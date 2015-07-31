library angular2.src.core.compiler.view_container_ref;

import "package:angular2/src/facade/collection.dart" show ListWrapper, List;
import "package:angular2/di.dart" show ResolvedBinding;
import "package:angular2/src/facade/lang.dart" show isPresent, isBlank;
import "view_manager.dart" as avmModule;
import "view.dart" as viewModule;
import "element_ref.dart" show ElementRef;
import "template_ref.dart" show TemplateRef;
import "view_ref.dart" show ViewRef, HostViewRef, ProtoViewRef, internalView;

/**
 * A location where {@link ViewRef}s can be attached.
 *
 * A `ViewContainerRef` represents a location in a {@link ViewRef} where other child
 * {@link ViewRef}s can be inserted. Adding and removing views is the only way of structurally
 * changing the rendered DOM of the application.
 */
class ViewContainerRef {
  avmModule.AppViewManager viewManager;
  ElementRef element;
  /**
   * @private
   */
  ViewContainerRef(this.viewManager, this.element) {}
  List<viewModule.AppView> _getViews() {
    var vc = internalView(this.element.parentView).viewContainers[
        this.element.boundElementIndex];
    return isPresent(vc) ? vc.views : [];
  }
  /**
   * Remove all {@link ViewRef}s at current location.
   */
  void clear() {
    for (var i = this.length - 1; i >= 0; i--) {
      this.remove(i);
    }
  }
  /**
   * Return a {@link ViewRef} at specific index.
   */
  ViewRef get(num index) {
    return this._getViews()[index].ref;
  }
  /**
   * Returns number of {@link ViewRef}s currently attached at this location.
   */
  num get length {
    return this._getViews().length;
  }
  /**
   * Create and insert a {@link ViewRef} into the view-container.
   *
   * - `protoViewRef` (optional) {@link ProtoViewRef} - The `ProtoView` to use for creating
   *   `View` to be inserted at this location. If `ViewContainer` is created at a location
   *   of inline template, then `protoViewRef` is the `ProtoView` of the template.
   * - `atIndex` (optional) `number` - location of insertion point. (Or at the end if unspecified.)
   * - `context` (optional) {@link ElementRef} - Context (for expression evaluation) from the
   *   {@link ElementRef} location. (Or current context if unspecified.)
   * - `bindings` (optional) Array of {@link ResolvedBinding} - Used for configuring
   *   `ElementInjector`.
   *
   * Returns newly created {@link ViewRef}.
   */

  // TODO(rado): profile and decide whether bounds checks should be added

  // to the methods below.
  ViewRef createEmbeddedView(TemplateRef templateRef, [num atIndex = -1]) {
    if (atIndex == -1) atIndex = this.length;
    return this.viewManager.createEmbeddedViewInContainer(
        this.element, atIndex, templateRef);
  }
  HostViewRef createHostView([ProtoViewRef protoViewRef = null,
      num atIndex = -1,
      List<ResolvedBinding> dynamicallyCreatedBindings = null]) {
    if (atIndex == -1) atIndex = this.length;
    return this.viewManager.createHostViewInContainer(
        this.element, atIndex, protoViewRef, dynamicallyCreatedBindings);
  }
  /**
   * Insert a {@link ViewRef} at specefic index.
   *
   * The index is location at which the {@link ViewRef} should be attached. If omitted it is
   * inserted at the end.
   *
   * Returns the inserted {@link ViewRef}.
   */
  ViewRef insert(ViewRef viewRef, [num atIndex = -1]) {
    if (atIndex == -1) atIndex = this.length;
    return this.viewManager.attachViewInContainer(
        this.element, atIndex, viewRef);
  }
  /**
   * Return the index of already inserted {@link ViewRef}.
   */
  num indexOf(ViewRef viewRef) {
    return ListWrapper.indexOf(this._getViews(), internalView(viewRef));
  }
  /**
   * Remove a {@link ViewRef} at specific index.
   *
   * If the index is omitted last {@link ViewRef} is removed.
   */
  void remove([num atIndex = -1]) {
    if (atIndex == -1) atIndex = this.length - 1;
    this.viewManager.destroyViewInContainer(this.element, atIndex);
  }
  /**
   * The method can be used together with insert to implement a view move, i.e.
   * moving the dom nodes while the directives in the view stay intact.
   */
  ViewRef detach([num atIndex = -1]) {
    if (atIndex == -1) atIndex = this.length - 1;
    return this.viewManager.detachViewInContainer(this.element, atIndex);
  }
}
