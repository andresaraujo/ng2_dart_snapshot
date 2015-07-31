library angular2.src.core.compiler.view_manager_utils;

import "package:angular2/di.dart"
    show Injector, Binding, Injectable, ResolvedBinding;
import "package:angular2/src/facade/collection.dart"
    show ListWrapper, MapWrapper, Map, StringMapWrapper, List;
import "element_injector.dart" as eli;
import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, BaseException;
import "view.dart" as viewModule;
import "view_ref.dart" show internalView;
import "view_manager.dart" as avmModule;
import "element_ref.dart" show ElementRef;
import "template_ref.dart" show TemplateRef;
import "package:angular2/src/render/api.dart"
    show Renderer, RenderViewWithFragments;
import "package:angular2/src/change_detection/change_detection.dart"
    show Locals;
import "package:angular2/src/render/api.dart"
    show RenderViewRef, RenderFragmentRef, ViewType;

@Injectable()
class AppViewManagerUtils {
  AppViewManagerUtils() {}
  dynamic getComponentInstance(
      viewModule.AppView parentView, num boundElementIndex) {
    var eli = parentView.elementInjectors[boundElementIndex];
    return eli.getComponent();
  }
  viewModule.AppView createView(viewModule.AppProtoView mergedParentViewProto,
      RenderViewWithFragments renderViewWithFragments,
      avmModule.AppViewManager viewManager, Renderer renderer) {
    var renderFragments = renderViewWithFragments.fragmentRefs;
    var renderView = renderViewWithFragments.viewRef;
    var elementCount =
        mergedParentViewProto.mergeMapping.renderElementIndices.length;
    var viewCount =
        mergedParentViewProto.mergeMapping.nestedViewCountByViewIndex[0] + 1;
    List<ElementRef> elementRefs = ListWrapper.createFixedSize(elementCount);
    var viewContainers = ListWrapper.createFixedSize(elementCount);
    List<eli.PreBuiltObjects> preBuiltObjects =
        ListWrapper.createFixedSize(elementCount);
    var elementInjectors = ListWrapper.createFixedSize(elementCount);
    var views = ListWrapper.createFixedSize(viewCount);
    var elementOffset = 0;
    var textOffset = 0;
    var fragmentIdx = 0;
    for (var viewOffset = 0; viewOffset < viewCount; viewOffset++) {
      var hostElementIndex =
          mergedParentViewProto.mergeMapping.hostElementIndicesByViewIndex[
          viewOffset];
      var parentView = isPresent(hostElementIndex)
          ? internalView(elementRefs[hostElementIndex].parentView)
          : null;
      var protoView = isPresent(hostElementIndex)
          ? parentView.proto.elementBinders[
              hostElementIndex - parentView.elementOffset].nestedProtoView
          : mergedParentViewProto;
      var renderFragment = null;
      if (identical(viewOffset, 0) ||
          identical(protoView.type, ViewType.EMBEDDED)) {
        renderFragment = renderFragments[fragmentIdx++];
      }
      var currentView = new viewModule.AppView(renderer, protoView,
          mergedParentViewProto.mergeMapping, viewOffset, elementOffset,
          textOffset, protoView.protoLocals, renderView, renderFragment);
      views[viewOffset] = currentView;
      var rootElementInjectors = [];
      for (var binderIdx = 0;
          binderIdx < protoView.elementBinders.length;
          binderIdx++) {
        var binder = protoView.elementBinders[binderIdx];
        var boundElementIndex = elementOffset + binderIdx;
        var elementInjector = null;
        // elementInjectors and rootElementInjectors
        var protoElementInjector = binder.protoElementInjector;
        if (isPresent(protoElementInjector)) {
          if (isPresent(protoElementInjector.parent)) {
            var parentElementInjector = elementInjectors[
                elementOffset + protoElementInjector.parent.index];
            elementInjector =
                protoElementInjector.instantiate(parentElementInjector);
          } else {
            elementInjector = protoElementInjector.instantiate(null);
            rootElementInjectors.add(elementInjector);
          }
        }
        elementInjectors[boundElementIndex] = elementInjector;
        // elementRefs
        var el = new ElementRef(currentView.ref, boundElementIndex,
            mergedParentViewProto.mergeMapping.renderElementIndices[
            boundElementIndex], renderer);
        elementRefs[el.boundElementIndex] = el;
        // preBuiltObjects
        if (isPresent(elementInjector)) {
          var templateRef =
              binder.hasEmbeddedProtoView() ? new TemplateRef(el) : null;
          preBuiltObjects[boundElementIndex] = new eli.PreBuiltObjects(
              viewManager, currentView, el, templateRef);
        }
      }
      currentView.init(protoView.protoChangeDetector.instantiate(currentView),
          elementInjectors, rootElementInjectors, preBuiltObjects, views,
          elementRefs, viewContainers);
      if (isPresent(parentView) &&
          identical(protoView.type, ViewType.COMPONENT)) {
        parentView.changeDetector.addShadowDomChild(currentView.changeDetector);
      }
      elementOffset += protoView.elementBinders.length;
      textOffset += protoView.textBindingCount;
    }
    return views[0];
  }
  hydrateRootHostView(viewModule.AppView hostView, Injector injector) {
    this._hydrateView(hostView, injector, null, new Object(), null);
  }
  // Misnomer: this method is attaching next to the view container.
  attachViewInContainer(viewModule.AppView parentView, num boundElementIndex,
      viewModule.AppView contextView, num contextBoundElementIndex, num atIndex,
      viewModule.AppView view) {
    if (isBlank(contextView)) {
      contextView = parentView;
      contextBoundElementIndex = boundElementIndex;
    }
    parentView.changeDetector.addChild(view.changeDetector);
    var viewContainer = parentView.viewContainers[boundElementIndex];
    if (isBlank(viewContainer)) {
      viewContainer = new viewModule.AppViewContainer();
      parentView.viewContainers[boundElementIndex] = viewContainer;
    }
    ListWrapper.insert(viewContainer.views, atIndex, view);
    var sibling;
    if (atIndex == 0) {
      sibling = null;
    } else {
      sibling = ListWrapper
          .last(viewContainer.views[atIndex - 1].rootElementInjectors);
    }
    var elementInjector =
        contextView.elementInjectors[contextBoundElementIndex];
    for (var i = view.rootElementInjectors.length - 1; i >= 0; i--) {
      if (isPresent(elementInjector.parent)) {
        view.rootElementInjectors[i].linkAfter(elementInjector.parent, sibling);
      } else {
        contextView.rootElementInjectors.add(view.rootElementInjectors[i]);
      }
    }
  }
  detachViewInContainer(
      viewModule.AppView parentView, num boundElementIndex, num atIndex) {
    var viewContainer = parentView.viewContainers[boundElementIndex];
    var view = viewContainer.views[atIndex];
    view.changeDetector.remove();
    ListWrapper.removeAt(viewContainer.views, atIndex);
    for (var i = 0; i < view.rootElementInjectors.length; ++i) {
      var inj = view.rootElementInjectors[i];
      if (isPresent(inj.parent)) {
        inj.unlink();
      } else {
        var removeIdx =
            ListWrapper.indexOf(parentView.rootElementInjectors, inj);
        if (removeIdx >= 0) {
          ListWrapper.removeAt(parentView.rootElementInjectors, removeIdx);
        }
      }
    }
  }
  hydrateViewInContainer(viewModule.AppView parentView, num boundElementIndex,
      viewModule.AppView contextView, num contextBoundElementIndex, num atIndex,
      List<ResolvedBinding> imperativelyCreatedBindings) {
    if (isBlank(contextView)) {
      contextView = parentView;
      contextBoundElementIndex = boundElementIndex;
    }
    var viewContainer = parentView.viewContainers[boundElementIndex];
    var view = viewContainer.views[atIndex];
    var elementInjector =
        contextView.elementInjectors[contextBoundElementIndex];
    var injector = isPresent(imperativelyCreatedBindings)
        ? Injector.fromResolvedBindings(imperativelyCreatedBindings)
        : null;
    this._hydrateView(view, injector, elementInjector.getHost(),
        contextView.context, contextView.locals);
  }
  _hydrateView(viewModule.AppView initView,
      Injector imperativelyCreatedInjector,
      eli.ElementInjector hostElementInjector, Object context,
      Locals parentLocals) {
    var viewIdx = initView.viewOffset;
    var endViewOffset =
        viewIdx + initView.mainMergeMapping.nestedViewCountByViewIndex[viewIdx];
    while (viewIdx <= endViewOffset) {
      var currView = initView.views[viewIdx];
      var currProtoView = currView.proto;
      if (!identical(currView, initView) &&
          identical(currView.proto.type, ViewType.EMBEDDED)) {
        // Don't hydrate components of embedded fragment views.
        viewIdx +=
            initView.mainMergeMapping.nestedViewCountByViewIndex[viewIdx] + 1;
      } else {
        if (!identical(currView, initView)) {
          // hydrate a nested component view
          imperativelyCreatedInjector = null;
          parentLocals = null;
          var hostElementIndex =
              initView.mainMergeMapping.hostElementIndicesByViewIndex[viewIdx];
          hostElementInjector = initView.elementInjectors[hostElementIndex];
          context = hostElementInjector.getComponent();
        }
        currView.context = context;
        currView.locals.parent = parentLocals;
        var binders = currProtoView.elementBinders;
        for (var binderIdx = 0; binderIdx < binders.length; binderIdx++) {
          var boundElementIndex = binderIdx + currView.elementOffset;
          var elementInjector = initView.elementInjectors[boundElementIndex];
          if (isPresent(elementInjector)) {
            elementInjector.hydrate(imperativelyCreatedInjector,
                hostElementInjector,
                currView.preBuiltObjects[boundElementIndex]);
            this._populateViewLocals(
                currView, elementInjector, boundElementIndex);
            this._setUpEventEmitters(
                currView, elementInjector, boundElementIndex);
            this._setUpHostActions(
                currView, elementInjector, boundElementIndex);
          }
        }
        var pipes =
            this._getPipes(imperativelyCreatedInjector, hostElementInjector);
        currView.changeDetector.hydrate(
            currView.context, currView.locals, currView, pipes);
        viewIdx++;
      }
    }
  }
  _getPipes(Injector imperativelyCreatedInjector,
      eli.ElementInjector hostElementInjector) {
    var pipesKey = eli.StaticKeys.instance().pipesKey;
    if (isPresent(
        imperativelyCreatedInjector)) return imperativelyCreatedInjector
        .getOptional(pipesKey);
    if (isPresent(hostElementInjector)) return hostElementInjector.getPipes();
    return null;
  }
  void _populateViewLocals(viewModule.AppView view,
      eli.ElementInjector elementInjector, num boundElementIdx) {
    if (isPresent(elementInjector.getDirectiveVariableBindings())) {
      MapWrapper.forEach(elementInjector.getDirectiveVariableBindings(),
          (directiveIndex, name) {
        if (isBlank(directiveIndex)) {
          view.locals.set(
              name, view.elementRefs[boundElementIdx].nativeElement);
        } else {
          view.locals.set(
              name, elementInjector.getDirectiveAtIndex(directiveIndex));
        }
      });
    }
  }
  _setUpEventEmitters(viewModule.AppView view,
      eli.ElementInjector elementInjector, num boundElementIndex) {
    var emitters = elementInjector.getEventEmitterAccessors();
    for (var directiveIndex = 0;
        directiveIndex < emitters.length;
        ++directiveIndex) {
      var directiveEmitters = emitters[directiveIndex];
      var directive = elementInjector.getDirectiveAtIndex(directiveIndex);
      for (var eventIndex = 0;
          eventIndex < directiveEmitters.length;
          ++eventIndex) {
        var eventEmitterAccessor = directiveEmitters[eventIndex];
        eventEmitterAccessor.subscribe(view, boundElementIndex, directive);
      }
    }
  }
  _setUpHostActions(viewModule.AppView view,
      eli.ElementInjector elementInjector, num boundElementIndex) {
    var hostActions = elementInjector.getHostActionAccessors();
    for (var directiveIndex = 0;
        directiveIndex < hostActions.length;
        ++directiveIndex) {
      var directiveHostActions = hostActions[directiveIndex];
      var directive = elementInjector.getDirectiveAtIndex(directiveIndex);
      for (var index = 0; index < directiveHostActions.length; ++index) {
        var hostActionAccessor = directiveHostActions[index];
        hostActionAccessor.subscribe(view, boundElementIndex, directive);
      }
    }
  }
  dehydrateView(viewModule.AppView initView) {
    var endViewOffset = initView.viewOffset +
        initView.mainMergeMapping.nestedViewCountByViewIndex[
        initView.viewOffset];
    for (var viewIdx = initView.viewOffset;
        viewIdx <= endViewOffset;
        viewIdx++) {
      var currView = initView.views[viewIdx];
      if (currView.hydrated()) {
        if (isPresent(currView.locals)) {
          currView.locals.clearValues();
        }
        currView.context = null;
        currView.changeDetector.dehydrate();
        var binders = currView.proto.elementBinders;
        for (var binderIdx = 0; binderIdx < binders.length; binderIdx++) {
          var eli =
              initView.elementInjectors[currView.elementOffset + binderIdx];
          if (isPresent(eli)) {
            eli.dehydrate();
          }
        }
      }
    }
  }
}
