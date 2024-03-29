library angular2.src.test_lib.test_injector;

import "package:angular2/di.dart" show bind, Binding;
import "package:angular2/src/core/compiler/compiler.dart"
    show Compiler, CompilerCache;
import "package:angular2/src/reflection/reflection.dart"
    show Reflector, reflector;
import "package:angular2/src/change_detection/change_detection.dart"
    show
        Parser,
        Lexer,
        ChangeDetection,
        DynamicChangeDetection,
        Pipes,
        defaultPipes;
import "package:angular2/src/core/exception_handler.dart" show ExceptionHandler;
import "package:angular2/src/render/dom/compiler/view_loader.dart"
    show ViewLoader;
import "package:angular2/src/core/compiler/view_resolver.dart"
    show ViewResolver;
import "package:angular2/src/core/compiler/directive_resolver.dart"
    show DirectiveResolver;
import "package:angular2/src/core/compiler/dynamic_component_loader.dart"
    show DynamicComponentLoader;
import "package:angular2/src/render/xhr.dart" show XHR;
import "package:angular2/src/core/compiler/component_url_mapper.dart"
    show ComponentUrlMapper;
import "package:angular2/src/services/url_resolver.dart" show UrlResolver;
import "package:angular2/src/services/app_root_url.dart" show AppRootUrl;
import "package:angular2/src/services/anchor_based_app_root_url.dart"
    show AnchorBasedAppRootUrl;
import "package:angular2/src/render/dom/compiler/style_url_resolver.dart"
    show StyleUrlResolver;
import "package:angular2/src/render/dom/compiler/style_inliner.dart"
    show StyleInliner;
import "package:angular2/src/core/zone/ng_zone.dart" show NgZone;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/render/dom/events/event_manager.dart"
    show EventManager, DomEventsPlugin;
import "package:angular2/src/mock/view_resolver_mock.dart"
    show MockViewResolver;
import "package:angular2/src/render/xhr_mock.dart" show MockXHR;
import "package:angular2/src/mock/mock_location_strategy.dart"
    show MockLocationStrategy;
import "package:angular2/src/router/location_strategy.dart"
    show LocationStrategy;
import "package:angular2/src/mock/ng_zone_mock.dart" show MockNgZone;
import "test_component_builder.dart" show TestComponentBuilder;
import "package:angular2/di.dart" show Injector;
import "package:angular2/src/facade/collection.dart" show List, ListWrapper;
import "package:angular2/src/facade/lang.dart" show FunctionWrapper, Type;
import "package:angular2/src/core/compiler/view_pool.dart"
    show AppViewPool, APP_VIEW_POOL_CAPACITY;
import "package:angular2/src/core/compiler/view_manager.dart"
    show AppViewManager;
import "package:angular2/src/core/compiler/view_manager_utils.dart"
    show AppViewManagerUtils;
import "package:angular2/debug.dart" show ELEMENT_PROBE_CONFIG;
import "package:angular2/src/core/compiler/proto_view_factory.dart"
    show ProtoViewFactory;
import "package:angular2/src/render/api.dart" show RenderCompiler, Renderer;
import "package:angular2/src/render/render.dart"
    show
        DomRenderer,
        DOCUMENT_TOKEN,
        DOM_REFLECT_PROPERTIES_AS_ATTRIBUTES,
        DefaultDomCompiler,
        APP_ID_TOKEN,
        SharedStylesHost,
        DomSharedStylesHost,
        MAX_IN_MEMORY_ELEMENTS_PER_TEMPLATE_TOKEN,
        TemplateCloner;
import "package:angular2/src/render/dom/schema/element_schema_registry.dart"
    show ElementSchemaRegistry;
import "package:angular2/src/render/dom/schema/dom_element_schema_registry.dart"
    show DomElementSchemaRegistry;
import "package:angular2/src/web-workers/shared/serializer.dart"
    show Serializer;
import "utils.dart" show Log;

/**
 * Returns the root injector bindings.
 *
 * This must be kept in sync with the _rootBindings in application.js
 *
 * @returns {any[]}
 */
_getRootBindings() {
  return [bind(Reflector).toValue(reflector)];
}
/**
 * Returns the application injector bindings.
 *
 * This must be kept in sync with _injectorBindings() in application.js
 *
 * @returns {any[]}
 */
_getAppBindings() {
  var appDoc;
  // The document is only available in browser environment
  try {
    appDoc = DOM.createHtmlDocument();
  } catch (e, e_stack) {
    appDoc = null;
  }
  return [
    bind(DOCUMENT_TOKEN).toValue(appDoc),
    DomRenderer,
    bind(Renderer).toAlias(DomRenderer),
    bind(APP_ID_TOKEN).toValue("a"),
    TemplateCloner,
    bind(MAX_IN_MEMORY_ELEMENTS_PER_TEMPLATE_TOKEN).toValue(-1),
    DefaultDomCompiler,
    bind(RenderCompiler).toAlias(DefaultDomCompiler),
    bind(ElementSchemaRegistry).toValue(new DomElementSchemaRegistry()),
    DomSharedStylesHost,
    bind(SharedStylesHost).toAlias(DomSharedStylesHost),
    bind(DOM_REFLECT_PROPERTIES_AS_ATTRIBUTES).toValue(false),
    ProtoViewFactory,
    AppViewPool,
    AppViewManager,
    AppViewManagerUtils,
    Serializer,
    ELEMENT_PROBE_CONFIG,
    bind(APP_VIEW_POOL_CAPACITY).toValue(500),
    Compiler,
    CompilerCache,
    bind(ViewResolver).toClass(MockViewResolver),
    bind(Pipes).toValue(defaultPipes),
    Log,
    bind(ChangeDetection).toClass(DynamicChangeDetection),
    ViewLoader,
    DynamicComponentLoader,
    DirectiveResolver,
    Parser,
    Lexer,
    bind(ExceptionHandler).toValue(new ExceptionHandler(DOM)),
    bind(LocationStrategy).toClass(MockLocationStrategy),
    bind(XHR).toClass(MockXHR),
    ComponentUrlMapper,
    UrlResolver,
    AnchorBasedAppRootUrl,
    bind(AppRootUrl).toAlias(AnchorBasedAppRootUrl),
    StyleUrlResolver,
    StyleInliner,
    TestComponentBuilder,
    bind(NgZone).toClass(MockNgZone),
    bind(EventManager).toFactory((zone) {
      var plugins = [new DomEventsPlugin()];
      return new EventManager(plugins, zone);
    }, [NgZone])
  ];
}
Injector createTestInjector(
    List<dynamic /* Type | Binding | List < dynamic > */ > bindings) {
  var rootInjector = Injector.resolveAndCreate(_getRootBindings());
  return rootInjector
      .resolveAndCreateChild(ListWrapper.concat(_getAppBindings(), bindings));
}
/**
 * Allows injecting dependencies in `beforeEach()` and `it()`.
 *
 * Example:
 *
 * ```
 * beforeEach(inject([Dependency, AClass], (dep, object) => {
 *   // some code that uses `dep` and `object`
 *   // ...
 * }));
 *
 * it('...', inject([AClass, AsyncTestCompleter], (object, async) => {
 *   object.doSomething().then(() => {
 *     expect(...);
 *     async.done();
 *   });
 * })
 * ```
 *
 * Notes:
 * - injecting an `AsyncTestCompleter` allow completing async tests - this is the equivalent of
 *   adding a `done` parameter in Jasmine,
 * - inject is currently a function because of some Traceur limitation the syntax should eventually
 *   becomes `it('...', @Inject (object: AClass, async: AsyncTestCompleter) => { ... });`
 *
 * @param {Array} tokens
 * @param {Function} fn
 * @return {FunctionWithParamTokens}
 */
FunctionWithParamTokens inject(List<dynamic> tokens, Function fn) {
  return new FunctionWithParamTokens(tokens, fn);
}
class FunctionWithParamTokens {
  List<dynamic> _tokens;
  Function _fn;
  FunctionWithParamTokens(List<dynamic> tokens, Function fn) {
    this._tokens = tokens;
    this._fn = fn;
  }
  /**
   * Returns the value of the executed function.
   */
  dynamic execute(Injector injector) {
    var params = ListWrapper.map(this._tokens, (t) => injector.get(t));
    return FunctionWrapper.apply(this._fn, params);
  }
}
