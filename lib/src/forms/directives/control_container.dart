library angular2.src.forms.directives.control_container;

import "form_interface.dart" show Form;
import "abstract_control_directive.dart" show AbstractControlDirective;
import "package:angular2/src/facade/collection.dart" show List;

/**
 * A directive that contains a group of [NgControl].
 *
 * Only used by the forms module.
 */
class ControlContainer extends AbstractControlDirective {
  String name;
  Form get formDirective {
    return null;
  }
  List<String> get path {
    return null;
  }
}
