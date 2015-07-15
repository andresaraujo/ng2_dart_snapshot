library angular2.src.http.enums;

import "package:angular2/src/facade/collection.dart" show Map, StringMapWrapper;

/**
 * Acceptable origin modes to be associated with a {@link Request}, based on
 * [RequestMode](https://fetch.spec.whatwg.org/#requestmode) from the Fetch spec.
 */
enum RequestModesOpts { Cors, NoCors, SameOrigin }
/**
 * Acceptable cache option to be associated with a {@link Request}, based on
 * [RequestCache](https://fetch.spec.whatwg.org/#requestcache) from the Fetch spec.
 */
enum RequestCacheOpts {
  Default,
  NoStore,
  Reload,
  NoCache,
  ForceCache,
  OnlyIfCached
}
/**
 * Acceptable credentials option to be associated with a {@link Request}, based on
 * [RequestCredentials](https://fetch.spec.whatwg.org/#requestcredentials) from the Fetch spec.
 */
enum RequestCredentialsOpts { Omit, SameOrigin, Include }
/**
 * Supported http methods.
 */
enum RequestMethods { GET, POST, PUT, DELETE, OPTIONS, HEAD, PATCH }
// TODO: Remove this when enum lookups are available in ts2dart

// https://github.com/angular/ts2dart/issues/221
class RequestMethodsMap {
  List<String> _methods;
  RequestMethodsMap() {
    this._methods = [
      "GET",
      "POST",
      "PUT",
      "DELETE",
      "OPTIONS",
      "HEAD",
      "PATCH"
    ];
  }
  String getMethod(int method) {
    return this._methods[method];
  }
}
/**
 * All possible states in which a connection can be, based on
 * [States](http://www.w3.org/TR/XMLHttpRequest/#states) from the `XMLHttpRequest` spec, but with an
 * additional "CANCELLED" state.
 */
enum ReadyStates { UNSENT, OPEN, HEADERS_RECEIVED, LOADING, DONE, CANCELLED }
/**
 * Acceptable response types to be associated with a {@link Response}, based on
 * [ResponseType](https://fetch.spec.whatwg.org/#responsetype) from the Fetch spec.
 */
enum ResponseTypes { Basic, Cors, Default, Error, Opaque }
