library angular2.src.change_detection.pipes.json_pipe;

import "package:angular2/src/facade/lang.dart" show isBlank, isPresent, Json;
import "pipe.dart" show Pipe, BasePipe, PipeFactory;
import "../change_detector_ref.dart" show ChangeDetectorRef;

/**
 * Implements json transforms to any object.
 *
 * # Example
 *
 * In this example we transform the user object to json.
 *
 *  ```
 * @Component({
 *   selector: "user-cmp"
 * })
 * @View({
 *   template: "User: {{ user | json }}"
 * })
 * class Username {
 *  user:Object
 *  constructor() {
 *    this.user = { name: "PatrickJS" };
 *  }
 * }
 *
 * ```
 */
class JsonPipe extends BasePipe implements PipeFactory {
  String transform(dynamic value, [List<dynamic> args = null]) {
    return Json.stringify(value);
  }
  Pipe create(ChangeDetectorRef cdRef) {
    return this;
  }
  const JsonPipe();
}
