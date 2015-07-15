library angular2.test.router.router_integration_spec;

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
        xit;
import "package:angular2/src/core/application.dart" show bootstrap;
import "package:angular2/src/core/annotations/decorators.dart"
    show Component, Directive, View;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/di.dart" show bind;
import "package:angular2/src/render/dom/dom_renderer.dart" show DOCUMENT_TOKEN;
import "package:angular2/src/router/route_config_decorator.dart"
    show RouteConfig;
import "package:angular2/src/facade/async.dart" show PromiseWrapper;
import "package:angular2/src/facade/lang.dart" show BaseException;
import "package:angular2/router.dart"
    show routerInjectables, Router, appBaseHrefToken, routerDirectives;
import "package:angular2/src/router/location_strategy.dart"
    show LocationStrategy;
import "package:angular2/src/mock/mock_location_strategy.dart"
    show MockLocationStrategy;

main() {
  describe("router injectables", () {
    var fakeDoc, el, testBindings;
    beforeEach(() {
      fakeDoc = DOM.createHtmlDocument();
      el = DOM.createElement("app-cmp", fakeDoc);
      DOM.appendChild(fakeDoc.body, el);
      testBindings = [
        routerInjectables,
        bind(LocationStrategy).toClass(MockLocationStrategy),
        bind(DOCUMENT_TOKEN).toValue(fakeDoc)
      ];
    });
    it("should bootstrap a simple app", inject([AsyncTestCompleter], (async) {
      bootstrap(AppCmp, testBindings).then((applicationRef) {
        var router = applicationRef.hostComponent.router;
        router.subscribe((_) {
          expect(el).toHaveText("outer { hello }");
          expect(applicationRef.hostComponent.location.path()).toEqual("");
          async.done();
        });
      });
    }));
    it("should rethrow exceptions from component constructors", inject(
        [AsyncTestCompleter], (async) {
      bootstrap(BrokenAppCmp, testBindings).then((applicationRef) {
        var router = applicationRef.hostComponent.router;
        PromiseWrapper.catchError(router.navigate("/cause-error"), (error) {
          expect(el).toHaveText("outer { oh no }");
          expect(error.message).toContain("oops!");
          async.done();
        });
      });
    }));
    it("should bootstrap an app with a hierarchy", inject([AsyncTestCompleter],
        (async) {
      bootstrap(HierarchyAppCmp, testBindings).then((applicationRef) {
        var router = applicationRef.hostComponent.router;
        router.subscribe((_) {
          expect(el).toHaveText("root { parent { hello } }");
          expect(applicationRef.hostComponent.location.path())
              .toEqual("/parent/child");
          async.done();
        });
        router.navigate("/parent/child");
      });
    }));
    it("should bootstrap an app with a custom app base href", inject(
        [AsyncTestCompleter], (async) {
      bootstrap(HierarchyAppCmp, [
        testBindings,
        bind(appBaseHrefToken).toValue("/my/app")
      ]).then((applicationRef) {
        var router = applicationRef.hostComponent.router;
        router.subscribe((_) {
          expect(el).toHaveText("root { parent { hello } }");
          expect(applicationRef.hostComponent.location.path())
              .toEqual("/my/app/parent/child");
          async.done();
        });
        router.navigate("/parent/child");
      });
    }));
  });
}
@Component(selector: "hello-cmp")
@View(template: "hello")
class HelloCmp {}
@Component(selector: "app-cmp")
@View(
    template: "outer { <router-outlet></router-outlet> }",
    directives: routerDirectives)
@RouteConfig(const [const {"path": "/", "component": HelloCmp}])
class AppCmp {
  Router router;
  LocationStrategy location;
  AppCmp(this.router, this.location) {}
}
@Component(selector: "parent-cmp")
@View(
    template: '''parent { <router-outlet></router-outlet> }''',
    directives: routerDirectives)
@RouteConfig(const [const {"path": "/child", "component": HelloCmp}])
class ParentCmp {}
@Component(selector: "app-cmp")
@View(
    template: '''root { <router-outlet></router-outlet> }''',
    directives: routerDirectives)
@RouteConfig(const [const {"path": "/parent/...", "component": ParentCmp}])
class HierarchyAppCmp {
  Router router;
  LocationStrategy location;
  HierarchyAppCmp(this.router, this.location) {}
}
@Component(selector: "oops-cmp")
@View(template: "oh no")
class BrokenCmp {
  BrokenCmp() {
    throw new BaseException("oops!");
  }
}
@Component(selector: "app-cmp")
@View(
    template: "outer { <router-outlet></router-outlet> }",
    directives: routerDirectives)
@RouteConfig(const [const {"path": "/cause-error", "component": BrokenCmp}])
class BrokenAppCmp {
  Router router;
  LocationStrategy location;
  BrokenAppCmp(this.router, this.location) {}
}
