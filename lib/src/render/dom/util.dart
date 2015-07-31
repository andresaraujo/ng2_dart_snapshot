library angular2.src.render.dom.util;

import "package:angular2/src/facade/lang.dart"
    show StringWrapper, isPresent, isBlank;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/facade/collection.dart" show ListWrapper;
import "view/proto_view.dart" show DomProtoView;
import "view/element_binder.dart" show DomElementBinder;
import "template_cloner.dart" show TemplateCloner;

const NG_BINDING_CLASS_SELECTOR = ".ng-binding";
const NG_BINDING_CLASS = "ng-binding";
const EVENT_TARGET_SEPARATOR = ":";
const NG_CONTENT_ELEMENT_NAME = "ng-content";
const NG_SHADOW_ROOT_ELEMENT_NAME = "shadow-root";
const MAX_IN_MEMORY_ELEMENTS_PER_TEMPLATE = 20;
var CAMEL_CASE_REGEXP = new RegExp(r'([A-Z])');
var DASH_CASE_REGEXP = new RegExp(r'-([a-z])');
String camelCaseToDashCase(String input) {
  return StringWrapper.replaceAllMapped(input, CAMEL_CASE_REGEXP, (m) {
    return "-" + m[1].toLowerCase();
  });
}
String dashCaseToCamelCase(String input) {
  return StringWrapper.replaceAllMapped(input, DASH_CASE_REGEXP, (m) {
    return m[1].toUpperCase();
  });
}
// Attention: This is on the hot path, so don't use closures or default values!
List<dynamic> queryBoundElements(
    dynamic templateContent, bool isSingleElementChild) {
  var result;
  var dynamicElementList;
  var elementIdx = 0;
  if (isSingleElementChild) {
    var rootElement = DOM.firstChild(templateContent);
    var rootHasBinding = DOM.hasClass(rootElement, NG_BINDING_CLASS);
    dynamicElementList =
        DOM.getElementsByClassName(rootElement, NG_BINDING_CLASS);
    result = ListWrapper
        .createFixedSize(dynamicElementList.length + (rootHasBinding ? 1 : 0));
    if (rootHasBinding) {
      result[elementIdx++] = rootElement;
    }
  } else {
    dynamicElementList =
        DOM.querySelectorAll(templateContent, NG_BINDING_CLASS_SELECTOR);
    result = ListWrapper.createFixedSize(dynamicElementList.length);
  }
  for (var i = 0; i < dynamicElementList.length; i++) {
    result[elementIdx++] = dynamicElementList[i];
  }
  return result;
}
class ClonedProtoView {
  DomProtoView original;
  List<List<dynamic>> fragments;
  List<dynamic> boundElements;
  List<dynamic> boundTextNodes;
  ClonedProtoView(
      this.original, this.fragments, this.boundElements, this.boundTextNodes) {}
}
ClonedProtoView cloneAndQueryProtoView(
    TemplateCloner templateCloner, DomProtoView pv, bool importIntoDocument) {
  var templateContent =
      templateCloner.cloneContent(pv.cloneableTemplate, importIntoDocument);
  var boundElements =
      queryBoundElements(templateContent, pv.isSingleElementFragment);
  var boundTextNodes = queryBoundTextNodes(templateContent,
      pv.rootTextNodeIndices, boundElements, pv.elementBinders,
      pv.boundTextNodeCount);
  var fragments = queryFragments(templateContent, pv.fragmentsRootNodeCount);
  return new ClonedProtoView(pv, fragments, boundElements, boundTextNodes);
}
List<List<dynamic>> queryFragments(
    dynamic templateContent, List<num> fragmentsRootNodeCount) {
  var fragments = ListWrapper.createGrowableSize(fragmentsRootNodeCount.length);
  // Note: An explicit loop is the fastest way to convert a DOM array into a JS array!
  var childNode = DOM.firstChild(templateContent);
  for (var fragmentIndex = 0;
      fragmentIndex < fragments.length;
      fragmentIndex++) {
    var fragment =
        ListWrapper.createFixedSize(fragmentsRootNodeCount[fragmentIndex]);
    fragments[fragmentIndex] = fragment;
    // Note: the 2nd, 3rd, ... fragments are separated by each other via a '|'
    if (fragmentIndex >= 1) {
      childNode = DOM.nextSibling(childNode);
    }
    for (var i = 0; i < fragment.length; i++) {
      fragment[i] = childNode;
      childNode = DOM.nextSibling(childNode);
    }
  }
  return fragments;
}
List<dynamic> queryBoundTextNodes(dynamic templateContent,
    List<num> rootTextNodeIndices, List<dynamic> boundElements,
    List<DomElementBinder> elementBinders, num boundTextNodeCount) {
  var boundTextNodes = ListWrapper.createFixedSize(boundTextNodeCount);
  var textNodeIndex = 0;
  if (rootTextNodeIndices.length > 0) {
    var rootChildNodes = DOM.childNodes(templateContent);
    for (var i = 0; i < rootTextNodeIndices.length; i++) {
      boundTextNodes[textNodeIndex++] = rootChildNodes[rootTextNodeIndices[i]];
    }
  }
  for (var i = 0; i < elementBinders.length; i++) {
    var binder = elementBinders[i];
    dynamic element = boundElements[i];
    if (binder.textNodeIndices.length > 0) {
      var childNodes = DOM.childNodes(element);
      for (var j = 0; j < binder.textNodeIndices.length; j++) {
        boundTextNodes[textNodeIndex++] = childNodes[binder.textNodeIndices[j]];
      }
    }
  }
  return boundTextNodes;
}
bool isElementWithTag(dynamic node, String elementName) {
  return DOM.isElementNode(node) &&
      DOM.tagName(node).toLowerCase() == elementName.toLowerCase();
}
queryBoundTextNodeIndices(dynamic parentNode,
    Map<dynamic, dynamic> boundTextNodes, Function resultCallback) {
  var childNodes = DOM.childNodes(parentNode);
  for (var j = 0; j < childNodes.length; j++) {
    var node = childNodes[j];
    if (boundTextNodes.containsKey(node)) {
      resultCallback(node, j, boundTextNodes[node]);
    }
  }
}
prependAll(dynamic parentNode, List<dynamic> nodes) {
  var lastInsertedNode = null;
  nodes.forEach((node) {
    if (isBlank(lastInsertedNode)) {
      var firstChild = DOM.firstChild(parentNode);
      if (isPresent(firstChild)) {
        DOM.insertBefore(firstChild, node);
      } else {
        DOM.appendChild(parentNode, node);
      }
    } else {
      DOM.insertAfter(lastInsertedNode, node);
    }
    lastInsertedNode = node;
  });
}
