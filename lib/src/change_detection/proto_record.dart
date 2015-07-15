library angular2.src.change_detection.proto_record;

import "package:angular2/src/facade/collection.dart" show List;
import "binding_record.dart" show BindingRecord;
import "directive_record.dart" show DirectiveIndex;

enum RecordType {
  SELF,
  CONST,
  PRIMITIVE_OP,
  PROPERTY,
  LOCAL,
  INVOKE_METHOD,
  INVOKE_CLOSURE,
  KEYED_ACCESS,
  PIPE,
  INTERPOLATE,
  SAFE_PROPERTY,
  SAFE_INVOKE_METHOD,
  DIRECTIVE_LIFECYCLE
}
class ProtoRecord {
  RecordType mode;
  String name;
  var funcOrValue;
  List<dynamic> args;
  List<dynamic> fixedArgs;
  num contextIndex;
  DirectiveIndex directiveIndex;
  num selfIndex;
  BindingRecord bindingRecord;
  String expressionAsString;
  bool lastInBinding;
  bool lastInDirective;
  ProtoRecord(this.mode, this.name, this.funcOrValue, this.args, this.fixedArgs,
      this.contextIndex, this.directiveIndex, this.selfIndex,
      this.bindingRecord, this.expressionAsString, this.lastInBinding,
      this.lastInDirective) {}
  bool isPureFunction() {
    return identical(this.mode, RecordType.INTERPOLATE) ||
        identical(this.mode, RecordType.PRIMITIVE_OP);
  }
  bool isPipeRecord() {
    return identical(this.mode, RecordType.PIPE);
  }
  bool isLifeCycleRecord() {
    return identical(this.mode, RecordType.DIRECTIVE_LIFECYCLE);
  }
}
