library angular2.test.router.route_registry_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        describe,
        it,
        iit,
        ddescribe,
        expect,
        inject,
        beforeEach,
        SpyObject;
import "package:angular2/src/facade/async.dart" show Future, PromiseWrapper;
import "package:angular2/src/router/route_registry.dart" show RouteRegistry;
import "package:angular2/src/router/route_config_decorator.dart"
    show RouteConfig, Route, AsyncRoute;

main() {
  describe("RouteRegistry", () {
    var registry;
    beforeEach(() {
      registry = new RouteRegistry();
    });
    it("should match the full URL", inject([AsyncTestCompleter], (async) {
      registry.config(RootHostCmp, new Route(path: "/", component: DummyCmpA));
      registry.config(
          RootHostCmp, new Route(path: "/test", component: DummyCmpB));
      registry.recognize("/test", RootHostCmp).then((instruction) {
        expect(instruction.component).toBe(DummyCmpB);
        async.done();
      });
    }));
    it("should generate URLs starting at the given component", () {
      registry.config(RootHostCmp, new Route(
          path: "/first/...", component: DummyParentCmp, as: "firstCmp"));
      expect(registry.generate(["firstCmp", "secondCmp"], RootHostCmp))
          .toEqual("first/second");
      expect(registry.generate(["secondCmp"], DummyParentCmp))
          .toEqual("second");
    });
    it("should generate URLs with params", () {
      registry.config(RootHostCmp, new Route(
          path: "/first/:param/...",
          component: DummyParentParamCmp,
          as: "firstCmp"));
      var url = registry.generate([
        "firstCmp",
        {"param": "one"},
        "secondCmp",
        {"param": "two"}
      ], RootHostCmp);
      expect(url).toEqual("first/one/second/two");
    });
    it("should generate URLs of loaded components after they are loaded",
        inject([AsyncTestCompleter], (async) {
      registry.config(RootHostCmp, new AsyncRoute(
          path: "/first/...", loader: AsyncParentLoader, as: "firstCmp"));
      expect(() => registry.generate(["firstCmp", "secondCmp"], RootHostCmp))
          .toThrowError("Could not find route named \"secondCmp\".");
      registry.recognize("/first/second", RootHostCmp).then((_) {
        expect(registry.generate(["firstCmp", "secondCmp"], RootHostCmp))
            .toEqual("first/second");
        async.done();
      });
    }));
    it("should throw when generating a url and a parent has no config", () {
      expect(() => registry.generate(["firstCmp", "secondCmp"], RootHostCmp))
          .toThrowError("Component \"RootHostCmp\" has no route config.");
    });
    it("should prefer static segments to dynamic", inject([AsyncTestCompleter],
        (async) {
      registry.config(
          RootHostCmp, new Route(path: "/:site", component: DummyCmpB));
      registry.config(
          RootHostCmp, new Route(path: "/home", component: DummyCmpA));
      registry.recognize("/home", RootHostCmp).then((instruction) {
        expect(instruction.component).toBe(DummyCmpA);
        async.done();
      });
    }));
    it("should prefer dynamic segments to star", inject([AsyncTestCompleter],
        (async) {
      registry.config(
          RootHostCmp, new Route(path: "/:site", component: DummyCmpA));
      registry.config(
          RootHostCmp, new Route(path: "/*site", component: DummyCmpB));
      registry.recognize("/home", RootHostCmp).then((instruction) {
        expect(instruction.component).toBe(DummyCmpA);
        async.done();
      });
    }));
    it("should prefer routes with more dynamic segments", inject(
        [AsyncTestCompleter], (async) {
      registry.config(
          RootHostCmp, new Route(path: "/:first/*rest", component: DummyCmpA));
      registry.config(
          RootHostCmp, new Route(path: "/*all", component: DummyCmpB));
      registry.recognize("/some/path", RootHostCmp).then((instruction) {
        expect(instruction.component).toBe(DummyCmpA);
        async.done();
      });
    }));
    it("should prefer routes with more static segments", inject(
        [AsyncTestCompleter], (async) {
      registry.config(
          RootHostCmp, new Route(path: "/first/:second", component: DummyCmpA));
      registry.config(RootHostCmp,
          new Route(path: "/:first/:second", component: DummyCmpB));
      registry.recognize("/first/second", RootHostCmp).then((instruction) {
        expect(instruction.component).toBe(DummyCmpA);
        async.done();
      });
    }));
    it("should prefer routes with static segments before dynamic segments",
        inject([AsyncTestCompleter], (async) {
      registry.config(RootHostCmp,
          new Route(path: "/first/second/:third", component: DummyCmpB));
      registry.config(RootHostCmp,
          new Route(path: "/first/:second/third", component: DummyCmpA));
      registry
          .recognize("/first/second/third", RootHostCmp)
          .then((instruction) {
        expect(instruction.component).toBe(DummyCmpB);
        async.done();
      });
    }));
    it("should match the full URL using child components", inject(
        [AsyncTestCompleter], (async) {
      registry.config(RootHostCmp,
          new Route(path: "/first/...", component: DummyParentCmp));
      registry.recognize("/first/second", RootHostCmp).then((instruction) {
        expect(instruction.component).toBe(DummyParentCmp);
        expect(instruction.child.component).toBe(DummyCmpB);
        async.done();
      });
    }));
    it("should match the URL using async child components", inject(
        [AsyncTestCompleter], (async) {
      registry.config(
          RootHostCmp, new Route(path: "/first/...", component: DummyAsyncCmp));
      registry.recognize("/first/second", RootHostCmp).then((instruction) {
        expect(instruction.component).toBe(DummyAsyncCmp);
        expect(instruction.child.component).toBe(DummyCmpB);
        async.done();
      });
    }));
    it("should match the URL using an async parent component", inject(
        [AsyncTestCompleter], (async) {
      registry.config(RootHostCmp,
          new AsyncRoute(path: "/first/...", loader: AsyncParentLoader));
      registry.recognize("/first/second", RootHostCmp).then((instruction) {
        expect(instruction.component).toBe(DummyParentCmp);
        expect(instruction.child.component).toBe(DummyCmpB);
        async.done();
      });
    }));
    // TODO: not sure what to do with these tests

    // it('should throw when a config does not have a component or redirectTo property', () => {

    //  expect(() => registry.config(rootHostComponent, {'path': '/some/path'}))

    //      .toThrowError(

    //          'Route config should contain exactly one \'component\', or \'redirectTo\'

    //          property');

    //});

    //

    // it('should throw when a config has an invalid component type', () => {

    //  expect(() => registry.config(

    //             rootHostComponent,

    //             {'path': '/some/path', 'component': {'type':

    //             'intentionallyWrongComponentType'}}))

    //      .toThrowError('Invalid component type \'intentionallyWrongComponentType\'');

    //});
    it("should throw when a parent config is missing the `...` suffix any of its children add routes",
        () {
      expect(() => registry.config(RootHostCmp,
              new Route(path: "/", component: DummyParentCmp))).toThrowError(
          "Child routes are not allowed for \"/\". Use \"...\" on the parent's route path.");
    });
    it("should throw when a parent config uses `...` suffix before the end of the route",
        () {
      expect(() => registry.config(RootHostCmp, new Route(
              path: "/home/.../fun/", component: DummyParentCmp))).toThrowError(
          "Unexpected \"...\" before the end of the path for \"home/.../fun/\".");
    });
  });
}
AsyncParentLoader() {
  return PromiseWrapper.resolve(DummyParentCmp);
}
AsyncChildLoader() {
  return PromiseWrapper.resolve(DummyCmpB);
}
class RootHostCmp {}
@RouteConfig(
    const [const AsyncRoute(path: "/second", loader: AsyncChildLoader)])
class DummyAsyncCmp {}
class DummyCmpA {}
class DummyCmpB {}
@RouteConfig(
    const [const Route(path: "/second", component: DummyCmpB, as: "secondCmp")])
class DummyParentCmp {}
@RouteConfig(const [
  const Route(path: "/second/:param", component: DummyCmpB, as: "secondCmp")
])
class DummyParentParamCmp {}
