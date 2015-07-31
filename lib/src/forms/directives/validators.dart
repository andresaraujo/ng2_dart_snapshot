library angular2.src.forms.directives.validators;

import "package:angular2/di.dart" show Binding;
import "package:angular2/annotations.dart" show Directive;
import "../validators.dart" show Validators;

class NgValidator {
  Function get validator {
    throw "Is not implemented";
  }
}
const requiredValidatorBinding =
    const Binding(NgValidator, toAlias: NgRequiredValidator);
@Directive(
    selector: "[required][ng-control],[required][ng-form-control],[required][ng-model]",
    bindings: const [requiredValidatorBinding])
class NgRequiredValidator extends NgValidator {
  Function get validator {
    return Validators.required;
  }
}
