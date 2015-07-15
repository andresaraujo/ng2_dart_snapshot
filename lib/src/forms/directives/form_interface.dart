library angular2.src.forms.directives.form_interface;

import "ng_control.dart" show NgControl;
import "ng_control_group.dart" show NgControlGroup;
import "../model.dart" show Control, ControlGroup;

/**
 * An interface that {@link NgFormModel} and {@link NgForm} implement.
 *
 * Only used by the forms module.
 */
abstract class Form {
  void addControl(NgControl dir);
  void removeControl(NgControl dir);
  Control getControl(NgControl dir);
  void addControlGroup(NgControlGroup dir);
  void removeControlGroup(NgControlGroup dir);
  ControlGroup getControlGroup(NgControlGroup dir);
  void updateModel(NgControl dir, dynamic value);
}
