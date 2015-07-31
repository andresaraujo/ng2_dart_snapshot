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
    show AppView, AppViewContainer;
import "package:angular2/src/core/compiler/view_container_ref.dart"
    show ViewContainerRef;
import "package:angular2/src/core/compiler/view_manager.dart"
    show AppViewManager;
import "package:angular2/src/core/compiler/element_ref.dart" show ElementRef;
import "package:angular2/src/core/compiler/view_ref.dart" show ViewRef;

main() {
  // TODO(tbosch): add missing tests
  describe("ViewContainerRef", () {
    var location;
    var view;
    var viewManager;
    createViewContainer() {
      return new ViewContainerRef(viewManager, location);
    }
    beforeEach(() {
      viewManager = new AppViewManagerSpy();
      view = new AppViewSpy();
      location = new ElementRef(new ViewRef(view), 0, 0, null);
    });
    describe("length", () {
      it("should return a 0 length if there is no underlying AppViewContainer",
          () {
        var vc = createViewContainer();
        expect(vc.length).toBe(0);
      });
      it("should return the size of the underlying AppViewContainer", () {
        var vc = createViewContainer();
        var appVc = new AppViewContainer();
        view.viewContainers = [appVc];
        appVc.views = [(new AppViewSpy() as dynamic)];
        expect(vc.length).toBe(1);
      });
    });
  });
}
@proxy()
class AppViewSpy extends SpyObject implements AppView {
  List<AppViewContainer> viewContainers = [null];
  AppViewSpy() : super(AppView) {
    /* super call moved to initializer */;
  }
  noSuchMethod(m) {
    return super.noSuchMethod(m);
  }
}
@proxy()
class AppViewManagerSpy extends SpyObject implements AppViewManager {
  AppViewManagerSpy() : super(AppViewManager) {
    /* super call moved to initializer */;
  }
  noSuchMethod(m) {
    return super.noSuchMethod(m);
  }
}
