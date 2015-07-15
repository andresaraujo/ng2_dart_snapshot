library angular2.test.change_detection.pipes.json_pipe_spec;

import "package:angular2/test_lib.dart"
    show
        ddescribe,
        describe,
        it,
        iit,
        xit,
        expect,
        beforeEach,
        afterEach,
        AsyncTestCompleter,
        inject,
        proxy,
        SpyObject,
        IS_DARTIUM;
import "package:angular2/src/facade/lang.dart"
    show Json, RegExp, NumberWrapper, StringWrapper;
import "package:angular2/src/change_detection/pipes/json_pipe.dart"
    show JsonPipe;

main() {
  describe("JsonPipe", () {
    var regNewLine = "\n";
    var canHasUndefined;
    var inceptionObj;
    var inceptionObjString;
    var catString;
    var pipe;
    List<num> collection;
    String normalize(String obj) {
      return StringWrapper.replace(obj, regNewLine, "");
    }
    beforeEach(() {
      inceptionObj = {"dream": {"dream": {"dream": "Limbo"}}};
      inceptionObjString = "{\n" +
          "  \"dream\": {\n" +
          "    \"dream\": {\n" +
          "      \"dream\": \"Limbo\"\n" +
          "    }\n" +
          "  }\n" +
          "}";
      catString = "Inception Cat";
      pipe = new JsonPipe();
      collection = [];
    });
    describe("supports", () {
      it("should support objects", () {
        expect(pipe.supports(inceptionObj)).toBe(true);
      });
      it("should support strings", () {
        expect(pipe.supports(catString)).toBe(true);
      });
      it("should support null", () {
        expect(pipe.supports(null)).toBe(true);
      });
      it("should support NaN", () {
        expect(pipe.supports(NumberWrapper.NaN)).toBe(true);
      });
      if (!IS_DARTIUM) {
        it("should support undefined", () {
          expect(pipe.supports(canHasUndefined)).toBe(true);
        });
      }
    });
    describe("transform", () {
      it("should return JSON-formatted string", () {
        expect(pipe.transform(inceptionObj)).toEqual(inceptionObjString);
      });
      it("should return JSON-formatted string even when normalized", () {
        var dream1 = normalize(pipe.transform(inceptionObj));
        var dream2 = normalize(inceptionObjString);
        expect(dream1).toEqual(dream2);
      });
      it("should return JSON-formatted string similar to Json.stringify", () {
        var dream1 = normalize(pipe.transform(inceptionObj));
        var dream2 = normalize(Json.stringify(inceptionObj));
        expect(dream1).toEqual(dream2);
      });
      it("should return same ref when nothing has changed since the last call",
          () {
        expect(pipe.transform(inceptionObj)).toEqual(inceptionObjString);
        expect(pipe.transform(inceptionObj)).toEqual(inceptionObjString);
      });
      it("should return a new value when something changed but the ref hasn't",
          () {
        var stringCollection = "[]";
        var stringCollectionWith1 = "[\n" + "  1" + "\n]";
        expect(pipe.transform(collection)).toEqual(stringCollection);
        collection.add(1);
        expect(pipe.transform(collection)).toEqual(stringCollectionWith1);
      });
    });
    describe("onDestroy", () {
      it("should do nothing when no latest value", () {
        expect(() => pipe.onDestroy()).not.toThrow();
      });
    });
  });
}
