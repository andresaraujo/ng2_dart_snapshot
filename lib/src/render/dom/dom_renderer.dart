library angular2.src.render.dom.dom_renderer;

import "package:angular2/di.dart" show Inject, Injectable, OpaqueToken;
import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, BaseException, RegExpWrapper;
import "package:angular2/src/facade/collection.dart"
    show ListWrapper, MapWrapper, Map, StringMapWrapper, List;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "shadow_dom/content_tag.dart" show Content;
import "shadow_dom/shadow_dom_strategy.dart" show ShadowDomStrategy;
import "events/event_manager.dart" show EventManager;
import "view/proto_view.dart"
    show DomProtoView, DomProtoViewRef, resolveInternalDomProtoView;
import "view/view.dart" show DomView, DomViewRef, resolveInternalDomView;
import "view/element.dart" show DomElement;
import "view/view_container.dart" show DomViewContainer;
import "util.dart" show NG_BINDING_CLASS_SELECTOR, NG_BINDING_CLASS;
import "../api.dart"
    show Renderer, RenderProtoViewRef, RenderViewRef, RenderElementRef;

const DOCUMENT_TOKEN = const OpaqueToken("DocumentToken");
@Injectable()
class DomRenderer extends Renderer {
  EventManager _eventManager;
  ShadowDomStrategy _shadowDomStrategy;
  var _document;
  DomRenderer(this._eventManager, this._shadowDomStrategy,
      @Inject(DOCUMENT_TOKEN) document)
      : super() {
    /* super call moved to initializer */;
    this._document = document;
  }
  RenderViewRef createRootHostView(
      RenderProtoViewRef hostProtoViewRef, String hostElementSelector) {
    var hostProtoView = resolveInternalDomProtoView(hostProtoViewRef);
    var element = DOM.querySelector(this._document, hostElementSelector);
    if (isBlank(element)) {
      throw new BaseException(
          '''The selector "${ hostElementSelector}" did not match any elements''');
    }
    return new DomViewRef(this._createView(hostProtoView, element));
  }
  RenderViewRef createView(RenderProtoViewRef protoViewRef) {
    var protoView = resolveInternalDomProtoView(protoViewRef);
    return new DomViewRef(this._createView(protoView, null));
  }
  destroyView(RenderViewRef view) {}
  dynamic getNativeElementSync(RenderElementRef location) {
    return resolveInternalDomView(location.renderView).boundElements[
        location.boundElementIndex].element;
  }
  attachComponentView(
      RenderElementRef location, RenderViewRef componentViewRef) {
    var hostView = resolveInternalDomView(location.renderView);
    var componentView = resolveInternalDomView(componentViewRef);
    var element = hostView.boundElements[location.boundElementIndex].element;
    var lightDom = hostView.boundElements[location.boundElementIndex].lightDom;
    if (isPresent(lightDom)) {
      lightDom.attachShadowDomView(componentView);
    }
    var shadowRoot = this._shadowDomStrategy.prepareShadowRoot(element);
    this._moveViewNodesIntoParent(shadowRoot, componentView);
    componentView.hostLightDom = lightDom;
    componentView.shadowRoot = shadowRoot;
  }
  setComponentViewRootNodes(
      RenderViewRef componentViewRef, List<dynamic> rootNodes) {
    var componentView = resolveInternalDomView(componentViewRef);
    this._removeViewNodes(componentView);
    componentView.rootNodes = rootNodes;
    this._moveViewNodesIntoParent(componentView.shadowRoot, componentView);
  }
  List<dynamic> getRootNodes(RenderViewRef viewRef) {
    return resolveInternalDomView(viewRef).rootNodes;
  }
  detachComponentView(
      RenderElementRef location, RenderViewRef componentViewRef) {
    var hostView = resolveInternalDomView(location.renderView);
    var componentView = resolveInternalDomView(componentViewRef);
    this._removeViewNodes(componentView);
    var lightDom = hostView.boundElements[location.boundElementIndex].lightDom;
    if (isPresent(lightDom)) {
      lightDom.detachShadowDomView();
    }
    componentView.hostLightDom = null;
    componentView.shadowRoot = null;
  }
  attachViewInContainer(
      RenderElementRef location, num atIndex, RenderViewRef viewRef) {
    var parentView = resolveInternalDomView(location.renderView);
    var view = resolveInternalDomView(viewRef);
    var viewContainer =
        this._getOrCreateViewContainer(parentView, location.boundElementIndex);
    ListWrapper.insert(viewContainer.views, atIndex, view);
    view.hostLightDom = parentView.hostLightDom;
    var directParentLightDom =
        this._directParentLightDom(parentView, location.boundElementIndex);
    if (isBlank(directParentLightDom)) {
      var siblingToInsertAfter;
      if (atIndex == 0) {
        siblingToInsertAfter =
            parentView.boundElements[location.boundElementIndex].element;
      } else {
        siblingToInsertAfter =
            ListWrapper.last(viewContainer.views[atIndex - 1].rootNodes);
      }
      this._moveViewNodesAfterSibling(siblingToInsertAfter, view);
    } else {
      directParentLightDom.redistribute();
    }
    // new content tags might have appeared, we need to redistribute.
    if (isPresent(parentView.hostLightDom)) {
      parentView.hostLightDom.redistribute();
    }
  }
  detachViewInContainer(
      RenderElementRef location, num atIndex, RenderViewRef viewRef) {
    var parentView = resolveInternalDomView(location.renderView);
    var view = resolveInternalDomView(viewRef);
    var viewContainer =
        parentView.boundElements[location.boundElementIndex].viewContainer;
    var detachedView = viewContainer.views[atIndex];
    ListWrapper.removeAt(viewContainer.views, atIndex);
    var directParentLightDom =
        this._directParentLightDom(parentView, location.boundElementIndex);
    if (isBlank(directParentLightDom)) {
      this._removeViewNodes(detachedView);
    } else {
      directParentLightDom.redistribute();
    }
    view.hostLightDom = null;
    // content tags might have disappeared we need to do redistribution.
    if (isPresent(parentView.hostLightDom)) {
      parentView.hostLightDom.redistribute();
    }
  }
  hydrateView(RenderViewRef viewRef) {
    var view = resolveInternalDomView(viewRef);
    if (view.hydrated) throw new BaseException("The view is already hydrated.");
    view.hydrated = true;
    for (var i = 0; i < view.boundElements.length; ++i) {
      var lightDom = view.boundElements[i].lightDom;
      if (isPresent(lightDom)) {
        lightDom.redistribute();
      }
    }
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
    if (isPresent(view.hostLightDom)) {
      view.hostLightDom.redistribute();
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
    var view = resolveInternalDomView(location.renderView);
    view.setElementProperty(
        location.boundElementIndex, propertyName, propertyValue);
  }
  void setElementAttribute(
      RenderElementRef location, String attributeName, String attributeValue) {
    var view = resolveInternalDomView(location.renderView);
    view.setElementAttribute(
        location.boundElementIndex, attributeName, attributeValue);
  }
  void setElementClass(
      RenderElementRef location, String className, bool isAdd) {
    var view = resolveInternalDomView(location.renderView);
    view.setElementClass(location.boundElementIndex, className, isAdd);
  }
  void setElementStyle(
      RenderElementRef location, String styleName, String styleValue) {
    var view = resolveInternalDomView(location.renderView);
    view.setElementStyle(location.boundElementIndex, styleName, styleValue);
  }
  void invokeElementMethod(
      RenderElementRef location, String methodName, List<dynamic> args) {
    var view = resolveInternalDomView(location.renderView);
    view.invokeElementMethod(location.boundElementIndex, methodName, args);
  }
  void setText(RenderViewRef viewRef, num textNodeIndex, String text) {
    var view = resolveInternalDomView(viewRef);
    DOM.setText(view.boundTextNodes[textNodeIndex], text);
  }
  void setEventDispatcher(RenderViewRef viewRef, dynamic dispatcher) {
    var view = resolveInternalDomView(viewRef);
    view.eventDispatcher = dispatcher;
  }
  DomView _createView(DomProtoView protoView, inplaceElement) {
    var rootElementClone;
    var elementsWithBindingsDynamic;
    var viewRootNodes;
    if (isPresent(inplaceElement)) {
      rootElementClone = inplaceElement;
      elementsWithBindingsDynamic = [];
      viewRootNodes = [inplaceElement];
    } else if (protoView.isTemplateElement) {
      rootElementClone = DOM.importIntoDoc(DOM.content(protoView.element));
      elementsWithBindingsDynamic =
          DOM.querySelectorAll(rootElementClone, NG_BINDING_CLASS_SELECTOR);
      viewRootNodes = ListWrapper.createFixedSize(protoView.rootNodeCount);
      // Note: An explicit loop is the fastest way to convert a DOM array into a JS array!
      var childNode = DOM.firstChild(rootElementClone);
      for (var i = 0;
          i < protoView.rootNodeCount;
          i++,
          childNode = DOM.nextSibling(childNode)) {
        viewRootNodes[i] = childNode;
      }
    } else {
      rootElementClone = DOM.importIntoDoc(protoView.element);
      elementsWithBindingsDynamic =
          DOM.getElementsByClassName(rootElementClone, NG_BINDING_CLASS);
      viewRootNodes = [rootElementClone];
    }
    var binders = protoView.elementBinders;
    var boundTextNodes =
        ListWrapper.createFixedSize(protoView.boundTextNodeCount);
    var boundElements = ListWrapper.createFixedSize(binders.length);
    var boundTextNodeIdx = 0;
    for (var binderIdx = 0; binderIdx < binders.length; binderIdx++) {
      var binder = binders[binderIdx];
      var element;
      var childNodes;
      if (identical(binderIdx, 0) &&
          identical(protoView.rootBindingOffset, 1)) {
        // Note: if the root element was a template,

        // the rootElementClone is a document fragment,

        // which will be empty as soon as the view gets appended

        // to a parent. So we store null in the boundElements array.
        element = protoView.isTemplateElement ? null : rootElementClone;
        childNodes = DOM.childNodes(rootElementClone);
      } else {
        element = elementsWithBindingsDynamic[
            binderIdx - protoView.rootBindingOffset];
        childNodes = DOM.childNodes(element);
      }
      // boundTextNodes
      var textNodeIndices = binder.textNodeIndices;
      for (var i = 0; i < textNodeIndices.length; i++) {
        boundTextNodes[boundTextNodeIdx++] = childNodes[textNodeIndices[i]];
      }
      // contentTags
      var contentTag = null;
      if (isPresent(binder.contentTagSelector)) {
        contentTag = new Content(element, binder.contentTagSelector);
      }
      boundElements[binderIdx] = new DomElement(binder, element, contentTag);
    }
    var view =
        new DomView(protoView, viewRootNodes, boundTextNodes, boundElements);
    for (var binderIdx = 0; binderIdx < binders.length; binderIdx++) {
      var binder = binders[binderIdx];
      var element = boundElements[binderIdx];
      var domEl = element.element;
      // lightDoms
      var lightDom = null;
      // Note: for the root element we can't use the binder.elementIsEmpty

      // information as we don't use the element from the ProtoView

      // but an element from the document.
      if (isPresent(binder.componentId) &&
          (!binder.elementIsEmpty || isPresent(inplaceElement))) {
        lightDom = this._shadowDomStrategy.constructLightDom(view, domEl);
      }
      element.lightDom = lightDom;
      // init contentTags
      var contentTag = element.contentTag;
      if (isPresent(contentTag)) {
        var directParentLightDom = this._directParentLightDom(view, binderIdx);
        contentTag.init(directParentLightDom);
      }
      // events
      if (isPresent(binder.eventLocals) && isPresent(binder.localEvents)) {
        for (var i = 0; i < binder.localEvents.length; i++) {
          this._createEventListener(view, domEl, binderIdx,
              binder.localEvents[i].name, binder.eventLocals);
        }
      }
    }
    return view;
  }
  _createEventListener(view, element, elementIndex, eventName, eventLocals) {
    this._eventManager.addEventListener(element, eventName, (event) {
      view.dispatchEvent(elementIndex, eventName, event);
    });
  }
  _moveViewNodesAfterSibling(sibling, view) {
    for (var i = view.rootNodes.length - 1; i >= 0; --i) {
      DOM.insertAfter(sibling, view.rootNodes[i]);
    }
  }
  _moveViewNodesIntoParent(parent, view) {
    for (var i = 0; i < view.rootNodes.length; ++i) {
      DOM.appendChild(parent, view.rootNodes[i]);
    }
  }
  _removeViewNodes(view) {
    var len = view.rootNodes.length;
    if (len == 0) return;
    var parent = view.rootNodes[0].parentNode;
    for (var i = len - 1; i >= 0; --i) {
      DOM.removeChild(parent, view.rootNodes[i]);
    }
  }
  _getOrCreateViewContainer(DomView parentView, boundElementIndex) {
    var el = parentView.boundElements[boundElementIndex];
    var vc = el.viewContainer;
    if (isBlank(vc)) {
      vc = new DomViewContainer();
      el.viewContainer = vc;
    }
    return vc;
  }
  _directParentLightDom(DomView view, num boundElementIndex) {
    var directParentEl = view.getDirectParentElement(boundElementIndex);
    return isPresent(directParentEl) ? directParentEl.lightDom : null;
  }
  Function _createGlobalEventListener(
      view, elementIndex, eventName, eventTarget, fullName) {
    return this._eventManager.addGlobalEventListener(eventTarget, eventName,
        (event) {
      view.dispatchEvent(elementIndex, fullName, event);
    });
  }
}
