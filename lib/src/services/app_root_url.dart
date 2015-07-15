library angular2.src.services.app_root_url;

import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/facade/lang.dart" show isBlank;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;

/**
 * Specifies app root url for the application.
 *
 * Used by the {@link Compiler} when resolving HTML and CSS template URLs.
 *
 * This interface can be overridden by the application developer to create custom behavior.
 *
 * See {@link Compiler}
 */
@Injectable()
class AppRootUrl {
  String _value;
  /**
   * Returns the base URL of the currently running application.
   */
  get value {
    if (isBlank(this._value)) {
      var a = DOM.createElement("a");
      DOM.resolveAndSetHref(a, "./", null);
      this._value = DOM.getHref(a);
    }
    return this._value;
  }
}
