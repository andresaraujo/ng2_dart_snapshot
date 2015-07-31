library angular2.src.forms.directives.select_control_value_accessor;

import "package:angular2/render.dart" show Renderer;
import "package:angular2/core.dart" show ElementRef, QueryList;
import "package:angular2/di.dart" show Self;
import "package:angular2/annotations.dart" show Query, Directive;
import "ng_control.dart" show NgControl;
import "control_value_accessor.dart" show ControlValueAccessor;
import "package:angular2/src/facade/lang.dart" show isPresent;
import "shared.dart" show setProperty;

/**
 * Marks <option> as dynamic, so Angular can be notified when options change.
 *
 * #Example:
 *
 * ```
 * <select ng-control="city">
 *   <option *ng-for="#c of cities" [value]="c"></option>
 * </select>
 * ```
 */
@Directive(selector: "option")
class NgSelectOption {}
/**
 * The accessor for writing a value and listening to changes on a select element.
 */
@Directive(
    selector: "select[ng-control],select[ng-form-control],select[ng-model]",
    host: const {
  "(change)": "onChange(\$event.target.value)",
  "(input)": "onChange(\$event.target.value)",
  "(blur)": "onTouched()",
  "[class.ng-untouched]": "ngClassUntouched",
  "[class.ng-touched]": "ngClassTouched",
  "[class.ng-pristine]": "ngClassPristine",
  "[class.ng-dirty]": "ngClassDirty",
  "[class.ng-valid]": "ngClassValid",
  "[class.ng-invalid]": "ngClassInvalid"
})
class SelectControlValueAccessor implements ControlValueAccessor {
  Renderer renderer;
  ElementRef elementRef;
  NgControl cd;
  String value;
  var onChange = (_) {};
  var onTouched = () {};
  SelectControlValueAccessor(@Self() NgControl cd, this.renderer,
      this.elementRef, @Query(NgSelectOption,
          descendants: true) QueryList<NgSelectOption> query) {
    this.cd = cd;
    cd.valueAccessor = this;
    this._updateValueWhenListOfOptionsChanges(query);
  }
  writeValue(dynamic value) {
    this.value = value;
    setProperty(this.renderer, this.elementRef, "value", value);
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
  void registerOnChange(dynamic /* () => any */ fn) {
    this.onChange = fn;
  }
  void registerOnTouched(dynamic /* () => any */ fn) {
    this.onTouched = fn;
  }
  _updateValueWhenListOfOptionsChanges(QueryList<NgSelectOption> query) {
    query.onChange(() => this.writeValue(this.value));
  }
}
