library angular2.src.test_lib.utils;

import "package:angular2/src/facade/collection.dart"
    show List, ListWrapper, MapWrapper;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/facade/lang.dart"
    show isPresent, isString, RegExpWrapper, StringWrapper, RegExp;

class Log {
  List<dynamic> _result;
  Log() {
    this._result = [];
  }
  void add(value) {
    this._result.add(value);
  }
  fn(value) {
    return ([a1 = null, a2 = null, a3 = null, a4 = null, a5 = null]) {
      this._result.add(value);
    };
  }
  String result() {
    return ListWrapper.join(this._result, "; ");
  }
}
dispatchEvent(element, eventType) {
  DOM.dispatchEvent(element, DOM.createEvent(eventType));
}
dynamic el(String html) {
  return (DOM.firstChild(DOM.content(DOM.createTemplate(html))) as dynamic);
}
var _RE_SPECIAL_CHARS = [
  "-",
  "[",
  "]",
  "/",
  "{",
  "}",
  "\\",
  "(",
  ")",
  "*",
  "+",
  "?",
  ".",
  "^",
  "\$",
  "|"
];
var _ESCAPE_RE =
    RegExpWrapper.create('''[\\${ _RE_SPECIAL_CHARS . join ( "\\" )}]''');
RegExp containsRegexp(String input) {
  return RegExpWrapper.create(StringWrapper.replaceAllMapped(
      input, _ESCAPE_RE, (match) => '''\\${ match [ 0 ]}'''));
}
String normalizeCSS(String css) {
  css = StringWrapper.replaceAll(css, new RegExp(r'\s+'), " ");
  css = StringWrapper.replaceAll(css, new RegExp(r':\s'), ":");
  css = StringWrapper.replaceAll(css, new RegExp(r'' + "'" + r'"'), "\"");
  css = StringWrapper.replaceAllMapped(css, new RegExp(r'url\(\"(.+)\\"\)'),
      (match) => '''url(${ match [ 1 ]})''');
  css = StringWrapper.replaceAllMapped(css, new RegExp(r'\[(.+)=([^"\]]+)\]'),
      (match) => '''[${ match [ 1 ]}="${ match [ 2 ]}"]''');
  return css;
}
var _singleTagWhitelist = ["br", "hr", "input"];
String stringifyElement(el) {
  var result = "";
  if (DOM.isElementNode(el)) {
    var tagName = StringWrapper.toLowerCase(DOM.tagName(el));
    // Opening tag
    result += '''<${ tagName}''';
    // Attributes in an ordered way
    var attributeMap = DOM.attributeMap(el);
    var keys = [];
    MapWrapper.forEach(attributeMap, (v, k) {
      keys.add(k);
    });
    ListWrapper.sort(keys);
    for (var i = 0; i < keys.length; i++) {
      var key = keys[i];
      var attValue = attributeMap[key];
      if (!isString(attValue)) {
        result += ''' ${ key}''';
      } else {
        result += ''' ${ key}="${ attValue}"''';
      }
    }
    result += ">";
    // Children
    var children = DOM.childNodes(DOM.templateAwareRoot(el));
    for (var j = 0; j < children.length; j++) {
      result += stringifyElement(children[j]);
    }
    // Closing tag
    if (!ListWrapper.contains(_singleTagWhitelist, tagName)) {
      result += '''</${ tagName}>''';
    }
  } else if (DOM.isCommentNode(el)) {
    result += '''<!--${ DOM . nodeValue ( el )}-->''';
  } else {
    result += DOM.getText(el);
  }
  return result;
}
