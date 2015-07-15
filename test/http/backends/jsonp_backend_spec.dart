library angular2.test.http.backends.jsonp_backend_spec;

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
import "package:angular2/src/http/backends/browser_jsonp.dart"
    show BrowserJsonp;
import "package:angular2/src/http/backends/jsonp_backend.dart"
    show JSONPConnection, JSONPBackend;
import "package:angular2/di.dart" show bind, Injector;
import "package:angular2/src/facade/lang.dart" show isPresent, StringWrapper;
import "package:angular2/src/facade/async.dart" show TimerWrapper;
import "package:angular2/src/http/static_request.dart" show Request;
import "package:angular2/src/facade/collection.dart" show Map;
import "package:angular2/src/http/base_request_options.dart"
    show RequestOptions, BaseRequestOptions;
import "package:angular2/src/http/base_response_options.dart"
    show BaseResponseOptions, ResponseOptions;
import "package:angular2/src/http/enums.dart"
    show ResponseTypes, ReadyStates, RequestMethods;

var addEventListenerSpy;
var existingScripts = [];
class MockBrowserJsonp extends BrowserJsonp {
  String src;
  Map<String, dynamic /* (data: any) => any */ > callbacks;
  MockBrowserJsonp() : super() {
    /* super call moved to initializer */;
    this.callbacks = new Map();
  }
  addEventListener(String type, dynamic /* (data: any) => any */ cb) {
    this.callbacks[type] = cb;
  }
  dispatchEvent(String type, [dynamic argument]) {
    if (!isPresent(argument)) {
      argument = {};
    }
    this.callbacks[type](argument);
  }
  build(String url) {
    var script = new MockBrowserJsonp();
    script.src = url;
    existingScripts.add(script);
    return script;
  }
  send(dynamic node) {}
  cleanup(dynamic node) {}
}
main() {
  describe("JSONPBackend", () {
    var backend;
    var sampleRequest;
    beforeEach(() {
      var injector = Injector.resolveAndCreate([
        bind(ResponseOptions).toClass(BaseResponseOptions),
        bind(BrowserJsonp).toClass(MockBrowserJsonp),
        JSONPBackend
      ]);
      backend = injector.get(JSONPBackend);
      var base = new BaseRequestOptions();
      sampleRequest = new Request(
          base.merge(new RequestOptions(url: "https://google.com")));
    });
    afterEach(() {
      existingScripts = [];
    });
    it("should create a connection", () {
      var instance;
      expect(() => instance = backend.createConnection(sampleRequest)).not
          .toThrow();
      expect(instance).toBeAnInstanceOf(JSONPConnection);
    });
    describe("JSONPConnection", () {
      it("should use the injected BaseResponseOptions to create the response",
          inject([AsyncTestCompleter], (async) {
        var connection = new JSONPConnection(sampleRequest,
            new MockBrowserJsonp(),
            new ResponseOptions(type: ResponseTypes.Error));
        ObservableWrapper.subscribe(connection.response, (res) {
          expect(res.type).toBe(ResponseTypes.Error);
          async.done();
        });
        connection.finished();
        existingScripts[0].dispatchEvent("load");
      }));
      it("should ignore load/callback when disposed", inject(
          [AsyncTestCompleter], (async) {
        var connection =
            new JSONPConnection(sampleRequest, new MockBrowserJsonp());
        var spy = new SpyObject();
        var loadSpy = spy.spy("load");
        var errorSpy = spy.spy("error");
        var returnSpy = spy.spy("cancelled");
        ObservableWrapper.subscribe(
            connection.response, loadSpy, errorSpy, returnSpy);
        connection.dispose();
        expect(connection.readyState).toBe(ReadyStates.CANCELLED);
        connection.finished("Fake data");
        existingScripts[0].dispatchEvent("load");
        TimerWrapper.setTimeout(() {
          expect(loadSpy).not.toHaveBeenCalled();
          expect(errorSpy).not.toHaveBeenCalled();
          expect(returnSpy).toHaveBeenCalled();
          async.done();
        }, 10);
      }));
      it("should report error if loaded without invoking callback", inject(
          [AsyncTestCompleter], (async) {
        var connection =
            new JSONPConnection(sampleRequest, new MockBrowserJsonp());
        ObservableWrapper.subscribe(connection.response, (res) {
          expect("response listener called").toBe(false);
          async.done();
        }, (err) {
          expect(StringWrapper.contains(err.message, "did not invoke callback"))
              .toBe(true);
          async.done();
        });
        existingScripts[0].dispatchEvent("load");
      }));
      it("should report error if script contains error", inject(
          [AsyncTestCompleter], (async) {
        var connection =
            new JSONPConnection(sampleRequest, new MockBrowserJsonp());
        ObservableWrapper.subscribe(connection.response, (res) {
          expect("response listener called").toBe(false);
          async.done();
        }, (err) {
          expect(err["message"]).toBe("Oops!");
          async.done();
        });
        existingScripts[0].dispatchEvent("error", ({"message": "Oops!"}));
      }));
      it("should throw if request method is not GET", () {
        [
          RequestMethods.POST,
          RequestMethods.PUT,
          RequestMethods.DELETE,
          RequestMethods.OPTIONS,
          RequestMethods.HEAD,
          RequestMethods.PATCH
        ].forEach((method) {
          var base = new BaseRequestOptions();
          var req = new Request(base.merge(
              new RequestOptions(url: "https://google.com", method: method)));
          expect(() => new JSONPConnection(req, new MockBrowserJsonp()))
              .toThrowError();
        });
      });
      it("should respond with data passed to callback", inject(
          [AsyncTestCompleter], (async) {
        var connection =
            new JSONPConnection(sampleRequest, new MockBrowserJsonp());
        ObservableWrapper.subscribe(connection.response, (res) {
          expect(res.json())
              .toEqual(({"fake_payload": true, "blob_id": 12345}));
          async.done();
        });
        connection.finished(({"fake_payload": true, "blob_id": 12345}));
        existingScripts[0].dispatchEvent("load");
      }));
    });
  });
}
