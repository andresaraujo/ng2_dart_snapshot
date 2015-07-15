library angular2.test.debug.debug_element_view_listener_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        beforeEach,
        ddescribe,
        xdescribe,
        describe,
        dispatchEvent,
        expect,
        iit,
        inject,
        IS_DARTIUM,
        beforeEachBindings,
        it,
        xit,
        TestComponentBuilder,
        By,
        Scope,
        inspectNativeElement;
import "package:angular2/src/facade/lang.dart" show global;
import "package:angular2/src/core/compiler/view_pool.dart"
    show APP_VIEW_POOL_CAPACITY;
import "package:angular2/di.dart" show Injectable, bind;
import "package:angular2/annotations.dart" show Directive, Component, View;

@Component(selector: "my-comp")
@View(directives: const [])
@Injectable()
class MyComp {
  String ctxProp;
}
main() {
  describe("element probe", () {
    beforeEachBindings(() => [bind(APP_VIEW_POOL_CAPACITY).toValue(0)]);
    it("should return a TestElement from a dom element", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (tcb, async) {
      tcb
          .overrideTemplate(MyComp, "<div some-dir></div>")
          .createAsync(MyComp)
          .then((rootTestComponent) {
        expect(inspectNativeElement(
                rootTestComponent.nativeElement).componentInstance)
            .toBeAnInstanceOf(MyComp);
        async.done();
      });
    }));
    it("should clean up whent the view is destroyed", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (tcb, async) {
      tcb
          .overrideTemplate(MyComp, "")
          .createAsync(MyComp)
          .then((rootTestComponent) {
        rootTestComponent.destroy();
        expect(inspectNativeElement(rootTestComponent.nativeElement))
            .toBe(null);
        async.done();
      });
    }));
    if (!IS_DARTIUM) {
      it("should provide a global function to inspect elements", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (tcb, async) {
        tcb
            .overrideTemplate(MyComp, "")
            .createAsync(MyComp)
            .then((rootTestComponent) {
          expect(global["ngProbe"](
                  rootTestComponent.nativeElement).componentInstance)
              .toBeAnInstanceOf(MyComp);
          async.done();
        });
      }));
    }
  });
}
