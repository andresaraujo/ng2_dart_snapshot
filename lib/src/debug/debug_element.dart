library angular2.src.debug.debug_element;

import "package:angular2/src/facade/lang.dart"
    show Type, isPresent, BaseException, isBlank;
import "package:angular2/src/facade/collection.dart"
    show List, ListWrapper, MapWrapper, Predicate;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/core/compiler/element_injector.dart"
    show ElementInjector;
import "package:angular2/src/core/compiler/view.dart" show AppView;
import "package:angular2/src/core/compiler/view_ref.dart" show internalView;
import "package:angular2/src/core/compiler/element_ref.dart" show ElementRef;

/**
 * A DebugElement contains information from the Angular compiler about an
 * element and provides access to the corresponding ElementInjector and
 * underlying dom Element, as well as a way to query for children.
 */
class DebugElement {
  AppView _parentView;
  num _boundElementIndex;
  ElementInjector _elementInjector;
  DebugElement(this._parentView, this._boundElementIndex) {
    this._elementInjector =
        this._parentView.elementInjectors[this._boundElementIndex];
  }
  static DebugElement create(ElementRef elementRef) {
    return new DebugElement(
        internalView(elementRef.parentView), elementRef.boundElementIndex);
  }
  dynamic get componentInstance {
    if (!isPresent(this._elementInjector)) {
      return null;
    }
    return this._elementInjector.getComponent();
  }
  dynamic get nativeElement {
    return this.elementRef.nativeElement;
  }
  ElementRef get elementRef {
    return this._parentView.elementRefs[this._boundElementIndex];
  }
  dynamic getDirectiveInstance(num directiveIndex) {
    return this._elementInjector.getDirectiveAtIndex(directiveIndex);
  }
  /**
   * Get child DebugElements from within the Light DOM.
   *
   * @return {List<DebugElement>}
   */
  List<DebugElement> get children {
    return this._getChildElements(this._parentView, this._boundElementIndex);
  }
  /**
   * Get the root DebugElement children of a component. Returns an empty
   * list if the current DebugElement is not a component root.
   *
   * @return {List<DebugElement>}
   */
  List<DebugElement> get componentViewChildren {
    var shadowView = this._parentView.getNestedView(this._boundElementIndex);
    if (!isPresent(shadowView)) {
      // The current element is not a component.
      return [];
    }
    return this._getChildElements(shadowView, null);
  }
  void triggerEventHandler(String eventName, dynamic eventObj) {
    this._parentView.triggerEventHandlers(
        eventName, eventObj, this._boundElementIndex);
  }
  bool hasDirective(Type type) {
    if (!isPresent(this._elementInjector)) {
      return false;
    }
    return this._elementInjector.hasDirective(type);
  }
  dynamic inject(Type type) {
    if (!isPresent(this._elementInjector)) {
      return null;
    }
    return this._elementInjector.get(type);
  }
  dynamic getLocal(String name) {
    return this._parentView.locals.get(name);
  }
  /**
   * Return the first descendant TestElement matching the given predicate
   * and scope.
   *
   * @param {Function: boolean} predicate
   * @param {Scope} scope
   *
   * @return {DebugElement}
   */
  DebugElement query(Predicate<DebugElement> predicate,
      [Function scope = Scope.all]) {
    var results = this.queryAll(predicate, scope);
    return results.length > 0 ? results[0] : null;
  }
  /**
   * Return descendant TestElememts matching the given predicate
   * and scope.
   *
   * @param {Function: boolean} predicate
   * @param {Scope} scope
   *
   * @return {List<DebugElement>}
   */
  List<DebugElement> queryAll(Predicate<DebugElement> predicate,
      [Function scope = Scope.all]) {
    var elementsInScope = scope(this);
    return ListWrapper.filter(elementsInScope, predicate);
  }
  List<DebugElement> _getChildElements(
      AppView view, num parentBoundElementIndex) {
    var els = [];
    var parentElementBinder = null;
    if (isPresent(parentBoundElementIndex)) {
      parentElementBinder = view.proto.elementBinders[
          parentBoundElementIndex - view.elementOffset];
    }
    for (var i = 0; i < view.proto.elementBinders.length; ++i) {
      var binder = view.proto.elementBinders[i];
      if (binder.parent == parentElementBinder) {
        els.add(new DebugElement(view, view.elementOffset + i));
        var views = view.viewContainers[view.elementOffset + i];
        if (isPresent(views)) {
          ListWrapper.forEach(views.views, (nextView) {
            els =
                ListWrapper.concat(els, this._getChildElements(nextView, null));
          });
        }
      }
    }
    return els;
  }
}
DebugElement inspectElement(ElementRef elementRef) {
  return DebugElement.create(elementRef);
}
List<dynamic> asNativeElements(List<DebugElement> arr) {
  return arr.map((debugEl) => debugEl.nativeElement).toList();
}
class Scope {
  static List<DebugElement> all(DebugElement debugElement) {
    var scope = [];
    scope.add(debugElement);
    ListWrapper.forEach(debugElement.children, (child) {
      scope = ListWrapper.concat(scope, Scope.all(child));
    });
    ListWrapper.forEach(debugElement.componentViewChildren, (child) {
      scope = ListWrapper.concat(scope, Scope.all(child));
    });
    return scope;
  }
  static List<DebugElement> light(DebugElement debugElement) {
    var scope = [];
    ListWrapper.forEach(debugElement.children, (child) {
      scope.add(child);
      scope = ListWrapper.concat(scope, Scope.light(child));
    });
    return scope;
  }
  static List<DebugElement> view(DebugElement debugElement) {
    var scope = [];
    ListWrapper.forEach(debugElement.componentViewChildren, (child) {
      scope.add(child);
      scope = ListWrapper.concat(scope, Scope.light(child));
    });
    return scope;
  }
}
class By {
  static Function all() {
    return (debugElement) => true;
  }
  static Predicate<DebugElement> css(String selector) {
    return (debugElement) {
      return isPresent(debugElement.nativeElement)
          ? DOM.elementMatches(debugElement.nativeElement, selector)
          : false;
    };
  }
  static Predicate<DebugElement> directive(Type type) {
    return (debugElement) {
      return debugElement.hasDirective(type);
    };
  }
}
