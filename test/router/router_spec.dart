library angular2.test.router.router_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        describe,
        proxy,
        it,
        iit,
        ddescribe,
        expect,
        inject,
        beforeEach,
        beforeEachBindings,
        SpyObject;
import "package:angular2/src/facade/async.dart" show Future, PromiseWrapper;
import "package:angular2/src/facade/collection.dart" show ListWrapper;
import "package:angular2/src/router/router.dart" show Router, RootRouter;
import "package:angular2/src/router/pipeline.dart" show Pipeline;
import "package:angular2/src/router/router_outlet.dart" show RouterOutlet;
import "package:angular2/src/mock/location_mock.dart" show SpyLocation;
import "package:angular2/src/router/location.dart" show Location;
import "package:angular2/src/router/route_registry.dart" show RouteRegistry;
import "package:angular2/src/router/route_config_decorator.dart"
    show RouteConfig;
import "package:angular2/src/core/compiler/directive_resolver.dart"
    show DirectiveResolver;
import "package:angular2/di.dart" show bind;

main() {
  describe("Router", () {
    var router, location;
    beforeEachBindings(() => [
      Pipeline,
      RouteRegistry,
      DirectiveResolver,
      bind(Location).toClass(SpyLocation),
      bind(Router).toFactory((registry, pipeline, location) {
        return new RootRouter(registry, pipeline, location, AppCmp);
      }, [RouteRegistry, Pipeline, Location])
    ]);
    beforeEach(inject([Router, Location], (rtr, loc) {
      router = rtr;
      location = loc;
    }));
    it("should navigate based on the initial URL state", inject(
        [AsyncTestCompleter], (async) {
      var outlet = makeDummyOutlet();
      router
          .config({"path": "/", "component": DummyComponent})
          .then((_) => router.registerOutlet(outlet))
          .then((_) {
        expect(outlet.spy("commit")).toHaveBeenCalled();
        expect(location.urlChanges).toEqual([]);
        async.done();
      });
    }));
    it("should activate viewports and update URL on navigate", inject(
        [AsyncTestCompleter], (async) {
      var outlet = makeDummyOutlet();
      router
          .registerOutlet(outlet)
          .then(
              (_) => router.config({"path": "/a", "component": DummyComponent}))
          .then((_) => router.navigate("/a"))
          .then((_) {
        expect(outlet.spy("commit")).toHaveBeenCalled();
        expect(location.urlChanges).toEqual(["/a"]);
        async.done();
      });
    }));
    it("should navigate after being configured", inject([AsyncTestCompleter],
        (async) {
      var outlet = makeDummyOutlet();
      router
          .registerOutlet(outlet)
          .then((_) => router.navigate("/a"))
          .then((_) {
        expect(outlet.spy("commit")).not.toHaveBeenCalled();
        return router.config({"path": "/a", "component": DummyComponent});
      }).then((_) {
        expect(outlet.spy("commit")).toHaveBeenCalled();
        async.done();
      });
    }));
    it("should throw when linkParams does not start with a \"/\" or \"./\"",
        () {
      expect(() => router.generate(["firstCmp", "secondCmp"])).toThrowError(
          '''Link "${ ListWrapper . toJSON ( [ "firstCmp" , "secondCmp" ] )}" must start with "/", "./", or "../"''');
    });
    it("should throw when linkParams does not include a route name", () {
      expect(() => router.generate(["./"])).toThrowError(
          '''Link "${ ListWrapper . toJSON ( [ "./" ] )}" must include a route name.''');
      expect(() => router.generate(["/"])).toThrowError(
          '''Link "${ ListWrapper . toJSON ( [ "/" ] )}" must include a route name.''');
    });
    it("should generate URLs from the root component when the path starts with /",
        () {
      router.config({
        "path": "/first/...",
        "component": DummyParentComp,
        "as": "firstCmp"
      });
      expect(router.generate(["/firstCmp", "secondCmp"]))
          .toEqual("/first/second");
      expect(router.generate(["/firstCmp", "secondCmp"]))
          .toEqual("/first/second");
      expect(router.generate(["/firstCmp/secondCmp"])).toEqual("/first/second");
    });
    describe("matrix params", () {
      it("should apply inline matrix params for each router path within the generated URL",
          () {
        router.config({
          "path": "/first/...",
          "component": DummyParentComp,
          "as": "firstCmp"
        });
        var path = router.generate([
          "/firstCmp",
          {"key": "value"},
          "secondCmp",
          {"project": "angular"}
        ]);
        expect(path).toEqual("/first;key=value/second;project=angular");
      });
      it("should apply inline matrix params for each router path within the generated URL and also include named params",
          () {
        router.config({
          "path": "/first/:token/...",
          "component": DummyParentComp,
          "as": "firstCmp"
        });
        var path = router.generate(
            ["/firstCmp", {"token": "min"}, "secondCmp", {"author": "max"}]);
        expect(path).toEqual("/first/min/second;author=max");
      });
    });
  });
}
@proxy
class DummyOutlet extends SpyObject implements RouterOutlet {
  noSuchMethod(m) {
    return super.noSuchMethod(m);
  }
}
class DummyComponent {}
@RouteConfig(const [
  const {"path": "/second", "component": DummyComponent, "as": "secondCmp"}
])
class DummyParentComp {}
makeDummyOutlet() {
  var ref = new DummyOutlet();
  ref.spy("canActivate").andCallFake((_) => PromiseWrapper.resolve(true));
  ref.spy("canReuse").andCallFake((_) => PromiseWrapper.resolve(false));
  ref.spy("canDeactivate").andCallFake((_) => PromiseWrapper.resolve(true));
  ref.spy("commit").andCallFake((_) => PromiseWrapper.resolve(true));
  return ref;
}
class AppCmp {}
