/**
 * A bridge between a control and a native element.
 *
 * Please see {@link DefaultValueAccessor} for more information.
 */
library angular2.src.forms.directives.control_value_accessor;

abstract class ControlValueAccessor {
  void writeValue(dynamic obj);
  void registerOnChange(dynamic fn);
  void registerOnTouched(dynamic fn);
}
