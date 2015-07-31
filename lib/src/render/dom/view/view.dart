library angular2.src.render.dom.view.view;

import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/facade/collection.dart"
    show ListWrapper, MapWrapper, Map, StringMapWrapper, List;
import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, BaseException, stringify;
import "proto_view.dart" show DomProtoView;
import "../../api.dart" show RenderViewRef, RenderEventDispatcher;
import "../util.dart" show camelCaseToDashCase;

DomView resolveInternalDomView(RenderViewRef viewRef) {
  return ((viewRef as DomViewRef))._view;
}
class DomViewRef extends RenderViewRef {
  DomView _view;
  DomViewRef(this._view) : super() {
    /* super call moved to initializer */;
  }
}
/**
 * Const of making objects: http://jsperf.com/instantiate-size-of-object
 */
class DomView {
  DomProtoView proto;
  List<dynamic> boundTextNodes;
  List<dynamic> boundElements;
  bool hydrated = false;
  RenderEventDispatcher eventDispatcher = null;
  List<Function> eventHandlerRemovers = [];
  DomView(this.proto, this.boundTextNodes, this.boundElements) {}
  setElementProperty(num elementIndex, String propertyName, dynamic value) {
    DOM.setProperty(this.boundElements[elementIndex], propertyName, value);
  }
  setElementAttribute(num elementIndex, String attributeName, String value) {
    var element = this.boundElements[elementIndex];
    var dashCasedAttributeName = camelCaseToDashCase(attributeName);
    if (isPresent(value)) {
      DOM.setAttribute(element, dashCasedAttributeName, stringify(value));
    } else {
      DOM.removeAttribute(element, dashCasedAttributeName);
    }
  }
  setElementClass(num elementIndex, String className, bool isAdd) {
    var element = this.boundElements[elementIndex];
    if (isAdd) {
      DOM.addClass(element, className);
    } else {
      DOM.removeClass(element, className);
    }
  }
  setElementStyle(num elementIndex, String styleName, String value) {
    var element = this.boundElements[elementIndex];
    var dashCasedStyleName = camelCaseToDashCase(styleName);
    if (isPresent(value)) {
      DOM.setStyle(element, dashCasedStyleName, stringify(value));
    } else {
      DOM.removeStyle(element, dashCasedStyleName);
    }
  }
  invokeElementMethod(num elementIndex, String methodName, List<dynamic> args) {
    var element = this.boundElements[elementIndex];
    DOM.invoke(element, methodName, args);
  }
  setText(num textIndex, String value) {
    DOM.setText(this.boundTextNodes[textIndex], value);
  }
  bool dispatchEvent(num elementIndex, String eventName, dynamic event) {
    var allowDefaultBehavior = true;
    if (isPresent(this.eventDispatcher)) {
      var evalLocals = new Map();
      evalLocals["\$event"] = event;
      // TODO(tbosch): reenable this when we are parsing element properties

      // out of action expressions

      // var localValues = this.proto.elementBinders[elementIndex].eventLocals.eval(null, new

      // Locals(null, evalLocals));

      // this.eventDispatcher.dispatchEvent(elementIndex, eventName, localValues);
      allowDefaultBehavior = this.eventDispatcher.dispatchRenderEvent(
          elementIndex, eventName, evalLocals);
      if (!allowDefaultBehavior) {
        event.preventDefault();
      }
    }
    return allowDefaultBehavior;
  }
}
