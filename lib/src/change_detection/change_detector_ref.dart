library angular2.src.change_detection.change_detector_ref;

import "interfaces.dart" show ChangeDetector;
import "constants.dart" show CHECK_ONCE, DETACHED, CHECK_ALWAYS;

/**
 * Controls change detection.
 *
 * {@link ChangeDetectorRef} allows requesting checks for detectors that rely on observables. It
 * also allows detaching and attaching change detector subtrees.
 */
class ChangeDetectorRef {
  ChangeDetector _cd;
  /**
   * @private
   */
  ChangeDetectorRef(this._cd) {}
  /**
   * Request to check all ON_PUSH ancestors.
   */
  void requestCheck() {
    this._cd.markPathToRootAsCheckOnce();
  }
  /**
   * Detaches the change detector from the change detector tree.
   *
   * The detached change detector will not be checked until it is reattached.
   */
  void detach() {
    this._cd.mode = DETACHED;
  }
  /**
   * Reattach the change detector to the change detector tree.
   *
   * This also requests a check of this change detector. This reattached change detector will be
   *checked during the
   * next change detection run.
   */
  void reattach() {
    this._cd.mode = CHECK_ALWAYS;
    this.requestCheck();
  }
}
