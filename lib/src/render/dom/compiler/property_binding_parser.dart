library angular2.src.render.dom.compiler.property_binding_parser;

import "package:angular2/src/facade/lang.dart"
    show isPresent, RegExpWrapper, StringWrapper;
import "package:angular2/src/facade/collection.dart" show MapWrapper;
import "package:angular2/change_detection.dart" show Parser;
import "compile_step.dart" show CompileStep;
import "compile_element.dart" show CompileElement;
import "compile_control.dart" show CompileControl;
import "../util.dart" show dashCaseToCamelCase;
// Group 1 = "bind-"

// Group 2 = "var-" or "#"

// Group 3 = "on-"

// Group 4 = "bindon-"

// Group 5 = the identifier after "bind-", "var-/#", or "on-"

// Group 6 = idenitifer inside [()]

// Group 7 = idenitifer inside []

// Group 8 = identifier inside ()
var BIND_NAME_REGEXP = new RegExp(
    r'^(?:(?:(?:(bind-)|(var-|#)|(on-)|(bindon-))(.+))|\[\(([^\)]+)\)\]|\[([^\]]+)\]|\(([^\)]+)\))$');
/**
 * Parses the property bindings on a single element.
 */
class PropertyBindingParser implements CompileStep {
  Parser _parser;
  PropertyBindingParser(this._parser) {}
  process(
      CompileElement parent, CompileElement current, CompileControl control) {
    var attrs = current.attrs();
    var newAttrs = new Map();
    MapWrapper.forEach(attrs, (attrValue, attrName) {
      attrName = this._normalizeAttributeName(attrName);
      var bindParts = RegExpWrapper.firstMatch(BIND_NAME_REGEXP, attrName);
      if (isPresent(bindParts)) {
        if (isPresent(bindParts[1])) {
          this._bindProperty(bindParts[5], attrValue, current, newAttrs);
        } else if (isPresent(bindParts[2])) {
          var identifier = bindParts[5];
          var value = attrValue == "" ? "\$implicit" : attrValue;
          this._bindVariable(identifier, value, current, newAttrs);
        } else if (isPresent(bindParts[3])) {
          this._bindEvent(bindParts[5], attrValue, current, newAttrs);
        } else if (isPresent(bindParts[4])) {
          this._bindProperty(bindParts[5], attrValue, current, newAttrs);
          this._bindAssignmentEvent(bindParts[5], attrValue, current, newAttrs);
        } else if (isPresent(bindParts[6])) {
          this._bindProperty(bindParts[6], attrValue, current, newAttrs);
          this._bindAssignmentEvent(bindParts[6], attrValue, current, newAttrs);
        } else if (isPresent(bindParts[7])) {
          this._bindProperty(bindParts[7], attrValue, current, newAttrs);
        } else if (isPresent(bindParts[8])) {
          this._bindEvent(bindParts[8], attrValue, current, newAttrs);
        }
      } else {
        var expr = this._parser.parseInterpolation(
            attrValue, current.elementDescription);
        if (isPresent(expr)) {
          this._bindPropertyAst(attrName, expr, current, newAttrs);
        }
      }
    });
    MapWrapper.forEach(newAttrs, (attrValue, attrName) {
      attrs[attrName] = attrValue;
    });
  }
  String _normalizeAttributeName(String attrName) {
    return StringWrapper.startsWith(attrName, "data-")
        ? StringWrapper.substring(attrName, 5)
        : attrName;
  }
  _bindVariable(identifier, value, CompileElement current,
      Map<dynamic, dynamic> newAttrs) {
    current.bindElement().bindVariable(dashCaseToCamelCase(identifier), value);
    newAttrs[identifier] = value;
  }
  _bindProperty(name, expression, CompileElement current, newAttrs) {
    this._bindPropertyAst(name,
        this._parser.parseBinding(expression, current.elementDescription),
        current, newAttrs);
  }
  _bindPropertyAst(
      name, ast, CompileElement current, Map<dynamic, dynamic> newAttrs) {
    var binder = current.bindElement();
    binder.bindProperty(dashCaseToCamelCase(name), ast);
    newAttrs[name] = ast.source;
  }
  _bindAssignmentEvent(name, expression, CompileElement current, newAttrs) {
    this._bindEvent(name, '''${ expression}=\$event''', current, newAttrs);
  }
  _bindEvent(name, expression, CompileElement current, newAttrs) {
    current.bindElement().bindEvent(dashCaseToCamelCase(name),
        this._parser.parseAction(expression, current.elementDescription));
  }
}
