library angular2.test.render.dom.shadow_dom.emulated_unscoped_shadow_dom_strategy_spec;

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
        xit,
        SpyObject;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/facade/collection.dart" show ListWrapper;
import "package:angular2/src/render/dom/shadow_dom/emulated_unscoped_shadow_dom_strategy.dart"
    show EmulatedUnscopedShadowDomStrategy;
import "package:angular2/src/render/dom/shadow_dom/util.dart"
    show resetShadowDomCache;

main() {
  var strategy;
  describe("EmulatedUnscopedShadowDomStrategy", () {
    var styleHost;
    beforeEach(() {
      styleHost = el("<div></div>");
      strategy = new EmulatedUnscopedShadowDomStrategy(styleHost);
      resetShadowDomCache();
    });
    it("should use the host element as shadow root", () {
      var host = el("<div><span>original content</span></div>");
      expect(strategy.prepareShadowRoot(host)).toBe(host);
    });
    it("should move the style element to the style host", () {
      var compileElement = el("<div><style>.one {}</style></div>");
      var styleElement = DOM.firstChild(compileElement);
      strategy.processStyleElement(
          "someComponent", "http://base", styleElement);
      expect(compileElement).toHaveText("");
      expect(styleHost).toHaveText(".one {}");
    });
    it("should insert the same style only once in the style host", () {
      var styleEls = [
        el("<style>/*css1*/</style>"),
        el("<style>/*css2*/</style>"),
        el("<style>/*css1*/</style>")
      ];
      ListWrapper.forEach(styleEls, (styleEl) {
        strategy.processStyleElement("someComponent", "http://base", styleEl);
      });
      expect(styleHost).toHaveText("/*css1*//*css2*/");
    });
  });
}
