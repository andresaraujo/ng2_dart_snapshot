library angular2.test.router.router_link_spec;

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
        proxy,
        SpyObject,
        By;
import "package:angular2/angular2.dart" show bind, Component, View;
import "package:angular2/router.dart" show Location, Router, RouterLink;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;

main() {
  describe("router-link directive", () {
    beforeEachBindings(() => [
      bind(Location).toValue(makeDummyLocation()),
      bind(Router).toValue(makeDummyRouter())
    ]);
    it("should update a[href] attribute", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (tcb, async) {
      tcb.createAsync(TestComponent).then((testComponent) {
        testComponent.detectChanges();
        var anchorElement = testComponent.query(By.css("a")).nativeElement;
        expect(DOM.getAttribute(anchorElement, "href")).toEqual("/detail");
        async.done();
      });
    }));
    it("should call router.navigate when a link is clicked", inject([
      TestComponentBuilder,
      AsyncTestCompleter,
      Router
    ], (tcb, async, router) {
      tcb.createAsync(TestComponent).then((testComponent) {
        testComponent.detectChanges();
        // TODO: shouldn't this be just 'click' rather than '^click'?
        testComponent.query(By.css("a")).triggerEventHandler("^click", {});
        expect(router.spy("navigate")).toHaveBeenCalledWith("/detail");
        async.done();
      });
    }));
  });
}
@Component(selector: "test-component")
@View(template: '''
    <div>
      <a [router-link]="[\'/detail\']">detail view</a>
    </div>''', directives: const [RouterLink])
class TestComponent {}
@proxy()
class DummyLocation extends SpyObject implements Location {
  noSuchMethod(m) {
    return super.noSuchMethod(m);
  }
}
makeDummyLocation() {
  var dl = new DummyLocation();
  dl.spy("normalizeAbsolutely").andCallFake((url) => url);
  return dl;
}
@proxy()
class DummyRouter extends SpyObject implements Router {
  noSuchMethod(m) {
    return super.noSuchMethod(m);
  }
}
makeDummyRouter() {
  var dr = new DummyRouter();
  dr.spy("generate").andCallFake((routeParams) => routeParams.join("="));
  dr.spy("navigate");
  return dr;
}
