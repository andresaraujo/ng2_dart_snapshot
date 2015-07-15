library angular2.src.render.dom.shadow_dom.shadow_dom_strategy;

import "package:angular2/src/facade/lang.dart" show isBlank, isPresent;
import "../view/view.dart" as viewModule;
import "light_dom.dart" show LightDom;

class ShadowDomStrategy {
  // Whether the strategy understands the native <content> tag
  bool hasNativeContentElement() {
    return true;
  }
  // Prepares and returns the (emulated) shadow root for the given element.
  dynamic prepareShadowRoot(el) {
    return null;
  }
  LightDom constructLightDom(viewModule.DomView lightDomView, el) {
    return null;
  }
  // An optional step that can modify the template style elements.
  void processStyleElement(
      String hostComponentId, String templateUrl, styleElement) {}
  // An optional step that can modify the template elements (style elements exlcuded).
  void processElement(
      String hostComponentId, String elementComponentId, element) {}
}
