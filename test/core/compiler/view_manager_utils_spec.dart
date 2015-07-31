library angular2.test.core.compiler.view_manager_utils_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        beforeEach,
        ddescribe,
        xdescribe,
        describe,
        el,
        dispatchEvent,
        expect,
        iit,
        inject,
        beforeEachBindings,
        it,
        xit,
        SpyObject,
        SpyChangeDetector,
        SpyProtoChangeDetector,
        proxy,
        Log;
import "package:angular2/di.dart" show Injector, bind;
import "package:angular2/src/facade/lang.dart" show isBlank, isPresent;
import "package:angular2/src/facade/collection.dart"
    show MapWrapper, ListWrapper, StringMapWrapper;
import "package:angular2/src/core/compiler/view.dart"
    show AppProtoView, AppView, AppProtoViewMergeMapping;
import "package:angular2/src/core/compiler/element_binder.dart"
    show ElementBinder;
import "package:angular2/src/core/compiler/element_injector.dart"
    show
        DirectiveBinding,
        ElementInjector,
        PreBuiltObjects,
        ProtoElementInjector;
import "package:angular2/src/core/compiler/directive_resolver.dart"
    show DirectiveResolver;
import "package:angular2/annotations.dart" show Component;
import "package:angular2/src/core/compiler/view_manager_utils.dart"
    show AppViewManagerUtils;
import "package:angular2/src/render/render.dart"
    show RenderProtoViewMergeMapping, ViewType, RenderViewWithFragments;

main() {
  // TODO(tbosch): add more tests here!
  describe("AppViewManagerUtils", () {
    AppViewManagerUtils utils;
    beforeEach(() {
      utils = new AppViewManagerUtils();
    });
    AppView createViewWithChildren(AppProtoView pv) {
      var renderViewWithFragments =
          new RenderViewWithFragments(null, [null, null]);
      return utils.createView(pv, renderViewWithFragments, null, null);
    }
    describe("shared hydrate functionality", () {
      it("should hydrate the change detector after hydrating element injectors",
          () {
        var log = new Log();
        var componentProtoView = createComponentPv([createEmptyElBinder()]);
        var hostView = createViewWithChildren(
            createHostPv([createNestedElBinder(componentProtoView)]));
        var componentView = hostView.views[1];
        var spyEi = (componentView.elementInjectors[0] as dynamic);
        spyEi.spy("hydrate").andCallFake(log.fn("hydrate"));
        var spyCd = (componentView.changeDetector as dynamic);
        spyCd.spy("hydrate").andCallFake(log.fn("hydrateCD"));
        utils.hydrateRootHostView(hostView, createInjector());
        expect(log.result()).toEqual("hydrate; hydrateCD");
      });
      it("should set up event listeners", () {
        var dir = new Object();
        var hostPv = createHostPv(
            [createNestedElBinder(createComponentPv()), createEmptyElBinder()]);
        var hostView = createViewWithChildren(hostPv);
        var spyEventAccessor1 = SpyObject.stub({"subscribe": null});
        SpyObject.stub(hostView.elementInjectors[0], {
          "getHostActionAccessors": [],
          "getEventEmitterAccessors": [[spyEventAccessor1]],
          "getDirectiveAtIndex": dir
        });
        var spyEventAccessor2 = SpyObject.stub({"subscribe": null});
        SpyObject.stub(hostView.elementInjectors[1], {
          "getHostActionAccessors": [],
          "getEventEmitterAccessors": [[spyEventAccessor2]],
          "getDirectiveAtIndex": dir
        });
        utils.hydrateRootHostView(hostView, createInjector());
        expect(spyEventAccessor1.spy("subscribe")).toHaveBeenCalledWith(
            hostView, 0, dir);
        expect(spyEventAccessor2.spy("subscribe")).toHaveBeenCalledWith(
            hostView, 1, dir);
      });
      it("should set up host action listeners", () {
        var dir = new Object();
        var hostPv = createHostPv(
            [createNestedElBinder(createComponentPv()), createEmptyElBinder()]);
        var hostView = createViewWithChildren(hostPv);
        var spyActionAccessor1 = SpyObject.stub({"subscribe": null});
        SpyObject.stub(hostView.elementInjectors[0], {
          "getHostActionAccessors": [[spyActionAccessor1]],
          "getEventEmitterAccessors": [],
          "getDirectiveAtIndex": dir
        });
        var spyActionAccessor2 = SpyObject.stub({"subscribe": null});
        SpyObject.stub(hostView.elementInjectors[1], {
          "getHostActionAccessors": [[spyActionAccessor2]],
          "getEventEmitterAccessors": [],
          "getDirectiveAtIndex": dir
        });
        utils.hydrateRootHostView(hostView, createInjector());
        expect(spyActionAccessor1.spy("subscribe")).toHaveBeenCalledWith(
            hostView, 0, dir);
        expect(spyActionAccessor2.spy("subscribe")).toHaveBeenCalledWith(
            hostView, 1, dir);
      });
      it("should not hydrate element injectors of component views inside of embedded fragments",
          () {
        var hostView = createViewWithChildren(createHostPv([
          createNestedElBinder(createComponentPv([
            createNestedElBinder(createEmbeddedPv([
              createNestedElBinder(createComponentPv([createEmptyElBinder()]))
            ]))
          ]))
        ]));
        utils.hydrateRootHostView(hostView, createInjector());
        expect(hostView.elementInjectors.length).toBe(4);
        expect(((hostView.elementInjectors[3] as dynamic)).spy("hydrate")).not
            .toHaveBeenCalled();
      });
    });
    describe("attachViewInContainer", () {
      var parentView, contextView, childView;
      createViews([numInj = 1]) {
        var childPv = createEmbeddedPv([createEmptyElBinder()]);
        childView = createViewWithChildren(childPv);
        var parentPv = createHostPv([createEmptyElBinder()]);
        parentView = createViewWithChildren(parentPv);
        var binders = [];
        for (var i = 0; i < numInj; i++) {
          binders.add(createEmptyElBinder(i > 0 ? binders[i - 1] : null));
        }
        ;
        var contextPv = createHostPv(binders);
        contextView = createViewWithChildren(contextPv);
      }
      it("should link the views rootElementInjectors at the given context", () {
        createViews();
        utils.attachViewInContainer(
            parentView, 0, contextView, 0, 0, childView);
        expect(contextView.rootElementInjectors.length).toEqual(2);
      });
      it("should link the views rootElementInjectors after the elementInjector at the given context",
          () {
        createViews(2);
        utils.attachViewInContainer(
            parentView, 0, contextView, 1, 0, childView);
        expect(childView.rootElementInjectors[0].spy("linkAfter"))
            .toHaveBeenCalledWith(contextView.elementInjectors[0], null);
      });
    });
    describe("hydrateViewInContainer", () {
      var parentView, contextView, childView;
      createViews() {
        var parentPv = createHostPv([createEmptyElBinder()]);
        parentView = createViewWithChildren(parentPv);
        var contextPv = createHostPv([createEmptyElBinder()]);
        contextView = createViewWithChildren(contextPv);
        var childPv = createEmbeddedPv([createEmptyElBinder()]);
        childView = createViewWithChildren(childPv);
        utils.attachViewInContainer(
            parentView, 0, contextView, 0, 0, childView);
      }
      it("should instantiate the elementInjectors with the host of the context's elementInjector",
          () {
        createViews();
        utils.hydrateViewInContainer(parentView, 0, contextView, 0, 0, null);
        expect(childView.rootElementInjectors[0].spy("hydrate"))
            .toHaveBeenCalledWith(null,
                contextView.elementInjectors[0].getHost(),
                childView.preBuiltObjects[0]);
      });
    });
    describe("hydrateRootHostView", () {
      var hostView;
      createViews() {
        var hostPv = createHostPv([createNestedElBinder(createComponentPv())]);
        hostView = createViewWithChildren(hostPv);
      }
      it("should instantiate the elementInjectors with the given injector and an empty host element injector",
          () {
        var injector = createInjector();
        createViews();
        utils.hydrateRootHostView(hostView, injector);
        expect(hostView.rootElementInjectors[0].spy("hydrate"))
            .toHaveBeenCalledWith(injector, null, hostView.preBuiltObjects[0]);
      });
    });
  });
}
createInjector() {
  return Injector.resolveAndCreate([]);
}
createElementInjector([parent = null]) {
  var host = new SpyElementInjector(null);
  var elementInjector = new SpyElementInjector(parent);
  return SpyObject.stub(elementInjector, {
    "isExportingComponent": false,
    "isExportingElement": false,
    "getEventEmitterAccessors": [],
    "getHostActionAccessors": [],
    "getComponent": new Object(),
    "getHost": host
  }, {});
}
ProtoElementInjector createProtoElInjector(
    [ProtoElementInjector parent = null]) {
  var pei = new SpyProtoElementInjector(parent);
  pei
      .spy("instantiate")
      .andCallFake((parentEli) => createElementInjector(parentEli));
  return (pei as dynamic);
}
createEmptyElBinder([ElementBinder parent = null]) {
  var parentPeli = isPresent(parent) ? parent.protoElementInjector : null;
  return new ElementBinder(0, null, 0, createProtoElInjector(parentPeli), null);
}
createNestedElBinder(AppProtoView nestedProtoView) {
  var componentBinding = null;
  if (identical(nestedProtoView.type, ViewType.COMPONENT)) {
    var annotation = new DirectiveResolver().resolve(SomeComponent);
    componentBinding =
        DirectiveBinding.createFromType(SomeComponent, annotation);
  }
  var binder =
      new ElementBinder(0, null, 0, createProtoElInjector(), componentBinding);
  binder.nestedProtoView = nestedProtoView;
  return binder;
}
num countNestedElementBinders(AppProtoView pv) {
  var result = pv.elementBinders.length;
  pv.elementBinders.forEach((binder) {
    if (isPresent(binder.nestedProtoView)) {
      result += countNestedElementBinders(binder.nestedProtoView);
    }
  });
  return result;
}
List<num> calcHostElementIndicesByViewIndex(AppProtoView pv,
    [elementOffset = 0, List<num> target = null]) {
  if (isBlank(target)) {
    target = [null];
  }
  for (var binderIdx = 0; binderIdx < pv.elementBinders.length; binderIdx++) {
    var binder = pv.elementBinders[binderIdx];
    if (isPresent(binder.nestedProtoView)) {
      target.add(elementOffset + binderIdx);
      calcHostElementIndicesByViewIndex(binder.nestedProtoView,
          elementOffset + pv.elementBinders.length, target);
      elementOffset += countNestedElementBinders(binder.nestedProtoView);
    }
  }
  return target;
}
List<num> countNestedProtoViews(AppProtoView pv, [List<num> target = null]) {
  if (isBlank(target)) {
    target = [];
  }
  target.add(null);
  var resultIndex = target.length - 1;
  var count = 0;
  for (var binderIdx = 0; binderIdx < pv.elementBinders.length; binderIdx++) {
    var binder = pv.elementBinders[binderIdx];
    if (isPresent(binder.nestedProtoView)) {
      var nextResultIndex = target.length;
      countNestedProtoViews(binder.nestedProtoView, target);
      count += target[nextResultIndex] + 1;
    }
  }
  target[resultIndex] = count;
  return target;
}
_createProtoView(ViewType type, [List<ElementBinder> binders = null]) {
  if (isBlank(binders)) {
    binders = [];
  }
  var protoChangeDetector = (new SpyProtoChangeDetector() as dynamic);
  protoChangeDetector.spy("instantiate").andReturn(new SpyChangeDetector());
  var res =
      new AppProtoView(type, null, null, protoChangeDetector, null, null, 0);
  res.elementBinders = binders;
  var mappedElementIndices =
      ListWrapper.createFixedSize(countNestedElementBinders(res));
  for (var i = 0; i < binders.length; i++) {
    var binder = binders[i];
    mappedElementIndices[i] = i;
    binder.protoElementInjector.index = i;
  }
  var hostElementIndicesByViewIndex = calcHostElementIndicesByViewIndex(res);
  if (identical(type, ViewType.EMBEDDED) || identical(type, ViewType.HOST)) {
    res.mergeMapping = new AppProtoViewMergeMapping(
        new RenderProtoViewMergeMapping(null,
            hostElementIndicesByViewIndex.length, mappedElementIndices,
            mappedElementIndices.length, [], hostElementIndicesByViewIndex,
            countNestedProtoViews(res)));
  }
  return res;
}
createHostPv([List<ElementBinder> binders = null]) {
  return _createProtoView(ViewType.HOST, binders);
}
createComponentPv([List<ElementBinder> binders = null]) {
  return _createProtoView(ViewType.COMPONENT, binders);
}
createEmbeddedPv([List<ElementBinder> binders = null]) {
  return _createProtoView(ViewType.EMBEDDED, binders);
}
@Component(selector: "someComponent")
class SomeComponent {}
@proxy()
class SpyProtoElementInjector extends SpyObject
    implements ProtoElementInjector {
  ProtoElementInjector parent;
  num index;
  SpyProtoElementInjector(this.parent) : super(ProtoElementInjector) {
    /* super call moved to initializer */;
  }
  noSuchMethod(m) {
    return super.noSuchMethod(m);
  }
}
@proxy()
class SpyElementInjector extends SpyObject implements ElementInjector {
  ElementInjector parent;
  SpyElementInjector(this.parent) : super(ElementInjector) {
    /* super call moved to initializer */;
  }
  noSuchMethod(m) {
    return super.noSuchMethod(m);
  }
}
@proxy()
class SpyPreBuiltObjects extends SpyObject implements PreBuiltObjects {
  SpyPreBuiltObjects() : super(PreBuiltObjects) {
    /* super call moved to initializer */;
  }
  noSuchMethod(m) {
    return super.noSuchMethod(m);
  }
}
@proxy()
class SpyInjector extends SpyObject implements Injector {
  SpyInjector() : super(Injector) {
    /* super call moved to initializer */;
  }
  noSuchMethod(m) {
    return super.noSuchMethod(m);
  }
}
