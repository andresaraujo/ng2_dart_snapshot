library angular2.test.change_detection.change_detector_config;

import "package:angular2/src/facade/collection.dart"
    show ListWrapper, MapWrapper, StringMapWrapper;
import "package:angular2/src/facade/lang.dart" show isBlank, isPresent;
import "package:angular2/change_detection.dart"
    show
        DEFAULT,
        ON_PUSH,
        BindingRecord,
        ChangeDetectorDefinition,
        DirectiveIndex,
        DirectiveRecord,
        Lexer,
        Locals,
        Parser;
import "package:angular2/src/reflection/reflection.dart" show reflector;
import "package:angular2/src/reflection/reflection_capabilities.dart"
    show ReflectionCapabilities;

/*
 * This file defines `ChangeDetectorDefinition` objects which are used in the tests defined in
 * the change_detector_spec library. Please see that library for more information.
 */
var _parser = new Parser(new Lexer());
_getParser() {
  reflector.reflectionCapabilities = new ReflectionCapabilities();
  return _parser;
}
List<BindingRecord> _createBindingRecords(String expression) {
  var ast = _getParser().parseBinding(expression, "location");
  return [BindingRecord.createForElementProperty(ast, 0, PROP_NAME)];
}
List<dynamic> _convertLocalsToVariableBindings(Locals locals) {
  var variableBindings = [];
  var loc = locals;
  while (isPresent(loc) && isPresent(loc.current)) {
    MapWrapper.forEach(loc.current, (v, k) => variableBindings.add(k));
    loc = loc.parent;
  }
  return variableBindings;
}
var PROP_NAME = "propName";
/**
 * In this case, we expect `id` and `expression` to be the same string.
 */
TestDefinition getDefinition(String id) {
  var testDef = null;
  if (StringMapWrapper.contains(
      _ExpressionWithLocals.availableDefinitions, id)) {
    var val =
        StringMapWrapper.get(_ExpressionWithLocals.availableDefinitions, id);
    var cdDef = val.createChangeDetectorDefinition();
    cdDef.id = id;
    testDef = new TestDefinition(id, cdDef, val.locals);
  } else if (StringMapWrapper.contains(
      _ExpressionWithMode.availableDefinitions, id)) {
    var val =
        StringMapWrapper.get(_ExpressionWithMode.availableDefinitions, id);
    var cdDef = val.createChangeDetectorDefinition();
    cdDef.id = id;
    testDef = new TestDefinition(id, cdDef, null);
  } else if (StringMapWrapper.contains(
      _DirectiveUpdating.availableDefinitions, id)) {
    var val = StringMapWrapper.get(_DirectiveUpdating.availableDefinitions, id);
    var cdDef = val.createChangeDetectorDefinition();
    cdDef.id = id;
    testDef = new TestDefinition(id, cdDef, null);
  } else if (ListWrapper.indexOf(_availableDefinitions, id) >= 0) {
    var strategy = null;
    var variableBindings = [];
    var bindingRecords = _createBindingRecords(id);
    var directiveRecords = [];
    var cdDef = new ChangeDetectorDefinition(
        id, strategy, variableBindings, bindingRecords, directiveRecords);
    testDef = new TestDefinition(id, cdDef, null);
  }
  if (isBlank(testDef)) {
    throw '''No ChangeDetectorDefinition for ${ id} available. Please modify this file if necessary.''';
  }
  return testDef;
}
class TestDefinition {
  String id;
  ChangeDetectorDefinition cdDef;
  Locals locals;
  TestDefinition(this.id, this.cdDef, this.locals) {}
}
/**
 * Get all available ChangeDetectorDefinition objects. Used to pre-generate Dart
 * `ChangeDetector` classes.
 */
List<TestDefinition> getAllDefinitions() {
  var allDefs = _availableDefinitions;
  allDefs = ListWrapper.concat(allDefs,
      StringMapWrapper.keys(_ExpressionWithLocals.availableDefinitions));
  allDefs = ListWrapper.concat(
      allDefs, StringMapWrapper.keys(_ExpressionWithMode.availableDefinitions));
  allDefs = ListWrapper.concat(
      allDefs, StringMapWrapper.keys(_DirectiveUpdating.availableDefinitions));
  return ListWrapper.map(allDefs, (id) => getDefinition(id));
}
class _ExpressionWithLocals {
  String _expression;
  Locals locals;
  _ExpressionWithLocals(this._expression, this.locals) {}
  ChangeDetectorDefinition createChangeDetectorDefinition() {
    var strategy = null;
    var variableBindings = _convertLocalsToVariableBindings(this.locals);
    var bindingRecords = _createBindingRecords(this._expression);
    var directiveRecords = [];
    return new ChangeDetectorDefinition("(empty id)", strategy,
        variableBindings, bindingRecords, directiveRecords);
  }
  /**
   * Map from test id to _ExpressionWithLocals.
   * Tests in this map define an expression and local values which those expressions refer to.
   */
  static Map<String, _ExpressionWithLocals> availableDefinitions = {
    "valueFromLocals": new _ExpressionWithLocals("key",
        new Locals(null, MapWrapper.createFromPairs([["key", "value"]]))),
    "functionFromLocals": new _ExpressionWithLocals("key()",
        new Locals(null, MapWrapper.createFromPairs([["key", () => "value"]]))),
    "nestedLocals": new _ExpressionWithLocals("key", new Locals(
        new Locals(null, MapWrapper.createFromPairs([["key", "value"]])),
        new Map())),
    "fallbackLocals": new _ExpressionWithLocals("name",
        new Locals(null, MapWrapper.createFromPairs([["key", "value"]]))),
    "contextNestedPropertyWithLocals": new _ExpressionWithLocals("address.city",
        new Locals(null, MapWrapper.createFromPairs([["city", "MTV"]]))),
    "localPropertyWithSimilarContext": new _ExpressionWithLocals(
        "city", new Locals(null, MapWrapper.createFromPairs([["city", "MTV"]])))
  };
}
class _ExpressionWithMode {
  String _strategy;
  bool _withRecords;
  _ExpressionWithMode(this._strategy, this._withRecords) {}
  ChangeDetectorDefinition createChangeDetectorDefinition() {
    var variableBindings = [];
    var bindingRecords = null;
    var directiveRecords = null;
    if (this._withRecords) {
      var dirRecordWithOnPush = new DirectiveRecord(
          directiveIndex: new DirectiveIndex(0, 0), changeDetection: ON_PUSH);
      var updateDirWithOnPushRecord = BindingRecord.createForDirective(
          _getParser().parseBinding("42", "location"), "a",
          (o, v) => ((o as dynamic)).a = v, dirRecordWithOnPush);
      bindingRecords = [updateDirWithOnPushRecord];
      directiveRecords = [dirRecordWithOnPush];
    } else {
      bindingRecords = [];
      directiveRecords = [];
    }
    return new ChangeDetectorDefinition("(empty id)", this._strategy,
        variableBindings, bindingRecords, directiveRecords);
  }
  /**
   * Map from test id to _ExpressionWithMode.
   * Definitions in this map define conditions which allow testing various change detector modes.
   */
  static Map<String, _ExpressionWithMode> availableDefinitions = {
    "emptyUsingDefaultStrategy": new _ExpressionWithMode(DEFAULT, false),
    "emptyUsingOnPushStrategy": new _ExpressionWithMode(ON_PUSH, false),
    "onPushRecordsUsingDefaultStrategy": new _ExpressionWithMode(DEFAULT, true)
  };
}
class _DirectiveUpdating {
  List<BindingRecord> _bindingRecords;
  List<DirectiveRecord> _directiveRecords;
  _DirectiveUpdating(this._bindingRecords, this._directiveRecords) {}
  ChangeDetectorDefinition createChangeDetectorDefinition() {
    var strategy = null;
    var variableBindings = [];
    return new ChangeDetectorDefinition("(empty id)", strategy,
        variableBindings, this._bindingRecords, this._directiveRecords);
  }
  static BindingRecord updateA(String expression, dirRecord) {
    return BindingRecord.createForDirective(
        _getParser().parseBinding(expression, "location"), "a",
        (o, v) => ((o as dynamic)).a = v, dirRecord);
  }
  static BindingRecord updateB(String expression, dirRecord) {
    return BindingRecord.createForDirective(
        _getParser().parseBinding(expression, "location"), "b",
        (o, v) => ((o as dynamic)).b = v, dirRecord);
  }
  static List<DirectiveRecord> basicRecords = [
    new DirectiveRecord(
        directiveIndex: new DirectiveIndex(0, 0),
        callOnChange: true,
        callOnCheck: true,
        callOnAllChangesDone: true),
    new DirectiveRecord(
        directiveIndex: new DirectiveIndex(0, 1),
        callOnChange: true,
        callOnCheck: true,
        callOnAllChangesDone: true)
  ];
  static var recordNoCallbacks = new DirectiveRecord(
      directiveIndex: new DirectiveIndex(0, 0),
      callOnChange: false,
      callOnCheck: false,
      callOnAllChangesDone: false);
  /**
   * Map from test id to _DirectiveUpdating.
   * Definitions in this map define definitions which allow testing directive updating.
   */
  static Map<String, _DirectiveUpdating> availableDefinitions = {
    "directNoDispatcher": new _DirectiveUpdating(
        [_DirectiveUpdating.updateA("42", _DirectiveUpdating.basicRecords[0])],
        [_DirectiveUpdating.basicRecords[0]]),
    "groupChanges": new _DirectiveUpdating([
      _DirectiveUpdating.updateA("1", _DirectiveUpdating.basicRecords[0]),
      _DirectiveUpdating.updateB("2", _DirectiveUpdating.basicRecords[0]),
      BindingRecord.createDirectiveOnChange(_DirectiveUpdating.basicRecords[0]),
      _DirectiveUpdating.updateA("3", _DirectiveUpdating.basicRecords[1]),
      BindingRecord.createDirectiveOnChange(_DirectiveUpdating.basicRecords[1])
    ], [
      _DirectiveUpdating.basicRecords[0],
      _DirectiveUpdating.basicRecords[1]
    ]),
    "directiveOnCheck": new _DirectiveUpdating([
      BindingRecord.createDirectiveOnCheck(_DirectiveUpdating.basicRecords[0])
    ], [_DirectiveUpdating.basicRecords[0]]),
    "directiveOnInit": new _DirectiveUpdating([
      BindingRecord.createDirectiveOnInit(_DirectiveUpdating.basicRecords[0])
    ], [_DirectiveUpdating.basicRecords[0]]),
    "emptyWithDirectiveRecords": new _DirectiveUpdating([], [
      _DirectiveUpdating.basicRecords[0],
      _DirectiveUpdating.basicRecords[1]
    ]),
    "noCallbacks": new _DirectiveUpdating(
        [_DirectiveUpdating.updateA("1", _DirectiveUpdating.recordNoCallbacks)],
        [_DirectiveUpdating.recordNoCallbacks]),
    "readingDirectives": new _DirectiveUpdating([
      BindingRecord.createForHostProperty(new DirectiveIndex(0, 0),
          _getParser().parseBinding("a", "location"), PROP_NAME)
    ], [_DirectiveUpdating.basicRecords[0]]),
    "interpolation": new _DirectiveUpdating([
      BindingRecord.createForElementProperty(
          _getParser().parseInterpolation("B{{a}}A", "location"), 0, PROP_NAME)
    ], [])
  };
}
/**
 * The list of all test definitions this config supplies.
 * Items in this list that do not appear in other structures define tests with expressions
 * equivalent to their ids.
 */
var _availableDefinitions = [
  "10",
  "\"str\"",
  "\"a\n\nb\"",
  "10 + 2",
  "10 - 2",
  "10 * 2",
  "10 / 2",
  "11 % 2",
  "1 == 1",
  "1 != 1",
  "1 == true",
  "1 === 1",
  "1 !== 1",
  "1 === true",
  "1 < 2",
  "2 < 1",
  "1 > 2",
  "2 > 1",
  "1 <= 2",
  "2 <= 2",
  "2 <= 1",
  "2 >= 1",
  "2 >= 2",
  "1 >= 2",
  "true && true",
  "true && false",
  "true || false",
  "false || false",
  "!true",
  "!!true",
  "1 < 2 ? 1 : 2",
  "1 > 2 ? 1 : 2",
  "[\"foo\", \"bar\"][0]",
  "{\"foo\": \"bar\"}[\"foo\"]",
  "name",
  "[1, 2]",
  "[1, a]",
  "{z: 1}",
  "{z: a}",
  "name | pipe",
  "name | pipe:'one':address.city",
  "value",
  "a",
  "address.city",
  "address?.city",
  "address?.toString()",
  "sayHi(\"Jim\")",
  "a()(99)",
  "a.sayHi(\"Jim\")",
  "passThrough([12])",
  "invalidFn(1)"
];
