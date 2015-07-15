library angular2.test.render.dom.compiler.view_loader_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        beforeEach,
        ddescribe,
        describe,
        el,
        expect,
        iit,
        inject,
        it,
        xit;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/render/dom/compiler/view_loader.dart"
    show ViewLoader;
import "package:angular2/src/render/dom/compiler/style_inliner.dart"
    show StyleInliner;
import "package:angular2/src/render/dom/compiler/style_url_resolver.dart"
    show StyleUrlResolver;
import "package:angular2/src/services/url_resolver.dart" show UrlResolver;
import "package:angular2/src/render/api.dart" show ViewDefinition;
import "package:angular2/src/facade/async.dart" show PromiseWrapper, Future;
import "package:angular2/src/facade/collection.dart"
    show MapWrapper, ListWrapper;
import "package:angular2/src/render/xhr.dart" show XHR;
import "package:angular2/src/render/xhr_mock.dart" show MockXHR;

main() {
  describe("ViewLoader", () {
    var loader, xhr, styleUrlResolver, urlResolver;
    beforeEach(() {
      xhr = new MockXHR();
      urlResolver = new UrlResolver();
      styleUrlResolver = new StyleUrlResolver(urlResolver);
      var styleInliner = new StyleInliner(xhr, styleUrlResolver, urlResolver);
      loader = new ViewLoader(xhr, styleInliner, styleUrlResolver);
    });
    describe("html", () {
      it("should load inline templates", inject([AsyncTestCompleter], (async) {
        var view = new ViewDefinition(template: "template template");
        loader.load(view).then((el) {
          expect(DOM.content(el)).toHaveText("template template");
          async.done();
        });
      }));
      it("should load templates through XHR", inject([AsyncTestCompleter],
          (async) {
        xhr.expect("http://ng.io/foo.html", "xhr template");
        var view = new ViewDefinition(templateAbsUrl: "http://ng.io/foo.html");
        loader.load(view).then((el) {
          expect(DOM.content(el)).toHaveText("xhr template");
          async.done();
        });
        xhr.flush();
      }));
      it("should resolve urls in styles", inject([AsyncTestCompleter], (async) {
        xhr.expect("http://ng.io/foo.html",
            "<style>.foo { background-image: url(\"double.jpg\"); }</style>");
        var view = new ViewDefinition(templateAbsUrl: "http://ng.io/foo.html");
        loader.load(view).then((el) {
          expect(DOM.content(el)).toHaveText(
              ".foo { background-image: url('http://ng.io/double.jpg'); }");
          async.done();
        });
        xhr.flush();
      }));
      it("should inline styles", inject([AsyncTestCompleter], (async) {
        var xhr = new FakeXHR();
        xhr.reply(
            "http://ng.io/foo.html", "<style>@import \"foo.css\";</style>");
        xhr.reply("http://ng.io/foo.css", "/* foo.css */");
        var styleInliner = new StyleInliner(xhr, styleUrlResolver, urlResolver);
        var loader = new ViewLoader(xhr, styleInliner, styleUrlResolver);
        var view = new ViewDefinition(templateAbsUrl: "http://ng.io/foo.html");
        loader.load(view).then((el) {
          expect(DOM.getInnerHTML(el))
              .toEqual("<style>/* foo.css */\n</style>");
          async.done();
        });
      }));
      it("should return a new template element on each call", inject(
          [AsyncTestCompleter], (async) {
        var firstEl;
        // we have only one xhr.expect, so there can only be one xhr call!
        xhr.expect("http://ng.io/foo.html", "xhr template");
        var view = new ViewDefinition(templateAbsUrl: "http://ng.io/foo.html");
        loader.load(view).then((el) {
          expect(DOM.content(el)).toHaveText("xhr template");
          firstEl = el;
          return loader.load(view);
        }).then((el) {
          expect(el).not.toBe(firstEl);
          expect(DOM.content(el)).toHaveText("xhr template");
          async.done();
        });
        xhr.flush();
      }));
      it("should throw when no template is defined", () {
        var view = new ViewDefinition(template: null, templateAbsUrl: null);
        expect(() => loader.load(view)).toThrowError(
            "View should have either the templateUrl or template property set");
      });
      it("should return a rejected Promise when XHR loading fails", inject(
          [AsyncTestCompleter], (async) {
        xhr.expect("http://ng.io/foo.html", null);
        var view = new ViewDefinition(templateAbsUrl: "http://ng.io/foo.html");
        PromiseWrapper.then(loader.load(view), (_) {
          throw "Unexpected response";
        }, (error) {
          expect(error.message)
              .toEqual("Failed to fetch url \"http://ng.io/foo.html\"");
          async.done();
        });
        xhr.flush();
      }));
    });
    describe("css", () {
      it("should load inline styles", inject([AsyncTestCompleter], (async) {
        var view = new ViewDefinition(
            template: "html", styles: ["style 1", "style 2"]);
        loader.load(view).then((el) {
          expect(DOM.getInnerHTML(el))
              .toEqual("<style>style 1</style><style>style 2</style>html");
          async.done();
        });
      }));
      it("should resolve urls in inline styles", inject([AsyncTestCompleter],
          (async) {
        xhr.expect("http://ng.io/foo.html", "html");
        var view = new ViewDefinition(
            templateAbsUrl: "http://ng.io/foo.html",
            styles: [".foo { background-image: url(\"double.jpg\"); }"]);
        loader.load(view).then((el) {
          expect(DOM.getInnerHTML(el)).toEqual(
              "<style>.foo { background-image: url('http://ng.io/double.jpg'); }</style>html");
          async.done();
        });
        xhr.flush();
      }));
      it("should load templates through XHR", inject([AsyncTestCompleter],
          (async) {
        xhr.expect("http://ng.io/foo.html", "xhr template");
        xhr.expect("http://ng.io/foo-1.css", "1");
        xhr.expect("http://ng.io/foo-2.css", "2");
        var view = new ViewDefinition(
            templateAbsUrl: "http://ng.io/foo.html",
            styles: ["i1"],
            styleAbsUrls: ["http://ng.io/foo-1.css", "http://ng.io/foo-2.css"]);
        loader.load(view).then((el) {
          expect(DOM.getInnerHTML(el)).toEqual(
              "<style>i1</style><style>1</style><style>2</style>xhr template");
          async.done();
        });
        xhr.flush();
      }));
      it("should inline styles", inject([AsyncTestCompleter], (async) {
        var xhr = new FakeXHR();
        xhr.reply("http://ng.io/foo.html", "<p>template</p>");
        xhr.reply("http://ng.io/foo.css", "/* foo.css */");
        var styleInliner = new StyleInliner(xhr, styleUrlResolver, urlResolver);
        var loader = new ViewLoader(xhr, styleInliner, styleUrlResolver);
        var view = new ViewDefinition(
            templateAbsUrl: "http://ng.io/foo.html",
            styles: ["@import \"foo.css\";"]);
        loader.load(view).then((el) {
          expect(DOM.getInnerHTML(el))
              .toEqual("<style>/* foo.css */\n</style><p>template</p>");
          async.done();
        });
      }));
      it("should return a rejected Promise when XHR loading fails", inject(
          [AsyncTestCompleter], (async) {
        xhr.expect("http://ng.io/foo.css", null);
        var view = new ViewDefinition(
            template: "", styleAbsUrls: ["http://ng.io/foo.css"]);
        PromiseWrapper.then(loader.load(view), (_) {
          throw "Unexpected response";
        }, (error) {
          expect(error.message)
              .toEqual("Failed to fetch url \"http://ng.io/foo.css\"");
          async.done();
        });
        xhr.flush();
      }));
    });
  });
}
class SomeComponent {}
class FakeXHR extends XHR {
  Map<String, String> _responses = new Map();
  FakeXHR() : super() {
    /* super call moved to initializer */;
  }
  Future<String> get(String url) {
    return this._responses.containsKey(url)
        ? PromiseWrapper.resolve(this._responses[url])
        : PromiseWrapper.reject("xhr error", null);
  }
  void reply(String url, String response) {
    this._responses[url] = response;
  }
}
