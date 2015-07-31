library angular2.test.http.backends.xhr_backend_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        afterEach,
        beforeEach,
        ddescribe,
        describe,
        expect,
        iit,
        inject,
        it,
        xit,
        SpyObject;
import "package:angular2/src/facade/async.dart" show ObservableWrapper;
import "package:angular2/src/http/backends/browser_xhr.dart" show BrowserXhr;
import "package:angular2/src/http/backends/xhr_backend.dart"
    show XHRConnection, XHRBackend;
import "package:angular2/di.dart" show bind, Injector;
import "package:angular2/src/http/static_request.dart" show Request;
import "package:angular2/src/http/static_response.dart" show Response;
import "package:angular2/src/http/headers.dart" show Headers;
import "package:angular2/src/facade/collection.dart" show Map;
import "package:angular2/src/http/base_request_options.dart"
    show RequestOptions, BaseRequestOptions;
import "package:angular2/src/http/base_response_options.dart"
    show BaseResponseOptions, ResponseOptions;
import "package:angular2/src/http/enums.dart" show ResponseTypes;

var abortSpy;
var sendSpy;
var openSpy;
var setRequestHeaderSpy;
var addEventListenerSpy;
var existingXHRs = [];
Response unused;
class MockBrowserXHR extends BrowserXhr {
  dynamic abort;
  dynamic send;
  dynamic open;
  dynamic response;
  String responseText;
  dynamic setRequestHeader;
  Map<String, Function> callbacks;
  MockBrowserXHR() : super() {
    /* super call moved to initializer */;
    var spy = new SpyObject();
    this.abort = abortSpy = spy.spy("abort");
    this.send = sendSpy = spy.spy("send");
    this.open = openSpy = spy.spy("open");
    this.setRequestHeader = setRequestHeaderSpy = spy.spy("setRequestHeader");
    this.callbacks = new Map();
  }
  addEventListener(String type, Function cb) {
    this.callbacks[type] = cb;
  }
  dispatchEvent(String type) {
    this.callbacks[type]({});
  }
  build() {
    var xhr = new MockBrowserXHR();
    existingXHRs.add(xhr);
    return xhr;
  }
}
main() {
  describe("XHRBackend", () {
    var backend;
    var sampleRequest;
    beforeEach(() {
      var injector = Injector.resolveAndCreate([
        bind(ResponseOptions).toClass(BaseResponseOptions),
        bind(BrowserXhr).toClass(MockBrowserXHR),
        XHRBackend
      ]);
      backend = injector.get(XHRBackend);
      var base = new BaseRequestOptions();
      sampleRequest = new Request(
          base.merge(new RequestOptions(url: "https://google.com")));
    });
    afterEach(() {
      existingXHRs = [];
    });
    it("should create a connection", () {
      expect(() => backend.createConnection(sampleRequest)).not.toThrow();
    });
    describe("XHRConnection", () {
      it("should use the injected BaseResponseOptions to create the response",
          inject([AsyncTestCompleter], (async) {
        var connection = new XHRConnection(sampleRequest, new MockBrowserXHR(),
            new ResponseOptions(type: ResponseTypes.Error));
        ObservableWrapper.subscribe(connection.response, (res) {
          expect(res.type).toBe(ResponseTypes.Error);
          async.done();
        });
        existingXHRs[0].dispatchEvent("load");
      }));
      it("should complete a request", inject([AsyncTestCompleter], (async) {
        var connection = new XHRConnection(sampleRequest, new MockBrowserXHR(),
            new ResponseOptions(type: ResponseTypes.Error));
        ObservableWrapper.subscribe(connection.response, (res) {
          expect(res.type).toBe(ResponseTypes.Error);
        }, null, () {
          async.done();
        });
        existingXHRs[0].dispatchEvent("load");
      }));
      it("should call abort when disposed", () {
        var connection = new XHRConnection(sampleRequest, new MockBrowserXHR());
        connection.dispose();
        expect(abortSpy).toHaveBeenCalled();
      });
      it("should automatically call open with method and url", () {
        new XHRConnection(sampleRequest, new MockBrowserXHR());
        expect(openSpy).toHaveBeenCalledWith("GET", sampleRequest.url);
      });
      it("should automatically call send on the backend with request body", () {
        var body = "Some body to love";
        var base = new BaseRequestOptions();
        new XHRConnection(
            new Request(base.merge(new RequestOptions(body: body))),
            new MockBrowserXHR());
        expect(sendSpy).toHaveBeenCalledWith(body);
      });
      it("should attach headers to the request", () {
        var headers =
            new Headers({"Content-Type": "text/xml", "Breaking-Bad": "<3"});
        var base = new BaseRequestOptions();
        new XHRConnection(
            new Request(base.merge(new RequestOptions(headers: headers))),
            new MockBrowserXHR());
        expect(setRequestHeaderSpy).toHaveBeenCalledWith(
            "Content-Type", ["text/xml"]);
        expect(setRequestHeaderSpy).toHaveBeenCalledWith(
            "Breaking-Bad", ["<3"]);
      });
    });
  });
}
