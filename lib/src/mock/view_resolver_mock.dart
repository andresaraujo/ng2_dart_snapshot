library angular2.src.mock.view_resolver_mock;

import "package:angular2/src/facade/collection.dart"
    show Map, MapWrapper, ListWrapper;
import "package:angular2/src/facade/lang.dart"
    show Type, isPresent, BaseException, stringify, isBlank;
import "package:angular2/src/core/annotations_impl/view.dart" show View;
import "package:angular2/src/core/compiler/view_resolver.dart"
    show ViewResolver;

class MockViewResolver extends ViewResolver {
  Map<Type, View> _views = new Map();
  Map<Type, String> _inlineTemplates = new Map();
  Map<Type, View> _viewCache = new Map();
  Map<Type, Map<Type, Type>> _directiveOverrides = new Map();
  MockViewResolver() : super() {
    /* super call moved to initializer */;
  }
  /**
   * Overrides the {@link View} for a component.
   *
   * @param {Type} component
   * @param {ViewDefinition} view
   */
  void setView(Type component, View view) {
    this._checkOverrideable(component);
    this._views[component] = view;
  }
  /**
   * Overrides the inline template for a component - other configuration remains unchanged.
   *
   * @param {Type} component
   * @param {string} template
   */
  void setInlineTemplate(Type component, String template) {
    this._checkOverrideable(component);
    this._inlineTemplates[component] = template;
  }
  /**
   * Overrides a directive from the component {@link View}.
   *
   * @param {Type} component
   * @param {Type} from
   * @param {Type} to
   */
  void overrideViewDirective(Type component, Type from, Type to) {
    this._checkOverrideable(component);
    var overrides = this._directiveOverrides[component];
    if (isBlank(overrides)) {
      overrides = new Map();
      this._directiveOverrides[component] = overrides;
    }
    overrides[from] = to;
  }
  /**
   * Returns the {@link View} for a component:
   * - Set the {@link View} to the overridden view when it exists or fallback to the default
   * `ViewResolver`,
   *   see `setView`.
   * - Override the directives, see `overrideViewDirective`.
   * - Override the @View definition, see `setInlineTemplate`.
   *
   * @param component
   * @returns {ViewDefinition}
   */
  View resolve(Type component) {
    var view = this._viewCache[component];
    if (isPresent(view)) return view;
    view = this._views[component];
    if (isBlank(view)) {
      view = super.resolve(component);
    }
    var directives = view.directives;
    var overrides = this._directiveOverrides[component];
    if (isPresent(overrides) && isPresent(directives)) {
      directives = ListWrapper.clone(view.directives);
      MapWrapper.forEach(overrides, (to, from) {
        var srcIndex = directives.indexOf(from);
        if (srcIndex == -1) {
          throw new BaseException(
              '''Overriden directive ${ stringify ( from )} not found in the template of ${ stringify ( component )}''');
        }
        directives[srcIndex] = to;
      });
      view = new View(
          template: view.template,
          templateUrl: view.templateUrl,
          directives: directives);
    }
    var inlineTemplate = this._inlineTemplates[component];
    if (isPresent(inlineTemplate)) {
      view = new View(
          template: inlineTemplate,
          templateUrl: null,
          directives: view.directives);
    }
    this._viewCache[component] = view;
    return view;
  }
  /**
   * Once a component has been compiled, the AppProtoView is stored in the compiler cache.
   *
   * Then it should not be possible to override the component configuration after the component
   * has been compiled.
   *
   * @param {Type} component
   */
  void _checkOverrideable(Type component) {
    var cached = this._viewCache[component];
    if (isPresent(cached)) {
      throw new BaseException(
          '''The component ${ stringify ( component )} has already been compiled, its configuration can not be changed''');
    }
  }
}
