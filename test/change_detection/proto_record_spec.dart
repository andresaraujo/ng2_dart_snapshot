library angular2.test.change_detection.proto_record_spec;

import "package:angular2/test_lib.dart"
    show ddescribe, describe, it, iit, xit, expect, beforeEach, afterEach;
import "package:angular2/src/facade/lang.dart" show isBlank;
import "package:angular2/src/change_detection/proto_record.dart"
    show RecordType, ProtoRecord;

main() {
  r({lastInBinding, mode, name, directiveIndex, argumentToPureFunction,
      referencedBySelf}) {
    if (isBlank(lastInBinding)) lastInBinding = false;
    if (isBlank(mode)) mode = RecordType.PROPERTY;
    if (isBlank(name)) name = "name";
    if (isBlank(directiveIndex)) directiveIndex = null;
    if (isBlank(argumentToPureFunction)) argumentToPureFunction = false;
    if (isBlank(referencedBySelf)) referencedBySelf = false;
    return new ProtoRecord(mode, name, null, [], null, 0, directiveIndex, 0,
        null, null, lastInBinding, false, argumentToPureFunction,
        referencedBySelf);
  }
  describe("ProtoRecord", () {
    describe("shouldBeChecked", () {
      it("should be true for pure functions", () {
        expect(r(mode: RecordType.COLLECTION_LITERAL).shouldBeChecked())
            .toBeTruthy();
      });
      it("should be true for args of pure functions", () {
        expect(r(mode: RecordType.CONST, argumentToPureFunction: true)
            .shouldBeChecked()).toBeTruthy();
      });
      it("should be true for last in binding records", () {
        expect(r(mode: RecordType.CONST, lastInBinding: true).shouldBeChecked())
            .toBeTruthy();
      });
      it("should be false otherwise", () {
        expect(r(mode: RecordType.CONST).shouldBeChecked()).toBeFalsy();
      });
    });
    describe("isUsedByOtherRecord", () {
      it("should be false for lastInBinding records", () {
        expect(r(lastInBinding: true).isUsedByOtherRecord()).toBeFalsy();
      });
      it("should be true for lastInBinding records that are referenced by self records",
          () {
        expect(r(lastInBinding: true, referencedBySelf: true)
            .isUsedByOtherRecord()).toBeTruthy();
      });
      it("should be true for non lastInBinding records", () {
        expect(r(lastInBinding: false).isUsedByOtherRecord()).toBeTruthy();
      });
    });
  });
}
