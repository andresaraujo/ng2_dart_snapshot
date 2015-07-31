library angular2.src.render.dom.view.proto_view;

import "package:angular2/src/facade/collection.dart" show List, ListWrapper;
import "element_binder.dart" show DomElementBinder;
import "../../api.dart" show RenderProtoViewRef, ViewType, ViewEncapsulation;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "../template_cloner.dart" show TemplateCloner;

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
  ViewType type;
  dynamic /* dynamic | String */ cloneableTemplate;
  ViewEncapsulation encapsulation;
  List<DomElementBinder> elementBinders;
  Map<String, String> hostAttributes;
  List<num> rootTextNodeIndices;
  num boundTextNodeCount;
  List<num> fragmentsRootNodeCount;
  bool isSingleElementFragment;
  static DomProtoView create(TemplateCloner templateCloner, ViewType type,
      dynamic rootElement, ViewEncapsulation viewEncapsulation,
      List<num> fragmentsRootNodeCount, List<num> rootTextNodeIndices,
      List<DomElementBinder> elementBinders,
      Map<String, String> hostAttributes) {
    var boundTextNodeCount = rootTextNodeIndices.length;
    for (var i = 0; i < elementBinders.length; i++) {
      boundTextNodeCount += elementBinders[i].textNodeIndices.length;
    }
    var isSingleElementFragment = identical(fragmentsRootNodeCount.length, 1) &&
        identical(fragmentsRootNodeCount[0], 1) &&
        DOM.isElementNode(DOM.firstChild(DOM.content(rootElement)));
    return new DomProtoView(type, templateCloner.prepareForClone(rootElement),
        viewEncapsulation, elementBinders, hostAttributes, rootTextNodeIndices,
        boundTextNodeCount, fragmentsRootNodeCount, isSingleElementFragment);
  }
  // Note: fragments are separated by a comment node that is not counted in fragmentsRootNodeCount!
  DomProtoView(this.type, this.cloneableTemplate, this.encapsulation,
      this.elementBinders, this.hostAttributes, this.rootTextNodeIndices,
      this.boundTextNodeCount, this.fragmentsRootNodeCount,
      this.isSingleElementFragment) {}
}
