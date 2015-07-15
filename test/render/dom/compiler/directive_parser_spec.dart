library angular2.test.render.dom.compiler.directive_parser_spec;

import "package:angular2/test_lib.dart"
    show describe, beforeEach, it, xit, expect, iit, ddescribe, el;
import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, assertionsEnabled;
import "package:angular2/src/facade/collection.dart"
    show ListWrapper, MapWrapper, StringMapWrapper;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/render/dom/compiler/directive_parser.dart"
    show DirectiveParser;
import "package:angular2/src/render/dom/compiler/compile_pipeline.dart"
    show CompilePipeline;
import "package:angular2/src/render/dom/compiler/compile_step.dart"
    show CompileStep;
import "package:angular2/src/render/dom/compiler/compile_element.dart"
    show CompileElement;
import "package:angular2/src/render/dom/compiler/compile_control.dart"
    show CompileControl;
import "package:angular2/src/render/api.dart"
    show ViewDefinition, DirectiveMetadata;
import "package:angular2/change_detection.dart" show Lexer, Parser;
import "package:angular2/src/render/dom/view/proto_view_builder.dart"
    show ElementBinderBuilder;

main() {
  describe("DirectiveParser", () {
    var parser, annotatedDirectives;
    beforeEach(() {
      annotatedDirectives = [
        someComponent,
        someComponent2,
        someDirective,
        someDirectiveIgnoringChildren,
        decoratorWithMultipleAttrs,
        someDirectiveWithProps,
        someDirectiveWithHostProperties,
        someDirectiveWithInvalidHostProperties,
        someDirectiveWithHostAttributes,
        someDirectiveWithEvents,
        someDirectiveWithGlobalEvents
      ];
      parser = new Parser(new Lexer());
    });
    createPipeline([propertyBindings = null, directives = null]) {
      if (isBlank(directives)) directives = annotatedDirectives;
      return new CompilePipeline([
        new MockStep((parent, current, control) {
          if (isPresent(propertyBindings)) {
            StringMapWrapper.forEach(propertyBindings, (ast, name) {
              current.bindElement().bindProperty(name, ast);
            });
          }
        }),
        new DirectiveParser(parser, directives)
      ]);
    }
    List<ElementBinderBuilder> process(el,
        [propertyBindings = null, directives = null]) {
      var pipeline = createPipeline(propertyBindings, directives);
      return ListWrapper.map(
          pipeline.process(el), (ce) => ce.inheritedElementBinder);
    }
    it("should not add directives if they are not used", () {
      var results = process(el("<div></div>"));
      expect(results[0]).toBe(null);
    });
    it("should detect directives in attributes", () {
      var results = process(el("<div some-decor></div>"));
      expect(results[0].directives[0].directiveIndex)
          .toBe(annotatedDirectives.indexOf(someDirective));
    });
    it("should detect directives with multiple attributes", () {
      var results = process(el("<input type=text control=one></input>"));
      expect(results[0].directives[0].directiveIndex)
          .toBe(annotatedDirectives.indexOf(decoratorWithMultipleAttrs));
    });
    it("should compile children by default", () {
      var results = createPipeline().process(el("<div some-decor></div>"));
      expect(results[0].compileChildren).toEqual(true);
    });
    it("should stop compiling children when specified in the directive config",
        () {
      var results = createPipeline()
          .process(el("<div some-decor-ignoring-children></div>"));
      expect(results[0].compileChildren).toEqual(false);
    });
    it("should bind directive properties from bound properties", () {
      var results = process(el("<div some-decor-props></div>"), {
        "elProp": parser.parseBinding("someExpr", "")
      });
      var directiveBinding = results[0].directives[0];
      expect(directiveBinding.propertyBindings["dirProp"].source)
          .toEqual("someExpr");
    });
    it("should bind directive properties from attribute values", () {
      var results =
          process(el("<div some-decor-props el-prop=\"someValue\"></div>"));
      var directiveBinding = results[0].directives[0];
      var simpleProp = directiveBinding.propertyBindings["dirProp"];
      expect(simpleProp.source).toEqual("someValue");
    });
    it("should bind host directive properties", () {
      var element = el("<input some-decor-with-host-props>");
      var results = process(element);
      var directiveBinding = results[0].directives[0];
      var ast = directiveBinding.hostPropertyBindings["hostProp"];
      expect(ast.source).toEqual("dirProp");
    });
    it("should throw when parsing invalid host properties", () {
      expect(() => process(el("<input some-decor-with-invalid-host-props>")))
          .toThrowError(new RegExp(
              "Simple binding expression can only contain field access and constants"));
    });
    it("should set host element attributes", () {
      var element = el("<input some-decor-with-host-attrs>");
      var results = process(element);
      expect(DOM.getAttribute(results[0].element, "attr_name"))
          .toEqual("attr_val");
    });
    it("should not set host element attribute if an attribute already exists",
        () {
      var element =
          el("<input attr_name=\"initial\" some-decor-with-host-attrs>");
      var results = process(element);
      expect(DOM.getAttribute(results[0].element, "attr_name"))
          .toEqual("initial");
      DOM.removeAttribute(element, "attr_name");
      results = process(element);
      expect(DOM.getAttribute(results[0].element, "attr_name"))
          .toEqual("attr_val");
    });
    it("should add CSS classes if \"class\" specified in host element attributes",
        () {
      var element = el("<input class=\"foo baz\" some-decor-with-host-attrs>");
      var results = process(element);
      expect(DOM.hasClass(results[0].element, "foo")).toBeTruthy();
      expect(DOM.hasClass(results[0].element, "bar")).toBeTruthy();
      expect(DOM.hasClass(results[0].element, "baz")).toBeTruthy();
    });
    it("should read attribute values", () {
      var element = el("<input some-decor-props some-attr=\"someValue\">");
      var results = process(element);
      expect(results[0].readAttributes["some-attr"]).toEqual("someValue");
    });
    it("should bind directive events", () {
      var results = process(el("<div some-decor-events></div>"));
      var directiveBinding = results[0].directives[0];
      expect(directiveBinding.eventBindings.length).toEqual(1);
      var eventBinding = directiveBinding.eventBindings[0];
      expect(eventBinding.fullName).toEqual("click");
      expect(eventBinding.source.source).toEqual("doIt()");
    });
    it("should bind directive global events", () {
      var results = process(el("<div some-decor-globalevents></div>"));
      var directiveBinding = results[0].directives[0];
      expect(directiveBinding.eventBindings.length).toEqual(1);
      var eventBinding = directiveBinding.eventBindings[0];
      expect(eventBinding.fullName).toEqual("window:resize");
      expect(eventBinding.source.source).toEqual("doItGlobal()");
    });
    // TODO: assertions should be enabled when running tests:

    // https://github.com/angular/angular/issues/1340
    describe("component directives", () {
      it("should save the component id", () {
        var results = process(el("<some-comp></some-comp>"));
        expect(results[0].componentId).toEqual("someComponent");
      });
      it("should throw when the provided selector is not an element selector",
          () {
        expect(() {
          createPipeline(null, [componentWithNonElementSelector]);
        }).toThrowError(
            '''Component \'componentWithNonElementSelector\' can only have an element selector, but had \'[attr]\'''');
      });
      it("should not allow multiple component directives on the same element",
          () {
        expect(() {
          process(el("<some-comp></some-comp>"), null, [
            someComponent,
            someComponentDup
          ]);
        }).toThrowError(
            new RegExp("Only one component directive is allowed per element"));
      });
      it("should sort the directives and store the component as the first directive",
          () {
        var results = process(el("<some-comp some-decor></some-comp>"));
        expect(annotatedDirectives[results[0].directives[0].directiveIndex].id)
            .toEqual("someComponent");
        expect(annotatedDirectives[results[0].directives[1].directiveIndex].id)
            .toEqual("someDirective");
      });
    });
  });
}
class MockStep implements CompileStep {
  Function processClosure;
  MockStep(process) {
    this.processClosure = process;
  }
  process(
      CompileElement parent, CompileElement current, CompileControl control) {
    this.processClosure(parent, current, control);
  }
}
var someComponent = DirectiveMetadata.create(
    selector: "some-comp",
    id: "someComponent",
    type: DirectiveMetadata.COMPONENT_TYPE);
var someComponentDup = DirectiveMetadata.create(
    selector: "some-comp",
    id: "someComponentDup",
    type: DirectiveMetadata.COMPONENT_TYPE);
var someComponent2 = DirectiveMetadata.create(
    selector: "some-comp2",
    id: "someComponent2",
    type: DirectiveMetadata.COMPONENT_TYPE);
var someDirective = DirectiveMetadata.create(
    selector: "[some-decor]",
    id: "someDirective",
    type: DirectiveMetadata.DIRECTIVE_TYPE);
var someDirectiveIgnoringChildren = DirectiveMetadata.create(
    selector: "[some-decor-ignoring-children]",
    compileChildren: false,
    type: DirectiveMetadata.DIRECTIVE_TYPE);
var decoratorWithMultipleAttrs = DirectiveMetadata.create(
    selector: "input[type=text][control]",
    id: "decoratorWithMultipleAttrs",
    type: DirectiveMetadata.DIRECTIVE_TYPE);
var someDirectiveWithProps = DirectiveMetadata.create(
    selector: "[some-decor-props]",
    properties: ["dirProp: elProp"],
    readAttributes: ["some-attr"]);
var someDirectiveWithHostProperties = DirectiveMetadata.create(
    selector: "[some-decor-with-host-props]",
    host: MapWrapper.createFromStringMap({"[hostProp]": "dirProp"}));
var someDirectiveWithInvalidHostProperties = DirectiveMetadata.create(
    selector: "[some-decor-with-invalid-host-props]",
    host: MapWrapper.createFromStringMap({"[hostProp]": "dirProp + dirProp2"}));
var someDirectiveWithHostAttributes = DirectiveMetadata.create(
    selector: "[some-decor-with-host-attrs]",
    host: MapWrapper
        .createFromStringMap({"attr_name": "attr_val", "class": "foo bar"}));
var someDirectiveWithEvents = DirectiveMetadata.create(
    selector: "[some-decor-events]",
    host: MapWrapper.createFromStringMap({"(click)": "doIt()"}));
var someDirectiveWithGlobalEvents = DirectiveMetadata.create(
    selector: "[some-decor-globalevents]",
    host: MapWrapper.createFromStringMap({"(window:resize)": "doItGlobal()"}));
var componentWithNonElementSelector = DirectiveMetadata.create(
    id: "componentWithNonElementSelector",
    selector: "[attr]",
    type: DirectiveMetadata.COMPONENT_TYPE);
