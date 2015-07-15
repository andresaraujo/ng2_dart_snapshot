library angular2.src.render.dom.shadow_dom.light_dom;

import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/facade/collection.dart" show List, ListWrapper;
import "package:angular2/src/facade/lang.dart" show isBlank, isPresent;
import "../view/view.dart" as viewModule;
import "../view/element.dart" as elModule;
import "content_tag.dart" show Content;

class DestinationLightDom {}
class _Root {
  var node;
  elModule.DomElement boundElement;
  _Root(this.node, this.boundElement) {}
}
// TODO: LightDom should implement DestinationLightDom

// once interfaces are supported
class LightDom {
  // The light DOM of the element is enclosed inside the lightDomView
  viewModule.DomView lightDomView;
  // The shadow DOM
  viewModule.DomView shadowDomView = null;
  // The nodes of the light DOM
  List<dynamic> nodes;
  List<_Root> _roots = null;
  LightDom(viewModule.DomView lightDomView, element) {
    this.lightDomView = lightDomView;
    this.nodes = DOM.childNodesAsList(element);
  }
  attachShadowDomView(viewModule.DomView shadowDomView) {
    this.shadowDomView = shadowDomView;
  }
  detachShadowDomView() {
    this.shadowDomView = null;
  }
  redistribute() {
    redistributeNodes(this.contentTags(), this.expandedDomNodes());
  }
  List<Content> contentTags() {
    if (isPresent(this.shadowDomView)) {
      return this._collectAllContentTags(this.shadowDomView, []);
    } else {
      return [];
    }
  }
  // Collects the Content directives from the view and all its child views
  List<Content> _collectAllContentTags(
      viewModule.DomView view, List<Content> acc) {
    // Note: exiting early here is important as we call this function for every view

    // that is added, so we have O(n^2) runtime.

    // TODO(tbosch): fix the root problem, see

    // https://github.com/angular/angular/issues/2298
    if (identical(view.proto.transitiveContentTagCount, 0)) {
      return acc;
    }
    var els = view.boundElements;
    for (var i = 0; i < els.length; i++) {
      var el = els[i];
      if (isPresent(el.contentTag)) {
        acc.add(el.contentTag);
      }
      if (isPresent(el.viewContainer)) {
        ListWrapper.forEach(el.viewContainer.contentTagContainers(), (view) {
          this._collectAllContentTags(view, acc);
        });
      }
    }
    return acc;
  }
  // Collects the nodes of the light DOM by merging:

  // - nodes from enclosed ViewContainers,

  // - nodes from enclosed content tags,

  // - plain DOM nodes
  List<dynamic> expandedDomNodes() {
    var res = [];
    var roots = this._findRoots();
    for (var i = 0; i < roots.length; ++i) {
      var root = roots[i];
      if (isPresent(root.boundElement)) {
        var vc = root.boundElement.viewContainer;
        var content = root.boundElement.contentTag;
        if (isPresent(vc)) {
          res = ListWrapper.concat(res, vc.nodes());
        } else if (isPresent(content)) {
          res = ListWrapper.concat(res, content.nodes());
        } else {
          res.add(root.node);
        }
      } else {
        res.add(root.node);
      }
    }
    return res;
  }
  // Returns a list of Roots for all the nodes of the light DOM.

  // The Root object contains the DOM node and its corresponding boundElement
  _findRoots() {
    if (isPresent(this._roots)) return this._roots;
    var boundElements = this.lightDomView.boundElements;
    this._roots = ListWrapper.map(this.nodes, (n) {
      var boundElement = null;
      for (var i = 0; i < boundElements.length; i++) {
        var boundEl = boundElements[i];
        if (isPresent(boundEl) && identical(boundEl.element, n)) {
          boundElement = boundEl;
          break;
        }
      }
      return new _Root(n, boundElement);
    });
    return this._roots;
  }
}
// Projects the light DOM into the shadow DOM
redistributeNodes(List<Content> contents, List<dynamic> nodes) {
  for (var i = 0; i < contents.length; ++i) {
    var content = contents[i];
    var select = content.select;
    // Empty selector is identical to <content/>
    if (identical(select.length, 0)) {
      content.insert(ListWrapper.clone(nodes));
      ListWrapper.clear(nodes);
    } else {
      var matchSelector = (n) => DOM.elementMatches(n, select);
      var matchingNodes = ListWrapper.filter(nodes, matchSelector);
      content.insert(matchingNodes);
      ListWrapper.removeAll(nodes, matchingNodes);
    }
  }
  for (var i = 0; i < nodes.length; i++) {
    var node = nodes[i];
    if (isPresent(node.parentNode)) {
      DOM.remove(nodes[i]);
    }
  }
}
