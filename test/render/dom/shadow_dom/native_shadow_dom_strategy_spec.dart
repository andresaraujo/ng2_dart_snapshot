library angular2.test.render.dom.shadow_dom.native_shadow_dom_strategy_spec;

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
import "package:angular2/src/render/dom/shadow_dom/native_shadow_dom_strategy.dart"
    show NativeShadowDomStrategy;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;

main() {
  var strategy;
  describe("NativeShadowDomStrategy", () {
    beforeEach(() {
      strategy = new NativeShadowDomStrategy();
    });
    if (DOM.supportsNativeShadowDOM()) {
      it("should use the native shadow root", () {
        var host = el("<div><span>original content</span></div>");
        expect(strategy.prepareShadowRoot(host)).toBe(DOM.getShadowRoot(host));
      });
    }
  });
}
