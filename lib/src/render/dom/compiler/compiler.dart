library angular2.src.render.dom.compiler.compiler;

import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/facade/async.dart" show PromiseWrapper, Future;
import "package:angular2/src/facade/lang.dart"
    show BaseException, isPresent, isBlank;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "../../api.dart"
    show
        ViewDefinition,
        ProtoViewDto,
        ViewType,
        DirectiveMetadata,
        RenderCompiler,
        RenderProtoViewRef,
        RenderProtoViewMergeMapping,
        ViewEncapsulation;
import "compile_pipeline.dart" show CompilePipeline;
import "package:angular2/src/render/dom/compiler/view_loader.dart"
    show ViewLoader, TemplateAndStyles;
import "compile_step_factory.dart" show CompileStepFactory, DefaultStepFactory;
import "../schema/element_schema_registry.dart" show ElementSchemaRegistry;
import "package:angular2/src/change_detection/change_detection.dart"
    show Parser;
import "../view/proto_view_merger.dart" as pvm;
import "../dom_tokens.dart" show DOCUMENT_TOKEN, APP_ID_TOKEN;
import "package:angular2/di.dart" show Inject;
import "../view/shared_styles_host.dart" show SharedStylesHost;
import "../util.dart" show prependAll;
import "../template_cloner.dart" show TemplateCloner;

/**
 * The compiler loads and translates the html templates of components into
 * nested ProtoViews. To decompose its functionality it uses
 * the CompilePipeline and the CompileSteps.
 */
class DomCompiler extends RenderCompiler {
  ElementSchemaRegistry _schemaRegistry;
  TemplateCloner _templateCloner;
  CompileStepFactory _stepFactory;
  ViewLoader _viewLoader;
  SharedStylesHost _sharedStylesHost;
  DomCompiler(this._schemaRegistry, this._templateCloner, this._stepFactory,
      this._viewLoader, this._sharedStylesHost)
      : super() {
    /* super call moved to initializer */;
  }
  Future<ProtoViewDto> compile(ViewDefinition view) {
    var tplPromise = this._viewLoader.load(view);
    return PromiseWrapper.then(tplPromise, (TemplateAndStyles tplAndStyles) =>
        this._compileView(view, tplAndStyles, ViewType.COMPONENT), (e) {
      throw new BaseException(
          '''Failed to load the template for "${ view . componentId}" : ${ e}''');
      return null;
    });
  }
  Future<ProtoViewDto> compileHost(DirectiveMetadata directiveMetadata) {
    var hostViewDef = new ViewDefinition(
        componentId: directiveMetadata.id,
        templateAbsUrl: null,
        template: null,
        styles: null,
        styleAbsUrls: null,
        directives: [directiveMetadata],
        encapsulation: ViewEncapsulation.NONE);
    return this._compileView(hostViewDef, new TemplateAndStyles(
        '''<${ directiveMetadata . selector}></${ directiveMetadata . selector}>''',
        []), ViewType.HOST);
  }
  Future<RenderProtoViewMergeMapping> mergeProtoViewsRecursively(
      List<dynamic /* RenderProtoViewRef | List < dynamic > */ > protoViewRefs) {
    return PromiseWrapper.resolve(
        pvm.mergeProtoViewsRecursively(this._templateCloner, protoViewRefs));
  }
  Future<ProtoViewDto> _compileView(ViewDefinition viewDef,
      TemplateAndStyles templateAndStyles, ViewType protoViewType) {
    if (identical(viewDef.encapsulation, ViewEncapsulation.EMULATED) &&
        identical(templateAndStyles.styles.length, 0)) {
      viewDef = this._normalizeViewEncapsulationIfThereAreNoStyles(viewDef);
    }
    var pipeline = new CompilePipeline(this._stepFactory.createSteps(viewDef));
    var compiledStyles = pipeline.processStyles(templateAndStyles.styles);
    var compileElements = pipeline.processElements(
        DOM.createTemplate(templateAndStyles.template), protoViewType, viewDef);
    if (identical(viewDef.encapsulation, ViewEncapsulation.NATIVE)) {
      prependAll(DOM.content(compileElements[0].element), compiledStyles
          .map((style) => DOM.createStyleElement(style))
          .toList());
    } else {
      this._sharedStylesHost.addStyles(compiledStyles);
    }
    return PromiseWrapper.resolve(compileElements[0].inheritedProtoView.build(
        this._schemaRegistry, this._templateCloner));
  }
  ViewDefinition _normalizeViewEncapsulationIfThereAreNoStyles(
      ViewDefinition viewDef) {
    if (identical(viewDef.encapsulation, ViewEncapsulation.EMULATED)) {
      return new ViewDefinition(
          componentId: viewDef.componentId,
          templateAbsUrl: viewDef.templateAbsUrl,
          template: viewDef.template,
          styleAbsUrls: viewDef.styleAbsUrls,
          styles: viewDef.styles,
          directives: viewDef.directives,
          encapsulation: ViewEncapsulation.NONE);
    } else {
      return viewDef;
    }
  }
}
@Injectable()
class DefaultDomCompiler extends DomCompiler {
  DefaultDomCompiler(ElementSchemaRegistry schemaRegistry,
      TemplateCloner templateCloner, Parser parser, ViewLoader viewLoader,
      SharedStylesHost sharedStylesHost, @Inject(APP_ID_TOKEN) dynamic appId)
      : super(schemaRegistry, templateCloner,
          new DefaultStepFactory(parser, appId), viewLoader, sharedStylesHost) {
    /* super call moved to initializer */;
  }
}
