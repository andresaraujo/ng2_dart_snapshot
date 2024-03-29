library angular2.src.directives.ng_for;

import "package:angular2/annotations.dart" show Directive, LifecycleEvent;
import "package:angular2/core.dart" show ViewContainerRef, ViewRef, TemplateRef;
import "package:angular2/change_detection.dart"
    show ChangeDetectorRef, Pipe, Pipes;
import "package:angular2/src/facade/lang.dart" show isPresent, isBlank;

/**
 * The `NgFor` directive instantiates a template once per item from an iterable. The context for
 * each instantiated template inherits from the outer context with the given loop variable set
 * to the current item from the iterable.
 *
 * It is possible to alias the `index` to a local variable that will be set to the current loop
 * iteration in the template context.
 *
 * When the contents of the iterator changes, `NgFor` makes the corresponding changes to the DOM:
 *
 * * When an item is added, a new instance of the template is added to the DOM.
 * * When an item is removed, its template instance is removed from the DOM.
 * * When items are reordered, their respective templates are reordered in the DOM.
 *
 * # Example
 *
 * ```
 * <ul>
 *   <li *ng-for="#error of errors; #i = index">
 *     Error {{i}} of {{errors.length}}: {{error.message}}
 *   </li>
 * </ul>
 * ```
 *
 * # Syntax
 *
 * - `<li *ng-for="#item of items; #i = index">...</li>`
 * - `<li template="ng-for #item of items; #i = index">...</li>`
 * - `<template ng-for #item [ng-for-of]="items" #i="index"><li>...</li></template>`
 */
@Directive(
    selector: "[ng-for][ng-for-of]",
    properties: const ["ngForOf"],
    lifecycle: const [LifecycleEvent.onCheck])
class NgFor {
  ViewContainerRef viewContainer;
  TemplateRef templateRef;
  Pipes pipes;
  ChangeDetectorRef cdr;
  dynamic _ngForOf;
  Pipe _pipe;
  NgFor(this.viewContainer, this.templateRef, this.pipes, this.cdr) {}
  set ngForOf(dynamic value) {
    this._ngForOf = value;
    this._pipe = this.pipes.get("iterableDiff", value, this.cdr, this._pipe);
  }
  onCheck() {
    var diff = this._pipe.transform(this._ngForOf, null);
    if (isPresent(diff)) this._applyChanges(diff.wrapped);
  }
  _applyChanges(changes) {
    if (isBlank(changes)) {
      this.viewContainer.clear();
      return;
    }
    // TODO(rado): check if change detection can produce a change record that is

    // easier to consume than current.
    var recordViewTuples = [];
    changes.forEachRemovedItem((removedRecord) =>
        recordViewTuples.add(new RecordViewTuple(removedRecord, null)));
    changes.forEachMovedItem((movedRecord) =>
        recordViewTuples.add(new RecordViewTuple(movedRecord, null)));
    var insertTuples = NgFor.bulkRemove(recordViewTuples, this.viewContainer);
    changes.forEachAddedItem((addedRecord) =>
        insertTuples.add(new RecordViewTuple(addedRecord, null)));
    NgFor.bulkInsert(insertTuples, this.viewContainer, this.templateRef);
    for (var i = 0; i < insertTuples.length; i++) {
      this._perViewChange(insertTuples[i].view, insertTuples[i].record);
    }
  }
  _perViewChange(view, record) {
    view.setLocal("\$implicit", record.item);
    view.setLocal("index", record.currentIndex);
  }
  static List<RecordViewTuple> bulkRemove(
      List<RecordViewTuple> tuples, ViewContainerRef viewContainer) {
    tuples.sort((a, b) => a.record.previousIndex - b.record.previousIndex);
    var movedTuples = [];
    for (var i = tuples.length - 1; i >= 0; i--) {
      var tuple = tuples[i];
      // separate moved views from removed views.
      if (isPresent(tuple.record.currentIndex)) {
        tuple.view = viewContainer.detach(tuple.record.previousIndex);
        movedTuples.add(tuple);
      } else {
        viewContainer.remove(tuple.record.previousIndex);
      }
    }
    return movedTuples;
  }
  static List<RecordViewTuple> bulkInsert(List<RecordViewTuple> tuples,
      ViewContainerRef viewContainer, TemplateRef templateRef) {
    tuples.sort((a, b) => a.record.currentIndex - b.record.currentIndex);
    for (var i = 0; i < tuples.length; i++) {
      var tuple = tuples[i];
      if (isPresent(tuple.view)) {
        viewContainer.insert(tuple.view, tuple.record.currentIndex);
      } else {
        tuple.view = viewContainer.createEmbeddedView(
            templateRef, tuple.record.currentIndex);
      }
    }
    return tuples;
  }
}
class RecordViewTuple {
  ViewRef view;
  dynamic record;
  RecordViewTuple(record, view) {
    this.record = record;
    this.view = view;
  }
}
