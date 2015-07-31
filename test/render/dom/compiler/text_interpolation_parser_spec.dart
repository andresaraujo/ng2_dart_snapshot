library angular2.test.render.dom.compiler.text_interpolation_parser_spec;

import "package:angular2/test_lib.dart"
    show describe, beforeEach, expect, it, iit, ddescribe, el;
import "package:angular2/src/render/dom/compiler/text_interpolation_parser.dart"
    show TextInterpolationParser;
import "package:angular2/src/render/dom/compiler/compile_pipeline.dart"
    show CompilePipeline;
import "package:angular2/src/facade/collection.dart"
    show MapWrapper, ListWrapper;
import "package:angular2/src/change_detection/change_detection.dart"
    show Lexer, Parser, ASTWithSource;
import "pipeline_spec.dart" show IgnoreChildrenStep;
import "package:angular2/src/render/dom/view/proto_view_builder.dart"
    show ProtoViewBuilder, ElementBinderBuilder;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/render/api.dart" show ViewDefinition, ViewType;

main() {
  describe("TextInterpolationParser", () {
    createPipeline() {
      return new CompilePipeline([
        new IgnoreChildrenStep(),
        new TextInterpolationParser(new Parser(new Lexer()))
      ]);
    }
    ViewDefinition createViewDefinition() {
      return new ViewDefinition(componentId: "someComponent");
    }
    ProtoViewBuilder process(String templateString) {
      var compileElements = createPipeline().processElements(
          DOM.createTemplate(templateString), ViewType.COMPONENT,
          createViewDefinition());
      return compileElements[0].inheritedProtoView;
    }
    assertRootTextBinding(
        ProtoViewBuilder protoViewBuilder, num nodeIndex, String expression) {
      var node = DOM.childNodes(
          DOM.templateAwareRoot(protoViewBuilder.rootElement))[nodeIndex];
      expect(protoViewBuilder.rootTextBindings[node].source)
          .toEqual(expression);
    }
    assertElementTextBinding(ElementBinderBuilder elementBinderBuilder,
        num nodeIndex, String expression) {
      var node = DOM.childNodes(
          DOM.templateAwareRoot(elementBinderBuilder.element))[nodeIndex];
      expect(elementBinderBuilder.textBindings[node].source)
          .toEqual(expression);
    }
    it("should find root text interpolations", () {
      var result = process("{{expr1}}{{expr2}}<div></div>{{expr3}}");
      assertRootTextBinding(result, 0, "{{expr1}}{{expr2}}");
      assertRootTextBinding(result, 2, "{{expr3}}");
    });
    it("should find text interpolation in normal elements", () {
      var result = process("<div>{{expr1}}<span></span>{{expr2}}</div>");
      assertElementTextBinding(result.elements[0], 0, "{{expr1}}");
      assertElementTextBinding(result.elements[0], 2, "{{expr2}}");
    });
    it("should allow multiple expressions", () {
      var result = process("<div>{{expr1}}{{expr2}}</div>");
      assertElementTextBinding(result.elements[0], 0, "{{expr1}}{{expr2}}");
    });
    it("should not interpolate when compileChildren is false", () {
      var results = process(
          "<div>{{included}}<span ignore-children>{{excluded}}</span></div>");
      assertElementTextBinding(results.elements[0], 0, "{{included}}");
      expect(results.elements.length).toBe(1);
      expect(results.elements[0].textBindings.length).toBe(1);
    });
    it("should allow fixed text before, in between and after expressions", () {
      var result = process("<div>a{{expr1}}b{{expr2}}c</div>");
      assertElementTextBinding(result.elements[0], 0, "a{{expr1}}b{{expr2}}c");
    });
    it("should escape quotes in fixed parts", () {
      var result = process("<div>'\"a{{expr1}}</div>");
      assertElementTextBinding(result.elements[0], 0, "'\"a{{expr1}}");
    });
  });
}
