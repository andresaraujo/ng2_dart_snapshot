// TODO (jteplitz602): This whole file is nearly identical to core/application.ts.

// There should be a way to refactor application so that this file is unnecessary. See #3277
library angular2.src.web_workers.ui.di_bindings;

import "package:angular2/di.dart" show Injector, bind, Binding;
import "package:angular2/src/facade/lang.dart" show Type, isBlank, isPresent;
import "package:angular2/src/reflection/reflection.dart"
    show Reflector, reflector;
import "package:angular2/src/facade/collection.dart" show List, ListWrapper;
import "package:angular2/src/change_detection/change_detection.dart"
    show
        Parser,
        Lexer,
        ChangeDetection,
        DynamicChangeDetection,
        JitChangeDetection,
        PreGeneratedChangeDetection,
        Pipes,
        defaultPipes;
import "package:angular2/src/render/dom/events/event_manager.dart"
    show EventManager, DomEventsPlugin;
import "package:angular2/src/core/compiler/compiler.dart"
    show Compiler, CompilerCache;
import "package:angular2/src/dom/browser_adapter.dart" show BrowserDomAdapter;
import "package:angular2/src/render/dom/events/key_events.dart"
    show KeyEventsPlugin;
import "package:angular2/src/render/dom/events/hammer_gestures.dart"
    show HammerGesturesPlugin;
import "package:angular2/src/core/compiler/view_pool.dart"
    show AppViewPool, APP_VIEW_POOL_CAPACITY;
import "package:angular2/src/render/api.dart" show Renderer, RenderCompiler;
import "package:angular2/src/services/app_root_url.dart" show AppRootUrl;
import "package:angular2/src/render/render.dart"
    show
        DomRenderer,
        DOCUMENT_TOKEN,
        DOM_REFLECT_PROPERTIES_AS_ATTRIBUTES,
        DefaultDomCompiler,
        APP_ID_RANDOM_BINDING,
        MAX_IN_MEMORY_ELEMENTS_PER_TEMPLATE_TOKEN,
        TemplateCloner;
import "package:angular2/src/render/dom/schema/element_schema_registry.dart"
    show ElementSchemaRegistry;
import "package:angular2/src/render/dom/schema/dom_element_schema_registry.dart"
    show DomElementSchemaRegistry;
import "package:angular2/src/render/dom/view/shared_styles_host.dart"
    show SharedStylesHost, DomSharedStylesHost;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/core/zone/ng_zone.dart" show NgZone;
import "package:angular2/src/core/compiler/view_manager.dart"
    show AppViewManager;
import "package:angular2/src/core/compiler/view_manager_utils.dart"
    show AppViewManagerUtils;
import "package:angular2/src/core/compiler/view_listener.dart"
    show AppViewListener;
import "package:angular2/src/core/compiler/proto_view_factory.dart"
    show ProtoViewFactory;
import "package:angular2/src/core/compiler/view_resolver.dart"
    show ViewResolver;
import "package:angular2/src/render/dom/compiler/view_loader.dart"
    show ViewLoader;
import "package:angular2/src/core/compiler/directive_resolver.dart"
    show DirectiveResolver;
import "package:angular2/src/core/exception_handler.dart" show ExceptionHandler;
import "package:angular2/src/core/compiler/component_url_mapper.dart"
    show ComponentUrlMapper;
import "package:angular2/src/render/dom/compiler/style_inliner.dart"
    show StyleInliner;
import "package:angular2/src/core/compiler/dynamic_component_loader.dart"
    show DynamicComponentLoader;
import "package:angular2/src/render/dom/compiler/style_url_resolver.dart"
    show StyleUrlResolver;
import "package:angular2/src/services/url_resolver.dart" show UrlResolver;
import "package:angular2/src/core/testability/testability.dart"
    show Testability;
import "package:angular2/src/render/xhr.dart" show XHR;
import "package:angular2/src/render/xhr_impl.dart" show XHRImpl;
import "package:angular2/src/web-workers/shared/serializer.dart"
    show Serializer;
import "package:angular2/src/web-workers/shared/api.dart" show ON_WEBWORKER;
import "package:angular2/src/web-workers/shared/render_proto_view_ref_store.dart"
    show RenderProtoViewRefStore;
import "package:angular2/src/web-workers/shared/render_view_with_fragments_store.dart"
    show RenderViewWithFragmentsStore;
import "package:angular2/src/services/anchor_based_app_root_url.dart"
    show AnchorBasedAppRootUrl;
import "package:angular2/src/web-workers/ui/impl.dart" show WebWorkerMain;

Injector _rootInjector;
// Contains everything that is safe to share between applications.
var _rootBindings = [bind(Reflector).toValue(reflector)];
// TODO: This code is nearly identitcal to core/application. There should be a way to only write it

// once
List<dynamic /* Type | Binding | List < dynamic > */ > _injectorBindings() {
  Type bestChangeDetection = DynamicChangeDetection;
  if (PreGeneratedChangeDetection.isSupported()) {
    bestChangeDetection = PreGeneratedChangeDetection;
  } else if (JitChangeDetection.isSupported()) {
    bestChangeDetection = JitChangeDetection;
  }
  return [
    bind(DOCUMENT_TOKEN).toValue(DOM.defaultDoc()),
    bind(EventManager).toFactory((ngZone) {
      var plugins = [
        new HammerGesturesPlugin(),
        new KeyEventsPlugin(),
        new DomEventsPlugin()
      ];
      return new EventManager(plugins, ngZone);
    }, [NgZone]),
    bind(DOM_REFLECT_PROPERTIES_AS_ATTRIBUTES).toValue(false),
    DomRenderer,
    bind(Renderer).toAlias(DomRenderer),
    APP_ID_RANDOM_BINDING,
    TemplateCloner,
    bind(MAX_IN_MEMORY_ELEMENTS_PER_TEMPLATE_TOKEN).toValue(20),
    DefaultDomCompiler,
    bind(RenderCompiler).toAlias(DefaultDomCompiler),
    DomSharedStylesHost,
    bind(SharedStylesHost).toAlias(DomSharedStylesHost),
    Serializer,
    bind(ON_WEBWORKER).toValue(false),
    bind(ElementSchemaRegistry).toValue(new DomElementSchemaRegistry()),
    RenderViewWithFragmentsStore,
    RenderProtoViewRefStore,
    ProtoViewFactory,
    AppViewPool,
    bind(APP_VIEW_POOL_CAPACITY).toValue(10000),
    AppViewManager,
    AppViewManagerUtils,
    AppViewListener,
    Compiler,
    CompilerCache,
    ViewResolver,
    bind(Pipes).toValue(defaultPipes),
    bind(ChangeDetection).toClass(bestChangeDetection),
    ViewLoader,
    DirectiveResolver,
    Parser,
    Lexer,
    bind(ExceptionHandler).toFactory(() => new ExceptionHandler(DOM), []),
    bind(XHR).toValue(new XHRImpl()),
    ComponentUrlMapper,
    UrlResolver,
    StyleUrlResolver,
    StyleInliner,
    DynamicComponentLoader,
    Testability,
    AnchorBasedAppRootUrl,
    bind(AppRootUrl).toAlias(AnchorBasedAppRootUrl),
    WebWorkerMain
  ];
}
Injector createInjector(NgZone zone) {
  BrowserDomAdapter.makeCurrent();
  _rootBindings.add(bind(NgZone).toValue(zone));
  Injector injector = Injector.resolveAndCreate(_rootBindings);
  return injector.resolveAndCreateChild(_injectorBindings());
}
