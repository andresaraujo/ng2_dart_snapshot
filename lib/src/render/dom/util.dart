library angular2.src.render.dom.util;

import "package:angular2/src/facade/lang.dart" show StringWrapper, isPresent;

const NG_BINDING_CLASS_SELECTOR = ".ng-binding";
const NG_BINDING_CLASS = "ng-binding";
const EVENT_TARGET_SEPARATOR = ":";
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
