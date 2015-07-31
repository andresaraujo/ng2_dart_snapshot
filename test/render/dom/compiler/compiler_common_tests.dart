library angular2.test.render.dom.compiler.compiler_common_tests;

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
        IS_DARTIUM,
        it;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/facade/collection.dart"
    show List, ListWrapper, Map, MapWrapper, StringMapWrapper;
import "package:angular2/src/facade/lang.dart"
    show Type, isBlank, stringify, isPresent, BaseException;
import "package:angular2/src/facade/async.dart" show PromiseWrapper, Future;
import "package:angular2/src/render/dom/compiler/compiler.dart"
    show DomCompiler;
import "package:angular2/src/render/api.dart"
    show
        ProtoViewDto,
        ViewDefinition,
        DirectiveMetadata,
        ViewType,
        ViewEncapsulation;
import "package:angular2/src/render/dom/compiler/compile_step.dart"
    show CompileStep;
import "package:angular2/src/render/dom/compiler/compile_step_factory.dart"
    show CompileStepFactory;
import "package:angular2/src/render/dom/schema/element_schema_registry.dart"
    show ElementSchemaRegistry;
import "package:angular2/src/render/dom/compiler/view_loader.dart"
    show ViewLoader, TemplateAndStyles;
import "package:angular2/src/render/dom/view/proto_view.dart"
    show resolveInternalDomProtoView;
import "package:angular2/src/render/dom/view/shared_styles_host.dart"
    show SharedStylesHost;
import "package:angular2/src/render/dom/template_cloner.dart"
    show TemplateCloner;
import "pipeline_spec.dart" show MockStep;

runCompilerCommonTests() {
  describe("DomCompiler", () {
    MockStepFactory mockStepFactory;
    SharedStylesHost sharedStylesHost;
    beforeEach(() {
      sharedStylesHost = new SharedStylesHost();
    });
    createCompiler([processElementClosure = null, processStyleClosure = null,
        urlData = null]) {
      if (isBlank(urlData)) {
        urlData = new Map();
      }
      var tplLoader = new FakeViewLoader(urlData);
      mockStepFactory = new MockStepFactory(
          [new MockStep(processElementClosure, processStyleClosure)]);
      return new DomCompiler(new ElementSchemaRegistry(),
          new TemplateCloner(-1), mockStepFactory, tplLoader, sharedStylesHost);
    }
    describe("compile", () {
      it("should run the steps and build the AppProtoView of the root element",
          inject([AsyncTestCompleter], (async) {
        var compiler = createCompiler((parent, current, control) {
          current.inheritedProtoView.bindVariable("b", "a");
        });
        compiler
            .compile(new ViewDefinition(
                componentId: "someComponent", template: "<div></div>"))
            .then((protoView) {
          expect(protoView.variableBindings)
              .toEqual(MapWrapper.createFromStringMap({"a": "b"}));
          async.done();
        });
      }));
      it("should run the steps and build the proto view", inject(
          [AsyncTestCompleter], (async) {
        var compiler = createCompiler((parent, current, control) {
          current.inheritedProtoView.bindVariable("b", "a");
        });
        var dirMetadata = DirectiveMetadata.create(
            id: "id",
            selector: "custom",
            type: DirectiveMetadata.COMPONENT_TYPE);
        compiler.compileHost(dirMetadata).then((protoView) {
          expect(DOM
              .tagName(DOM.firstChild(DOM.content(templateRoot(protoView))))
              .toLowerCase()).toEqual("custom");
          expect(mockStepFactory.viewDef.directives).toEqual([dirMetadata]);
          expect(protoView.variableBindings)
              .toEqual(MapWrapper.createFromStringMap({"a": "b"}));
          async.done();
        });
      }));
      it("should use the inline template and compile in sync", inject(
          [AsyncTestCompleter], (async) {
        var compiler = createCompiler(EMPTY_STEP);
        compiler
            .compile(new ViewDefinition(
                componentId: "someId", template: "inline component"))
            .then((protoView) {
          expect(DOM.getInnerHTML(templateRoot(protoView)))
              .toEqual("inline component");
          async.done();
        });
      }));
      it("should load url templates", inject([AsyncTestCompleter], (async) {
        var urlData =
            MapWrapper.createFromStringMap({"someUrl": "url component"});
        var compiler = createCompiler(EMPTY_STEP, null, urlData);
        compiler
            .compile(new ViewDefinition(
                componentId: "someId", templateAbsUrl: "someUrl"))
            .then((protoView) {
          expect(DOM.getInnerHTML(templateRoot(protoView)))
              .toEqual("url component");
          async.done();
        });
      }));
      it("should report loading errors", inject([AsyncTestCompleter], (async) {
        var compiler = createCompiler(EMPTY_STEP, null, new Map());
        PromiseWrapper.catchError(compiler.compile(new ViewDefinition(
            componentId: "someId", templateAbsUrl: "someUrl")), (e) {
          expect(e.message).toEqual(
              "Failed to load the template for \"someId\" : Failed to fetch url \"someUrl\"");
          async.done();
          return null;
        });
      }));
      it("should return ProtoViews of type COMPONENT_VIEW_TYPE", inject(
          [AsyncTestCompleter], (async) {
        var compiler = createCompiler(EMPTY_STEP);
        compiler
            .compile(new ViewDefinition(
                componentId: "someId", template: "inline component"))
            .then((protoView) {
          expect(protoView.type).toEqual(ViewType.COMPONENT);
          async.done();
        });
      }));
    });
    describe("compileHost", () {
      it("should return ProtoViews of type HOST_VIEW_TYPE", inject(
          [AsyncTestCompleter], (async) {
        var compiler = createCompiler(EMPTY_STEP);
        compiler.compileHost(someComponent).then((protoView) {
          expect(protoView.type).toEqual(ViewType.HOST);
          async.done();
        });
      }));
    });
    describe("compile styles", () {
      it("should run the steps", inject([AsyncTestCompleter], (async) {
        var compiler = createCompiler(null, (style) {
          return style + "b {};";
        });
        compiler
            .compile(new ViewDefinition(
                componentId: "someComponent", template: "", styles: ["a {};"]))
            .then((protoViewDto) {
          expect(sharedStylesHost.getAllStyles()).toEqual(["a {};b {};"]);
          async.done();
        });
      }));
      it("should store the styles in the SharedStylesHost for ViewEncapsulation.NONE",
          inject([AsyncTestCompleter], (async) {
        var compiler = createCompiler();
        compiler
            .compile(new ViewDefinition(
                componentId: "someComponent",
                template: "",
                styles: ["a {};"],
                encapsulation: ViewEncapsulation.NONE))
            .then((protoViewDto) {
          expect(DOM.getInnerHTML(templateRoot(protoViewDto))).toEqual("");
          expect(sharedStylesHost.getAllStyles()).toEqual(["a {};"]);
          async.done();
        });
      }));
      it("should store the styles in the SharedStylesHost for ViewEncapsulation.EMULATED",
          inject([AsyncTestCompleter], (async) {
        var compiler = createCompiler();
        compiler
            .compile(new ViewDefinition(
                componentId: "someComponent",
                template: "",
                styles: ["a {};"],
                encapsulation: ViewEncapsulation.EMULATED))
            .then((protoViewDto) {
          expect(DOM.getInnerHTML(templateRoot(protoViewDto))).toEqual("");
          expect(sharedStylesHost.getAllStyles()).toEqual(["a {};"]);
          async.done();
        });
      }));
      if (DOM.supportsNativeShadowDOM()) {
        it("should store the styles in the template for ViewEncapsulation.NATIVE",
            inject([AsyncTestCompleter], (async) {
          var compiler = createCompiler();
          compiler
              .compile(new ViewDefinition(
                  componentId: "someComponent",
                  template: "",
                  styles: ["a {};"],
                  encapsulation: ViewEncapsulation.NATIVE))
              .then((protoViewDto) {
            expect(DOM.getInnerHTML(templateRoot(protoViewDto)))
                .toEqual("<style>a {};</style>");
            expect(sharedStylesHost.getAllStyles()).toEqual([]);
            async.done();
          });
        }));
      }
      it("should default to ViewEncapsulation.NONE if no styles are specified",
          inject([AsyncTestCompleter], (async) {
        var compiler = createCompiler();
        compiler
            .compile(new ViewDefinition(
                componentId: "someComponent", template: "", styles: []))
            .then((protoView) {
          expect(mockStepFactory.viewDef.encapsulation)
              .toBe(ViewEncapsulation.NONE);
          async.done();
        });
      }));
      it("should default to ViewEncapsulation.EMULATED if styles are specified",
          inject([AsyncTestCompleter], (async) {
        var compiler = createCompiler();
        compiler
            .compile(new ViewDefinition(
                componentId: "someComponent", template: "", styles: ["a {};"]))
            .then((protoView) {
          expect(mockStepFactory.viewDef.encapsulation)
              .toBe(ViewEncapsulation.EMULATED);
          async.done();
        });
      }));
    });
    describe("mergeProtoViews", () {
      it("should store the styles of the merged ProtoView in the SharedStylesHost",
          inject([AsyncTestCompleter], (async) {
        var compiler = createCompiler();
        compiler
            .compile(new ViewDefinition(
                componentId: "someComponent", template: "", styles: ["a {};"]))
            .then((protoViewDto) =>
                compiler.mergeProtoViewsRecursively([protoViewDto.render]))
            .then((_) {
          expect(sharedStylesHost.getAllStyles()).toEqual(["a {};"]);
          async.done();
        });
      }));
    });
  });
}
dynamic templateRoot(ProtoViewDto protoViewDto) {
  var pv = resolveInternalDomProtoView(protoViewDto.render);
  return ((pv.cloneableTemplate as dynamic));
}
class MockStepFactory extends CompileStepFactory {
  List<CompileStep> steps;
  List<Future<dynamic>> subTaskPromises;
  ViewDefinition viewDef;
  MockStepFactory(steps) : super() {
    /* super call moved to initializer */;
    this.steps = steps;
  }
  List<CompileStep> createSteps(viewDef) {
    this.viewDef = viewDef;
    return this.steps;
  }
}
var EMPTY_STEP = (parent, current, control) {
  if (isPresent(parent)) {
    current.inheritedProtoView = parent.inheritedProtoView;
  }
};
class FakeViewLoader extends ViewLoader {
  Map<String, String> _urlData;
  FakeViewLoader(urlData) : super(null, null, null) {
    /* super call moved to initializer */;
    this._urlData = urlData;
  }
  Future<dynamic> load(viewDef) {
    var styles = isPresent(viewDef.styles) ? viewDef.styles : [];
    if (isPresent(viewDef.template)) {
      return PromiseWrapper
          .resolve(new TemplateAndStyles(viewDef.template, styles));
    }
    if (isPresent(viewDef.templateAbsUrl)) {
      var content = this._urlData[viewDef.templateAbsUrl];
      return isPresent(content)
          ? PromiseWrapper.resolve(new TemplateAndStyles(content, styles))
          : PromiseWrapper.reject(
              '''Failed to fetch url "${ viewDef . templateAbsUrl}"''', null);
    }
    throw new BaseException(
        "View should have either the templateUrl or template property set");
  }
}
var someComponent = DirectiveMetadata.create(
    selector: "some-comp",
    id: "someComponent",
    type: DirectiveMetadata.COMPONENT_TYPE);
