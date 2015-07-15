library angular2.test.core.life_cycle.life_cycle_spec;

import "package:angular2/test_lib.dart"
    show
        ddescribe,
        describe,
        it,
        iit,
        xit,
        expect,
        beforeEach,
        afterEach,
        el,
        AsyncTestCompleter,
        fakeAsync,
        tick,
        inject,
        SpyChangeDetector;
import "package:angular2/src/core/life_cycle/life_cycle.dart" show LifeCycle;

main() {
  describe("LifeCycle", () {
    it("should throw when reentering tick", () {
      var cd = (new SpyChangeDetector() as dynamic);
      var lc = new LifeCycle(null, cd, false);
      cd.spy("detectChanges").andCallFake(() => lc.tick());
      expect(() => lc.tick())
          .toThrowError("LifeCycle.tick is called recursively");
    });
  });
}
