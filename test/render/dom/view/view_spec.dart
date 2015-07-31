library angular2.test.render.dom.view.view_spec;

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
import "package:angular2/src/facade/lang.dart" show isBlank;
import "package:angular2/src/facade/collection.dart" show ListWrapper;
import "package:angular2/src/render/dom/view/proto_view.dart" show DomProtoView;
import "package:angular2/src/render/dom/view/element_binder.dart"
    show DomElementBinder;
import "package:angular2/src/render/dom/view/view.dart" show DomView;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/render/dom/template_cloner.dart"
    show TemplateCloner;

main() {
  describe("DomView", () {
    createProtoView([binders = null]) {
      if (isBlank(binders)) {
        binders = [];
      }
      var rootEl = DOM.createTemplate("<div></div>");
      return DomProtoView.create(new TemplateCloner(-1), null,
          (rootEl as dynamic), null, [1], [], binders, null);
    }
    createElementBinder() {
      return new DomElementBinder(textNodeIndices: []);
    }
    createView([pv = null, boundElementCount = 0]) {
      if (isBlank(pv)) {
        var elementBinders = ListWrapper.createFixedSize(boundElementCount);
        for (var i = 0; i < boundElementCount; i++) {
          elementBinders[i] = createElementBinder();
        }
        pv = createProtoView(elementBinders);
      }
      var root = el("<div><div></div></div>");
      var boundElements = [];
      for (var i = 0; i < boundElementCount; i++) {
        boundElements.add(el("<span></span"));
      }
      return new DomView(pv, [DOM.childNodes(root)[0]], boundElements);
    }
    describe("setElementProperty", () {
      var el, view;
      beforeEach(() {
        view = createView(null, 1);
        el = view.boundElements[0];
      });
      it("should update the property value", () {
        view.setElementProperty(0, "title", "Hello");
        expect(el.title).toEqual("Hello");
      });
    });
    describe("setElementAttribute", () {
      var el, view;
      beforeEach(() {
        view = createView(null, 1);
        el = view.boundElements[0];
      });
      it("should update and remove an attribute", () {
        view.setElementAttribute(0, "role", "button");
        expect(DOM.getAttribute(el, "role")).toEqual("button");
        view.setElementAttribute(0, "role", null);
        expect(DOM.getAttribute(el, "role")).toEqual(null);
      });
      it("should de-normalize attribute names", () {
        view.setElementAttribute(0, "ariaLabel", "fancy button");
        expect(DOM.getAttribute(el, "aria-label")).toEqual("fancy button");
      });
    });
    describe("setElementClass", () {
      var el, view;
      beforeEach(() {
        view = createView(null, 1);
        el = view.boundElements[0];
      });
      it("should set and remove a class", () {
        view.setElementClass(0, "active", true);
        expect(DOM.hasClass(el, "active")).toEqual(true);
        view.setElementClass(0, "active", false);
        expect(DOM.hasClass(el, "active")).toEqual(false);
      });
      it("should not de-normalize class names", () {
        view.setElementClass(0, "veryActive", true);
        view.setElementClass(0, "very-active", true);
        expect(DOM.hasClass(el, "veryActive")).toEqual(true);
        expect(DOM.hasClass(el, "very-active")).toEqual(true);
        view.setElementClass(0, "veryActive", false);
        view.setElementClass(0, "very-active", false);
        expect(DOM.hasClass(el, "veryActive")).toEqual(false);
        expect(DOM.hasClass(el, "very-active")).toEqual(false);
      });
    });
    describe("setElementStyle", () {
      var el, view;
      beforeEach(() {
        view = createView(null, 1);
        el = view.boundElements[0];
      });
      it("should set and remove styles", () {
        view.setElementStyle(0, "width", "40px");
        expect(DOM.getStyle(el, "width")).toEqual("40px");
        view.setElementStyle(0, "width", null);
        expect(DOM.getStyle(el, "width")).toEqual("");
      });
      it("should de-normalize style names", () {
        view.setElementStyle(0, "textAlign", "right");
        expect(DOM.getStyle(el, "text-align")).toEqual("right");
        view.setElementStyle(0, "textAlign", null);
        expect(DOM.getStyle(el, "text-align")).toEqual("");
      });
    });
  });
}
