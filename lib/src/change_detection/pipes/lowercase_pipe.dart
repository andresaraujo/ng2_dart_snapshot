library angular2.src.change_detection.pipes.lowercase_pipe;

import "package:angular2/src/facade/lang.dart" show isString, StringWrapper;
import "pipe.dart" show Pipe, BasePipe, PipeFactory;
import "../change_detector_ref.dart" show ChangeDetectorRef;

/**
 * Implements lowercase transforms to text.
 *
 * # Example
 *
 * In this example we transform the user text lowercase.
 *
 *  ```
 * @Component({
 *   selector: "username-cmp"
 * })
 * @View({
 *   template: "Username: {{ user | lowercase }}"
 * })
 * class Username {
 *   user:string;
 * }
 *
 * ```
 */
class LowerCasePipe extends BasePipe implements PipeFactory {
  bool supports(dynamic str) {
    return isString(str);
  }
  String transform(String value, [List<dynamic> args = null]) {
    return StringWrapper.toLowerCase(value);
  }
  Pipe create(ChangeDetectorRef cdRef) {
    return this;
  }
  const LowerCasePipe();
}
