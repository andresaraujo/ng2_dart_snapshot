library angular2.test.directives.ng_if_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        TestComponentBuilder,
        By,
        beforeEach,
        ddescribe,
        describe,
        el,
        expect,
        iit,
        inject,
        IS_DARTIUM,
        it,
        xit;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/angular2.dart" show Component, View;
import "package:angular2/src/directives/ng_if.dart" show NgIf;

main() {
  describe("ng-if directive", () {
    it("should work in a template attribute", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      var html =
          "<div><copy-me template=\"ng-if booleanCondition\">hello</copy-me></div>";
      tcb
          .overrideTemplate(TestComponent, html)
          .createAsync(TestComponent)
          .then((rootTC) {
        rootTC.detectChanges();
        expect(DOM.querySelectorAll(rootTC.nativeElement, "copy-me").length)
            .toEqual(1);
        expect(rootTC.nativeElement).toHaveText("hello");
        async.done();
      });
    }));
    it("should work in a template element", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      var html =
          "<div><template [ng-if]=\"booleanCondition\"><copy-me>hello2</copy-me></template></div>";
      tcb
          .overrideTemplate(TestComponent, html)
          .createAsync(TestComponent)
          .then((rootTC) {
        rootTC.detectChanges();
        expect(DOM.querySelectorAll(rootTC.nativeElement, "copy-me").length)
            .toEqual(1);
        expect(rootTC.nativeElement).toHaveText("hello2");
        async.done();
      });
    }));
    it("should toggle node when condition changes", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      var html =
          "<div><copy-me template=\"ng-if booleanCondition\">hello</copy-me></div>";
      tcb
          .overrideTemplate(TestComponent, html)
          .createAsync(TestComponent)
          .then((rootTC) {
        rootTC.componentInstance.booleanCondition = false;
        rootTC.detectChanges();
        expect(DOM.querySelectorAll(rootTC.nativeElement, "copy-me").length)
            .toEqual(0);
        expect(rootTC.nativeElement).toHaveText("");
        rootTC.componentInstance.booleanCondition = true;
        rootTC.detectChanges();
        expect(DOM.querySelectorAll(rootTC.nativeElement, "copy-me").length)
            .toEqual(1);
        expect(rootTC.nativeElement).toHaveText("hello");
        rootTC.componentInstance.booleanCondition = false;
        rootTC.detectChanges();
        expect(DOM.querySelectorAll(rootTC.nativeElement, "copy-me").length)
            .toEqual(0);
        expect(rootTC.nativeElement).toHaveText("");
        async.done();
      });
    }));
    it("should handle nested if correctly", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      var html =
          "<div><template [ng-if]=\"booleanCondition\"><copy-me *ng-if=\"nestedBooleanCondition\">hello</copy-me></template></div>";
      tcb
          .overrideTemplate(TestComponent, html)
          .createAsync(TestComponent)
          .then((rootTC) {
        rootTC.componentInstance.booleanCondition = false;
        rootTC.detectChanges();
        expect(DOM.querySelectorAll(rootTC.nativeElement, "copy-me").length)
            .toEqual(0);
        expect(rootTC.nativeElement).toHaveText("");
        rootTC.componentInstance.booleanCondition = true;
        rootTC.detectChanges();
        expect(DOM.querySelectorAll(rootTC.nativeElement, "copy-me").length)
            .toEqual(1);
        expect(rootTC.nativeElement).toHaveText("hello");
        rootTC.componentInstance.nestedBooleanCondition = false;
        rootTC.detectChanges();
        expect(DOM.querySelectorAll(rootTC.nativeElement, "copy-me").length)
            .toEqual(0);
        expect(rootTC.nativeElement).toHaveText("");
        rootTC.componentInstance.nestedBooleanCondition = true;
        rootTC.detectChanges();
        expect(DOM.querySelectorAll(rootTC.nativeElement, "copy-me").length)
            .toEqual(1);
        expect(rootTC.nativeElement).toHaveText("hello");
        rootTC.componentInstance.booleanCondition = false;
        rootTC.detectChanges();
        expect(DOM.querySelectorAll(rootTC.nativeElement, "copy-me").length)
            .toEqual(0);
        expect(rootTC.nativeElement).toHaveText("");
        async.done();
      });
    }));
    it("should update several nodes with if", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      var html = "<div>" +
          "<copy-me template=\"ng-if numberCondition + 1 >= 2\">helloNumber</copy-me>" +
          "<copy-me template=\"ng-if stringCondition == 'foo'\">helloString</copy-me>" +
          "<copy-me template=\"ng-if functionCondition(stringCondition, numberCondition)\">helloFunction</copy-me>" +
          "</div>";
      tcb
          .overrideTemplate(TestComponent, html)
          .createAsync(TestComponent)
          .then((rootTC) {
        rootTC.detectChanges();
        expect(DOM.querySelectorAll(rootTC.nativeElement, "copy-me").length)
            .toEqual(3);
        expect(DOM.getText(rootTC.nativeElement))
            .toEqual("helloNumberhelloStringhelloFunction");
        rootTC.componentInstance.numberCondition = 0;
        rootTC.detectChanges();
        expect(DOM.querySelectorAll(rootTC.nativeElement, "copy-me").length)
            .toEqual(1);
        expect(rootTC.nativeElement).toHaveText("helloString");
        rootTC.componentInstance.numberCondition = 1;
        rootTC.componentInstance.stringCondition = "bar";
        rootTC.detectChanges();
        expect(DOM.querySelectorAll(rootTC.nativeElement, "copy-me").length)
            .toEqual(1);
        expect(rootTC.nativeElement).toHaveText("helloNumber");
        async.done();
      });
    }));
    if (!IS_DARTIUM) {
      it("should not add the element twice if the condition goes from true to true (JS)",
          inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var html =
            "<div><copy-me template=\"ng-if numberCondition\">hello</copy-me></div>";
        tcb
            .overrideTemplate(TestComponent, html)
            .createAsync(TestComponent)
            .then((rootTC) {
          rootTC.detectChanges();
          expect(DOM.querySelectorAll(rootTC.nativeElement, "copy-me").length)
              .toEqual(1);
          expect(rootTC.nativeElement).toHaveText("hello");
          rootTC.componentInstance.numberCondition = 2;
          rootTC.detectChanges();
          expect(DOM.querySelectorAll(rootTC.nativeElement, "copy-me").length)
              .toEqual(1);
          expect(rootTC.nativeElement).toHaveText("hello");
          async.done();
        });
      }));
      it("should not recreate the element if the condition goes from true to true (JS)",
          inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var html =
            "<div><copy-me template=\"ng-if numberCondition\">hello</copy-me></div>";
        tcb
            .overrideTemplate(TestComponent, html)
            .createAsync(TestComponent)
            .then((rootTC) {
          rootTC.detectChanges();
          DOM.addClass(
              DOM.querySelector(rootTC.nativeElement, "copy-me"), "foo");
          rootTC.componentInstance.numberCondition = 2;
          rootTC.detectChanges();
          expect(DOM.hasClass(
                  DOM.querySelector(rootTC.nativeElement, "copy-me"), "foo"))
              .toBe(true);
          async.done();
        });
      }));
    }
    if (IS_DARTIUM) {
      it("should not create the element if the condition is not a boolean (DART)",
          inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var html =
            "<div><copy-me template=\"ng-if numberCondition\">hello</copy-me></div>";
        tcb
            .overrideTemplate(TestComponent, html)
            .createAsync(TestComponent)
            .then((rootTC) {
          expect(() => rootTC.detectChanges()).toThrowError();
          expect(DOM.querySelectorAll(rootTC.nativeElement, "copy-me").length)
              .toEqual(0);
          expect(rootTC.nativeElement).toHaveText("");
          async.done();
        });
      }));
    }
  });
}
@Component(selector: "test-cmp")
@View(directives: const [NgIf])
class TestComponent {
  bool booleanCondition;
  bool nestedBooleanCondition;
  num numberCondition;
  String stringCondition;
  Function functionCondition;
  TestComponent() {
    this.booleanCondition = true;
    this.nestedBooleanCondition = true;
    this.numberCondition = 1;
    this.stringCondition = "foo";
    this.functionCondition = (s, n) {
      return s == "foo" && n == 1;
    };
  }
}
