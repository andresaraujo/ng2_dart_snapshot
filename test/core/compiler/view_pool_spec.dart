library angular2.test.core.compiler.view_pool_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        beforeEach,
        ddescribe,
        xdescribe,
        describe,
        el,
        dispatchEvent,
        expect,
        iit,
        inject,
        beforeEachBindings,
        it,
        xit,
        SpyObject,
        proxy;
import "package:angular2/src/core/compiler/view_pool.dart" show AppViewPool;
import "package:angular2/src/core/compiler/view.dart"
    show AppProtoView, AppView;
import "package:angular2/src/facade/collection.dart" show MapWrapper, Map;

main() {
  describe("AppViewPool", () {
    AppViewPool createViewPool({capacity}) {
      return new AppViewPool(capacity);
    }
    createProtoView() {
      return new AppProtoView(null, null, null, null);
    }
    createView(pv) {
      return new AppView(null, pv, new Map());
    }
    it("should support multiple AppProtoViews", () {
      var vf = createViewPool(capacity: 2);
      var pv1 = createProtoView();
      var pv2 = createProtoView();
      var view1 = createView(pv1);
      var view2 = createView(pv2);
      vf.returnView(view1);
      vf.returnView(view2);
      expect(vf.getView(pv1)).toBe(view1);
      expect(vf.getView(pv2)).toBe(view2);
    });
    it("should reuse the newest view that has been returned", () {
      var pv = createProtoView();
      var vf = createViewPool(capacity: 2);
      var view1 = createView(pv);
      var view2 = createView(pv);
      vf.returnView(view1);
      vf.returnView(view2);
      expect(vf.getView(pv)).toBe(view2);
    });
    it("should not add views when the capacity has been reached", () {
      var pv = createProtoView();
      var vf = createViewPool(capacity: 2);
      var view1 = createView(pv);
      var view2 = createView(pv);
      var view3 = createView(pv);
      expect(vf.returnView(view1)).toBe(true);
      expect(vf.returnView(view2)).toBe(true);
      expect(vf.returnView(view3)).toBe(false);
      expect(vf.getView(pv)).toBe(view2);
      expect(vf.getView(pv)).toBe(view1);
    });
  });
}
