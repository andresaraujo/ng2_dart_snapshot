library angular2.src.http.backends.jsonp_backend;

import "../interfaces.dart" show ConnectionBackend, Connection;
import "../enums.dart" show ReadyStates, RequestMethods, RequestMethodsMap;
import "../static_request.dart" show Request;
import "../static_response.dart" show Response;
import "../base_response_options.dart"
    show ResponseOptions, BaseResponseOptions;
import "package:angular2/di.dart" show Injectable;
import "browser_jsonp.dart" show BrowserJsonp;
import "package:angular2/src/facade/async.dart"
    show EventEmitter, ObservableWrapper;
import "package:angular2/src/facade/lang.dart"
    show StringWrapper, isPresent, ENUM_INDEX, makeTypeError;

class JSONPConnection implements Connection {
  BrowserJsonp _dom;
  ResponseOptions baseResponseOptions;
  ReadyStates readyState;
  Request request;
  EventEmitter response;
  String _id;
  dynamic _script;
  dynamic _responseData;
  bool _finished = false;
  JSONPConnection(Request req, this._dom, [this.baseResponseOptions]) {
    if (!identical(req.method, RequestMethods.GET)) {
      throw makeTypeError("JSONP requests must use GET request method.");
    }
    this.request = req;
    this.response = new EventEmitter();
    this.readyState = ReadyStates.LOADING;
    this._id = _dom.nextRequestID();
    _dom.exposeConnection(this._id, this);
    // Workaround Dart

    // url = url.replace(/=JSONP_CALLBACK(&|$)/, `generated method`);
    var callback = _dom.requestCallback(this._id);
    String url = req.url;
    if (url.indexOf("=JSONP_CALLBACK&") > -1) {
      url =
          StringWrapper.replace(url, "=JSONP_CALLBACK&", '''=${ callback}&''');
    } else if (identical(url.lastIndexOf("=JSONP_CALLBACK"),
        url.length - "=JSONP_CALLBACK".length)) {
      url = StringWrapper.substring(
              url, 0, url.length - "=JSONP_CALLBACK".length) +
          '''=${ callback}''';
    }
    var script = this._script = _dom.build(url);
    script.addEventListener("load", (event) {
      if (identical(this.readyState, ReadyStates.CANCELLED)) return;
      this.readyState = ReadyStates.DONE;
      _dom.cleanup(script);
      if (!this._finished) {
        ObservableWrapper.callThrow(this.response,
            makeTypeError("JSONP injected script did not invoke callback."));
        return;
      }
      var responseOptions = new ResponseOptions(body: this._responseData);
      if (isPresent(this.baseResponseOptions)) {
        responseOptions = this.baseResponseOptions.merge(responseOptions);
      }
      ObservableWrapper.callNext(this.response, new Response(responseOptions));
    });
    script.addEventListener("error", (error) {
      if (identical(this.readyState, ReadyStates.CANCELLED)) return;
      this.readyState = ReadyStates.DONE;
      _dom.cleanup(script);
      ObservableWrapper.callThrow(this.response, error);
    });
    _dom.send(script);
  }
  finished([dynamic data]) {
    // Don't leak connections
    this._finished = true;
    this._dom.removeConnection(this._id);
    if (identical(this.readyState, ReadyStates.CANCELLED)) return;
    this._responseData = data;
  }
  void dispose() {
    this.readyState = ReadyStates.CANCELLED;
    var script = this._script;
    this._script = null;
    if (isPresent(script)) {
      this._dom.cleanup(script);
    }
    ObservableWrapper.callReturn(this.response);
  }
}
@Injectable()
class JSONPBackend implements ConnectionBackend {
  BrowserJsonp _browserJSONP;
  ResponseOptions _baseResponseOptions;
  JSONPBackend(this._browserJSONP, this._baseResponseOptions) {}
  JSONPConnection createConnection(Request request) {
    return new JSONPConnection(
        request, this._browserJSONP, this._baseResponseOptions);
  }
}
