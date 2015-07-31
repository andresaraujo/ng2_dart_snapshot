library angular2.test.router.router_integration_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        beforeEach,
        beforeEachBindings,
        ddescribe,
        describe,
        expect,
        iit,
        flushMicrotasks,
        inject,
        it,
        xdescribe,
        TestComponentBuilder,
        xit;
import "package:angular2/src/core/application.dart" show bootstrap;
import "package:angular2/src/core/annotations/decorators.dart"
    show Component, Directive, View;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/di.dart" show bind;
import "package:angular2/src/render/render.dart" show DOCUMENT_TOKEN;
import "package:angular2/src/router/route_config_decorator.dart"
    show RouteConfig, Route, Redirect;
import "package:angular2/src/facade/async.dart" show PromiseWrapper;
import "package:angular2/src/facade/lang.dart" show BaseException;
import "package:angular2/router.dart"
    show
        routerInjectables,
        RouteParams,
        Router,
        appBaseHrefToken,
        routerDirectives;
import "package:angular2/src/router/location_strategy.dart"
    show LocationStrategy;
import "package:angular2/src/mock/mock_location_strategy.dart"
    show MockLocationStrategy;
import "package:angular2/src/core/application_tokens.dart"
    show appComponentTypeToken;

main() {
  describe("router injectables", () {
    beforeEachBindings(() {
      return [
        routerInjectables,
        bind(LocationStrategy).toClass(MockLocationStrategy)
      ];
    });
    // do not refactor out the `bootstrap` functionality. We still want to

    // keep this test around so we can ensure that bootstrapping a router works
    describe("boostrap functionality", () {
      it("should bootstrap a simple app", inject([AsyncTestCompleter], (async) {
        var fakeDoc = DOM.createHtmlDocument();
        var el = DOM.createElement("app-cmp", fakeDoc);
        DOM.appendChild(fakeDoc.body, el);
        bootstrap(AppCmp, [
          routerInjectables,
          bind(LocationStrategy).toClass(MockLocationStrategy),
          bind(DOCUMENT_TOKEN).toValue(fakeDoc)
        ]).then((applicationRef) {
          var router = applicationRef.hostComponent.router;
          router.subscribe((_) {
            expect(el).toHaveText("outer { hello }");
            expect(applicationRef.hostComponent.location.path()).toEqual("");
            async.done();
          });
        });
      }));
    });
    describe("broken app", () {
      beforeEachBindings(() {
        return [bind(appComponentTypeToken).toValue(BrokenAppCmp)];
      });
      it("should rethrow exceptions from component constructors", inject([
        AsyncTestCompleter,
        TestComponentBuilder
      ], (async, TestComponentBuilder tcb) {
        tcb.createAsync(AppCmp).then((rootTC) {
          var router = rootTC.componentInstance.router;
          PromiseWrapper.catchError(router.navigate("/cause-error"), (error) {
            expect(rootTC.nativeElement).toHaveText("outer { oh no }");
            expect(error).toContainError("oops!");
            async.done();
          });
        });
      }));
    });
    describe("hierarchical app", () {
      beforeEachBindings(() {
        return [bind(appComponentTypeToken).toValue(HierarchyAppCmp)];
      });
      it("should bootstrap an app with a hierarchy", inject([
        AsyncTestCompleter,
        TestComponentBuilder
      ], (async, TestComponentBuilder tcb) {
        tcb.createAsync(HierarchyAppCmp).then((rootTC) {
          var router = rootTC.componentInstance.router;
          router.subscribe((_) {
            expect(rootTC.nativeElement)
                .toHaveText("root { parent { hello } }");
            expect(rootTC.componentInstance.location.path())
                .toEqual("/parent/child");
            async.done();
          });
          router.navigate("/parent/child");
        });
      }));
      describe("custom app base ref", () {
        beforeEachBindings(() {
          return [bind(appBaseHrefToken).toValue("/my/app")];
        });
        it("should bootstrap", inject([
          AsyncTestCompleter,
          TestComponentBuilder
        ], (async, TestComponentBuilder tcb) {
          tcb.createAsync(HierarchyAppCmp).then((rootTC) {
            var router = rootTC.componentInstance.router;
            router.subscribe((_) {
              expect(rootTC.nativeElement)
                  .toHaveText("root { parent { hello } }");
              expect(rootTC.componentInstance.location.path())
                  .toEqual("/my/app/parent/child");
              async.done();
            });
            router.navigate("/parent/child");
          });
        }));
      });
    });
    // TODO: add a test in which the child component has bindings
    describe("querystring params app", () {
      beforeEachBindings(() {
        return [bind(appComponentTypeToken).toValue(QueryStringAppCmp)];
      });
      it("should recognize and return querystring params with the injected RouteParams",
          inject([
        AsyncTestCompleter,
        TestComponentBuilder
      ], (async, TestComponentBuilder tcb) {
        tcb.createAsync(QueryStringAppCmp).then((rootTC) {
          var router = rootTC.componentInstance.router;
          router.subscribe((_) {
            rootTC.detectChanges();
            expect(rootTC.nativeElement)
                .toHaveText("qParam = search-for-something");
            /*
                   expect(applicationRef.hostComponent.location.path())
                       .toEqual('/qs?q=search-for-something');*/
            async.done();
          });
          router.navigate("/qs?q=search-for-something");
          rootTC.detectChanges();
        });
      }));
    });
  });
}
@Component(selector: "hello-cmp")
@View(template: "hello")
class HelloCmp {}
@Component(selector: "app-cmp")
@View(
    template: "outer { <router-outlet></router-outlet> }",
    directives: routerDirectives)
@RouteConfig(const [const Route(path: "/", component: HelloCmp)])
class AppCmp {
  Router router;
  LocationStrategy location;
  AppCmp(this.router, this.location) {}
}
@Component(selector: "parent-cmp")
@View(
    template: '''parent { <router-outlet></router-outlet> }''',
    directives: routerDirectives)
@RouteConfig(const [const Route(path: "/child", component: HelloCmp)])
class ParentCmp {}
@Component(selector: "app-cmp")
@View(
    template: '''root { <router-outlet></router-outlet> }''',
    directives: routerDirectives)
@RouteConfig(const [const Route(path: "/parent/...", component: ParentCmp)])
class HierarchyAppCmp {
  Router router;
  LocationStrategy location;
  HierarchyAppCmp(this.router, this.location) {}
}
@Component(selector: "qs-cmp")
@View(template: "qParam = {{q}}")
class QSCmp {
  String q;
  QSCmp(RouteParams params) {
    this.q = params.get("q");
  }
}
@Component(selector: "app-cmp")
@View(
    template: '''<router-outlet></router-outlet>''',
    directives: routerDirectives)
@RouteConfig(const [const Route(path: "/qs", component: QSCmp)])
class QueryStringAppCmp {
  Router router;
  LocationStrategy location;
  QueryStringAppCmp(this.router, this.location) {}
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
    template: '''outer { <router-outlet></router-outlet> }''',
    directives: routerDirectives)
@RouteConfig(const [const Route(path: "/cause-error", component: BrokenCmp)])
class BrokenAppCmp {
  Router router;
  LocationStrategy location;
  BrokenAppCmp(this.router, this.location) {}
}
