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
        proxy,
        Log;
import "package:angular2/di.dart" show Injector, bind;
import "package:angular2/src/facade/lang.dart" show isBlank, isPresent;
import "package:angular2/src/facade/collection.dart"
    show MapWrapper, ListWrapper, StringMapWrapper;
import "package:angular2/src/core/compiler/view.dart"
    show AppProtoView, AppView;
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

main() {
  // TODO(tbosch): add more tests here!
  describe("AppViewManagerUtils", () {
    var directiveResolver;
    var utils;
    createInjector() {
      return Injector.resolveAndCreate([]);
    }
    createDirectiveBinding(type) {
      var annotation = directiveResolver.resolve(type);
      return DirectiveBinding.createFromType(type, annotation);
    }
    createEmptyElBinder() {
      return new ElementBinder(0, null, 0, null, null);
    }
    createComponentElBinder([nestedProtoView = null]) {
      var binding = createDirectiveBinding(SomeComponent);
      var binder = new ElementBinder(0, null, 0, null, binding);
      binder.nestedProtoView = nestedProtoView;
      return binder;
    }
    createProtoView([binders = null]) {
      if (isBlank(binders)) {
        binders = [];
      }
      var res = new AppProtoView(null, null, null, null);
      res.elementBinders = binders;
      return res;
    }
    createElementInjector([parent = null]) {
      var host = new SpyElementInjector();
      var elementInjector = isPresent(parent)
          ? new SpyElementInjectorWithParent(parent)
          : new SpyElementInjector();
      return SpyObject.stub(elementInjector, {
        "isExportingComponent": false,
        "isExportingElement": false,
        "getEventEmitterAccessors": [],
        "getHostActionAccessors": [],
        "getComponent": null,
        "getHost": host
      }, {});
    }
    createView([pv = null, nestedInjectors = false]) {
      if (isBlank(pv)) {
        pv = createProtoView();
      }
      var view = new AppView(null, pv, new Map());
      var elementInjectors =
          ListWrapper.createGrowableSize(pv.elementBinders.length);
      var preBuiltObjects =
          ListWrapper.createFixedSize(pv.elementBinders.length);
      for (var i = 0; i < pv.elementBinders.length; i++) {
        if (nestedInjectors && i > 0) {
          elementInjectors[i] = createElementInjector(elementInjectors[i - 1]);
        } else {
          elementInjectors[i] = createElementInjector();
        }
        preBuiltObjects[i] = new SpyPreBuiltObjects();
      }
      view.init((new SpyChangeDetector() as dynamic), elementInjectors,
          elementInjectors, preBuiltObjects,
          ListWrapper.createFixedSize(pv.elementBinders.length));
      return view;
    }
    beforeEach(() {
      directiveResolver = new DirectiveResolver();
      utils = new AppViewManagerUtils();
    });
    describe("hydrateComponentView", () {
      it("should hydrate the change detector after hydrating element injectors",
          () {
        var log = new Log();
        var componentView =
            createView(createProtoView([createEmptyElBinder()]));
        var hostView = createView(
            createProtoView([createComponentElBinder(createProtoView())]));
        hostView.componentChildViews = [componentView];
        var spyEi = (componentView.elementInjectors[0] as dynamic);
        spyEi.spy("hydrate").andCallFake(log.fn("hydrate"));
        var spyCd = (componentView.changeDetector as dynamic);
        spyCd.spy("hydrate").andCallFake(log.fn("hydrateCD"));
        utils.hydrateComponentView(hostView, 0);
        expect(log.result()).toEqual("hydrate; hydrateCD");
      });
    });
    describe("shared hydrate functionality", () {
      it("should set up event listeners", () {
        var dir = new Object();
        var hostPv = createProtoView(
            [createComponentElBinder(null), createEmptyElBinder()]);
        var hostView = createView(hostPv);
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
        var shadowView = createView();
        utils.attachComponentView(hostView, 0, shadowView);
        utils.hydrateRootHostView(hostView, createInjector());
        expect(spyEventAccessor1.spy("subscribe")).toHaveBeenCalledWith(
            hostView, 0, dir);
        expect(spyEventAccessor2.spy("subscribe")).toHaveBeenCalledWith(
            hostView, 1, dir);
      });
      it("should set up host action listeners", () {
        var dir = new Object();
        var hostPv = createProtoView(
            [createComponentElBinder(null), createEmptyElBinder()]);
        var hostView = createView(hostPv);
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
        var shadowView = createView();
        utils.attachComponentView(hostView, 0, shadowView);
        utils.hydrateRootHostView(hostView, createInjector());
        expect(spyActionAccessor1.spy("subscribe")).toHaveBeenCalledWith(
            hostView, 0, dir);
        expect(spyActionAccessor2.spy("subscribe")).toHaveBeenCalledWith(
            hostView, 1, dir);
      });
    });
    describe("attachViewInContainer", () {
      var parentView, contextView, childView;
      createViews([numInj = 1]) {
        var parentPv = createProtoView([createEmptyElBinder()]);
        parentView = createView(parentPv);
        var binders = [];
        for (var i = 0; i < numInj; i++) binders.add(createEmptyElBinder());
        var contextPv = createProtoView(binders);
        contextView = createView(contextPv, true);
        var childPv = createProtoView([createEmptyElBinder()]);
        childView = createView(childPv);
      }
      it("should link the views rootElementInjectors at the given context", () {
        createViews();
        utils.attachViewInContainer(
            parentView, 0, contextView, 0, 0, childView);
        expect(contextView.elementInjectors.length).toEqual(2);
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
        var parentPv = createProtoView([createEmptyElBinder()]);
        parentView = createView(parentPv);
        var contextPv = createProtoView([createEmptyElBinder()]);
        contextView = createView(contextPv);
        var childPv = createProtoView([createEmptyElBinder()]);
        childView = createView(childPv);
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
        var hostPv = createProtoView([createComponentElBinder()]);
        hostView = createView(hostPv);
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
@Component(selector: "someComponent")
class SomeComponent {}
@proxy
class SpyElementInjector extends SpyObject implements ElementInjector {
  SpyElementInjector() : super(ElementInjector) {
    /* super call moved to initializer */;
  }
  noSuchMethod(m) {
    return super.noSuchMethod(m);
  }
}
@proxy
class SpyElementInjectorWithParent extends SpyObject
    implements ElementInjector {
  ElementInjector parent;
  SpyElementInjectorWithParent(parent) : super(ElementInjector) {
    /* super call moved to initializer */;
    this.parent = parent;
  }
  noSuchMethod(m) {
    return super.noSuchMethod(m);
  }
}
@proxy
class SpyPreBuiltObjects extends SpyObject implements PreBuiltObjects {
  SpyPreBuiltObjects() : super(PreBuiltObjects) {
    /* super call moved to initializer */;
  }
  noSuchMethod(m) {
    return super.noSuchMethod(m);
  }
}
@proxy
class SpyInjector extends SpyObject implements Injector {
  SpyInjector() : super(Injector) {
    /* super call moved to initializer */;
  }
  noSuchMethod(m) {
    return super.noSuchMethod(m);
  }
}
