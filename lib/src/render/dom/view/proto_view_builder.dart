library angular2.src.render.dom.view.proto_view_builder;

import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, BaseException, StringWrapper;
import "package:angular2/src/facade/collection.dart"
    show ListWrapper, MapWrapper, Set, SetWrapper, List, StringMapWrapper;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/change_detection.dart"
    show
        ASTWithSource,
        AST,
        AstTransformer,
        AccessMember,
        LiteralArray,
        ImplicitReceiver;
import "proto_view.dart"
    show DomProtoView, DomProtoViewRef, resolveInternalDomProtoView;
import "element_binder.dart" show ElementBinder, Event, HostAction;
import "../../api.dart" as api;
import "../util.dart" show NG_BINDING_CLASS, EVENT_TARGET_SEPARATOR;

class ProtoViewBuilder {
  var rootElement;
  api.ViewType type;
  Map<String, String> variableBindings = new Map();
  List<ElementBinderBuilder> elements = [];
  ProtoViewBuilder(this.rootElement, this.type) {}
  ElementBinderBuilder bindElement(element, [description = null]) {
    var builder =
        new ElementBinderBuilder(this.elements.length, element, description);
    this.elements.add(builder);
    DOM.addClass(element, NG_BINDING_CLASS);
    return builder;
  }
  bindVariable(name, value) {
    // Store the variable map from value to variable, reflecting how it will be used later by

    // DomView. When a local is set to the view, a lookup for the variable name will take place

    // keyed

    // by the "value", or exported identifier. For example, ng-for sets a view local of "index".

    // When this occurs, a lookup keyed by "index" must occur to find if there is a var referencing

    // it.
    this.variableBindings[value] = name;
  }
  api.ProtoViewDto build() {
    var renderElementBinders = [];
    var apiElementBinders = [];
    var transitiveContentTagCount = 0;
    var boundTextNodeCount = 0;
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
            hostPropertyBindings: buildElementPropertyBindings(ebb.element,
                isPresent(ebb.componentId), dbb.hostPropertyBindings,
                directiveTemplatePropertyNames));
      });
      var nestedProtoView =
          isPresent(ebb.nestedProtoView) ? ebb.nestedProtoView.build() : null;
      var nestedRenderProtoView = isPresent(nestedProtoView)
          ? resolveInternalDomProtoView(nestedProtoView.render)
          : null;
      if (isPresent(nestedRenderProtoView)) {
        transitiveContentTagCount +=
            nestedRenderProtoView.transitiveContentTagCount;
      }
      if (isPresent(ebb.contentTagSelector)) {
        transitiveContentTagCount++;
      }
      var parentIndex = isPresent(ebb.parent) ? ebb.parent.index : -1;
      apiElementBinders.add(new api.ElementBinder(
          index: ebb.index,
          parentIndex: parentIndex,
          distanceToParent: ebb.distanceToParent,
          directives: apiDirectiveBinders,
          nestedProtoView: nestedProtoView,
          propertyBindings: buildElementPropertyBindings(ebb.element,
              isPresent(ebb.componentId), ebb.propertyBindings,
              directiveTemplatePropertyNames),
          variableBindings: ebb.variableBindings,
          eventBindings: ebb.eventBindings,
          textBindings: ebb.textBindings,
          readAttributes: ebb.readAttributes));
      var childNodeInfo =
          this._analyzeChildNodes(ebb.element, ebb.textBindingNodes);
      boundTextNodeCount += ebb.textBindingNodes.length;
      renderElementBinders.add(new ElementBinder(
          textNodeIndices: childNodeInfo.boundTextNodeIndices,
          contentTagSelector: ebb.contentTagSelector,
          parentIndex: parentIndex,
          distanceToParent: ebb.distanceToParent,
          nestedProtoView: isPresent(nestedProtoView)
              ? resolveInternalDomProtoView(nestedProtoView.render)
              : null,
          componentId: ebb.componentId,
          eventLocals: new LiteralArray(ebb.eventBuilder.buildEventLocals()),
          localEvents: ebb.eventBuilder.buildLocalEvents(),
          globalEvents: ebb.eventBuilder.buildGlobalEvents(),
          elementIsEmpty: childNodeInfo.elementIsEmpty));
    });
    return new api.ProtoViewDto(
        render: new DomProtoViewRef(new DomProtoView(
            element: this.rootElement,
            elementBinders: renderElementBinders,
            transitiveContentTagCount: transitiveContentTagCount,
            boundTextNodeCount: boundTextNodeCount)),
        type: this.type,
        elementBinders: apiElementBinders,
        variableBindings: this.variableBindings);
  }
  // Note: We need to calculate the next node indices not until the compilation is complete,

  // as the compiler might change the order of elements.
  _ChildNodesInfo _analyzeChildNodes(
      dynamic parentElement, List<dynamic> boundTextNodes) {
    var childNodes = DOM.childNodes(DOM.templateAwareRoot(parentElement));
    var boundTextNodeIndices = [];
    var indexInBoundTextNodes = 0;
    var elementIsEmpty = true;
    for (var i = 0; i < childNodes.length; i++) {
      var node = childNodes[i];
      if (indexInBoundTextNodes < boundTextNodes.length &&
          identical(node, boundTextNodes[indexInBoundTextNodes])) {
        boundTextNodeIndices.add(i);
        indexInBoundTextNodes++;
        elementIsEmpty = false;
      } else if ((DOM.isTextNode(node) &&
              DOM.getText(node).trim().length > 0) ||
          (DOM.isElementNode(node))) {
        elementIsEmpty = false;
      }
    }
    return new _ChildNodesInfo(boundTextNodeIndices, elementIsEmpty);
  }
}
class _ChildNodesInfo {
  List<num> boundTextNodeIndices;
  bool elementIsEmpty;
  _ChildNodesInfo(this.boundTextNodeIndices, this.elementIsEmpty) {}
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
  Set<String> propertyBindingsToDirectives = new Set();
  List<api.EventBinding> eventBindings = [];
  EventBuilder eventBuilder = new EventBuilder();
  List<dynamic> textBindingNodes = [];
  List<ASTWithSource> textBindings = [];
  String contentTagSelector = null;
  Map<String, String> readAttributes = new Map();
  String componentId = null;
  ElementBinderBuilder(this.index, this.element, String description) {}
  ElementBinderBuilder setParent(
      ElementBinderBuilder parent, distanceToParent) {
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
  ProtoViewBuilder bindNestedProtoView(rootElement) {
    if (isPresent(this.nestedProtoView)) {
      throw new BaseException("Only one nested view per element is allowed");
    }
    this.nestedProtoView =
        new ProtoViewBuilder(rootElement, api.ViewType.EMBEDDED);
    return this.nestedProtoView;
  }
  bindProperty(String name, ASTWithSource expression) {
    this.propertyBindings[name] = expression;
  }
  bindPropertyToDirective(String name) {
    // we are filling in a set of property names that are bound to a property

    // of at least one directive. This allows us to report "dangling" bindings.
    this.propertyBindingsToDirectives.add(name);
  }
  bindVariable(name, value) {
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
  bindEvent(name, expression, [target = null]) {
    this.eventBindings.add(this.eventBuilder.add(name, expression, target));
  }
  bindText(textNode, expression) {
    this.textBindingNodes.add(textNode);
    this.textBindings.add(expression);
  }
  setContentTagSelector(String value) {
    this.contentTagSelector = value;
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
  bindEvent(name, expression, [target = null]) {
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
    dynamic protoElement, bool isNgComponent,
    Map<String, ASTWithSource> bindingsInTemplate,
    Set<String> directiveTempaltePropertyNames) {
  var propertyBindings = [];
  MapWrapper.forEach(bindingsInTemplate, (ast, propertyNameInTemplate) {
    var propertyBinding =
        createElementPropertyBinding(ast, propertyNameInTemplate);
    if (isValidElementPropertyBinding(
        protoElement, isNgComponent, propertyBinding)) {
      propertyBindings.add(propertyBinding);
    } else if (!SetWrapper.has(
        directiveTempaltePropertyNames, propertyNameInTemplate)) {
      throw new BaseException(
          '''Can\'t bind to \'${ propertyNameInTemplate}\' since it isn\'t a know property of the \'${ DOM . tagName ( protoElement ) . toLowerCase ( )}\' element and there are no matching directives with a corresponding property''');
    }
  });
  return propertyBindings;
}
bool isValidElementPropertyBinding(dynamic protoElement, bool isNgComponent,
    api.ElementPropertyBinding binding) {
  if (identical(binding.type, api.PropertyBindingType.PROPERTY)) {
    var tagName = DOM.tagName(protoElement);
    var possibleCustomElement = !identical(tagName.indexOf("-"), -1);
    if (possibleCustomElement && !isNgComponent) {
      // can't tell now as we don't know which properties a custom element will get

      // once it is instantiated
      return true;
    } else {
      return DOM.hasProperty(protoElement, binding.property);
    }
  }
  return true;
}
api.ElementPropertyBinding createElementPropertyBinding(
    ASTWithSource ast, String propertyNameInTemplate) {
  var parts =
      StringWrapper.split(propertyNameInTemplate, PROPERTY_PARTS_SEPARATOR);
  if (identical(parts.length, 1)) {
    var propName = parts[0];
    var mappedPropName = StringMapWrapper.get(DOM.attrToPropMap, propName);
    propName = isPresent(mappedPropName) ? mappedPropName : propName;
    return new api.ElementPropertyBinding(
        api.PropertyBindingType.PROPERTY, ast, propName);
  } else if (parts[0] == ATTRIBUTE_PREFIX) {
    return new api.ElementPropertyBinding(
        api.PropertyBindingType.ATTRIBUTE, ast, parts[1]);
  } else if (parts[0] == CLASS_PREFIX) {
    return new api.ElementPropertyBinding(
        api.PropertyBindingType.CLASS, ast, parts[1]);
  } else if (parts[0] == STYLE_PREFIX) {
    var unit = parts.length > 2 ? parts[2] : null;
    return new api.ElementPropertyBinding(
        api.PropertyBindingType.STYLE, ast, parts[1], unit);
  } else {
    throw new BaseException(
        '''Invalid property name ${ propertyNameInTemplate}''');
  }
}
