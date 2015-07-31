library angular2.test.render.dom.compiler.view_splitter_spec;

import "package:angular2/test_lib.dart"
    show describe, beforeEach, it, expect, iit, ddescribe, el, stringifyElement;
import "package:angular2/src/facade/collection.dart" show MapWrapper;
import "package:angular2/src/render/dom/compiler/view_splitter.dart"
    show ViewSplitter;
import "package:angular2/src/render/dom/compiler/compile_pipeline.dart"
    show CompilePipeline;
import "package:angular2/src/render/dom/compiler/compile_element.dart"
    show CompileElement;
import "package:angular2/src/render/api.dart"
    show ProtoViewDto, ViewType, ViewDefinition;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/change_detection/change_detection.dart"
    show Lexer, Parser;

main() {
  describe("ViewSplitter", () {
    ViewDefinition createViewDefinition() {
      return new ViewDefinition(componentId: "someComponent");
    }
    createPipeline() {
      return new CompilePipeline([new ViewSplitter(new Parser(new Lexer()))]);
    }
    List<CompileElement> proceess(el) {
      return createPipeline().processElements(
          el, ViewType.COMPONENT, createViewDefinition());
    }
    describe("<template> elements", () {
      it("should move the content into a new <template> element and mark that as viewRoot",
          () {
        var rootElement =
            DOM.createTemplate("<template if=\"true\">a</template>");
        var results = proceess(rootElement);
        expect(stringifyElement(results[1].element))
            .toEqual("<template class=\"ng-binding\" if=\"true\"></template>");
        expect(results[1].isViewRoot).toBe(false);
        expect(stringifyElement(results[2].element))
            .toEqual("<template>a</template>");
        expect(results[2].isViewRoot).toBe(true);
      });
      it("should mark the new <template> element as viewRoot", () {
        var rootElement =
            DOM.createTemplate("<template if=\"true\">a</template>");
        var results = proceess(rootElement);
        expect(results[2].isViewRoot).toBe(true);
      });
      it("should not wrap the root element", () {
        var rootElement = DOM.createTemplate("");
        var results = proceess(rootElement);
        expect(results.length).toBe(1);
        expect(stringifyElement(rootElement)).toEqual("<template></template>");
      });
      it("should copy over the elementDescription", () {
        var rootElement =
            DOM.createTemplate("<template if=\"true\">a</template>");
        var results = proceess(rootElement);
        expect(results[2].elementDescription)
            .toBe(results[1].elementDescription);
      });
      it("should clean out the inheritedElementBinder", () {
        var rootElement =
            DOM.createTemplate("<template if=\"true\">a</template>");
        var results = proceess(rootElement);
        expect(results[2].inheritedElementBinder).toBe(null);
      });
      it("should create a nestedProtoView", () {
        var rootElement =
            DOM.createTemplate("<template if=\"true\">a</template>");
        var results = proceess(rootElement);
        expect(results[2].inheritedProtoView).not.toBe(null);
        expect(results[2].inheritedProtoView)
            .toBe(results[1].inheritedElementBinder.nestedProtoView);
        expect(results[2].inheritedProtoView.type).toBe(ViewType.EMBEDDED);
        expect(stringifyElement(results[2].inheritedProtoView.rootElement))
            .toEqual("<template>a</template>");
      });
    });
    describe("elements with template attribute", () {
      it("should replace the element with an empty <template> element", () {
        var rootElement = DOM.createTemplate("<span template=\"\"></span>");
        var originalChild = DOM.firstChild(DOM.content(rootElement));
        var results = proceess(rootElement);
        expect(results[0].element).toBe(rootElement);
        expect(stringifyElement(results[0].element)).toEqual(
            "<template><template class=\"ng-binding\"></template></template>");
        expect(stringifyElement(results[2].element))
            .toEqual("<template><span template=\"\"></span></template>");
        expect(DOM.firstChild(DOM.content(results[2].element)))
            .toBe(originalChild);
      });
      it("should work with top-level template node", () {
        var rootElement = DOM.createTemplate("<div template>x</div>");
        var originalChild = DOM.content(rootElement).childNodes[0];
        var results = proceess(rootElement);
        expect(results[0].element).toBe(rootElement);
        expect(results[0].isViewRoot).toBe(true);
        expect(results[2].isViewRoot).toBe(true);
        expect(stringifyElement(results[0].element)).toEqual(
            "<template><template class=\"ng-binding\"></template></template>");
        expect(DOM.firstChild(DOM.content(results[2].element)))
            .toBe(originalChild);
      });
      it("should mark the element as viewRoot", () {
        var rootElement = DOM.createTemplate("<div template></div>");
        var results = proceess(rootElement);
        expect(results[2].isViewRoot).toBe(true);
      });
      it("should add property bindings from the template attribute", () {
        var rootElement =
            DOM.createTemplate("<div template=\"some-prop:expr\"></div>");
        var results = proceess(rootElement);
        expect(results[1].inheritedElementBinder.propertyBindings[
            "someProp"].source).toEqual("expr");
        expect(results[1].attrs()["some-prop"]).toEqual("expr");
      });
      it("should add variable mappings from the template attribute to the nestedProtoView",
          () {
        var rootElement =
            DOM.createTemplate("<div template=\"var var-name=mapName\"></div>");
        var results = proceess(rootElement);
        expect(results[2].inheritedProtoView.variableBindings)
            .toEqual(MapWrapper.createFromStringMap({"mapName": "varName"}));
      });
      it("should add entries without value as attributes to the element", () {
        var rootElement =
            DOM.createTemplate("<div template=\"varname\"></div>");
        var results = proceess(rootElement);
        expect(results[1].attrs()["varname"]).toEqual("");
        expect(results[1].inheritedElementBinder.propertyBindings)
            .toEqual(new Map());
        expect(results[1].inheritedElementBinder.variableBindings)
            .toEqual(new Map());
      });
      it("should iterate properly after a template dom modification", () {
        var rootElement =
            DOM.createTemplate("<div template></div><after></after>");
        var results = proceess(rootElement);
        // 1 root + 2 initial + 2 generated template elements
        expect(results.length).toEqual(5);
      });
      it("should copy over the elementDescription", () {
        var rootElement = DOM.createTemplate("<span template=\"\"></span>");
        var results = proceess(rootElement);
        expect(results[2].elementDescription)
            .toBe(results[1].elementDescription);
      });
      it("should clean out the inheritedElementBinder", () {
        var rootElement = DOM.createTemplate("<span template=\"\"></span>");
        var results = proceess(rootElement);
        expect(results[2].inheritedElementBinder).toBe(null);
      });
      it("should create a nestedProtoView", () {
        var rootElement = DOM.createTemplate("<span template=\"\"></span>");
        var results = proceess(rootElement);
        expect(results[2].inheritedProtoView).not.toBe(null);
        expect(results[2].inheritedProtoView)
            .toBe(results[1].inheritedElementBinder.nestedProtoView);
        expect(stringifyElement(results[2].inheritedProtoView.rootElement))
            .toEqual("<template><span template=\"\"></span></template>");
      });
    });
    describe("elements with *directive_name attribute", () {
      it("should replace the element with an empty <template> element", () {
        var rootElement = DOM.createTemplate("<span *ng-if></span>");
        var originalChild = DOM.firstChild(DOM.content(rootElement));
        var results = proceess(rootElement);
        expect(results[0].element).toBe(rootElement);
        expect(stringifyElement(results[0].element)).toEqual(
            "<template><template class=\"ng-binding\" ng-if=\"\"></template></template>");
        expect(stringifyElement(results[2].element))
            .toEqual("<template><span *ng-if=\"\"></span></template>");
        expect(DOM.firstChild(DOM.content(results[2].element)))
            .toBe(originalChild);
      });
      it("should mark the element as viewRoot", () {
        var rootElement = DOM.createTemplate("<div *foo=\"bar\"></div>");
        var results = proceess(rootElement);
        expect(results[2].isViewRoot).toBe(true);
      });
      it("should work with top-level template node", () {
        var rootElement = DOM.createTemplate("<div *foo>x</div>");
        var originalChild = DOM.content(rootElement).childNodes[0];
        var results = proceess(rootElement);
        expect(results[0].element).toBe(rootElement);
        expect(results[0].isViewRoot).toBe(true);
        expect(results[2].isViewRoot).toBe(true);
        expect(stringifyElement(results[0].element)).toEqual(
            "<template><template class=\"ng-binding\" foo=\"\"></template></template>");
        expect(DOM.firstChild(DOM.content(results[2].element)))
            .toBe(originalChild);
      });
      it("should add property bindings from the template attribute", () {
        var rootElement = DOM.createTemplate("<div *prop=\"expr\"></div>");
        var results = proceess(rootElement);
        expect(results[1].inheritedElementBinder.propertyBindings[
            "prop"].source).toEqual("expr");
        expect(results[1].attrs()["prop"]).toEqual("expr");
      });
      it("should add variable mappings from the template attribute to the nestedProtoView",
          () {
        var rootElement =
            DOM.createTemplate("<div *foreach=\"var varName=mapName\"></div>");
        var results = proceess(rootElement);
        expect(results[2].inheritedProtoView.variableBindings)
            .toEqual(MapWrapper.createFromStringMap({"mapName": "varName"}));
      });
      it("should add entries without value as attribute to the element", () {
        var rootElement = DOM.createTemplate("<div *varname></div>");
        var results = proceess(rootElement);
        expect(results[1].attrs()["varname"]).toEqual("");
        expect(results[1].inheritedElementBinder.propertyBindings)
            .toEqual(new Map());
        expect(results[1].inheritedElementBinder.variableBindings)
            .toEqual(new Map());
      });
      it("should iterate properly after a template dom modification", () {
        var rootElement = DOM.createTemplate("<div *foo></div><after></after>");
        var results = proceess(rootElement);
        // 1 root + 2 initial + 2 generated template elements
        expect(results.length).toEqual(5);
      });
      it("should copy over the elementDescription", () {
        var rootElement = DOM.createTemplate("<span *foo></span>");
        var results = proceess(rootElement);
        expect(results[2].elementDescription)
            .toBe(results[1].elementDescription);
      });
      it("should clean out the inheritedElementBinder", () {
        var rootElement = DOM.createTemplate("<span *foo></span>");
        var results = proceess(rootElement);
        expect(results[2].inheritedElementBinder).toBe(null);
      });
      it("should create a nestedProtoView", () {
        var rootElement = DOM.createTemplate("<span *foo></span>");
        var results = proceess(rootElement);
        expect(results[2].inheritedProtoView).not.toBe(null);
        expect(results[2].inheritedProtoView)
            .toBe(results[1].inheritedElementBinder.nestedProtoView);
        expect(stringifyElement(results[2].inheritedProtoView.rootElement))
            .toEqual("<template><span *foo=\"\"></span></template>");
      });
    });
  });
}
