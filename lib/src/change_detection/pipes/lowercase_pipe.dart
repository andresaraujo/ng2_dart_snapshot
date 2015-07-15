library angular2.src.change_detection.pipes.lowercase_pipe;

import "package:angular2/src/facade/lang.dart" show isString, StringWrapper;
import "pipe.dart" show Pipe, PipeFactory;
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
class LowerCasePipe implements Pipe {
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
      return StringWrapper.toLowerCase(value);
    } else {
      return this._latestValue;
    }
  }
}
class LowerCaseFactory implements PipeFactory {
  bool supports(str) {
    return isString(str);
  }
  Pipe create(ChangeDetectorRef cdRef) {
    return new LowerCasePipe();
  }
  const LowerCaseFactory();
}
