library angular2.src.router.location;

import "location_strategy.dart" show LocationStrategy;
import "package:angular2/src/facade/lang.dart" show StringWrapper, isPresent;
import "package:angular2/src/facade/async.dart"
    show EventEmitter, ObservableWrapper;
import "package:angular2/di.dart"
    show OpaqueToken, Injectable, Optional, Inject;

const OpaqueToken appBaseHrefToken = const OpaqueToken("locationHrefToken");
/**
 * This is the service that an application developer will directly interact with.
 *
 * Responsible for normalizing the URL against the application's base href.
 * A normalized URL is absolute from the URL host, includes the application's base href, and has no
 * trailing slash:
 * - `/my/app/user/123` is normalized
 * - `my/app/user/123` **is not** normalized
 * - `/my/app/user/123/` **is not** normalized
 */
@Injectable()
class Location {
  LocationStrategy _platformStrategy;
  EventEmitter _subject = new EventEmitter();
  String _baseHref;
  Location(this._platformStrategy,
      [@Optional() @Inject(appBaseHrefToken) String href]) {
    this._baseHref = stripTrailingSlash(stripIndexHtml(
        isPresent(href) ? href : this._platformStrategy.getBaseHref()));
    this._platformStrategy.onPopState((_) => this._onPopState(_));
  }
  void _onPopState(_) {
    ObservableWrapper.callNext(this._subject, {"url": this.path()});
  }
  String path() {
    return this.normalize(this._platformStrategy.path());
  }
  String normalize(String url) {
    return stripTrailingSlash(this._stripBaseHref(stripIndexHtml(url)));
  }
  String normalizeAbsolutely(String url) {
    if (!url.startsWith("/")) {
      url = "/" + url;
    }
    return stripTrailingSlash(this._addBaseHref(url));
  }
  String _stripBaseHref(String url) {
    if (this._baseHref.length > 0 && url.startsWith(this._baseHref)) {
      return url.substring(this._baseHref.length);
    }
    return url;
  }
  String _addBaseHref(String url) {
    if (!url.startsWith(this._baseHref)) {
      return this._baseHref + url;
    }
    return url;
  }
  void go(String url) {
    var finalUrl = this.normalizeAbsolutely(url);
    this._platformStrategy.pushState(null, "", finalUrl);
  }
  void forward() {
    this._platformStrategy.forward();
  }
  void back() {
    this._platformStrategy.back();
  }
  void subscribe(onNext, [onThrow = null, onReturn = null]) {
    ObservableWrapper.subscribe(this._subject, onNext, onThrow, onReturn);
  }
}
String stripIndexHtml(String url) {
  if (new RegExp(r'\/index.html$').hasMatch(url)) {
    // '/index.html'.length == 11
    return url.substring(0, url.length - 11);
  }
  return url;
}
String stripTrailingSlash(String url) {
  if (new RegExp(r'\/$').hasMatch(url)) {
    url = url.substring(0, url.length - 1);
  }
  return url;
}
