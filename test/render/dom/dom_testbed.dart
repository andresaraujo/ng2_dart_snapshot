library angular2.test.render.dom.dom_testbed;

import "package:angular2/di.dart" show Inject, Injectable;
import "package:angular2/src/facade/collection.dart"
    show MapWrapper, ListWrapper, List, Map;
import "package:angular2/src/facade/async.dart" show PromiseWrapper, Future;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/render/dom/dom_renderer.dart"
    show DomRenderer, DOCUMENT_TOKEN;
import "package:angular2/src/render/dom/compiler/compiler.dart"
    show DefaultDomCompiler;
import "package:angular2/src/render/dom/view/view.dart" show DomView;
import "package:angular2/src/render/api.dart"
    show
        RenderViewRef,
        ProtoViewDto,
        ViewDefinition,
        EventDispatcher,
        DirectiveMetadata,
        RenderElementRef;
import "package:angular2/src/render/dom/view/view.dart"
    show resolveInternalDomView;
import "package:angular2/test_lib.dart" show el, dispatchEvent;

class TestView {
  DomView rawView;
  RenderViewRef viewRef;
  List<List<dynamic>> events;
  TestView(RenderViewRef viewRef) {
    this.viewRef = viewRef;
    this.rawView = resolveInternalDomView(viewRef);
    this.events = [];
  }
}
elRef(RenderViewRef renderView, num boundElementIndex) {
  return new TestRenderElementRef(renderView, boundElementIndex);
}
class TestRenderElementRef implements RenderElementRef {
  RenderViewRef renderView;
  num boundElementIndex;
  TestRenderElementRef(this.renderView, this.boundElementIndex) {}
}
class LoggingEventDispatcher implements EventDispatcher {
  List<List<dynamic>> log;
  LoggingEventDispatcher(List<List<dynamic>> log) {
    this.log = log;
  }
  dispatchEvent(
      num elementIndex, String eventName, Map<String, dynamic> locals) {
    this.log.add([elementIndex, eventName, locals]);
    return true;
  }
}
@Injectable()
class DomTestbed {
  DomRenderer renderer;
  DefaultDomCompiler compiler;
  var rootEl;
  DomTestbed(DomRenderer renderer, DefaultDomCompiler compiler,
      @Inject(DOCUMENT_TOKEN) document) {
    this.renderer = renderer;
    this.compiler = compiler;
    this.rootEl = el("<div id=\"root\"></div>");
    var oldRoots = DOM.querySelectorAll(document, "#root");
    for (var i = 0; i < oldRoots.length; i++) {
      DOM.remove(oldRoots[i]);
    }
    DOM.appendChild(DOM.querySelector(document, "body"), this.rootEl);
  }
  Future<List<ProtoViewDto>> compileAll(
      List<dynamic /* DirectiveMetadata | ViewDefinition */ > directivesOrViewDefinitions) {
    return PromiseWrapper.all(ListWrapper.map(directivesOrViewDefinitions,
        (entry) {
      if (entry is DirectiveMetadata) {
        return this.compiler.compileHost(entry);
      } else {
        return this.compiler.compile(entry);
      }
    }));
  }
  _createTestView(RenderViewRef viewRef) {
    var testView = new TestView(viewRef);
    this.renderer.setEventDispatcher(
        viewRef, new LoggingEventDispatcher(testView.events));
    return testView;
  }
  TestView createRootView(ProtoViewDto rootProtoView) {
    var viewRef =
        this.renderer.createRootHostView(rootProtoView.render, "#root");
    this.renderer.hydrateView(viewRef);
    return this._createTestView(viewRef);
  }
  TestView createComponentView(RenderViewRef parentViewRef,
      num boundElementIndex, ProtoViewDto componentProtoView) {
    var componentViewRef = this.renderer.createView(componentProtoView.render);
    this.renderer.attachComponentView(
        elRef(parentViewRef, boundElementIndex), componentViewRef);
    this.renderer.hydrateView(componentViewRef);
    return this._createTestView(componentViewRef);
  }
  List<TestView> createRootViews(List<ProtoViewDto> protoViews) {
    var views = [];
    var lastView = this.createRootView(protoViews[0]);
    views.add(lastView);
    for (var i = 1; i < protoViews.length; i++) {
      lastView = this.createComponentView(lastView.viewRef, 0, protoViews[i]);
      views.add(lastView);
    }
    return views;
  }
  destroyComponentView(RenderViewRef parentViewRef, num boundElementIndex,
      RenderViewRef componentView) {
    this.renderer.dehydrateView(componentView);
    this.renderer.detachComponentView(
        elRef(parentViewRef, boundElementIndex), componentView);
  }
  TestView createViewInContainer(RenderViewRef parentViewRef,
      num boundElementIndex, num atIndex, ProtoViewDto protoView) {
    var viewRef = this.renderer.createView(protoView.render);
    this.renderer.attachViewInContainer(
        elRef(parentViewRef, boundElementIndex), atIndex, viewRef);
    this.renderer.hydrateView(viewRef);
    return this._createTestView(viewRef);
  }
  destroyViewInContainer(RenderViewRef parentViewRef, num boundElementIndex,
      num atIndex, RenderViewRef viewRef) {
    this.renderer.dehydrateView(viewRef);
    this.renderer.detachViewInContainer(
        elRef(parentViewRef, boundElementIndex), atIndex, viewRef);
    this.renderer.destroyView(viewRef);
  }
  triggerEvent(RenderViewRef viewRef, num boundElementIndex, String eventName) {
    var element = resolveInternalDomView(viewRef).boundElements[
        boundElementIndex].element;
    dispatchEvent(element, eventName);
  }
}
