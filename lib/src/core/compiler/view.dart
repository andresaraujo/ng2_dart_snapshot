library angular2.src.core.compiler.view;

import "package:angular2/src/facade/collection.dart"
    show ListWrapper, MapWrapper, Map, StringMapWrapper, List, Map;
import "package:angular2/src/change_detection/change_detection.dart"
    show
        AST,
        BindingRecord,
        ChangeDetector,
        ChangeDetectorRef,
        ChangeDispatcher,
        DirectiveIndex,
        DirectiveRecord,
        Locals,
        ProtoChangeDetector;
import "package:angular2/src/change_detection/interfaces.dart"
    show DebugContext;
import "element_injector.dart"
    show
        ProtoElementInjector,
        ElementInjector,
        PreBuiltObjects,
        DirectiveBinding;
import "element_binder.dart" show ElementBinder;
import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, BaseException;
import "package:angular2/src/render/api.dart" as renderApi;
import "package:angular2/src/render/api.dart" show RenderEventDispatcher;
import "view_ref.dart" show ViewRef, ProtoViewRef, internalView;
import "element_ref.dart" show ElementRef;
export "package:angular2/src/change_detection/interfaces.dart"
    show DebugContext;

class AppProtoViewMergeMapping {
  renderApi.RenderProtoViewRef renderProtoViewRef;
  num renderFragmentCount;
  List<num> renderElementIndices;
  List<num> renderInverseElementIndices;
  List<num> renderTextIndices;
  List<num> nestedViewIndicesByElementIndex;
  List<num> hostElementIndicesByViewIndex;
  List<num> nestedViewCountByViewIndex;
  AppProtoViewMergeMapping(
      renderApi.RenderProtoViewMergeMapping renderProtoViewMergeMapping) {
    this.renderProtoViewRef = renderProtoViewMergeMapping.mergedProtoViewRef;
    this.renderFragmentCount = renderProtoViewMergeMapping.fragmentCount;
    this.renderElementIndices =
        renderProtoViewMergeMapping.mappedElementIndices;
    this.renderInverseElementIndices = inverseIndexMapping(
        this.renderElementIndices,
        renderProtoViewMergeMapping.mappedElementCount);
    this.renderTextIndices = renderProtoViewMergeMapping.mappedTextIndices;
    this.hostElementIndicesByViewIndex =
        renderProtoViewMergeMapping.hostElementIndicesByViewIndex;
    this.nestedViewIndicesByElementIndex = inverseIndexMapping(
        this.hostElementIndicesByViewIndex, this.renderElementIndices.length);
    this.nestedViewCountByViewIndex =
        renderProtoViewMergeMapping.nestedViewCountByViewIndex;
  }
}
List<num> inverseIndexMapping(List<num> input, num resultLength) {
  var result = ListWrapper.createGrowableSize(resultLength);
  for (var i = 0; i < input.length; i++) {
    var value = input[i];
    if (isPresent(value)) {
      result[input[i]] = i;
    }
  }
  return result;
}
class AppViewContainer {
  // The order in this list matches the DOM order.
  List<AppView> views = [];
}
/**
 * Cost of making objects: http://jsperf.com/instantiate-size-of-object
 *
 */
class AppView implements ChangeDispatcher, RenderEventDispatcher {
  renderApi.Renderer renderer;
  AppProtoView proto;
  AppProtoViewMergeMapping mainMergeMapping;
  num viewOffset;
  num elementOffset;
  num textOffset;
  renderApi.RenderViewRef render;
  renderApi.RenderFragmentRef renderFragment;
  // AppViews that have been merged in depth first order.

  // This list is shared between all merged views. Use this.elementOffset to get the local

  // entries.
  List<AppView> views = null;
  // root elementInjectors of this AppView

  // This list is local to this AppView and not shared with other Views.
  List<ElementInjector> rootElementInjectors;
  // ElementInjectors of all AppViews in views grouped by view.

  // This list is shared between all merged views. Use this.elementOffset to get the local

  // entries.
  List<ElementInjector> elementInjectors = null;
  // ViewContainers of all AppViews in views grouped by view.

  // This list is shared between all merged views. Use this.elementOffset to get the local

  // entries.
  List<AppViewContainer> viewContainers = null;
  // PreBuiltObjects of all AppViews in views grouped by view.

  // This list is shared between all merged views. Use this.elementOffset to get the local

  // entries.
  List<PreBuiltObjects> preBuiltObjects = null;
  // ElementRef of all AppViews in views grouped by view.

  // This list is shared between all merged views. Use this.elementOffset to get the local

  // entries.
  List<ElementRef> elementRefs;
  ViewRef ref;
  ChangeDetector changeDetector = null;
  /**
   * The context against which data-binding expressions in this view are evaluated against.
   * This is always a component instance.
   */
  dynamic context = null;
  /**
   * Variables, local to this view, that can be used in binding expressions (in addition to the
   * context). This is used for thing like `<video #player>` or
   * `<li template="for #item of items">`, where "player" and "item" are locals, respectively.
   */
  Locals locals;
  AppView(this.renderer, this.proto, this.mainMergeMapping, this.viewOffset,
      this.elementOffset, this.textOffset, Map<String, dynamic> protoLocals,
      this.render, this.renderFragment) {
    this.ref = new ViewRef(this);
    this.locals = new Locals(null, MapWrapper.clone(protoLocals));
  }
  init(ChangeDetector changeDetector, List<ElementInjector> elementInjectors,
      List<ElementInjector> rootElementInjectors,
      List<PreBuiltObjects> preBuiltObjects, List<AppView> views,
      List<ElementRef> elementRefs, List<AppViewContainer> viewContainers) {
    this.changeDetector = changeDetector;
    this.elementInjectors = elementInjectors;
    this.rootElementInjectors = rootElementInjectors;
    this.preBuiltObjects = preBuiltObjects;
    this.views = views;
    this.elementRefs = elementRefs;
    this.viewContainers = viewContainers;
  }
  void setLocal(String contextName, dynamic value) {
    if (!this.hydrated()) throw new BaseException(
        "Cannot set locals on dehydrated view.");
    if (!this.proto.variableBindings.containsKey(contextName)) {
      return;
    }
    var templateName = this.proto.variableBindings[contextName];
    this.locals.set(templateName, value);
  }
  bool hydrated() {
    return isPresent(this.context);
  }
  /**
   * Triggers the event handlers for the element and the directives.
   *
   * This method is intended to be called from directive EventEmitters.
   *
   * @param {string} eventName
   * @param {*} eventObj
   * @param {int} boundElementIndex
   */
  void triggerEventHandlers(
      String eventName, dynamic eventObj, int boundElementIndex) {
    var locals = new Map();
    locals["\$event"] = eventObj;
    this.dispatchEvent(boundElementIndex, eventName, locals);
  }
  // dispatch to element injector or text nodes based on context
  void notifyOnBinding(BindingRecord b, dynamic currentValue) {
    if (b.isTextNode()) {
      this.renderer.setText(this.render,
          this.mainMergeMapping.renderTextIndices[
          b.elementIndex + this.textOffset], currentValue);
    } else {
      var elementRef = this.elementRefs[this.elementOffset + b.elementIndex];
      if (b.isElementProperty()) {
        this.renderer.setElementProperty(
            elementRef, b.propertyName, currentValue);
      } else if (b.isElementAttribute()) {
        this.renderer.setElementAttribute(
            elementRef, b.propertyName, currentValue);
      } else if (b.isElementClass()) {
        this.renderer.setElementClass(elementRef, b.propertyName, currentValue);
      } else if (b.isElementStyle()) {
        var unit = isPresent(b.propertyUnit) ? b.propertyUnit : "";
        this.renderer.setElementStyle(
            elementRef, b.propertyName, '''${ currentValue}${ unit}''');
      } else {
        throw new BaseException("Unsupported directive record");
      }
    }
  }
  void notifyOnAllChangesDone() {
    var eiCount = this.proto.elementBinders.length;
    var ei = this.elementInjectors;
    for (var i = eiCount - 1; i >= 0; i--) {
      if (isPresent(ei[i + this.elementOffset])) ei[i + this.elementOffset]
          .onAllChangesDone();
    }
  }
  dynamic getDirectiveFor(DirectiveIndex directive) {
    var elementInjector =
        this.elementInjectors[this.elementOffset + directive.elementIndex];
    return elementInjector.getDirectiveAtIndex(directive.directiveIndex);
  }
  AppView getNestedView(num boundElementIndex) {
    var viewIndex = this.mainMergeMapping.nestedViewIndicesByElementIndex[
        boundElementIndex];
    return isPresent(viewIndex) ? this.views[viewIndex] : null;
  }
  ElementRef getHostElement() {
    var boundElementIndex =
        this.mainMergeMapping.hostElementIndicesByViewIndex[this.viewOffset];
    return isPresent(boundElementIndex)
        ? this.elementRefs[boundElementIndex]
        : null;
  }
  DebugContext getDebugContext(
      num elementIndex, DirectiveIndex directiveIndex) {
    try {
      var offsettedIndex = this.elementOffset + elementIndex;
      var hasRefForIndex = offsettedIndex < this.elementRefs.length;
      var elementRef = hasRefForIndex
          ? this.elementRefs[this.elementOffset + elementIndex]
          : null;
      var host = this.getHostElement();
      var ei = hasRefForIndex
          ? this.elementInjectors[this.elementOffset + elementIndex]
          : null;
      var element = isPresent(elementRef) ? elementRef.nativeElement : null;
      var componentElement = isPresent(host) ? host.nativeElement : null;
      var directive = isPresent(directiveIndex)
          ? this.getDirectiveFor(directiveIndex)
          : null;
      var injector = isPresent(ei) ? ei.getInjector() : null;
      return new DebugContext(element, componentElement, directive,
          this.context, _localsToStringMap(this.locals), injector);
    } catch (e, e_stack) {
      // TODO: vsavkin log the exception once we have a good way to log errors and warnings

      // if an error happens during getting the debug context, we return an empty map.
      return null;
    }
  }
  dynamic getDetectorFor(DirectiveIndex directive) {
    var childView =
        this.getNestedView(this.elementOffset + directive.elementIndex);
    return isPresent(childView) ? childView.changeDetector : null;
  }
  invokeElementMethod(num elementIndex, String methodName, List<dynamic> args) {
    this.renderer.invokeElementMethod(
        this.elementRefs[elementIndex], methodName, args);
  }
  // implementation of RenderEventDispatcher#dispatchRenderEvent
  bool dispatchRenderEvent(
      num renderElementIndex, String eventName, Map<String, dynamic> locals) {
    var elementRef = this.elementRefs[
        this.mainMergeMapping.renderInverseElementIndices[renderElementIndex]];
    var view = internalView(elementRef.parentView);
    return view.dispatchEvent(elementRef.boundElementIndex, eventName, locals);
  }
  // returns false if preventDefault must be applied to the DOM event
  bool dispatchEvent(
      num boundElementIndex, String eventName, Map<String, dynamic> locals) {
    try {
      // Most of the time the event will be fired only when the view is in the live document.

      // However, in a rare circumstance the view might get dehydrated, in between the event

      // queuing up and firing.
      var allowDefaultBehavior = true;
      if (this.hydrated()) {
        var elBinder =
            this.proto.elementBinders[boundElementIndex - this.elementOffset];
        if (isBlank(elBinder.hostListeners)) return allowDefaultBehavior;
        var eventMap = elBinder.hostListeners[eventName];
        if (isBlank(eventMap)) return allowDefaultBehavior;
        MapWrapper.forEach(eventMap, (expr, directiveIndex) {
          var context;
          if (identical(directiveIndex, -1)) {
            context = this.context;
          } else {
            context = this.elementInjectors[boundElementIndex]
                .getDirectiveAtIndex(directiveIndex);
          }
          var result = expr.eval(context, new Locals(this.locals, locals));
          if (isPresent(result)) {
            allowDefaultBehavior = allowDefaultBehavior && result == true;
          }
        });
      }
      return allowDefaultBehavior;
    } catch (e, e_stack) {
      var c =
          this.getDebugContext(boundElementIndex - this.elementOffset, null);
      var context = isPresent(c)
          ? new _Context(
              c.element, c.componentElement, c.context, c.locals, c.injector)
          : null;
      throw new EventEvaluationError(eventName, e, e_stack, context);
    }
  }
}
Map<String, dynamic> _localsToStringMap(Locals locals) {
  var res = {};
  var c = locals;
  while (isPresent(c)) {
    res = StringMapWrapper.merge(res, MapWrapper.toStringMap(c.current));
    c = c.parent;
  }
  return res;
}
/**
 * Error context included when an event handler throws an exception.
 */
class _Context {
  dynamic element;
  dynamic componentElement;
  dynamic context;
  dynamic locals;
  dynamic injector;
  _Context(this.element, this.componentElement, this.context, this.locals,
      this.injector) {}
}
/**
 * Wraps an exception thrown by an event handler.
 */
class EventEvaluationError extends BaseException {
  EventEvaluationError(String eventName, dynamic originalException,
      dynamic originalStack, dynamic context)
      : super('''Error during evaluation of "${ eventName}"''',
          originalException, originalStack, context) {
    /* super call moved to initializer */;
  }
}
/**
 *
 */
class AppProtoView {
  renderApi.ViewType type;
  bool isEmbeddedFragment;
  renderApi.RenderProtoViewRef render;
  ProtoChangeDetector protoChangeDetector;
  Map<String, String> variableBindings;
  Map<String, num> variableLocations;
  num textBindingCount;
  List<ElementBinder> elementBinders = [];
  Map<String, dynamic> protoLocals = new Map();
  AppProtoViewMergeMapping mergeMapping;
  ProtoViewRef ref;
  AppProtoView(this.type, this.isEmbeddedFragment, this.render,
      this.protoChangeDetector, this.variableBindings, this.variableLocations,
      this.textBindingCount) {
    this.ref = new ProtoViewRef(this);
    if (isPresent(variableBindings)) {
      MapWrapper.forEach(variableBindings, (templateName, _) {
        this.protoLocals[templateName] = null;
      });
    }
  }
  ElementBinder bindElement(ElementBinder parent, int distanceToParent,
      ProtoElementInjector protoElementInjector,
      [DirectiveBinding componentDirective = null]) {
    var elBinder = new ElementBinder(this.elementBinders.length, parent,
        distanceToParent, protoElementInjector, componentDirective);
    this.elementBinders.add(elBinder);
    return elBinder;
  }
  /**
   * Adds an event binding for the last created ElementBinder via bindElement.
   *
   * If the directive index is a positive integer, the event is evaluated in the context of
   * the given directive.
   *
   * If the directive index is -1, the event is evaluated in the context of the enclosing view.
   *
   * @param {string} eventName
   * @param {AST} expression
   * @param {int} directiveIndex The directive index in the binder or -1 when the event is not bound
   *                             to a directive
   */
  void bindEvent(
      List<renderApi.EventBinding> eventBindings, num boundElementIndex,
      [int directiveIndex = -1]) {
    var elBinder = this.elementBinders[boundElementIndex];
    var events = elBinder.hostListeners;
    if (isBlank(events)) {
      events = StringMapWrapper.create();
      elBinder.hostListeners = events;
    }
    for (var i = 0; i < eventBindings.length; i++) {
      var eventBinding = eventBindings[i];
      var eventName = eventBinding.fullName;
      var event = StringMapWrapper.get(events, eventName);
      if (isBlank(event)) {
        event = new Map();
        StringMapWrapper.set(events, eventName, event);
      }
      event[directiveIndex] = eventBinding.source;
    }
  }
}
