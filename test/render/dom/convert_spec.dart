library angular2.test.render.dom.convert_spec;

import "package:angular2/src/facade/collection.dart" show MapWrapper;
import "package:angular2/src/render/api.dart" show DirectiveMetadata;
import "package:angular2/src/render/dom/convert.dart"
    show directiveMetadataFromMap, directiveMetadataToMap;
import "package:angular2/test_lib.dart" show ddescribe, describe, expect, it;

main() {
  describe("convert", () {
    it("directiveMetadataToMap", () {
      var someComponent = new DirectiveMetadata(
          compileChildren: false,
          hostListeners: MapWrapper.createFromPairs([["LKey", "LVal"]]),
          hostProperties: MapWrapper.createFromPairs([["PKey", "PVal"]]),
          hostActions: MapWrapper.createFromPairs([["AcKey", "AcVal"]]),
          hostAttributes: MapWrapper.createFromPairs([["AtKey", "AtVal"]]),
          id: "someComponent",
          properties: ["propKey: propVal"],
          readAttributes: ["read1", "read2"],
          selector: "some-comp",
          type: DirectiveMetadata.COMPONENT_TYPE,
          exportAs: "aaa",
          callOnDestroy: true,
          callOnChange: true,
          callOnCheck: true,
          callOnInit: true,
          callOnAllChangesDone: true,
          events: ["onFoo", "onBar"],
          changeDetection: "CHECK_ONCE");
      var map = directiveMetadataToMap(someComponent);
      expect(map["compileChildren"]).toEqual(false);
      expect(map["hostListeners"])
          .toEqual(MapWrapper.createFromPairs([["LKey", "LVal"]]));
      expect(map["hostProperties"])
          .toEqual(MapWrapper.createFromPairs([["PKey", "PVal"]]));
      expect(map["hostActions"])
          .toEqual(MapWrapper.createFromPairs([["AcKey", "AcVal"]]));
      expect(map["hostAttributes"])
          .toEqual(MapWrapper.createFromPairs([["AtKey", "AtVal"]]));
      expect(map["id"]).toEqual("someComponent");
      expect(map["properties"]).toEqual(["propKey: propVal"]);
      expect(map["readAttributes"]).toEqual(["read1", "read2"]);
      expect(map["selector"]).toEqual("some-comp");
      expect(map["type"]).toEqual(DirectiveMetadata.COMPONENT_TYPE);
      expect(map["callOnDestroy"]).toEqual(true);
      expect(map["callOnCheck"]).toEqual(true);
      expect(map["callOnChange"]).toEqual(true);
      expect(map["callOnInit"]).toEqual(true);
      expect(map["callOnAllChangesDone"]).toEqual(true);
      expect(map["exportAs"]).toEqual("aaa");
      expect(map["events"]).toEqual(["onFoo", "onBar"]);
      expect(map["changeDetection"]).toEqual("CHECK_ONCE");
    });
    it("mapToDirectiveMetadata", () {
      var map = MapWrapper.createFromPairs([
        ["compileChildren", false],
        ["hostProperties", MapWrapper.createFromPairs([["PKey", "testVal"]])],
        ["hostListeners", MapWrapper.createFromPairs([["LKey", "testVal"]])],
        ["hostActions", MapWrapper.createFromPairs([["AcKey", "testVal"]])],
        ["hostAttributes", MapWrapper.createFromPairs([["AtKey", "testVal"]])],
        ["id", "testId"],
        ["properties", ["propKey: propVal"]],
        ["readAttributes", ["readTest1", "readTest2"]],
        ["selector", "testSelector"],
        ["type", DirectiveMetadata.DIRECTIVE_TYPE],
        ["exportAs", "aaa"],
        ["callOnDestroy", true],
        ["callOnCheck", true],
        ["callOnInit", true],
        ["callOnChange", true],
        ["callOnAllChangesDone", true],
        ["events", ["onFoo", "onBar"]],
        ["changeDetection", "CHECK_ONCE"]
      ]);
      var meta = directiveMetadataFromMap(map);
      expect(meta.compileChildren).toEqual(false);
      expect(meta.hostProperties)
          .toEqual(MapWrapper.createFromPairs([["PKey", "testVal"]]));
      expect(meta.hostListeners)
          .toEqual(MapWrapper.createFromPairs([["LKey", "testVal"]]));
      expect(meta.hostActions)
          .toEqual(MapWrapper.createFromPairs([["AcKey", "testVal"]]));
      expect(meta.hostAttributes)
          .toEqual(MapWrapper.createFromPairs([["AtKey", "testVal"]]));
      expect(meta.id).toEqual("testId");
      expect(meta.properties).toEqual(["propKey: propVal"]);
      expect(meta.readAttributes).toEqual(["readTest1", "readTest2"]);
      expect(meta.selector).toEqual("testSelector");
      expect(meta.type).toEqual(DirectiveMetadata.DIRECTIVE_TYPE);
      expect(meta.exportAs).toEqual("aaa");
      expect(meta.callOnDestroy).toEqual(true);
      expect(meta.callOnCheck).toEqual(true);
      expect(meta.callOnInit).toEqual(true);
      expect(meta.callOnChange).toEqual(true);
      expect(meta.callOnAllChangesDone).toEqual(true);
      expect(meta.events).toEqual(["onFoo", "onBar"]);
      expect(meta.changeDetection).toEqual("CHECK_ONCE");
    });
  });
}
