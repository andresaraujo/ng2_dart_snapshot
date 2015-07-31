library angular2.src.directives.ng_switch;

import "package:angular2/annotations.dart" show Directive;
import "package:angular2/di.dart" show Host;
import "package:angular2/core.dart" show ViewContainerRef, TemplateRef;
import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, normalizeBlank;
import "package:angular2/src/facade/collection.dart"
    show ListWrapper, List, MapWrapper, Map;

class SwitchView {
  ViewContainerRef _viewContainerRef;
  TemplateRef _templateRef;
  SwitchView(ViewContainerRef viewContainerRef, TemplateRef templateRef) {
    this._templateRef = templateRef;
    this._viewContainerRef = viewContainerRef;
  }
  create() {
    this._viewContainerRef.createEmbeddedView(this._templateRef);
  }
  destroy() {
    this._viewContainerRef.clear();
  }
}
/**
 * The `NgSwitch` directive is used to conditionally swap DOM structure on your template based on a
 * scope expression.
 * Elements within `NgSwitch` but without `NgSwitchWhen` or `NgSwitchDefault` directives will be
 * preserved at the location as specified in the template.
 *
 * `NgSwitch` simply chooses nested elements and makes them visible based on which element matches
 * the value obtained from the evaluated expression. In other words, you define a container element
 * (where you place the directive), place an expression on the **`[ng-switch]="..."` attribute**),
 * define any inner elements inside of the directive and place a `[ng-switch-when]` attribute per
 * element.
 * The when attribute is used to inform NgSwitch which element to display when the expression is
 * evaluated. If a matching expression is not found via a when attribute then an element with the
 * default attribute is displayed.
 *
 * # Example:
 *
 * ```
 * <ANY [ng-switch]="expression">
 *   <template [ng-switch-when]="whenExpression1">...</template>
 *   <template [ng-switch-when]="whenExpression1">...</template>
 *   <template ng-switch-default>...</template>
 * </ANY>
 * ```
 */
@Directive(selector: "[ng-switch]", properties: const ["ngSwitch"])
class NgSwitch {
  dynamic _switchValue;
  bool _useDefault;
  Map<dynamic, List<SwitchView>> _valueViews;
  List<SwitchView> _activeViews;
  NgSwitch() {
    this._valueViews = new Map();
    this._activeViews = [];
    this._useDefault = false;
  }
  set ngSwitch(value) {
    // Empty the currently active ViewContainers
    this._emptyAllActiveViews();
    // Add the ViewContainers matching the value (with a fallback to default)
    this._useDefault = false;
    var views = this._valueViews[value];
    if (isBlank(views)) {
      this._useDefault = true;
      views = normalizeBlank(this._valueViews[_whenDefault]);
    }
    this._activateViews(views);
    this._switchValue = value;
  }
  void _onWhenValueChanged(oldWhen, newWhen, SwitchView view) {
    this._deregisterView(oldWhen, view);
    this._registerView(newWhen, view);
    if (identical(oldWhen, this._switchValue)) {
      view.destroy();
      ListWrapper.remove(this._activeViews, view);
    } else if (identical(newWhen, this._switchValue)) {
      if (this._useDefault) {
        this._useDefault = false;
        this._emptyAllActiveViews();
      }
      view.create();
      this._activeViews.add(view);
    }
    // Switch to default when there is no more active ViewContainers
    if (identical(this._activeViews.length, 0) && !this._useDefault) {
      this._useDefault = true;
      this._activateViews(this._valueViews[_whenDefault]);
    }
  }
  void _emptyAllActiveViews() {
    var activeContainers = this._activeViews;
    for (var i = 0; i < activeContainers.length; i++) {
      activeContainers[i].destroy();
    }
    this._activeViews = [];
  }
  void _activateViews(List<SwitchView> views) {
    // TODO(vicb): assert(this._activeViews.length === 0);
    if (isPresent(views)) {
      for (var i = 0; i < views.length; i++) {
        views[i].create();
      }
      this._activeViews = views;
    }
  }
  void _registerView(value, SwitchView view) {
    var views = this._valueViews[value];
    if (isBlank(views)) {
      views = [];
      this._valueViews[value] = views;
    }
    views.add(view);
  }
  void _deregisterView(value, SwitchView view) {
    // `_whenDefault` is used a marker for non-registered whens
    if (value == _whenDefault) return;
    var views = this._valueViews[value];
    if (views.length == 1) {
      MapWrapper.delete(this._valueViews, value);
    } else {
      ListWrapper.remove(views, view);
    }
  }
}
/**
 * Defines a case statement as an expression.
 *
 * If multiple `NgSwitchWhen` match the `NgSwitch` value, all of them are displayed.
 *
 * Example:
 *
 * ```
 * // match against a context variable
 * <template [ng-switch-when]="contextVariable">...</template>
 *
 * // match against a constant string
 * <template ng-switch-when="stringValue">...</template>
 * ```
 */
@Directive(selector: "[ng-switch-when]", properties: const ["ngSwitchWhen"])
class NgSwitchWhen {
  dynamic _value;
  NgSwitch _switch;
  SwitchView _view;
  NgSwitchWhen(ViewContainerRef viewContainer, TemplateRef templateRef,
      @Host() NgSwitch sswitch) {
    // `_whenDefault` is used as a marker for a not yet initialized value
    this._value = _whenDefault;
    this._switch = sswitch;
    this._view = new SwitchView(viewContainer, templateRef);
  }
  onDestroy() {
    this._switch;
  }
  set ngSwitchWhen(value) {
    this._switch._onWhenValueChanged(this._value, value, this._view);
    this._value = value;
  }
}
/**
 * Defines a default case statement.
 *
 * Default case statements are displayed when no `NgSwitchWhen` match the `ng-switch` value.
 *
 * Example:
 *
 * ```
 * <template ng-switch-default>...</template>
 * ```
 */
@Directive(selector: "[ng-switch-default]")
class NgSwitchDefault {
  NgSwitchDefault(ViewContainerRef viewContainer, TemplateRef templateRef,
      @Host() NgSwitch sswitch) {
    sswitch._registerView(
        _whenDefault, new SwitchView(viewContainer, templateRef));
  }
}
var _whenDefault = new Object();
