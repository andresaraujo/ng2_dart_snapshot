library angular2.src.render.dom.compiler.compile_control;

import "package:angular2/src/facade/lang.dart" show isBlank;
import "package:angular2/src/facade/collection.dart" show List, ListWrapper;
import "compile_element.dart" show CompileElement;
import "compile_step.dart" show CompileStep;

/**
 * Controls the processing order of elements.
 * Right now it only allows to add a parent element.
 */
class CompileControl {
  List<CompileStep> _steps;
  num _currentStepIndex = 0;
  CompileElement _parent = null;
  List<dynamic> _results = null;
  List<CompileElement> _additionalChildren = null;
  bool _ignoreCurrentElement;
  CompileControl(this._steps) {}
  // only public so that it can be used by compile_pipeline
  List<CompileElement> internalProcess(List<dynamic> results,
      num startStepIndex, CompileElement parent, CompileElement current) {
    this._results = results;
    var previousStepIndex = this._currentStepIndex;
    var previousParent = this._parent;
    this._ignoreCurrentElement = false;
    for (var i = startStepIndex;
        i < this._steps.length && !this._ignoreCurrentElement;
        i++) {
      var step = this._steps[i];
      this._parent = parent;
      this._currentStepIndex = i;
      step.processElement(parent, current, this);
      parent = this._parent;
    }
    if (!this._ignoreCurrentElement) {
      results.add(current);
    }
    this._currentStepIndex = previousStepIndex;
    this._parent = previousParent;
    var localAdditionalChildren = this._additionalChildren;
    this._additionalChildren = null;
    return localAdditionalChildren;
  }
  addParent(CompileElement newElement) {
    this.internalProcess(
        this._results, this._currentStepIndex + 1, this._parent, newElement);
    this._parent = newElement;
  }
  addChild(CompileElement element) {
    if (isBlank(this._additionalChildren)) {
      this._additionalChildren = [];
    }
    this._additionalChildren.add(element);
  }
  /**
   * Ignores the current element.
   *
   * When a step calls `ignoreCurrentElement`, no further steps are executed on the current
   * element and no `CompileElement` is added to the result list.
   */
  ignoreCurrentElement() {
    this._ignoreCurrentElement = true;
  }
}
