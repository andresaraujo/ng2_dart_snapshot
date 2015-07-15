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
import "view_ref.dart" show ViewRef;

class ComponentRef {
  ElementRef location;
  dynamic instance;
  Function dispose;
  ComponentRef(this.location, this.instance, this.dispose) {}
  ViewRef get hostView {
    return this.location.parentView;
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
   * The loaded component receives injection normally as a hosted view.
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
   * Loads a component into the component view of the provided ElementRef
   * next to the element with the given name
   * The loaded component receives
   * injection normally as a hosted view.
   */
  Future<ComponentRef> loadIntoLocation(
      dynamic /* Type | Binding */ typeOrBinding, ElementRef hostLocation,
      String anchorName, [List<ResolvedBinding> bindings = null]) {
    return this.loadNextToLocation(typeOrBinding, this._viewManager
        .getNamedElementInComponentView(hostLocation, anchorName), bindings);
  }
  /**
   * Loads a component next to the provided ElementRef. The loaded component receives
   * injection normally as a hosted view.
   */
  Future<ComponentRef> loadNextToLocation(
      dynamic /* Type | Binding */ typeOrBinding, ElementRef location,
      [List<ResolvedBinding> bindings = null]) {
    return this._compiler.compileInHost(typeOrBinding).then((hostProtoViewRef) {
      var viewContainer = this._viewManager.getViewContainer(location);
      var hostViewRef = viewContainer.create(
          hostProtoViewRef, viewContainer.length, null, bindings);
      var newLocation = this._viewManager.getHostElement(hostViewRef);
      var component = this._viewManager.getComponent(newLocation);
      var dispose = () {
        var index = viewContainer.indexOf(hostViewRef);
        if (!identical(index, -1)) {
          viewContainer.remove(index);
        }
      };
      return new ComponentRef(newLocation, component, dispose);
    });
  }
}
