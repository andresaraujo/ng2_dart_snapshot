library angular2.src.forms.directives.ng_form;

import "package:angular2/src/facade/async.dart"
    show PromiseWrapper, ObservableWrapper, EventEmitter, PromiseCompleter;
import "package:angular2/src/facade/collection.dart"
    show StringMapWrapper, List, ListWrapper;
import "package:angular2/src/facade/lang.dart" show isPresent, isBlank;
import "package:angular2/annotations.dart" show Directive;
import "package:angular2/di.dart" show Binding;
import "ng_control.dart" show NgControl;
import "form_interface.dart" show Form;
import "ng_control_group.dart" show NgControlGroup;
import "control_container.dart" show ControlContainer;
import "../model.dart" show AbstractControl, ControlGroup, Control;
import "shared.dart" show setUpControl;

const formDirectiveBinding = const Binding(ControlContainer, toAlias: NgForm);
/**
 * Creates and binds a form object to a DOM element.
 *
 * # Example
 *
 *  ```
 * @Component({selector: "signup-comp"})
 * @View({
 *      directives: [formDirectives],
 *      template: `
 *              <form #f="form" (submit)='onSignUp(f.value)'>
 *                <div ng-control-group='credentials' #credentials="form">
 *                  Login <input type='text' ng-control='login'>
 *                  Password <input type='password' ng-control='password'>
 *                </div>
 *                <div *ng-if="!credentials.valid">Credentials are invalid</div>
 *
 *                <div ng-control-group='personal'>
 *                  Name <input type='text' ng-control='name'>
 *                </div>
 *                <button type='submit'>Sign Up!</button>
 *              </form>
 *      `})
 * class SignupComp {
 *  onSignUp(value) {
 *    // value === {personal: {name: 'some name'},
 *    //  credentials: {login: 'some login', password: 'some password'}}
 *  }
 * }
 *
 *  ```
 */
@Directive(
    selector: "form:not([ng-no-form]):not([ng-form-model]),ng-form,[ng-form]",
    bindings: const [formDirectiveBinding],
    host: const {"(submit)": "onSubmit()"},
    events: const ["ngSubmit"],
    exportAs: "form")
class NgForm extends ControlContainer implements Form {
  ControlGroup form;
  var ngSubmit = new EventEmitter();
  NgForm() : super() {
    /* super call moved to initializer */;
    this.form = new ControlGroup({});
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
  Map<String, AbstractControl> get controls {
    return this.form.controls;
  }
  void addControl(NgControl dir) {
    this._later((_) {
      var container = this._findContainer(dir.path);
      var c = new Control();
      setUpControl(c, dir);
      container.addControl(dir.name, c);
      c.updateValidity();
    });
  }
  Control getControl(NgControl dir) {
    return (this.form.find(dir.path) as Control);
  }
  void removeControl(NgControl dir) {
    this._later((_) {
      var container = this._findContainer(dir.path);
      if (isPresent(container)) {
        container.removeControl(dir.name);
        container.updateValidity();
      }
    });
  }
  void addControlGroup(NgControlGroup dir) {
    this._later((_) {
      var container = this._findContainer(dir.path);
      var c = new ControlGroup({});
      container.addControl(dir.name, c);
      c.updateValidity();
    });
  }
  void removeControlGroup(NgControlGroup dir) {
    this._later((_) {
      var container = this._findContainer(dir.path);
      if (isPresent(container)) {
        container.removeControl(dir.name);
        container.updateValidity();
      }
    });
  }
  ControlGroup getControlGroup(NgControlGroup dir) {
    return (this.form.find(dir.path) as ControlGroup);
  }
  void updateModel(NgControl dir, dynamic value) {
    this._later((_) {
      var c = (this.form.find(dir.path) as Control);
      c.updateValue(value);
    });
  }
  bool onSubmit() {
    ObservableWrapper.callNext(this.ngSubmit, null);
    return false;
  }
  ControlGroup _findContainer(List<String> path) {
    ListWrapper.removeLast(path);
    return ListWrapper.isEmpty(path)
        ? this.form
        : (this.form.find(path) as ControlGroup);
  }
  _later(fn) {
    PromiseCompleter<dynamic> c = PromiseWrapper.completer();
    PromiseWrapper.then(c.promise, fn, (_) {});
    c.resolve(null);
  }
}
