library angular2.test.router.location_spec;

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
import "package:angular2/di.dart" show Injector, bind;
import "package:angular2/src/router/location.dart"
    show Location, appBaseHrefToken;
import "package:angular2/src/router/location_strategy.dart"
    show LocationStrategy;
import "package:angular2/src/mock/mock_location_strategy.dart"
    show MockLocationStrategy;

main() {
  describe("Location", () {
    var locationStrategy, location;
    Location makeLocation(
        [String baseHref = "/my/app", dynamic binding = const []]) {
      locationStrategy = new MockLocationStrategy();
      locationStrategy.internalBaseHref = baseHref;
      var injector = Injector.resolveAndCreate([
        Location,
        bind(LocationStrategy).toValue(locationStrategy),
        binding
      ]);
      return location = injector.get(Location);
    }
    beforeEach(makeLocation);
    it("should normalize relative urls on navigate", () {
      location.go("user/btford");
      expect(locationStrategy.path()).toEqual("/my/app/user/btford");
    });
    it("should not prepend urls with starting slash when an empty URL is provided",
        () {
      expect(location.normalizeAbsolutely(""))
          .toEqual(locationStrategy.getBaseHref());
    });
    it("should not prepend path with an extra slash when a baseHref has a trailing slash",
        () {
      var location = makeLocation("/my/slashed/app/");
      expect(location.normalizeAbsolutely("/page"))
          .toEqual("/my/slashed/app/page");
    });
    it("should not append urls with leading slash on navigate", () {
      location.go("/my/app/user/btford");
      expect(locationStrategy.path()).toEqual("/my/app/user/btford");
    });
    it("should remove index.html from base href", () {
      var location = makeLocation("/my/app/index.html");
      location.go("user/btford");
      expect(locationStrategy.path()).toEqual("/my/app/user/btford");
    });
    it("should normalize urls on popstate", inject([AsyncTestCompleter],
        (async) {
      locationStrategy.simulatePopState("/my/app/user/btford");
      location.subscribe((ev) {
        expect(ev["url"]).toEqual("/user/btford");
        async.done();
      });
    }));
    it("should normalize location path", () {
      locationStrategy.internalPath = "/my/app/user/btford";
      expect(location.path()).toEqual("/user/btford");
    });
    it("should use optional base href param", () {
      var location =
          makeLocation("/", bind(appBaseHrefToken).toValue("/my/custom/href"));
      location.go("user/btford");
      expect(locationStrategy.path()).toEqual("/my/custom/href/user/btford");
    });
    it("should throw when no base href is provided", () {
      var locationStrategy = new MockLocationStrategy();
      locationStrategy.internalBaseHref = null;
      expect(() => new Location(locationStrategy)).toThrowError(
          '''No base href set. Either provide a binding to "appBaseHrefToken" or add a base element.''');
    });
  });
}
