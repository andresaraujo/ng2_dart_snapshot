library angular2.test.render.dom.dom_testbed;

import "package:angular2/di.dart" show Inject, Injectable;
import "package:angular2/src/facade/lang.dart" show isPresent;
import "package:angular2/src/facade/collection.dart"
    show MapWrapper, ListWrapper, List, Map;
import "package:angular2/src/facade/async.dart" show PromiseWrapper, Future;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/render/dom/dom_renderer.dart" show DomRenderer;
import "package:angular2/src/render/dom/dom_tokens.dart" show DOCUMENT_TOKEN;
import "package:angular2/src/render/dom/compiler/compiler.dart"
    show DefaultDomCompiler;
import "package:angular2/src/render/api.dart"
    show
        RenderViewWithFragments,
        RenderFragmentRef,
        RenderViewRef,
        ProtoViewDto,
        ViewDefinition,
        RenderEventDispatcher,
        DirectiveMetadata,
        RenderElementRef,
        RenderProtoViewMergeMapping,
        RenderProtoViewRef;
import "package:angular2/src/render/dom/view/view.dart"
    show resolveInternalDomView;
import "package:angular2/src/render/dom/view/fragment.dart"
    show resolveInternalDomFragment;
import "package:angular2/test_lib.dart" show el, dispatchEvent;

class TestRootView {
  RenderViewRef viewRef;
  List<RenderFragmentRef> fragments;
  dynamic hostElement;
  List<List<dynamic>> events;
  TestRootView(RenderViewWithFragments viewWithFragments) {
    this.viewRef = viewWithFragments.viewRef;
    this.fragments = viewWithFragments.fragmentRefs;
    this.hostElement =
        (resolveInternalDomFragment(this.fragments[0])[0] as dynamic);
    this.events = [];
  }
}
class TestRenderElementRef implements RenderElementRef {
  RenderViewRef renderView;
  num renderBoundElementIndex;
  TestRenderElementRef(this.renderView, this.renderBoundElementIndex) {}
}
elRef(RenderViewRef renderView, num boundElementIndex) {
  return new TestRenderElementRef(renderView, boundElementIndex);
}
rootNodes(RenderViewRef view) {}
class LoggingEventDispatcher implements RenderEventDispatcher {
  List<List<dynamic>> log;
  LoggingEventDispatcher(List<List<dynamic>> log) {
    this.log = log;
  }
  dispatchRenderEvent(
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
    this.rootEl = el("<div id=\"root\" class=\"rootElem\"></div>");
    var oldRoots = DOM.querySelectorAll(document, "#root");
    for (var i = 0; i < oldRoots.length; i++) {
      DOM.remove(oldRoots[i]);
    }
    DOM.appendChild(DOM.querySelector(document, "body"), this.rootEl);
  }
  Future<List<ProtoViewDto>> compile(
      DirectiveMetadata host, List<ViewDefinition> componentViews) {
    var promises = [this.compiler.compileHost(host)];
    componentViews.forEach((view) => promises.add(this.compiler.compile(view)));
    return PromiseWrapper.all(promises);
  }
  Future<RenderProtoViewMergeMapping> merge(
      List<dynamic /* ProtoViewDto | RenderProtoViewRef */ > protoViews) {
    return this.compiler.mergeProtoViewsRecursively(
        collectMergeRenderProtoViewsRecurse(
            (protoViews[0] as ProtoViewDto), ListWrapper.slice(protoViews, 1)));
  }
  Future<RenderProtoViewMergeMapping> compileAndMerge(
      DirectiveMetadata host, List<ViewDefinition> componentViews) {
    return this
        .compile(host, componentViews)
        .then((protoViewDtos) => this.merge(protoViewDtos));
  }
  _createTestView(RenderViewWithFragments viewWithFragments) {
    var testView = new TestRootView(viewWithFragments);
    this.renderer.setEventDispatcher(
        viewWithFragments.viewRef, new LoggingEventDispatcher(testView.events));
    return testView;
  }
  TestRootView createView(RenderProtoViewMergeMapping protoView) {
    var viewWithFragments =
        this.renderer.createView(protoView.mergedProtoViewRef, 0);
    this.renderer.hydrateView(viewWithFragments.viewRef);
    return this._createTestView(viewWithFragments);
  }
  triggerEvent(RenderElementRef elementRef, String eventName) {
    var element = resolveInternalDomView(elementRef.renderView).boundElements[
        elementRef.renderBoundElementIndex];
    dispatchEvent(element, eventName);
  }
}
List<dynamic /* RenderProtoViewRef | List < dynamic > */ > collectMergeRenderProtoViewsRecurse(
    ProtoViewDto current,
    List<dynamic /* ProtoViewDto | RenderProtoViewRef */ > components) {
  var result = [current.render];
  current.elementBinders.forEach((elementBinder) {
    if (isPresent(elementBinder.nestedProtoView)) {
      result.add(collectMergeRenderProtoViewsRecurse(
          elementBinder.nestedProtoView, components));
    } else if (elementBinder.directives.length > 0) {
      if (components.length > 0) {
        var comp = components.removeAt(0);
        if (comp is ProtoViewDto) {
          result.add(collectMergeRenderProtoViewsRecurse(comp, components));
        } else {
          result.add(comp);
        }
      } else {
        result.add(null);
      }
    }
  });
  return result;
}
