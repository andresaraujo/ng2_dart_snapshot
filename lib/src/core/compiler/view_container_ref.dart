library angular2.src.core.compiler.view_container_ref;

import "package:angular2/src/facade/collection.dart" show ListWrapper, List;
import "package:angular2/di.dart" show ResolvedBinding;
import "package:angular2/src/facade/lang.dart" show isPresent, isBlank;
import "view_manager.dart" as avmModule;
import "view.dart" as viewModule;
import "element_ref.dart" show ElementRef;
import "view_ref.dart" show ViewRef, ProtoViewRef, internalView;

class ViewContainerRef {
  avmModule.AppViewManager viewManager;
  ElementRef element;
  ViewContainerRef(this.viewManager, this.element) {}
  List<viewModule.AppView> _getViews() {
    var vc = internalView(this.element.parentView).viewContainers[
        this.element.boundElementIndex];
    return isPresent(vc) ? vc.views : [];
  }
  void clear() {
    for (var i = this.length - 1; i >= 0; i--) {
      this.remove(i);
    }
  }
  ViewRef get(num index) {
    return this._getViews()[index].ref;
  }
  num get length {
    return this._getViews().length;
  }
  // TODO(rado): profile and decide whether bounds checks should be added

  // to the methods below.
  ViewRef create([ProtoViewRef protoViewRef = null, num atIndex = -1,
      ElementRef context = null, List<ResolvedBinding> bindings = null]) {
    if (atIndex == -1) atIndex = this.length;
    return this.viewManager.createViewInContainer(
        this.element, atIndex, protoViewRef, context, bindings);
  }
  ViewRef insert(ViewRef viewRef, [num atIndex = -1]) {
    if (atIndex == -1) atIndex = this.length;
    return this.viewManager.attachViewInContainer(
        this.element, atIndex, viewRef);
  }
  num indexOf(ViewRef viewRef) {
    return ListWrapper.indexOf(this._getViews(), internalView(viewRef));
  }
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
