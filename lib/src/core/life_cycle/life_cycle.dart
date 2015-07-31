library angular2.src.core.life_cycle.life_cycle;

import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/change_detection/change_detection.dart"
    show ChangeDetector;
import "package:angular2/src/core/zone/ng_zone.dart" show NgZone;
import "package:angular2/src/facade/lang.dart" show isPresent, BaseException;

/**
 * Provides access to explicitly trigger change detection in an application.
 *
 * By default, `Zone` triggers change detection in Angular on each virtual machine (VM) turn. When
 * testing, or in some
 * limited application use cases, a developer can also trigger change detection with the
 * `lifecycle.tick()` method.
 *
 * Each Angular application has a single `LifeCycle` instance.
 *
 * # Example
 *
 * This is a contrived example, since the bootstrap automatically runs inside of the `Zone`, which
 * invokes
 * `lifecycle.tick()` on your behalf.
 *
 * ```javascript
 * bootstrap(MyApp).then((ref:ComponentRef) => {
 *   var lifeCycle = ref.injector.get(LifeCycle);
 *   var myApp = ref.instance;
 *
 *   ref.doSomething();
 *   lifecycle.tick();
 * });
 * ```
 */
@Injectable()
class LifeCycle {
  ChangeDetector _changeDetector;
  bool _enforceNoNewChanges;
  bool _runningTick = false;
  LifeCycle([ChangeDetector changeDetector = null,
      bool enforceNoNewChanges = false]) {
    this._changeDetector = changeDetector;
    this._enforceNoNewChanges = enforceNoNewChanges;
  }
  /**
   * @private
   */
  registerWith(NgZone zone, [ChangeDetector changeDetector = null]) {
    if (isPresent(changeDetector)) {
      this._changeDetector = changeDetector;
    }
    zone.overrideOnTurnDone(() => this.tick());
  }
  /**
   *  Invoke this method to explicitly process change detection and its side-effects.
   *
   *  In development mode, `tick()` also performs a second change detection cycle to ensure that no
   * further
   *  changes are detected. If additional changes are picked up during this second cycle, bindings
   * in
   * the app have
   *  side-effects that cannot be resolved in a single change detection pass. In this case, Angular
   * throws an error,
   *  since an Angular application can only have one change detection pass during which all change
   * detection must
   *  complete.
   *
   */
  tick() {
    if (this._runningTick) {
      throw new BaseException("LifeCycle.tick is called recursively");
    }
    try {
      this._runningTick = true;
      this._changeDetector.detectChanges();
      if (this._enforceNoNewChanges) {
        this._changeDetector.checkNoChanges();
      }
    } finally {
      this._runningTick = false;
    }
  }
}
