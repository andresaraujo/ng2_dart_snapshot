library angular2.src.mock.mock_location_strategy;

import "package:angular2/src/facade/async.dart"
    show EventEmitter, ObservableWrapper;
import "package:angular2/src/facade/collection.dart" show List;
import "package:angular2/src/router/location_strategy.dart"
    show LocationStrategy;

class MockLocationStrategy extends LocationStrategy {
  String internalBaseHref = "/";
  String internalPath = "/";
  String internalTitle = "";
  List<String> urlChanges = [];
  EventEmitter _subject = new EventEmitter();
  MockLocationStrategy() : super() {
    /* super call moved to initializer */;
  }
  void simulatePopState(url) {
    this.internalPath = url;
    ObservableWrapper.callNext(this._subject, null);
  }
  String path() {
    return this.internalPath;
  }
  void simulateUrlPop(String pathname) {
    ObservableWrapper.callNext(this._subject, {"url": pathname});
  }
  void pushState(dynamic ctx, String title, String url) {
    this.internalTitle = title;
    this.internalPath = url;
    this.urlChanges.add(url);
  }
  void onPopState(fn) {
    ObservableWrapper.subscribe(this._subject, fn);
  }
  String getBaseHref() {
    return this.internalBaseHref;
  }
}
