library angular2.test.core.compiler.proto_view_factory_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        beforeEach,
        xdescribe,
        ddescribe,
        describe,
        el,
        expect,
        iit,
        inject,
        IS_DARTIUM,
        it,
        SpyObject,
        proxy;
import "package:angular2/src/facade/lang.dart" show isBlank, stringify;
import "package:angular2/src/facade/collection.dart" show MapWrapper;
import "package:angular2/src/change_detection/change_detection.dart"
    show ChangeDetection, ChangeDetectorDefinition;
import "package:angular2/src/core/compiler/proto_view_factory.dart"
    show
        ProtoViewFactory,
        getChangeDetectorDefinitions,
        createDirectiveVariableBindings,
        createVariableLocations;
import "package:angular2/annotations.dart" show Component, Directive;
import "package:angular2/di.dart" show Key;
import "package:angular2/src/core/compiler/directive_resolver.dart"
    show DirectiveResolver;
import "package:angular2/src/core/compiler/element_injector.dart"
    show DirectiveBinding;
import "package:angular2/src/render/api.dart" as renderApi;

main() {
  // TODO(tbosch): add missing tests
  describe("ProtoViewFactory", () {
    var changeDetection;
    ProtoViewFactory protoViewFactory;
    var directiveResolver;
    beforeEach(() {
      directiveResolver = new DirectiveResolver();
      changeDetection = new ChangeDetectionSpy();
      protoViewFactory = new ProtoViewFactory(changeDetection);
    });
    bindDirective(type) {
      return DirectiveBinding.createFromType(
          type, directiveResolver.resolve(type));
    }
    describe("getChangeDetectorDefinitions", () {
      it("should create a ChangeDetectorDefinition for the root render proto view",
          () {
        var renderPv = createRenderProtoView();
        var defs = getChangeDetectorDefinitions(
            bindDirective(MainComponent).metadata, renderPv, []);
        expect(defs.length).toBe(1);
        expect(defs[0].id)
            .toEqual('''${ stringify ( MainComponent )}_comp_0''');
      });
    });
    describe("createAppProtoViews", () {
      it("should create an AppProtoView for the root render proto view", () {
        var varBindings = new Map();
        varBindings["a"] = "b";
        var renderPv = createRenderProtoView([], null, varBindings);
        var appPvs = protoViewFactory.createAppProtoViews(
            bindDirective(MainComponent), renderPv, []);
        expect(appPvs[0].variableBindings["a"]).toEqual("b");
        expect(appPvs.length).toBe(1);
      });
    });
    describe("createDirectiveVariableBindings", () {
      it("should calculate directive variable bindings", () {
        var dvbs = createDirectiveVariableBindings(new renderApi.ElementBinder(
            variableBindings: MapWrapper
                .createFromStringMap({"exportName": "templateName"})), [
          directiveBinding(
              metadata: renderApi.DirectiveMetadata.create(
                  exportAs: "exportName")),
          directiveBinding(
              metadata: renderApi.DirectiveMetadata.create(
                  exportAs: "otherName"))
        ]);
        expect(dvbs)
            .toEqual(MapWrapper.createFromStringMap({"templateName": 0}));
      });
      it("should set exportAs to \$implicit for component with exportAs = null",
          () {
        var dvbs = createDirectiveVariableBindings(new renderApi.ElementBinder(
            variableBindings: MapWrapper
                .createFromStringMap({"\$implicit": "templateName"})), [
          directiveBinding(
              metadata: renderApi.DirectiveMetadata.create(
                  exportAs: null,
                  type: renderApi.DirectiveMetadata.COMPONENT_TYPE))
        ]);
        expect(dvbs)
            .toEqual(MapWrapper.createFromStringMap({"templateName": 0}));
      });
      it("should throw we no directive exported with this name", () {
        expect(() {
          createDirectiveVariableBindings(new renderApi.ElementBinder(
              variableBindings: MapWrapper
                  .createFromStringMap({"someInvalidName": "templateName"})), [
            directiveBinding(
                metadata: renderApi.DirectiveMetadata.create(
                    exportAs: "exportName"))
          ]);
        }).toThrowError(new RegExp(
            "Cannot find directive with exportAs = 'someInvalidName'"));
      });
      it("should throw when binding to a name exported by two directives", () {
        expect(() {
          createDirectiveVariableBindings(new renderApi.ElementBinder(
              variableBindings: MapWrapper
                  .createFromStringMap({"exportName": "templateName"})), [
            directiveBinding(
                metadata: renderApi.DirectiveMetadata.create(
                    exportAs: "exportName")),
            directiveBinding(
                metadata: renderApi.DirectiveMetadata.create(
                    exportAs: "exportName"))
          ]);
        }).toThrowError(
            new RegExp("More than one directive have exportAs = 'exportName'"));
      });
      it("should not throw when not binding to a name exported by two directives",
          () {
        expect(() {
          createDirectiveVariableBindings(
              new renderApi.ElementBinder(variableBindings: new Map()), [
            directiveBinding(
                metadata: renderApi.DirectiveMetadata.create(
                    exportAs: "exportName")),
            directiveBinding(
                metadata: renderApi.DirectiveMetadata.create(
                    exportAs: "exportName"))
          ]);
        }).not.toThrow();
      });
    });
    describe("createVariableLocations", () {
      it("should merge the names in the template for all ElementBinders", () {
        expect(createVariableLocations([
          new renderApi.ElementBinder(
              variableBindings: MapWrapper.createFromStringMap({"x": "a"})),
          new renderApi.ElementBinder(
              variableBindings: MapWrapper.createFromStringMap({"y": "b"}))
        ])).toEqual(MapWrapper.createFromStringMap({"a": 0, "b": 1}));
      });
    });
  });
}
directiveBinding({metadata}) {
  return new DirectiveBinding(Key.get("dummy"), null, [], [], [], metadata);
}
createRenderProtoView([elementBinders = null, renderApi.ViewType type = null,
    variableBindings = null]) {
  if (isBlank(type)) {
    type = renderApi.ViewType.COMPONENT;
  }
  if (isBlank(elementBinders)) {
    elementBinders = [];
  }
  if (isBlank(variableBindings)) {
    variableBindings = new Map();
  }
  return new renderApi.ProtoViewDto(
      elementBinders: elementBinders,
      type: type,
      variableBindings: variableBindings,
      textBindings: [],
      transitiveNgContentCount: 0);
}
createRenderComponentElementBinder(directiveIndex) {
  return new renderApi.ElementBinder(
      directives: [
    new renderApi.DirectiveBinder(directiveIndex: directiveIndex)
  ]);
}
createRenderViewportElementBinder(nestedProtoView) {
  return new renderApi.ElementBinder(nestedProtoView: nestedProtoView);
}
@proxy()
class ChangeDetectionSpy extends SpyObject implements ChangeDetection {
  ChangeDetectionSpy() : super(ChangeDetection) {
    /* super call moved to initializer */;
  }
  noSuchMethod(m) {
    return super.noSuchMethod(m);
  }
}
@Component(selector: "main-comp")
class MainComponent {}
