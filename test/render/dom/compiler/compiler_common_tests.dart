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
    show ProtoViewDto, ViewDefinition, DirectiveMetadata, ViewType;
import "package:angular2/src/render/dom/compiler/compile_element.dart"
    show CompileElement;
import "package:angular2/src/render/dom/compiler/compile_step.dart"
    show CompileStep;
import "package:angular2/src/render/dom/compiler/compile_step_factory.dart"
    show CompileStepFactory;
import "package:angular2/src/render/dom/compiler/compile_control.dart"
    show CompileControl;
import "package:angular2/src/render/dom/compiler/view_loader.dart"
    show ViewLoader;
import "package:angular2/src/render/dom/view/proto_view.dart"
    show resolveInternalDomProtoView;

runCompilerCommonTests() {
  describe("DomCompiler", () {
    MockStepFactory mockStepFactory;
    createCompiler(processClosure, [urlData = null]) {
      if (isBlank(urlData)) {
        urlData = new Map();
      }
      var tplLoader = new FakeViewLoader(urlData);
      mockStepFactory = new MockStepFactory([new MockStep(processClosure)]);
      return new DomCompiler(mockStepFactory, tplLoader);
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
            selector: "CUSTOM",
            type: DirectiveMetadata.COMPONENT_TYPE);
        compiler.compileHost(dirMetadata).then((protoView) {
          expect(DOM.tagName(
                  resolveInternalDomProtoView(protoView.render).element))
              .toEqual("CUSTOM");
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
          expect(DOM.getInnerHTML(
                  resolveInternalDomProtoView(protoView.render).element))
              .toEqual("inline component");
          async.done();
        });
      }));
      it("should load url templates", inject([AsyncTestCompleter], (async) {
        var urlData =
            MapWrapper.createFromStringMap({"someUrl": "url component"});
        var compiler = createCompiler(EMPTY_STEP, urlData);
        compiler
            .compile(new ViewDefinition(
                componentId: "someId", templateAbsUrl: "someUrl"))
            .then((protoView) {
          expect(DOM.getInnerHTML(
                  resolveInternalDomProtoView(protoView.render).element))
              .toEqual("url component");
          async.done();
        });
      }));
      it("should report loading errors", inject([AsyncTestCompleter], (async) {
        var compiler = createCompiler(EMPTY_STEP, new Map());
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
  });
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
  Future<dynamic> load(ViewDefinition view) {
    if (isPresent(view.template)) {
      return PromiseWrapper.resolve(DOM.createTemplate(view.template));
    }
    if (isPresent(view.templateAbsUrl)) {
      var content = this._urlData[view.templateAbsUrl];
      return isPresent(content)
          ? PromiseWrapper.resolve(DOM.createTemplate(content))
          : PromiseWrapper.reject(
              '''Failed to fetch url "${ view . templateAbsUrl}"''', null);
    }
    throw new BaseException(
        "View should have either the templateUrl or template property set");
  }
}
var someComponent = DirectiveMetadata.create(
    selector: "some-comp",
    id: "someComponent",
    type: DirectiveMetadata.COMPONENT_TYPE);
