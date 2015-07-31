library angular2.src.render.dom.view.fragment;

import "../../api.dart" show RenderFragmentRef;

List<dynamic> resolveInternalDomFragment(RenderFragmentRef fragmentRef) {
  return ((fragmentRef as DomFragmentRef))._nodes;
}
class DomFragmentRef extends RenderFragmentRef {
  List<dynamic> _nodes;
  DomFragmentRef(this._nodes) : super() {
    /* super call moved to initializer */;
  }
}
