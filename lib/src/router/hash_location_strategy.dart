library angular2.src.router.hash_location_strategy;

import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/di.dart" show Injectable;
import "location_strategy.dart" show LocationStrategy;
import "package:angular2/src/facade/browser.dart"
    show EventListener, History, Location;

@Injectable()
class HashLocationStrategy extends LocationStrategy {
  Location _location;
  History _history;
  HashLocationStrategy() : super() {
    /* super call moved to initializer */;
    this._location = DOM.getLocation();
    this._history = DOM.getHistory();
  }
  void onPopState(EventListener fn) {
    DOM.getGlobalEventTarget("window").addEventListener("popstate", fn, false);
  }
  String getBaseHref() {
    return "";
  }
  String path() {
    // the hash value is always prefixed with a `#`

    // and if it is empty then it will stay empty
    var path = this._location.hash;
    // Dart will complain if a call to substring is

    // executed with a position value that extends the

    // length of string.
    return path.length > 0 ? path.substring(1) : path;
  }
  pushState(dynamic state, String title, String url) {
    this._history.pushState(state, title, "#" + url);
  }
  void forward() {
    this._history.forward();
  }
  void back() {
    this._history.back();
  }
}
