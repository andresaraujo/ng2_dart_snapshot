library angular2.test.change_detection.change_detection_spec;

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
        SpyProtoChangeDetector;
import "package:angular2/change_detection.dart"
    show
        PreGeneratedChangeDetection,
        ChangeDetectorDefinition,
        DynamicProtoChangeDetector;

main() {
  describe("PreGeneratedChangeDetection", () {
    var proto;
    var def;
    beforeEach(() {
      proto = new SpyProtoChangeDetector();
      def = new ChangeDetectorDefinition("id", null, [], [], []);
    });
    it("should return a proto change detector when one is available", () {
      var map = {"id": (def) => proto};
      var cd = new PreGeneratedChangeDetection(map);
      expect(cd.createProtoChangeDetector(def)).toBe(proto);
    });
    it("should delegate to dynamic change detection otherwise", () {
      var cd = new PreGeneratedChangeDetection({});
      expect(cd.createProtoChangeDetector(def))
          .toBeAnInstanceOf(DynamicProtoChangeDetector);
    });
  });
}
