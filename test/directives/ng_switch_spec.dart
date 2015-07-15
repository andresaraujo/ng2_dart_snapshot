library angular2.test.directives.ng_switch_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        TestComponentBuilder,
        beforeEach,
        ddescribe,
        describe,
        el,
        expect,
        iit,
        inject,
        it,
        xit;
import "package:angular2/angular2.dart" show Component, View;
import "package:angular2/src/directives/ng_switch.dart"
    show NgSwitch, NgSwitchWhen, NgSwitchDefault;

main() {
  describe("switch", () {
    describe("switch value changes", () {
      it("should switch amongst when values", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var template = "<div>" +
            "<ul [ng-switch]=\"switchValue\">" +
            "<template ng-switch-when=\"a\"><li>when a</li></template>" +
            "<template ng-switch-when=\"b\"><li>when b</li></template>" +
            "</ul></div>";
        tcb
            .overrideTemplate(TestComponent, template)
            .createAsync(TestComponent)
            .then((rootTC) {
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("");
          rootTC.componentInstance.switchValue = "a";
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("when a");
          rootTC.componentInstance.switchValue = "b";
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("when b");
          async.done();
        });
      }));
      it("should switch amongst when values with fallback to default", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var template = "<div>" +
            "<ul [ng-switch]=\"switchValue\">" +
            "<li template=\"ng-switch-when 'a'\">when a</li>" +
            "<li template=\"ng-switch-default\">when default</li>" +
            "</ul></div>";
        tcb
            .overrideTemplate(TestComponent, template)
            .createAsync(TestComponent)
            .then((rootTC) {
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("when default");
          rootTC.componentInstance.switchValue = "a";
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("when a");
          rootTC.componentInstance.switchValue = "b";
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("when default");
          async.done();
        });
      }));
      it("should support multiple whens with the same value", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var template = "<div>" +
            "<ul [ng-switch]=\"switchValue\">" +
            "<template ng-switch-when=\"a\"><li>when a1;</li></template>" +
            "<template ng-switch-when=\"b\"><li>when b1;</li></template>" +
            "<template ng-switch-when=\"a\"><li>when a2;</li></template>" +
            "<template ng-switch-when=\"b\"><li>when b2;</li></template>" +
            "<template ng-switch-default><li>when default1;</li></template>" +
            "<template ng-switch-default><li>when default2;</li></template>" +
            "</ul></div>";
        tcb
            .overrideTemplate(TestComponent, template)
            .createAsync(TestComponent)
            .then((rootTC) {
          rootTC.detectChanges();
          expect(rootTC.nativeElement)
              .toHaveText("when default1;when default2;");
          rootTC.componentInstance.switchValue = "a";
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("when a1;when a2;");
          rootTC.componentInstance.switchValue = "b";
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("when b1;when b2;");
          async.done();
        });
      }));
    });
    describe("when values changes", () {
      it("should switch amongst when values", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var template = "<div>" +
            "<ul [ng-switch]=\"switchValue\">" +
            "<template [ng-switch-when]=\"when1\"><li>when 1;</li></template>" +
            "<template [ng-switch-when]=\"when2\"><li>when 2;</li></template>" +
            "<template ng-switch-default><li>when default;</li></template>" +
            "</ul></div>";
        tcb
            .overrideTemplate(TestComponent, template)
            .createAsync(TestComponent)
            .then((rootTC) {
          rootTC.componentInstance.when1 = "a";
          rootTC.componentInstance.when2 = "b";
          rootTC.componentInstance.switchValue = "a";
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("when 1;");
          rootTC.componentInstance.switchValue = "b";
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("when 2;");
          rootTC.componentInstance.switchValue = "c";
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("when default;");
          rootTC.componentInstance.when1 = "c";
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("when 1;");
          rootTC.componentInstance.when1 = "d";
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("when default;");
          async.done();
        });
      }));
    });
  });
}
@Component(selector: "test-cmp")
@View(directives: const [NgSwitch, NgSwitchWhen, NgSwitchDefault])
class TestComponent {
  dynamic switchValue;
  dynamic when1;
  dynamic when2;
  TestComponent() {
    this.switchValue = null;
    this.when1 = null;
    this.when2 = null;
  }
}
