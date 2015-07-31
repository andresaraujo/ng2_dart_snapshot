library angular2.src.services.app_root_url;

import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/facade/lang.dart" show isBlank;

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
  AppRootUrl(String value) {
    this._value = value;
  }
  /**
   * Returns the base URL of the currently running application.
   */
  get value {
    return this._value;
  }
  set value(String value) {
    this._value = value;
  }
}
