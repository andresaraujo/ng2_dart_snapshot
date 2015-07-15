library angular2.src.change_detection.pipes.uppercase_pipe;

import "package:angular2/src/facade/lang.dart" show isString, StringWrapper;
import "pipe.dart" show Pipe, PipeFactory;
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
class UpperCasePipe implements Pipe {
  String _latestValue = null;
  bool supports(str) {
    return isString(str);
  }
  void onDestroy() {
    this._latestValue = null;
  }
  String transform(String value, [List<dynamic> args = null]) {
    if (!identical(this._latestValue, value)) {
      this._latestValue = value;
      return StringWrapper.toUpperCase(value);
    } else {
      return this._latestValue;
    }
  }
}
class UpperCaseFactory implements PipeFactory {
  bool supports(str) {
    return isString(str);
  }
  Pipe create(ChangeDetectorRef cdRef) {
    return new UpperCasePipe();
  }
  const UpperCaseFactory();
}
