library angular2.src.services.anchor_based_app_root_url;

import "package:angular2/src/services/app_root_url.dart" show AppRootUrl;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/di.dart" show Injectable;

/**
 * Extension of {@link AppRootUrl} that uses a DOM anchor tag to set the root url to
 * the current page's url.
 */
@Injectable()
class AnchorBasedAppRootUrl extends AppRootUrl {
  AnchorBasedAppRootUrl() : super("") {
    /* super call moved to initializer */;
    // compute the root url to pass to AppRootUrl
    String rootUrl;
    var a = DOM.createElement("a");
    DOM.resolveAndSetHref(a, "./", null);
    rootUrl = DOM.getHref(a);
    this.value = rootUrl;
  }
}
