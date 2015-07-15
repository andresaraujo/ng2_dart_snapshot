library angular2.test.core.compiler.view_container_ref_spec;

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
import "package:angular2/src/core/compiler/view.dart"
    show AppView, AppProtoView, AppViewContainer;
import "package:angular2/src/core/compiler/view_container_ref.dart"
    show ViewContainerRef;
import "package:angular2/src/core/compiler/view_manager.dart"
    show AppViewManager;
import "package:angular2/src/core/compiler/element_binder.dart"
    show ElementBinder;

main() {
  // TODO(tbosch): add missing tests
  describe("ViewContainerRef", () {
    var location;
    var view;
    var viewManager;
    createProtoView() {
      var pv = new AppProtoView(null, null, null, null);
      pv.elementBinders = [new ElementBinder(0, null, 0, null, null)];
      return pv;
    }
    createView() {
      return new AppView(null, createProtoView(), new Map());
    }
    createViewContainer() {
      return new ViewContainerRef(viewManager, location);
    }
    beforeEach(() {
      viewManager = new AppViewManagerSpy();
      view = createView();
      view.viewContainers = [null];
      location = view.elementRefs[0];
    });
    describe("length", () {
      it("should return a 0 length if there is no underlying ViewContainerRef",
          () {
        var vc = createViewContainer();
        expect(vc.length).toBe(0);
      });
      it("should return the size of the underlying ViewContainerRef", () {
        var vc = createViewContainer();
        view.viewContainers = [new AppViewContainer()];
        view.viewContainers[0].views = [createView()];
        expect(vc.length).toBe(1);
      });
    });
  });
}
@proxy
class AppViewManagerSpy extends SpyObject implements AppViewManager {
  AppViewManagerSpy() : super(AppViewManager) {
    /* super call moved to initializer */;
  }
  noSuchMethod(m) {
    return super.noSuchMethod(m);
  }
}
