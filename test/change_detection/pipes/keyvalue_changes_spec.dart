library angular2.test.change_detection.pipes.keyvalue_changes_spec;

import "package:angular2/test_lib.dart"
    show describe, it, iit, xit, expect, beforeEach, afterEach;
import "package:angular2/src/change_detection/pipes/keyvalue_changes.dart"
    show KeyValueChanges;
import "package:angular2/src/facade/lang.dart" show NumberWrapper, isJsObject;
import "package:angular2/src/facade/collection.dart" show MapWrapper;
import "../util.dart" show kvChangesAsString;

// todo(vicb): Update the code & tests for object equality
main() {
  describe("keyvalue_changes", () {
    describe("KeyValueChanges", () {
      var changes;
      Map<dynamic, dynamic> m;
      beforeEach(() {
        changes = new KeyValueChanges();
        m = new Map();
      });
      afterEach(() {
        changes = null;
      });
      it("should detect additions", () {
        changes.check(m);
        m["a"] = 1;
        changes.check(m);
        expect(changes.toString()).toEqual(
            kvChangesAsString(map: ["a[null->1]"], additions: ["a[null->1]"]));
        m["b"] = 2;
        changes.check(m);
        expect(changes.toString()).toEqual(kvChangesAsString(
            map: ["a", "b[null->2]"],
            previous: ["a"],
            additions: ["b[null->2]"]));
      });
      it("should handle changing key/values correctly", () {
        m[1] = 10;
        m[2] = 20;
        changes.check(m);
        m[2] = 10;
        m[1] = 20;
        changes.check(m);
        expect(changes.toString()).toEqual(kvChangesAsString(
            map: ["1[10->20]", "2[20->10]"],
            previous: ["1[10->20]", "2[20->10]"],
            changes: ["1[10->20]", "2[20->10]"]));
      });
      it("should expose previous and current value", () {
        var previous, current;
        m[1] = 10;
        changes.check(m);
        m[1] = 20;
        changes.check(m);
        changes.forEachChangedItem((record) {
          previous = record.previousValue;
          current = record.currentValue;
        });
        expect(previous).toEqual(10);
        expect(current).toEqual(20);
      });
      it("should do basic map watching", () {
        changes.check(m);
        m["a"] = "A";
        changes.check(m);
        expect(changes.toString()).toEqual(
            kvChangesAsString(map: ["a[null->A]"], additions: ["a[null->A]"]));
        m["b"] = "B";
        changes.check(m);
        expect(changes.toString()).toEqual(kvChangesAsString(
            map: ["a", "b[null->B]"],
            previous: ["a"],
            additions: ["b[null->B]"]));
        m["b"] = "BB";
        m["d"] = "D";
        changes.check(m);
        expect(changes.toString()).toEqual(kvChangesAsString(
            map: ["a", "b[B->BB]", "d[null->D]"],
            previous: ["a", "b[B->BB]"],
            additions: ["d[null->D]"],
            changes: ["b[B->BB]"]));
        MapWrapper.delete(m, "b");
        changes.check(m);
        expect(changes.toString()).toEqual(kvChangesAsString(
            map: ["a", "d"],
            previous: ["a", "b[BB->null]", "d"],
            removals: ["b[BB->null]"]));
        m.clear();
        changes.check(m);
        expect(changes.toString()).toEqual(kvChangesAsString(
            previous: ["a[A->null]", "d[D->null]"],
            removals: ["a[A->null]", "d[D->null]"]));
      });
      it("should test string by value rather than by reference (DART)", () {
        m["foo"] = "bar";
        changes.check(m);
        var f = "f";
        var oo = "oo";
        var b = "b";
        var ar = "ar";
        m[f + oo] = b + ar;
        changes.check(m);
        expect(changes.toString())
            .toEqual(kvChangesAsString(map: ["foo"], previous: ["foo"]));
      });
      it("should not see a NaN value as a change (JS)", () {
        m["foo"] = NumberWrapper.NaN;
        changes.check(m);
        changes.check(m);
        expect(changes.toString())
            .toEqual(kvChangesAsString(map: ["foo"], previous: ["foo"]));
      });
      // JS specific tests (JS Objects)
      if (isJsObject({})) {
        describe("JsObject changes", () {
          it("should support JS Object", () {
            expect(KeyValueChanges.supportsObj({})).toBeTruthy();
            expect(KeyValueChanges.supportsObj("not supported")).toBeFalsy();
            expect(KeyValueChanges.supportsObj(0)).toBeFalsy();
            expect(KeyValueChanges.supportsObj(null)).toBeFalsy();
          });
          it("should do basic object watching", () {
            var m = {};
            changes.check(m);
            m["a"] = "A";
            changes.check(m);
            expect(changes.toString()).toEqual(kvChangesAsString(
                map: ["a[null->A]"], additions: ["a[null->A]"]));
            m["b"] = "B";
            changes.check(m);
            expect(changes.toString()).toEqual(kvChangesAsString(
                map: ["a", "b[null->B]"],
                previous: ["a"],
                additions: ["b[null->B]"]));
            m["b"] = "BB";
            m["d"] = "D";
            changes.check(m);
            expect(changes.toString()).toEqual(kvChangesAsString(
                map: ["a", "b[B->BB]", "d[null->D]"],
                previous: ["a", "b[B->BB]"],
                additions: ["d[null->D]"],
                changes: ["b[B->BB]"]));
            m = {};
            m["a"] = "A";
            m["d"] = "D";
            changes.check(m);
            expect(changes.toString()).toEqual(kvChangesAsString(
                map: ["a", "d"],
                previous: ["a", "b[BB->null]", "d"],
                removals: ["b[BB->null]"]));
            m = {};
            changes.check(m);
            expect(changes.toString()).toEqual(kvChangesAsString(
                previous: ["a[A->null]", "d[D->null]"],
                removals: ["a[A->null]", "d[D->null]"]));
          });
        });
      }
    });
  });
}
