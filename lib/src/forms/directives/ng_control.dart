library angular2.src.forms.directives.ng_control;

import "control_value_accessor.dart" show ControlValueAccessor;
import "abstract_control_directive.dart" show AbstractControlDirective;

/**
 * An abstract class that all control directive extend.
 *
 * It binds a {@link Control} object to a DOM element.
 */
class NgControl extends AbstractControlDirective {
  String name = null;
  ControlValueAccessor valueAccessor = null;
  Function get validator {
    return null;
  }
  List<String> get path {
    return null;
  }
  void viewToModelUpdate(dynamic newValue) {}
}
