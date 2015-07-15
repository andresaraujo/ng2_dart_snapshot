library angular2.src.directives.ng_if;

import "package:angular2/annotations.dart" show Directive;
import "package:angular2/core.dart" show ViewContainerRef, ProtoViewRef;
import "package:angular2/src/facade/lang.dart" show isBlank;

/**
 * Removes or recreates a portion of the DOM tree based on an {expression}.
 *
 * If the expression assigned to `ng-if` evaluates to a false value then the element
 * is removed from the DOM, otherwise a clone of the element is reinserted into the DOM.
 *
 * # Example:
 *
 * ```
 * <div *ng-if="errorCount > 0" class="error">
 *   <!-- Error message displayed when the errorCount property on the current context is greater
 * than 0. -->
 *   {{errorCount}} errors detected
 * </div>
 * ```
 *
 * # Syntax
 *
 * - `<div *ng-if="condition">...</div>`
 * - `<div template="ng-if condition">...</div>`
 * - `<template [ng-if]="condition"><div>...</div></template>`
 */
@Directive(selector: "[ng-if]", properties: const ["ngIf"])
class NgIf {
  ViewContainerRef viewContainer;
  ProtoViewRef protoViewRef;
  bool prevCondition;
  NgIf(ViewContainerRef viewContainer, ProtoViewRef protoViewRef) {
    this.viewContainer = viewContainer;
    this.prevCondition = null;
    this.protoViewRef = protoViewRef;
  }
  set ngIf(newCondition) {
    if (newCondition && (isBlank(this.prevCondition) || !this.prevCondition)) {
      this.prevCondition = true;
      this.viewContainer.create(this.protoViewRef);
    } else if (!newCondition &&
        (isBlank(this.prevCondition) || this.prevCondition)) {
      this.prevCondition = false;
      this.viewContainer.clear();
    }
  }
}
