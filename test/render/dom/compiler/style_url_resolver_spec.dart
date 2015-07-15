library angular2.test.render.dom.compiler.style_url_resolver_spec;

import "package:angular2/test_lib.dart"
    show describe, it, expect, beforeEach, ddescribe, iit, xit, el;
import "package:angular2/src/render/dom/compiler/style_url_resolver.dart"
    show StyleUrlResolver;
import "package:angular2/src/services/url_resolver.dart" show UrlResolver;

main() {
  describe("StyleUrlResolver", () {
    var styleUrlResolver;
    beforeEach(() {
      styleUrlResolver = new StyleUrlResolver(new UrlResolver());
    });
    it("should resolve \"url()\" urls", () {
      var css = '''
      .foo {
        background-image: url("double.jpg");
        background-image: url(\'simple.jpg\');
        background-image: url(noquote.jpg);
      }''';
      var expectedCss = '''
      .foo {
        background-image: url(\'http://ng.io/double.jpg\');
        background-image: url(\'http://ng.io/simple.jpg\');
        background-image: url(\'http://ng.io/noquote.jpg\');
      }''';
      var resolvedCss = styleUrlResolver.resolveUrls(css, "http://ng.io");
      expect(resolvedCss).toEqual(expectedCss);
    });
    it("should resolve \"@import\" urls", () {
      var css = '''
      @import \'1.css\';
      @import "2.css";
      ''';
      var expectedCss = '''
      @import \'http://ng.io/1.css\';
      @import \'http://ng.io/2.css\';
      ''';
      var resolvedCss = styleUrlResolver.resolveUrls(css, "http://ng.io");
      expect(resolvedCss).toEqual(expectedCss);
    });
    it("should resolve \"@import url()\" urls", () {
      var css = '''
      @import url(\'3.css\');
      @import url("4.css");
      @import url(5.css);
      ''';
      var expectedCss = '''
      @import url(\'http://ng.io/3.css\');
      @import url(\'http://ng.io/4.css\');
      @import url(\'http://ng.io/5.css\');
      ''';
      var resolvedCss = styleUrlResolver.resolveUrls(css, "http://ng.io");
      expect(resolvedCss).toEqual(expectedCss);
    });
    it("should support media query in \"@import\"", () {
      var css = '''
      @import \'print.css\' print;
      @import url(print.css) print;
      ''';
      var expectedCss = '''
      @import \'http://ng.io/print.css\' print;
      @import url(\'http://ng.io/print.css\') print;
      ''';
      var resolvedCss = styleUrlResolver.resolveUrls(css, "http://ng.io");
      expect(resolvedCss).toEqual(expectedCss);
    });
  });
}
