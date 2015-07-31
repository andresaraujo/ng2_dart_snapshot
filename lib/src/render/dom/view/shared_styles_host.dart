library angular2.src.render.dom.view.shared_styles_host;

import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/di.dart" show Inject, Injectable;
import "package:angular2/src/facade/collection.dart" show SetWrapper;
import "../dom_tokens.dart" show DOCUMENT_TOKEN;

@Injectable()
class SharedStylesHost {
  List<String> _styles = [];
  Set<String> _stylesSet = new Set();
  SharedStylesHost() {}
  addStyles(List<String> styles) {
    var additions = [];
    styles.forEach((style) {
      if (!SetWrapper.has(this._stylesSet, style)) {
        this._stylesSet.add(style);
        this._styles.add(style);
        additions.add(style);
      }
    });
    this.onStylesAdded(additions);
  }
  onStylesAdded(List<String> additions) {}
  List<String> getAllStyles() {
    return this._styles;
  }
}
@Injectable()
class DomSharedStylesHost extends SharedStylesHost {
  Set<dynamic> _hostNodes = new Set();
  DomSharedStylesHost(@Inject(DOCUMENT_TOKEN) dynamic doc) : super() {
    /* super call moved to initializer */;
    this._hostNodes.add(doc.head);
  }
  _addStylesToHost(List<String> styles, dynamic host) {
    for (var i = 0; i < styles.length; i++) {
      var style = styles[i];
      DOM.appendChild(host, DOM.createStyleElement(style));
    }
  }
  addHost(dynamic hostNode) {
    this._addStylesToHost(this._styles, hostNode);
    this._hostNodes.add(hostNode);
  }
  removeHost(dynamic hostNode) {
    SetWrapper.delete(this._hostNodes, hostNode);
  }
  onStylesAdded(List<String> additions) {
    this._hostNodes.forEach((hostNode) {
      this._addStylesToHost(additions, hostNode);
    });
  }
}
