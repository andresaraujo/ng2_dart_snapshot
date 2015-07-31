library angular2.src.forms.directives.ng_control_group;

import "package:angular2/annotations.dart" show Directive, LifecycleEvent;
import "package:angular2/di.dart" show Inject, Host, SkipSelf, Binding;
import "package:angular2/src/facade/collection.dart" show List, ListWrapper;
import "control_container.dart" show ControlContainer;
import "shared.dart" show controlPath;
import "../model.dart" show ControlGroup;
import "form_interface.dart" show Form;

const controlGroupBinding =
    const Binding(ControlContainer, toAlias: NgControlGroup);
/**
 * Creates and binds a control group to a DOM element.
 *
 * This directive can only be used as a child of {@link NgForm} or {@link NgFormModel}.
 *
 * # Example
 *
 * In this example, we create the credentials and personal control groups.
 * We can work with each group separately: check its validity, get its value, listen to its changes.
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
    selector: "[ng-control-group]",
    bindings: const [controlGroupBinding],
    properties: const ["name: ng-control-group"],
    lifecycle: const [LifecycleEvent.onInit, LifecycleEvent.onDestroy],
    exportAs: "form")
class NgControlGroup extends ControlContainer {
  ControlContainer _parent;
  NgControlGroup(@Host() @SkipSelf() ControlContainer _parent) : super() {
    /* super call moved to initializer */;
    this._parent = _parent;
  }
  onInit() {
    this.formDirective.addControlGroup(this);
  }
  onDestroy() {
    this.formDirective.removeControlGroup(this);
  }
  ControlGroup get control {
    return this.formDirective.getControlGroup(this);
  }
  List<String> get path {
    return controlPath(this.name, this._parent);
  }
  Form get formDirective {
    return this._parent.formDirective;
  }
}
