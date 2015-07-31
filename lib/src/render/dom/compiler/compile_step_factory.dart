library angular2.src.render.dom.compiler.compile_step_factory;

import "package:angular2/src/facade/collection.dart" show List;
import "package:angular2/src/change_detection/change_detection.dart"
    show Parser;
import "../../api.dart" show ViewDefinition;
import "compile_step.dart" show CompileStep;
import "property_binding_parser.dart" show PropertyBindingParser;
import "text_interpolation_parser.dart" show TextInterpolationParser;
import "directive_parser.dart" show DirectiveParser;
import "view_splitter.dart" show ViewSplitter;
import "style_encapsulator.dart" show StyleEncapsulator;

class CompileStepFactory {
  List<CompileStep> createSteps(ViewDefinition view) {
    return null;
  }
}
class DefaultStepFactory extends CompileStepFactory {
  Parser _parser;
  String _appId;
  Map<String, String> _componentUIDsCache = new Map();
  DefaultStepFactory(this._parser, this._appId) : super() {
    /* super call moved to initializer */;
  }
  List<CompileStep> createSteps(ViewDefinition view) {
    return [
      new ViewSplitter(this._parser),
      new PropertyBindingParser(this._parser),
      new DirectiveParser(this._parser, view.directives),
      new TextInterpolationParser(this._parser),
      new StyleEncapsulator(this._appId, view, this._componentUIDsCache)
    ];
  }
}
