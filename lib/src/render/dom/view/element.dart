library angular2.src.render.dom.view.element;

import "element_binder.dart" show ElementBinder;
import "view_container.dart" show DomViewContainer;
import "../shadow_dom/light_dom.dart" show LightDom;
import "../shadow_dom/content_tag.dart" show Content;

class DomElement {
  ElementBinder proto;
  dynamic element;
  Content contentTag;
  DomViewContainer viewContainer;
  LightDom lightDom;
  DomElement(this.proto, this.element, this.contentTag) {}
}
