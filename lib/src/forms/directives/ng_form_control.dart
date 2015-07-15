library angular2.src.forms.directives.ng_form_control;

import "package:angular2/src/facade/collection.dart" show StringMapWrapper;
import "package:angular2/src/facade/async.dart"
    show EventEmitter, ObservableWrapper;
import "package:angular2/angular2.dart"
    show Directive, LifecycleEvent, Query, QueryList;
import "package:angular2/di.dart" show Ancestor, Binding;
import "ng_control.dart" show NgControl;
import "../model.dart" show Control;
import "validators.dart" show NgValidator;
import "shared.dart" show setUpControl, composeNgValidator;

const formControlBinding = const Binding(NgControl, toAlias: NgFormControl);
/**
 * Binds an existing control to a DOM element.
 *
 * # Example
 *
 * In this example, we bind the control to an input element. When the value of the input element
 * changes, the value of
 * the control will reflect that change. Likewise, if the value of the control changes, the input
 * element reflects that
 * change.
 *
 *  ```
 * @Component({selector: "login-comp"})
 * @View({
 *      directives: [formDirectives],
 *      template: "<input type='text' [ng-form-control]='loginControl'>"
 *      })
 * class LoginComp {
 *  loginControl:Control;
 *
 *  constructor() {
 *    this.loginControl = new Control('');
 *  }
 * }
 *
 *  ```
 *
 * We can also use ng-model to bind a domain model to the form.
 *
 *  ```
 * @Component({selector: "login-comp"})
 * @View({
 *      directives: [formDirectives],
 *      template: "<input type='text' [ng-form-control]='loginControl' [(ng-model)]='login'>"
 *      })
 * class LoginComp {
 *  loginControl:Control;
 *  login:string;
 *
 *  constructor() {
 *    this.loginControl = new Control('');
 *  }
 * }
 *  ```
 */
@Directive(
    selector: "[ng-form-control]",
    hostInjector: const [formControlBinding],
    properties: const ["form: ngFormControl", "model: ngModel"],
    events: const ["update: ngModel"],
    lifecycle: const [LifecycleEvent.onChange],
    exportAs: "form")
class NgFormControl extends NgControl {
  Control form;
  var update = new EventEmitter();
  var _added = false;
  dynamic model;
  QueryList<NgValidator> ngValidators;
  // Scope the query once https://github.com/angular/angular/issues/2603 is fixed
  NgFormControl(@Query(NgValidator) QueryList<NgValidator> ngValidators)
      : super() {
    /* super call moved to initializer */;
    this.ngValidators = ngValidators;
  }
  onChange(c) {
    if (!this._added) {
      setUpControl(this.form, this);
      this.form.updateValidity();
      this._added = true;
    }
    if (StringMapWrapper.contains(c, "model")) {
      this.form.updateValue(this.model);
    }
  }
  List<String> get path {
    return [];
  }
  Control get control {
    return this.form;
  }
  Function get validator {
    return composeNgValidator(this.ngValidators);
  }
  void viewToModelUpdate(dynamic newValue) {
    ObservableWrapper.callNext(this.update, newValue);
  }
}
