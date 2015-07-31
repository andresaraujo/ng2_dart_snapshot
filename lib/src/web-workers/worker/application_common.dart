library angular2.src.web_workers.worker.application_common;

import "package:angular2/di.dart" show Injector, bind, OpaqueToken, Binding;
import "package:angular2/src/facade/lang.dart"
    show
        NumberWrapper,
        Type,
        isBlank,
        isPresent,
        BaseException,
        assertionsEnabled,
        print,
        stringify;
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
        JitChangeDetection,
        Pipes,
        defaultPipes,
        PreGeneratedChangeDetection;
import "package:angular2/src/render/dom/compiler/style_url_resolver.dart"
    show StyleUrlResolver;
import "package:angular2/src/core/exception_handler.dart" show ExceptionHandler;
import "package:angular2/src/core/compiler/directive_resolver.dart"
    show DirectiveResolver;
import "package:angular2/src/core/compiler/view_resolver.dart"
    show ViewResolver;
import "package:angular2/src/facade/collection.dart" show List, ListWrapper;
import "package:angular2/src/facade/async.dart"
    show Future, PromiseWrapper, PromiseCompleter;
import "package:angular2/src/core/zone/ng_zone.dart" show NgZone;
import "package:angular2/src/core/life_cycle/life_cycle.dart" show LifeCycle;
import "package:angular2/src/render/xhr.dart" show XHR;
import "package:angular2/src/render/xhr_impl.dart" show XHRImpl;
import "package:angular2/src/core/compiler/component_url_mapper.dart"
    show ComponentUrlMapper;
import "package:angular2/src/services/url_resolver.dart" show UrlResolver;
import "package:angular2/src/services/app_root_url.dart" show AppRootUrl;
import "package:angular2/src/core/compiler/dynamic_component_loader.dart"
    show ComponentRef, DynamicComponentLoader;
import "package:angular2/src/core/testability/testability.dart"
    show Testability;
import "package:angular2/src/core/compiler/view_pool.dart"
    show AppViewPool, APP_VIEW_POOL_CAPACITY;
import "package:angular2/src/core/compiler/view_manager.dart"
    show AppViewManager;
import "package:angular2/src/core/compiler/view_manager_utils.dart"
    show AppViewManagerUtils;
import "package:angular2/src/core/compiler/view_listener.dart"
    show AppViewListener;
import "package:angular2/src/core/compiler/proto_view_factory.dart"
    show ProtoViewFactory;
import "renderer.dart" show WorkerRenderer, WorkerCompiler;
import "package:angular2/src/render/api.dart" show Renderer, RenderCompiler;
import "package:angular2/src/core/compiler/view_ref.dart" show internalView;
import "package:angular2/src/web-workers/worker/broker.dart" show MessageBroker;
import "package:angular2/src/web-workers/worker/application.dart"
    show WorkerMessageBus;
import "package:angular2/src/core/application_tokens.dart"
    show appComponentRefPromiseToken, appComponentTypeToken;
import "package:angular2/src/core/application.dart" show ApplicationRef;
import "package:angular2/src/core/application_common.dart" show createNgZone;
import "package:angular2/src/web-workers/shared/serializer.dart"
    show Serializer;
import "package:angular2/src/web-workers/shared/api.dart" show ON_WEBWORKER;
import "package:angular2/src/web-workers/shared/render_proto_view_ref_store.dart"
    show RenderProtoViewRefStore;
import "package:angular2/src/web-workers/shared/render_view_with_fragments_store.dart"
    show RenderViewWithFragmentsStore;

Injector _rootInjector;
// Contains everything that is safe to share between applications.
var _rootBindings = [bind(Reflector).toValue(reflector)];
class PrintLogger {
  var log = print;
  var logGroup = print;
  logGroupEnd() {}
}
List<dynamic /* Type | Binding | List < dynamic > */ > _injectorBindings(
    appComponentType, WorkerMessageBus bus, Map<String, dynamic> initData) {
  Type bestChangeDetection = DynamicChangeDetection;
  if (PreGeneratedChangeDetection.isSupported()) {
    bestChangeDetection = PreGeneratedChangeDetection;
  } else if (JitChangeDetection.isSupported()) {
    bestChangeDetection = JitChangeDetection;
  }
  return [
    bind(appComponentTypeToken).toValue(appComponentType),
    bind(appComponentRefPromiseToken)
        .toFactory((dynamicComponentLoader, injector) {
      // TODO(rado): investigate whether to support bindings on root component.
      return dynamicComponentLoader
          .loadAsRoot(appComponentType, null, injector)
          .then((componentRef) {
        return componentRef;
      });
    }, [DynamicComponentLoader, Injector]),
    bind(appComponentType).toFactory(
        (ref) => ref.instance, [appComponentRefPromiseToken]),
    bind(LifeCycle).toFactory(
        (exceptionHandler) => new LifeCycle(null, assertionsEnabled()),
        [ExceptionHandler]),
    Serializer,
    bind(WorkerMessageBus).toValue(bus),
    bind(MessageBroker).toFactory((a, b, c) => new MessageBroker(a, b, c), [
      WorkerMessageBus,
      Serializer,
      NgZone
    ]),
    WorkerRenderer,
    bind(Renderer).toAlias(WorkerRenderer),
    WorkerCompiler,
    bind(RenderCompiler).toAlias(WorkerCompiler),
    bind(ON_WEBWORKER).toValue(true),
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
    DirectiveResolver,
    Parser,
    Lexer,
    bind(ExceptionHandler).toFactory(
        () => new ExceptionHandler(new PrintLogger()), []),
    bind(XHR).toValue(new XHRImpl()),
    ComponentUrlMapper,
    UrlResolver,
    StyleUrlResolver,
    DynamicComponentLoader,
    Testability,
    bind(AppRootUrl).toValue(new AppRootUrl(initData["rootUrl"]))
  ];
}
Future<ApplicationRef> bootstrapWebworkerCommon(
    Type appComponentType, WorkerMessageBus bus,
    [List<dynamic /* Type | Binding | List < dynamic > */ > componentInjectableBindings = null]) {
  PromiseCompleter<dynamic> bootstrapProcess = PromiseWrapper.completer();
  var zone = createNgZone(new ExceptionHandler(new PrintLogger()));
  zone.run(() {
    // TODO(rado): prepopulate template cache, so applications with only

    // index.html and main.js are possible.

    //
    int listenerId;
    listenerId = bus.source.addListener((Map<String, dynamic> message) {
      if (!identical(message["data"]["type"], "init")) {
        return;
      }
      var appInjector = _createAppInjector(appComponentType,
          componentInjectableBindings, zone, bus, message["data"]["value"]);
      var compRefToken = PromiseWrapper.wrap(() {
        try {
          return appInjector.get(appComponentRefPromiseToken);
        } catch (e, e_stack) {
          rethrow;
        }
      });
      var tick = (componentRef) {
        var appChangeDetector =
            internalView(componentRef.hostView).changeDetector;
        // retrieve life cycle: may have already been created if injected in root component
        var lc = appInjector.get(LifeCycle);
        lc.registerWith(zone, appChangeDetector);
        lc.tick();
        bootstrapProcess.resolve(
            new ApplicationRef(componentRef, appComponentType, appInjector));
      };
      PromiseWrapper.then(compRefToken, tick, (err, stackTrace) {
        bootstrapProcess.reject(err, stackTrace);
      });
      bus.source.removeListener(listenerId);
    });
    bus.sink.send({"type": "ready"});
  });
  return bootstrapProcess.promise;
}
Injector _createAppInjector(Type appComponentType,
    List<dynamic /* Type | Binding | List < dynamic > */ > bindings,
    NgZone zone, WorkerMessageBus bus, Map<String, dynamic> initData) {
  if (isBlank(_rootInjector)) _rootInjector =
      Injector.resolveAndCreate(_rootBindings);
  List<dynamic> mergedBindings = isPresent(bindings)
      ? ListWrapper.concat(
          _injectorBindings(appComponentType, bus, initData), bindings)
      : _injectorBindings(appComponentType, bus, initData);
  mergedBindings.add(bind(NgZone).toValue(zone));
  return _rootInjector.resolveAndCreateChild(mergedBindings);
}
