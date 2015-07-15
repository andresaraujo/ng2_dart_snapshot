library angular2.src.render.dom.shadow_dom.native_shadow_dom_strategy;

import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "shadow_dom_strategy.dart" show ShadowDomStrategy;

/**
 * This strategies uses the native Shadow DOM support.
 *
 * The templates for the component are inserted in a Shadow Root created on the component element.
 * Hence they are strictly isolated.
 */
@Injectable()
class NativeShadowDomStrategy extends ShadowDomStrategy {
  dynamic prepareShadowRoot(el) {
    return DOM.createShadowRoot(el);
  }
}
