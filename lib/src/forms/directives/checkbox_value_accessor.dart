library angular2.src.forms.directives.checkbox_value_accessor;

import "package:angular2/render.dart" show Renderer;
import "package:angular2/annotations.dart" show Directive;
import "package:angular2/core.dart" show ElementRef;
import "ng_control.dart" show NgControl;
import "control_value_accessor.dart" show ControlValueAccessor;
import "package:angular2/src/facade/lang.dart" show isPresent;
import "shared.dart" show setProperty;

/**
 * The accessor for writing a value and listening to changes on a checkbox input element.
 *
 *  # Example
 *  ```
 *  <input type="checkbox" [ng-control]="rememberLogin">
 *  ```
 */
@Directive(
    selector: "input[type=checkbox][ng-control],input[type=checkbox][ng-form-control],input[type=checkbox][ng-model]",
    host: const {
  "(change)": "onChange(\$event.target.checked)",
  "(blur)": "onTouched()",
  "[checked]": "checked",
  "[class.ng-untouched]": "ngClassUntouched",
  "[class.ng-touched]": "ngClassTouched",
  "[class.ng-pristine]": "ngClassPristine",
  "[class.ng-dirty]": "ngClassDirty",
  "[class.ng-valid]": "ngClassValid",
  "[class.ng-invalid]": "ngClassInvalid"
})
class CheckboxControlValueAccessor implements ControlValueAccessor {
  NgControl cd;
  Renderer renderer;
  ElementRef elementRef;
  bool checked;
  var onChange = (_) {};
  var onTouched = () {};
  CheckboxControlValueAccessor(this.cd, this.renderer, this.elementRef) {
    cd.valueAccessor = this;
  }
  writeValue(value) {
    // both this.checked and setProperty are required at the moment

    // remove when a proper imperative API is provided
    this.checked = value;
    setProperty(this.renderer, this.elementRef, "checked", value);
  }
  bool get ngClassUntouched {
    return isPresent(this.cd.control) ? this.cd.control.untouched : false;
  }
  bool get ngClassTouched {
    return isPresent(this.cd.control) ? this.cd.control.touched : false;
  }
  bool get ngClassPristine {
    return isPresent(this.cd.control) ? this.cd.control.pristine : false;
  }
  bool get ngClassDirty {
    return isPresent(this.cd.control) ? this.cd.control.dirty : false;
  }
  bool get ngClassValid {
    return isPresent(this.cd.control) ? this.cd.control.valid : false;
  }
  bool get ngClassInvalid {
    return isPresent(this.cd.control) ? !this.cd.control.valid : false;
  }
  void registerOnChange(fn) {
    this.onChange = fn;
  }
  void registerOnTouched(fn) {
    this.onTouched = fn;
  }
}
