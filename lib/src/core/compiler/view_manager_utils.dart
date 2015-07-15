library angular2.src.core.compiler.view_manager_utils;

import "package:angular2/di.dart"
    show Injector, Binding, Injectable, ResolvedBinding;
import "package:angular2/src/facade/collection.dart"
    show ListWrapper, MapWrapper, Map, StringMapWrapper, List;
import "element_injector.dart" as eli;
import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, BaseException;
import "view.dart" as viewModule;
import "view_manager.dart" as avmModule;
import "package:angular2/src/render/api.dart" show Renderer;
import "package:angular2/change_detection.dart" show Locals;
import "package:angular2/src/render/api.dart" show RenderViewRef;

@Injectable()
class AppViewManagerUtils {
  AppViewManagerUtils() {}
  dynamic getComponentInstance(
      viewModule.AppView parentView, num boundElementIndex) {
    var eli = parentView.elementInjectors[boundElementIndex];
    return eli.getComponent();
  }
  viewModule.AppView createView(viewModule.AppProtoView protoView,
      RenderViewRef renderView, avmModule.AppViewManager viewManager,
      Renderer renderer) {
    var view =
        new viewModule.AppView(renderer, protoView, protoView.protoLocals);
    // TODO(tbosch): pass RenderViewRef as argument to AppView!
    view.render = renderView;
    var changeDetector = protoView.protoChangeDetector.instantiate(view);
    var binders = protoView.elementBinders;
    var elementInjectors = ListWrapper.createFixedSize(binders.length);
    var rootElementInjectors = [];
    var preBuiltObjects = ListWrapper.createFixedSize(binders.length);
    var componentChildViews = ListWrapper.createFixedSize(binders.length);
    for (var binderIdx = 0; binderIdx < binders.length; binderIdx++) {
      var binder = binders[binderIdx];
      var elementInjector = null;
      // elementInjectors and rootElementInjectors
      var protoElementInjector = binder.protoElementInjector;
      if (isPresent(protoElementInjector)) {
        if (isPresent(protoElementInjector.parent)) {
          var parentElementInjector =
              elementInjectors[protoElementInjector.parent.index];
          elementInjector =
              protoElementInjector.instantiate(parentElementInjector);
        } else {
          elementInjector = protoElementInjector.instantiate(null);
          rootElementInjectors.add(elementInjector);
        }
      }
      elementInjectors[binderIdx] = elementInjector;
      // preBuiltObjects
      if (isPresent(elementInjector)) {
        var embeddedProtoView =
            binder.hasEmbeddedProtoView() ? binder.nestedProtoView : null;
        preBuiltObjects[binderIdx] =
            new eli.PreBuiltObjects(viewManager, view, embeddedProtoView);
      }
    }
    view.init(changeDetector, elementInjectors, rootElementInjectors,
        preBuiltObjects, componentChildViews);
    return view;
  }
  attachComponentView(viewModule.AppView hostView, num boundElementIndex,
      viewModule.AppView componentView) {
    var childChangeDetector = componentView.changeDetector;
    hostView.changeDetector.addShadowDomChild(childChangeDetector);
    hostView.componentChildViews[boundElementIndex] = componentView;
  }
  detachComponentView(viewModule.AppView hostView, num boundElementIndex) {
    var componentView = hostView.componentChildViews[boundElementIndex];
    hostView.changeDetector.removeShadowDomChild(componentView.changeDetector);
    hostView.componentChildViews[boundElementIndex] = null;
  }
  hydrateComponentView(viewModule.AppView hostView, num boundElementIndex) {
    var elementInjector = hostView.elementInjectors[boundElementIndex];
    var componentView = hostView.componentChildViews[boundElementIndex];
    var component = this.getComponentInstance(hostView, boundElementIndex);
    this._hydrateView(componentView, null, elementInjector, component, null);
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
    var viewContainer =
        this._getOrCreateViewContainer(parentView, boundElementIndex);
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
        ListWrapper.removeAt(parentView.rootElementInjectors, removeIdx);
      }
    }
  }
  hydrateViewInContainer(viewModule.AppView parentView, num boundElementIndex,
      viewModule.AppView contextView, num contextBoundElementIndex, num atIndex,
      List<ResolvedBinding> bindings) {
    if (isBlank(contextView)) {
      contextView = parentView;
      contextBoundElementIndex = boundElementIndex;
    }
    var viewContainer = parentView.viewContainers[boundElementIndex];
    var view = viewContainer.views[atIndex];
    var elementInjector =
        contextView.elementInjectors[contextBoundElementIndex];
    var injector =
        isPresent(bindings) ? Injector.fromResolvedBindings(bindings) : null;
    this._hydrateView(view, injector, elementInjector.getHost(),
        contextView.context, contextView.locals);
  }
  _hydrateView(viewModule.AppView view, Injector imperativelyCreatedInjector,
      eli.ElementInjector hostElementInjector, Object context,
      Locals parentLocals) {
    view.context = context;
    view.locals.parent = parentLocals;
    var binders = view.proto.elementBinders;
    for (var i = 0; i < binders.length; ++i) {
      var elementInjector = view.elementInjectors[i];
      if (isPresent(elementInjector)) {
        elementInjector.hydrate(imperativelyCreatedInjector,
            hostElementInjector, view.preBuiltObjects[i]);
        this._populateViewLocals(view, elementInjector);
        this._setUpEventEmitters(view, elementInjector, i);
        this._setUpHostActions(view, elementInjector, i);
      }
    }
    var pipes =
        this._getPipes(imperativelyCreatedInjector, hostElementInjector);
    view.changeDetector.hydrate(view.context, view.locals, view, pipes);
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
  void _populateViewLocals(
      viewModule.AppView view, eli.ElementInjector elementInjector) {
    if (isPresent(elementInjector.getDirectiveVariableBindings())) {
      MapWrapper.forEach(elementInjector.getDirectiveVariableBindings(),
          (directiveIndex, name) {
        if (isBlank(directiveIndex)) {
          view.locals.set(name, elementInjector.getElementRef().nativeElement);
        } else {
          view.locals.set(
              name, elementInjector.getDirectiveAtIndex(directiveIndex));
        }
      });
    }
  }
  _getOrCreateViewContainer(
      viewModule.AppView parentView, num boundElementIndex) {
    var viewContainer = parentView.viewContainers[boundElementIndex];
    if (isBlank(viewContainer)) {
      viewContainer = new viewModule.AppViewContainer();
      parentView.viewContainers[boundElementIndex] = viewContainer;
    }
    return viewContainer;
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
  dehydrateView(viewModule.AppView view) {
    var binders = view.proto.elementBinders;
    for (var i = 0; i < binders.length; ++i) {
      var elementInjector = view.elementInjectors[i];
      if (isPresent(elementInjector)) {
        elementInjector.dehydrate();
      }
    }
    if (isPresent(view.locals)) {
      view.locals.clearValues();
    }
    view.context = null;
    view.changeDetector.dehydrate();
  }
}
