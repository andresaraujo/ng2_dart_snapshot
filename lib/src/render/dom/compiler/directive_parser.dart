library angular2.src.render.dom.compiler.directive_parser;

import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, BaseException, StringWrapper;
import "package:angular2/src/facade/collection.dart"
    show List, MapWrapper, ListWrapper;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/change_detection/change_detection.dart"
    show Parser;
import "package:angular2/src/render/dom/compiler/selector.dart"
    show SelectorMatcher, CssSelector;
import "compile_step.dart" show CompileStep;
import "compile_element.dart" show CompileElement;
import "compile_control.dart" show CompileControl;
import "../../api.dart" show DirectiveMetadata;
import "../util.dart"
    show dashCaseToCamelCase, camelCaseToDashCase, EVENT_TARGET_SEPARATOR;
import "../view/proto_view_builder.dart"
    show DirectiveBuilder, ElementBinderBuilder;

/**
 * Parses the directives on a single element. Assumes ViewSplitter has already created
 * <template> elements for template directives.
 */
class DirectiveParser implements CompileStep {
  Parser _parser;
  List<DirectiveMetadata> _directives;
  SelectorMatcher _selectorMatcher = new SelectorMatcher();
  DirectiveParser(this._parser, this._directives) {
    for (var i = 0; i < _directives.length; i++) {
      var directive = _directives[i];
      var selector = CssSelector.parse(directive.selector);
      this._ensureComponentOnlyHasElementSelector(selector, directive);
      this._selectorMatcher.addSelectables(selector, i);
    }
  }
  String processStyle(String style) {
    return style;
  }
  _ensureComponentOnlyHasElementSelector(selector, directive) {
    var isElementSelector =
        identical(selector.length, 1) && selector[0].isElementSelector();
    if (!isElementSelector &&
        identical(directive.type, DirectiveMetadata.COMPONENT_TYPE)) {
      throw new BaseException(
          '''Component \'${ directive . id}\' can only have an element selector, but had \'${ directive . selector}\'''');
    }
  }
  processElement(
      CompileElement parent, CompileElement current, CompileControl control) {
    var attrs = current.attrs();
    var classList = current.classList();
    var cssSelector = new CssSelector();
    var foundDirectiveIndices = [];
    ElementBinderBuilder elementBinder = null;
    cssSelector.setElement(DOM.nodeName(current.element));
    for (var i = 0; i < classList.length; i++) {
      cssSelector.addClassName(classList[i]);
    }
    MapWrapper.forEach(attrs, (attrValue, attrName) {
      cssSelector.addAttribute(attrName, attrValue);
    });
    this._selectorMatcher.match(cssSelector, (selector, directiveIndex) {
      var directive = this._directives[directiveIndex];
      elementBinder = current.bindElement();
      if (identical(directive.type, DirectiveMetadata.COMPONENT_TYPE)) {
        this._ensureHasOnlyOneComponent(
            elementBinder, current.elementDescription);
        // components need to go first, so it is easier to locate them in the result.
        ListWrapper.insert(foundDirectiveIndices, 0, directiveIndex);
        elementBinder.setComponentId(directive.id);
      } else {
        foundDirectiveIndices.add(directiveIndex);
      }
    });
    ListWrapper.forEach(foundDirectiveIndices, (directiveIndex) {
      var dirMetadata = this._directives[directiveIndex];
      var directiveBinderBuilder = elementBinder.bindDirective(directiveIndex);
      current.compileChildren =
          current.compileChildren && dirMetadata.compileChildren;
      if (isPresent(dirMetadata.properties)) {
        ListWrapper.forEach(dirMetadata.properties, (bindConfig) {
          this._bindDirectiveProperty(
              bindConfig, current, directiveBinderBuilder);
        });
      }
      if (isPresent(dirMetadata.hostListeners)) {
        this._sortedKeysForEach(dirMetadata.hostListeners, (action, eventName) {
          this._bindDirectiveEvent(
              eventName, action, current, directiveBinderBuilder);
        });
      }
      if (isPresent(dirMetadata.hostProperties)) {
        this._sortedKeysForEach(dirMetadata.hostProperties,
            (expression, hostPropertyName) {
          this._bindHostProperty(
              hostPropertyName, expression, current, directiveBinderBuilder);
        });
      }
      if (isPresent(dirMetadata.hostAttributes)) {
        this._sortedKeysForEach(dirMetadata.hostAttributes,
            (hostAttrValue, hostAttrName) {
          this._addHostAttribute(hostAttrName, hostAttrValue, current);
        });
      }
      if (isPresent(dirMetadata.readAttributes)) {
        ListWrapper.forEach(dirMetadata.readAttributes, (attrName) {
          elementBinder.readAttribute(attrName);
        });
      }
    });
  }
  void _sortedKeysForEach(Map<String, String> map,
      dynamic /* (value: string, key: string) => void */ fn) {
    var keys = MapWrapper.keys(map);
    ListWrapper.sort(keys, (a, b) {
      // Ensure a stable sort.
      var compareVal = StringWrapper.compare(a, b);
      return compareVal == 0 ? -1 : compareVal;
    });
    ListWrapper.forEach(keys, (key) {
      fn(MapWrapper.get(map, key), key);
    });
  }
  void _ensureHasOnlyOneComponent(
      ElementBinderBuilder elementBinder, String elDescription) {
    if (isPresent(elementBinder.componentId)) {
      throw new BaseException(
          '''Only one component directive is allowed per element - check ${ elDescription}''');
    }
  }
  _bindDirectiveProperty(String bindConfig, CompileElement compileElement,
      DirectiveBuilder directiveBinderBuilder) {
    // Name of the property on the directive
    String dirProperty;
    // Name of the property on the element
    String elProp;
    List<String> pipes;
    num assignIndex = bindConfig.indexOf(":");
    if (assignIndex > -1) {
      // canonical syntax: `dirProp: elProp | pipe0 | ... | pipeN`
      dirProperty = StringWrapper.substring(bindConfig, 0, assignIndex).trim();
      pipes = this._splitBindConfig(
          StringWrapper.substring(bindConfig, assignIndex + 1));
      elProp = ListWrapper.removeAt(pipes, 0);
    } else {
      // shorthand syntax when the name of the property on the directive and on the element is the

      // same, ie `property`
      dirProperty = bindConfig;
      elProp = bindConfig;
      pipes = [];
    }
    elProp = dashCaseToCamelCase(elProp);
    var bindingAst = compileElement.bindElement().propertyBindings[elProp];
    if (isBlank(bindingAst)) {
      var attributeValue = compileElement.attrs()[camelCaseToDashCase(elProp)];
      if (isPresent(attributeValue)) {
        bindingAst = this._parser.wrapLiteralPrimitive(
            attributeValue, compileElement.elementDescription);
      }
    }
    // Bindings are optional, so this binding only needs to be set up if an expression is given.
    if (isPresent(bindingAst)) {
      directiveBinderBuilder.bindProperty(dirProperty, bindingAst, elProp);
    }
  }
  _bindDirectiveEvent(
      eventName, action, compileElement, directiveBinderBuilder) {
    var ast =
        this._parser.parseAction(action, compileElement.elementDescription);
    if (StringWrapper.contains(eventName, EVENT_TARGET_SEPARATOR)) {
      var parts = eventName.split(EVENT_TARGET_SEPARATOR);
      directiveBinderBuilder.bindEvent(parts[1], ast, parts[0]);
    } else {
      directiveBinderBuilder.bindEvent(eventName, ast);
    }
  }
  _bindHostProperty(
      hostPropertyName, expression, compileElement, directiveBinderBuilder) {
    var ast = this._parser.parseSimpleBinding(expression,
        '''hostProperties of ${ compileElement . elementDescription}''');
    directiveBinderBuilder.bindHostProperty(hostPropertyName, ast);
  }
  _addHostAttribute(attrName, attrValue, compileElement) {
    if (StringWrapper.equals(attrName, "class")) {
      ListWrapper.forEach(attrValue.split(" "), (className) {
        DOM.addClass(compileElement.element, className);
      });
    } else if (!DOM.hasAttribute(compileElement.element, attrName)) {
      DOM.setAttribute(compileElement.element, attrName, attrValue);
    }
  }
  _splitBindConfig(String bindConfig) {
    return ListWrapper.map(bindConfig.split("|"), (s) => s.trim());
  }
}
