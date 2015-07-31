library angular2.test.render.dom.compiler.style_encapsulator_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        beforeEach,
        ddescribe,
        describe,
        el,
        expect,
        iit,
        inject,
        it,
        xit,
        SpyObject;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/render/dom/compiler/compile_pipeline.dart"
    show CompilePipeline;
import "package:angular2/src/facade/collection.dart"
    show MapWrapper, ListWrapper;
import "package:angular2/src/render/dom/view/proto_view_builder.dart"
    show ProtoViewBuilder, ElementBinderBuilder;
import "package:angular2/src/render/api.dart"
    show ViewDefinition, ViewType, ViewEncapsulation;
import "package:angular2/src/render/dom/compiler/style_encapsulator.dart"
    show StyleEncapsulator;
import "pipeline_spec.dart" show MockStep;

main() {
  describe("StyleEncapsulator", () {
    var componentIdCache;
    beforeEach(() {
      componentIdCache = new Map();
    });
    createPipeline(ViewDefinition viewDef) {
      return new CompilePipeline([
        new MockStep((parent, current, control) {
          var tagName = DOM.tagName(current.element).toLowerCase();
          if (tagName.startsWith("comp-")) {
            current.bindElement().setComponentId(tagName);
          }
        }),
        new StyleEncapsulator("someapp", viewDef, componentIdCache)
      ]);
    }
    ViewDefinition createViewDefinition(
        ViewEncapsulation encapsulation, String componentId) {
      return new ViewDefinition(
          encapsulation: encapsulation, componentId: componentId);
    }
    List<String> processStyles(ViewEncapsulation encapsulation,
        String componentId, List<String> styles) {
      var viewDef = createViewDefinition(encapsulation, componentId);
      return createPipeline(viewDef).processStyles(styles);
    }
    ProtoViewBuilder processElements(
        ViewEncapsulation encapsulation, String componentId, dynamic template,
        [ViewType viewType = ViewType.COMPONENT]) {
      var viewDef = createViewDefinition(encapsulation, componentId);
      var compileElements =
          createPipeline(viewDef).processElements(template, viewType, viewDef);
      return compileElements[0].inheritedProtoView;
    }
    describe("ViewEncapsulation.NONE", () {
      it("should not change the styles", () {
        var cs =
            processStyles(ViewEncapsulation.NONE, "someComponent", [".one {}"]);
        expect(cs[0]).toEqual(".one {}");
      });
    });
    describe("ViewEncapsulation.NATIVE", () {
      it("should not change the styles", () {
        var cs = processStyles(
            ViewEncapsulation.NATIVE, "someComponent", [".one {}"]);
        expect(cs[0]).toEqual(".one {}");
      });
    });
    describe("ViewEncapsulation.EMULATED", () {
      it("should scope styles", () {
        var cs = processStyles(
            ViewEncapsulation.EMULATED, "someComponent", [".foo {} :host {}"]);
        expect(cs[0]).toEqual(
            ".foo[_ngcontent-someapp-0] {\n\n}\n\n[_nghost-someapp-0] {\n\n}");
      });
      it("should return the same style given the same component", () {
        var style = ".foo {} :host {}";
        var cs1 =
            processStyles(ViewEncapsulation.EMULATED, "someComponent", [style]);
        var cs2 =
            processStyles(ViewEncapsulation.EMULATED, "someComponent", [style]);
        expect(cs1[0]).toEqual(cs2[0]);
      });
      it("should return different styles given different components", () {
        var style = ".foo {} :host {}";
        var cs1 = processStyles(
            ViewEncapsulation.EMULATED, "someComponent1", [style]);
        var cs2 = processStyles(
            ViewEncapsulation.EMULATED, "someComponent2", [style]);
        expect(cs1[0]).not.toEqual(cs2[0]);
      });
      it("should add a host attribute to component proto views", () {
        var template = DOM.createTemplate("<div></div>");
        var protoViewBuilder = processElements(
            ViewEncapsulation.EMULATED, "someComponent", template);
        expect(protoViewBuilder.hostAttributes["_nghost-someapp-0"])
            .toEqual("");
      });
      it("should not add a host attribute to embedded proto views", () {
        var template = DOM.createTemplate("<div></div>");
        var protoViewBuilder = processElements(ViewEncapsulation.EMULATED,
            "someComponent", template, ViewType.EMBEDDED);
        expect(protoViewBuilder.hostAttributes.length).toBe(0);
      });
      it("should not add a host attribute to host proto views", () {
        var template = DOM.createTemplate("<div></div>");
        var protoViewBuilder = processElements(ViewEncapsulation.EMULATED,
            "someComponent", template, ViewType.HOST);
        expect(protoViewBuilder.hostAttributes.length).toBe(0);
      });
      it("should add an attribute to the content elements", () {
        var template = DOM.createTemplate("<div></div>");
        processElements(ViewEncapsulation.EMULATED, "someComponent", template);
        expect(DOM.getInnerHTML(template))
            .toEqual("<div _ngcontent-someapp-0=\"\"></div>");
      });
      it("should not add an attribute to the content elements for host views",
          () {
        var template = DOM.createTemplate("<div></div>");
        processElements(ViewEncapsulation.EMULATED, "someComponent", template,
            ViewType.HOST);
        expect(DOM.getInnerHTML(template)).toEqual("<div></div>");
      });
    });
  });
}
