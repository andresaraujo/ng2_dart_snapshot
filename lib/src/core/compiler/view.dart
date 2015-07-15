library angular2.src.core.compiler.view;

import "package:angular2/src/facade/collection.dart"
    show ListWrapper, MapWrapper, Map, StringMapWrapper, List;
import "package:angular2/change_detection.dart"
    show
        AST,
        Locals,
        ChangeDispatcher,
        ProtoChangeDetector,
        ChangeDetector,
        BindingRecord,
        DirectiveRecord,
        DirectiveIndex,
        ChangeDetectorRef;
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
import "package:angular2/src/render/api.dart" show EventDispatcher;
import "view_ref.dart" show ViewRef;
import "element_ref.dart" show ElementRef;

class AppViewContainer {
  // The order in this list matches the DOM order.
  List<AppView> views = [];
}
/**
 * Cost of making objects: http://jsperf.com/instantiate-size-of-object
 *
 */
class AppView implements ChangeDispatcher, EventDispatcher {
  renderApi.Renderer renderer;
  AppProtoView proto;
  renderApi.RenderViewRef render = null;
  /// This list matches the _nodes list. It is sparse, since only Elements have ElementInjector
  List<ElementInjector> rootElementInjectors;
  List<ElementInjector> elementInjectors = null;
  ChangeDetector changeDetector = null;
  List<AppView> componentChildViews = null;
  List<AppViewContainer> viewContainers;
  List<PreBuiltObjects> preBuiltObjects = null;
  List<ElementRef> elementRefs;
  ViewRef ref;
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
  AppView(this.renderer, this.proto, Map<String, dynamic> protoLocals) {
    this.viewContainers =
        ListWrapper.createFixedSize(this.proto.elementBinders.length);
    this.elementRefs =
        ListWrapper.createFixedSize(this.proto.elementBinders.length);
    this.ref = new ViewRef(this);
    for (var i = 0; i < this.elementRefs.length; i++) {
      this.elementRefs[i] = new ElementRef(this.ref, i, renderer);
    }
    this.locals = new Locals(null, MapWrapper.clone(protoLocals));
  }
  init(ChangeDetector changeDetector, List<ElementInjector> elementInjectors,
      List<ElementInjector> rootElementInjectors,
      List<PreBuiltObjects> preBuiltObjects,
      List<AppView> componentChildViews) {
    this.changeDetector = changeDetector;
    this.elementInjectors = elementInjectors;
    this.rootElementInjectors = rootElementInjectors;
    this.preBuiltObjects = preBuiltObjects;
    this.componentChildViews = componentChildViews;
  }
  void setLocal(String contextName, value) {
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
   * @param {int} binderIndex
   */
  void triggerEventHandlers(String eventName, eventObj, int binderIndex) {
    var locals = new Map();
    locals["\$event"] = eventObj;
    this.dispatchEvent(binderIndex, eventName, locals);
  }
  // dispatch to element injector or text nodes based on context
  void notifyOnBinding(BindingRecord b, dynamic currentValue) {
    if (b.isElementProperty()) {
      this.renderer.setElementProperty(
          this.elementRefs[b.elementIndex], b.propertyName, currentValue);
    } else if (b.isElementAttribute()) {
      this.renderer.setElementAttribute(
          this.elementRefs[b.elementIndex], b.propertyName, currentValue);
    } else if (b.isElementClass()) {
      this.renderer.setElementClass(
          this.elementRefs[b.elementIndex], b.propertyName, currentValue);
    } else if (b.isElementStyle()) {
      var unit = isPresent(b.propertyUnit) ? b.propertyUnit : "";
      this.renderer.setElementStyle(this.elementRefs[b.elementIndex],
          b.propertyName, '''${ currentValue}${ unit}''');
    } else if (b.isTextNode()) {
      this.renderer.setText(this.render, b.elementIndex, currentValue);
    } else {
      throw new BaseException("Unsupported directive record");
    }
  }
  void notifyOnAllChangesDone() {
    var ei = this.elementInjectors;
    for (var i = ei.length - 1; i >= 0; i--) {
      if (isPresent(ei[i])) ei[i].onAllChangesDone();
    }
  }
  dynamic getDirectiveFor(DirectiveIndex directive) {
    var elementInjector = this.elementInjectors[directive.elementIndex];
    return elementInjector.getDirectiveAtIndex(directive.directiveIndex);
  }
  dynamic getDetectorFor(DirectiveIndex directive) {
    var childView = this.componentChildViews[directive.elementIndex];
    return isPresent(childView) ? childView.changeDetector : null;
  }
  invokeElementMethod(num elementIndex, String methodName, List<dynamic> args) {
    this.renderer.invokeElementMethod(
        this.elementRefs[elementIndex], methodName, args);
  }
  // implementation of EventDispatcher#dispatchEvent

  // returns false if preventDefault must be applied to the DOM event
  bool dispatchEvent(
      num elementIndex, String eventName, Map<String, dynamic> locals) {
    // Most of the time the event will be fired only when the view is in the live document.

    // However, in a rare circumstance the view might get dehydrated, in between the event

    // queuing up and firing.
    var allowDefaultBehavior = true;
    if (this.hydrated()) {
      var elBinder = this.proto.elementBinders[elementIndex];
      if (isBlank(elBinder.hostListeners)) return allowDefaultBehavior;
      var eventMap = elBinder.hostListeners[eventName];
      if (isBlank(eventMap)) return allowDefaultBehavior;
      MapWrapper.forEach(eventMap, (expr, directiveIndex) {
        var context;
        if (identical(directiveIndex, -1)) {
          context = this.context;
        } else {
          context = this.elementInjectors[elementIndex]
              .getDirectiveAtIndex(directiveIndex);
        }
        var result = expr.eval(context, new Locals(this.locals, locals));
        if (isPresent(result)) {
          allowDefaultBehavior = allowDefaultBehavior && result == true;
        }
      });
    }
    return allowDefaultBehavior;
  }
}
/**
 *
 */
class AppProtoView {
  renderApi.RenderProtoViewRef render;
  ProtoChangeDetector protoChangeDetector;
  Map<String, String> variableBindings;
  Map<String, num> variableLocations;
  List<ElementBinder> elementBinders = [];
  Map<String, dynamic> protoLocals = new Map();
  AppProtoView(this.render, this.protoChangeDetector, this.variableBindings,
      this.variableLocations) {
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
