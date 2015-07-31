library angular2.test.facade.lang_spec;

import "package:angular2/test_lib.dart"
    show describe, it, expect, beforeEach, ddescribe, iit, xit, el;
import "package:angular2/src/facade/lang.dart"
    show isPresent, RegExpWrapper, RegExpMatcherWrapper, StringWrapper;

main() {
  describe("RegExp", () {
    it("should expose the index for each match", () {
      var re = new RegExp(r'(!)');
      var matcher = RegExpWrapper.matcher(re, "0!23!567!!");
      var indexes = [];
      var m;
      while (isPresent(m = RegExpMatcherWrapper.next(matcher))) {
        indexes.add(m.index);
        expect(m[0]).toEqual("!");
        expect(m[1]).toEqual("!");
        expect(m.length).toBe(2);
      }
      expect(indexes).toEqual([1, 4, 8, 9]);
    });
    it("should reset before it is reused", () {
      var re = new RegExp(r'^[' + "'" + r'"]');
      var str = "'";
      expect(RegExpWrapper.test(re, str)).toEqual(true);
      // If not reset, the second attempt to test results in false
      expect(RegExpWrapper.test(re, str)).toEqual(true);
    });
  });
  describe("const", () {
    it("should support const expressions both in TS and Dart", () {
      const numbers = const [1, 2, 3];
      expect(numbers).toEqual([1, 2, 3]);
    });
  });
  describe("String", () {
    var upper, lower;
    beforeEach(() {
      upper = "SOMETHING";
      lower = "something";
    });
    it("should upper case a string", () {
      var str = StringWrapper.toUpperCase(lower);
      expect(str).toEqual(upper);
    });
    it("should lower case a string", () {
      var str = StringWrapper.toLowerCase(upper);
      expect(str).toEqual(lower);
    });
  });
}
