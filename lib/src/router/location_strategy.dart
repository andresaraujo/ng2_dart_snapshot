library angular2.src.router.location_strategy;

import "package:angular2/src/facade/lang.dart" show BaseException;

_abstract() {
  return new BaseException("This method is abstract");
}
class LocationStrategy {
  String path() {
    throw _abstract();
  }
  void pushState(dynamic ctx, String title, String url) {
    throw _abstract();
  }
  void forward() {
    throw _abstract();
  }
  void back() {
    throw _abstract();
  }
  void onPopState(fn) {
    throw _abstract();
  }
  String getBaseHref() {
    throw _abstract();
  }
}
