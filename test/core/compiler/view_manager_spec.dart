library angular2.test.core.compiler.view_manager_spec;

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
        proxy;
import "package:angular2/di.dart" show Injector, bind;
import "package:angular2/src/core/compiler/view.dart"
    show AppProtoView, AppView, AppViewContainer, AppProtoViewMergeMapping;
import "package:angular2/src/core/compiler/view_ref.dart"
    show ProtoViewRef, ViewRef, internalView;
import "package:angular2/src/core/compiler/element_ref.dart" show ElementRef;
import "package:angular2/src/core/compiler/template_ref.dart" show TemplateRef;
import "package:angular2/src/render/api.dart"
    show
        Renderer,
        RenderViewRef,
        RenderProtoViewRef,
        RenderFragmentRef,
        ViewType,
        RenderProtoViewMergeMapping,
        RenderViewWithFragments;
import "package:angular2/src/core/compiler/view_manager.dart"
    show AppViewManager;
import "package:angular2/src/core/compiler/view_manager_utils.dart"
    show AppViewManagerUtils;
import "package:angular2/src/core/compiler/view_listener.dart"
    show AppViewListener;
import "package:angular2/src/core/compiler/view_pool.dart" show AppViewPool;
import "view_manager_utils_spec.dart"
    show
        createHostPv,
        createComponentPv,
        createEmbeddedPv,
        createEmptyElBinder,
        createNestedElBinder,
        createProtoElInjector;

main() {
  // TODO(tbosch): add missing tests
  describe("AppViewManager", () {
    var renderer;
    AppViewManagerUtils utils;
    var viewListener;
    var viewPool;
    AppViewManager manager;
    List<RenderViewWithFragments> createdRenderViews;
    ProtoViewRef wrapPv(AppProtoView protoView) {
      return new ProtoViewRef(protoView);
    }
    ViewRef wrapView(AppView view) {
      return new ViewRef(view);
    }
    resetSpies() {
      viewListener.spy("viewCreated").reset();
      viewListener.spy("viewDestroyed").reset();
      renderer.spy("createView").reset();
      renderer.spy("destroyView").reset();
      renderer.spy("createRootHostView").reset();
      renderer.spy("setEventDispatcher").reset();
      renderer.spy("hydrateView").reset();
      renderer.spy("dehydrateView").reset();
      viewPool.spy("returnView").reset();
    }
    beforeEach(() {
      renderer = new SpyRenderer();
      utils = new AppViewManagerUtils();
      viewListener = new SpyAppViewListener();
      viewPool = new SpyAppViewPool();
      manager = new AppViewManager(viewPool, viewListener, utils, renderer);
      createdRenderViews = [];
      renderer
          .spy("createRootHostView")
          .andCallFake((_a, renderFragmentCount, _b) {
        var fragments = [];
        for (var i = 0; i < renderFragmentCount; i++) {
          fragments.add(new RenderFragmentRef());
        }
        var rv = new RenderViewWithFragments(new RenderViewRef(), fragments);
        createdRenderViews.add(rv);
        return rv;
      });
      renderer.spy("createView").andCallFake((_a, renderFragmentCount) {
        var fragments = [];
        for (var i = 0; i < renderFragmentCount; i++) {
          fragments.add(new RenderFragmentRef());
        }
        var rv = new RenderViewWithFragments(new RenderViewRef(), fragments);
        createdRenderViews.add(rv);
        return rv;
      });
      viewPool.spy("returnView").andReturn(true);
    });
    describe("createRootHostView", () {
      AppProtoView hostProtoView;
      beforeEach(() {
        hostProtoView =
            createHostPv([createNestedElBinder(createComponentPv())]);
      });
      it("should create the view", () {
        var rootView = internalView((manager.createRootHostView(
            wrapPv(hostProtoView), null, null) as ViewRef));
        expect(rootView.proto).toBe(hostProtoView);
        expect(viewListener.spy("viewCreated")).toHaveBeenCalledWith(rootView);
      });
      it("should hydrate the view", () {
        var injector = Injector.resolveAndCreate([]);
        var rootView = internalView((manager.createRootHostView(
            wrapPv(hostProtoView), null, injector) as ViewRef));
        expect(rootView.hydrated()).toBe(true);
        expect(renderer.spy("hydrateView"))
            .toHaveBeenCalledWith(rootView.render);
      });
      it("should create and set the render view using the component selector",
          () {
        var rootView = internalView((manager.createRootHostView(
            wrapPv(hostProtoView), null, null) as ViewRef));
        expect(renderer.spy("createRootHostView")).toHaveBeenCalledWith(
            hostProtoView.mergeMapping.renderProtoViewRef,
            hostProtoView.mergeMapping.renderFragmentCount, "someComponent");
        expect(rootView.render).toBe(createdRenderViews[0].viewRef);
        expect(rootView.renderFragment)
            .toBe(createdRenderViews[0].fragmentRefs[0]);
      });
      it("should allow to override the selector", () {
        var selector = "someOtherSelector";
        internalView((manager.createRootHostView(
            wrapPv(hostProtoView), selector, null) as ViewRef));
        expect(renderer.spy("createRootHostView")).toHaveBeenCalledWith(
            hostProtoView.mergeMapping.renderProtoViewRef,
            hostProtoView.mergeMapping.renderFragmentCount, selector);
      });
      it("should set the event dispatcher", () {
        var rootView = internalView((manager.createRootHostView(
            wrapPv(hostProtoView), null, null) as ViewRef));
        expect(renderer.spy("setEventDispatcher")).toHaveBeenCalledWith(
            rootView.render, rootView);
      });
    });
    describe("destroyRootHostView", () {
      AppProtoView hostProtoView;
      AppView hostView;
      RenderViewRef hostRenderViewRef;
      beforeEach(() {
        hostProtoView =
            createHostPv([createNestedElBinder(createComponentPv())]);
        hostView = internalView((manager.createRootHostView(
            wrapPv(hostProtoView), null, null) as ViewRef));
        hostRenderViewRef = hostView.render;
      });
      it("should dehydrate", () {
        manager.destroyRootHostView(wrapView(hostView));
        expect(hostView.hydrated()).toBe(false);
        expect(renderer.spy("dehydrateView"))
            .toHaveBeenCalledWith(hostView.render);
      });
      it("should destroy the render view", () {
        manager.destroyRootHostView(wrapView(hostView));
        expect(renderer.spy("destroyView"))
            .toHaveBeenCalledWith(hostRenderViewRef);
        expect(viewListener.spy("viewDestroyed"))
            .toHaveBeenCalledWith(hostView);
      });
      it("should not return the view to the pool", () {
        manager.destroyRootHostView(wrapView(hostView));
        expect(viewPool.spy("returnView")).not.toHaveBeenCalled();
      });
    });
    describe("createViewInContainer", () {
      describe("basic functionality", () {
        AppView hostView;
        AppProtoView childProtoView;
        ElementRef vcRef;
        TemplateRef templateRef;
        beforeEach(() {
          childProtoView = createEmbeddedPv();
          var hostProtoView = createHostPv([
            createNestedElBinder(
                createComponentPv([createNestedElBinder(childProtoView)]))
          ]);
          hostView = internalView((manager.createRootHostView(
              wrapPv(hostProtoView), null, null) as ViewRef));
          vcRef = hostView.elementRefs[1];
          templateRef = new TemplateRef(hostView.elementRefs[1]);
          resetSpies();
        });
        describe("create the first view", () {
          it("should create an AppViewContainer if not yet existing", () {
            manager.createEmbeddedViewInContainer(vcRef, 0, templateRef);
            expect(hostView.viewContainers[1]).toBeTruthy();
          });
          it("should use an existing nested view", () {
            var childView = internalView(
                manager.createEmbeddedViewInContainer(vcRef, 0, templateRef));
            expect(childView.proto).toBe(childProtoView);
            expect(childView).toBe(hostView.views[2]);
            expect(viewListener.spy("viewCreated")).not.toHaveBeenCalled();
            expect(renderer.spy("createView")).not.toHaveBeenCalled();
          });
          it("should attach the fragment", () {
            var childView = internalView(
                manager.createEmbeddedViewInContainer(vcRef, 0, templateRef));
            expect(childView.proto).toBe(childProtoView);
            expect(hostView.viewContainers[1].views.length).toBe(1);
            expect(hostView.viewContainers[1].views[0]).toBe(childView);
            expect(renderer.spy("attachFragmentAfterElement"))
                .toHaveBeenCalledWith(vcRef, childView.renderFragment);
          });
          it("should hydrate the view but not the render view", () {
            var childView = internalView(
                manager.createEmbeddedViewInContainer(vcRef, 0, templateRef));
            expect(childView.hydrated()).toBe(true);
            expect(renderer.spy("hydrateView")).not.toHaveBeenCalled();
          });
          it("should not set the EventDispatcher", () {
            internalView(
                manager.createEmbeddedViewInContainer(vcRef, 0, templateRef));
            expect(renderer.spy("setEventDispatcher")).not.toHaveBeenCalled();
          });
        });
        describe("create the second view", () {
          var firstChildView;
          beforeEach(() {
            firstChildView = internalView(
                manager.createEmbeddedViewInContainer(vcRef, 0, templateRef));
            resetSpies();
          });
          it("should create a new view", () {
            var childView = internalView(
                manager.createEmbeddedViewInContainer(vcRef, 1, templateRef));
            expect(childView.proto).toBe(childProtoView);
            expect(childView).not.toBe(firstChildView);
            expect(viewListener.spy("viewCreated"))
                .toHaveBeenCalledWith(childView);
            expect(renderer.spy("createView")).toHaveBeenCalledWith(
                childProtoView.mergeMapping.renderProtoViewRef,
                childProtoView.mergeMapping.renderFragmentCount);
            expect(childView.render).toBe(createdRenderViews[1].viewRef);
            expect(childView.renderFragment)
                .toBe(createdRenderViews[1].fragmentRefs[0]);
          });
          it("should attach the fragment", () {
            var childView = internalView(
                manager.createEmbeddedViewInContainer(vcRef, 1, templateRef));
            expect(childView.proto).toBe(childProtoView);
            expect(hostView.viewContainers[1].views[1]).toBe(childView);
            expect(renderer.spy("attachFragmentAfterFragment"))
                .toHaveBeenCalledWith(
                    firstChildView.renderFragment, childView.renderFragment);
          });
          it("should hydrate the view", () {
            var childView = internalView(
                manager.createEmbeddedViewInContainer(vcRef, 1, templateRef));
            expect(childView.hydrated()).toBe(true);
            expect(renderer.spy("hydrateView"))
                .toHaveBeenCalledWith(childView.render);
          });
          it("should set the EventDispatcher", () {
            var childView = internalView(
                manager.createEmbeddedViewInContainer(vcRef, 1, templateRef));
            expect(renderer.spy("setEventDispatcher")).toHaveBeenCalledWith(
                childView.render, childView);
          });
        });
        describe("create another view when the first view has been returned",
            () {
          beforeEach(() {
            internalView(
                manager.createEmbeddedViewInContainer(vcRef, 0, templateRef));
            manager.destroyViewInContainer(vcRef, 0);
            resetSpies();
          });
          it("should use an existing nested view", () {
            var childView = internalView(
                manager.createEmbeddedViewInContainer(vcRef, 0, templateRef));
            expect(childView.proto).toBe(childProtoView);
            expect(childView).toBe(hostView.views[2]);
            expect(viewListener.spy("viewCreated")).not.toHaveBeenCalled();
            expect(renderer.spy("createView")).not.toHaveBeenCalled();
          });
        });
        describe("create a host view", () {
          it("should always create a new view and not use the embedded view",
              () {
            var newHostPv =
                createHostPv([createNestedElBinder(createComponentPv())]);
            var newHostView = internalView((manager.createHostViewInContainer(
                vcRef, 0, wrapPv(newHostPv), null) as ViewRef));
            expect(newHostView.proto).toBe(newHostPv);
            expect(newHostView).not.toBe(hostView.views[2]);
            expect(viewListener.spy("viewCreated"))
                .toHaveBeenCalledWith(newHostView);
            expect(renderer.spy("createView")).toHaveBeenCalledWith(
                newHostPv.mergeMapping.renderProtoViewRef,
                newHostPv.mergeMapping.renderFragmentCount);
          });
        });
      });
    });
    describe("destroyViewInContainer", () {
      describe("basic functionality", () {
        AppView hostView;
        AppProtoView childProtoView;
        ElementRef vcRef;
        TemplateRef templateRef;
        AppView firstChildView;
        beforeEach(() {
          childProtoView = createEmbeddedPv();
          var hostProtoView = createHostPv([
            createNestedElBinder(
                createComponentPv([createNestedElBinder(childProtoView)]))
          ]);
          hostView = internalView((manager.createRootHostView(
              wrapPv(hostProtoView), null, null) as ViewRef));
          vcRef = hostView.elementRefs[1];
          templateRef = new TemplateRef(hostView.elementRefs[1]);
          firstChildView = internalView(
              manager.createEmbeddedViewInContainer(vcRef, 0, templateRef));
          resetSpies();
        });
        describe("destroy the first view", () {
          it("should dehydrate the app view but not the render view", () {
            manager.destroyViewInContainer(vcRef, 0);
            expect(firstChildView.hydrated()).toBe(false);
            expect(renderer.spy("dehydrateView")).not.toHaveBeenCalled();
          });
          it("should detach", () {
            manager.destroyViewInContainer(vcRef, 0);
            expect(hostView.viewContainers[1].views).toEqual([]);
            expect(renderer.spy("detachFragment"))
                .toHaveBeenCalledWith(firstChildView.renderFragment);
          });
          it("should not return the view to the pool", () {
            manager.destroyViewInContainer(vcRef, 0);
            expect(viewPool.spy("returnView")).not.toHaveBeenCalled();
          });
        });
        describe("destroy another view", () {
          var secondChildView;
          beforeEach(() {
            secondChildView = internalView(
                manager.createEmbeddedViewInContainer(vcRef, 1, templateRef));
            resetSpies();
          });
          it("should dehydrate", () {
            manager.destroyViewInContainer(vcRef, 1);
            expect(secondChildView.hydrated()).toBe(false);
            expect(renderer.spy("dehydrateView"))
                .toHaveBeenCalledWith(secondChildView.render);
          });
          it("should detach", () {
            manager.destroyViewInContainer(vcRef, 1);
            expect(hostView.viewContainers[1].views[0]).toBe(firstChildView);
            expect(renderer.spy("detachFragment"))
                .toHaveBeenCalledWith(secondChildView.renderFragment);
          });
          it("should return the view to the pool", () {
            manager.destroyViewInContainer(vcRef, 1);
            expect(viewPool.spy("returnView"))
                .toHaveBeenCalledWith(secondChildView);
          });
        });
      });
      describe("recursively destroy views in ViewContainers", () {
        describe("destroy child views when a component is destroyed", () {
          AppView hostView;
          AppProtoView childProtoView;
          ElementRef vcRef;
          TemplateRef templateRef;
          AppView firstChildView;
          AppView secondChildView;
          beforeEach(() {
            childProtoView = createEmbeddedPv();
            var hostProtoView = createHostPv([
              createNestedElBinder(
                  createComponentPv([createNestedElBinder(childProtoView)]))
            ]);
            hostView = internalView((manager.createRootHostView(
                wrapPv(hostProtoView), null, null) as ViewRef));
            vcRef = hostView.elementRefs[1];
            templateRef = new TemplateRef(hostView.elementRefs[1]);
            firstChildView = internalView(
                manager.createEmbeddedViewInContainer(vcRef, 0, templateRef));
            secondChildView = internalView(
                manager.createEmbeddedViewInContainer(vcRef, 1, templateRef));
            resetSpies();
          });
          it("should dehydrate", () {
            manager.destroyRootHostView(wrapView(hostView));
            expect(firstChildView.hydrated()).toBe(false);
            expect(secondChildView.hydrated()).toBe(false);
            expect(renderer.spy("dehydrateView"))
                .toHaveBeenCalledWith(hostView.render);
            expect(renderer.spy("dehydrateView"))
                .toHaveBeenCalledWith(secondChildView.render);
          });
          it("should detach", () {
            manager.destroyRootHostView(wrapView(hostView));
            expect(hostView.viewContainers[1].views).toEqual([]);
            expect(renderer.spy("detachFragment"))
                .toHaveBeenCalledWith(firstChildView.renderFragment);
            expect(renderer.spy("detachFragment"))
                .toHaveBeenCalledWith(secondChildView.renderFragment);
          });
          it("should return the view to the pool", () {
            manager.destroyRootHostView(wrapView(hostView));
            expect(viewPool.spy("returnView")).not
                .toHaveBeenCalledWith(firstChildView);
            expect(viewPool.spy("returnView"))
                .toHaveBeenCalledWith(secondChildView);
          });
        });
        describe("destroy child views over multiple levels", () {
          AppView hostView;
          AppProtoView childProtoView;
          AppProtoView nestedChildProtoView;
          ElementRef vcRef;
          TemplateRef templateRef;
          List<ElementRef> nestedVcRefs;
          List<AppView> childViews;
          List<AppView> nestedChildViews;
          beforeEach(() {
            nestedChildProtoView = createEmbeddedPv();
            childProtoView = createEmbeddedPv([
              createNestedElBinder(createComponentPv(
                  [createNestedElBinder(nestedChildProtoView)]))
            ]);
            var hostProtoView = createHostPv([
              createNestedElBinder(
                  createComponentPv([createNestedElBinder(childProtoView)]))
            ]);
            hostView = internalView((manager.createRootHostView(
                wrapPv(hostProtoView), null, null) as ViewRef));
            vcRef = hostView.elementRefs[1];
            templateRef = new TemplateRef(hostView.elementRefs[1]);
            nestedChildViews = [];
            childViews = [];
            nestedVcRefs = [];
            for (var i = 0; i < 2; i++) {
              var view = internalView(
                  manager.createEmbeddedViewInContainer(vcRef, i, templateRef));
              childViews.add(view);
              var nestedVcRef = view.elementRefs[view.elementOffset];
              nestedVcRefs.add(nestedVcRef);
              for (var j = 0; j < 2; j++) {
                var nestedView = internalView(manager
                    .createEmbeddedViewInContainer(
                        nestedVcRef, j, templateRef));
                nestedChildViews.add(nestedView);
              }
            }
            resetSpies();
          });
          it("should dehydrate all child views", () {
            manager.destroyRootHostView(wrapView(hostView));
            childViews.forEach(
                (childView) => expect(childView.hydrated()).toBe(false));
            nestedChildViews.forEach(
                (childView) => expect(childView.hydrated()).toBe(false));
          });
        });
      });
    });
    describe("attachViewInContainer", () {});
    describe("detachViewInContainer", () {});
  });
}
@proxy()
class SpyRenderer extends SpyObject implements Renderer {
  SpyRenderer() : super(Renderer) {
    /* super call moved to initializer */;
  }
  noSuchMethod(m) {
    return super.noSuchMethod(m);
  }
}
@proxy()
class SpyAppViewPool extends SpyObject implements AppViewPool {
  SpyAppViewPool() : super(AppViewPool) {
    /* super call moved to initializer */;
  }
  noSuchMethod(m) {
    return super.noSuchMethod(m);
  }
}
@proxy()
class SpyAppViewListener extends SpyObject implements AppViewListener {
  SpyAppViewListener() : super(AppViewListener) {
    /* super call moved to initializer */;
  }
  noSuchMethod(m) {
    return super.noSuchMethod(m);
  }
}
