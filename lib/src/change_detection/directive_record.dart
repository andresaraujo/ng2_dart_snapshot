library angular2.src.change_detection.directive_record;

import "constants.dart" show ON_PUSH;
import "package:angular2/src/facade/lang.dart"
    show StringWrapper, normalizeBool;

class DirectiveIndex {
  num elementIndex;
  num directiveIndex;
  DirectiveIndex(this.elementIndex, this.directiveIndex) {}
  get name {
    return '''${ this . elementIndex}_${ this . directiveIndex}''';
  }
}
class DirectiveRecord {
  DirectiveIndex directiveIndex;
  bool callOnAllChangesDone;
  bool callOnChange;
  bool callOnCheck;
  bool callOnInit;
  String changeDetection;
  DirectiveRecord({directiveIndex, callOnAllChangesDone, callOnChange,
      callOnCheck, callOnInit, changeDetection}) {
    this.directiveIndex = directiveIndex;
    this.callOnAllChangesDone = normalizeBool(callOnAllChangesDone);
    this.callOnChange = normalizeBool(callOnChange);
    this.callOnCheck = normalizeBool(callOnCheck);
    this.callOnInit = normalizeBool(callOnInit);
    this.changeDetection = changeDetection;
  }
  bool isOnPushChangeDetection() {
    return StringWrapper.equals(this.changeDetection, ON_PUSH);
  }
}
