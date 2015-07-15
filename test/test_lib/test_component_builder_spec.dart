library angular2.test.test_lib.test_component_builder_spec;

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
        TestComponentBuilder;
import "package:angular2/di.dart" show Injectable;
import "package:angular2/annotations.dart" show Directive, Component, View;
import "package:angular2/src/core/annotations_impl/view.dart" as viewAnn;
import "package:angular2/src/directives/ng_if.dart" show NgIf;

@Component(selector: "child-comp")
@View(
    template: '''<span>Original {{childBinding}}</span>''',
    directives: const [])
@Injectable()
class ChildComp {
  String childBinding;
  ChildComp() {
    this.childBinding = "Child";
  }
}
@Component(selector: "child-comp")
@View(template: '''<span>Mock</span>''')
@Injectable()
class MockChildComp {}
@Component(selector: "parent-comp")
@View(
    template: '''Parent(<child-comp></child-comp>)''',
    directives: const [ChildComp])
@Injectable()
class ParentComp {}
@Component(selector: "my-if-comp")
@View(
    template: '''MyIf(<span *ng-if="showMore">More</span>)''',
    directives: const [NgIf])
@Injectable()
class MyIfComp {
  bool showMore = false;
}
main() {
  describe("test component builder", () {
    it("should instantiate a component with valid DOM", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (tcb, async) {
      tcb.createAsync(ChildComp).then((rootTestComponent) {
        rootTestComponent.detectChanges();
        expect(rootTestComponent.nativeElement).toHaveText("Original Child");
        async.done();
      });
    }));
    it("should allow changing members of the component", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (tcb, async) {
      tcb.createAsync(MyIfComp).then((rootTestComponent) {
        rootTestComponent.detectChanges();
        expect(rootTestComponent.nativeElement).toHaveText("MyIf()");
        rootTestComponent.componentInstance.showMore = true;
        rootTestComponent.detectChanges();
        expect(rootTestComponent.nativeElement).toHaveText("MyIf(More)");
        async.done();
      });
    }));
    it("should override a template", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (tcb, async) {
      tcb
          .overrideTemplate(MockChildComp, "<span>Mock</span>")
          .createAsync(MockChildComp)
          .then((rootTestComponent) {
        rootTestComponent.detectChanges();
        expect(rootTestComponent.nativeElement).toHaveText("Mock");
        async.done();
      });
    }));
    it("should override a view", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (tcb, async) {
      tcb
          .overrideView(ChildComp, new viewAnn.View(
              template: "<span>Modified {{childBinding}}</span>"))
          .createAsync(ChildComp)
          .then((rootTestComponent) {
        rootTestComponent.detectChanges();
        expect(rootTestComponent.nativeElement).toHaveText("Modified Child");
        async.done();
      });
    }));
    it("should override component dependencies", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (tcb, async) {
      tcb
          .overrideDirective(ParentComp, ChildComp, MockChildComp)
          .createAsync(ParentComp)
          .then((rootTestComponent) {
        rootTestComponent.detectChanges();
        expect(rootTestComponent.nativeElement).toHaveText("Parent(Mock)");
        async.done();
      });
    }));
  });
}
