library angular2.src.render.dom.compiler.compile_step_factory;

import "package:angular2/src/facade/collection.dart" show List;
import "package:angular2/change_detection.dart" show Parser;
import "../../api.dart" show ViewDefinition;
import "compile_step.dart" show CompileStep;
import "property_binding_parser.dart" show PropertyBindingParser;
import "text_interpolation_parser.dart" show TextInterpolationParser;
import "directive_parser.dart" show DirectiveParser;
import "view_splitter.dart" show ViewSplitter;
import "../shadow_dom/shadow_dom_compile_step.dart" show ShadowDomCompileStep;
import "../shadow_dom/shadow_dom_strategy.dart" show ShadowDomStrategy;

class CompileStepFactory {
  List<CompileStep> createSteps(ViewDefinition view) {
    return null;
  }
}
class DefaultStepFactory extends CompileStepFactory {
  Parser _parser;
  ShadowDomStrategy _shadowDomStrategy;
  DefaultStepFactory(this._parser, this._shadowDomStrategy) : super() {
    /* super call moved to initializer */;
  }
  List<CompileStep> createSteps(ViewDefinition view) {
    return [
      new ViewSplitter(this._parser),
      new PropertyBindingParser(this._parser),
      new DirectiveParser(this._parser, view.directives),
      new TextInterpolationParser(this._parser),
      new ShadowDomCompileStep(this._shadowDomStrategy, view)
    ];
  }
}
