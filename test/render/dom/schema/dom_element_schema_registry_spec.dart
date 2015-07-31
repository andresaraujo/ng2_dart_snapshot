library angular2.test.render.dom.schema.dom_element_schema_registry_spec;

import "package:angular2/test_lib.dart"
    show
        beforeEach,
        ddescribe,
        xdescribe,
        describe,
        expect,
        iit,
        inject,
        it,
        xit,
        IS_DARTIUM;
import "package:angular2/src/render/dom/schema/dom_element_schema_registry.dart"
    show DomElementSchemaRegistry;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;

main() {
  // DOMElementSchema can only be used on the JS side where we can safely

  // use reflection for DOM elements
  if (IS_DARTIUM) return;
  var registry;
  beforeEach(() {
    registry = new DomElementSchemaRegistry();
  });
  describe("DOMElementSchema", () {
    it("should detect properties on regular elements", () {
      var divEl = DOM.createElement("div");
      expect(registry.hasProperty(divEl, "id")).toBeTruthy();
      expect(registry.hasProperty(divEl, "title")).toBeTruthy();
      expect(registry.hasProperty(divEl, "unknown")).toBeFalsy();
    });
    it("should return true for custom-like elements", () {
      var customLikeEl = DOM.createElement("custom-like");
      expect(registry.hasProperty(customLikeEl, "unknown")).toBeTruthy();
    });
    it("should not re-map property names that are not specified in DOM facade",
        () {
      expect(registry.getMappedPropName("readonly")).toEqual("readOnly");
    });
    it("should not re-map property names that are not specified in DOM facade",
        () {
      expect(registry.getMappedPropName("title")).toEqual("title");
      expect(registry.getMappedPropName("exotic-unknown"))
          .toEqual("exotic-unknown");
    });
  });
}
