library angular2.src.render.dom.shadow_dom.emulated_unscoped_shadow_dom_strategy;

import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "../view/view.dart" as viewModule;
import "light_dom.dart" show LightDom;
import "shadow_dom_strategy.dart" show ShadowDomStrategy;
import "util.dart" show insertSharedStyleText;

/**
 * This strategy emulates the Shadow DOM for the templates, styles **excluded**:
 * - components templates are added as children of their component element,
 * - styles are moved from the templates to the styleHost (i.e. the document head).
 *
 * Notes:
 * - styles are **not** scoped to their component and will apply to the whole document,
 * - you can **not** use shadow DOM specific selectors in the styles
 */
class EmulatedUnscopedShadowDomStrategy extends ShadowDomStrategy {
  var styleHost;
  EmulatedUnscopedShadowDomStrategy(this.styleHost) : super() {
    /* super call moved to initializer */;
  }
  bool hasNativeContentElement() {
    return false;
  }
  dynamic prepareShadowRoot(el) {
    return el;
  }
  LightDom constructLightDom(viewModule.DomView lightDomView, el) {
    return new LightDom(lightDomView, el);
  }
  void processStyleElement(
      String hostComponentId, String templateUrl, styleEl) {
    var cssText = DOM.getText(styleEl);
    insertSharedStyleText(cssText, this.styleHost, styleEl);
  }
}
