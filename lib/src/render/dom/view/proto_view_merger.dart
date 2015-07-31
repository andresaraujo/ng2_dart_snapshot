library angular2.src.render.dom.view.proto_view_merger;

import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, BaseException, isArray;
import "package:angular2/src/facade/collection.dart"
    show ListWrapper, SetWrapper, MapWrapper;
import "proto_view.dart"
    show DomProtoView, DomProtoViewRef, resolveInternalDomProtoView;
import "element_binder.dart" show DomElementBinder;
import "../../api.dart"
    show
        RenderProtoViewMergeMapping,
        RenderProtoViewRef,
        ViewType,
        ViewEncapsulation;
import "../util.dart"
    show
        NG_BINDING_CLASS,
        NG_CONTENT_ELEMENT_NAME,
        ClonedProtoView,
        cloneAndQueryProtoView,
        queryBoundElements,
        queryBoundTextNodeIndices,
        NG_SHADOW_ROOT_ELEMENT_NAME,
        isElementWithTag,
        prependAll;
import "../template_cloner.dart" show TemplateCloner;

RenderProtoViewMergeMapping mergeProtoViewsRecursively(
    TemplateCloner templateCloner,
    List<dynamic /* RenderProtoViewRef | List < dynamic > */ > protoViewRefs) {
  // clone
  var clonedProtoViews = [];
  List<List<num>> hostViewAndBinderIndices = [];
  cloneProtoViews(templateCloner, protoViewRefs, clonedProtoViews,
      hostViewAndBinderIndices);
  ClonedProtoView mainProtoView = clonedProtoViews[0];
  // modify the DOM
  mergeEmbeddedPvsIntoComponentOrRootPv(
      clonedProtoViews, hostViewAndBinderIndices);
  var fragments = [];
  Set<dynamic> elementsWithNativeShadowRoot = new Set();
  mergeComponents(clonedProtoViews, hostViewAndBinderIndices, fragments,
      elementsWithNativeShadowRoot);
  // Note: Need to remark parent elements of bound text nodes

  // so that we can find them later via queryBoundElements!
  markBoundTextNodeParentsAsBoundElements(clonedProtoViews);
  // create a new root element with the changed fragments and elements
  var fragmentsRootNodeCount =
      fragments.map((fragment) => fragment.length).toList();
  var rootElement = createRootElementFromFragments(fragments);
  var rootNode = DOM.content(rootElement);
  // read out the new element / text node / ElementBinder order
  var mergedBoundElements = queryBoundElements(rootNode, false);
  Map<dynamic, num> mergedBoundTextIndices = new Map();
  Map<dynamic, dynamic> boundTextNodeMap =
      indexBoundTextNodes(clonedProtoViews);
  var rootTextNodeIndices = calcRootTextNodeIndices(
      rootNode, boundTextNodeMap, mergedBoundTextIndices);
  var mergedElementBinders = calcElementBinders(clonedProtoViews,
      mergedBoundElements, elementsWithNativeShadowRoot, boundTextNodeMap,
      mergedBoundTextIndices);
  // create element / text index mappings
  var mappedElementIndices =
      calcMappedElementIndices(clonedProtoViews, mergedBoundElements);
  var mappedTextIndices =
      calcMappedTextIndices(clonedProtoViews, mergedBoundTextIndices);
  // create result
  var hostElementIndicesByViewIndex = calcHostElementIndicesByViewIndex(
      clonedProtoViews, hostViewAndBinderIndices);
  var nestedViewCounts = calcNestedViewCounts(hostViewAndBinderIndices);
  var mergedProtoView = DomProtoView.create(templateCloner,
      mainProtoView.original.type, rootElement,
      mainProtoView.original.encapsulation, fragmentsRootNodeCount,
      rootTextNodeIndices, mergedElementBinders, new Map());
  return new RenderProtoViewMergeMapping(new DomProtoViewRef(mergedProtoView),
      fragmentsRootNodeCount.length, mappedElementIndices,
      mergedBoundElements.length, mappedTextIndices,
      hostElementIndicesByViewIndex, nestedViewCounts);
}
cloneProtoViews(TemplateCloner templateCloner,
    List<dynamic /* RenderProtoViewRef | List < dynamic > */ > protoViewRefs,
    List<ClonedProtoView> targetClonedProtoViews,
    List<List<num>> targetHostViewAndBinderIndices) {
  var hostProtoView = resolveInternalDomProtoView(protoViewRefs[0]);
  var hostPvIdx = targetClonedProtoViews.length;
  targetClonedProtoViews
      .add(cloneAndQueryProtoView(templateCloner, hostProtoView, false));
  if (identical(targetHostViewAndBinderIndices.length, 0)) {
    targetHostViewAndBinderIndices.add([null, null]);
  }
  var protoViewIdx = 1;
  for (var i = 0; i < hostProtoView.elementBinders.length; i++) {
    var binder = hostProtoView.elementBinders[i];
    if (binder.hasNestedProtoView) {
      var nestedEntry = protoViewRefs[protoViewIdx++];
      if (isPresent(nestedEntry)) {
        targetHostViewAndBinderIndices.add([hostPvIdx, i]);
        if (isArray(nestedEntry)) {
          cloneProtoViews(templateCloner, (nestedEntry as List<dynamic>),
              targetClonedProtoViews, targetHostViewAndBinderIndices);
        } else {
          targetClonedProtoViews.add(cloneAndQueryProtoView(
              templateCloner, resolveInternalDomProtoView(nestedEntry), false));
        }
      }
    }
  }
}
markBoundTextNodeParentsAsBoundElements(
    List<ClonedProtoView> mergableProtoViews) {
  mergableProtoViews.forEach((mergableProtoView) {
    mergableProtoView.boundTextNodes.forEach((textNode) {
      var parentNode = textNode.parentNode;
      if (isPresent(parentNode) && DOM.isElementNode(parentNode)) {
        DOM.addClass(parentNode, NG_BINDING_CLASS);
      }
    });
  });
}
Map<dynamic, dynamic> indexBoundTextNodes(
    List<ClonedProtoView> mergableProtoViews) {
  var boundTextNodeMap = new Map();
  for (var pvIndex = 0; pvIndex < mergableProtoViews.length; pvIndex++) {
    var mergableProtoView = mergableProtoViews[pvIndex];
    mergableProtoView.boundTextNodes.forEach((textNode) {
      boundTextNodeMap[textNode] = null;
    });
  }
  return boundTextNodeMap;
}
mergeEmbeddedPvsIntoComponentOrRootPv(List<ClonedProtoView> clonedProtoViews,
    List<List<num>> hostViewAndBinderIndices) {
  var nearestHostComponentOrRootPvIndices =
      calcNearestHostComponentOrRootPvIndices(
          clonedProtoViews, hostViewAndBinderIndices);
  for (var viewIdx = 1; viewIdx < clonedProtoViews.length; viewIdx++) {
    var clonedProtoView = clonedProtoViews[viewIdx];
    if (identical(clonedProtoView.original.type, ViewType.EMBEDDED)) {
      var hostComponentIdx = nearestHostComponentOrRootPvIndices[viewIdx];
      var hostPv = clonedProtoViews[hostComponentIdx];
      clonedProtoView.fragments
          .forEach((fragment) => hostPv.fragments.add(fragment));
    }
  }
}
List<num> calcNearestHostComponentOrRootPvIndices(
    List<ClonedProtoView> clonedProtoViews,
    List<List<num>> hostViewAndBinderIndices) {
  var nearestHostComponentOrRootPvIndices =
      ListWrapper.createFixedSize(clonedProtoViews.length);
  nearestHostComponentOrRootPvIndices[0] = null;
  for (var viewIdx = 1; viewIdx < hostViewAndBinderIndices.length; viewIdx++) {
    var hostViewIdx = hostViewAndBinderIndices[viewIdx][0];
    var hostProtoView = clonedProtoViews[hostViewIdx];
    if (identical(hostViewIdx, 0) ||
        identical(hostProtoView.original.type, ViewType.COMPONENT)) {
      nearestHostComponentOrRootPvIndices[viewIdx] = hostViewIdx;
    } else {
      nearestHostComponentOrRootPvIndices[viewIdx] =
          nearestHostComponentOrRootPvIndices[hostViewIdx];
    }
  }
  return nearestHostComponentOrRootPvIndices;
}
mergeComponents(List<ClonedProtoView> clonedProtoViews,
    List<List<num>> hostViewAndBinderIndices,
    List<List<dynamic>> targetFragments,
    Set<dynamic> targetElementsWithNativeShadowRoot) {
  var hostProtoView = clonedProtoViews[0];
  hostProtoView.fragments.forEach((fragment) => targetFragments.add(fragment));
  for (var viewIdx = 1; viewIdx < clonedProtoViews.length; viewIdx++) {
    var hostViewIdx = hostViewAndBinderIndices[viewIdx][0];
    var hostBinderIdx = hostViewAndBinderIndices[viewIdx][1];
    var hostProtoView = clonedProtoViews[hostViewIdx];
    var clonedProtoView = clonedProtoViews[viewIdx];
    if (identical(clonedProtoView.original.type, ViewType.COMPONENT)) {
      mergeComponent(hostProtoView, hostBinderIdx, clonedProtoView,
          targetFragments, targetElementsWithNativeShadowRoot);
    }
  }
}
mergeComponent(ClonedProtoView hostProtoView, num binderIdx,
    ClonedProtoView nestedProtoView, List<List<dynamic>> targetFragments,
    Set<dynamic> targetElementsWithNativeShadowRoot) {
  var hostElement = hostProtoView.boundElements[binderIdx];
  // We wrap the fragments into elements so that we can expand <ng-content>

  // even for root nodes in the fragment without special casing them.
  var fragmentElements = mapFragmentsIntoElements(nestedProtoView.fragments);
  var contentElements = findContentElements(fragmentElements);
  var projectableNodes = DOM.childNodesAsList(hostElement);
  for (var i = 0; i < contentElements.length; i++) {
    var contentElement = contentElements[i];
    var select = DOM.getAttribute(contentElement, "select");
    projectableNodes =
        projectMatchingNodes(select, contentElement, projectableNodes);
  }
  // unwrap the fragment elements into arrays of nodes after projecting
  var fragments = extractFragmentNodesFromElements(fragmentElements);
  var useNativeShadowRoot = identical(
      nestedProtoView.original.encapsulation, ViewEncapsulation.NATIVE);
  if (useNativeShadowRoot) {
    targetElementsWithNativeShadowRoot.add(hostElement);
  }
  MapWrapper.forEach(nestedProtoView.original.hostAttributes,
      (attrValue, attrName) {
    DOM.setAttribute(hostElement, attrName, attrValue);
  });
  appendComponentNodesToHost(
      hostProtoView, binderIdx, fragments[0], useNativeShadowRoot);
  for (var i = 1; i < fragments.length; i++) {
    targetFragments.add(fragments[i]);
  }
}
List<dynamic> mapFragmentsIntoElements(List<List<dynamic>> fragments) {
  return fragments.map((fragment) {
    var fragmentElement = DOM.createTemplate("");
    fragment
        .forEach((node) => DOM.appendChild(DOM.content(fragmentElement), node));
    return fragmentElement;
  }).toList();
}
List<List<dynamic>> extractFragmentNodesFromElements(
    List<dynamic> fragmentElements) {
  return fragmentElements.map((fragmentElement) {
    return DOM.childNodesAsList(DOM.content(fragmentElement));
  }).toList();
}
List<dynamic> findContentElements(List<dynamic> fragmentElements) {
  var contentElements = [];
  fragmentElements.forEach((dynamic fragmentElement) {
    var fragmentContentElements = DOM.querySelectorAll(
        DOM.content(fragmentElement), NG_CONTENT_ELEMENT_NAME);
    for (var i = 0; i < fragmentContentElements.length; i++) {
      contentElements.add(fragmentContentElements[i]);
    }
  });
  return sortContentElements(contentElements);
}
appendComponentNodesToHost(ClonedProtoView hostProtoView, num binderIdx,
    List<dynamic> componentRootNodes, bool useNativeShadowRoot) {
  var hostElement = hostProtoView.boundElements[binderIdx];
  if (useNativeShadowRoot) {
    var shadowRootWrapper = DOM.createElement(NG_SHADOW_ROOT_ELEMENT_NAME);
    for (var i = 0; i < componentRootNodes.length; i++) {
      DOM.appendChild(shadowRootWrapper, componentRootNodes[i]);
    }
    var firstChild = DOM.firstChild(hostElement);
    if (isPresent(firstChild)) {
      DOM.insertBefore(firstChild, shadowRootWrapper);
    } else {
      DOM.appendChild(hostElement, shadowRootWrapper);
    }
  } else {
    DOM.clearNodes(hostElement);
    for (var i = 0; i < componentRootNodes.length; i++) {
      DOM.appendChild(hostElement, componentRootNodes[i]);
    }
  }
}
List<dynamic> projectMatchingNodes(
    String selector, dynamic contentElement, List<dynamic> nodes) {
  var remaining = [];
  DOM.insertBefore(contentElement, DOM.createComment("["));
  for (var i = 0; i < nodes.length; i++) {
    var node = nodes[i];
    var matches = false;
    if (isWildcard(selector)) {
      matches = true;
    } else if (DOM.isElementNode(node) && DOM.elementMatches(node, selector)) {
      matches = true;
    }
    if (matches) {
      DOM.insertBefore(contentElement, node);
    } else {
      remaining.add(node);
    }
  }
  DOM.insertBefore(contentElement, DOM.createComment("]"));
  DOM.remove(contentElement);
  return remaining;
}
bool isWildcard(selector) {
  return isBlank(selector) || identical(selector.length, 0) || selector == "*";
}
// we need to sort content elements as they can originate from

// different sub views
List<dynamic> sortContentElements(List<dynamic> contentElements) {
  // for now, only move the wildcard selector to the end.

  // TODO(tbosch): think about sorting by selector specifity...
  var firstWildcard = null;
  var sorted = [];
  contentElements.forEach((contentElement) {
    var select = DOM.getAttribute(contentElement, "select");
    if (isWildcard(select)) {
      if (isBlank(firstWildcard)) {
        firstWildcard = contentElement;
      }
    } else {
      sorted.add(contentElement);
    }
  });
  if (isPresent(firstWildcard)) {
    sorted.add(firstWildcard);
  }
  return sorted;
}
dynamic createRootElementFromFragments(List<List<dynamic>> fragments) {
  var rootElement = DOM.createTemplate("");
  var rootNode = DOM.content(rootElement);
  for (var i = 0; i < fragments.length; i++) {
    var fragment = fragments[i];
    if (i >= 1) {
      // Note: We need to seprate fragments by a comment so that sibling

      // text nodes don't get merged when we serialize the DomProtoView into a string

      // and parse it back again.
      DOM.appendChild(rootNode, DOM.createComment("|"));
    }
    fragment.forEach((node) {
      DOM.appendChild(rootNode, node);
    });
  }
  return rootElement;
}
List<num> calcRootTextNodeIndices(dynamic rootNode,
    Map<dynamic, dynamic> boundTextNodes,
    Map<dynamic, num> targetBoundTextIndices) {
  var rootTextNodeIndices = [];
  queryBoundTextNodeIndices(rootNode, boundTextNodes, (textNode, nodeIndex, _) {
    rootTextNodeIndices.add(nodeIndex);
    targetBoundTextIndices[textNode] = targetBoundTextIndices.length;
  });
  return rootTextNodeIndices;
}
List<DomElementBinder> calcElementBinders(
    List<ClonedProtoView> clonedProtoViews, List<dynamic> mergedBoundElements,
    Set<dynamic> elementsWithNativeShadowRoot,
    Map<dynamic, dynamic> boundTextNodes,
    Map<dynamic, num> targetBoundTextIndices) {
  Map<dynamic, DomElementBinder> elementBinderByElement =
      indexElementBindersByElement(clonedProtoViews);
  var mergedElementBinders = [];
  for (var i = 0; i < mergedBoundElements.length; i++) {
    var element = mergedBoundElements[i];
    var textNodeIndices = [];
    queryBoundTextNodeIndices(element, boundTextNodes,
        (textNode, nodeIndex, _) {
      textNodeIndices.add(nodeIndex);
      targetBoundTextIndices[textNode] = targetBoundTextIndices.length;
    });
    mergedElementBinders.add(updateElementBinders(
        elementBinderByElement[element], textNodeIndices,
        SetWrapper.has(elementsWithNativeShadowRoot, element)));
  }
  return mergedElementBinders;
}
Map<dynamic, DomElementBinder> indexElementBindersByElement(
    List<ClonedProtoView> mergableProtoViews) {
  var elementBinderByElement = new Map();
  mergableProtoViews.forEach((mergableProtoView) {
    for (var i = 0; i < mergableProtoView.boundElements.length; i++) {
      var el = mergableProtoView.boundElements[i];
      if (isPresent(el)) {
        elementBinderByElement[el] =
            mergableProtoView.original.elementBinders[i];
      }
    }
  });
  return elementBinderByElement;
}
DomElementBinder updateElementBinders(DomElementBinder elementBinder,
    List<num> textNodeIndices, bool hasNativeShadowRoot) {
  var result;
  if (isBlank(elementBinder)) {
    result = new DomElementBinder(
        textNodeIndices: textNodeIndices,
        hasNestedProtoView: false,
        eventLocals: null,
        localEvents: [],
        globalEvents: [],
        hasNativeShadowRoot: false);
  } else {
    result = new DomElementBinder(
        textNodeIndices: textNodeIndices,
        hasNestedProtoView: false,
        eventLocals: elementBinder.eventLocals,
        localEvents: elementBinder.localEvents,
        globalEvents: elementBinder.globalEvents,
        hasNativeShadowRoot: hasNativeShadowRoot);
  }
  return result;
}
List<num> calcMappedElementIndices(
    List<ClonedProtoView> clonedProtoViews, List<dynamic> mergedBoundElements) {
  Map<dynamic, num> mergedBoundElementIndices = indexArray(mergedBoundElements);
  var mappedElementIndices = [];
  clonedProtoViews.forEach((clonedProtoView) {
    clonedProtoView.boundElements.forEach((boundElement) {
      var mappedElementIndex = mergedBoundElementIndices[boundElement];
      mappedElementIndices.add(mappedElementIndex);
    });
  });
  return mappedElementIndices;
}
List<num> calcMappedTextIndices(List<ClonedProtoView> clonedProtoViews,
    Map<dynamic, num> mergedBoundTextIndices) {
  var mappedTextIndices = [];
  clonedProtoViews.forEach((clonedProtoView) {
    clonedProtoView.boundTextNodes.forEach((textNode) {
      var mappedTextIndex = mergedBoundTextIndices[textNode];
      mappedTextIndices.add(mappedTextIndex);
    });
  });
  return mappedTextIndices;
}
List<num> calcHostElementIndicesByViewIndex(
    List<ClonedProtoView> clonedProtoViews,
    List<List<num>> hostViewAndBinderIndices) {
  var hostElementIndices = [null];
  var viewElementOffsets = [0];
  var elementIndex = clonedProtoViews[0].original.elementBinders.length;
  for (var viewIdx = 1; viewIdx < hostViewAndBinderIndices.length; viewIdx++) {
    viewElementOffsets.add(elementIndex);
    elementIndex += clonedProtoViews[viewIdx].original.elementBinders.length;
    var hostViewIdx = hostViewAndBinderIndices[viewIdx][0];
    var hostBinderIdx = hostViewAndBinderIndices[viewIdx][1];
    hostElementIndices.add(viewElementOffsets[hostViewIdx] + hostBinderIdx);
  }
  return hostElementIndices;
}
List<num> calcNestedViewCounts(List<List<num>> hostViewAndBinderIndices) {
  var nestedViewCounts =
      ListWrapper.createFixedSize(hostViewAndBinderIndices.length);
  ListWrapper.fill(nestedViewCounts, 0);
  for (var viewIdx = hostViewAndBinderIndices.length - 1;
      viewIdx >= 1;
      viewIdx--) {
    var hostViewAndElementIdx = hostViewAndBinderIndices[viewIdx];
    if (isPresent(hostViewAndElementIdx)) {
      nestedViewCounts[hostViewAndElementIdx[0]] +=
          nestedViewCounts[viewIdx] + 1;
    }
  }
  return nestedViewCounts;
}
Map<dynamic, num> indexArray(List<dynamic> arr) {
  var map = new Map();
  for (var i = 0; i < arr.length; i++) {
    map[arr[i]] = i;
  }
  return map;
}
