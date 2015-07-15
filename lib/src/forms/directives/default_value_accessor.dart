library angular2.src.forms.directives.default_value_accessor;

import "package:angular2/render.dart" show Renderer;
import "package:angular2/annotations.dart" show Directive;
import "package:angular2/core.dart" show ElementRef;
import "ng_control.dart" show NgControl;
import "control_value_accessor.dart" show ControlValueAccessor;
import "package:angular2/src/facade/lang.dart" show isBlank, isPresent;
import "shared.dart" show setProperty;

/**
 * The default accessor for writing a value and listening to changes that is used by the
 * {@link NgModel}, {@link NgFormControl}, and {@link NgControlName} directives.
 *
 *  # Example
 *  ```
 *  <input type="text" [(ng-model)]="searchQuery">
 *  ```
 */
@Directive(
    selector: "input:not([type=checkbox])[ng-control],textarea[ng-control],input:not([type=checkbox])[ng-form-control],textarea[ng-form-control],input:not([type=checkbox])[ng-model],textarea[ng-model]",
    host: const {
  "(change)": "onChange(\$event.target.value)",
  "(input)": "onChange(\$event.target.value)",
  "(blur)": "onTouched()",
  "[value]": "value",
  "[class.ng-untouched]": "ngClassUntouched",
  "[class.ng-touched]": "ngClassTouched",
  "[class.ng-pristine]": "ngClassPristine",
  "[class.ng-dirty]": "ngClassDirty",
  "[class.ng-valid]": "ngClassValid",
  "[class.ng-invalid]": "ngClassInvalid"
})
class DefaultValueAccessor implements ControlValueAccessor {
  NgControl cd;
  Renderer renderer;
  ElementRef elementRef;
  String value = null;
  var onChange = (_) {};
  var onTouched = () {};
  DefaultValueAccessor(this.cd, this.renderer, this.elementRef) {
    cd.valueAccessor = this;
  }
  writeValue(value) {
    // both this.value and setProperty are required at the moment

    // remove when a proper imperative API is provided
    this.value = isBlank(value) ? "" : value;
    setProperty(this.renderer, this.elementRef, "value", this.value);
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
