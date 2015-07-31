library angular2.src.debug.debug_element_view_listener;

import "package:angular2/src/facade/lang.dart"
    show isPresent, NumberWrapper, StringWrapper;
import "package:angular2/src/facade/collection.dart"
    show MapWrapper, Map, ListWrapper, List;
import "package:angular2/di.dart" show Injectable, bind, Binding;
import "package:angular2/src/core/compiler/view_listener.dart"
    show AppViewListener;
import "package:angular2/src/core/compiler/view.dart" show AppView;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/render/api.dart" show Renderer;
import "debug_element.dart" show DebugElement;

const NG_ID_PROPERTY = "ngid";
const INSPECT_GLOBAL_NAME = "ngProbe";
var NG_ID_SEPARATOR = "#";
// Need to keep the views in a global Map so that multiple angular apps are supported
var _allIdsByView = new Map<AppView, num>();
var _allViewsById = new Map<num, AppView>();
var _nextId = 0;
_setElementId(element, List<num> indices) {
  if (isPresent(element)) {
    DOM.setData(
        element, NG_ID_PROPERTY, ListWrapper.join(indices, NG_ID_SEPARATOR));
  }
}
List<num> _getElementId(element) {
  var elId = DOM.getData(element, NG_ID_PROPERTY);
  if (isPresent(elId)) {
    return ListWrapper.map(elId.split(NG_ID_SEPARATOR),
        (partStr) => NumberWrapper.parseInt(partStr, 10));
  } else {
    return null;
  }
}
DebugElement inspectNativeElement(element) {
  var elId = _getElementId(element);
  if (isPresent(elId)) {
    var view = _allViewsById[elId[0]];
    if (isPresent(view)) {
      return new DebugElement(view, elId[1]);
    }
  }
  return null;
}
@Injectable()
class DebugElementViewListener implements AppViewListener {
  Renderer _renderer;
  DebugElementViewListener(this._renderer) {
    DOM.setGlobalVar(INSPECT_GLOBAL_NAME, inspectNativeElement);
  }
  viewCreated(AppView view) {
    var viewId = _nextId++;
    _allViewsById[viewId] = view;
    _allIdsByView[view] = viewId;
    for (var i = 0; i < view.elementRefs.length; i++) {
      var el = view.elementRefs[i];
      _setElementId(this._renderer.getNativeElementSync(el), [viewId, i]);
    }
  }
  viewDestroyed(AppView view) {
    var viewId = _allIdsByView[view];
    MapWrapper.delete(_allIdsByView, view);
    MapWrapper.delete(_allViewsById, viewId);
  }
}
var ELEMENT_PROBE_CONFIG = [
  DebugElementViewListener,
  bind(AppViewListener).toAlias(DebugElementViewListener)
];
