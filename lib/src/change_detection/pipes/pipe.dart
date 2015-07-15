library angular2.src.change_detection.pipes.pipe;

import "package:angular2/src/facade/lang.dart" show BaseException;
import "../change_detector_ref.dart" show ChangeDetectorRef;

/**
 * Indicates that the result of a {@link Pipe} transformation has changed even though the reference
 *has not changed.
 *
 * The wrapped value will be unwrapped by change detection, and the unwrapped value will be stored.
 */
class WrappedValue {
  dynamic wrapped;
  WrappedValue(this.wrapped) {}
  static WrappedValue wrap(dynamic value) {
    var w = _wrappedValues[_wrappedIndex++ % 5];
    w.wrapped = value;
    return w;
  }
}
var _wrappedValues = [
  new WrappedValue(null),
  new WrappedValue(null),
  new WrappedValue(null),
  new WrappedValue(null),
  new WrappedValue(null)
];
var _wrappedIndex = 0;
/**
 * An interface for extending the list of pipes known to Angular.
 *
 * If you are writing a custom {@link Pipe}, you must extend this interface.
 *
 * #Example
 *
 * ```
 * class DoublePipe implements Pipe {
 *  supports(obj) {
 *    return true;
 *  }
 *
 *  onDestroy() {}
 *
 *  transform(value, args = []) {
 *    return `${value}${value}`;
 *  }
 * }
 * ```
 */
abstract class Pipe {
  bool supports(obj);
  void onDestroy();
  dynamic transform(dynamic value, List<dynamic> args);
}
/**
 * Provides default implementation of supports and onDestroy.
 *
 * #Example
 *
 * ```
 * class DoublePipe extends BasePipe {*
 *  transform(value) {
 *    return `${value}${value}`;
 *  }
 * }
 * ```
 */
class BasePipe implements Pipe {
  bool supports(obj) {
    return true;
  }
  void onDestroy() {}
  dynamic transform(dynamic value, List<dynamic> args) {
    return _abstract();
  }
  const BasePipe();
}
abstract class PipeFactory {
  bool supports(obs);
  Pipe create(ChangeDetectorRef cdRef);
}
_abstract() {
  throw new BaseException("This method is abstract");
}
