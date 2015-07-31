library angular2.src.render.dom.compiler.compile_pipeline;

import "package:angular2/src/facade/lang.dart" show isPresent, isBlank;
import "package:angular2/src/facade/collection.dart" show List, ListWrapper;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "compile_element.dart" show CompileElement;
import "compile_control.dart" show CompileControl;
import "compile_step.dart" show CompileStep;
import "../view/proto_view_builder.dart" show ProtoViewBuilder;
import "../../api.dart" show ProtoViewDto, ViewType, ViewDefinition;

/**
 * CompilePipeline for executing CompileSteps recursively for
 * all elements in a template.
 */
class CompilePipeline {
  List<CompileStep> steps;
  CompileControl _control;
  CompilePipeline(this.steps) {
    this._control = new CompileControl(steps);
  }
  List<String> processStyles(List<String> styles) {
    return styles.map((style) {
      this.steps.forEach((step) {
        style = step.processStyle(style);
      });
      return style;
    }).toList();
  }
  List<CompileElement> processElements(
      dynamic rootElement, ViewType protoViewType, ViewDefinition viewDef) {
    List<CompileElement> results = [];
    var compilationCtxtDescription = viewDef.componentId;
    var rootCompileElement =
        new CompileElement(rootElement, compilationCtxtDescription);
    rootCompileElement.inheritedProtoView =
        new ProtoViewBuilder(rootElement, protoViewType, viewDef.encapsulation);
    rootCompileElement.isViewRoot = true;
    this._processElement(
        results, null, rootCompileElement, compilationCtxtDescription);
    return results;
  }
  _processElement(List<CompileElement> results, CompileElement parent,
      CompileElement current, [String compilationCtxtDescription = ""]) {
    var additionalChildren =
        this._control.internalProcess(results, 0, parent, current);
    if (current.compileChildren) {
      var node = DOM.firstChild(DOM.templateAwareRoot(current.element));
      while (isPresent(node)) {
        // compiliation can potentially move the node, so we need to store the

        // next sibling before recursing.
        var nextNode = DOM.nextSibling(node);
        if (DOM.isElementNode(node)) {
          var childCompileElement =
              new CompileElement(node, compilationCtxtDescription);
          childCompileElement.inheritedProtoView = current.inheritedProtoView;
          childCompileElement.inheritedElementBinder =
              current.inheritedElementBinder;
          childCompileElement.distanceToInheritedBinder =
              current.distanceToInheritedBinder + 1;
          this._processElement(results, current, childCompileElement);
        }
        node = nextNode;
      }
    }
    if (isPresent(additionalChildren)) {
      for (var i = 0; i < additionalChildren.length; i++) {
        this._processElement(results, current, additionalChildren[i]);
      }
    }
  }
}
