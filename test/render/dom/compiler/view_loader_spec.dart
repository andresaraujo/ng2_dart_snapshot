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
import "package:angular2/src/render/dom/compiler/view_loader.dart"
    show ViewLoader, TemplateAndStyles;
import "package:angular2/src/render/dom/compiler/style_inliner.dart"
    show StyleInliner;
import "package:angular2/src/render/dom/compiler/style_url_resolver.dart"
    show StyleUrlResolver;
import "package:angular2/src/services/url_resolver.dart" show UrlResolver;
import "package:angular2/src/facade/async.dart" show PromiseWrapper, Future;
import "package:angular2/src/facade/collection.dart"
    show MapWrapper, ListWrapper;
import "package:angular2/src/render/xhr.dart" show XHR;
import "package:angular2/src/render/xhr_mock.dart" show MockXHR;
import "package:angular2/src/render/api.dart" show ViewDefinition;

main() {
  describe("ViewLoader", () {
    ViewLoader loader;
    var xhr, styleUrlResolver, urlResolver;
    beforeEach(() {
      xhr = new MockXHR();
      urlResolver = new UrlResolver();
      styleUrlResolver = new StyleUrlResolver(urlResolver);
      var styleInliner = new StyleInliner(xhr, styleUrlResolver, urlResolver);
      loader = new ViewLoader(xhr, styleInliner, styleUrlResolver);
    });
    describe("html", () {
      it("should load inline templates", inject([AsyncTestCompleter], (async) {
        loader
            .load(new ViewDefinition(template: "template template"))
            .then((el) {
          expect(el.template).toEqual("template template");
          async.done();
        });
      }));
      it("should load templates through XHR", inject([AsyncTestCompleter],
          (async) {
        xhr.expect("http://ng.io/foo.html", "xhr template");
        loader
            .load(new ViewDefinition(templateAbsUrl: "http://ng.io/foo.html"))
            .then((el) {
          expect(el.template).toEqual("xhr template");
          async.done();
        });
        xhr.flush();
      }));
      it("should resolve urls in styles", inject([AsyncTestCompleter], (async) {
        xhr.expect("http://ng.io/foo.html",
            "<style>.foo { background-image: url(\"double.jpg\"); }</style>");
        loader
            .load(new ViewDefinition(templateAbsUrl: "http://ng.io/foo.html"))
            .then((el) {
          expect(el.template).toEqual("");
          expect(el.styles).toEqual(
              [".foo { background-image: url('http://ng.io/double.jpg'); }"]);
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
        loader
            .load(new ViewDefinition(templateAbsUrl: "http://ng.io/foo.html"))
            .then((el) {
          expect(el.template).toEqual("");
          expect(el.styles).toEqual(["/* foo.css */\n"]);
          async.done();
        });
      }));
      it("should throw when no template is defined", () {
        expect(() => loader.load(new ViewDefinition(
                template: null, templateAbsUrl: null))).toThrowError(
            "View should have either the templateUrl or template property set");
      });
      it("should return a rejected Promise when XHR loading fails", inject(
          [AsyncTestCompleter], (async) {
        xhr.expect("http://ng.io/foo.html", null);
        PromiseWrapper.then(loader.load(
            new ViewDefinition(templateAbsUrl: "http://ng.io/foo.html")), (_) {
          throw "Unexpected response";
        }, (error) {
          expect(error.message)
              .toEqual("Failed to fetch url \"http://ng.io/foo.html\"");
          async.done();
        });
        xhr.flush();
      }));
      it("should replace \$baseUrl in attributes with the template base url",
          inject([AsyncTestCompleter], (async) {
        xhr.expect(
            "http://ng.io/path/foo.html", "<img src=\"\$baseUrl/logo.png\">");
        loader
            .load(new ViewDefinition(
                templateAbsUrl: "http://ng.io/path/foo.html"))
            .then((el) {
          expect(el.template)
              .toEqual("<img src=\"http://ng.io/path/logo.png\">");
          async.done();
        });
        xhr.flush();
      }));
    });
    describe("css", () {
      it("should load inline styles", inject([AsyncTestCompleter], (async) {
        loader
            .load(new ViewDefinition(
                template: "html", styles: ["style 1", "style 2"]))
            .then((el) {
          expect(el.template).toEqual("html");
          expect(el.styles).toEqual(["style 1", "style 2"]);
          async.done();
        });
      }));
      it("should resolve urls in inline styles", inject([AsyncTestCompleter],
          (async) {
        xhr.expect("http://ng.io/foo.html", "html");
        loader
            .load(new ViewDefinition(
                templateAbsUrl: "http://ng.io/foo.html",
                styles: [".foo { background-image: url(\"double.jpg\"); }"]))
            .then((el) {
          expect(el.template).toEqual("html");
          expect(el.styles).toEqual(
              [".foo { background-image: url('http://ng.io/double.jpg'); }"]);
          async.done();
        });
        xhr.flush();
      }));
      it("should load templates through XHR", inject([AsyncTestCompleter],
          (async) {
        xhr.expect("http://ng.io/foo.html", "xhr template");
        xhr.expect("http://ng.io/foo-1.css", "1");
        xhr.expect("http://ng.io/foo-2.css", "2");
        loader
            .load(new ViewDefinition(
                templateAbsUrl: "http://ng.io/foo.html",
                styles: ["i1"],
                styleAbsUrls: [
          "http://ng.io/foo-1.css",
          "http://ng.io/foo-2.css"
        ]))
            .then((el) {
          expect(el.template).toEqual("xhr template");
          expect(el.styles).toEqual(["i1", "1", "2"]);
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
        loader
            .load(new ViewDefinition(
                templateAbsUrl: "http://ng.io/foo.html",
                styles: ["@import \"foo.css\";"]))
            .then((el) {
          expect(el.template).toEqual("<p>template</p>");
          expect(el.styles).toEqual(["/* foo.css */\n"]);
          async.done();
        });
      }));
      it("should return a rejected Promise when XHR loading fails", inject(
          [AsyncTestCompleter], (async) {
        xhr.expect("http://ng.io/foo.css", null);
        PromiseWrapper.then(loader.load(new ViewDefinition(
            template: "", styleAbsUrls: ["http://ng.io/foo.css"])), (_) {
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
