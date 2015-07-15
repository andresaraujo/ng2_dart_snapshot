library angular2.src.test_lib.test_component_builder;

import "package:angular2/di.dart" show Injector, bind, Injectable;
import "package:angular2/src/facade/lang.dart"
    show Type, isPresent, BaseException, isBlank;
import "package:angular2/src/facade/async.dart" show Future;
import "package:angular2/src/facade/collection.dart"
    show List, ListWrapper, MapWrapper;
import "package:angular2/src/core/annotations_impl/view.dart" show View;
import "package:angular2/src/core/compiler/view_resolver.dart"
    show ViewResolver;
import "package:angular2/src/core/compiler/view.dart" show AppView;
import "package:angular2/src/core/compiler/view_ref.dart" show internalView;
import "package:angular2/src/core/compiler/dynamic_component_loader.dart"
    show DynamicComponentLoader, ComponentRef;
import "utils.dart" show el;
import "package:angular2/src/render/dom/dom_renderer.dart" show DOCUMENT_TOKEN;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/debug/debug_element.dart" show DebugElement;

class RootTestComponent extends DebugElement {
  ComponentRef _componentRef;
  AppView _componentParentView;
  RootTestComponent(ComponentRef componentRef)
      : super(internalView(componentRef.hostView), 0) {
    /* super call moved to initializer */;
    this._componentParentView = internalView(componentRef.hostView);
    this._componentRef = componentRef;
  }
  void detectChanges() {
    this._componentParentView.changeDetector.detectChanges();
    this._componentParentView.changeDetector.checkNoChanges();
  }
  void destroy() {
    this._componentRef.dispose();
  }
}
var _nextRootElementId = 0;
/**
 * Builds a RootTestComponent for use in component level tests.
 */
@Injectable()
class TestComponentBuilder {
  Injector _injector;
  Map<Type, View> _viewOverrides;
  Map<Type, Map<Type, Type>> _directiveOverrides;
  Map<Type, String> _templateOverrides;
  TestComponentBuilder(Injector injector) {
    this._injector = injector;
    this._viewOverrides = new Map();
    this._directiveOverrides = new Map();
    this._templateOverrides = new Map();
  }
  TestComponentBuilder _clone() {
    var clone = new TestComponentBuilder(this._injector);
    clone._viewOverrides = MapWrapper.clone(this._viewOverrides);
    clone._directiveOverrides = MapWrapper.clone(this._directiveOverrides);
    clone._templateOverrides = MapWrapper.clone(this._templateOverrides);
    return clone;
  }
  /**
   * Overrides only the html of a {@link Component}.
   * All the other properties of the component's {@link View} are preserved.
   *
   * @param {Type} component
   * @param {string} html
   *
   * @return {TestComponentBuilder}
   */
  TestComponentBuilder overrideTemplate(Type componentType, String template) {
    var clone = this._clone();
    clone._templateOverrides[componentType] = template;
    return clone;
  }
  /**
   * Overrides a component's {@link View}.
   *
   * @param {Type} component
   * @param {view} View
   *
   * @return {TestComponentBuilder}
   */
  TestComponentBuilder overrideView(Type componentType, View view) {
    var clone = this._clone();
    clone._viewOverrides[componentType] = view;
    return clone;
  }
  /**
   * Overrides the directives from the component {@link View}.
   *
   * @param {Type} component
   * @param {Type} from
   * @param {Type} to
   *
   * @return {TestComponentBuilder}
   */
  TestComponentBuilder overrideDirective(
      Type componentType, Type from, Type to) {
    var clone = this._clone();
    var overridesForComponent = clone._directiveOverrides[componentType];
    if (!isPresent(overridesForComponent)) {
      clone._directiveOverrides[componentType] = new Map();
      overridesForComponent = clone._directiveOverrides[componentType];
    }
    overridesForComponent[from] = to;
    return clone;
  }
  /**
   * Builds and returns a RootTestComponent.
   *
   * @return {Promise<RootTestComponent>}
   */
  Future<RootTestComponent> createAsync(Type rootComponentType) {
    var mockViewResolver = this._injector.get(ViewResolver);
    MapWrapper.forEach(this._viewOverrides, (view, type) {
      mockViewResolver.setView(type, view);
    });
    MapWrapper.forEach(this._templateOverrides, (template, type) {
      mockViewResolver.setInlineTemplate(type, template);
    });
    MapWrapper.forEach(this._directiveOverrides, (overrides, component) {
      MapWrapper.forEach(overrides, (to, from) {
        mockViewResolver.overrideViewDirective(component, from, to);
      });
    });
    var rootElId = '''root${ _nextRootElementId ++}''';
    var rootEl = el('''<div id="${ rootElId}"></div>''');
    var doc = this._injector.get(DOCUMENT_TOKEN);
    // TODO(juliemr): can/should this be optional?
    DOM.appendChild(doc.body, rootEl);
    return this._injector
        .get(DynamicComponentLoader)
        .loadAsRoot(rootComponentType, '''#${ rootElId}''', this._injector)
        .then((componentRef) {
      return new RootTestComponent(componentRef);
    });
  }
}
