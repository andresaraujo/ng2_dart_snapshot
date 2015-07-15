library angular2.test.change_detection.pipes.uppercase_pipe_spec;

import "package:angular2/test_lib.dart"
    show ddescribe, describe, it, iit, xit, expect, beforeEach, afterEach;
import "package:angular2/src/change_detection/pipes/uppercase_pipe.dart"
    show UpperCasePipe;

main() {
  describe("UpperCasePipe", () {
    var str;
    var upper;
    var lower;
    var pipe;
    beforeEach(() {
      str = "something";
      lower = "something";
      upper = "SOMETHING";
      pipe = new UpperCasePipe();
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
      it("should return uppercase", () {
        var val = pipe.transform(lower);
        expect(val).toEqual(upper);
      });
      it("should uppercase when there is a new value", () {
        var val = pipe.transform(lower);
        expect(val).toEqual(upper);
        var val2 = pipe.transform("wat");
        expect(val2).toEqual("WAT");
      });
    });
  });
}
