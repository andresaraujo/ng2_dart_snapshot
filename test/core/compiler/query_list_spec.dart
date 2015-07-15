library angular2.test.core.compiler.query_list_spec;

import "package:angular2/test_lib.dart"
    show describe, it, expect, beforeEach, ddescribe, iit, xit, el;
import "package:angular2/src/facade/collection.dart"
    show List, MapWrapper, ListWrapper, iterateListLike;
import "package:angular2/src/core/compiler/query_list.dart" show QueryList;

main() {
  describe("QueryList", () {
    QueryList<String> queryList;
    String log;
    beforeEach(() {
      queryList = new QueryList<String>();
      log = "";
    });
    logAppend(item) {
      log += (log.length == 0 ? "" : ", ") + item;
    }
    it("should support adding objects and iterating over them", () {
      queryList.add("one");
      queryList.add("two");
      iterateListLike(queryList, logAppend);
      expect(log).toEqual("one, two");
    });
    it("should support resetting and iterating over the new objects", () {
      queryList.add("one");
      queryList.add("two");
      queryList.reset(["one again"]);
      queryList.add("two again");
      iterateListLike(queryList, logAppend);
      expect(log).toEqual("one again, two again");
    });
    it("should support length", () {
      queryList.add("one");
      queryList.add("two");
      expect(queryList.length).toEqual(2);
    });
    it("should support map", () {
      queryList.add("one");
      queryList.add("two");
      expect(queryList.map((x) => x)).toEqual(["one", "two"]);
    });
    it("should support first and last", () {
      queryList.add("one");
      queryList.add("two");
      queryList.add("three");
      expect(queryList.first).toEqual("one");
      expect(queryList.last).toEqual("three");
    });
    describe("simple observable interface", () {
      it("should fire callbacks on change", () {
        var fires = 0;
        queryList.onChange(() {
          fires += 1;
        });
        queryList.fireCallbacks();
        expect(fires).toEqual(0);
        queryList.add("one");
        queryList.fireCallbacks();
        expect(fires).toEqual(1);
        queryList.fireCallbacks();
        expect(fires).toEqual(1);
      });
      it("should support removing callbacks", () {
        var fires = 0;
        var callback = () => fires += 1;
        queryList.onChange(callback);
        queryList.add("one");
        queryList.fireCallbacks();
        expect(fires).toEqual(1);
        queryList.removeCallback(callback);
        queryList.add("two");
        queryList.fireCallbacks();
        expect(fires).toEqual(1);
      });
    });
  });
}
