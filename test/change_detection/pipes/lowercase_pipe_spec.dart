library angular2.test.change_detection.pipes.lowercase_pipe_spec;

import "package:angular2/test_lib.dart"
    show ddescribe, describe, it, iit, xit, expect, beforeEach, afterEach;
import "package:angular2/src/change_detection/pipes/lowercase_pipe.dart"
    show LowerCasePipe;

main() {
  describe("LowerCasePipe", () {
    var str;
    var upper;
    var lower;
    var pipe;
    beforeEach(() {
      str = "something";
      lower = "something";
      upper = "SOMETHING";
      pipe = new LowerCasePipe();
    });
    describe("supports", () {
      it("should support strings", () {
        expect(pipe.supports(str)).toBe(true);
      });
      it("should not support other objects", () {
        expect(pipe.supports(new Object())).toBe(false);
        expect(pipe.supports(null)).toBe(false);
      });
    });
    describe("transform", () {
      it("should return lowercase", () {
        var val = pipe.transform(upper);
        expect(val).toEqual(lower);
      });
      it("should lowercase when there is a new value", () {
        var val = pipe.transform(upper);
        expect(val).toEqual(lower);
        var val2 = pipe.transform("WAT");
        expect(val2).toEqual("wat");
      });
    });
  });
}
