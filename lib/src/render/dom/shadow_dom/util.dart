library angular2.src.render.dom.shadow_dom.util;

import "package:angular2/src/facade/lang.dart" show isBlank, isPresent;
import "package:angular2/src/facade/collection.dart" show MapWrapper, Map;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "shadow_css.dart" show ShadowCss;

Map<String, int> _componentUIDs = new Map();
int _nextComponentUID = 0;
Map<String, bool> _sharedStyleTexts = new Map();
var _lastInsertedStyleEl;
num getComponentId(String componentStringId) {
  var id = _componentUIDs[componentStringId];
  if (isBlank(id)) {
    id = _nextComponentUID++;
    _componentUIDs[componentStringId] = id;
  }
  return id;
}
insertSharedStyleText(cssText, styleHost, styleEl) {
  if (!_sharedStyleTexts.containsKey(cssText)) {
    // Styles are unscoped and shared across components, only append them to the head

    // when there are not present yet
    _sharedStyleTexts[cssText] = true;
    insertStyleElement(styleHost, styleEl);
  }
}
insertStyleElement(host, styleEl) {
  if (isBlank(_lastInsertedStyleEl)) {
    var firstChild = DOM.firstChild(host);
    if (isPresent(firstChild)) {
      DOM.insertBefore(firstChild, styleEl);
    } else {
      DOM.appendChild(host, styleEl);
    }
  } else {
    DOM.insertAfter(_lastInsertedStyleEl, styleEl);
  }
  _lastInsertedStyleEl = styleEl;
}
// Return the attribute to be added to the component
String getHostAttribute(int id) {
  return '''_nghost-${ id}''';
}
// Returns the attribute to be added on every single element nodes in the component
String getContentAttribute(int id) {
  return '''_ngcontent-${ id}''';
}
String shimCssForComponent(String cssText, String componentId) {
  var id = getComponentId(componentId);
  var shadowCss = new ShadowCss();
  return shadowCss.shimCssText(
      cssText, getContentAttribute(id), getHostAttribute(id));
}
// Reset the caches - used for tests only
resetShadowDomCache() {
  _componentUIDs.clear();
  _nextComponentUID = 0;
  _sharedStyleTexts.clear();
  _lastInsertedStyleEl = null;
}
