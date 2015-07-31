library angular2.src.render.dom.view.proto_view_builder;

import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, BaseException, StringWrapper;
import "package:angular2/src/facade/collection.dart"
    show ListWrapper, MapWrapper, Set, SetWrapper, List, StringMapWrapper;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/change_detection/change_detection.dart"
    show
        ASTWithSource,
        AST,
        AstTransformer,
        AccessMember,
        LiteralArray,
        ImplicitReceiver;
import "proto_view.dart"
    show DomProtoView, DomProtoViewRef, resolveInternalDomProtoView;
import "element_binder.dart" show DomElementBinder, Event, HostAction;
import "../schema/element_schema_registry.dart" show ElementSchemaRegistry;
import "../template_cloner.dart" show TemplateCloner;
import "../../api.dart" as api;
import "../util.dart"
    show
        NG_BINDING_CLASS,
        EVENT_TARGET_SEPARATOR,
        queryBoundTextNodeIndices,
        camelCaseToDashCase;

class ProtoViewBuilder {
  var rootElement;
  api.ViewType type;
  api.ViewEncapsulation viewEncapsulation;
  Map<String, String> variableBindings = new Map();
  List<ElementBinderBuilder> elements = [];
  Map<dynamic, ASTWithSource> rootTextBindings = new Map();
  num ngContentCount = 0;
  Map<String, String> hostAttributes = new Map();
  ProtoViewBuilder(this.rootElement, this.type, this.viewEncapsulation) {}
  ElementBinderBuilder bindElement(dynamic element,
      [String description = null]) {
    var builder =
        new ElementBinderBuilder(this.elements.length, element, description);
    this.elements.add(builder);
    DOM.addClass(element, NG_BINDING_CLASS);
    return builder;
  }
  bindVariable(String name, String value) {
    // Store the variable map from value to variable, reflecting how it will be used later by

    // DomView. When a local is set to the view, a lookup for the variable name will take place

    // keyed

    // by the "value", or exported identifier. For example, ng-for sets a view local of "index".

    // When this occurs, a lookup keyed by "index" must occur to find if there is a var referencing

    // it.
    this.variableBindings[value] = name;
  }
  // Note: We don't store the node index until the compilation is complete,

  // as the compiler might change the order of elements.
  bindRootText(dynamic textNode, ASTWithSource expression) {
    this.rootTextBindings[textNode] = expression;
  }
  bindNgContent() {
    this.ngContentCount++;
  }
  setHostAttribute(String name, String value) {
    this.hostAttributes[name] = value;
  }
  api.ProtoViewDto build(
      ElementSchemaRegistry schemaRegistry, TemplateCloner templateCloner) {
    var domElementBinders = [];
    var apiElementBinders = [];
    var textNodeExpressions = [];
    var rootTextNodeIndices = [];
    var transitiveNgContentCount = this.ngContentCount;
    queryBoundTextNodeIndices(DOM.content(this.rootElement),
        this.rootTextBindings, (node, nodeIndex, expression) {
      textNodeExpressions.add(expression);
      rootTextNodeIndices.add(nodeIndex);
    });
    ListWrapper.forEach(this.elements, (ElementBinderBuilder ebb) {
      var directiveTemplatePropertyNames = new Set();
      var apiDirectiveBinders = ListWrapper.map(ebb.directives,
          (DirectiveBuilder dbb) {
        ebb.eventBuilder.merge(dbb.eventBuilder);
        ListWrapper.forEach(dbb.templatePropertyNames,
            (name) => directiveTemplatePropertyNames.add(name));
        return new api.DirectiveBinder(
            directiveIndex: dbb.directiveIndex,
            propertyBindings: dbb.propertyBindings,
            eventBindings: dbb.eventBindings,
            hostPropertyBindings: buildElementPropertyBindings(schemaRegistry,
                ebb.element, true, dbb.hostPropertyBindings, null));
      });
      var nestedProtoView = isPresent(ebb.nestedProtoView)
          ? ebb.nestedProtoView.build(schemaRegistry, templateCloner)
          : null;
      if (isPresent(nestedProtoView)) {
        transitiveNgContentCount += nestedProtoView.transitiveNgContentCount;
      }
      var parentIndex = isPresent(ebb.parent) ? ebb.parent.index : -1;
      var textNodeIndices = [];
      queryBoundTextNodeIndices(ebb.element, ebb.textBindings,
          (node, nodeIndex, expression) {
        textNodeExpressions.add(expression);
        textNodeIndices.add(nodeIndex);
      });
      apiElementBinders.add(new api.ElementBinder(
          index: ebb.index,
          parentIndex: parentIndex,
          distanceToParent: ebb.distanceToParent,
          directives: apiDirectiveBinders,
          nestedProtoView: nestedProtoView,
          propertyBindings: buildElementPropertyBindings(schemaRegistry,
              ebb.element, isPresent(ebb.componentId), ebb.propertyBindings,
              directiveTemplatePropertyNames),
          variableBindings: ebb.variableBindings,
          eventBindings: ebb.eventBindings,
          readAttributes: ebb.readAttributes));
      domElementBinders.add(new DomElementBinder(
          textNodeIndices: textNodeIndices,
          hasNestedProtoView: isPresent(nestedProtoView) ||
              isPresent(ebb.componentId),
          hasNativeShadowRoot: false,
          eventLocals: new LiteralArray(ebb.eventBuilder.buildEventLocals()),
          localEvents: ebb.eventBuilder.buildLocalEvents(),
          globalEvents: ebb.eventBuilder.buildGlobalEvents()));
    });
    var rootNodeCount = DOM.childNodes(DOM.content(this.rootElement)).length;
    return new api.ProtoViewDto(
        render: new DomProtoViewRef(DomProtoView.create(templateCloner,
            this.type, this.rootElement, this.viewEncapsulation,
            [rootNodeCount], rootTextNodeIndices, domElementBinders,
            this.hostAttributes)),
        type: this.type,
        elementBinders: apiElementBinders,
        variableBindings: this.variableBindings,
        textBindings: textNodeExpressions,
        transitiveNgContentCount: transitiveNgContentCount);
  }
}
class ElementBinderBuilder {
  num index;
  var element;
  ElementBinderBuilder parent = null;
  num distanceToParent = 0;
  List<DirectiveBuilder> directives = [];
  ProtoViewBuilder nestedProtoView = null;
  Map<String, ASTWithSource> propertyBindings = new Map();
  Map<String, String> variableBindings = new Map();
  List<api.EventBinding> eventBindings = [];
  EventBuilder eventBuilder = new EventBuilder();
  Map<dynamic, ASTWithSource> textBindings = new Map();
  Map<String, String> readAttributes = new Map();
  String componentId = null;
  ElementBinderBuilder(this.index, this.element, String description) {}
  ElementBinderBuilder setParent(
      ElementBinderBuilder parent, num distanceToParent) {
    this.parent = parent;
    if (isPresent(parent)) {
      this.distanceToParent = distanceToParent;
    }
    return this;
  }
  readAttribute(String attrName) {
    if (isBlank(this.readAttributes[attrName])) {
      this.readAttributes[attrName] = DOM.getAttribute(this.element, attrName);
    }
  }
  DirectiveBuilder bindDirective(num directiveIndex) {
    var directive = new DirectiveBuilder(directiveIndex);
    this.directives.add(directive);
    return directive;
  }
  ProtoViewBuilder bindNestedProtoView(dynamic rootElement) {
    if (isPresent(this.nestedProtoView)) {
      throw new BaseException("Only one nested view per element is allowed");
    }
    this.nestedProtoView = new ProtoViewBuilder(
        rootElement, api.ViewType.EMBEDDED, api.ViewEncapsulation.NONE);
    return this.nestedProtoView;
  }
  bindProperty(String name, ASTWithSource expression) {
    this.propertyBindings[name] = expression;
  }
  bindVariable(String name, String value) {
    // When current is a view root, the variable bindings are set to the *nested* proto view.

    // The root view conceptually signifies a new "block scope" (the nested view), to which

    // the variables are bound.
    if (isPresent(this.nestedProtoView)) {
      this.nestedProtoView.bindVariable(name, value);
    } else {
      // Store the variable map from value to variable, reflecting how it will be used later by

      // DomView. When a local is set to the view, a lookup for the variable name will take place

      // keyed

      // by the "value", or exported identifier. For example, ng-for sets a view local of "index".

      // When this occurs, a lookup keyed by "index" must occur to find if there is a var

      // referencing

      // it.
      this.variableBindings[value] = name;
    }
  }
  bindEvent(String name, ASTWithSource expression, [String target = null]) {
    this.eventBindings.add(this.eventBuilder.add(name, expression, target));
  }
  // Note: We don't store the node index until the compilation is complete,

  // as the compiler might change the order of elements.
  bindText(dynamic textNode, ASTWithSource expression) {
    this.textBindings[textNode] = expression;
  }
  setComponentId(String componentId) {
    this.componentId = componentId;
  }
}
class DirectiveBuilder {
  num directiveIndex;
  // mapping from directive property name to AST for that directive
  Map<String, ASTWithSource> propertyBindings = new Map();
  // property names used in the template
  List<String> templatePropertyNames = [];
  Map<String, ASTWithSource> hostPropertyBindings = new Map();
  List<api.EventBinding> eventBindings = [];
  EventBuilder eventBuilder = new EventBuilder();
  DirectiveBuilder(this.directiveIndex) {}
  bindProperty(String name, ASTWithSource expression, String elProp) {
    this.propertyBindings[name] = expression;
    if (isPresent(elProp)) {
      // we are filling in a set of property names that are bound to a property

      // of at least one directive. This allows us to report "dangling" bindings.
      this.templatePropertyNames.add(elProp);
    }
  }
  bindHostProperty(String name, ASTWithSource expression) {
    this.hostPropertyBindings[name] = expression;
  }
  bindEvent(String name, ASTWithSource expression, [String target = null]) {
    this.eventBindings.add(this.eventBuilder.add(name, expression, target));
  }
}
class EventBuilder extends AstTransformer {
  List<AST> locals = [];
  List<Event> localEvents = [];
  List<Event> globalEvents = [];
  AST _implicitReceiver = new ImplicitReceiver();
  EventBuilder() : super() {
    /* super call moved to initializer */;
  }
  api.EventBinding add(String name, ASTWithSource source, String target) {
    // TODO(tbosch): reenable this when we are parsing element properties

    // out of action expressions

    // var adjustedAst = astWithSource.ast.visit(this);
    var adjustedAst = source.ast;
    var fullName =
        isPresent(target) ? target + EVENT_TARGET_SEPARATOR + name : name;
    var result = new api.EventBinding(fullName,
        new ASTWithSource(adjustedAst, source.source, source.location));
    var event = new Event(name, target, fullName);
    if (isBlank(target)) {
      this.localEvents.add(event);
    } else {
      this.globalEvents.add(event);
    }
    return result;
  }
  AccessMember visitAccessMember(AccessMember ast) {
    var isEventAccess = false;
    AST current = ast;
    while (!isEventAccess && (current is AccessMember)) {
      var am = (current as AccessMember);
      if (am.name == "\$event") {
        isEventAccess = true;
      }
      current = am.receiver;
    }
    if (isEventAccess) {
      this.locals.add(ast);
      var index = this.locals.length - 1;
      return new AccessMember(
          this._implicitReceiver, '''${ index}''', (arr) => arr[index], null);
    } else {
      return ast;
    }
  }
  List<AST> buildEventLocals() {
    return this.locals;
  }
  List<Event> buildLocalEvents() {
    return this.localEvents;
  }
  List<Event> buildGlobalEvents() {
    return this.globalEvents;
  }
  merge(EventBuilder eventBuilder) {
    this._merge(this.localEvents, eventBuilder.localEvents);
    this._merge(this.globalEvents, eventBuilder.globalEvents);
    ListWrapper.concat(this.locals, eventBuilder.locals);
  }
  _merge(List<Event> host, List<Event> tobeAdded) {
    var names = [];
    for (var i = 0; i < host.length; i++) {
      names.add(host[i].fullName);
    }
    for (var j = 0; j < tobeAdded.length; j++) {
      if (!ListWrapper.contains(names, tobeAdded[j].fullName)) {
        host.add(tobeAdded[j]);
      }
    }
  }
}
var PROPERTY_PARTS_SEPARATOR = new RegExp("\\.");
const ATTRIBUTE_PREFIX = "attr";
const CLASS_PREFIX = "class";
const STYLE_PREFIX = "style";
List<api.ElementPropertyBinding> buildElementPropertyBindings(
    ElementSchemaRegistry schemaRegistry, dynamic protoElement,
    bool isNgComponent, Map<String, ASTWithSource> bindingsInTemplate,
    Set<String> directiveTemplatePropertyNames) {
  var propertyBindings = [];
  MapWrapper.forEach(bindingsInTemplate, (ast, propertyNameInTemplate) {
    var propertyBinding = createElementPropertyBinding(
        schemaRegistry, ast, propertyNameInTemplate);
    if (isPresent(directiveTemplatePropertyNames) &&
        SetWrapper.has(
            directiveTemplatePropertyNames, propertyNameInTemplate)) {
    } else if (isValidElementPropertyBinding(
        schemaRegistry, protoElement, isNgComponent, propertyBinding)) {
      propertyBindings.add(propertyBinding);
    } else {
      var exMsg =
          '''Can\'t bind to \'${ propertyNameInTemplate}\' since it isn\'t a known property of the \'<${ DOM . tagName ( protoElement ) . toLowerCase ( )}>\' element''';
      // directiveTemplatePropertyNames is null for host property bindings
      if (isPresent(directiveTemplatePropertyNames)) {
        exMsg +=
            " and there are no matching directives with a corresponding property";
      }
      throw new BaseException(exMsg);
    }
  });
  return propertyBindings;
}
bool isValidElementPropertyBinding(ElementSchemaRegistry schemaRegistry,
    dynamic protoElement, bool isNgComponent,
    api.ElementPropertyBinding binding) {
  if (identical(binding.type, api.PropertyBindingType.PROPERTY)) {
    if (!isNgComponent) {
      return schemaRegistry.hasProperty(protoElement, binding.property);
    } else {
      // TODO(pk): change this logic as soon as we can properly detect custom elements
      return DOM.hasProperty(protoElement, binding.property);
    }
  }
  return true;
}
api.ElementPropertyBinding createElementPropertyBinding(
    ElementSchemaRegistry schemaRegistry, ASTWithSource ast,
    String propertyNameInTemplate) {
  var parts =
      StringWrapper.split(propertyNameInTemplate, PROPERTY_PARTS_SEPARATOR);
  if (identical(parts.length, 1)) {
    var propName = schemaRegistry.getMappedPropName(parts[0]);
    return new api.ElementPropertyBinding(
        api.PropertyBindingType.PROPERTY, ast, propName);
  } else if (parts[0] == ATTRIBUTE_PREFIX) {
    return new api.ElementPropertyBinding(
        api.PropertyBindingType.ATTRIBUTE, ast, parts[1]);
  } else if (parts[0] == CLASS_PREFIX) {
    return new api.ElementPropertyBinding(
        api.PropertyBindingType.CLASS, ast, camelCaseToDashCase(parts[1]));
  } else if (parts[0] == STYLE_PREFIX) {
    var unit = parts.length > 2 ? parts[2] : null;
    return new api.ElementPropertyBinding(
        api.PropertyBindingType.STYLE, ast, parts[1], unit);
  } else {
    throw new BaseException(
        '''Invalid property name ${ propertyNameInTemplate}''');
  }
}
