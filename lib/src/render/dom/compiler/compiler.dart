library angular2.src.render.dom.compiler.compiler;

import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/facade/async.dart" show PromiseWrapper, Future;
import "package:angular2/src/facade/lang.dart" show BaseException, isPresent;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "../../api.dart"
    show
        ViewDefinition,
        ProtoViewDto,
        ViewType,
        DirectiveMetadata,
        RenderCompiler,
        RenderProtoViewRef;
import "compile_pipeline.dart" show CompilePipeline;
import "package:angular2/src/render/dom/compiler/view_loader.dart"
    show ViewLoader;
import "compile_step_factory.dart" show CompileStepFactory, DefaultStepFactory;
import "package:angular2/change_detection.dart" show Parser;
import "../shadow_dom/shadow_dom_strategy.dart" show ShadowDomStrategy;

/**
 * The compiler loads and translates the html templates of components into
 * nested ProtoViews. To decompose its functionality it uses
 * the CompilePipeline and the CompileSteps.
 */
class DomCompiler extends RenderCompiler {
  CompileStepFactory _stepFactory;
  ViewLoader _viewLoader;
  DomCompiler(this._stepFactory, this._viewLoader) : super() {
    /* super call moved to initializer */;
  }
  Future<ProtoViewDto> compile(ViewDefinition view) {
    var tplPromise = this._viewLoader.load(view);
    return PromiseWrapper.then(tplPromise,
        (el) => this._compileTemplate(view, el, ViewType.COMPONENT), (e) {
      throw new BaseException(
          '''Failed to load the template for "${ view . componentId}" : ${ e}''');
    });
  }
  Future<ProtoViewDto> compileHost(DirectiveMetadata directiveMetadata) {
    var hostViewDef = new ViewDefinition(
        componentId: directiveMetadata.id,
        templateAbsUrl: null,
        template: null,
        styles: null,
        styleAbsUrls: null,
        directives: [directiveMetadata]);
    var element = DOM.createElement(directiveMetadata.selector);
    return this._compileTemplate(hostViewDef, element, ViewType.HOST);
  }
  Future<ProtoViewDto> _compileTemplate(
      ViewDefinition viewDef, tplElement, ViewType protoViewType) {
    var pipeline = new CompilePipeline(this._stepFactory.createSteps(viewDef));
    var compileElements =
        pipeline.process(tplElement, protoViewType, viewDef.componentId);
    return PromiseWrapper
        .resolve(compileElements[0].inheritedProtoView.build());
  }
}
@Injectable()
class DefaultDomCompiler extends DomCompiler {
  DefaultDomCompiler(
      Parser parser, ShadowDomStrategy shadowDomStrategy, ViewLoader viewLoader)
      : super(new DefaultStepFactory(parser, shadowDomStrategy), viewLoader) {
    /* super call moved to initializer */;
  }
}
