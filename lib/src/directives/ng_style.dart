library angular2.src.directives.ng_style;

import "package:angular2/annotations.dart" show Directive, LifecycleEvent;
import "package:angular2/core.dart" show ElementRef;
import "package:angular2/src/change_detection/pipes/pipe.dart" show Pipe;
import "package:angular2/src/change_detection/pipes/pipes.dart" show Pipes;
import "package:angular2/src/change_detection/pipes/keyvalue_changes.dart"
    show KeyValueChanges;
import "package:angular2/src/facade/lang.dart" show isPresent, print;
import "package:angular2/src/render/api.dart" show Renderer;

/**
 * Adds or removes styles based on an {expression}.
 *
 * When the expression assigned to `ng-style` evaluates to an object, the corresponding element
 * styles are updated. Style names to update are taken from the object keys and values - from the
 * corresponding object values.
 *
 * # Example:
 *
 * ```
 * <div ng-style="{'text-align': alignEpr}"></div>
 * ```
 *
 * In the above example the `text-align` style will be updated based on the `alignEpr` value
 * changes.
 *
 * # Syntax
 *
 * - `<div ng-style="{'text-align': alignEpr}"></div>`
 * - `<div ng-style="styleExp"></div>`
 */
@Directive(
    selector: "[ng-style]",
    lifecycle: const [LifecycleEvent.onCheck],
    properties: const ["rawStyle: ng-style"])
class NgStyle {
  Pipes _pipes;
  ElementRef _ngEl;
  Renderer _renderer;
  Pipe _pipe;
  var _rawStyle;
  NgStyle(this._pipes, this._ngEl, this._renderer) {}
  set rawStyle(v) {
    this._rawStyle = v;
    this._pipe = this._pipes.get("keyValDiff", this._rawStyle);
  }
  onCheck() {
    var diff = this._pipe.transform(this._rawStyle, null);
    if (isPresent(diff) && isPresent(diff.wrapped)) {
      this._applyChanges(diff.wrapped);
    }
  }
  void _applyChanges(KeyValueChanges diff) {
    diff.forEachAddedItem((record) {
      this._setStyle(record.key, record.currentValue);
    });
    diff.forEachChangedItem((record) {
      this._setStyle(record.key, record.currentValue);
    });
    diff.forEachRemovedItem((record) {
      this._setStyle(record.key, null);
    });
  }
  void _setStyle(String name, String val) {
    this._renderer.setElementStyle(this._ngEl, name, val);
  }
}
