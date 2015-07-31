library angular2.src.forms.directives.ng_form_model;

import "package:angular2/src/facade/collection.dart" show List, ListWrapper;
import "package:angular2/src/facade/async.dart"
    show ObservableWrapper, EventEmitter;
import "package:angular2/annotations.dart" show Directive, LifecycleEvent;
import "package:angular2/di.dart" show Binding;
import "ng_control.dart" show NgControl;
import "ng_control_group.dart" show NgControlGroup;
import "control_container.dart" show ControlContainer;
import "form_interface.dart" show Form;
import "../model.dart" show Control, ControlGroup;
import "shared.dart" show setUpControl;

const formDirectiveBinding =
    const Binding(ControlContainer, toAlias: NgFormModel);
/**
 * Binds an existing control group to a DOM element.
 *
 * # Example
 *
 * In this example, we bind the control group to the form element, and we bind the login and
 * password controls to the
 * login and password elements.
 *
 *  ```
 * @Component({selector: "login-comp"})
 * @View({
 *      directives: [formDirectives],
 *      template: "<form [ng-form-model]='loginForm'>" +
 *              "Login <input type='text' ng-control='login'>" +
 *              "Password <input type='password' ng-control='password'>" +
 *              "<button (click)="onLogin()">Login</button>" +
 *              "</form>"
 *      })
 * class LoginComp {
 *  loginForm:ControlGroup;
 *
 *  constructor() {
 *    this.loginForm = new ControlGroup({
 *      login: new Control(""),
 *      password: new Control("")
 *    });
 *  }
 *
 *  onLogin() {
 *    // this.loginForm.value
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
 *      template: "<form [ng-form-model]='loginForm'>" +
 *              "Login <input type='text' ng-control='login' [(ng-model)]='login'>" +
 *              "Password <input type='password' ng-control='password' [(ng-model)]='password'>" +
 *              "<button (click)="onLogin()">Login</button>" +
 *              "</form>"
 *      })
 * class LoginComp {
 *  credentials:{login:string, password:string}
 *  loginForm:ControlGroup;
 *
 *  constructor() {
 *    this.loginForm = new ControlGroup({
 *      login: new Control(""),
 *      password: new Control("")
 *    });
 *  }
 *
 *  onLogin() {
 *    // this.credentials.login === 'some login'
 *    // this.credentials.password === 'some password'
 *  }
 * }
 *  ```
 */
@Directive(
    selector: "[ng-form-model]",
    bindings: const [formDirectiveBinding],
    properties: const ["form: ng-form-model"],
    lifecycle: const [LifecycleEvent.onChange],
    host: const {"(submit)": "onSubmit()"},
    events: const ["ngSubmit"],
    exportAs: "form")
class NgFormModel extends ControlContainer implements Form {
  ControlGroup form = null;
  List<NgControl> directives = [];
  var ngSubmit = new EventEmitter();
  onChange(_) {
    this._updateDomValue();
  }
  Form get formDirective {
    return this;
  }
  ControlGroup get control {
    return this.form;
  }
  List<String> get path {
    return [];
  }
  void addControl(NgControl dir) {
    dynamic c = this.form.find(dir.path);
    setUpControl(c, dir);
    c.updateValidity();
    this.directives.add(dir);
  }
  Control getControl(NgControl dir) {
    return (this.form.find(dir.path) as Control);
  }
  void removeControl(NgControl dir) {
    ListWrapper.remove(this.directives, dir);
  }
  addControlGroup(NgControlGroup dir) {}
  removeControlGroup(NgControlGroup dir) {}
  ControlGroup getControlGroup(NgControlGroup dir) {
    return (this.form.find(dir.path) as ControlGroup);
  }
  void updateModel(NgControl dir, dynamic value) {
    var c = (this.form.find(dir.path) as Control);
    c.updateValue(value);
  }
  bool onSubmit() {
    ObservableWrapper.callNext(this.ngSubmit, null);
    return false;
  }
  _updateDomValue() {
    ListWrapper.forEach(this.directives, (dir) {
      dynamic c = this.form.find(dir.path);
      dir.valueAccessor.writeValue(c.value);
    });
  }
}
