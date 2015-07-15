library angular2.src.router.html5_location_strategy;

import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/facade/browser.dart"
    show EventListener, History, Location;
import "location_strategy.dart" show LocationStrategy;

@Injectable()
class HTML5LocationStrategy extends LocationStrategy {
  Location _location;
  History _history;
  String _baseHref;
  HTML5LocationStrategy() : super() {
    /* super call moved to initializer */;
    this._location = DOM.getLocation();
    this._history = DOM.getHistory();
    this._baseHref = DOM.getBaseHref();
  }
  void onPopState(EventListener fn) {
    DOM.getGlobalEventTarget("window").addEventListener("popstate", fn, false);
  }
  String getBaseHref() {
    return this._baseHref;
  }
  String path() {
    return this._location.pathname;
  }
  pushState(dynamic state, String title, String url) {
    this._history.pushState(state, title, url);
  }
  void forward() {
    this._history.forward();
  }
  void back() {
    this._history.back();
  }
}
