library dart_gen_change_detectors;

import 'package:angular2/src/change_detection/pregen_proto_change_detector.dart'
    as _gen;

class ChangeDetector0 extends _gen.AbstractChangeDetector<dynamic> {
  var literal0;

  ChangeDetector0(dispatcher, protos, directiveRecords)
      : super("\"\$\"", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = "\$";
    if (_gen.looseNotIdentical(l_literal0, this.literal0)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.literal0, l_literal0);
      }

      this.notifyDispatcher(l_literal0);

      this.literal0 = l_literal0;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.literal0 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector0(a, b, c), def);
  }
}

class ChangeDetector1 extends _gen.AbstractChangeDetector<dynamic> {
  var literal0;

  ChangeDetector1(dispatcher, protos, directiveRecords)
      : super("10", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 10;
    if (_gen.looseNotIdentical(l_literal0, this.literal0)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.literal0, l_literal0);
      }

      this.notifyDispatcher(l_literal0);

      this.literal0 = l_literal0;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.literal0 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector1(a, b, c), def);
  }
}

class ChangeDetector2 extends _gen.AbstractChangeDetector<dynamic> {
  var literal0;

  ChangeDetector2(dispatcher, protos, directiveRecords)
      : super("\"str\"", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = "str";
    if (_gen.looseNotIdentical(l_literal0, this.literal0)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.literal0, l_literal0);
      }

      this.notifyDispatcher(l_literal0);

      this.literal0 = l_literal0;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.literal0 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector2(a, b, c), def);
  }
}

class ChangeDetector3 extends _gen.AbstractChangeDetector<dynamic> {
  var literal0;

  ChangeDetector3(dispatcher, protos, directiveRecords) : super(
          "\"a\n\nb\"", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = "a\n\nb";
    if (_gen.looseNotIdentical(l_literal0, this.literal0)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.literal0, l_literal0);
      }

      this.notifyDispatcher(l_literal0);

      this.literal0 = l_literal0;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.literal0 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector3(a, b, c), def);
  }
}

class ChangeDetector4 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_add2;

  ChangeDetector4(dispatcher, protos, directiveRecords)
      : super("10 + 2", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_literal1,
        l_operation_add2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 10;

    l_literal1 = 2;

    l_operation_add2 =
        _gen.ChangeDetectionUtil.operation_add(l_literal0, l_literal1);
    if (_gen.looseNotIdentical(l_operation_add2, this.operation_add2)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.operation_add2, l_operation_add2);
      }

      this.notifyDispatcher(l_operation_add2);

      this.operation_add2 = l_operation_add2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_add2 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector4(a, b, c), def);
  }
}

class ChangeDetector5 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_subtract2;

  ChangeDetector5(dispatcher, protos, directiveRecords)
      : super("10 - 2", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_literal1,
        l_operation_subtract2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 10;

    l_literal1 = 2;

    l_operation_subtract2 =
        _gen.ChangeDetectionUtil.operation_subtract(l_literal0, l_literal1);
    if (_gen.looseNotIdentical(
        l_operation_subtract2, this.operation_subtract2)) {
      if (throwOnChange) {
        this.throwOnChangeError(
            this.operation_subtract2, l_operation_subtract2);
      }

      this.notifyDispatcher(l_operation_subtract2);

      this.operation_subtract2 = l_operation_subtract2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_subtract2 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector5(a, b, c), def);
  }
}

class ChangeDetector6 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_multiply2;

  ChangeDetector6(dispatcher, protos, directiveRecords)
      : super("10 * 2", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_literal1,
        l_operation_multiply2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 10;

    l_literal1 = 2;

    l_operation_multiply2 =
        _gen.ChangeDetectionUtil.operation_multiply(l_literal0, l_literal1);
    if (_gen.looseNotIdentical(
        l_operation_multiply2, this.operation_multiply2)) {
      if (throwOnChange) {
        this.throwOnChangeError(
            this.operation_multiply2, l_operation_multiply2);
      }

      this.notifyDispatcher(l_operation_multiply2);

      this.operation_multiply2 = l_operation_multiply2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_multiply2 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector6(a, b, c), def);
  }
}

class ChangeDetector7 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_divide2;

  ChangeDetector7(dispatcher, protos, directiveRecords)
      : super("10 / 2", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_literal1,
        l_operation_divide2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 10;

    l_literal1 = 2;

    l_operation_divide2 =
        _gen.ChangeDetectionUtil.operation_divide(l_literal0, l_literal1);
    if (_gen.looseNotIdentical(l_operation_divide2, this.operation_divide2)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.operation_divide2, l_operation_divide2);
      }

      this.notifyDispatcher(l_operation_divide2);

      this.operation_divide2 = l_operation_divide2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_divide2 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector7(a, b, c), def);
  }
}

class ChangeDetector8 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_remainder2;

  ChangeDetector8(dispatcher, protos, directiveRecords)
      : super("11 % 2", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_literal1,
        l_operation_remainder2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 11;

    l_literal1 = 2;

    l_operation_remainder2 =
        _gen.ChangeDetectionUtil.operation_remainder(l_literal0, l_literal1);
    if (_gen.looseNotIdentical(
        l_operation_remainder2, this.operation_remainder2)) {
      if (throwOnChange) {
        this.throwOnChangeError(
            this.operation_remainder2, l_operation_remainder2);
      }

      this.notifyDispatcher(l_operation_remainder2);

      this.operation_remainder2 = l_operation_remainder2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_remainder2 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector8(a, b, c), def);
  }
}

class ChangeDetector9 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_equals1;

  ChangeDetector9(dispatcher, protos, directiveRecords)
      : super("1 == 1", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_operation_equals1;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 1;

    l_operation_equals1 =
        _gen.ChangeDetectionUtil.operation_equals(l_literal0, l_literal0);
    if (_gen.looseNotIdentical(l_operation_equals1, this.operation_equals1)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.operation_equals1, l_operation_equals1);
      }

      this.notifyDispatcher(l_operation_equals1);

      this.operation_equals1 = l_operation_equals1;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_equals1 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector9(a, b, c), def);
  }
}

class ChangeDetector10 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_not_equals1;

  ChangeDetector10(dispatcher, protos, directiveRecords)
      : super("1 != 1", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_operation_not_equals1;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 1;

    l_operation_not_equals1 =
        _gen.ChangeDetectionUtil.operation_not_equals(l_literal0, l_literal0);
    if (_gen.looseNotIdentical(
        l_operation_not_equals1, this.operation_not_equals1)) {
      if (throwOnChange) {
        this.throwOnChangeError(
            this.operation_not_equals1, l_operation_not_equals1);
      }

      this.notifyDispatcher(l_operation_not_equals1);

      this.operation_not_equals1 = l_operation_not_equals1;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_not_equals1 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector10(a, b, c), def);
  }
}

class ChangeDetector11 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_equals2;

  ChangeDetector11(dispatcher, protos, directiveRecords) : super(
          "1 == true", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_literal1,
        l_operation_equals2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 1;

    l_literal1 = true;

    l_operation_equals2 =
        _gen.ChangeDetectionUtil.operation_equals(l_literal0, l_literal1);
    if (_gen.looseNotIdentical(l_operation_equals2, this.operation_equals2)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.operation_equals2, l_operation_equals2);
      }

      this.notifyDispatcher(l_operation_equals2);

      this.operation_equals2 = l_operation_equals2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_equals2 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector11(a, b, c), def);
  }
}

class ChangeDetector12 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_identical1;

  ChangeDetector12(dispatcher, protos, directiveRecords)
      : super("1 === 1", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_operation_identical1;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 1;

    l_operation_identical1 =
        _gen.ChangeDetectionUtil.operation_identical(l_literal0, l_literal0);
    if (_gen.looseNotIdentical(
        l_operation_identical1, this.operation_identical1)) {
      if (throwOnChange) {
        this.throwOnChangeError(
            this.operation_identical1, l_operation_identical1);
      }

      this.notifyDispatcher(l_operation_identical1);

      this.operation_identical1 = l_operation_identical1;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_identical1 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector12(a, b, c), def);
  }
}

class ChangeDetector13 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_not_identical1;

  ChangeDetector13(dispatcher, protos, directiveRecords)
      : super("1 !== 1", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_operation_not_identical1;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 1;

    l_operation_not_identical1 = _gen.ChangeDetectionUtil
        .operation_not_identical(l_literal0, l_literal0);
    if (_gen.looseNotIdentical(
        l_operation_not_identical1, this.operation_not_identical1)) {
      if (throwOnChange) {
        this.throwOnChangeError(
            this.operation_not_identical1, l_operation_not_identical1);
      }

      this.notifyDispatcher(l_operation_not_identical1);

      this.operation_not_identical1 = l_operation_not_identical1;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_not_identical1 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector13(a, b, c), def);
  }
}

class ChangeDetector14 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_identical2;

  ChangeDetector14(dispatcher, protos, directiveRecords) : super(
          "1 === true", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_literal1,
        l_operation_identical2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 1;

    l_literal1 = true;

    l_operation_identical2 =
        _gen.ChangeDetectionUtil.operation_identical(l_literal0, l_literal1);
    if (_gen.looseNotIdentical(
        l_operation_identical2, this.operation_identical2)) {
      if (throwOnChange) {
        this.throwOnChangeError(
            this.operation_identical2, l_operation_identical2);
      }

      this.notifyDispatcher(l_operation_identical2);

      this.operation_identical2 = l_operation_identical2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_identical2 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector14(a, b, c), def);
  }
}

class ChangeDetector15 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_less_then2;

  ChangeDetector15(dispatcher, protos, directiveRecords)
      : super("1 < 2", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_literal1,
        l_operation_less_then2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 1;

    l_literal1 = 2;

    l_operation_less_then2 =
        _gen.ChangeDetectionUtil.operation_less_then(l_literal0, l_literal1);
    if (_gen.looseNotIdentical(
        l_operation_less_then2, this.operation_less_then2)) {
      if (throwOnChange) {
        this.throwOnChangeError(
            this.operation_less_then2, l_operation_less_then2);
      }

      this.notifyDispatcher(l_operation_less_then2);

      this.operation_less_then2 = l_operation_less_then2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_less_then2 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector15(a, b, c), def);
  }
}

class ChangeDetector16 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_less_then2;

  ChangeDetector16(dispatcher, protos, directiveRecords)
      : super("2 < 1", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_literal1,
        l_operation_less_then2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 2;

    l_literal1 = 1;

    l_operation_less_then2 =
        _gen.ChangeDetectionUtil.operation_less_then(l_literal0, l_literal1);
    if (_gen.looseNotIdentical(
        l_operation_less_then2, this.operation_less_then2)) {
      if (throwOnChange) {
        this.throwOnChangeError(
            this.operation_less_then2, l_operation_less_then2);
      }

      this.notifyDispatcher(l_operation_less_then2);

      this.operation_less_then2 = l_operation_less_then2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_less_then2 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector16(a, b, c), def);
  }
}

class ChangeDetector17 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_greater_then2;

  ChangeDetector17(dispatcher, protos, directiveRecords)
      : super("1 > 2", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_literal1,
        l_operation_greater_then2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 1;

    l_literal1 = 2;

    l_operation_greater_then2 =
        _gen.ChangeDetectionUtil.operation_greater_then(l_literal0, l_literal1);
    if (_gen.looseNotIdentical(
        l_operation_greater_then2, this.operation_greater_then2)) {
      if (throwOnChange) {
        this.throwOnChangeError(
            this.operation_greater_then2, l_operation_greater_then2);
      }

      this.notifyDispatcher(l_operation_greater_then2);

      this.operation_greater_then2 = l_operation_greater_then2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_greater_then2 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector17(a, b, c), def);
  }
}

class ChangeDetector18 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_greater_then2;

  ChangeDetector18(dispatcher, protos, directiveRecords)
      : super("2 > 1", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_literal1,
        l_operation_greater_then2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 2;

    l_literal1 = 1;

    l_operation_greater_then2 =
        _gen.ChangeDetectionUtil.operation_greater_then(l_literal0, l_literal1);
    if (_gen.looseNotIdentical(
        l_operation_greater_then2, this.operation_greater_then2)) {
      if (throwOnChange) {
        this.throwOnChangeError(
            this.operation_greater_then2, l_operation_greater_then2);
      }

      this.notifyDispatcher(l_operation_greater_then2);

      this.operation_greater_then2 = l_operation_greater_then2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_greater_then2 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector18(a, b, c), def);
  }
}

class ChangeDetector19 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_less_or_equals_then2;

  ChangeDetector19(dispatcher, protos, directiveRecords)
      : super("1 <= 2", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_literal1,
        l_operation_less_or_equals_then2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 1;

    l_literal1 = 2;

    l_operation_less_or_equals_then2 = _gen.ChangeDetectionUtil
        .operation_less_or_equals_then(l_literal0, l_literal1);
    if (_gen.looseNotIdentical(l_operation_less_or_equals_then2,
        this.operation_less_or_equals_then2)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.operation_less_or_equals_then2,
            l_operation_less_or_equals_then2);
      }

      this.notifyDispatcher(l_operation_less_or_equals_then2);

      this.operation_less_or_equals_then2 = l_operation_less_or_equals_then2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_less_or_equals_then2 =
        _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector19(a, b, c), def);
  }
}

class ChangeDetector20 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_less_or_equals_then1;

  ChangeDetector20(dispatcher, protos, directiveRecords)
      : super("2 <= 2", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_operation_less_or_equals_then1;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 2;

    l_operation_less_or_equals_then1 = _gen.ChangeDetectionUtil
        .operation_less_or_equals_then(l_literal0, l_literal0);
    if (_gen.looseNotIdentical(l_operation_less_or_equals_then1,
        this.operation_less_or_equals_then1)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.operation_less_or_equals_then1,
            l_operation_less_or_equals_then1);
      }

      this.notifyDispatcher(l_operation_less_or_equals_then1);

      this.operation_less_or_equals_then1 = l_operation_less_or_equals_then1;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_less_or_equals_then1 =
        _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector20(a, b, c), def);
  }
}

class ChangeDetector21 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_less_or_equals_then2;

  ChangeDetector21(dispatcher, protos, directiveRecords)
      : super("2 <= 1", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_literal1,
        l_operation_less_or_equals_then2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 2;

    l_literal1 = 1;

    l_operation_less_or_equals_then2 = _gen.ChangeDetectionUtil
        .operation_less_or_equals_then(l_literal0, l_literal1);
    if (_gen.looseNotIdentical(l_operation_less_or_equals_then2,
        this.operation_less_or_equals_then2)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.operation_less_or_equals_then2,
            l_operation_less_or_equals_then2);
      }

      this.notifyDispatcher(l_operation_less_or_equals_then2);

      this.operation_less_or_equals_then2 = l_operation_less_or_equals_then2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_less_or_equals_then2 =
        _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector21(a, b, c), def);
  }
}

class ChangeDetector22 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_greater_or_equals_then2;

  ChangeDetector22(dispatcher, protos, directiveRecords)
      : super("2 >= 1", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_literal1,
        l_operation_greater_or_equals_then2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 2;

    l_literal1 = 1;

    l_operation_greater_or_equals_then2 = _gen.ChangeDetectionUtil
        .operation_greater_or_equals_then(l_literal0, l_literal1);
    if (_gen.looseNotIdentical(l_operation_greater_or_equals_then2,
        this.operation_greater_or_equals_then2)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.operation_greater_or_equals_then2,
            l_operation_greater_or_equals_then2);
      }

      this.notifyDispatcher(l_operation_greater_or_equals_then2);

      this.operation_greater_or_equals_then2 =
          l_operation_greater_or_equals_then2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_greater_or_equals_then2 =
        _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector22(a, b, c), def);
  }
}

class ChangeDetector23 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_greater_or_equals_then1;

  ChangeDetector23(dispatcher, protos, directiveRecords)
      : super("2 >= 2", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_operation_greater_or_equals_then1;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 2;

    l_operation_greater_or_equals_then1 = _gen.ChangeDetectionUtil
        .operation_greater_or_equals_then(l_literal0, l_literal0);
    if (_gen.looseNotIdentical(l_operation_greater_or_equals_then1,
        this.operation_greater_or_equals_then1)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.operation_greater_or_equals_then1,
            l_operation_greater_or_equals_then1);
      }

      this.notifyDispatcher(l_operation_greater_or_equals_then1);

      this.operation_greater_or_equals_then1 =
          l_operation_greater_or_equals_then1;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_greater_or_equals_then1 =
        _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector23(a, b, c), def);
  }
}

class ChangeDetector24 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_greater_or_equals_then2;

  ChangeDetector24(dispatcher, protos, directiveRecords)
      : super("1 >= 2", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_literal1,
        l_operation_greater_or_equals_then2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 1;

    l_literal1 = 2;

    l_operation_greater_or_equals_then2 = _gen.ChangeDetectionUtil
        .operation_greater_or_equals_then(l_literal0, l_literal1);
    if (_gen.looseNotIdentical(l_operation_greater_or_equals_then2,
        this.operation_greater_or_equals_then2)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.operation_greater_or_equals_then2,
            l_operation_greater_or_equals_then2);
      }

      this.notifyDispatcher(l_operation_greater_or_equals_then2);

      this.operation_greater_or_equals_then2 =
          l_operation_greater_or_equals_then2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_greater_or_equals_then2 =
        _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector24(a, b, c), def);
  }
}

class ChangeDetector25 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_logical_and1;

  ChangeDetector25(dispatcher, protos, directiveRecords) : super("true && true",
          dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_operation_logical_and1;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = true;

    l_operation_logical_and1 =
        _gen.ChangeDetectionUtil.operation_logical_and(l_literal0, l_literal0);
    if (_gen.looseNotIdentical(
        l_operation_logical_and1, this.operation_logical_and1)) {
      if (throwOnChange) {
        this.throwOnChangeError(
            this.operation_logical_and1, l_operation_logical_and1);
      }

      this.notifyDispatcher(l_operation_logical_and1);

      this.operation_logical_and1 = l_operation_logical_and1;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_logical_and1 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector25(a, b, c), def);
  }
}

class ChangeDetector26 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_logical_and2;

  ChangeDetector26(dispatcher, protos, directiveRecords) : super(
          "true && false", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_literal1,
        l_operation_logical_and2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = true;

    l_literal1 = false;

    l_operation_logical_and2 =
        _gen.ChangeDetectionUtil.operation_logical_and(l_literal0, l_literal1);
    if (_gen.looseNotIdentical(
        l_operation_logical_and2, this.operation_logical_and2)) {
      if (throwOnChange) {
        this.throwOnChangeError(
            this.operation_logical_and2, l_operation_logical_and2);
      }

      this.notifyDispatcher(l_operation_logical_and2);

      this.operation_logical_and2 = l_operation_logical_and2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_logical_and2 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector26(a, b, c), def);
  }
}

class ChangeDetector27 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_logical_or2;

  ChangeDetector27(dispatcher, protos, directiveRecords) : super(
          "true || false", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_literal1,
        l_operation_logical_or2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = true;

    l_literal1 = false;

    l_operation_logical_or2 =
        _gen.ChangeDetectionUtil.operation_logical_or(l_literal0, l_literal1);
    if (_gen.looseNotIdentical(
        l_operation_logical_or2, this.operation_logical_or2)) {
      if (throwOnChange) {
        this.throwOnChangeError(
            this.operation_logical_or2, l_operation_logical_or2);
      }

      this.notifyDispatcher(l_operation_logical_or2);

      this.operation_logical_or2 = l_operation_logical_or2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_logical_or2 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector27(a, b, c), def);
  }
}

class ChangeDetector28 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_logical_or1;

  ChangeDetector28(dispatcher, protos, directiveRecords) : super(
          "false || false", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_operation_logical_or1;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = false;

    l_operation_logical_or1 =
        _gen.ChangeDetectionUtil.operation_logical_or(l_literal0, l_literal0);
    if (_gen.looseNotIdentical(
        l_operation_logical_or1, this.operation_logical_or1)) {
      if (throwOnChange) {
        this.throwOnChangeError(
            this.operation_logical_or1, l_operation_logical_or1);
      }

      this.notifyDispatcher(l_operation_logical_or1);

      this.operation_logical_or1 = l_operation_logical_or1;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_logical_or1 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector28(a, b, c), def);
  }
}

class ChangeDetector29 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_negate1;

  ChangeDetector29(dispatcher, protos, directiveRecords)
      : super("!true", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_operation_negate1;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = true;

    l_operation_negate1 = _gen.ChangeDetectionUtil.operation_negate(l_literal0);
    if (_gen.looseNotIdentical(l_operation_negate1, this.operation_negate1)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.operation_negate1, l_operation_negate1);
      }

      this.notifyDispatcher(l_operation_negate1);

      this.operation_negate1 = l_operation_negate1;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_negate1 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector29(a, b, c), def);
  }
}

class ChangeDetector30 extends _gen.AbstractChangeDetector<dynamic> {
  var operation_negate2;

  ChangeDetector30(dispatcher, protos, directiveRecords)
      : super("!!true", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_operation_negate1,
        l_operation_negate2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = true;

    l_operation_negate1 = _gen.ChangeDetectionUtil.operation_negate(l_literal0);

    l_operation_negate2 =
        _gen.ChangeDetectionUtil.operation_negate(l_operation_negate1);
    if (_gen.looseNotIdentical(l_operation_negate2, this.operation_negate2)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.operation_negate2, l_operation_negate2);
      }

      this.notifyDispatcher(l_operation_negate2);

      this.operation_negate2 = l_operation_negate2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.operation_negate2 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector30(a, b, c), def);
  }
}

class ChangeDetector31 extends _gen.AbstractChangeDetector<dynamic> {
  var cond3;

  ChangeDetector31(dispatcher, protos, directiveRecords) : super(
          "1 < 2 ? 1 : 2", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_literal1,
        l_operation_less_then2,
        l_cond3;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 1;

    l_literal1 = 2;

    l_operation_less_then2 =
        _gen.ChangeDetectionUtil.operation_less_then(l_literal0, l_literal1);

    l_cond3 = _gen.ChangeDetectionUtil.cond(
        l_operation_less_then2, l_literal0, l_literal1);
    if (_gen.looseNotIdentical(l_cond3, this.cond3)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.cond3, l_cond3);
      }

      this.notifyDispatcher(l_cond3);

      this.cond3 = l_cond3;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.cond3 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector31(a, b, c), def);
  }
}

class ChangeDetector32 extends _gen.AbstractChangeDetector<dynamic> {
  var cond3;

  ChangeDetector32(dispatcher, protos, directiveRecords) : super(
          "1 > 2 ? 1 : 2", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_literal1,
        l_operation_greater_then2,
        l_cond3;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 1;

    l_literal1 = 2;

    l_operation_greater_then2 =
        _gen.ChangeDetectionUtil.operation_greater_then(l_literal0, l_literal1);

    l_cond3 = _gen.ChangeDetectionUtil.cond(
        l_operation_greater_then2, l_literal0, l_literal1);
    if (_gen.looseNotIdentical(l_cond3, this.cond3)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.cond3, l_cond3);
      }

      this.notifyDispatcher(l_cond3);

      this.cond3 = l_cond3;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.cond3 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector32(a, b, c), def);
  }
}

class ChangeDetector33 extends _gen.AbstractChangeDetector<dynamic> {
  var literal0, literal1, arrayFn22, keyedAccess4;

  ChangeDetector33(dispatcher, protos, directiveRecords) : super(
          "[\"foo\", \"bar\"][0]", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        c_literal0,
        l_literal1,
        c_literal1,
        l_arrayFn22,
        l_literal3,
        l_keyedAccess4;
    c_literal0 = c_literal1 = false;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = "foo";
    if (_gen.looseNotIdentical(l_literal0, this.literal0)) {
      c_literal0 = true;

      this.literal0 = l_literal0;
    }

    l_literal1 = "bar";
    if (_gen.looseNotIdentical(l_literal1, this.literal1)) {
      c_literal1 = true;

      this.literal1 = l_literal1;
    }

    if (c_literal0 || c_literal1) {
      l_arrayFn22 = _gen.ChangeDetectionUtil.arrayFn2(l_literal0, l_literal1);
      if (_gen.looseNotIdentical(l_arrayFn22, this.arrayFn22)) {
        this.arrayFn22 = l_arrayFn22;
      }
    } else {
      l_arrayFn22 = this.arrayFn22;
    }

    l_literal3 = 0;

    l_keyedAccess4 = l_arrayFn22[l_literal3];
    if (_gen.looseNotIdentical(l_keyedAccess4, this.keyedAccess4)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.keyedAccess4, l_keyedAccess4);
      }

      this.notifyDispatcher(l_keyedAccess4);

      this.keyedAccess4 = l_keyedAccess4;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.literal0 = this.literal1 = this.arrayFn22 =
        this.keyedAccess4 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector33(a, b, c), def);
  }
}

class ChangeDetector34 extends _gen.AbstractChangeDetector<dynamic> {
  var literal0, mapFnfoo1, keyedAccess3;

  ChangeDetector34(dispatcher, protos, directiveRecords) : super(
          "{\"foo\": \"bar\"}[\"foo\"]", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        c_literal0,
        l_mapFnfoo1,
        l_literal2,
        l_keyedAccess3;
    c_literal0 = false;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = "bar";
    if (_gen.looseNotIdentical(l_literal0, this.literal0)) {
      c_literal0 = true;

      this.literal0 = l_literal0;
    }

    if (c_literal0) {
      l_mapFnfoo1 = _gen.ChangeDetectionUtil.mapFn(["foo"])(l_literal0);
      if (_gen.looseNotIdentical(l_mapFnfoo1, this.mapFnfoo1)) {
        this.mapFnfoo1 = l_mapFnfoo1;
      }
    } else {
      l_mapFnfoo1 = this.mapFnfoo1;
    }

    l_literal2 = "foo";

    l_keyedAccess3 = l_mapFnfoo1[l_literal2];
    if (_gen.looseNotIdentical(l_keyedAccess3, this.keyedAccess3)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.keyedAccess3, l_keyedAccess3);
      }

      this.notifyDispatcher(l_keyedAccess3);

      this.keyedAccess3 = l_keyedAccess3;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.literal0 = this.mapFnfoo1 =
        this.keyedAccess3 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector34(a, b, c), def);
  }
}

class ChangeDetector35 extends _gen.AbstractChangeDetector<dynamic> {
  var name0;

  ChangeDetector35(dispatcher, protos, directiveRecords)
      : super("name", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_name0;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_name0 = l_context.name;
    if (_gen.looseNotIdentical(l_name0, this.name0)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.name0, l_name0);
      }

      this.notifyDispatcher(l_name0);

      this.name0 = l_name0;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.name0 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector35(a, b, c), def);
  }
}

class ChangeDetector36 extends _gen.AbstractChangeDetector<dynamic> {
  var literal0, literal1, arrayFn22;

  ChangeDetector36(dispatcher, protos, directiveRecords)
      : super("[1, 2]", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        c_literal0,
        l_literal1,
        c_literal1,
        l_arrayFn22;
    c_literal0 = c_literal1 = false;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 1;
    if (_gen.looseNotIdentical(l_literal0, this.literal0)) {
      c_literal0 = true;

      this.literal0 = l_literal0;
    }

    l_literal1 = 2;
    if (_gen.looseNotIdentical(l_literal1, this.literal1)) {
      c_literal1 = true;

      this.literal1 = l_literal1;
    }

    if (c_literal0 || c_literal1) {
      l_arrayFn22 = _gen.ChangeDetectionUtil.arrayFn2(l_literal0, l_literal1);
      if (_gen.looseNotIdentical(l_arrayFn22, this.arrayFn22)) {
        if (throwOnChange) {
          this.throwOnChangeError(this.arrayFn22, l_arrayFn22);
        }

        this.notifyDispatcher(l_arrayFn22);

        this.arrayFn22 = l_arrayFn22;
      }
    }
    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.literal0 =
        this.literal1 = this.arrayFn22 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector36(a, b, c), def);
  }
}

class ChangeDetector37 extends _gen.AbstractChangeDetector<dynamic> {
  var literal0, a1, arrayFn22;

  ChangeDetector37(dispatcher, protos, directiveRecords)
      : super("[1, a]", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        c_literal0,
        l_a1,
        c_a1,
        l_arrayFn22;
    c_literal0 = c_a1 = false;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 1;
    if (_gen.looseNotIdentical(l_literal0, this.literal0)) {
      c_literal0 = true;

      this.literal0 = l_literal0;
    }

    l_a1 = l_context.a;
    if (_gen.looseNotIdentical(l_a1, this.a1)) {
      c_a1 = true;

      this.a1 = l_a1;
    }

    if (c_literal0 || c_a1) {
      l_arrayFn22 = _gen.ChangeDetectionUtil.arrayFn2(l_literal0, l_a1);
      if (_gen.looseNotIdentical(l_arrayFn22, this.arrayFn22)) {
        if (throwOnChange) {
          this.throwOnChangeError(this.arrayFn22, l_arrayFn22);
        }

        this.notifyDispatcher(l_arrayFn22);

        this.arrayFn22 = l_arrayFn22;
      }
    }
    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.literal0 =
        this.a1 = this.arrayFn22 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector37(a, b, c), def);
  }
}

class ChangeDetector38 extends _gen.AbstractChangeDetector<dynamic> {
  var literal0, mapFnz1;

  ChangeDetector38(dispatcher, protos, directiveRecords)
      : super("{z: 1}", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        c_literal0,
        l_mapFnz1;
    c_literal0 = false;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 1;
    if (_gen.looseNotIdentical(l_literal0, this.literal0)) {
      c_literal0 = true;

      this.literal0 = l_literal0;
    }

    if (c_literal0) {
      l_mapFnz1 = _gen.ChangeDetectionUtil.mapFn(["z"])(l_literal0);
      if (_gen.looseNotIdentical(l_mapFnz1, this.mapFnz1)) {
        if (throwOnChange) {
          this.throwOnChangeError(this.mapFnz1, l_mapFnz1);
        }

        this.notifyDispatcher(l_mapFnz1);

        this.mapFnz1 = l_mapFnz1;
      }
    }
    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.literal0 = this.mapFnz1 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector38(a, b, c), def);
  }
}

class ChangeDetector39 extends _gen.AbstractChangeDetector<dynamic> {
  var a0, mapFnz1;

  ChangeDetector39(dispatcher, protos, directiveRecords)
      : super("{z: a}", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_a0,
        c_a0,
        l_mapFnz1;
    c_a0 = false;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_a0 = l_context.a;
    if (_gen.looseNotIdentical(l_a0, this.a0)) {
      c_a0 = true;

      this.a0 = l_a0;
    }

    if (c_a0) {
      l_mapFnz1 = _gen.ChangeDetectionUtil.mapFn(["z"])(l_a0);
      if (_gen.looseNotIdentical(l_mapFnz1, this.mapFnz1)) {
        if (throwOnChange) {
          this.throwOnChangeError(this.mapFnz1, l_mapFnz1);
        }

        this.notifyDispatcher(l_mapFnz1);

        this.mapFnz1 = l_mapFnz1;
      }
    }
    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.a0 = this.mapFnz1 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector39(a, b, c), def);
  }
}

class ChangeDetector40 extends _gen.AbstractChangeDetector<dynamic> {
  var pipe1, pipe1_pipe;

  ChangeDetector40(dispatcher, protos, directiveRecords) : super(
          "name | pipe", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_name0,
        l_pipe1;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_name0 = l_context.name;

    if (_gen.looseIdentical(
        this.pipe1_pipe, _gen.ChangeDetectionUtil.uninitialized)) {
      this.pipe1_pipe = this.pipes.get('pipe', l_name0, this.ref);
    } else if (!this.pipe1_pipe.supports(l_name0)) {
      this.pipe1_pipe.onDestroy();
      this.pipe1_pipe = this.pipes.get('pipe', l_name0, this.ref);
    }
    l_pipe1 = this.pipe1_pipe.transform(l_name0, []);
    if (_gen.looseNotIdentical(this.pipe1, l_pipe1)) {
      l_pipe1 = _gen.ChangeDetectionUtil.unwrapValue(l_pipe1);

      if (throwOnChange) {
        this.throwOnChangeError(this.pipe1, l_pipe1);
      }

      this.notifyDispatcher(l_pipe1);

      this.pipe1 = l_pipe1;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    if (destroyPipes) {
      this.pipe1_pipe.onDestroy();
    }
    this.pipe1 = this.pipe1_pipe = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector40(a, b, c), def);
  }
}

class ChangeDetector41 extends _gen.AbstractChangeDetector<dynamic> {
  var length2, pipe1_pipe;

  ChangeDetector41(dispatcher, protos, directiveRecords) : super(
          "(name | pipe).length", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_name0,
        l_pipe1,
        l_length2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_name0 = l_context.name;

    if (_gen.looseIdentical(
        this.pipe1_pipe, _gen.ChangeDetectionUtil.uninitialized)) {
      this.pipe1_pipe = this.pipes.get('pipe', l_name0, this.ref);
    } else if (!this.pipe1_pipe.supports(l_name0)) {
      this.pipe1_pipe.onDestroy();
      this.pipe1_pipe = this.pipes.get('pipe', l_name0, this.ref);
    }
    l_pipe1 = this.pipe1_pipe.transform(l_name0, []);

    l_length2 = l_pipe1.length;
    if (_gen.looseNotIdentical(l_length2, this.length2)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.length2, l_length2);
      }

      this.notifyDispatcher(l_length2);

      this.length2 = l_length2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    if (destroyPipes) {
      this.pipe1_pipe.onDestroy();
    }
    this.length2 = this.pipe1_pipe = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector41(a, b, c), def);
  }
}

class ChangeDetector42 extends _gen.AbstractChangeDetector<dynamic> {
  var pipe4, pipe4_pipe;

  ChangeDetector42(dispatcher, protos, directiveRecords) : super(
          "name | pipe:'one':address.city", dispatcher, protos,
          directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_name0,
        l_literal1,
        l_address2,
        l_city3,
        l_pipe4;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_name0 = l_context.name;

    l_literal1 = "one";

    l_address2 = l_context.address;

    l_city3 = l_address2.city;

    if (_gen.looseIdentical(
        this.pipe4_pipe, _gen.ChangeDetectionUtil.uninitialized)) {
      this.pipe4_pipe = this.pipes.get('pipe', l_name0, this.ref);
    } else if (!this.pipe4_pipe.supports(l_name0)) {
      this.pipe4_pipe.onDestroy();
      this.pipe4_pipe = this.pipes.get('pipe', l_name0, this.ref);
    }
    l_pipe4 = this.pipe4_pipe.transform(l_name0, [l_literal1, l_city3]);
    if (_gen.looseNotIdentical(this.pipe4, l_pipe4)) {
      l_pipe4 = _gen.ChangeDetectionUtil.unwrapValue(l_pipe4);

      if (throwOnChange) {
        this.throwOnChangeError(this.pipe4, l_pipe4);
      }

      this.notifyDispatcher(l_pipe4);

      this.pipe4 = l_pipe4;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    if (destroyPipes) {
      this.pipe4_pipe.onDestroy();
    }
    this.pipe4 = this.pipe4_pipe = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector42(a, b, c), def);
  }
}

class ChangeDetector43 extends _gen.AbstractChangeDetector<dynamic> {
  var value0;

  ChangeDetector43(dispatcher, protos, directiveRecords)
      : super("value", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_value0;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_value0 = l_context.value;
    if (_gen.looseNotIdentical(l_value0, this.value0)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.value0, l_value0);
      }

      this.notifyDispatcher(l_value0);

      this.value0 = l_value0;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.value0 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector43(a, b, c), def);
  }
}

class ChangeDetector44 extends _gen.AbstractChangeDetector<dynamic> {
  var a0;

  ChangeDetector44(dispatcher, protos, directiveRecords)
      : super("a", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_a0;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_a0 = l_context.a;
    if (_gen.looseNotIdentical(l_a0, this.a0)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.a0, l_a0);
      }

      this.notifyDispatcher(l_a0);

      this.a0 = l_a0;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.a0 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector44(a, b, c), def);
  }
}

class ChangeDetector45 extends _gen.AbstractChangeDetector<dynamic> {
  var city1;

  ChangeDetector45(dispatcher, protos, directiveRecords) : super("address.city",
          dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_address0,
        l_city1;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_address0 = l_context.address;

    l_city1 = l_address0.city;
    if (_gen.looseNotIdentical(l_city1, this.city1)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.city1, l_city1);
      }

      this.notifyDispatcher(l_city1);

      this.city1 = l_city1;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.city1 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector45(a, b, c), def);
  }
}

class ChangeDetector46 extends _gen.AbstractChangeDetector<dynamic> {
  var city1;

  ChangeDetector46(dispatcher, protos, directiveRecords) : super(
          "address?.city", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_address0,
        l_city1;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_address0 = l_context.address;

    l_city1 = _gen.ChangeDetectionUtil.isValueBlank(l_address0)
        ? null
        : l_address0.city;
    if (_gen.looseNotIdentical(l_city1, this.city1)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.city1, l_city1);
      }

      this.notifyDispatcher(l_city1);

      this.city1 = l_city1;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.city1 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector46(a, b, c), def);
  }
}

class ChangeDetector47 extends _gen.AbstractChangeDetector<dynamic> {
  var toString1;

  ChangeDetector47(dispatcher, protos, directiveRecords) : super(
          "address?.toString()", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_address0,
        l_toString1;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_address0 = l_context.address;

    l_toString1 = _gen.ChangeDetectionUtil.isValueBlank(l_address0)
        ? null
        : l_address0.toString();
    if (_gen.looseNotIdentical(l_toString1, this.toString1)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.toString1, l_toString1);
      }

      this.notifyDispatcher(l_toString1);

      this.toString1 = l_toString1;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.toString1 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector47(a, b, c), def);
  }
}

class ChangeDetector48 extends _gen.AbstractChangeDetector<dynamic> {
  var sayHi1;

  ChangeDetector48(dispatcher, protos, directiveRecords) : super(
          "sayHi(\"Jim\")", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_sayHi1;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = "Jim";

    l_sayHi1 = l_context.sayHi(l_literal0);
    if (_gen.looseNotIdentical(l_sayHi1, this.sayHi1)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.sayHi1, l_sayHi1);
      }

      this.notifyDispatcher(l_sayHi1);

      this.sayHi1 = l_sayHi1;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.sayHi1 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector48(a, b, c), def);
  }
}

class ChangeDetector49 extends _gen.AbstractChangeDetector<dynamic> {
  var closure2;

  ChangeDetector49(dispatcher, protos, directiveRecords)
      : super("a()(99)", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_a0,
        l_literal1,
        l_closure2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_a0 = l_context.a();

    l_literal1 = 99;

    l_closure2 = l_a0(l_literal1);
    if (_gen.looseNotIdentical(l_closure2, this.closure2)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.closure2, l_closure2);
      }

      this.notifyDispatcher(l_closure2);

      this.closure2 = l_closure2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.closure2 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector49(a, b, c), def);
  }
}

class ChangeDetector50 extends _gen.AbstractChangeDetector<dynamic> {
  var sayHi2;

  ChangeDetector50(dispatcher, protos, directiveRecords) : super(
          "a.sayHi(\"Jim\")", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_a0,
        l_literal1,
        l_sayHi2;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_a0 = l_context.a;

    l_literal1 = "Jim";

    l_sayHi2 = l_a0.sayHi(l_literal1);
    if (_gen.looseNotIdentical(l_sayHi2, this.sayHi2)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.sayHi2, l_sayHi2);
      }

      this.notifyDispatcher(l_sayHi2);

      this.sayHi2 = l_sayHi2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.sayHi2 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector50(a, b, c), def);
  }
}

class ChangeDetector51 extends _gen.AbstractChangeDetector<dynamic> {
  var literal0, arrayFn11, passThrough2;

  ChangeDetector51(dispatcher, protos, directiveRecords) : super(
          "passThrough([12])", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        c_literal0,
        l_arrayFn11,
        l_passThrough2;
    c_literal0 = false;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 12;
    if (_gen.looseNotIdentical(l_literal0, this.literal0)) {
      c_literal0 = true;

      this.literal0 = l_literal0;
    }

    if (c_literal0) {
      l_arrayFn11 = _gen.ChangeDetectionUtil.arrayFn1(l_literal0);
      if (_gen.looseNotIdentical(l_arrayFn11, this.arrayFn11)) {
        this.arrayFn11 = l_arrayFn11;
      }
    } else {
      l_arrayFn11 = this.arrayFn11;
    }

    l_passThrough2 = l_context.passThrough(l_arrayFn11);
    if (_gen.looseNotIdentical(l_passThrough2, this.passThrough2)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.passThrough2, l_passThrough2);
      }

      this.notifyDispatcher(l_passThrough2);

      this.passThrough2 = l_passThrough2;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.literal0 = this.arrayFn11 =
        this.passThrough2 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector51(a, b, c), def);
  }
}

class ChangeDetector52 extends _gen.AbstractChangeDetector<dynamic> {
  var invalidFn1;

  ChangeDetector52(dispatcher, protos, directiveRecords) : super("invalidFn(1)",
          dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_invalidFn1;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 1;

    l_invalidFn1 = l_context.invalidFn(l_literal0);
    if (_gen.looseNotIdentical(l_invalidFn1, this.invalidFn1)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.invalidFn1, l_invalidFn1);
      }

      this.notifyDispatcher(l_invalidFn1);

      this.invalidFn1 = l_invalidFn1;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.invalidFn1 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector52(a, b, c), def);
  }
}

class ChangeDetector53 extends _gen.AbstractChangeDetector<dynamic> {
  var key0;

  ChangeDetector53(dispatcher, protos, directiveRecords) : super(
          "valueFromLocals", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_key0;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_key0 = this.locals.get("key");
    if (_gen.looseNotIdentical(l_key0, this.key0)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.key0, l_key0);
      }

      this.notifyDispatcher(l_key0);

      this.key0 = l_key0;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.key0 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector53(a, b, c), def);
  }
}

class ChangeDetector54 extends _gen.AbstractChangeDetector<dynamic> {
  var closure1;

  ChangeDetector54(dispatcher, protos, directiveRecords) : super(
          "functionFromLocals", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_key0,
        l_closure1;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_key0 = this.locals.get("key");

    l_closure1 = l_key0();
    if (_gen.looseNotIdentical(l_closure1, this.closure1)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.closure1, l_closure1);
      }

      this.notifyDispatcher(l_closure1);

      this.closure1 = l_closure1;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.closure1 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector54(a, b, c), def);
  }
}

class ChangeDetector55 extends _gen.AbstractChangeDetector<dynamic> {
  var key0;

  ChangeDetector55(dispatcher, protos, directiveRecords) : super("nestedLocals",
          dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_key0;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_key0 = this.locals.get("key");
    if (_gen.looseNotIdentical(l_key0, this.key0)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.key0, l_key0);
      }

      this.notifyDispatcher(l_key0);

      this.key0 = l_key0;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.key0 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector55(a, b, c), def);
  }
}

class ChangeDetector56 extends _gen.AbstractChangeDetector<dynamic> {
  var name0;

  ChangeDetector56(dispatcher, protos, directiveRecords) : super(
          "fallbackLocals", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_name0;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_name0 = l_context.name;
    if (_gen.looseNotIdentical(l_name0, this.name0)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.name0, l_name0);
      }

      this.notifyDispatcher(l_name0);

      this.name0 = l_name0;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.name0 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector56(a, b, c), def);
  }
}

class ChangeDetector57 extends _gen.AbstractChangeDetector<dynamic> {
  var city1;

  ChangeDetector57(dispatcher, protos, directiveRecords) : super(
          "contextNestedPropertyWithLocals", dispatcher, protos,
          directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_address0,
        l_city1;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_address0 = l_context.address;

    l_city1 = l_address0.city;
    if (_gen.looseNotIdentical(l_city1, this.city1)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.city1, l_city1);
      }

      this.notifyDispatcher(l_city1);

      this.city1 = l_city1;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.city1 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector57(a, b, c), def);
  }
}

class ChangeDetector58 extends _gen.AbstractChangeDetector<dynamic> {
  var city0;

  ChangeDetector58(dispatcher, protos, directiveRecords) : super(
          "localPropertyWithSimilarContext", dispatcher, protos,
          directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_city0;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_city0 = this.locals.get("city");
    if (_gen.looseNotIdentical(l_city0, this.city0)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.city0, l_city0);
      }

      this.notifyDispatcher(l_city0);

      this.city0 = l_city0;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.city0 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector58(a, b, c), def);
  }
}

class ChangeDetector59 extends _gen.AbstractChangeDetector<dynamic> {
  ChangeDetector59(dispatcher, protos, directiveRecords) : super(
          "emptyUsingDefaultStrategy", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context;
    var isChanged = false;
    var changes = null;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector59(a, b, c), def);
  }
}

class ChangeDetector60 extends _gen.AbstractChangeDetector<dynamic> {
  ChangeDetector60(dispatcher, protos, directiveRecords) : super(
          "emptyUsingOnPushStrategy", dispatcher, protos, directiveRecords,
          'CHECK_ONCE') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context;
    var isChanged = false;
    var changes = null;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector60(a, b, c), def);
  }
}

class ChangeDetector61 extends _gen.AbstractChangeDetector<dynamic> {
  var literal0, directive_0_0, detector_0_0;

  ChangeDetector61(dispatcher, protos, directiveRecords) : super(
          "onPushRecordsUsingDefaultStrategy", dispatcher, protos,
          directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 42;
    if (_gen.looseNotIdentical(l_literal0, this.literal0)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.literal0, l_literal0);
      }

      this.directive_0_0.a = l_literal0;
      isChanged = true;

      this.literal0 = l_literal0;
    }

    changes = null;
    if (isChanged) {
      this.detector_0_0.markAsCheckOnce();
    }

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void hydrateDirectives(directives) {
    this.directive_0_0 =
        directives.getDirectiveFor(this.directiveRecords[0].directiveIndex);
    this.detector_0_0 =
        directives.getDetectorFor(this.directiveRecords[0].directiveIndex);
  }

  void dehydrateDirectives(destroyPipes) {
    this.literal0 = this.directive_0_0 =
        this.detector_0_0 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector61(a, b, c), def);
  }
}

class ChangeDetector62 extends _gen.AbstractChangeDetector<dynamic> {
  var literal0, directive_0_0;

  ChangeDetector62(dispatcher, protos, directiveRecords) : super(
          "directNoDispatcher", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 42;
    if (_gen.looseNotIdentical(l_literal0, this.literal0)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.literal0, l_literal0);
      }

      this.directive_0_0.a = l_literal0;
      isChanged = true;

      changes = addChange(changes, this.literal0, l_literal0);
      this.literal0 = l_literal0;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void callOnAllChangesDone() {
    this.dispatcher.notifyOnAllChangesDone();
    this.directive_0_0.onAllChangesDone();
  }

  void hydrateDirectives(directives) {
    this.directive_0_0 =
        directives.getDirectiveFor(this.directiveRecords[0].directiveIndex);
  }

  void dehydrateDirectives(destroyPipes) {
    this.literal0 = this.directive_0_0 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector62(a, b, c), def);
  }
}

class ChangeDetector63 extends _gen.AbstractChangeDetector<dynamic> {
  var literal0,
      literal1,
      onChange2,
      literal3,
      onChange4,
      directive_0_0,
      directive_0_1;

  ChangeDetector63(dispatcher, protos, directiveRecords) : super("groupChanges",
          dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0,
        l_literal1,
        l_onChange2,
        l_literal3,
        l_onChange4;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 1;
    if (_gen.looseNotIdentical(l_literal0, this.literal0)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.literal0, l_literal0);
      }

      this.directive_0_0.a = l_literal0;
      isChanged = true;

      changes = addChange(changes, this.literal0, l_literal0);
      this.literal0 = l_literal0;
    }

    this.firstProtoInCurrentBinding = 2;
    l_literal1 = 2;
    if (_gen.looseNotIdentical(l_literal1, this.literal1)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.literal1, l_literal1);
      }

      this.directive_0_0.b = l_literal1;
      isChanged = true;

      changes = addChange(changes, this.literal1, l_literal1);
      this.literal1 = l_literal1;
    }

    this.firstProtoInCurrentBinding = 3;
    if (!throwOnChange && changes != null) this.directive_0_0.onChange(changes);
    changes = null;

    isChanged = false;

    this.firstProtoInCurrentBinding = 4;
    l_literal3 = 3;
    if (_gen.looseNotIdentical(l_literal3, this.literal3)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.literal3, l_literal3);
      }

      this.directive_0_1.a = l_literal3;
      isChanged = true;

      changes = addChange(changes, this.literal3, l_literal3);
      this.literal3 = l_literal3;
    }

    this.firstProtoInCurrentBinding = 5;
    if (!throwOnChange && changes != null) this.directive_0_1.onChange(changes);
    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void callOnAllChangesDone() {
    this.dispatcher.notifyOnAllChangesDone();
    this.directive_0_1.onAllChangesDone();
    this.directive_0_0.onAllChangesDone();
  }

  void hydrateDirectives(directives) {
    this.directive_0_0 =
        directives.getDirectiveFor(this.directiveRecords[0].directiveIndex);
    this.directive_0_1 =
        directives.getDirectiveFor(this.directiveRecords[1].directiveIndex);
  }

  void dehydrateDirectives(destroyPipes) {
    this.literal0 = this.literal1 = this.onChange2 = this.literal3 =
        this.onChange4 = this.directive_0_0 =
        this.directive_0_1 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector63(a, b, c), def);
  }
}

class ChangeDetector64 extends _gen.AbstractChangeDetector<dynamic> {
  var onCheck0, directive_0_0;

  ChangeDetector64(dispatcher, protos, directiveRecords) : super(
          "directiveOnCheck", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_onCheck0;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    if (!throwOnChange) this.directive_0_0.onCheck();
    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void callOnAllChangesDone() {
    this.dispatcher.notifyOnAllChangesDone();
    this.directive_0_0.onAllChangesDone();
  }

  void hydrateDirectives(directives) {
    this.directive_0_0 =
        directives.getDirectiveFor(this.directiveRecords[0].directiveIndex);
  }

  void dehydrateDirectives(destroyPipes) {
    this.onCheck0 = this.directive_0_0 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector64(a, b, c), def);
  }
}

class ChangeDetector65 extends _gen.AbstractChangeDetector<dynamic> {
  var onInit0, directive_0_0;

  ChangeDetector65(dispatcher, protos, directiveRecords) : super(
          "directiveOnInit", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_onInit0;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    if (!throwOnChange && !this.alreadyChecked) this.directive_0_0.onInit();
    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void callOnAllChangesDone() {
    this.dispatcher.notifyOnAllChangesDone();
    this.directive_0_0.onAllChangesDone();
  }

  void hydrateDirectives(directives) {
    this.directive_0_0 =
        directives.getDirectiveFor(this.directiveRecords[0].directiveIndex);
  }

  void dehydrateDirectives(destroyPipes) {
    this.onInit0 = this.directive_0_0 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector65(a, b, c), def);
  }
}

class ChangeDetector66 extends _gen.AbstractChangeDetector<dynamic> {
  var directive_0_0, directive_0_1;

  ChangeDetector66(dispatcher, protos, directiveRecords) : super(
          "emptyWithDirectiveRecords", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context;
    var isChanged = false;
    var changes = null;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void callOnAllChangesDone() {
    this.dispatcher.notifyOnAllChangesDone();
    this.directive_0_1.onAllChangesDone();
    this.directive_0_0.onAllChangesDone();
  }

  void hydrateDirectives(directives) {
    this.directive_0_0 =
        directives.getDirectiveFor(this.directiveRecords[0].directiveIndex);
    this.directive_0_1 =
        directives.getDirectiveFor(this.directiveRecords[1].directiveIndex);
  }

  void dehydrateDirectives(destroyPipes) {
    this.directive_0_0 =
        this.directive_0_1 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector66(a, b, c), def);
  }
}

class ChangeDetector67 extends _gen.AbstractChangeDetector<dynamic> {
  var literal0, directive_0_0;

  ChangeDetector67(dispatcher, protos, directiveRecords) : super(
          "noCallbacks", dispatcher, protos, directiveRecords, 'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_literal0;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_literal0 = 1;
    if (_gen.looseNotIdentical(l_literal0, this.literal0)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.literal0, l_literal0);
      }

      this.directive_0_0.a = l_literal0;
      isChanged = true;

      this.literal0 = l_literal0;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void hydrateDirectives(directives) {
    this.directive_0_0 =
        directives.getDirectiveFor(this.directiveRecords[0].directiveIndex);
  }

  void dehydrateDirectives(destroyPipes) {
    this.literal0 = this.directive_0_0 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector67(a, b, c), def);
  }
}

class ChangeDetector68 extends _gen.AbstractChangeDetector<dynamic> {
  var a0, directive_0_0;

  ChangeDetector68(dispatcher, protos, directiveRecords) : super(
          "readingDirectives", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_a0;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_a0 = this.directive_0_0.a;
    if (_gen.looseNotIdentical(l_a0, this.a0)) {
      if (throwOnChange) {
        this.throwOnChangeError(this.a0, l_a0);
      }

      this.notifyDispatcher(l_a0);

      this.a0 = l_a0;
    }

    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void callOnAllChangesDone() {
    this.dispatcher.notifyOnAllChangesDone();
    this.directive_0_0.onAllChangesDone();
  }

  void hydrateDirectives(directives) {
    this.directive_0_0 =
        directives.getDirectiveFor(this.directiveRecords[0].directiveIndex);
  }

  void dehydrateDirectives(destroyPipes) {
    this.a0 = this.directive_0_0 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector68(a, b, c), def);
  }
}

class ChangeDetector69 extends _gen.AbstractChangeDetector<dynamic> {
  var a0, interpolate1;

  ChangeDetector69(dispatcher, protos, directiveRecords) : super(
          "interpolation", dispatcher, protos, directiveRecords,
          'ALWAYS_CHECK') {
    dehydrateDirectives(false);
  }

  void detectChangesInRecordsInternal(throwOnChange) {
    var l_context = this.context,
        l_a0,
        c_a0,
        l_interpolate1;
    c_a0 = false;
    var isChanged = false;
    var changes = null;

    this.firstProtoInCurrentBinding = 1;
    l_a0 = l_context.a;
    if (_gen.looseNotIdentical(l_a0, this.a0)) {
      c_a0 = true;

      this.a0 = l_a0;
    }

    if (c_a0) {
      l_interpolate1 = "B" "${l_a0 == null ? "" : l_a0}" "A";
      if (_gen.looseNotIdentical(l_interpolate1, this.interpolate1)) {
        if (throwOnChange) {
          this.throwOnChangeError(this.interpolate1, l_interpolate1);
        }

        this.notifyDispatcher(l_interpolate1);

        this.interpolate1 = l_interpolate1;
      }
    }
    changes = null;

    isChanged = false;

    this.alreadyChecked = true;
  }

  void checkNoChanges() {
    runDetectChanges(true);
  }

  void dehydrateDirectives(destroyPipes) {
    this.a0 = this.interpolate1 = _gen.ChangeDetectionUtil.uninitialized;
  }

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector69(a, b, c), def);
  }
}

var _idToProtoMap = {
  '''"\$"''': ChangeDetector0.newProtoChangeDetector,
  '''10''': ChangeDetector1.newProtoChangeDetector,
  '''"str"''': ChangeDetector2.newProtoChangeDetector,
  '''"a

b"''': ChangeDetector3.newProtoChangeDetector,
  '''10 + 2''': ChangeDetector4.newProtoChangeDetector,
  '''10 - 2''': ChangeDetector5.newProtoChangeDetector,
  '''10 * 2''': ChangeDetector6.newProtoChangeDetector,
  '''10 / 2''': ChangeDetector7.newProtoChangeDetector,
  '''11 % 2''': ChangeDetector8.newProtoChangeDetector,
  '''1 == 1''': ChangeDetector9.newProtoChangeDetector,
  '''1 != 1''': ChangeDetector10.newProtoChangeDetector,
  '''1 == true''': ChangeDetector11.newProtoChangeDetector,
  '''1 === 1''': ChangeDetector12.newProtoChangeDetector,
  '''1 !== 1''': ChangeDetector13.newProtoChangeDetector,
  '''1 === true''': ChangeDetector14.newProtoChangeDetector,
  '''1 < 2''': ChangeDetector15.newProtoChangeDetector,
  '''2 < 1''': ChangeDetector16.newProtoChangeDetector,
  '''1 > 2''': ChangeDetector17.newProtoChangeDetector,
  '''2 > 1''': ChangeDetector18.newProtoChangeDetector,
  '''1 <= 2''': ChangeDetector19.newProtoChangeDetector,
  '''2 <= 2''': ChangeDetector20.newProtoChangeDetector,
  '''2 <= 1''': ChangeDetector21.newProtoChangeDetector,
  '''2 >= 1''': ChangeDetector22.newProtoChangeDetector,
  '''2 >= 2''': ChangeDetector23.newProtoChangeDetector,
  '''1 >= 2''': ChangeDetector24.newProtoChangeDetector,
  '''true && true''': ChangeDetector25.newProtoChangeDetector,
  '''true && false''': ChangeDetector26.newProtoChangeDetector,
  '''true || false''': ChangeDetector27.newProtoChangeDetector,
  '''false || false''': ChangeDetector28.newProtoChangeDetector,
  '''!true''': ChangeDetector29.newProtoChangeDetector,
  '''!!true''': ChangeDetector30.newProtoChangeDetector,
  '''1 < 2 ? 1 : 2''': ChangeDetector31.newProtoChangeDetector,
  '''1 > 2 ? 1 : 2''': ChangeDetector32.newProtoChangeDetector,
  '''["foo", "bar"][0]''': ChangeDetector33.newProtoChangeDetector,
  '''{"foo": "bar"}["foo"]''': ChangeDetector34.newProtoChangeDetector,
  '''name''': ChangeDetector35.newProtoChangeDetector,
  '''[1, 2]''': ChangeDetector36.newProtoChangeDetector,
  '''[1, a]''': ChangeDetector37.newProtoChangeDetector,
  '''{z: 1}''': ChangeDetector38.newProtoChangeDetector,
  '''{z: a}''': ChangeDetector39.newProtoChangeDetector,
  '''name | pipe''': ChangeDetector40.newProtoChangeDetector,
  '''(name | pipe).length''': ChangeDetector41.newProtoChangeDetector,
  '''name | pipe:'one':address.city''': ChangeDetector42.newProtoChangeDetector,
  '''value''': ChangeDetector43.newProtoChangeDetector,
  '''a''': ChangeDetector44.newProtoChangeDetector,
  '''address.city''': ChangeDetector45.newProtoChangeDetector,
  '''address?.city''': ChangeDetector46.newProtoChangeDetector,
  '''address?.toString()''': ChangeDetector47.newProtoChangeDetector,
  '''sayHi("Jim")''': ChangeDetector48.newProtoChangeDetector,
  '''a()(99)''': ChangeDetector49.newProtoChangeDetector,
  '''a.sayHi("Jim")''': ChangeDetector50.newProtoChangeDetector,
  '''passThrough([12])''': ChangeDetector51.newProtoChangeDetector,
  '''invalidFn(1)''': ChangeDetector52.newProtoChangeDetector,
  '''valueFromLocals''': ChangeDetector53.newProtoChangeDetector,
  '''functionFromLocals''': ChangeDetector54.newProtoChangeDetector,
  '''nestedLocals''': ChangeDetector55.newProtoChangeDetector,
  '''fallbackLocals''': ChangeDetector56.newProtoChangeDetector,
  '''contextNestedPropertyWithLocals''':
      ChangeDetector57.newProtoChangeDetector,
  '''localPropertyWithSimilarContext''':
      ChangeDetector58.newProtoChangeDetector,
  '''emptyUsingDefaultStrategy''': ChangeDetector59.newProtoChangeDetector,
  '''emptyUsingOnPushStrategy''': ChangeDetector60.newProtoChangeDetector,
  '''onPushRecordsUsingDefaultStrategy''':
      ChangeDetector61.newProtoChangeDetector,
  '''directNoDispatcher''': ChangeDetector62.newProtoChangeDetector,
  '''groupChanges''': ChangeDetector63.newProtoChangeDetector,
  '''directiveOnCheck''': ChangeDetector64.newProtoChangeDetector,
  '''directiveOnInit''': ChangeDetector65.newProtoChangeDetector,
  '''emptyWithDirectiveRecords''': ChangeDetector66.newProtoChangeDetector,
  '''noCallbacks''': ChangeDetector67.newProtoChangeDetector,
  '''readingDirectives''': ChangeDetector68.newProtoChangeDetector,
  '''interpolation''': ChangeDetector69.newProtoChangeDetector
};

getFactoryById(String id) => _idToProtoMap[id];

