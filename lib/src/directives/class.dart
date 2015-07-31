library angular2.src.directives._class;

import "package:angular2/annotations.dart" show Directive, LifecycleEvent;
import "package:angular2/core.dart" show ElementRef;
import "package:angular2/src/change_detection/pipes/pipes.dart" show Pipes;
import "package:angular2/src/change_detection/pipes/pipe.dart" show Pipe;
import "package:angular2/src/render/api.dart" show Renderer;
import "package:angular2/src/change_detection/pipes/keyvalue_changes.dart"
    show KeyValueChanges;
import "package:angular2/src/change_detection/pipes/iterable_changes.dart"
    show IterableChanges;
import "package:angular2/src/facade/lang.dart"
    show isPresent, isString, StringWrapper;
import "package:angular2/src/facade/collection.dart"
    show ListWrapper, StringMapWrapper, isListLikeIterable;

/**
 * Adds and removes CSS classes based on an {expression} value.
 *
 * The result of expression is used to add and remove CSS classes using the following logic,
 * based on expression's value type:
 * - {string} - all the CSS classes (space - separated) are added
 * - {Array} - all the CSS classes (Array elements) are added
 * - {Object} - each key corresponds to a CSS class name while values
 * are interpreted as {boolean} expression. If a given expression
 * evaluates to {true} a corresponding CSS class is added - otherwise
 * it is removed.
 *
 * # Example:
 *
 * ```
 * <div class="message" [class]="{error: errorCount > 0}">
 *     Please check errors.
 * </div>
 * ```
 */
@Directive(
    selector: "[class]",
    lifecycle: const [LifecycleEvent.onCheck, LifecycleEvent.onDestroy],
    properties: const ["rawClass: class"])
class CSSClass {
  Pipes _pipes;
  ElementRef _ngEl;
  Renderer _renderer;
  Pipe _pipe;
  var _rawClass;
  CSSClass(this._pipes, this._ngEl, this._renderer) {}
  set rawClass(v) {
    this._cleanupClasses(this._rawClass);
    if (isString(v)) {
      v = v.split(" ");
    }
    this._rawClass = v;
    this._pipe = this._pipes.get(
        isListLikeIterable(v) ? "iterableDiff" : "keyValDiff", v);
  }
  void onCheck() {
    var diff = this._pipe.transform(this._rawClass, null);
    if (isPresent(diff) && isPresent(diff.wrapped)) {
      if (diff.wrapped is IterableChanges) {
        this._applyArrayChanges(diff.wrapped);
      } else {
        this._applyObjectChanges(diff.wrapped);
      }
    }
  }
  void onDestroy() {
    this._cleanupClasses(this._rawClass);
  }
  void _cleanupClasses(rawClassVal) {
    if (isPresent(rawClassVal)) {
      if (isListLikeIterable(rawClassVal)) {
        ListWrapper.forEach(rawClassVal, (className) {
          this._toggleClass(className, false);
        });
      } else {
        StringMapWrapper.forEach(rawClassVal, (expVal, className) {
          if (expVal) this._toggleClass(className, false);
        });
      }
    }
  }
  void _applyObjectChanges(KeyValueChanges diff) {
    diff.forEachAddedItem((record) {
      this._toggleClass(record.key, record.currentValue);
    });
    diff.forEachChangedItem((record) {
      this._toggleClass(record.key, record.currentValue);
    });
    diff.forEachRemovedItem((record) {
      if (record.previousValue) {
        this._toggleClass(record.key, false);
      }
    });
  }
  void _applyArrayChanges(IterableChanges diff) {
    diff.forEachAddedItem((record) {
      this._toggleClass(record.item, true);
    });
    diff.forEachRemovedItem((record) {
      this._toggleClass(record.item, false);
    });
  }
  void _toggleClass(String className, enabled) {
    this._renderer.setElementClass(this._ngEl, className, enabled);
  }
}
