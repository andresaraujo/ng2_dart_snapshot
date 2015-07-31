library angular2.src.render.dom.compiler.style_encapsulator;

import "../compiler/compile_step.dart" show CompileStep;
import "../compiler/compile_element.dart" show CompileElement;
import "../compiler/compile_control.dart" show CompileControl;
import "../../api.dart" show ViewDefinition, ViewEncapsulation, ViewType;
import "../util.dart" show NG_CONTENT_ELEMENT_NAME, isElementWithTag;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/facade/lang.dart" show isBlank, isPresent;
import "shadow_css.dart" show ShadowCss;

class StyleEncapsulator implements CompileStep {
  String _appId;
  ViewDefinition _view;
  Map<String, String> _componentUIDsCache;
  StyleEncapsulator(this._appId, this._view, this._componentUIDsCache) {}
  processElement(
      CompileElement parent, CompileElement current, CompileControl control) {
    if (isElementWithTag(current.element, NG_CONTENT_ELEMENT_NAME)) {
      current.inheritedProtoView.bindNgContent();
    } else {
      if (identical(this._view.encapsulation, ViewEncapsulation.EMULATED)) {
        this._processEmulatedScopedElement(current, parent);
      }
    }
  }
  String processStyle(String style) {
    var encapsulation = this._view.encapsulation;
    if (identical(encapsulation, ViewEncapsulation.EMULATED)) {
      return this._shimCssForComponent(style, this._view.componentId);
    } else {
      return style;
    }
  }
  void _processEmulatedScopedElement(
      CompileElement current, CompileElement parent) {
    var element = current.element;
    var hostComponentId = this._view.componentId;
    var viewType = current.inheritedProtoView.type;
    // Shim the element as a child of the compiled component
    if (!identical(viewType, ViewType.HOST) && isPresent(hostComponentId)) {
      var contentAttribute =
          getContentAttribute(this._getComponentId(hostComponentId));
      DOM.setAttribute(element, contentAttribute, "");
      // also shim the host
      if (isBlank(parent) && viewType == ViewType.COMPONENT) {
        var hostAttribute =
            getHostAttribute(this._getComponentId(hostComponentId));
        current.inheritedProtoView.setHostAttribute(hostAttribute, "");
      }
    }
  }
  String _shimCssForComponent(String cssText, String componentId) {
    var id = this._getComponentId(componentId);
    var shadowCss = new ShadowCss();
    return shadowCss.shimCssText(
        cssText, getContentAttribute(id), getHostAttribute(id));
  }
  String _getComponentId(String componentStringId) {
    var id = this._componentUIDsCache[componentStringId];
    if (isBlank(id)) {
      id = '''${ this . _appId}-${ this . _componentUIDsCache . length}''';
      this._componentUIDsCache[componentStringId] = id;
    }
    return id;
  }
}
// Return the attribute to be added to the component
String getHostAttribute(String compId) {
  return '''_nghost-${ compId}''';
}
// Returns the attribute to be added on every single element nodes in the component
String getContentAttribute(String compId) {
  return '''_ngcontent-${ compId}''';
}
