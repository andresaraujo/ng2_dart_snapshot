library angular2.src.render.dom.compiler.view_splitter;

import "package:angular2/src/facade/lang.dart"
    show isBlank, isPresent, BaseException, StringWrapper;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/facade/collection.dart"
    show MapWrapper, ListWrapper;
import "package:angular2/src/change_detection/change_detection.dart"
    show Parser;
import "compile_step.dart" show CompileStep;
import "compile_element.dart" show CompileElement;
import "compile_control.dart" show CompileControl;
import "../util.dart" show dashCaseToCamelCase;

/**
 * Splits views at `<template>` elements or elements with `template` attribute:
 * For `<template>` elements:
 * - moves the content into a new and disconnected `<template>` element
 *   that is marked as view root.
 *
 * For elements with a `template` attribute:
 * - replaces the element with an empty `<template>` element,
 *   parses the content of the `template` attribute and adds the information to that
 *   `<template>` element. Marks the elements as view root.
 *
 * Note: In both cases the root of the nested view is disconnected from its parent element.
 * This is needed for browsers that don't support the `<template>` element
 * as we want to do locate elements with bindings using `getElementsByClassName` later on,
 * which should not descend into the nested view.
 */
class ViewSplitter implements CompileStep {
  Parser _parser;
  ViewSplitter(this._parser) {}
  String processStyle(String style) {
    return style;
  }
  processElement(
      CompileElement parent, CompileElement current, CompileControl control) {
    var attrs = current.attrs();
    var templateBindings = attrs["template"];
    var hasTemplateBinding = isPresent(templateBindings);
    // look for template shortcuts such as *ng-if="condition" and treat them as template="if

    // condition"
    MapWrapper.forEach(attrs, (attrValue, attrName) {
      if (StringWrapper.startsWith(attrName, "*")) {
        var key = StringWrapper.substring(attrName, 1);
        if (hasTemplateBinding) {
          // 2nd template binding detected
          throw new BaseException(
              '''Only one template directive per element is allowed: ''' +
                  '''${ templateBindings} and ${ key} cannot be used simultaneously ''' +
                  '''in ${ current . elementDescription}''');
        } else {
          templateBindings =
              (attrValue.length == 0) ? key : key + " " + attrValue;
          hasTemplateBinding = true;
        }
      }
    });
    if (isPresent(parent)) {
      if (DOM.isTemplateElement(current.element)) {
        if (!current.isViewRoot) {
          var viewRoot = new CompileElement(DOM.createTemplate(""));
          viewRoot.inheritedProtoView =
              current.bindElement().bindNestedProtoView(viewRoot.element);
          // viewRoot doesn't appear in the original template, so we associate

          // the current element description to get a more meaningful message in case of error
          viewRoot.elementDescription = current.elementDescription;
          viewRoot.isViewRoot = true;
          this._moveChildNodes(
              DOM.content(current.element), DOM.content(viewRoot.element));
          control.addChild(viewRoot);
        }
      }
      if (hasTemplateBinding) {
        var anchor = new CompileElement(DOM.createTemplate(""));
        anchor.inheritedProtoView = current.inheritedProtoView;
        anchor.inheritedElementBinder = current.inheritedElementBinder;
        anchor.distanceToInheritedBinder = current.distanceToInheritedBinder;
        // newParent doesn't appear in the original template, so we associate

        // the current element description to get a more meaningful message in case of error
        anchor.elementDescription = current.elementDescription;
        var viewRoot = new CompileElement(DOM.createTemplate(""));
        viewRoot.inheritedProtoView =
            anchor.bindElement().bindNestedProtoView(viewRoot.element);
        // viewRoot doesn't appear in the original template, so we associate

        // the current element description to get a more meaningful message in case of error
        viewRoot.elementDescription = current.elementDescription;
        viewRoot.isViewRoot = true;
        current.inheritedProtoView = viewRoot.inheritedProtoView;
        current.inheritedElementBinder = null;
        current.distanceToInheritedBinder = 0;
        this._parseTemplateBindings(templateBindings, anchor);
        DOM.insertBefore(current.element, anchor.element);
        control.addParent(anchor);
        DOM.appendChild(DOM.content(viewRoot.element), current.element);
        control.addParent(viewRoot);
      }
    }
  }
  _moveChildNodes(source, target) {
    var next = DOM.firstChild(source);
    while (isPresent(next)) {
      DOM.appendChild(target, next);
      next = DOM.firstChild(source);
    }
  }
  _parseTemplateBindings(
      String templateBindings, CompileElement compileElement) {
    var bindings = this._parser.parseTemplateBindings(
        templateBindings, compileElement.elementDescription);
    for (var i = 0; i < bindings.length; i++) {
      var binding = bindings[i];
      if (binding.keyIsVar) {
        compileElement.bindElement().bindVariable(
            dashCaseToCamelCase(binding.key), binding.name);
        compileElement.attrs()[binding.key] = binding.name;
      } else if (isPresent(binding.expression)) {
        compileElement.bindElement().bindProperty(
            dashCaseToCamelCase(binding.key), binding.expression);
        compileElement.attrs()[binding.key] = binding.expression.source;
      } else {
        DOM.setAttribute(compileElement.element, binding.key, "");
      }
    }
  }
}
