library angular2.test.render.dom.compiler.property_binding_parser_spec;

import "package:angular2/test_lib.dart"
    show describe, beforeEach, it, expect, iit, ddescribe, el;
import "package:angular2/src/render/dom/compiler/property_binding_parser.dart"
    show PropertyBindingParser;
import "package:angular2/src/render/dom/compiler/compile_pipeline.dart"
    show CompilePipeline;
import "package:angular2/src/facade/collection.dart"
    show MapWrapper, ListWrapper;
import "package:angular2/src/change_detection/change_detection.dart"
    show Lexer, Parser;
import "package:angular2/src/render/dom/view/proto_view_builder.dart"
    show ElementBinderBuilder;
import "package:angular2/src/render/api.dart" show ViewDefinition, ViewType;
import "pipeline_spec.dart" show MockStep;

var EMPTY_MAP = new Map();
main() {
  describe("PropertyBindingParser", () {
    createPipeline([hasNestedProtoView = false]) {
      return new CompilePipeline([
        new MockStep((parent, current, control) {
          if (hasNestedProtoView) {
            current
                .bindElement()
                .bindNestedProtoView(el("<template></template>"));
          }
        }),
        new PropertyBindingParser(new Parser(new Lexer()))
      ]);
    }
    ViewDefinition createViewDefinition() {
      return new ViewDefinition(componentId: "someComponent");
    }
    List<ElementBinderBuilder> process(element, [hasNestedProtoView = false]) {
      return ListWrapper.map(createPipeline(hasNestedProtoView).processElements(
              element, ViewType.COMPONENT, createViewDefinition()),
          (compileElement) => compileElement.inheritedElementBinder);
    }
    it("should detect [] syntax", () {
      var results = process(el("<div [a]=\"b\"></div>"));
      expect(results[0].propertyBindings["a"].source).toEqual("b");
    });
    it("should detect [] syntax with data- prefix", () {
      var results = process(el("<div data-[a]=\"b\"></div>"));
      expect(results[0].propertyBindings["a"].source).toEqual("b");
    });
    it("should detect [] syntax only if an attribute name starts and ends with []",
        () {
      expect(process(el("<div z[a]=\"b\"></div>"))[0]).toBe(null);
      expect(process(el("<div [a]v=\"b\"></div>"))[0]).toBe(null);
    });
    it("should detect bind- syntax", () {
      var results = process(el("<div bind-a=\"b\"></div>"));
      expect(results[0].propertyBindings["a"].source).toEqual("b");
    });
    it("should detect bind- syntax with data- prefix", () {
      var results = process(el("<div data-bind-a=\"b\"></div>"));
      expect(results[0].propertyBindings["a"].source).toEqual("b");
    });
    it("should detect bind- syntax only if an attribute name starts with bind",
        () {
      expect(process(el("<div _bind-a=\"b\"></div>"))[0]).toEqual(null);
    });
    it("should detect interpolation syntax", () {
      var results = process(el("<div a=\"{{b}}\"></div>"));
      expect(results[0].propertyBindings["a"].source).toEqual("{{b}}");
    });
    it("should detect interpolation syntax with data- prefix", () {
      var results = process(el("<div data-a=\"{{b}}\"></div>"));
      expect(results[0].propertyBindings["a"].source).toEqual("{{b}}");
    });
    it("should store property setters as camel case", () {
      var element = el("<div bind-some-prop=\"1\">");
      var results = process(element);
      expect(results[0].propertyBindings["someProp"]).toBeTruthy();
    });
    it("should detect var- syntax", () {
      var results = process(el("<template var-a=\"b\"></template>"));
      expect(results[0].variableBindings["b"]).toEqual("a");
    });
    it("should detect var- syntax with data- prefix", () {
      var results = process(el("<template data-var-a=\"b\"></template>"));
      expect(results[0].variableBindings["b"]).toEqual("a");
    });
    it("should store variable binding for a template element on the nestedProtoView",
        () {
      var results =
          process(el("<template var-george=\"washington\"></p>"), true);
      expect(results[0].variableBindings).toEqual(EMPTY_MAP);
      expect(results[0].nestedProtoView.variableBindings["washington"])
          .toEqual("george");
    });
    it("should store variable binding for a non-template element using shorthand syntax on the nestedProtoView",
        () {
      var results =
          process(el("<template #george=\"washington\"></template>"), true);
      expect(results[0].variableBindings).toEqual(EMPTY_MAP);
      expect(results[0].nestedProtoView.variableBindings["washington"])
          .toEqual("george");
    });
    it("should store variable binding for a non-template element", () {
      var results = process(el("<p var-george=\"washington\"></p>"));
      expect(results[0].variableBindings["washington"]).toEqual("george");
    });
    it("should store variable binding for a non-template element using shorthand syntax",
        () {
      var results = process(el("<p #george=\"washington\"></p>"));
      expect(results[0].variableBindings["washington"]).toEqual("george");
    });
    it("should store a variable binding with an implicit value", () {
      var results = process(el("<p var-george></p>"));
      expect(results[0].variableBindings["\$implicit"]).toEqual("george");
    });
    it("should store a variable binding with an implicit value using shorthand syntax",
        () {
      var results = process(el("<p #george></p>"));
      expect(results[0].variableBindings["\$implicit"]).toEqual("george");
    });
    it("should detect variable bindings only if an attribute name starts with #",
        () {
      var results = process(el("<p b#george></p>"));
      expect(results[0]).toEqual(null);
    });
    it("should detect () syntax", () {
      var results = process(el("<div (click)=\"b()\"></div>"));
      var eventBinding = results[0].eventBindings[0];
      expect(eventBinding.source.source).toEqual("b()");
      expect(eventBinding.fullName).toEqual("click");
      // "(click[])" is not an expected syntax and is only used to validate the regexp
      results = process(el("<div (click[])=\"b()\"></div>"));
      eventBinding = results[0].eventBindings[0];
      expect(eventBinding.source.source).toEqual("b()");
      expect(eventBinding.fullName).toEqual("click[]");
    });
    it("should detect () syntax with data- prefix", () {
      var results = process(el("<div data-(click)=\"b()\"></div>"));
      var eventBinding = results[0].eventBindings[0];
      expect(eventBinding.source.source).toEqual("b()");
      expect(eventBinding.fullName).toEqual("click");
    });
    it("should detect () syntax only if an attribute name starts and ends with ()",
        () {
      expect(process(el("<div z(a)=\"b()\"></div>"))[0]).toEqual(null);
      expect(process(el("<div (a)v=\"b()\"></div>"))[0]).toEqual(null);
    });
    it("should parse event handlers using () syntax as actions", () {
      var results = process(el("<div (click)=\"foo=bar\"></div>"));
      var eventBinding = results[0].eventBindings[0];
      expect(eventBinding.source.source).toEqual("foo=bar");
      expect(eventBinding.fullName).toEqual("click");
    });
    it("should detect on- syntax", () {
      var results = process(el("<div on-click=\"b()\"></div>"));
      var eventBinding = results[0].eventBindings[0];
      expect(eventBinding.source.source).toEqual("b()");
      expect(eventBinding.fullName).toEqual("click");
    });
    it("should detect on- syntax with data- prefix", () {
      var results = process(el("<div data-on-click=\"b()\"></div>"));
      var eventBinding = results[0].eventBindings[0];
      expect(eventBinding.source.source).toEqual("b()");
      expect(eventBinding.fullName).toEqual("click");
    });
    it("should parse event handlers using on- syntax as actions", () {
      var results = process(el("<div on-click=\"foo=bar\"></div>"));
      var eventBinding = results[0].eventBindings[0];
      expect(eventBinding.source.source).toEqual("foo=bar");
      expect(eventBinding.fullName).toEqual("click");
    });
    it("should store bound properties as temporal attributes", () {
      var results = createPipeline().processElements(
          el("<div bind-a=\"b\" [c]=\"d\"></div>"), ViewType.COMPONENT,
          createViewDefinition());
      expect(results[0].attrs()["a"]).toEqual("b");
      expect(results[0].attrs()["c"]).toEqual("d");
    });
    it("should store variables as temporal attributes", () {
      var results = createPipeline().processElements(
          el("<div var-a=\"b\" #c=\"d\"></div>"), ViewType.COMPONENT,
          createViewDefinition());
      expect(results[0].attrs()["a"]).toEqual("b");
      expect(results[0].attrs()["c"]).toEqual("d");
    });
    it("should detect [()] syntax", () {
      var results = process(el("<div [(a)]=\"b\"></div>"));
      expect(results[0].propertyBindings["a"].source).toEqual("b");
      expect(results[0].eventBindings[0].source.source).toEqual("b=\$event");
    });
    it("should detect [()] syntax with data- prefix", () {
      var results = process(el("<div data-[(a)]=\"b\"></div>"));
      expect(results[0].propertyBindings["a"].source).toEqual("b");
      expect(results[0].eventBindings[0].source.source).toEqual("b=\$event");
    });
    it("should detect bindon- syntax", () {
      var results = process(el("<div bindon-a=\"b\"></div>"));
      expect(results[0].propertyBindings["a"].source).toEqual("b");
      expect(results[0].eventBindings[0].source.source).toEqual("b=\$event");
    });
    it("should detect bindon- syntax with data- prefix", () {
      var results = process(el("<div data-bindon-a=\"b\"></div>"));
      expect(results[0].propertyBindings["a"].source).toEqual("b");
      expect(results[0].eventBindings[0].source.source).toEqual("b=\$event");
    });
  });
}
