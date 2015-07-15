library angular2.src.core.application;

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
import "package:angular2/src/dom/browser_adapter.dart" show BrowserDomAdapter;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "compiler/compiler.dart" show Compiler, CompilerCache;
import "package:angular2/src/reflection/reflection.dart"
    show Reflector, reflector;
import "package:angular2/change_detection.dart"
    show
        Parser,
        Lexer,
        ChangeDetection,
        DynamicChangeDetection,
        JitChangeDetection,
        PreGeneratedChangeDetection,
        Pipes,
        defaultPipes;
import "exception_handler.dart" show ExceptionHandler;
import "package:angular2/src/render/dom/compiler/view_loader.dart"
    show ViewLoader;
import "package:angular2/src/render/dom/compiler/style_url_resolver.dart"
    show StyleUrlResolver;
import "package:angular2/src/render/dom/compiler/style_inliner.dart"
    show StyleInliner;
import "compiler/view_resolver.dart" show ViewResolver;
import "compiler/directive_resolver.dart" show DirectiveResolver;
import "package:angular2/src/facade/collection.dart" show List, ListWrapper;
import "package:angular2/src/facade/async.dart" show Future, PromiseWrapper;
import "package:angular2/src/core/zone/ng_zone.dart" show NgZone;
import "package:angular2/src/core/life_cycle/life_cycle.dart" show LifeCycle;
import "package:angular2/src/render/dom/shadow_dom/shadow_dom_strategy.dart"
    show ShadowDomStrategy;
import "package:angular2/src/render/dom/shadow_dom/emulated_unscoped_shadow_dom_strategy.dart"
    show EmulatedUnscopedShadowDomStrategy;
import "package:angular2/src/render/xhr.dart" show XHR;
import "package:angular2/src/render/xhr_impl.dart" show XHRImpl;
import "package:angular2/src/render/dom/events/event_manager.dart"
    show EventManager, DomEventsPlugin;
import "package:angular2/src/render/dom/events/key_events.dart"
    show KeyEventsPlugin;
import "package:angular2/src/render/dom/events/hammer_gestures.dart"
    show HammerGesturesPlugin;
import "package:angular2/src/core/compiler/component_url_mapper.dart"
    show ComponentUrlMapper;
import "package:angular2/src/services/url_resolver.dart" show UrlResolver;
import "package:angular2/src/services/app_root_url.dart" show AppRootUrl;
import "package:angular2/src/core/compiler/dynamic_component_loader.dart"
    show ComponentRef, DynamicComponentLoader;
import "package:angular2/src/core/testability/testability.dart"
    show TestabilityRegistry, Testability;
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
import "package:angular2/src/render/api.dart" show Renderer, RenderCompiler;
import "package:angular2/src/render/dom/dom_renderer.dart"
    show DomRenderer, DOCUMENT_TOKEN;
import "package:angular2/src/render/dom/compiler/compiler.dart"
    show DefaultDomCompiler;
import "package:angular2/src/core/compiler/view_ref.dart" show internalView;
import "application_tokens.dart"
    show appComponentRefPromiseToken, appComponentTypeToken;

Injector _rootInjector;
// Contains everything that is safe to share between applications.
var _rootBindings = [bind(Reflector).toValue(reflector), TestabilityRegistry];
List<dynamic /* Type | Binding | List < dynamic > */ > _injectorBindings(
    appComponentType) {
  Type bestChangeDetection = DynamicChangeDetection;
  if (PreGeneratedChangeDetection.isSupported()) {
    bestChangeDetection = PreGeneratedChangeDetection;
  } else if (JitChangeDetection.isSupported()) {
    bestChangeDetection = JitChangeDetection;
  }
  return [
    bind(DOCUMENT_TOKEN).toValue(DOM.defaultDoc()),
    bind(appComponentTypeToken).toValue(appComponentType),
    bind(appComponentRefPromiseToken)
        .toFactory((dynamicComponentLoader, injector, testability, registry) {
      // TODO(rado): investigate whether to support bindings on root component.
      return dynamicComponentLoader
          .loadAsRoot(appComponentType, null, injector)
          .then((componentRef) {
        registry.registerApplication(
            componentRef.location.nativeElement, testability);
        return componentRef;
      });
    }, [DynamicComponentLoader, Injector, Testability, TestabilityRegistry]),
    bind(appComponentType).toFactory((Future<dynamic> p) =>
        p.then((ref) => ref.instance), [appComponentRefPromiseToken]),
    bind(LifeCycle).toFactory((exceptionHandler) =>
            new LifeCycle(exceptionHandler, null, assertionsEnabled()),
        [ExceptionHandler]),
    bind(EventManager).toFactory((ngZone) {
      var plugins = [
        new HammerGesturesPlugin(),
        new KeyEventsPlugin(),
        new DomEventsPlugin()
      ];
      return new EventManager(plugins, ngZone);
    }, [NgZone]),
    bind(ShadowDomStrategy).toFactory((doc) =>
        new EmulatedUnscopedShadowDomStrategy(doc.head), [DOCUMENT_TOKEN]),
    DomRenderer,
    DefaultDomCompiler,
    bind(Renderer).toAlias(DomRenderer),
    bind(RenderCompiler).toAlias(DefaultDomCompiler),
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
    ExceptionHandler,
    bind(XHR).toValue(new XHRImpl()),
    ComponentUrlMapper,
    UrlResolver,
    StyleUrlResolver,
    StyleInliner,
    DynamicComponentLoader,
    Testability,
    AppRootUrl
  ];
}
NgZone _createNgZone(Function givenReporter) {
  var defaultErrorReporter = (exception, stackTrace) {
    var longStackTrace =
        ListWrapper.join(stackTrace, "\n\n-----async gap-----\n");
    DOM.logError('''${ exception}

${ longStackTrace}''');
    throw exception;
  };
  var reporter =
      isPresent(givenReporter) ? givenReporter : defaultErrorReporter;
  var zone = new NgZone(enableLongStackTrace: assertionsEnabled());
  zone.overrideOnErrorHandler(reporter);
  return zone;
}
/**
 * Bootstrapping for Angular applications.
 *
 * You instantiate an Angular application by explicitly specifying a component to use as the root
 * component for your
 * application via the `bootstrap()` method.
 *
 * ## Simple Example
 *
 * Assuming this `index.html`:
 *
 * ```html
 * <html>
 *   <!-- load Angular script tags here. -->
 *   <body>
 *     <my-app>loading...</my-app>
 *   </body>
 * </html>
 * ```
 *
 * An application is bootstrapped inside an existing browser DOM, typically `index.html`. Unlike
 * Angular 1, Angular 2
 * does not compile/process bindings in `index.html`. This is mainly for security reasons, as well
 * as architectural
 * changes in Angular 2. This means that `index.html` can safely be processed using server-side
 * technologies such as
 * bindings. Bindings can thus use double-curly `{{ syntax }}` without collision from Angular 2
 * component double-curly
 * `{{ syntax }}`.
 *
 * We can use this script code:
 *
 * ```
 * @Component({
 *    selector: 'my-app'
 * })
 * @View({
 *    template: 'Hello {{ name }}!'
 * })
 * class MyApp {
 *   name:string;
 *
 *   constructor() {
 *     this.name = 'World';
 *   }
 * }
 *
 * main() {
 *   return bootstrap(MyApp);
 * }
 * ```
 *
 * When the app developer invokes `bootstrap()` with the root component `MyApp` as its argument,
 * Angular performs the
 * following tasks:
 *
 *  1. It uses the component's `selector` property to locate the DOM element which needs to be
 * upgraded into
 *     the angular component.
 *  2. It creates a new child injector (from the platform injector). Optionally, you can also
 * override the injector configuration for an app by
 * invoking `bootstrap` with the `componentInjectableBindings` argument.
 *  3. It creates a new `Zone` and connects it to the angular application's change detection domain
 * instance.
 *  4. It creates a shadow DOM on the selected component's host element and loads the template into
 * it.
 *  5. It instantiates the specified component.
 *  6. Finally, Angular performs change detection to apply the initial data bindings for the
 * application.
 *
 *
 * ## Instantiating Multiple Applications on a Single Page
 *
 * There are two ways to do this.
 *
 *
 * ### Isolated Applications
 *
 * Angular creates a new application each time that the `bootstrap()` method is invoked. When
 * multiple applications
 * are created for a page, Angular treats each application as independent within an isolated change
 * detection and
 * `Zone` domain. If you need to share data between applications, use the strategy described in the
 * next
 * section, "Applications That Share Change Detection."
 *
 *
 * ### Applications That Share Change Detection
 *
 * If you need to bootstrap multiple applications that share common data, the applications must
 * share a common
 * change detection and zone. To do that, create a meta-component that lists the application
 * components in its template.
 * By only invoking the `bootstrap()` method once, with the meta-component as its argument, you
 * ensure that only a
 * single change detection zone is created and therefore data can be shared across the applications.
 *
 *
 * ## Platform Injector
 *
 * When working within a browser window, there are many singleton resources: cookies, title,
 * location, and others.
 * Angular services that represent these resources must likewise be shared across all Angular
 * applications that
 * occupy the same browser window.  For this reason, Angular creates exactly one global platform
 * injector which stores
 * all shared services, and each angular application injector has the platform injector as its
 * parent.
 *
 * Each application has its own private injector as well. When there are multiple applications on a
 * page, Angular treats
 * each application injector's services as private to that application.
 *
 *
 * # API
 * - `appComponentType`: The root component which should act as the application. This is a reference
 * to a `Type`
 *   which is annotated with `@Component(...)`.
 * - `componentInjectableBindings`: An additional set of bindings that can be added to the app
 * injector
 * to override default injection behavior.
 * - `errorReporter`: `function(exception:any, stackTrace:string)` a default error reporter for
 * unhandled exceptions.
 *
 * Returns a `Promise` of {@link ApplicationRef}.
 */
Future<ApplicationRef> bootstrap(Type appComponentType,
    [List<dynamic /* Type | Binding | List < dynamic > */ > componentInjectableBindings = null,
    Function errorReporter = null]) {
  BrowserDomAdapter.makeCurrent();
  var bootstrapProcess = PromiseWrapper.completer();
  var zone = _createNgZone(errorReporter);
  zone.run(() {
    // TODO(rado): prepopulate template cache, so applications with only

    // index.html and main.js are possible.
    var appInjector =
        _createAppInjector(appComponentType, componentInjectableBindings, zone);
    Future<dynamic> compRefToken =
        PromiseWrapper.wrap(() => appInjector.get(appComponentRefPromiseToken));
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
  });
  return bootstrapProcess.promise;
}
/**
 * Represents a Angular's representation of an Application.
 *
 * `ApplicationRef` represents a running application instance. Use it to retrieve the host
 * component, injector,
 * or dispose of an application.
 */
class ApplicationRef {
  ComponentRef _hostComponent;
  Injector _injector;
  Type _hostComponentType;
  /**
   * @private
   */
  ApplicationRef(
      ComponentRef hostComponent, Type hostComponentType, Injector injector) {
    this._hostComponent = hostComponent;
    this._injector = injector;
    this._hostComponentType = hostComponentType;
  }
  /**
   * Returns the current {@link Component} type.
   */
  Type get hostComponentType {
    return this._hostComponentType;
  }
  /**
   * Returns the current {@link Component} instance.
   */
  dynamic get hostComponent {
    return this._hostComponent.instance;
  }
  /**
   * Dispose (un-load) the application.
   */
  void dispose() {
    // TODO: We also need to clean up the Zone, ... here!
    this._hostComponent.dispose();
  }
  /**
   * Returns the root application {@link Injector}.
   */
  Injector get injector {
    return this._injector;
  }
}
Injector _createAppInjector(Type appComponentType,
    List<dynamic /* Type | Binding | List < dynamic > */ > bindings,
    NgZone zone) {
  if (isBlank(_rootInjector)) _rootInjector =
      Injector.resolveAndCreate(_rootBindings);
  List<dynamic> mergedBindings = isPresent(bindings)
      ? ListWrapper.concat(_injectorBindings(appComponentType), bindings)
      : _injectorBindings(appComponentType);
  mergedBindings.add(bind(NgZone).toValue(zone));
  return _rootInjector.resolveAndCreateChild(mergedBindings);
}
