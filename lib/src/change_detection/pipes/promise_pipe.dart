library angular2.src.change_detection.pipes.promise_pipe;

import "package:angular2/src/facade/async.dart" show Future, PromiseWrapper;
import "package:angular2/src/facade/lang.dart"
    show isBlank, isPresent, isPromise;
import "pipe.dart" show Pipe, PipeFactory, WrappedValue;
import "../change_detector_ref.dart" show ChangeDetectorRef;

/**
 * Implements async bindings to Promise.
 *
 * # Example
 *
 * In this example we bind the description promise to the DOM.
 * The async pipe will convert a promise to the value with which it is resolved. It will also
 * request a change detection check when the promise is resolved.
 *
 *  ```
 * @Component({
 *   selector: "task-cmp",
 *   changeDetection: ON_PUSH
 * })
 * @View({
 *   template: "Task Description {{ description | async }}"
 * })
 * class Task {
 *   description:Promise<string>;
 * }
 *
 * ```
 */
class PromisePipe implements Pipe {
  ChangeDetectorRef _ref;
  Object _latestValue = null;
  Object _latestReturnedValue = null;
  Future<dynamic> _sourcePromise;
  PromisePipe(this._ref) {}
  bool supports(promise) {
    return isPromise(promise);
  }
  void onDestroy() {
    if (isPresent(this._sourcePromise)) {
      this._latestValue = null;
      this._latestReturnedValue = null;
      this._sourcePromise = null;
    }
  }
  dynamic transform(Future<dynamic> promise, [List<dynamic> args = null]) {
    if (isBlank(this._sourcePromise)) {
      this._sourcePromise = promise;
      promise.then((val) {
        if (identical(this._sourcePromise, promise)) {
          this._updateLatestValue(val);
        }
      });
      return null;
    }
    if (!identical(promise, this._sourcePromise)) {
      this._sourcePromise = null;
      return this.transform(promise);
    }
    if (identical(this._latestValue, this._latestReturnedValue)) {
      return this._latestReturnedValue;
    } else {
      this._latestReturnedValue = this._latestValue;
      return WrappedValue.wrap(this._latestValue);
    }
  }
  _updateLatestValue(Object value) {
    this._latestValue = value;
    this._ref.requestCheck();
  }
}
/**
 * Provides a factory for [PromisePipe].
 */
class PromisePipeFactory implements PipeFactory {
  bool supports(promise) {
    return isPromise(promise);
  }
  Pipe create(ChangeDetectorRef cdRef) {
    return new PromisePipe(cdRef);
  }
  const PromisePipeFactory();
}
