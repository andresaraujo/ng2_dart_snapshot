library angular2.src.http.backends.xhr_backend;

import "../interfaces.dart" show ConnectionBackend, Connection;
import "../enums.dart" show ReadyStates, RequestMethods, RequestMethodsMap;
import "../static_request.dart" show Request;
import "../static_response.dart" show Response;
import "../base_response_options.dart"
    show ResponseOptions, BaseResponseOptions;
import "package:angular2/di.dart" show Injectable;
import "browser_xhr.dart" show BrowserXhr;
import "package:angular2/src/facade/async.dart"
    show EventEmitter, ObservableWrapper;
import "package:angular2/src/facade/lang.dart" show isPresent, ENUM_INDEX;

/**
 * Creates connections using `XMLHttpRequest`. Given a fully-qualified
 * request, an `XHRConnection` will immediately create an `XMLHttpRequest` object and send the
 * request.
 *
 * This class would typically not be created or interacted with directly inside applications, though
 * the {@link MockConnection} may be interacted with in tests.
 */
class XHRConnection implements Connection {
  Request request;
  /**
   * Response {@link EventEmitter} which emits a single {@link Response} value on load event of
   * `XMLHttpRequest`.
   */
  EventEmitter response;
  ReadyStates readyState;
  var _xhr;
  // https://github.com/angular/ts2dart/issues/230
  XHRConnection(Request req, BrowserXhr browserXHR,
      [ResponseOptions baseResponseOptions]) {
    // TODO: get rid of this when enum lookups are available in ts2dart

    // https://github.com/angular/ts2dart/issues/221
    var requestMethodsMap = new RequestMethodsMap();
    this.request = req;
    this.response = new EventEmitter();
    this._xhr = browserXHR.build();
    // TODO(jeffbcross): implement error listening/propagation
    this._xhr.open(
        requestMethodsMap.getMethod(ENUM_INDEX(req.method)), req.url);
    this._xhr.addEventListener("load", (_) {
      var responseOptions = new ResponseOptions(
          body: isPresent(this._xhr.response)
              ? this._xhr.response
              : this._xhr.responseText);
      if (isPresent(baseResponseOptions)) {
        responseOptions = baseResponseOptions.merge(responseOptions);
      }
      ObservableWrapper.callNext(this.response, new Response(responseOptions));
      // TODO(gdi2290): defer complete if array buffer until done
      ObservableWrapper.callReturn(this.response);
    });
    // TODO(jeffbcross): make this more dynamic based on body type
    if (isPresent(req.headers)) {
      req.headers.forEach((value, name) {
        this._xhr.setRequestHeader(name, value);
      });
    }
    this._xhr.send(this.request.text());
  }
  /**
   * Calls abort on the underlying XMLHttpRequest.
   */
  void dispose() {
    this._xhr.abort();
  }
}
/**
 * Creates {@link XHRConnection} instances.
 *
 * This class would typically not be used by end users, but could be
 * overridden if a different backend implementation should be used,
 * such as in a node backend.
 *
 * #Example
 *
 * ```
 * import {Http, MyNodeBackend, httpInjectables, BaseRequestOptions} from 'angular2/http';
 * @Component({
 *   viewBindings: [
 *     httpInjectables,
 *     bind(Http).toFactory((backend, options) => {
 *       return new Http(backend, options);
 *     }, [MyNodeBackend, BaseRequestOptions])]
 * })
 * class MyComponent {
 *   constructor(http:Http) {
 *     http('people.json').subscribe(res => this.people = res.json());
 *   }
 * }
 * ```
 *
 **/
@Injectable()
class XHRBackend implements ConnectionBackend {
  BrowserXhr _browserXHR;
  ResponseOptions _baseResponseOptions;
  XHRBackend(this._browserXHR, this._baseResponseOptions) {}
  XHRConnection createConnection(Request request) {
    return new XHRConnection(
        request, this._browserXHR, this._baseResponseOptions);
  }
}
