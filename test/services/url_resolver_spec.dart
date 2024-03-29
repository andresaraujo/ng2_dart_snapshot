library angular2.test.services.url_resolver_spec;

import "package:angular2/test_lib.dart"
    show describe, it, expect, beforeEach, ddescribe, iit, xit, el;
import "package:angular2/src/services/url_resolver.dart" show UrlResolver;

main() {
  describe("UrlResolver", () {
    var resolver = new UrlResolver();
    describe("absolute base url", () {
      it("should add a relative path to the base url", () {
        expect(resolver.resolve("http://www.foo.com", "bar"))
            .toEqual("http://www.foo.com/bar");
        expect(resolver.resolve("http://www.foo.com/", "bar"))
            .toEqual("http://www.foo.com/bar");
        expect(resolver.resolve("http://www.foo.com", "./bar"))
            .toEqual("http://www.foo.com/bar");
        expect(resolver.resolve("http://www.foo.com/", "./bar"))
            .toEqual("http://www.foo.com/bar");
      });
      it("should replace the base path", () {
        expect(resolver.resolve("http://www.foo.com/baz", "bar"))
            .toEqual("http://www.foo.com/bar");
        expect(resolver.resolve("http://www.foo.com/baz", "./bar"))
            .toEqual("http://www.foo.com/bar");
      });
      it("should append to the base path", () {
        expect(resolver.resolve("http://www.foo.com/baz/", "bar"))
            .toEqual("http://www.foo.com/baz/bar");
        expect(resolver.resolve("http://www.foo.com/baz/", "./bar"))
            .toEqual("http://www.foo.com/baz/bar");
      });
      it("should support \"..\" in the path", () {
        expect(resolver.resolve("http://www.foo.com/baz/", "../bar"))
            .toEqual("http://www.foo.com/bar");
        expect(resolver.resolve("http://www.foo.com/1/2/3/", "../../bar"))
            .toEqual("http://www.foo.com/1/bar");
        expect(resolver.resolve("http://www.foo.com/1/2/3/", "../biz/bar"))
            .toEqual("http://www.foo.com/1/2/biz/bar");
        expect(resolver.resolve("http://www.foo.com/1/2/baz", "../../bar"))
            .toEqual("http://www.foo.com/bar");
      });
      it("should ignore the base path when the url has a scheme", () {
        expect(resolver.resolve("http://www.foo.com", "http://www.bar.com"))
            .toEqual("http://www.bar.com");
      });
      it("should support absolute urls", () {
        expect(resolver.resolve("http://www.foo.com", "/bar"))
            .toEqual("http://www.foo.com/bar");
        expect(resolver.resolve("http://www.foo.com/", "/bar"))
            .toEqual("http://www.foo.com/bar");
        expect(resolver.resolve("http://www.foo.com/baz", "/bar"))
            .toEqual("http://www.foo.com/bar");
        expect(resolver.resolve("http://www.foo.com/baz/", "/bar"))
            .toEqual("http://www.foo.com/bar");
      });
    });
    describe("relative base url", () {
      it("should add a relative path to the base url", () {
        expect(resolver.resolve("foo/", "./bar")).toEqual("foo/bar");
        expect(resolver.resolve("foo/baz", "./bar")).toEqual("foo/bar");
        expect(resolver.resolve("foo/baz", "bar")).toEqual("foo/bar");
      });
      it("should support \"..\" in the path", () {
        expect(resolver.resolve("foo/baz", "../bar")).toEqual("bar");
        expect(resolver.resolve("foo/baz", "../biz/bar")).toEqual("biz/bar");
      });
      it("should support absolute urls", () {
        expect(resolver.resolve("foo/baz", "/bar")).toEqual("/bar");
        expect(resolver.resolve("foo/baz/", "/bar")).toEqual("/bar");
      });
    });
  });
}
