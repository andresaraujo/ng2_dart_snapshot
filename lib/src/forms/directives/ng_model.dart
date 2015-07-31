library angular2.src.forms.directives.ng_model;

import "package:angular2/src/facade/async.dart"
    show EventEmitter, ObservableWrapper;
import "package:angular2/core.dart" show QueryList;
import "package:angular2/annotations.dart"
    show Query, Directive, LifecycleEvent;
import "package:angular2/di.dart" show Binding;
import "ng_control.dart" show NgControl;
import "../model.dart" show Control;
import "validators.dart" show NgValidator;
import "shared.dart" show setUpControl, composeNgValidator, isPropertyUpdated;

const formControlBinding = const Binding(NgControl, toAlias: NgModel);
/**
 * Binds a domain model to the form.
 *
 * # Example
 *  ```
 * @Component({selector: "search-comp"})
 * @View({
 *      directives: [formDirectives],
 *      template: `
              <input type='text' [(ng-model)]="searchQuery">
 *      `})
 * class SearchComp {
 *  searchQuery: string;
 * }
 *  ```
 */
@Directive(
    selector: "[ng-model]:not([ng-control]):not([ng-form-control])",
    bindings: const [formControlBinding],
    properties: const ["model: ngModel"],
    events: const ["update: ngModel"],
    lifecycle: const [LifecycleEvent.onChange],
    exportAs: "form")
class NgModel extends NgControl {
  var _control = new Control();
  var _added = false;
  var update = new EventEmitter();
  dynamic model;
  dynamic viewModel;
  QueryList<NgValidator> ngValidators;
  // Scope the query once https://github.com/angular/angular/issues/2603 is fixed
  NgModel(@Query(NgValidator) QueryList<NgValidator> ngValidators) : super() {
    /* super call moved to initializer */;
    this.ngValidators = ngValidators;
  }
  onChange(Map<String, dynamic> c) {
    if (!this._added) {
      setUpControl(this._control, this);
      this._control.updateValidity();
      this._added = true;
    }
    if (isPropertyUpdated(c, this.viewModel)) {
      this._control.updateValue(this.model);
    }
  }
  Control get control {
    return this._control;
  }
  List<String> get path {
    return [];
  }
  Function get validator {
    return composeNgValidator(this.ngValidators);
  }
  void viewToModelUpdate(dynamic newValue) {
    this.viewModel = newValue;
    ObservableWrapper.callNext(this.update, newValue);
  }
}
