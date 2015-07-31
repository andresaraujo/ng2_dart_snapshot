library angular2.test.web_workers.shared.render_view_with_fragments_store_spec;

import "package:angular2/test_lib.dart"
    show AsyncTestCompleter, beforeEach, inject, describe, it, expect;
import "package:angular2/src/render/api.dart"
    show RenderViewWithFragments, RenderViewRef, RenderFragmentRef;
import "package:angular2/src/web-workers/shared/render_view_with_fragments_store.dart"
    show
        RenderViewWithFragmentsStore,
        WorkerRenderViewRef,
        WorkerRenderFragmentRef;
import "package:angular2/src/facade/collection.dart" show List, ListWrapper;

main() {
  describe("RenderViewWithFragmentsStore", () {
    describe("on WebWorker", () {
      var store;
      beforeEach(() {
        store = new RenderViewWithFragmentsStore(true);
      });
      it("should allocate fragmentCount + 1 refs", () {
        RenderViewWithFragments view = store.allocate(10);
        WorkerRenderViewRef viewRef = (view.viewRef as WorkerRenderViewRef);
        expect(viewRef.refNumber).toEqual(0);
        List<WorkerRenderFragmentRef> fragmentRefs =
            (view.fragmentRefs as List<WorkerRenderFragmentRef>);
        expect(fragmentRefs.length).toEqual(10);
        for (var i = 0; i < fragmentRefs.length; i++) {
          expect(fragmentRefs[i].refNumber).toEqual(i + 1);
        }
      });
      it("should not reuse a reference", () {
        store.allocate(10);
        var view = store.allocate(0);
        var viewRef = (view.viewRef as WorkerRenderViewRef);
        expect(viewRef.refNumber).toEqual(11);
      });
      it("should be serializable", () {
        var view = store.allocate(1);
        expect(store.deserializeViewWithFragments(
            store.serializeViewWithFragments(view))).toEqual(view);
      });
    });
    describe("on UI", () {
      var store;
      beforeEach(() {
        store = new RenderViewWithFragmentsStore(false);
      });
      RenderViewWithFragments createMockRenderViewWithFragments() {
        var view = new MockRenderViewRef();
        var fragments = ListWrapper.createGrowableSize(20);
        for (var i = 0; i < 20; i++) {
          fragments[i] = new MockRenderFragmentRef();
        }
        return new RenderViewWithFragments(view, fragments);
      }
      it("should associate views with the correct references", () {
        var renderViewWithFragments = createMockRenderViewWithFragments();
        store.store(renderViewWithFragments, 100);
        expect(store.retreive(100)).toBe(renderViewWithFragments.viewRef);
        for (var i = 0; i < renderViewWithFragments.fragmentRefs.length; i++) {
          expect(store.retreive(101 + i))
              .toBe(renderViewWithFragments.fragmentRefs[i]);
        }
      });
      describe("RenderViewWithFragments", () {
        it("should be serializable", () {
          var renderViewWithFragments = createMockRenderViewWithFragments();
          store.store(renderViewWithFragments, 0);
          var deserialized = store.deserializeViewWithFragments(
              store.serializeViewWithFragments(renderViewWithFragments));
          expect(deserialized.viewRef).toBe(renderViewWithFragments.viewRef);
          expect(deserialized.fragmentRefs.length)
              .toEqual(renderViewWithFragments.fragmentRefs.length);
          for (var i = 0; i < deserialized.fragmentRefs.length; i++) {
            var val = deserialized.fragmentRefs[i];
            expect(val).toBe(renderViewWithFragments.fragmentRefs[i]);
          }
          ;
        });
      });
      describe("RenderViewRef", () {
        it("should be serializable", () {
          var renderViewWithFragments = createMockRenderViewWithFragments();
          store.store(renderViewWithFragments, 0);
          var deserialized = store.deserializeRenderViewRef(
              store.serializeRenderViewRef(renderViewWithFragments.viewRef));
          expect(deserialized).toBe(renderViewWithFragments.viewRef);
        });
      });
      describe("RenderFragmentRef", () {
        it("should be serializable", () {
          var renderViewWithFragments = createMockRenderViewWithFragments();
          store.store(renderViewWithFragments, 0);
          var serialized = store.serializeRenderFragmentRef(
              renderViewWithFragments.fragmentRefs[0]);
          var deserialized = store.deserializeRenderFragmentRef(serialized);
          expect(deserialized).toBe(renderViewWithFragments.fragmentRefs[0]);
        });
      });
    });
  });
}
class MockRenderViewRef extends RenderViewRef {
  MockRenderViewRef() : super() {
    /* super call moved to initializer */;
  }
}
class MockRenderFragmentRef extends RenderFragmentRef {
  MockRenderFragmentRef() : super() {
    /* super call moved to initializer */;
  }
}
