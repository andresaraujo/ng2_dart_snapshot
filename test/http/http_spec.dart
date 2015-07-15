library angular2.test.http.http_spec;

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
import "package:angular2/src/http/http.dart" show Http;
import "package:angular2/di.dart" show Injector, bind;
import "package:angular2/src/http/backends/mock_backend.dart" show MockBackend;
import "package:angular2/src/http/static_response.dart" show Response;
import "package:angular2/src/http/enums.dart" show RequestMethods;
import "package:angular2/src/http/base_request_options.dart"
    show BaseRequestOptions, RequestOptions;
import "package:angular2/src/http/base_response_options.dart"
    show ResponseOptions;
import "package:angular2/src/http/static_request.dart" show Request;
import "package:angular2/src/facade/async.dart"
    show EventEmitter, ObservableWrapper;
import "package:angular2/src/http/interfaces.dart" show ConnectionBackend;

class SpyObserver extends SpyObject {
  Function onNext;
  Function onError;
  Function onCompleted;
  SpyObserver() : super() {
    /* super call moved to initializer */;
    this.onNext = this.spy("onNext");
    this.onError = this.spy("onError");
    this.onCompleted = this.spy("onCompleted");
  }
}
main() {
  describe("http", () {
    var url = "http://foo.bar";
    Http http;
    Injector injector;
    MockBackend backend;
    var baseResponse;
    beforeEach(() {
      injector = Injector.resolveAndCreate([
        BaseRequestOptions,
        MockBackend,
        bind(Http).toFactory((ConnectionBackend backend,
            BaseRequestOptions defaultOptions) {
          return new Http(backend, defaultOptions);
        }, [MockBackend, BaseRequestOptions])
      ]);
      http = injector.get(Http);
      backend = injector.get(MockBackend);
      baseResponse = new Response(new ResponseOptions(body: "base response"));
    });
    afterEach(() => backend.verifyNoPendingRequests());
    describe("Http", () {
      describe(".request()", () {
        it("should return an Observable", () {
          expect(ObservableWrapper.isObservable(http.request(url))).toBe(true);
        });
        it("should accept a fully-qualified request as its only parameter",
            inject([AsyncTestCompleter], (async) {
          ObservableWrapper.subscribe(backend.connections, (c) {
            expect(c.request.url).toBe("https://google.com");
            c.mockRespond(new Response(new ResponseOptions(body: "Thank you")));
            async.done();
          });
          ObservableWrapper.subscribe(http.request(
                  new Request(new RequestOptions(url: "https://google.com"))),
              (res) {});
        }));
        it("should perform a get request for given url if only passed a string",
            inject([AsyncTestCompleter], (async) {
          ObservableWrapper.subscribe(
              backend.connections, (c) => c.mockRespond(baseResponse));
          ObservableWrapper.subscribe(http.request("http://basic.connection"),
              (res) {
            expect(res.text()).toBe("base response");
            async.done();
          });
        }));
      });
      describe(".get()", () {
        it("should perform a get request for given url", inject(
            [AsyncTestCompleter], (async) {
          ObservableWrapper.subscribe(backend.connections, (c) {
            expect(c.request.method).toBe(RequestMethods.GET);
            backend.resolveAllConnections();
            async.done();
          });
          ObservableWrapper.subscribe(http.get(url), (res) {});
        }));
      });
      describe(".post()", () {
        it("should perform a post request for given url", inject(
            [AsyncTestCompleter], (async) {
          ObservableWrapper.subscribe(backend.connections, (c) {
            expect(c.request.method).toBe(RequestMethods.POST);
            backend.resolveAllConnections();
            async.done();
          });
          ObservableWrapper.subscribe(http.post(url, "post me"), (res) {});
        }));
        it("should attach the provided body to the request", inject(
            [AsyncTestCompleter], (async) {
          var body = "this is my post body";
          ObservableWrapper.subscribe(backend.connections, (c) {
            expect(c.request.text()).toBe(body);
            backend.resolveAllConnections();
            async.done();
          });
          ObservableWrapper.subscribe(http.post(url, body), (res) {});
        }));
      });
      describe(".put()", () {
        it("should perform a put request for given url", inject(
            [AsyncTestCompleter], (async) {
          ObservableWrapper.subscribe(backend.connections, (c) {
            expect(c.request.method).toBe(RequestMethods.PUT);
            backend.resolveAllConnections();
            async.done();
          });
          ObservableWrapper.subscribe(http.put(url, "put me"), (res) {});
        }));
        it("should attach the provided body to the request", inject(
            [AsyncTestCompleter], (async) {
          var body = "this is my put body";
          ObservableWrapper.subscribe(backend.connections, (c) {
            expect(c.request.text()).toBe(body);
            backend.resolveAllConnections();
            async.done();
          });
          ObservableWrapper.subscribe(http.put(url, body), (res) {});
        }));
      });
      describe(".delete()", () {
        it("should perform a delete request for given url", inject(
            [AsyncTestCompleter], (async) {
          ObservableWrapper.subscribe(backend.connections, (c) {
            expect(c.request.method).toBe(RequestMethods.DELETE);
            backend.resolveAllConnections();
            async.done();
          });
          ObservableWrapper.subscribe(http.delete(url), (res) {});
        }));
      });
      describe(".patch()", () {
        it("should perform a patch request for given url", inject(
            [AsyncTestCompleter], (async) {
          ObservableWrapper.subscribe(backend.connections, (c) {
            expect(c.request.method).toBe(RequestMethods.PATCH);
            backend.resolveAllConnections();
            async.done();
          });
          ObservableWrapper.subscribe(
              http.patch(url, "this is my patch body"), (res) {});
        }));
        it("should attach the provided body to the request", inject(
            [AsyncTestCompleter], (async) {
          var body = "this is my patch body";
          ObservableWrapper.subscribe(backend.connections, (c) {
            expect(c.request.text()).toBe(body);
            backend.resolveAllConnections();
            async.done();
          });
          ObservableWrapper.subscribe(http.patch(url, body), (res) {});
        }));
      });
      describe(".head()", () {
        it("should perform a head request for given url", inject(
            [AsyncTestCompleter], (async) {
          ObservableWrapper.subscribe(backend.connections, (c) {
            expect(c.request.method).toBe(RequestMethods.HEAD);
            backend.resolveAllConnections();
            async.done();
          });
          ObservableWrapper.subscribe(http.head(url), (res) {});
        }));
      });
    });
  });
}
