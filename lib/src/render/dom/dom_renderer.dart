library angular2.src.render.dom.dom_renderer;

import "package:angular2/di.dart" show Inject, Injectable, OpaqueToken;
import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, BaseException, RegExpWrapper;
import "package:angular2/src/facade/collection.dart"
    show ListWrapper, MapWrapper, Map, StringMapWrapper, List;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "events/event_manager.dart" show EventManager;
import "view/proto_view.dart"
    show DomProtoView, DomProtoViewRef, resolveInternalDomProtoView;
import "view/view.dart" show DomView, DomViewRef, resolveInternalDomView;
import "view/fragment.dart" show DomFragmentRef, resolveInternalDomFragment;
import "view/shared_styles_host.dart" show DomSharedStylesHost;
import "util.dart"
    show
        NG_BINDING_CLASS_SELECTOR,
        NG_BINDING_CLASS,
        cloneAndQueryProtoView,
        camelCaseToDashCase;
import "../api.dart"
    show
        Renderer,
        RenderProtoViewRef,
        RenderViewRef,
        RenderElementRef,
        RenderFragmentRef,
        RenderViewWithFragments;
import "template_cloner.dart" show TemplateCloner;
import "dom_tokens.dart"
    show DOCUMENT_TOKEN, DOM_REFLECT_PROPERTIES_AS_ATTRIBUTES;

const String REFLECT_PREFIX = "ng-reflect-";
@Injectable()
class DomRenderer extends Renderer {
  EventManager _eventManager;
  DomSharedStylesHost _domSharedStylesHost;
  TemplateCloner _templateCloner;
  var _document;
  bool _reflectPropertiesAsAttributes;
  DomRenderer(this._eventManager, this._domSharedStylesHost,
      this._templateCloner, @Inject(DOCUMENT_TOKEN) document, @Inject(
          DOM_REFLECT_PROPERTIES_AS_ATTRIBUTES) bool reflectPropertiesAsAttributes)
      : super() {
    /* super call moved to initializer */;
    this._reflectPropertiesAsAttributes = reflectPropertiesAsAttributes;
    this._document = document;
  }
  RenderViewWithFragments createRootHostView(
      RenderProtoViewRef hostProtoViewRef, num fragmentCount,
      String hostElementSelector) {
    var hostProtoView = resolveInternalDomProtoView(hostProtoViewRef);
    var element = DOM.querySelector(this._document, hostElementSelector);
    if (isBlank(element)) {
      throw new BaseException(
          '''The selector "${ hostElementSelector}" did not match any elements''');
    }
    return this._createView(hostProtoView, element);
  }
  RenderViewWithFragments createView(
      RenderProtoViewRef protoViewRef, num fragmentCount) {
    var protoView = resolveInternalDomProtoView(protoViewRef);
    return this._createView(protoView, null);
  }
  destroyView(RenderViewRef viewRef) {
    var view = resolveInternalDomView(viewRef);
    var elementBinders = view.proto.elementBinders;
    for (var i = 0; i < elementBinders.length; i++) {
      var binder = elementBinders[i];
      if (binder.hasNativeShadowRoot) {
        this._domSharedStylesHost
            .removeHost(DOM.getShadowRoot(view.boundElements[i]));
      }
    }
  }
  dynamic getNativeElementSync(RenderElementRef location) {
    if (isBlank(location.renderBoundElementIndex)) {
      return null;
    }
    return resolveInternalDomView(location.renderView).boundElements[
        location.renderBoundElementIndex];
  }
  List<dynamic> getRootNodes(RenderFragmentRef fragment) {
    return resolveInternalDomFragment(fragment);
  }
  attachFragmentAfterFragment(
      RenderFragmentRef previousFragmentRef, RenderFragmentRef fragmentRef) {
    var previousFragmentNodes = resolveInternalDomFragment(previousFragmentRef);
    if (previousFragmentNodes.length > 0) {
      var sibling = previousFragmentNodes[previousFragmentNodes.length - 1];
      moveNodesAfterSibling(sibling, resolveInternalDomFragment(fragmentRef));
    }
  }
  attachFragmentAfterElement(
      RenderElementRef elementRef, RenderFragmentRef fragmentRef) {
    if (isBlank(elementRef.renderBoundElementIndex)) {
      return;
    }
    var parentView = resolveInternalDomView(elementRef.renderView);
    var element = parentView.boundElements[elementRef.renderBoundElementIndex];
    moveNodesAfterSibling(element, resolveInternalDomFragment(fragmentRef));
  }
  detachFragment(RenderFragmentRef fragmentRef) {
    var fragmentNodes = resolveInternalDomFragment(fragmentRef);
    for (var i = 0; i < fragmentNodes.length; i++) {
      DOM.remove(fragmentNodes[i]);
    }
  }
  hydrateView(RenderViewRef viewRef) {
    var view = resolveInternalDomView(viewRef);
    if (view.hydrated) throw new BaseException("The view is already hydrated.");
    view.hydrated = true;
    // add global events
    view.eventHandlerRemovers = [];
    var binders = view.proto.elementBinders;
    for (var binderIdx = 0; binderIdx < binders.length; binderIdx++) {
      var binder = binders[binderIdx];
      if (isPresent(binder.globalEvents)) {
        for (var i = 0; i < binder.globalEvents.length; i++) {
          var globalEvent = binder.globalEvents[i];
          var remover = this._createGlobalEventListener(view, binderIdx,
              globalEvent.name, globalEvent.target, globalEvent.fullName);
          view.eventHandlerRemovers.add(remover);
        }
      }
    }
  }
  dehydrateView(RenderViewRef viewRef) {
    var view = resolveInternalDomView(viewRef);
    // remove global events
    for (var i = 0; i < view.eventHandlerRemovers.length; i++) {
      view.eventHandlerRemovers[i]();
    }
    view.eventHandlerRemovers = null;
    view.hydrated = false;
  }
  void setElementProperty(
      RenderElementRef location, String propertyName, dynamic propertyValue) {
    if (isBlank(location.renderBoundElementIndex)) {
      return;
    }
    var view = resolveInternalDomView(location.renderView);
    view.setElementProperty(
        location.renderBoundElementIndex, propertyName, propertyValue);
    // Reflect the property value as an attribute value with ng-reflect- prefix.
    if (this._reflectPropertiesAsAttributes) {
      this.setElementAttribute(location,
          '''${ REFLECT_PREFIX}${ camelCaseToDashCase ( propertyName )}''',
          '''${ propertyValue}''');
    }
  }
  void setElementAttribute(
      RenderElementRef location, String attributeName, String attributeValue) {
    if (isBlank(location.renderBoundElementIndex)) {
      return;
    }
    var view = resolveInternalDomView(location.renderView);
    view.setElementAttribute(
        location.renderBoundElementIndex, attributeName, attributeValue);
  }
  void setElementClass(
      RenderElementRef location, String className, bool isAdd) {
    if (isBlank(location.renderBoundElementIndex)) {
      return;
    }
    var view = resolveInternalDomView(location.renderView);
    view.setElementClass(location.renderBoundElementIndex, className, isAdd);
  }
  void setElementStyle(
      RenderElementRef location, String styleName, String styleValue) {
    if (isBlank(location.renderBoundElementIndex)) {
      return;
    }
    var view = resolveInternalDomView(location.renderView);
    view.setElementStyle(
        location.renderBoundElementIndex, styleName, styleValue);
  }
  void invokeElementMethod(
      RenderElementRef location, String methodName, List<dynamic> args) {
    if (isBlank(location.renderBoundElementIndex)) {
      return;
    }
    var view = resolveInternalDomView(location.renderView);
    view.invokeElementMethod(
        location.renderBoundElementIndex, methodName, args);
  }
  void setText(RenderViewRef viewRef, num textNodeIndex, String text) {
    if (isBlank(textNodeIndex)) {
      return;
    }
    var view = resolveInternalDomView(viewRef);
    DOM.setText(view.boundTextNodes[textNodeIndex], text);
  }
  void setEventDispatcher(RenderViewRef viewRef, dynamic dispatcher) {
    var view = resolveInternalDomView(viewRef);
    view.eventDispatcher = dispatcher;
  }
  RenderViewWithFragments _createView(
      DomProtoView protoView, dynamic inplaceElement) {
    var clonedProtoView =
        cloneAndQueryProtoView(this._templateCloner, protoView, true);
    var boundElements = clonedProtoView.boundElements;
    // adopt inplaceElement
    if (isPresent(inplaceElement)) {
      if (!identical(protoView.fragmentsRootNodeCount[0], 1)) {
        throw new BaseException(
            "Root proto views can only contain one element!");
      }
      DOM.clearNodes(inplaceElement);
      var tempRoot = clonedProtoView.fragments[0][0];
      moveChildNodes(tempRoot, inplaceElement);
      if (boundElements.length > 0 && identical(boundElements[0], tempRoot)) {
        boundElements[0] = inplaceElement;
      }
      clonedProtoView.fragments[0][0] = inplaceElement;
    }
    var view =
        new DomView(protoView, clonedProtoView.boundTextNodes, boundElements);
    var binders = protoView.elementBinders;
    for (var binderIdx = 0; binderIdx < binders.length; binderIdx++) {
      var binder = binders[binderIdx];
      var element = boundElements[binderIdx];
      // native shadow DOM
      if (binder.hasNativeShadowRoot) {
        var shadowRootWrapper = DOM.firstChild(element);
        var shadowRoot = DOM.createShadowRoot(element);
        this._domSharedStylesHost.addHost(shadowRoot);
        moveChildNodes(shadowRootWrapper, shadowRoot);
        DOM.remove(shadowRootWrapper);
      }
      // events
      if (isPresent(binder.eventLocals) && isPresent(binder.localEvents)) {
        for (var i = 0; i < binder.localEvents.length; i++) {
          this._createEventListener(view, element, binderIdx,
              binder.localEvents[i].name, binder.eventLocals);
        }
      }
    }
    return new RenderViewWithFragments(new DomViewRef(view),
        clonedProtoView.fragments
            .map((nodes) => new DomFragmentRef(nodes))
            .toList());
  }
  _createEventListener(view, element, elementIndex, eventName, eventLocals) {
    this._eventManager.addEventListener(element, eventName, (event) {
      view.dispatchEvent(elementIndex, eventName, event);
    });
  }
  Function _createGlobalEventListener(
      view, elementIndex, eventName, eventTarget, fullName) {
    return this._eventManager.addGlobalEventListener(eventTarget, eventName,
        (event) {
      view.dispatchEvent(elementIndex, fullName, event);
    });
  }
}
moveNodesAfterSibling(sibling, nodes) {
  if (nodes.length > 0 && isPresent(DOM.parentElement(sibling))) {
    for (var i = 0; i < nodes.length; i++) {
      DOM.insertBefore(sibling, nodes[i]);
    }
    DOM.insertBefore(nodes[nodes.length - 1], sibling);
  }
}
moveChildNodes(dynamic source, dynamic target) {
  var currChild = DOM.firstChild(source);
  while (isPresent(currChild)) {
    var nextChild = DOM.nextSibling(currChild);
    DOM.appendChild(target, currChild);
    currChild = nextChild;
  }
}
