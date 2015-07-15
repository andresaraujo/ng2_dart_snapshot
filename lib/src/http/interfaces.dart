/// <reference path="../../typings/rx/rx.d.ts" />
library angular2.src.http.interfaces;

import "enums.dart"
    show
        ReadyStates,
        RequestModesOpts,
        RequestMethods,
        RequestCacheOpts,
        RequestCredentialsOpts,
        ResponseTypes;
import "headers.dart" show Headers;
import "package:angular2/src/facade/lang.dart" show BaseException;
import "package:angular2/src/facade/async.dart" show EventEmitter;
import "static_request.dart" show Request;

/**
 * Abstract class from which real backends are derived.
 *
 * The primary purpose of a `ConnectionBackend` is to create new connections to fulfill a given
 * {@link Request}.
 */
class ConnectionBackend {
  ConnectionBackend() {}
  Connection createConnection(dynamic request) {
    throw new BaseException("Abstract!");
  }
}
/**
 * Abstract class from which real connections are derived.
 */
class Connection {
  ReadyStates readyState;
  Request request;
  EventEmitter response;
  void dispose() {
    throw new BaseException("Abstract!");
  }
}
/**
 * Interface for options to construct a Request, based on
 * [RequestInit](https://fetch.spec.whatwg.org/#requestinit) from the Fetch spec.
 */
abstract class IRequestOptions {
  String url;
  RequestMethods method;
  Headers headers;
  // TODO: Support Blob, ArrayBuffer, JSON, URLSearchParams, FormData
  String body;
  RequestModesOpts mode;
  RequestCredentialsOpts credentials;
  RequestCacheOpts cache;
}
/**
 * Interface for options to construct a Response, based on
 * [ResponseInit](https://fetch.spec.whatwg.org/#responseinit) from the Fetch spec.
 */
abstract class IResponseOptions {
  // TODO: Support Blob, ArrayBuffer, JSON
  dynamic /* String | Object | FormData */ body;
  num status;
  String statusText;
  Headers headers;
  ResponseTypes type;
  String url;
}
