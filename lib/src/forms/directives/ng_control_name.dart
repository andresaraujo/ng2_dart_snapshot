library angular2.src.forms.directives.ng_control_name;

import "package:angular2/src/facade/async.dart"
    show EventEmitter, ObservableWrapper;
import "package:angular2/src/facade/collection.dart" show List, Map;
import "package:angular2/core.dart" show QueryList;
import "package:angular2/annotations.dart"
    show Query, Directive, LifecycleEvent;
import "package:angular2/di.dart" show Host, SkipSelf, Binding, Inject;
import "control_container.dart" show ControlContainer;
import "ng_control.dart" show NgControl;
import "validators.dart" show NgValidator;
import "shared.dart" show controlPath, composeNgValidator, isPropertyUpdated;
import "../model.dart" show Control;

const controlNameBinding = const Binding(NgControl, toAlias: NgControlName);
/**
 * Creates and binds a control with a specified name to a DOM element.
 *
 * This directive can only be used as a child of {@link NgForm} or {@link NgFormModel}.

 * # Example
 *
 * In this example, we create the login and password controls.
 * We can work with each control separately: check its validity, get its value, listen to its
 changes.
 *
 *  ```
 * @Component({selector: "login-comp"})
 * @View({
 *      directives: [formDirectives],
 *      template: `
 *              <form #f="form" (submit)='onLogIn(f.value)'>
 *                Login <input type='text' ng-control='login' #l="form">
 *                <div *ng-if="!l.valid">Login is invalid</div>
 *
 *                Password <input type='password' ng-control='password'>

 *                <button type='submit'>Log in!</button>
 *              </form>
 *      `})
 * class LoginComp {
 *  onLogIn(value) {
 *    // value === {login: 'some login', password: 'some password'}
 *  }
 * }
 *  ```
 *
 * We can also use ng-model to bind a domain model to the form.
 *
 *  ```
 * @Component({selector: "login-comp"})
 * @View({
 *      directives: [formDirectives],
 *      template: `
 *              <form (submit)='onLogIn()'>
 *                Login <input type='text' ng-control='login' [(ng-model)]="credentials.login">
 *                Password <input type='password' ng-control='password'
 [(ng-model)]="credentials.password">
 *                <button type='submit'>Log in!</button>
 *              </form>
 *      `})
 * class LoginComp {
 *  credentials: {login:string, password:string};
 *
 *  onLogIn() {
 *    // this.credentials.login === "some login"
 *    // this.credentials.password === "some password"
 *  }
 * }
 *  ```
 */
@Directive(
    selector: "[ng-control]",
    bindings: const [controlNameBinding],
    properties: const ["name: ngControl", "model: ngModel"],
    events: const ["update: ngModel"],
    lifecycle: const [LifecycleEvent.onDestroy, LifecycleEvent.onChange],
    exportAs: "form")
class NgControlName extends NgControl {
  ControlContainer _parent;
  var update = new EventEmitter();
  dynamic model;
  dynamic viewModel;
  QueryList<NgValidator> ngValidators;
  var _added = false;
  // Scope the query once https://github.com/angular/angular/issues/2603 is fixed
  NgControlName(@Host() @SkipSelf() ControlContainer parent,
      @Query(NgValidator) QueryList<NgValidator> ngValidators)
      : super() {
    /* super call moved to initializer */;
    this._parent = parent;
    this.ngValidators = ngValidators;
  }
  onChange(Map<String, dynamic> c) {
    if (!this._added) {
      this.formDirective.addControl(this);
      this._added = true;
    }
    if (isPropertyUpdated(c, this.viewModel)) {
      this.viewModel = this.model;
      this.formDirective.updateModel(this, this.model);
    }
  }
  onDestroy() {
    this.formDirective.removeControl(this);
  }
  void viewToModelUpdate(dynamic newValue) {
    this.viewModel = newValue;
    ObservableWrapper.callNext(this.update, newValue);
  }
  List<String> get path {
    return controlPath(this.name, this._parent);
  }
  dynamic get formDirective {
    return this._parent.formDirective;
  }
  Control get control {
    return this.formDirective.getControl(this);
  }
  Function get validator {
    return composeNgValidator(this.ngValidators);
  }
}
