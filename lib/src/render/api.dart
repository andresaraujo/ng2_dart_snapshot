library angular2.src.render.api;

import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, RegExpWrapper;
import "package:angular2/src/facade/async.dart" show Future;
import "package:angular2/src/facade/collection.dart"
    show List, Map, MapWrapper, Map, StringMapWrapper;
import "package:angular2/src/change_detection/change_detection.dart"
    show ASTWithSource;

/**
 * General notes:
 *
 * The methods for creating / destroying views in this API are used in the AppViewHydrator
 * and RenderViewHydrator as well.
 *
 * We are already parsing expressions on the render side:
 * - this makes the ElementBinders more compact
 *   (e.g. no need to distinguish interpolations from regular expressions from literals)
 * - allows to retrieve which properties should be accessed from the event
 *   by looking at the expression
 * - we need the parse at least for the `template` attribute to match
 *   directives in it
 * - render compiler is not on the critical path as
 *   its output will be stored in precompiled templates.
 */
class EventBinding {
  String fullName;
  ASTWithSource source;
  EventBinding(this.fullName, this.source) {}
}
enum PropertyBindingType { PROPERTY, ATTRIBUTE, CLASS, STYLE }
class ElementPropertyBinding {
  PropertyBindingType type;
  ASTWithSource astWithSource;
  String property;
  String unit;
  ElementPropertyBinding(this.type, this.astWithSource, this.property,
      [this.unit = null]) {}
}
class ElementBinder {
  num index;
  num parentIndex;
  num distanceToParent;
  List<DirectiveBinder> directives;
  ProtoViewDto nestedProtoView;
  List<ElementPropertyBinding> propertyBindings;
  Map<String, String> variableBindings;
  // Note: this contains a preprocessed AST

  // that replaced the values that should be extracted from the element

  // with a local name
  List<EventBinding> eventBindings;
  Map<String, String> readAttributes;
  ElementBinder({index, parentIndex, distanceToParent, directives,
      nestedProtoView, propertyBindings, variableBindings, eventBindings,
      readAttributes}) {
    this.index = index;
    this.parentIndex = parentIndex;
    this.distanceToParent = distanceToParent;
    this.directives = directives;
    this.nestedProtoView = nestedProtoView;
    this.propertyBindings = propertyBindings;
    this.variableBindings = variableBindings;
    this.eventBindings = eventBindings;
    this.readAttributes = readAttributes;
  }
}
class DirectiveBinder {
  // Index into the array of directives in the View instance
  num directiveIndex;
  Map<String, ASTWithSource> propertyBindings;
  // Note: this contains a preprocessed AST

  // that replaced the values that should be extracted from the element

  // with a local name
  List<EventBinding> eventBindings;
  List<ElementPropertyBinding> hostPropertyBindings;
  DirectiveBinder(
      {directiveIndex, propertyBindings, eventBindings, hostPropertyBindings}) {
    this.directiveIndex = directiveIndex;
    this.propertyBindings = propertyBindings;
    this.eventBindings = eventBindings;
    this.hostPropertyBindings = hostPropertyBindings;
  }
}
enum ViewType {
  // A view that contains the host element with bound component directive.

  // Contains a COMPONENT view
  HOST,
  // The view of the component

  // Can contain 0 to n EMBEDDED views
  COMPONENT,
  // A view that is embedded into another View via a <template> element

  // inside of a COMPONENT view
  EMBEDDED
}
class ProtoViewDto {
  RenderProtoViewRef render;
  List<ElementBinder> elementBinders;
  Map<String, String> variableBindings;
  ViewType type;
  List<ASTWithSource> textBindings;
  num transitiveNgContentCount;
  ProtoViewDto({render, elementBinders, variableBindings, type, textBindings,
      transitiveNgContentCount}) {
    this.render = render;
    this.elementBinders = elementBinders;
    this.variableBindings = variableBindings;
    this.type = type;
    this.textBindings = textBindings;
    this.transitiveNgContentCount = transitiveNgContentCount;
  }
}
class DirectiveMetadata {
  static get DIRECTIVE_TYPE {
    return 0;
  }
  static get COMPONENT_TYPE {
    return 1;
  }
  dynamic id;
  String selector;
  bool compileChildren;
  List<String> events;
  List<String> properties;
  List<String> readAttributes;
  num type;
  bool callOnDestroy;
  bool callOnChange;
  bool callOnCheck;
  bool callOnInit;
  bool callOnAllChangesDone;
  String changeDetection;
  String exportAs;
  Map<String, String> hostListeners;
  Map<String, String> hostProperties;
  Map<String, String> hostAttributes;
  Map<String, String> hostActions;
  // group 1: "property" from "[property]"

  // group 2: "event" from "(event)"

  // group 3: "action" from "@action"
  static var _hostRegExp =
      new RegExp(r'^(?:(?:\[([^\]]+)\])|(?:\(([^\)]+)\))|(?:@(.+)))$');
  DirectiveMetadata({id, selector, compileChildren, events, hostListeners,
      hostProperties, hostAttributes, hostActions, properties, readAttributes,
      type, callOnDestroy, callOnChange, callOnCheck, callOnInit,
      callOnAllChangesDone, changeDetection, exportAs}) {
    this.id = id;
    this.selector = selector;
    this.compileChildren = isPresent(compileChildren) ? compileChildren : true;
    this.events = events;
    this.hostListeners = hostListeners;
    this.hostAttributes = hostAttributes;
    this.hostProperties = hostProperties;
    this.hostActions = hostActions;
    this.properties = properties;
    this.readAttributes = readAttributes;
    this.type = type;
    this.callOnDestroy = callOnDestroy;
    this.callOnChange = callOnChange;
    this.callOnCheck = callOnCheck;
    this.callOnInit = callOnInit;
    this.callOnAllChangesDone = callOnAllChangesDone;
    this.changeDetection = changeDetection;
    this.exportAs = exportAs;
  }
  static DirectiveMetadata create({id, selector, compileChildren, events, host,
      properties, readAttributes, type, callOnDestroy, callOnChange,
      callOnCheck, callOnInit, callOnAllChangesDone, changeDetection,
      exportAs}) {
    var hostListeners = new Map();
    var hostProperties = new Map();
    var hostAttributes = new Map();
    var hostActions = new Map();
    if (isPresent(host)) {
      MapWrapper.forEach(host, (String value, String key) {
        var matches =
            RegExpWrapper.firstMatch(DirectiveMetadata._hostRegExp, key);
        if (isBlank(matches)) {
          hostAttributes[key] = value;
        } else if (isPresent(matches[1])) {
          hostProperties[matches[1]] = value;
        } else if (isPresent(matches[2])) {
          hostListeners[matches[2]] = value;
        } else if (isPresent(matches[3])) {
          hostActions[matches[3]] = value;
        }
      });
    }
    return new DirectiveMetadata(
        id: id,
        selector: selector,
        compileChildren: compileChildren,
        events: events,
        hostListeners: hostListeners,
        hostProperties: hostProperties,
        hostAttributes: hostAttributes,
        hostActions: hostActions,
        properties: properties,
        readAttributes: readAttributes,
        type: type,
        callOnDestroy: callOnDestroy,
        callOnChange: callOnChange,
        callOnCheck: callOnCheck,
        callOnInit: callOnInit,
        callOnAllChangesDone: callOnAllChangesDone,
        changeDetection: changeDetection,
        exportAs: exportAs);
  }
}
// An opaque reference to a render proto ivew
class RenderProtoViewRef {}
// An opaque reference to a part of a view
class RenderFragmentRef {}
// An opaque reference to a view
class RenderViewRef {}
/**
 * How the template and styles of a view should be encapsulated.
 */
enum ViewEncapsulation {
  /**
   * Emulate scoping of styles by preprocessing the style rules
   * and adding additional attributes to elements. This is the default.
   */
  EMULATED,
  /**
   * Uses the native mechanism of the renderer. For the DOM this means creating a ShadowRoot.
   */
  NATIVE,
  /**
   * Don't scope the template nor the styles.
   */
  NONE
}
class ViewDefinition {
  String componentId;
  String templateAbsUrl;
  String template;
  List<DirectiveMetadata> directives;
  List<String> styleAbsUrls;
  List<String> styles;
  ViewEncapsulation encapsulation;
  ViewDefinition({componentId, templateAbsUrl, template, styleAbsUrls, styles,
      directives, encapsulation}) {
    this.componentId = componentId;
    this.templateAbsUrl = templateAbsUrl;
    this.template = template;
    this.styleAbsUrls = styleAbsUrls;
    this.styles = styles;
    this.directives = directives;
    this.encapsulation =
        isPresent(encapsulation) ? encapsulation : ViewEncapsulation.EMULATED;
  }
}
class RenderProtoViewMergeMapping {
  RenderProtoViewRef mergedProtoViewRef;
  num fragmentCount;
  List<num> mappedElementIndices;
  num mappedElementCount;
  List<num> mappedTextIndices;
  List<num> hostElementIndicesByViewIndex;
  List<num> nestedViewCountByViewIndex;
  RenderProtoViewMergeMapping(this.mergedProtoViewRef,
      // Number of fragments in the merged ProtoView.

      // Fragments are stored in depth first order of nested ProtoViews.
      this.fragmentCount,
      // Mapping from app element index to render element index.

      // Mappings of nested ProtoViews are in depth first order, with all

      // indices for one ProtoView in a consecuitve block.
      this.mappedElementIndices,
      // Number of bound render element.

      // Note: This could be more than the original ones

      // as we might have bound a new element for projecting bound text nodes.
      this.mappedElementCount,
      // Mapping from app text index to render text index.

      // Mappings of nested ProtoViews are in depth first order, with all

      // indices for one ProtoView in a consecuitve block.
      this.mappedTextIndices,
      // Mapping from view index to app element index
      this.hostElementIndicesByViewIndex,
      // Number of contained views by view index
      this.nestedViewCountByViewIndex) {}
}
class RenderCompiler {
  /**
   * Creats a ProtoViewDto that contains a single nested component with the given componentId.
   */
  Future<ProtoViewDto> compileHost(DirectiveMetadata directiveMetadata) {
    return null;
  }
  /**
   * Compiles a single DomProtoView. Non recursive so that
   * we don't need to serialize all possible components over the wire,
   * but only the needed ones based on previous calls.
   */
  Future<ProtoViewDto> compile(ViewDefinition view) {
    return null;
  }
  /**
   * Merges ProtoViews.
   * The first entry of the array is the protoview into which all the other entries of the array
   * should be merged.
   * If the array contains other arrays, they will be merged before processing the parent array.
   * The array must contain an entry for every component and embedded ProtoView of the first entry.
   * @param protoViewRefs List of ProtoViewRefs or nested
   * @return the merge result
   */
  Future<RenderProtoViewMergeMapping> mergeProtoViewsRecursively(
      List<dynamic /* RenderProtoViewRef | List < dynamic > */ > protoViewRefs) {
    return null;
  }
}
class RenderViewWithFragments {
  RenderViewRef viewRef;
  List<RenderFragmentRef> fragmentRefs;
  RenderViewWithFragments(this.viewRef, this.fragmentRefs) {}
}
/**
 * Abstract reference to the element which can be marshaled across web-worker boundary.
 *
 * This interface is used by the Renderer API.
 */
abstract class RenderElementRef {
  /**
   * Reference to the `RenderViewRef` where the `RenderElementRef` is inside of.
   */
  RenderViewRef renderView;
  /**
   * Index of the element inside the `RenderViewRef`.
   *
   * This is used internally by the Angular framework to locate elements.
   */
  num renderBoundElementIndex;
}
class Renderer {
  /**
   * Creates a root host view that includes the given element.
   * Note that the fragmentCount needs to be passed in so that we can create a result
   * synchronously even when dealing with webworkers!
   *
   * @param {RenderProtoViewRef} hostProtoViewRef a RenderProtoViewRef of type
   * ProtoViewDto.HOST_VIEW_TYPE
   * @param {any} hostElementSelector css selector for the host element (will be queried against the
   * main document)
   * @return {RenderViewWithFragments} the created view including fragments
   */
  RenderViewWithFragments createRootHostView(
      RenderProtoViewRef hostProtoViewRef, num fragmentCount,
      String hostElementSelector) {
    return null;
  }
  /**
   * Creates a regular view out of the given ProtoView.
   * Note that the fragmentCount needs to be passed in so that we can create a result
   * synchronously even when dealing with webworkers!
   */
  RenderViewWithFragments createView(
      RenderProtoViewRef protoViewRef, num fragmentCount) {
    return null;
  }
  /**
   * Destroys the given view after it has been dehydrated and detached
   */
  destroyView(RenderViewRef viewRef) {}
  /**
   * Attaches a fragment after another fragment.
   */
  attachFragmentAfterFragment(
      RenderFragmentRef previousFragmentRef, RenderFragmentRef fragmentRef) {}
  /**
   * Attaches a fragment after an element.
   */
  attachFragmentAfterElement(
      RenderElementRef elementRef, RenderFragmentRef fragmentRef) {}
  /**
   * Detaches a fragment.
   */
  detachFragment(RenderFragmentRef fragmentRef) {}
  /**
   * Hydrates a view after it has been attached. Hydration/dehydration is used for reusing views
   * inside of the view pool.
   */
  hydrateView(RenderViewRef viewRef) {}
  /**
   * Dehydrates a view after it has been attached. Hydration/dehydration is used for reusing views
   * inside of the view pool.
   */
  dehydrateView(RenderViewRef viewRef) {}
  /**
   * Returns the native element at the given location.
   * Attention: In a WebWorker scenario, this should always return null!
   */
  dynamic getNativeElementSync(RenderElementRef location) {
    return null;
  }
  /**
   * Sets a property on an element.
   */
  setElementProperty(
      RenderElementRef location, String propertyName, dynamic propertyValue) {}
  /**
   * Sets an attribute on an element.
   */
  setElementAttribute(
      RenderElementRef location, String attributeName, String attributeValue) {}
  /**
   * Sets a class on an element.
   */
  setElementClass(RenderElementRef location, String className, bool isAdd) {}
  /**
   * Sets a style on an element.
   */
  setElementStyle(
      RenderElementRef location, String styleName, String styleValue) {}
  /**
   * Calls a method on an element.
   */
  invokeElementMethod(
      RenderElementRef location, String methodName, List<dynamic> args) {}
  /**
   * Sets the value of a text node.
   */
  setText(RenderViewRef viewRef, num textNodeIndex, String text) {}
  /**
   * Sets the dispatcher for all events of the given view
   */
  setEventDispatcher(RenderViewRef viewRef, RenderEventDispatcher dispatcher) {}
}
/**
 * A dispatcher for all events happening in a view.
 */
abstract class RenderEventDispatcher {
  /**
   * Called when an event was triggered for a on-* attribute on an element.
   * @param {Map<string, any>} locals Locals to be used to evaluate the
   *   event expressions
   */
  dispatchRenderEvent(
      num elementIndex, String eventName, Map<String, dynamic> locals);
}
