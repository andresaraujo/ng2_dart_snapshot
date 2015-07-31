library angular2.src.change_detection.pipes.uppercase_pipe;

import "package:angular2/src/facade/lang.dart" show isString, StringWrapper;
import "pipe.dart" show Pipe, BasePipe, PipeFactory;
import "../change_detector_ref.dart" show ChangeDetectorRef;

/**
 * Implements uppercase transforms to text.
 *
 * # Example
 *
 * In this example we transform the user text uppercase.
 *
 *  ```
 * @Component({
 *   selector: "username-cmp"
 * })
 * @View({
 *   template: "Username: {{ user | uppercase }}"
 * })
 * class Username {
 *   user:string;
 * }
 *
 * ```
 */
class UpperCasePipe extends BasePipe implements PipeFactory {
  bool supports(dynamic str) {
    return isString(str);
  }
  String transform(String value, [List<dynamic> args = null]) {
    return StringWrapper.toUpperCase(value);
  }
  Pipe create(ChangeDetectorRef cdRef) {
    return this;
  }
  const UpperCasePipe();
}
