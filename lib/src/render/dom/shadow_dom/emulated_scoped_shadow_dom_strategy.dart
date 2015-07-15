library angular2.src.render.dom.shadow_dom.emulated_scoped_shadow_dom_strategy;

import "package:angular2/src/facade/lang.dart" show isBlank, isPresent;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "emulated_unscoped_shadow_dom_strategy.dart"
    show EmulatedUnscopedShadowDomStrategy;
import "util.dart"
    show
        getContentAttribute,
        getHostAttribute,
        getComponentId,
        shimCssForComponent,
        insertStyleElement;

/**
 * This strategy emulates the Shadow DOM for the templates, styles **included**:
 * - components templates are added as children of their component element,
 * - both the template and the styles are modified so that styles are scoped to the component
 *   they belong to,
 * - styles are moved from the templates to the styleHost (i.e. the document head).
 *
 * Notes:
 * - styles are scoped to their component and will apply only to it,
 * - a common subset of shadow DOM selectors are supported,
 * - see `ShadowCss` for more information and limitations.
 */
class EmulatedScopedShadowDomStrategy
    extends EmulatedUnscopedShadowDomStrategy {
  EmulatedScopedShadowDomStrategy(styleHost) : super(styleHost) {
    /* super call moved to initializer */;
  }
  void processStyleElement(
      String hostComponentId, String templateUrl, styleEl) {
    var cssText = DOM.getText(styleEl);
    cssText = shimCssForComponent(cssText, hostComponentId);
    DOM.setText(styleEl, cssText);
    this._moveToStyleHost(styleEl);
  }
  void _moveToStyleHost(styleEl) {
    DOM.remove(styleEl);
    insertStyleElement(this.styleHost, styleEl);
  }
  void processElement(
      String hostComponentId, String elementComponentId, element) {
    // Shim the element as a child of the compiled component
    if (isPresent(hostComponentId)) {
      var contentAttribute =
          getContentAttribute(getComponentId(hostComponentId));
      DOM.setAttribute(element, contentAttribute, "");
    }
    // If the current element is also a component, shim it as a host
    if (isPresent(elementComponentId)) {
      var hostAttribute = getHostAttribute(getComponentId(elementComponentId));
      DOM.setAttribute(element, hostAttribute, "");
    }
  }
}
