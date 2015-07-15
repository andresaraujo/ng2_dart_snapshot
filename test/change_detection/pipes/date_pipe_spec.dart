library angular2.test.change_detection.pipes.date_pipe_spec;

import "package:angular2/test_lib.dart"
    show ddescribe, describe, it, iit, xit, expect, beforeEach, afterEach;
import "package:angular2/src/change_detection/pipes/date_pipe.dart"
    show DatePipe;
import "package:angular2/src/facade/lang.dart" show DateWrapper;

main() {
  describe("DatePipe", () {
    var date;
    var pipe;
    beforeEach(() {
      date = DateWrapper.create(2015, 6, 15, 21, 43, 11);
      pipe = new DatePipe();
    });
    describe("supports", () {
      it("should support date", () {
        expect(pipe.supports(date)).toBe(true);
      });
      it("should support int", () {
        expect(pipe.supports(123456789)).toBe(true);
      });
      it("should not support other objects", () {
        expect(pipe.supports(new Object())).toBe(false);
        expect(pipe.supports(null)).toBe(false);
      });
    });
    describe("transform", () {
      it("should format each component correctly", () {
        expect(pipe.transform(date, ["y"])).toEqual("2015");
        expect(pipe.transform(date, ["yy"])).toEqual("15");
        expect(pipe.transform(date, ["M"])).toEqual("6");
        expect(pipe.transform(date, ["MM"])).toEqual("06");
        expect(pipe.transform(date, ["MMM"])).toEqual("Jun");
        expect(pipe.transform(date, ["MMMM"])).toEqual("June");
        expect(pipe.transform(date, ["d"])).toEqual("15");
        expect(pipe.transform(date, ["E"])).toEqual("Mon");
        expect(pipe.transform(date, ["EEEE"])).toEqual("Monday");
        expect(pipe.transform(date, ["H"])).toEqual("21");
        expect(pipe.transform(date, ["j"])).toEqual("9 PM");
        expect(pipe.transform(date, ["m"])).toEqual("43");
        expect(pipe.transform(date, ["s"])).toEqual("11");
      });
      it("should format common multi component patterns", () {
        expect(pipe.transform(date, ["yMEd"])).toEqual("Mon, 6/15/2015");
        expect(pipe.transform(date, ["MEd"])).toEqual("Mon, 6/15");
        expect(pipe.transform(date, ["MMMd"])).toEqual("Jun 15");
        expect(pipe.transform(date, ["yMMMMEEEEd"]))
            .toEqual("Monday, June 15, 2015");
        expect(pipe.transform(date, ["jms"])).toEqual("9:43:11 PM");
        expect(pipe.transform(date, ["ms"])).toEqual("43:11");
      });
      it("should format with pattern aliases", () {
        expect(pipe.transform(date, ["medium"]))
            .toEqual("Jun 15, 2015, 9:43:11 PM");
        expect(pipe.transform(date, ["short"])).toEqual("6/15/2015, 9:43 PM");
        expect(pipe.transform(date, ["fullDate"]))
            .toEqual("Monday, June 15, 2015");
        expect(pipe.transform(date, ["longDate"])).toEqual("June 15, 2015");
        expect(pipe.transform(date, ["mediumDate"])).toEqual("Jun 15, 2015");
        expect(pipe.transform(date, ["shortDate"])).toEqual("6/15/2015");
        expect(pipe.transform(date, ["mediumTime"])).toEqual("9:43:11 PM");
        expect(pipe.transform(date, ["shortTime"])).toEqual("9:43 PM");
      });
    });
  });
}
