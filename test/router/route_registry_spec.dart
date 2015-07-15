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
import "package:angular2/src/facade/collection.dart" show ListWrapper;
import "package:angular2/src/router/route_registry.dart" show RouteRegistry;
import "package:angular2/src/router/route_config_decorator.dart"
    show RouteConfig;

main() {
  describe("RouteRegistry", () {
    var registry,
        rootHostComponent = new Object();
    beforeEach(() {
      registry = new RouteRegistry();
    });
    it("should match the full URL", inject([AsyncTestCompleter], (async) {
      registry.config(
          rootHostComponent, {"path": "/", "component": DummyCompA});
      registry.config(
          rootHostComponent, {"path": "/test", "component": DummyCompB});
      registry.recognize("/test", rootHostComponent).then((instruction) {
        expect(instruction.component).toBe(DummyCompB);
        async.done();
      });
    }));
    it("should generate URLs starting at the given component", () {
      registry.config(rootHostComponent, {
        "path": "/first/...",
        "component": DummyParentComp,
        "as": "firstCmp"
      });
      expect(registry.generate(["firstCmp", "secondCmp"], rootHostComponent))
          .toEqual("first/second");
      expect(registry.generate(["secondCmp"], DummyParentComp))
          .toEqual("second");
    });
    it("should generate URLs with params", () {
      registry.config(rootHostComponent, {
        "path": "/first/:param/...",
        "component": DummyParentParamComp,
        "as": "firstCmp"
      });
      var url = registry.generate([
        "firstCmp",
        {"param": "one"},
        "secondCmp",
        {"param": "two"}
      ], rootHostComponent);
      expect(url).toEqual("first/one/second/two");
    });
    it("should generate URLs of loaded components after they are loaded",
        inject([AsyncTestCompleter], (async) {
      registry.config(rootHostComponent, {
        "path": "/first/...",
        "component": {"type": "loader", "loader": AsyncParentLoader},
        "as": "firstCmp"
      });
      expect(() =>
              registry.generate(["firstCmp", "secondCmp"], rootHostComponent))
          .toThrowError("Could not find route config for \"secondCmp\".");
      registry.recognize("/first/second", rootHostComponent).then((_) {
        expect(registry.generate(["firstCmp", "secondCmp"], rootHostComponent))
            .toEqual("first/second");
        async.done();
      });
    }));
    it("should prefer static segments to dynamic", inject([AsyncTestCompleter],
        (async) {
      registry.config(
          rootHostComponent, {"path": "/:site", "component": DummyCompB});
      registry.config(
          rootHostComponent, {"path": "/home", "component": DummyCompA});
      registry.recognize("/home", rootHostComponent).then((instruction) {
        expect(instruction.component).toBe(DummyCompA);
        async.done();
      });
    }));
    it("should prefer dynamic segments to star", inject([AsyncTestCompleter],
        (async) {
      registry.config(
          rootHostComponent, {"path": "/:site", "component": DummyCompA});
      registry.config(
          rootHostComponent, {"path": "/*site", "component": DummyCompB});
      registry.recognize("/home", rootHostComponent).then((instruction) {
        expect(instruction.component).toBe(DummyCompA);
        async.done();
      });
    }));
    it("should prefer routes with more dynamic segments", inject(
        [AsyncTestCompleter], (async) {
      registry.config(rootHostComponent, {
        "path": "/:first/*rest",
        "component": DummyCompA
      });
      registry.config(
          rootHostComponent, {"path": "/*all", "component": DummyCompB});
      registry.recognize("/some/path", rootHostComponent).then((instruction) {
        expect(instruction.component).toBe(DummyCompA);
        async.done();
      });
    }));
    it("should prefer routes with more static segments", inject(
        [AsyncTestCompleter], (async) {
      registry.config(rootHostComponent, {
        "path": "/first/:second",
        "component": DummyCompA
      });
      registry.config(rootHostComponent, {
        "path": "/:first/:second",
        "component": DummyCompB
      });
      registry
          .recognize("/first/second", rootHostComponent)
          .then((instruction) {
        expect(instruction.component).toBe(DummyCompA);
        async.done();
      });
    }));
    it("should prefer routes with static segments before dynamic segments",
        inject([AsyncTestCompleter], (async) {
      registry.config(rootHostComponent, {
        "path": "/first/second/:third",
        "component": DummyCompB
      });
      registry.config(rootHostComponent, {
        "path": "/first/:second/third",
        "component": DummyCompA
      });
      registry
          .recognize("/first/second/third", rootHostComponent)
          .then((instruction) {
        expect(instruction.component).toBe(DummyCompB);
        async.done();
      });
    }));
    it("should match the full URL using child components", inject(
        [AsyncTestCompleter], (async) {
      registry.config(rootHostComponent, {
        "path": "/first/...",
        "component": DummyParentComp
      });
      registry
          .recognize("/first/second", rootHostComponent)
          .then((instruction) {
        expect(instruction.component).toBe(DummyParentComp);
        expect(instruction.child.component).toBe(DummyCompB);
        async.done();
      });
    }));
    it("should match the URL using async child components", inject(
        [AsyncTestCompleter], (async) {
      registry.config(rootHostComponent, {
        "path": "/first/...",
        "component": DummyAsyncComp
      });
      registry
          .recognize("/first/second", rootHostComponent)
          .then((instruction) {
        expect(instruction.component).toBe(DummyAsyncComp);
        expect(instruction.child.component).toBe(DummyCompB);
        async.done();
      });
    }));
    it("should match the URL using an async parent component", inject(
        [AsyncTestCompleter], (async) {
      registry.config(rootHostComponent, {
        "path": "/first/...",
        "component": {"loader": AsyncParentLoader, "type": "loader"}
      });
      registry
          .recognize("/first/second", rootHostComponent)
          .then((instruction) {
        expect(instruction.component).toBe(DummyParentComp);
        expect(instruction.child.component).toBe(DummyCompB);
        async.done();
      });
    }));
    it("should throw when a config does not have a component or redirectTo property",
        () {
      expect(() => registry.config(
              rootHostComponent, {"path": "/some/path"})).toThrowError(
          "Route config should contain exactly one 'component', or 'redirectTo' property");
    });
    it("should throw when a config has an invalid component type", () {
      expect(() => registry.config(rootHostComponent, {
        "path": "/some/path",
        "component": {"type": "intentionallyWrongComponentType"}
      })).toThrowError(
          "Invalid component type 'intentionallyWrongComponentType'");
    });
    it("should throw when a parent config is missing the `...` suffix any of its children add routes",
        () {
      expect(() => registry.config(rootHostComponent, {
        "path": "/",
        "component": DummyParentComp
      })).toThrowError(
          "Child routes are not allowed for \"/\". Use \"...\" on the parent's route path.");
    });
    it("should throw when a parent config is missing the `...` suffix any of its children add routes",
        () {
      expect(() => registry.config(rootHostComponent, {
        "path": "/home/.../fun/",
        "component": DummyParentComp
      })).toThrowError(
          "Unexpected \"...\" before the end of the path for \"home/.../fun/\".");
    });
  });
}
AsyncParentLoader() {
  return PromiseWrapper.resolve(DummyParentComp);
}
AsyncChildLoader() {
  return PromiseWrapper.resolve(DummyCompB);
}
@RouteConfig(const [
  const {
    "path": "/second",
    "component": const {"loader": AsyncChildLoader, "type": "loader"}
  }
])
class DummyAsyncComp {}
class DummyCompA {}
class DummyCompB {}
@RouteConfig(const [
  const {"path": "/second", "component": DummyCompB, "as": "secondCmp"}
])
class DummyParentComp {}
@RouteConfig(const [
  const {"path": "/second/:param", "component": DummyCompB, "as": "secondCmp"}
])
class DummyParentParamComp {}
