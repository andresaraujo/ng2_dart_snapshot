library angular2.src.http.http;

import "package:angular2/src/facade/lang.dart"
    show isString, isPresent, isBlank, makeTypeError;
import "package:angular2/src/di/decorators.dart" show Injectable;
import "interfaces.dart" show IRequestOptions, Connection, ConnectionBackend;
import "static_request.dart" show Request;
import "base_request_options.dart" show BaseRequestOptions, RequestOptions;
import "enums.dart" show RequestMethods;
import "package:angular2/src/facade/async.dart" show EventEmitter;

EventEmitter httpRequest(ConnectionBackend backend, Request request) {
  return backend.createConnection(request).response;
}
RequestOptions mergeOptions(defaultOpts, providedOpts, method, url) {
  var newOptions = defaultOpts;
  if (isPresent(providedOpts)) {
    // Hack so Dart can used named parameters
    newOptions = newOptions.merge(new RequestOptions(
        method: providedOpts.method,
        url: providedOpts.url,
        headers: providedOpts.headers,
        body: providedOpts.body,
        mode: providedOpts.mode,
        credentials: providedOpts.credentials,
        cache: providedOpts.cache));
  }
  if (isPresent(method)) {
    return newOptions.merge(new RequestOptions(method: method, url: url));
  } else {
    return newOptions.merge(new RequestOptions(url: url));
  }
}
/**
 * Performs http requests using `XMLHttpRequest` as the default backend.
 *
 * `Http` is available as an injectable class, with methods to perform http requests. Calling
 * `request` returns an {@link EventEmitter} which will emit a single {@link Response} when a
 * response is received.
 *
 *
 * ## Breaking Change
 *
 * Previously, methods of `Http` would return an RxJS Observable directly. For now,
 * the `toRx()` method of {@link EventEmitter} needs to be called in order to get the RxJS
 * Subject. `EventEmitter` does not provide combinators like `map`, and has different semantics for
 * subscribing/observing. This is temporary; the result of all `Http` method calls will be either an
 * Observable
 * or Dart Stream when [issue #2794](https://github.com/angular/angular/issues/2794) is resolved.
 *
 * #Example
 *
 * ```
 * import {Http, httpInjectables} from 'angular2/http';
 * @Component({selector: 'http-app', viewBindings: [httpInjectables]})
 * @View({templateUrl: 'people.html'})
 * class PeopleComponent {
 *   constructor(http: Http) {
 *     http.get('people.json')
 *       //Get the RxJS Subject
 *       .toRx()
 *       // Call map on the response observable to get the parsed people object
 *       .map(res => res.json())
 *       // Subscribe to the observable to get the parsed people object and attach it to the
 *       // component
 *       .subscribe(people => this.people = people);
 *   }
 * }
 * ```
 *
 * To use the {@link EventEmitter} returned by `Http`, simply pass a generator (See "interface
 *Generator" in the Async Generator spec: https://github.com/jhusain/asyncgenerator) to the
 *`observer` method of the returned emitter, with optional methods of `next`, `throw`, and `return`.
 *
 * #Example
 *
 * ```
 * http.get('people.json').observer({next: (value) => this.people = people});
 * ```
 *
 * The default construct used to perform requests, `XMLHttpRequest`, is abstracted as a "Backend" (
 * {@link XHRBackend} in this case), which could be mocked with dependency injection by replacing
 * the {@link XHRBackend} binding, as in the following example:
 *
 * #Example
 *
 * ```
 * import {MockBackend, BaseRequestOptions, Http} from 'angular2/http';
 * var injector = Injector.resolveAndCreate([
 *   BaseRequestOptions,
 *   MockBackend,
 *   bind(Http).toFactory(
 *       function(backend, defaultOptions) {
 *         return new Http(backend, defaultOptions);
 *       },
 *       [MockBackend, BaseRequestOptions])
 * ]);
 * var http = injector.get(Http);
 * http.get('request-from-mock-backend.json').toRx().subscribe((res:Response) => doSomething(res));
 * ```
 *
 **/
@Injectable()
class Http {
  ConnectionBackend _backend;
  RequestOptions _defaultOptions;
  Http(this._backend, this._defaultOptions) {}
  /**
   * Performs any type of http request. First argument is required, and can either be a url or
   * a {@link Request} instance. If the first argument is a url, an optional {@link RequestOptions}
   * object can be provided as the 2nd argument. The options object will be merged with the values
   * of {@link BaseRequestOptions} before performing the request.
   */
  EventEmitter request(dynamic /* String | Request */ url,
      [IRequestOptions options]) {
    EventEmitter responseObservable;
    if (isString(url)) {
      responseObservable = httpRequest(this._backend, new Request(mergeOptions(
          this._defaultOptions, options, RequestMethods.GET, url)));
    } else if (url is Request) {
      responseObservable = httpRequest(this._backend, url);
    }
    return responseObservable;
  }
  /**
   * Performs a request with `get` http method.
   */
  EventEmitter get(String url, [IRequestOptions options]) {
    return httpRequest(this._backend, new Request(
        mergeOptions(this._defaultOptions, options, RequestMethods.GET, url)));
  }
  /**
   * Performs a request with `post` http method.
   */
  EventEmitter post(String url, String body, [IRequestOptions options]) {
    return httpRequest(this._backend, new Request(mergeOptions(
        this._defaultOptions.merge(new RequestOptions(body: body)), options,
        RequestMethods.POST, url)));
  }
  /**
   * Performs a request with `put` http method.
   */
  EventEmitter put(String url, String body, [IRequestOptions options]) {
    return httpRequest(this._backend, new Request(mergeOptions(
        this._defaultOptions.merge(new RequestOptions(body: body)), options,
        RequestMethods.PUT, url)));
  }
  /**
   * Performs a request with `delete` http method.
   */
  EventEmitter delete(String url, [IRequestOptions options]) {
    return httpRequest(this._backend, new Request(mergeOptions(
        this._defaultOptions, options, RequestMethods.DELETE, url)));
  }
  /**
   * Performs a request with `patch` http method.
   */
  EventEmitter patch(String url, String body, [IRequestOptions options]) {
    return httpRequest(this._backend, new Request(mergeOptions(
        this._defaultOptions.merge(new RequestOptions(body: body)), options,
        RequestMethods.PATCH, url)));
  }
  /**
   * Performs a request with `head` http method.
   */
  EventEmitter head(String url, [IRequestOptions options]) {
    return httpRequest(this._backend, new Request(
        mergeOptions(this._defaultOptions, options, RequestMethods.HEAD, url)));
  }
}
@Injectable()
class Jsonp extends Http {
  Jsonp(ConnectionBackend backend, RequestOptions defaultOptions)
      : super(backend, defaultOptions) {
    /* super call moved to initializer */;
  }
  /**
   * Performs any type of http request. First argument is required, and can either be a url or
   * a {@link Request} instance. If the first argument is a url, an optional {@link RequestOptions}
   * object can be provided as the 2nd argument. The options object will be merged with the values
   * of {@link BaseRequestOptions} before performing the request.
   */
  EventEmitter request(dynamic /* String | Request */ url,
      [IRequestOptions options]) {
    EventEmitter responseObservable;
    if (isString(url)) {
      url = new Request(
          mergeOptions(this._defaultOptions, options, RequestMethods.GET, url));
    }
    if (url is Request) {
      if (!identical(url.method, RequestMethods.GET)) {
        makeTypeError("JSONP requests must use GET request method.");
      }
      responseObservable = httpRequest(this._backend, url);
    }
    return responseObservable;
  }
}
