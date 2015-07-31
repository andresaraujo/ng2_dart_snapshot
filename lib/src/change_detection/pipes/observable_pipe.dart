library angular2.src.change_detection.pipes.observable_pipe;

import "package:angular2/src/facade/async.dart" show Stream, ObservableWrapper;
import "package:angular2/src/facade/lang.dart" show isBlank, isPresent;
import "pipe.dart" show Pipe, WrappedValue, PipeFactory;
import "../change_detector_ref.dart" show ChangeDetectorRef;

/**
 * Implements async bindings to Observable.
 *
 * # Example
 *
 * In this example we bind the description observable to the DOM. The async pipe will convert an
 *observable to the
 * latest value it emitted. It will also request a change detection check when a new value is
 *emitted.
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
 *  description:Observable<string>;
 * }
 *
 * ```
 */
class ObservablePipe implements Pipe {
  ChangeDetectorRef _ref;
  Object _latestValue = null;
  Object _latestReturnedValue = null;
  Object _subscription = null;
  Stream _observable = null;
  ObservablePipe(this._ref) {}
  bool supports(dynamic obs) {
    return ObservableWrapper.isObservable(obs);
  }
  void onDestroy() {
    if (isPresent(this._subscription)) {
      this._dispose();
    }
  }
  dynamic transform(Stream obs, [List<dynamic> args = null]) {
    if (isBlank(this._subscription)) {
      this._subscribe(obs);
      return null;
    }
    if (!identical(obs, this._observable)) {
      this._dispose();
      return this.transform(obs);
    }
    if (identical(this._latestValue, this._latestReturnedValue)) {
      return this._latestReturnedValue;
    } else {
      this._latestReturnedValue = this._latestValue;
      return WrappedValue.wrap(this._latestValue);
    }
  }
  void _subscribe(Stream obs) {
    this._observable = obs;
    this._subscription = ObservableWrapper.subscribe(obs,
        (value) => this._updateLatestValue(value), (e) {
      throw e;
    });
  }
  void _dispose() {
    ObservableWrapper.dispose(this._subscription);
    this._latestValue = null;
    this._latestReturnedValue = null;
    this._subscription = null;
    this._observable = null;
  }
  _updateLatestValue(Object value) {
    this._latestValue = value;
    this._ref.requestCheck();
  }
}
/**
 * Provides a factory for [ObervablePipe].
 */
class ObservablePipeFactory implements PipeFactory {
  bool supports(dynamic obs) {
    return ObservableWrapper.isObservable(obs);
  }
  Pipe create(ChangeDetectorRef cdRef) {
    return new ObservablePipe(cdRef);
  }
  const ObservablePipeFactory();
}
