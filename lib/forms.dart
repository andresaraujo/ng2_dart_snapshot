/**
 * @module
 * @description
 * This module is used for handling user input, by defining and building a {@link ControlGroup} that
 * consists of
 * {@link Control} objects, and mapping them onto the DOM. {@link Control} objects can then be used
 * to read information
 * from the form DOM elements.
 *
 * This module is not included in the `angular2` module; you must import the forms module
 * explicitly.
 *
 */
library angular2.forms;

export "src/forms/model.dart"
    show AbstractControl, Control, ControlGroup, ControlArray;
export "src/forms/directives/abstract_control_directive.dart"
    show AbstractControlDirective;
export "src/forms/directives/form_interface.dart" show Form;
export "src/forms/directives/control_container.dart" show ControlContainer;
export "src/forms/directives/ng_control_name.dart" show NgControlName;
export "src/forms/directives/ng_form_control.dart" show NgFormControl;
export "src/forms/directives/ng_model.dart" show NgModel;
export "src/forms/directives/ng_control.dart" show NgControl;
export "src/forms/directives/ng_control_group.dart" show NgControlGroup;
export "src/forms/directives/ng_form_model.dart" show NgFormModel;
export "src/forms/directives/ng_form.dart" show NgForm;
export "src/forms/directives/control_value_accessor.dart"
    show ControlValueAccessor;
export "src/forms/directives/default_value_accessor.dart"
    show DefaultValueAccessor;
export "src/forms/directives/checkbox_value_accessor.dart"
    show CheckboxControlValueAccessor;
export "src/forms/directives/select_control_value_accessor.dart"
    show SelectControlValueAccessor;
export "src/forms/directives.dart" show formDirectives;
export "src/forms/validators.dart" show Validators;
export "src/forms/directives/validators.dart"
    show NgValidator, NgRequiredValidator;
export "src/forms/form_builder.dart" show FormBuilder;
import "src/forms/form_builder.dart" show FormBuilder;
import "src/facade/lang.dart" show Type;

const List<Type> formInjectables = const [FormBuilder];
