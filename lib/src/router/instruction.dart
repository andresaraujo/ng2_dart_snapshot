library angular2.src.router.instruction;

import "package:angular2/src/facade/collection.dart"
    show Map, MapWrapper, Map, StringMapWrapper, List, ListWrapper;
import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, normalizeBlank;
import "path_recognizer.dart" show PathRecognizer;

class RouteParams {
  Map<String, String> params;
  RouteParams(this.params) {}
  String get(String param) {
    return normalizeBlank(StringMapWrapper.get(this.params, param));
  }
}
/**
 * An `Instruction` represents the component hierarchy of the application based on a given route
 */
class Instruction {
  dynamic component;
  String capturedUrl;
  PathRecognizer _recognizer;
  Instruction child;
  // "capturedUrl" is the part of the URL captured by this instruction

  // "accumulatedUrl" is the part of the URL captured by this instruction and all children
  String accumulatedUrl;
  bool reuse = false;
  num specificity;
  Map<String, String> _params;
  Instruction(this.component, this.capturedUrl, this._recognizer,
      [this.child = null]) {
    this.accumulatedUrl = capturedUrl;
    this.specificity = _recognizer.specificity;
    if (isPresent(child)) {
      this.child = child;
      this.specificity += child.specificity;
      var childUrl = child.accumulatedUrl;
      if (isPresent(childUrl)) {
        this.accumulatedUrl += childUrl;
      }
    }
  }
  Map<String, String> params() {
    if (isBlank(this._params)) {
      this._params = this._recognizer.parseParams(this.capturedUrl);
    }
    return this._params;
  }
}
