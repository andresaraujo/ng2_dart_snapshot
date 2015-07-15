library angular2.test.core.directive_lifecycle_integration_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        beforeEach,
        ddescribe,
        describe,
        expect,
        iit,
        inject,
        it,
        xdescribe,
        xit,
        TestComponentBuilder,
        IS_DARTIUM;
import "package:angular2/src/facade/collection.dart" show ListWrapper;
import "package:angular2/angular2.dart"
    show Directive, Component, View, LifecycleEvent;
import "package:angular2/src/core/annotations_impl/view.dart" as viewAnn;

main() {
  describe("directive lifecycle integration spec", () {
    it("should invoke lifecycle methods onChange > onInit > onCheck > onAllChangesDone",
        inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      tcb
          .overrideView(MyComp, new viewAnn.View(
              template: "<div [field]=\"123\" lifecycle></div>",
              directives: [LifecycleDir]))
          .createAsync(MyComp)
          .then((tc) {
        var dir = tc.componentViewChildren[0].inject(LifecycleDir);
        tc.detectChanges();
        expect(dir.log)
            .toEqual(["onChange", "onInit", "onCheck", "onAllChangesDone"]);
        tc.detectChanges();
        expect(dir.log).toEqual([
          "onChange",
          "onInit",
          "onCheck",
          "onAllChangesDone",
          "onCheck",
          "onAllChangesDone"
        ]);
        async.done();
      });
    }));
  });
}
@Directive(
    selector: "[lifecycle]",
    properties: const ["field"],
    lifecycle: const [
  LifecycleEvent.onChange,
  LifecycleEvent.onCheck,
  LifecycleEvent.onInit,
  LifecycleEvent.onAllChangesDone
])
class LifecycleDir {
  var field;
  List<String> log;
  LifecycleDir() {
    this.log = [];
  }
  onChange(_) {
    this.log.add("onChange");
  }
  onInit() {
    this.log.add("onInit");
  }
  onCheck() {
    this.log.add("onCheck");
  }
  onAllChangesDone() {
    this.log.add("onAllChangesDone");
  }
}
@Component(selector: "my-comp")
@View(directives: const [])
class MyComp {}
