library angular2.src.forms.directives.shared;

import "package:angular2/src/facade/collection.dart"
    show ListWrapper, iterableToList;
import "package:angular2/src/facade/lang.dart" show isBlank, BaseException;
import "control_container.dart" show ControlContainer;
import "ng_control.dart" show NgControl;
import "validators.dart" show NgValidator;
import "../model.dart" show Control;
import "../validators.dart" show Validators;
import "package:angular2/render.dart" show Renderer;
import "package:angular2/core.dart" show ElementRef, QueryList;

List<String> controlPath(String name, ControlContainer parent) {
  var p = ListWrapper.clone(parent.path);
  p.add(name);
  return p;
}
setUpControl(Control c, NgControl dir) {
  if (isBlank(c)) _throwError(dir, "Cannot find control");
  if (isBlank(dir.valueAccessor)) _throwError(dir, "No value accessor for");
  c.validator = Validators.compose([c.validator, dir.validator]);
  dir.valueAccessor.writeValue(c.value);
  // view -> model
  dir.valueAccessor.registerOnChange((newValue) {
    dir.viewToModelUpdate(newValue);
    c.updateValue(newValue);
    c.markAsDirty();
  });
  // model -> view
  c.registerOnChange((newValue) => dir.valueAccessor.writeValue(newValue));
  // touched
  dir.valueAccessor.registerOnTouched(() => c.markAsTouched());
}
Function composeNgValidator(QueryList<NgValidator> ngValidators) {
  if (isBlank(ngValidators)) return Validators.nullValidator;
  return Validators.compose(
      ((iterableToList(ngValidators) as List<NgValidator>))
          .map((v) => v.validator)
          .toList());
}
void _throwError(NgControl dir, String message) {
  var path = ListWrapper.join(dir.path, " -> ");
  throw new BaseException('''${ message} \'${ path}\'''');
}
setProperty(Renderer renderer, ElementRef elementRef, String propName,
    dynamic propValue) {
  renderer.setElementProperty(elementRef, propName, propValue);
}
