library angular2.src.forms.model;

import "package:angular2/src/facade/lang.dart"
    show StringWrapper, isPresent, isBlank;
import "package:angular2/src/facade/async.dart"
    show Stream, EventEmitter, ObservableWrapper;
import "package:angular2/src/facade/collection.dart"
    show Map, StringMapWrapper, ListWrapper, List;
import "validators.dart" show Validators;

/**
 * Indicates that a Control is valid, i.e. that no errors exist in the input value.
 */
const VALID = "VALID";
/**
 * Indicates that a Control is invalid, i.e. that an error exists in the input value.
 */
const INVALID = "INVALID";
bool isControl(Object c) {
  return c is AbstractControl;
}
_find(AbstractControl c,
    dynamic /* List < dynamic /* String | num */ > | String */ path) {
  if (isBlank(path)) return null;
  if (!(path is List)) {
    path = StringWrapper.split((path as String), new RegExp("/"));
  }
  if (ListWrapper.isEmpty(path)) return null;
  return ListWrapper.reduce((path as List<dynamic /* String | num */ >),
      (v, name) {
    if (v is ControlGroup) {
      return isPresent(v.controls[name]) ? v.controls[name] : null;
    } else if (v is ControlArray) {
      var index = (name as num);
      return isPresent(v.at(index)) ? v.at(index) : null;
    } else {
      return null;
    }
  }, c);
}
/**
 * Omitting from external API doc as this is really an abstract internal concept.
 */
class AbstractControl {
  dynamic _value;
  String _status;
  Map<String, dynamic> _errors;
  bool _pristine;
  bool _touched;
  dynamic /* ControlGroup | ControlArray */ _parent;
  Function validator;
  EventEmitter _valueChanges;
  AbstractControl(Function validator) {
    this.validator = validator;
    this._pristine = true;
    this._touched = false;
  }
  dynamic get value {
    return this._value;
  }
  String get status {
    return this._status;
  }
  bool get valid {
    return identical(this._status, VALID);
  }
  Map<String, dynamic> get errors {
    return this._errors;
  }
  bool get pristine {
    return this._pristine;
  }
  bool get dirty {
    return !this.pristine;
  }
  bool get touched {
    return this._touched;
  }
  bool get untouched {
    return !this._touched;
  }
  Stream get valueChanges {
    return this._valueChanges;
  }
  void markAsTouched() {
    this._touched = true;
  }
  void markAsDirty({onlySelf}) {
    onlySelf = isPresent(onlySelf) ? onlySelf : false;
    this._pristine = false;
    if (isPresent(this._parent) && !onlySelf) {
      this._parent.markAsDirty(onlySelf: onlySelf);
    }
  }
  setParent(parent) {
    this._parent = parent;
  }
  void updateValidity({onlySelf}) {
    onlySelf = isPresent(onlySelf) ? onlySelf : false;
    this._errors = this.validator(this);
    this._status = isPresent(this._errors) ? INVALID : VALID;
    if (isPresent(this._parent) && !onlySelf) {
      this._parent.updateValidity(onlySelf: onlySelf);
    }
  }
  void updateValueAndValidity({onlySelf, emitEvent}) {
    onlySelf = isPresent(onlySelf) ? onlySelf : false;
    emitEvent = isPresent(emitEvent) ? emitEvent : true;
    this._updateValue();
    if (emitEvent) {
      ObservableWrapper.callNext(this._valueChanges, this._value);
    }
    this._errors = this.validator(this);
    this._status = isPresent(this._errors) ? INVALID : VALID;
    if (isPresent(this._parent) && !onlySelf) {
      this._parent.updateValueAndValidity(
          onlySelf: onlySelf, emitEvent: emitEvent);
    }
  }
  AbstractControl find(
      dynamic /* List < dynamic /* String | num */ > | String */ path) {
    return _find(this, path);
  }
  dynamic getError(String errorCode, [List<String> path = null]) {
    var c =
        isPresent(path) && !ListWrapper.isEmpty(path) ? this.find(path) : this;
    if (isPresent(c) && isPresent(c._errors)) {
      return StringMapWrapper.get(c._errors, errorCode);
    } else {
      return null;
    }
  }
  bool hasError(String errorCode, [List<String> path = null]) {
    return isPresent(this.getError(errorCode, path));
  }
  void _updateValue() {}
}
/**
 * Defines a part of a form that cannot be divided into other controls.
 *
 * `Control` is one of the three fundamental building blocks used to define forms in Angular, along
 * with
 * {@link ControlGroup} and {@link ControlArray}.
 */
class Control extends AbstractControl {
  Function _onChange;
  Control(dynamic value, [Function validator = Validators.nullValidator])
      : super(validator) {
    /* super call moved to initializer */;
    this._value = value;
    this.updateValidity(onlySelf: true);
    this._valueChanges = new EventEmitter();
  }
  void updateValue(dynamic value, {onlySelf, emitEvent}) {
    this._value = value;
    if (isPresent(this._onChange)) this._onChange(this._value);
    this.updateValueAndValidity(onlySelf: onlySelf, emitEvent: emitEvent);
  }
  void registerOnChange(Function fn) {
    this._onChange = fn;
  }
}
/**
 * Defines a part of a form, of fixed length, that can contain other controls.
 *
 * A ControlGroup aggregates the values and errors of each {@link Control} in the group. Thus, if
 * one of the controls
 * in a group is invalid, the entire group is invalid. Similarly, if a control changes its value,
 * the entire group
 * changes as well.
 *
 * `ControlGroup` is one of the three fundamental building blocks used to define forms in Angular,
 * along with
 * {@link Control} and {@link ControlArray}. {@link ControlArray} can also contain other controls,
 * but is of variable
 * length.
 */
class ControlGroup extends AbstractControl {
  Map<String, AbstractControl> controls;
  Map<String, bool> _optionals;
  ControlGroup(Map<String, AbstractControl> controls,
      [Map<String, bool> optionals = null,
      Function validator = Validators.group])
      : super(validator) {
    /* super call moved to initializer */;
    this.controls = controls;
    this._optionals = isPresent(optionals) ? optionals : {};
    this._valueChanges = new EventEmitter();
    this._setParentForControls();
    this._value = this._reduceValue();
    this.updateValidity(onlySelf: true);
  }
  addControl(String name, AbstractControl c) {
    this.controls[name] = c;
    c.setParent(this);
  }
  removeControl(String name) {
    StringMapWrapper.delete(this.controls, name);
  }
  void include(String controlName) {
    StringMapWrapper.set(this._optionals, controlName, true);
    this.updateValueAndValidity();
  }
  void exclude(String controlName) {
    StringMapWrapper.set(this._optionals, controlName, false);
    this.updateValueAndValidity();
  }
  bool contains(String controlName) {
    var c = StringMapWrapper.contains(this.controls, controlName);
    return c && this._included(controlName);
  }
  _setParentForControls() {
    StringMapWrapper.forEach(this.controls, (control, name) {
      control.setParent(this);
    });
  }
  _updateValue() {
    this._value = this._reduceValue();
  }
  _reduceValue() {
    return this._reduceChildren({}, (acc, control, name) {
      acc[name] = control.value;
      return acc;
    });
  }
  _reduceChildren(dynamic initValue, Function fn) {
    var res = initValue;
    StringMapWrapper.forEach(this.controls, (control, name) {
      if (this._included(name)) {
        res = fn(res, control, name);
      }
    });
    return res;
  }
  bool _included(String controlName) {
    var isOptional = StringMapWrapper.contains(this._optionals, controlName);
    return !isOptional || StringMapWrapper.get(this._optionals, controlName);
  }
}
/**
 * Defines a part of a form, of variable length, that can contain other controls.
 *
 * A `ControlArray` aggregates the values and errors of each {@link Control} in the group. Thus, if
 * one of the controls
 * in a group is invalid, the entire group is invalid. Similarly, if a control changes its value,
 * the entire group
 * changes as well.
 *
 * `ControlArray` is one of the three fundamental building blocks used to define forms in Angular,
 * along with {@link Control} and {@link ControlGroup}. {@link ControlGroup} can also contain
 * other controls, but is of fixed length.
 */
class ControlArray extends AbstractControl {
  List<AbstractControl> controls;
  ControlArray(List<AbstractControl> controls,
      [Function validator = Validators.array])
      : super(validator) {
    /* super call moved to initializer */;
    this.controls = controls;
    this._valueChanges = new EventEmitter();
    this._setParentForControls();
    this._updateValue();
    this.updateValidity(onlySelf: true);
  }
  AbstractControl at(num index) {
    return this.controls[index];
  }
  void push(AbstractControl control) {
    this.controls.add(control);
    control.setParent(this);
    this.updateValueAndValidity();
  }
  void insert(num index, AbstractControl control) {
    ListWrapper.insert(this.controls, index, control);
    control.setParent(this);
    this.updateValueAndValidity();
  }
  void removeAt(num index) {
    ListWrapper.removeAt(this.controls, index);
    this.updateValueAndValidity();
  }
  num get length {
    return this.controls.length;
  }
  _updateValue() {
    this._value = ListWrapper.map(this.controls, (c) => c.value);
  }
  _setParentForControls() {
    ListWrapper.forEach(this.controls, (control) {
      control.setParent(this);
    });
  }
}
