library angular2.src.render.dom.view.proto_view;

import "package:angular2/src/facade/lang.dart" show isPresent;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/facade/collection.dart" show List, ListWrapper;
import "element_binder.dart" show ElementBinder;
import "../util.dart" show NG_BINDING_CLASS;
import "../../api.dart" show RenderProtoViewRef;

DomProtoView resolveInternalDomProtoView(RenderProtoViewRef protoViewRef) {
  return ((protoViewRef as DomProtoViewRef))._protoView;
}
class DomProtoViewRef extends RenderProtoViewRef {
  DomProtoView _protoView;
  DomProtoViewRef(this._protoView) : super() {
    /* super call moved to initializer */;
  }
}
class DomProtoView {
  var element;
  List<ElementBinder> elementBinders;
  bool isTemplateElement;
  num rootBindingOffset;
  // the number of content tags seen in this or any child proto view.
  num transitiveContentTagCount;
  num boundTextNodeCount;
  num rootNodeCount;
  DomProtoView({elementBinders, element, transitiveContentTagCount,
      boundTextNodeCount}) {
    this.element = element;
    this.elementBinders = elementBinders;
    this.transitiveContentTagCount = transitiveContentTagCount;
    this.isTemplateElement = DOM.isTemplateElement(this.element);
    this.rootBindingOffset = (isPresent(this.element) &&
        DOM.hasClass(this.element, NG_BINDING_CLASS)) ? 1 : 0;
    this.boundTextNodeCount = boundTextNodeCount;
    this.rootNodeCount = this.isTemplateElement
        ? DOM.childNodes(DOM.content(this.element)).length
        : 1;
  }
}
