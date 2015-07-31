library angular2.src.core.compiler.dynamic_component_loader;

import "package:angular2/di.dart"
    show Key, Injector, ResolvedBinding, Binding, bind, Injectable;
import "compiler.dart" show Compiler;
import "package:angular2/src/facade/lang.dart"
    show Type, BaseException, stringify, isPresent;
import "package:angular2/src/facade/async.dart" show Future;
import "package:angular2/src/core/compiler/view_manager.dart"
    show AppViewManager;
import "element_ref.dart" show ElementRef;
import "view_ref.dart" show ViewRef, HostViewRef;

/**
 * Angular's reference to a component instance.
 *
 * `ComponentRef` represents a component instance lifecycle and meta information.
 */
class ComponentRef {
  dynamic /* () => void */ _dispose;
  /**
   * Location of the component host element.
   */
  ElementRef location;
  /**
   * Instance of component.
   */
  dynamic instance;
  /**
   * @private
   */
  ComponentRef(ElementRef location, dynamic instance, this._dispose) {
    this.location = location;
    this.instance = instance;
  }
  /**
   * Returns the host {@link ViewRef}.
   */
  HostViewRef get hostView {
    return this.location.parentView;
  }
  /**
   * Dispose of the component instance.
   */
  dispose() {
    this._dispose();
  }
}
/**
 * Service for dynamically loading a Component into an arbitrary position in the internal Angular
 * application tree.
 */
@Injectable()
class DynamicComponentLoader {
  Compiler _compiler;
  AppViewManager _viewManager;
  DynamicComponentLoader(this._compiler, this._viewManager) {}
  /**
   * Loads a root component that is placed at the first element that matches the component's
   * selector.
   *
   * - `typeOrBinding` `Type` \ {@link Binding} - representing the component to load.
   * - `overrideSelector` (optional) selector to load the component at (or use
   *   `@Component.selector`) The selector can be anywhere (i.e. outside the current component.)
   * - `injector` {@link Injector} - optional injector to use for the component.
   *
   * The loaded component receives injection normally as a hosted view.
   *
   *
   * ## Example
   *
   * ```
   * @ng.Component({
   *   selector: 'child-component'
   * })
   * @ng.View({
   *   template: 'Child'
   * })
   * class ChildComponent {
   * }
   *
   *
   *
   * @ng.Component({
   *   selector: 'my-app'
   * })
   * @ng.View({
   *   template: `
   *     Parent (<child id="child"></child>)
   *   `
   * })
   * class MyApp {
   *   constructor(dynamicComponentLoader: ng.DynamicComponentLoader, injector: ng.Injector) {
   *     dynamicComponentLoader.loadAsRoot(ChildComponent, '#child', injector);
   *   }
   * }
   *
   * ng.bootstrap(MyApp);
   * ```
   *
   * Resulting DOM:
   *
   * ```
   * <my-app>
   *   Parent (
   *     <child id="child">
   *        Child
   *     </child>
   *   )
   * </my-app>
   * ```
   */
  Future<ComponentRef> loadAsRoot(dynamic /* Type | Binding */ typeOrBinding,
      String overrideSelector, Injector injector) {
    return this._compiler.compileInHost(typeOrBinding).then((hostProtoViewRef) {
      var hostViewRef = this._viewManager.createRootHostView(
          hostProtoViewRef, overrideSelector, injector);
      var newLocation = this._viewManager.getHostElement(hostViewRef);
      var component = this._viewManager.getComponent(newLocation);
      var dispose = () {
        this._viewManager.destroyRootHostView(hostViewRef);
      };
      return new ComponentRef(newLocation, component, dispose);
    });
  }
  /**
   * Loads a component into the component view of the provided ElementRef next to the element
   * with the given name.
   *
   * The loaded component receives injection normally as a hosted view.
   *
   * ## Example
   *
   * ```
   * @ng.Component({
   *   selector: 'child-component'
   * })
   * @ng.View({
   *   template: 'Child'
   * })
   * class ChildComponent {
   * }
   *
   *
   * @ng.Component({
   *   selector: 'my-app'
   * })
   * @ng.View({
   *   template: `
   *     Parent (<div #child></div>)
   *   `
   * })
   * class MyApp {
   *   constructor(dynamicComponentLoader: ng.DynamicComponentLoader, elementRef: ng.ElementRef) {
   *     dynamicComponentLoader.loadIntoLocation(ChildComponent, elementRef, 'child');
   *   }
   * }
   *
   * ng.bootstrap(MyApp);
   * ```
   *
   * Resulting DOM:
   *
   * ```
   * <my-app>
   *    Parent (
   *      <div #child="" class="ng-binding"></div>
   *      <child-component class="ng-binding">Child</child-component>
   *    )
   * </my-app>
   * ```
   */
  Future<ComponentRef> loadIntoLocation(
      dynamic /* Type | Binding */ typeOrBinding, ElementRef hostLocation,
      String anchorName, [List<ResolvedBinding> bindings = null]) {
    return this.loadNextToLocation(typeOrBinding, this._viewManager
        .getNamedElementInComponentView(hostLocation, anchorName), bindings);
  }
  /**
   * Loads a component next to the provided ElementRef.
   *
   * The loaded component receives injection normally as a hosted view.
   *
   *
   * ## Example
   *
   * ```
   * @ng.Component({
   *   selector: 'child-component'
   * })
   * @ng.View({
   *   template: 'Child'
   * })
   * class ChildComponent {
   * }
   *
   *
   * @ng.Component({
   *   selector: 'my-app'
   * })
   * @ng.View({
   *   template: `Parent`
   * })
   * class MyApp {
   *   constructor(dynamicComponentLoader: ng.DynamicComponentLoader, elementRef: ng.ElementRef) {
   *     dynamicComponentLoader.loadIntoLocation(ChildComponent, elementRef, 'child');
   *   }
   * }
   *
   * ng.bootstrap(MyApp);
   * ```
   *
   * Resulting DOM:
   *
   * ```
   * <my-app>Parent</my-app>
   * <child-component>Child</child-component>
   * ```
   */
  Future<ComponentRef> loadNextToLocation(
      dynamic /* Type | Binding */ typeOrBinding, ElementRef location,
      [List<ResolvedBinding> bindings = null]) {
    return this._compiler.compileInHost(typeOrBinding).then((hostProtoViewRef) {
      var viewContainer = this._viewManager.getViewContainer(location);
      var hostViewRef = viewContainer.createHostView(
          hostProtoViewRef, viewContainer.length, bindings);
      var newLocation = this._viewManager.getHostElement(hostViewRef);
      var component = this._viewManager.getComponent(newLocation);
      var dispose = () {
        var index = viewContainer.indexOf((hostViewRef as ViewRef));
        if (!identical(index, -1)) {
          viewContainer.remove(index);
        }
      };
      return new ComponentRef(newLocation, component, dispose);
    });
  }
}
