library angular2.src.core.compiler.template_ref;

import "view_ref.dart" show internalView, ProtoViewRef;
import "element_ref.dart" show ElementRef;
import "view.dart" as viewModule;

/**
 * Reference to a template within a component.
 *
 * Represents an opaque reference to the underlying template that can
 * be instantiated using the {@link ViewContainerRef}.
 */
class TemplateRef {
  /**
   * The location of the template
   */
  ElementRef elementRef;
  TemplateRef(ElementRef elementRef) {
    this.elementRef = elementRef;
  }
  viewModule.AppProtoView _getProtoView() {
    var parentView = internalView(this.elementRef.parentView);
    return parentView.proto.elementBinders[this.elementRef.boundElementIndex -
        parentView.elementOffset].nestedProtoView;
  }
  ProtoViewRef get protoViewRef {
    return this._getProtoView().ref;
  }
  /**
   * Whether this template has a local variable with the given name
   */
  bool hasLocal(String name) {
    return this._getProtoView().protoLocals.containsKey(name);
  }
}
