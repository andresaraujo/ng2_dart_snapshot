library angular2.src.core.compiler.compiler;

import "package:angular2/di.dart" show Binding, resolveForwardRef, Injectable;
import "package:angular2/src/facade/lang.dart"
    show
        Type,
        isBlank,
        isType,
        isPresent,
        BaseException,
        normalizeBlank,
        stringify,
        isArray,
        isPromise;
import "package:angular2/src/facade/async.dart" show Future, PromiseWrapper;
import "package:angular2/src/facade/collection.dart"
    show List, ListWrapper, Map, MapWrapper;
import "directive_resolver.dart" show DirectiveResolver;
import "view.dart" show AppProtoView, AppProtoViewMergeMapping;
import "view_ref.dart" show ProtoViewRef;
import "element_injector.dart" show DirectiveBinding;
import "view_resolver.dart" show ViewResolver;
import "../annotations_impl/view.dart" show View;
import "component_url_mapper.dart" show ComponentUrlMapper;
import "proto_view_factory.dart" show ProtoViewFactory;
import "package:angular2/src/services/url_resolver.dart" show UrlResolver;
import "package:angular2/src/services/app_root_url.dart" show AppRootUrl;
import "element_binder.dart" show ElementBinder;
import "package:angular2/src/render/api.dart" as renderApi;

/**
 * Cache that stores the AppProtoView of the template of a component.
 * Used to prevent duplicate work and resolve cyclic dependencies.
 */
@Injectable()
class CompilerCache {
  Map<Type, AppProtoView> _cache = new Map();
  Map<Type, AppProtoView> _hostCache = new Map();
  void set(Type component, AppProtoView protoView) {
    this._cache[component] = protoView;
  }
  AppProtoView get(Type component) {
    var result = this._cache[component];
    return normalizeBlank(result);
  }
  void setHost(Type component, AppProtoView protoView) {
    this._hostCache[component] = protoView;
  }
  AppProtoView getHost(Type component) {
    var result = this._hostCache[component];
    return normalizeBlank(result);
  }
  void clear() {
    this._cache.clear();
    this._hostCache.clear();
  }
}
/**
 *
 * ## URL Resolution
 *
 * ```
 * var appRootUrl: AppRootUrl = ...;
 * var componentUrlMapper: ComponentUrlMapper = ...;
 * var urlResolver: UrlResolver = ...;
 *
 * var componentType: Type = ...;
 * var componentAnnotation: ComponentAnnotation = ...;
 * var viewAnnotation: ViewAnnotation = ...;
 *
 * // Resolving a URL
 *
 * var url = viewAnnotation.templateUrl;
 * var componentUrl = componentUrlMapper.getUrl(componentType);
 * var componentResolvedUrl = urlResolver.resolve(appRootUrl.value, componentUrl);
 * var templateResolvedUrl = urlResolver.resolve(componetResolvedUrl, url);
 * ```
 */
@Injectable()
class Compiler {
  DirectiveResolver _reader;
  CompilerCache _compilerCache;
  Map<Type, Future<AppProtoView>> _compiling;
  ViewResolver _viewResolver;
  ComponentUrlMapper _componentUrlMapper;
  UrlResolver _urlResolver;
  String _appUrl;
  renderApi.RenderCompiler _render;
  ProtoViewFactory _protoViewFactory;
  /**
   * @private
   */
  Compiler(DirectiveResolver reader, CompilerCache cache,
      ViewResolver viewResolver, ComponentUrlMapper componentUrlMapper,
      UrlResolver urlResolver, renderApi.RenderCompiler render,
      ProtoViewFactory protoViewFactory, AppRootUrl appUrl) {
    this._reader = reader;
    this._compilerCache = cache;
    this._compiling = new Map();
    this._viewResolver = viewResolver;
    this._componentUrlMapper = componentUrlMapper;
    this._urlResolver = urlResolver;
    this._appUrl = appUrl.value;
    this._render = render;
    this._protoViewFactory = protoViewFactory;
  }
  DirectiveBinding _bindDirective(directiveTypeOrBinding) {
    if (directiveTypeOrBinding is DirectiveBinding) {
      return directiveTypeOrBinding;
    } else if (directiveTypeOrBinding is Binding) {
      var annotation = this._reader.resolve(directiveTypeOrBinding.token);
      return DirectiveBinding.createFromBinding(
          directiveTypeOrBinding, annotation);
    } else {
      var annotation = this._reader.resolve(directiveTypeOrBinding);
      return DirectiveBinding.createFromType(
          directiveTypeOrBinding, annotation);
    }
  }
  // Create a hostView as if the compiler encountered <hostcmp></hostcmp>.

  // Used for bootstrapping.
  Future<ProtoViewRef> compileInHost(
      dynamic /* Type | Binding */ componentTypeOrBinding) {
    var componentType = isType(componentTypeOrBinding)
        ? componentTypeOrBinding
        : ((componentTypeOrBinding as Binding)).token;
    var hostAppProtoView = this._compilerCache.getHost(componentType);
    var hostPvPromise;
    if (isPresent(hostAppProtoView)) {
      hostPvPromise = PromiseWrapper.resolve(hostAppProtoView);
    } else {
      DirectiveBinding componentBinding =
          this._bindDirective(componentTypeOrBinding);
      Compiler._assertTypeIsComponent(componentBinding);
      var directiveMetadata = componentBinding.metadata;
      hostPvPromise = this._render
          .compileHost(directiveMetadata)
          .then((hostRenderPv) {
        var protoViews = this._protoViewFactory.createAppProtoViews(
            componentBinding, hostRenderPv, [componentBinding]);
        return this._compileNestedProtoViews(
            protoViews, componentType, new Map());
      }).then((appProtoView) {
        this._compilerCache.setHost(componentType, appProtoView);
        return appProtoView;
      });
    }
    return hostPvPromise.then((hostAppProtoView) => hostAppProtoView.ref);
  }
  dynamic /* Future < AppProtoView > | AppProtoView */ _compile(
      DirectiveBinding componentBinding,
      Map<Type, AppProtoView> componentPath) {
    var component = (componentBinding.key.token as Type);
    var protoView = this._compilerCache.get(component);
    if (isPresent(protoView)) {
      // The component has already been compiled into an AppProtoView,

      // returns a plain AppProtoView, not wrapped inside of a Promise, for performance reasons.
      return protoView;
    }
    var resultPromise = this._compiling[component];
    if (isPresent(resultPromise)) {
      // The component is already being compiled, attach to the existing Promise

      // instead of re-compiling the component.

      // It happens when a template references a component multiple times.
      return resultPromise;
    }
    var view = this._viewResolver.resolve(component);
    var directives = this._flattenDirectives(view);
    for (var i = 0; i < directives.length; i++) {
      if (!Compiler._isValidDirective(directives[i])) {
        throw new BaseException(
            '''Unexpected directive value \'${ stringify ( directives [ i ] )}\' on the View of component \'${ stringify ( component )}\'''');
      }
    }
    var boundDirectives = this._removeDuplicatedDirectives(ListWrapper.map(
        directives, (directive) => this._bindDirective(directive)));
    var renderTemplate =
        this._buildRenderTemplate(component, view, boundDirectives);
    resultPromise = this._render.compile(renderTemplate).then((renderPv) {
      var protoViews = this._protoViewFactory.createAppProtoViews(
          componentBinding, renderPv, boundDirectives);
      return this._compileNestedProtoViews(
          protoViews, component, componentPath);
    }).then((appProtoView) {
      this._compilerCache.set(component, appProtoView);
      MapWrapper.delete(this._compiling, component);
      return appProtoView;
    });
    this._compiling[component] = resultPromise;
    return resultPromise;
  }
  List<DirectiveBinding> _removeDuplicatedDirectives(
      List<DirectiveBinding> directives) {
    Map<num, DirectiveBinding> directivesMap = new Map();
    directives.forEach((dirBinding) {
      directivesMap[dirBinding.key.id] = dirBinding;
    });
    return MapWrapper.values(directivesMap);
  }
  Future<AppProtoView> _compileNestedProtoViews(
      List<AppProtoView> appProtoViews, Type componentType,
      Map<Type, AppProtoView> componentPath) {
    var nestedPVPromises = [];
    componentPath = MapWrapper.clone(componentPath);
    if (identical(appProtoViews[0].type, renderApi.ViewType.COMPONENT)) {
      componentPath[componentType] = appProtoViews[0];
    }
    appProtoViews.forEach((appProtoView) {
      this
          ._collectComponentElementBinders(appProtoView)
          .forEach((ElementBinder elementBinder) {
        var nestedComponent = elementBinder.componentDirective;
        var nestedComponentType = (nestedComponent.key.token as Type);
        var elementBinderDone = (AppProtoView nestedPv) {
          elementBinder.nestedProtoView = nestedPv;
        };
        if (componentPath.containsKey(nestedComponentType)) {
          // cycle...
          if (appProtoView.isEmbeddedFragment) {
            throw new BaseException(
                '''<ng-content> is used within the recursive path of ${ stringify ( nestedComponentType )}''');
          } else if (identical(
              appProtoView.type, renderApi.ViewType.COMPONENT)) {
            throw new BaseException(
                '''Unconditional component cycle in ${ stringify ( nestedComponentType )}''');
          } else {
            elementBinderDone(componentPath[nestedComponentType]);
          }
        } else {
          var nestedCall = this._compile(nestedComponent, componentPath);
          if (isPromise(nestedCall)) {
            nestedPVPromises.add(
                ((nestedCall as Future<AppProtoView>)).then(elementBinderDone));
          } else {
            elementBinderDone((nestedCall as AppProtoView));
          }
        }
      });
    });
    return PromiseWrapper
        .all(nestedPVPromises)
        .then((_) => PromiseWrapper.all(appProtoViews
            .map((appProtoView) => this._mergeProtoView(appProtoView))
            .toList()))
        .then((_) => appProtoViews[0]);
  }
  Future<dynamic> _mergeProtoView(AppProtoView appProtoView) {
    if (!identical(appProtoView.type, renderApi.ViewType.HOST) &&
        !identical(appProtoView.type, renderApi.ViewType.EMBEDDED)) {
      return null;
    }
    return this._render
        .mergeProtoViewsRecursively(
            this._collectMergeRenderProtoViews(appProtoView))
        .then((renderApi.RenderProtoViewMergeMapping mergeResult) {
      appProtoView.mergeMapping = new AppProtoViewMergeMapping(mergeResult);
    });
  }
  List<dynamic /* renderApi . RenderProtoViewRef | List < dynamic > */ > _collectMergeRenderProtoViews(
      AppProtoView appProtoView) {
    var result = [appProtoView.render];
    for (var i = 0; i < appProtoView.elementBinders.length; i++) {
      var binder = appProtoView.elementBinders[i];
      if (isPresent(binder.nestedProtoView)) {
        if (binder.hasStaticComponent() ||
            (binder.hasEmbeddedProtoView() &&
                binder.nestedProtoView.isEmbeddedFragment)) {
          result
              .add(this._collectMergeRenderProtoViews(binder.nestedProtoView));
        } else {
          result.add(null);
        }
      }
    }
    return result;
  }
  List<ElementBinder> _collectComponentElementBinders(
      AppProtoView appProtoView) {
    var componentElementBinders = [];
    appProtoView.elementBinders.forEach((elementBinder) {
      if (isPresent(elementBinder.componentDirective)) {
        componentElementBinders.add(elementBinder);
      }
    });
    return componentElementBinders;
  }
  renderApi.ViewDefinition _buildRenderTemplate(component, view, directives) {
    var componentUrl = this._urlResolver.resolve(
        this._appUrl, this._componentUrlMapper.getUrl(component));
    var templateAbsUrl = null;
    var styleAbsUrls = null;
    if (isPresent(view.templateUrl)) {
      templateAbsUrl =
          this._urlResolver.resolve(componentUrl, view.templateUrl);
    } else if (isPresent(view.template)) {
      // Note: If we have an inline template, we also need to send

      // the url for the component to the render so that it

      // is able to resolve urls in stylesheets.
      templateAbsUrl = componentUrl;
    }
    if (isPresent(view.styleUrls)) {
      styleAbsUrls = ListWrapper.map(view.styleUrls,
          (url) => this._urlResolver.resolve(componentUrl, url));
    }
    return new renderApi.ViewDefinition(
        componentId: stringify(component),
        templateAbsUrl: templateAbsUrl,
        template: view.template,
        styleAbsUrls: styleAbsUrls,
        styles: view.styles,
        directives: ListWrapper.map(
            directives, (directiveBinding) => directiveBinding.metadata),
        encapsulation: view.encapsulation);
  }
  List<Type> _flattenDirectives(View template) {
    if (isBlank(template.directives)) return [];
    var directives = [];
    this._flattenList(template.directives, directives);
    return directives;
  }
  void _flattenList(List<dynamic> tree,
      List<dynamic /* Type | Binding | List < dynamic > */ > out) {
    for (var i = 0; i < tree.length; i++) {
      var item = resolveForwardRef(tree[i]);
      if (isArray(item)) {
        this._flattenList(item, out);
      } else {
        out.add(item);
      }
    }
  }
  static bool _isValidDirective(dynamic /* Type | Binding */ value) {
    return isPresent(value) && (value is Type || value is Binding);
  }
  static void _assertTypeIsComponent(DirectiveBinding directiveBinding) {
    if (!identical(directiveBinding.metadata.type,
        renderApi.DirectiveMetadata.COMPONENT_TYPE)) {
      throw new BaseException(
          '''Could not load \'${ stringify ( directiveBinding . key . token )}\' because it is not a component.''');
    }
  }
}
