library angular2.test.directives.ng_for_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        TestComponentBuilder,
        beforeEach,
        beforeEachBindings,
        ddescribe,
        describe,
        el,
        expect,
        iit,
        inject,
        it,
        xit;
import "package:angular2/src/facade/collection.dart" show ListWrapper;
import "package:angular2/angular2.dart" show Component, View;
import "package:angular2/src/directives/ng_for.dart" show NgFor;

main() {
  describe("ng-for", () {
    var TEMPLATE =
        "<div><copy-me template=\"ng-for #item of items\">{{item.toString()}};</copy-me></div>";
    it("should reflect initial elements", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      tcb
          .overrideTemplate(TestComponent, TEMPLATE)
          .createAsync(TestComponent)
          .then((rootTC) {
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("1;2;");
        async.done();
      });
    }));
    it("should reflect added elements", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      tcb
          .overrideTemplate(TestComponent, TEMPLATE)
          .createAsync(TestComponent)
          .then((rootTC) {
        rootTC.detectChanges();
        ((rootTC.componentInstance.items as List<num>)).add(3);
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("1;2;3;");
        async.done();
      });
    }));
    it("should reflect removed elements", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      tcb
          .overrideTemplate(TestComponent, TEMPLATE)
          .createAsync(TestComponent)
          .then((rootTC) {
        rootTC.detectChanges();
        ListWrapper.removeAt(rootTC.componentInstance.items, 1);
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("1;");
        async.done();
      });
    }));
    it("should reflect moved elements", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      tcb
          .overrideTemplate(TestComponent, TEMPLATE)
          .createAsync(TestComponent)
          .then((rootTC) {
        rootTC.detectChanges();
        ListWrapper.removeAt(rootTC.componentInstance.items, 0);
        ((rootTC.componentInstance.items as List<num>)).add(1);
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("2;1;");
        async.done();
      });
    }));
    it("should reflect a mix of all changes (additions/removals/moves)", inject(
        [
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      tcb
          .overrideTemplate(TestComponent, TEMPLATE)
          .createAsync(TestComponent)
          .then((rootTC) {
        rootTC.componentInstance.items = [0, 1, 2, 3, 4, 5];
        rootTC.detectChanges();
        rootTC.componentInstance.items = [6, 2, 7, 0, 4, 8];
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("6;2;7;0;4;8;");
        async.done();
      });
    }));
    it("should iterate over an array of objects", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      var template =
          "<ul><li template=\"ng-for #item of items\">{{item[\"name\"]}};</li></ul>";
      tcb
          .overrideTemplate(TestComponent, template)
          .createAsync(TestComponent)
          .then((rootTC) {
        // INIT
        rootTC.componentInstance.items = [{"name": "misko"}, {"name": "shyam"}];
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("misko;shyam;");
        // GROW
        ((rootTC.componentInstance.items as List<dynamic>))
            .add({"name": "adam"});
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("misko;shyam;adam;");
        // SHRINK
        ListWrapper.removeAt(rootTC.componentInstance.items, 2);
        ListWrapper.removeAt(rootTC.componentInstance.items, 0);
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("shyam;");
        async.done();
      });
    }));
    it("should gracefully handle nulls", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      var template =
          "<ul><li template=\"ng-for #item of null\">{{item}};</li></ul>";
      tcb
          .overrideTemplate(TestComponent, template)
          .createAsync(TestComponent)
          .then((rootTC) {
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("");
        async.done();
      });
    }));
    it("should gracefully handle ref changing to null and back", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      tcb
          .overrideTemplate(TestComponent, TEMPLATE)
          .createAsync(TestComponent)
          .then((rootTC) {
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("1;2;");
        rootTC.componentInstance.items = null;
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("");
        rootTC.componentInstance.items = [1, 2, 3];
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("1;2;3;");
        async.done();
      });
    }));
    it("should throw on ref changing to string", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      tcb
          .overrideTemplate(TestComponent, TEMPLATE)
          .createAsync(TestComponent)
          .then((rootTC) {
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("1;2;");
        rootTC.componentInstance.items = "whaaa";
        expect(() => rootTC.detectChanges()).toThrowError();
        async.done();
      });
    }));
    it("should works with duplicates", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      tcb
          .overrideTemplate(TestComponent, TEMPLATE)
          .createAsync(TestComponent)
          .then((rootTC) {
        var a = new Foo();
        rootTC.componentInstance.items = [a, a];
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("foo;foo;");
        async.done();
      });
    }));
    it("should repeat over nested arrays", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      var template = "<div>" +
          "<div template=\"ng-for #item of items\">" +
          "<div template=\"ng-for #subitem of item\">" +
          "{{subitem}}-{{item.length}};" +
          "</div>|" +
          "</div>" +
          "</div>";
      tcb
          .overrideTemplate(TestComponent, template)
          .createAsync(TestComponent)
          .then((rootTC) {
        rootTC.componentInstance.items = [["a", "b"], ["c"]];
        rootTC.detectChanges();
        rootTC.detectChanges();
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("a-2;b-2;|c-1;|");
        rootTC.componentInstance.items = [["e"], ["f", "g"]];
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("e-1;|f-2;g-2;|");
        async.done();
      });
    }));
    it("should repeat over nested arrays with no intermediate element", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      var template = "<div><template ng-for #item [ng-for-of]=\"items\">" +
          "<div template=\"ng-for #subitem of item\">" +
          "{{subitem}}-{{item.length}};" +
          "</div></template></div>";
      tcb
          .overrideTemplate(TestComponent, template)
          .createAsync(TestComponent)
          .then((rootTC) {
        rootTC.componentInstance.items = [["a", "b"], ["c"]];
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("a-2;b-2;c-1;");
        rootTC.componentInstance.items = [["e"], ["f", "g"]];
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("e-1;f-2;g-2;");
        async.done();
      });
    }));
    it("should display indices correctly", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      var template =
          "<div><copy-me template=\"ng-for: var item of items; var i=index\">{{i.toString()}}</copy-me></div>";
      tcb
          .overrideTemplate(TestComponent, template)
          .createAsync(TestComponent)
          .then((rootTC) {
        rootTC.componentInstance.items = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("0123456789");
        rootTC.componentInstance.items = [1, 2, 6, 7, 4, 3, 5, 8, 9, 0];
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("0123456789");
        async.done();
      });
    }));
  });
}
class Foo {
  toString() {
    return "foo";
  }
}
@Component(selector: "test-cmp")
@View(directives: const [NgFor])
class TestComponent {
  dynamic items;
  TestComponent() {
    this.items = [1, 2];
  }
}
