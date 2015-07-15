library angular2.test.render.api_spec;

import "package:angular2/src/render/api.dart" show DirectiveMetadata;
import "package:angular2/src/facade/collection.dart" show MapWrapper;
import "package:angular2/test_lib.dart" show ddescribe, describe, expect, it;

main() {
  describe("Metadata", () {
    describe("host", () {
      it("should parse host configuration", () {
        var md = DirectiveMetadata.create(
            host: MapWrapper.createFromPairs([
          ["(event)", "eventVal"],
          ["[prop]", "propVal"],
          ["@action", "actionVal"],
          ["attr", "attrVal"]
        ]));
        expect(md.hostListeners)
            .toEqual(MapWrapper.createFromPairs([["event", "eventVal"]]));
        expect(md.hostProperties)
            .toEqual(MapWrapper.createFromPairs([["prop", "propVal"]]));
        expect(md.hostActions)
            .toEqual(MapWrapper.createFromPairs([["action", "actionVal"]]));
        expect(md.hostAttributes)
            .toEqual(MapWrapper.createFromPairs([["attr", "attrVal"]]));
      });
    });
  });
}
