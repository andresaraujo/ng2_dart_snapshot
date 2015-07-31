library angular2.src.render.dom.compiler.text_interpolation_parser;

import "package:angular2/src/facade/lang.dart"
    show RegExpWrapper, StringWrapper, isPresent;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/change_detection/change_detection.dart"
    show Parser;
import "compile_step.dart" show CompileStep;
import "compile_element.dart" show CompileElement;
import "compile_control.dart" show CompileControl;

/**
 * Parses interpolations in direct text child nodes of the current element.
 */
class TextInterpolationParser implements CompileStep {
  Parser _parser;
  TextInterpolationParser(this._parser) {}
  String processStyle(String style) {
    return style;
  }
  processElement(
      CompileElement parent, CompileElement current, CompileControl control) {
    if (!current.compileChildren) {
      return;
    }
    var element = current.element;
    var childNodes = DOM.childNodes(DOM.templateAwareRoot(element));
    for (var i = 0; i < childNodes.length; i++) {
      var node = childNodes[i];
      if (DOM.isTextNode(node)) {
        var textNode = (node as dynamic);
        var text = DOM.nodeValue(textNode);
        var expr =
            this._parser.parseInterpolation(text, current.elementDescription);
        if (isPresent(expr)) {
          DOM.setText(textNode, " ");
          if (identical(
              current.element, current.inheritedProtoView.rootElement)) {
            current.inheritedProtoView.bindRootText(textNode, expr);
          } else {
            current.bindElement().bindText(textNode, expr);
          }
        }
      }
    }
  }
}
