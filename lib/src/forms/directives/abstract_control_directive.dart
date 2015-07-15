library angular2.src.forms.directives.abstract_control_directive;

import "../model.dart" show AbstractControl;

class AbstractControlDirective {
  AbstractControl get control {
    return null;
  }
  dynamic get value {
    return this.control.value;
  }
  bool get valid {
    return this.control.valid;
  }
  Map<String, dynamic> get errors {
    return this.control.errors;
  }
  bool get pristine {
    return this.control.pristine;
  }
  bool get dirty {
    return this.control.dirty;
  }
  bool get touched {
    return this.control.touched;
  }
  bool get untouched {
    return this.control.untouched;
  }
}
