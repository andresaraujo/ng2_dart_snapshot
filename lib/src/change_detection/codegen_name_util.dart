library angular2.src.change_detection.codegen_name_util;

import "package:angular2/src/facade/lang.dart"
    show RegExpWrapper, StringWrapper;
import "package:angular2/src/facade/collection.dart" show List, ListWrapper;
import "directive_record.dart" show DirectiveIndex;
import "proto_record.dart" show ProtoRecord;
// The names of these fields must be kept in sync with abstract_change_detector.ts or change

// detection will fail.
const _ALREADY_CHECKED_ACCESSOR = "alreadyChecked";
const _CONTEXT_ACCESSOR = "context";
const _FIRST_PROTO_IN_CURRENT_BINDING = "firstProtoInCurrentBinding";
const _DIRECTIVES_ACCESSOR = "directiveRecords";
const _DISPATCHER_ACCESSOR = "dispatcher";
const _LOCALS_ACCESSOR = "locals";
const _MODE_ACCESSOR = "mode";
const _PIPES_ACCESSOR = "pipes";
const _PROTOS_ACCESSOR = "protos";
// `context` is always first.
const CONTEXT_INDEX = 0;
const _FIELD_PREFIX = "this.";
var _whiteSpaceRegExp = RegExpWrapper.create("\\W", "g");
/**
 * Returns `s` with all non-identifier characters removed.
 */
String sanitizeName(String s) {
  return StringWrapper.replaceAll(s, _whiteSpaceRegExp, "");
}
/**
 * Class responsible for providing field and local variable names for change detector classes.
 * Also provides some convenience functions, for example, declaring variables, destroying pipes,
 * and dehydrating the detector.
 */
class CodegenNameUtil {
  List<ProtoRecord> records;
  List<dynamic> directiveRecords;
  String utilName;
  /**
   * Record names sanitized for use as fields.
   * See [sanitizeName] for details.
   */
  List<String> _sanitizedNames;
  CodegenNameUtil(this.records, this.directiveRecords, this.utilName) {
    this._sanitizedNames = ListWrapper.createFixedSize(this.records.length + 1);
    this._sanitizedNames[CONTEXT_INDEX] = _CONTEXT_ACCESSOR;
    for (var i = 0, iLen = this.records.length; i < iLen; ++i) {
      this._sanitizedNames[i + 1] =
          sanitizeName('''${ this . records [ i ] . name}${ i}''');
    }
  }
  String _addFieldPrefix(String name) {
    return '''${ _FIELD_PREFIX}${ name}''';
  }
  String getDispatcherName() {
    return this._addFieldPrefix(_DISPATCHER_ACCESSOR);
  }
  String getPipesAccessorName() {
    return this._addFieldPrefix(_PIPES_ACCESSOR);
  }
  String getProtosName() {
    return this._addFieldPrefix(_PROTOS_ACCESSOR);
  }
  String getDirectivesAccessorName() {
    return this._addFieldPrefix(_DIRECTIVES_ACCESSOR);
  }
  String getLocalsAccessorName() {
    return this._addFieldPrefix(_LOCALS_ACCESSOR);
  }
  String getAlreadyCheckedName() {
    return this._addFieldPrefix(_ALREADY_CHECKED_ACCESSOR);
  }
  String getModeName() {
    return this._addFieldPrefix(_MODE_ACCESSOR);
  }
  String getFirstProtoInCurrentBinding() {
    return this._addFieldPrefix(_FIRST_PROTO_IN_CURRENT_BINDING);
  }
  String getLocalName(int idx) {
    return '''l_${ this . _sanitizedNames [ idx ]}''';
  }
  String getChangeName(int idx) {
    return '''c_${ this . _sanitizedNames [ idx ]}''';
  }
  /**
   * Generate a statement initializing local variables used when detecting changes.
   */
  String genInitLocals() {
    var declarations = [];
    var assignments = [];
    for (var i = 0, iLen = this.getFieldCount(); i < iLen; ++i) {
      if (i == CONTEXT_INDEX) {
        declarations.add(
            '''${ this . getLocalName ( i )} = ${ this . getFieldName ( i )}''');
      } else {
        var rec = this.records[i - 1];
        if (rec.argumentToPureFunction) {
          var changeName = this.getChangeName(i);
          declarations.add('''${ this . getLocalName ( i )},${ changeName}''');
          assignments.add(changeName);
        } else {
          declarations.add('''${ this . getLocalName ( i )}''');
        }
      }
    }
    var assignmentsCode = ListWrapper.isEmpty(assignments)
        ? ""
        : '''${ ListWrapper . join ( assignments , "=" )} = false;''';
    return '''var ${ ListWrapper . join ( declarations , "," )};${ assignmentsCode}''';
  }
  int getFieldCount() {
    return this._sanitizedNames.length;
  }
  String getFieldName(int idx) {
    return this._addFieldPrefix(this._sanitizedNames[idx]);
  }
  List<String> getAllFieldNames() {
    var fieldList = [];
    for (var k = 0, kLen = this.getFieldCount(); k < kLen; ++k) {
      if (identical(k, 0) || this.records[k - 1].shouldBeChecked()) {
        fieldList.add(this.getFieldName(k));
      }
    }
    for (var i = 0, iLen = this.records.length; i < iLen; ++i) {
      var rec = this.records[i];
      if (rec.isPipeRecord()) {
        fieldList.add(this.getPipeName(rec.selfIndex));
      }
    }
    for (var j = 0, jLen = this.directiveRecords.length; j < jLen; ++j) {
      var dRec = this.directiveRecords[j];
      fieldList.add(this.getDirectiveName(dRec.directiveIndex));
      if (dRec.isOnPushChangeDetection()) {
        fieldList.add(this.getDetectorName(dRec.directiveIndex));
      }
    }
    return fieldList;
  }
  /**
   * Generates statements which clear all fields so that the change detector is dehydrated.
   */
  String genDehydrateFields() {
    var fields = this.getAllFieldNames();
    ListWrapper.removeAt(fields, CONTEXT_INDEX);
    if (ListWrapper.isEmpty(fields)) return "";
    // At least one assignment.
    fields.add('''${ this . utilName}.uninitialized;''');
    return ListWrapper.join(fields, " = ");
  }
  /**
   * Generates statements destroying all pipe variables.
   */
  String genPipeOnDestroy() {
    return ListWrapper.join(ListWrapper.map(ListWrapper.filter(this.records,
        (r) {
      return r.isPipeRecord();
    }), (r) {
      return '''${ this . getPipeName ( r . selfIndex )}.onDestroy();''';
    }), "\n");
  }
  String getPipeName(int idx) {
    return this._addFieldPrefix('''${ this . _sanitizedNames [ idx ]}_pipe''');
  }
  List<String> getAllDirectiveNames() {
    return ListWrapper.map(
        this.directiveRecords, (d) => this.getDirectiveName(d.directiveIndex));
  }
  String getDirectiveName(DirectiveIndex d) {
    return this._addFieldPrefix('''directive_${ d . name}''');
  }
  List<String> getAllDetectorNames() {
    return ListWrapper.map(ListWrapper.filter(
            this.directiveRecords, (r) => r.isOnPushChangeDetection()),
        (d) => this.getDetectorName(d.directiveIndex));
  }
  String getDetectorName(DirectiveIndex d) {
    return this._addFieldPrefix('''detector_${ d . name}''');
  }
}
