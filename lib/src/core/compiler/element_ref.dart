library angular2.src.core.compiler.element_ref;

import "package:angular2/src/facade/lang.dart" show BaseException;
import "view_ref.dart" show ViewRef;
import "package:angular2/src/render/api.dart"
    show RenderViewRef, RenderElementRef, Renderer;

/**
 * Reference to the element.
 *
 * Represents an opaque reference to the underlying element. The element is a DOM ELement in
 * a Browser, but may represent other types on other rendering platforms. In the browser the
 * `ElementRef` can be sent to the web-worker. Web Workers can not have references to the
 * DOM Elements.
 */
class ElementRef implements RenderElementRef {
  Renderer _renderer;
  /**
   * Reference to the {@link ViewRef} where the `ElementRef` is inside of.
   */
  ViewRef parentView;
  /**
   * Index of the element inside the {@link ViewRef}.
   *
   * This is used internally by the Angular framework to locate elements.
   */
  num boundElementIndex;
  ElementRef(ViewRef parentView, num boundElementIndex, this._renderer) {
    this.parentView = parentView;
    this.boundElementIndex = boundElementIndex;
  }
  /**
   *
   */
  RenderViewRef get renderView {
    return this.parentView.render;
  }
  // TODO(tbosch): remove this once Typescript supports declaring interfaces

  // that contain getters

  // https://github.com/Microsoft/TypeScript/issues/3745
  set renderView(RenderViewRef viewRef) {
    throw new BaseException("Abstract setter");
  }
  /**
   * Returns the native Element implementation.
   *
   * In the browser this represents the DOM Element.
   *
   * The `nativeElement` can be used as an escape hatch when direct DOM manipulation is needed. Use
   * this with caution, as it creates tight coupling between your application and the Browser, which
   * will not work in WebWorkers.
   *
   * NOTE: This method will return null in the webworker scenario!
   */
  dynamic get nativeElement {
    return this._renderer.getNativeElementSync(this);
  }
}
