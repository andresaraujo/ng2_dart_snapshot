library dart_gen_change_detectors;

import 'package:angular2/src/change_detection/pregen_proto_change_detector.dart'
    as _gen;

class ChangeDetector0 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector0(this._dispatcher, this._protos, this._directiveRecords)
      : super("10");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var change_context = false;
    var change_literal0 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 10;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(currentProto,
            _gen.ChangeDetectionUtil.simpleChange(_literal0, literal0));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, literal0);

      _literal0 = literal0;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector0(a, b, c), def);
  }
}

class ChangeDetector1 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector1(this._dispatcher, this._protos, this._directiveRecords)
      : super("\"str\"");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var change_context = false;
    var change_literal0 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = "str";
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(currentProto,
            _gen.ChangeDetectionUtil.simpleChange(_literal0, literal0));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, literal0);

      _literal0 = literal0;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector1(a, b, c), def);
  }
}

class ChangeDetector2 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector2(this._dispatcher, this._protos, this._directiveRecords)
      : super("\"a\n\nb\"");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var change_context = false;
    var change_literal0 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = "a\n\nb";
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(currentProto,
            _gen.ChangeDetectionUtil.simpleChange(_literal0, literal0));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, literal0);

      _literal0 = literal0;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector2(a, b, c), def);
  }
}

class ChangeDetector3 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_add2 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector3(this._dispatcher, this._protos, this._directiveRecords)
      : super("10 + 2");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var operation_add2 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_operation_add2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 10;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = 2;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      operation_add2 =
          _gen.ChangeDetectionUtil.operation_add(literal0, literal1);
      if (!_gen.looseIdentical(operation_add2, _operation_add2)) {
        change_operation_add2 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_add2, operation_add2));
        }

        _dispatcher.notifyOnBinding(currentProto.bindingRecord, operation_add2);

        _operation_add2 = operation_add2;
      }
    } else {
      operation_add2 = _operation_add2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_add2 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector3(a, b, c), def);
  }
}

class ChangeDetector4 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_subtract2 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector4(this._dispatcher, this._protos, this._directiveRecords)
      : super("10 - 2");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var operation_subtract2 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_operation_subtract2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 10;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = 2;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      operation_subtract2 =
          _gen.ChangeDetectionUtil.operation_subtract(literal0, literal1);
      if (!_gen.looseIdentical(operation_subtract2, _operation_subtract2)) {
        change_operation_subtract2 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_subtract2, operation_subtract2));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_subtract2);

        _operation_subtract2 = operation_subtract2;
      }
    } else {
      operation_subtract2 = _operation_subtract2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_subtract2 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector4(a, b, c), def);
  }
}

class ChangeDetector5 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_multiply2 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector5(this._dispatcher, this._protos, this._directiveRecords)
      : super("10 * 2");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var operation_multiply2 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_operation_multiply2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 10;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = 2;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      operation_multiply2 =
          _gen.ChangeDetectionUtil.operation_multiply(literal0, literal1);
      if (!_gen.looseIdentical(operation_multiply2, _operation_multiply2)) {
        change_operation_multiply2 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_multiply2, operation_multiply2));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_multiply2);

        _operation_multiply2 = operation_multiply2;
      }
    } else {
      operation_multiply2 = _operation_multiply2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_multiply2 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector5(a, b, c), def);
  }
}

class ChangeDetector6 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_divide2 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector6(this._dispatcher, this._protos, this._directiveRecords)
      : super("10 / 2");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var operation_divide2 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_operation_divide2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 10;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = 2;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      operation_divide2 =
          _gen.ChangeDetectionUtil.operation_divide(literal0, literal1);
      if (!_gen.looseIdentical(operation_divide2, _operation_divide2)) {
        change_operation_divide2 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_divide2, operation_divide2));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_divide2);

        _operation_divide2 = operation_divide2;
      }
    } else {
      operation_divide2 = _operation_divide2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_divide2 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector6(a, b, c), def);
  }
}

class ChangeDetector7 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_remainder2 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector7(this._dispatcher, this._protos, this._directiveRecords)
      : super("11 % 2");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var operation_remainder2 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_operation_remainder2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 11;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = 2;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      operation_remainder2 =
          _gen.ChangeDetectionUtil.operation_remainder(literal0, literal1);
      if (!_gen.looseIdentical(operation_remainder2, _operation_remainder2)) {
        change_operation_remainder2 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_remainder2, operation_remainder2));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_remainder2);

        _operation_remainder2 = operation_remainder2;
      }
    } else {
      operation_remainder2 = _operation_remainder2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_remainder2 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector7(a, b, c), def);
  }
}

class ChangeDetector8 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_equals1 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector8(this._dispatcher, this._protos, this._directiveRecords)
      : super("1 == 1");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var operation_equals1 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_operation_equals1 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 1;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    if (change_literal0 || change_literal0) {
      currentProto = _protos[1];
      operation_equals1 =
          _gen.ChangeDetectionUtil.operation_equals(literal0, literal0);
      if (!_gen.looseIdentical(operation_equals1, _operation_equals1)) {
        change_operation_equals1 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_equals1, operation_equals1));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_equals1);

        _operation_equals1 = operation_equals1;
      }
    } else {
      operation_equals1 = _operation_equals1;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_equals1 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector8(a, b, c), def);
  }
}

class ChangeDetector9 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_not_equals1 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector9(this._dispatcher, this._protos, this._directiveRecords)
      : super("1 != 1");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var operation_not_equals1 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_operation_not_equals1 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 1;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    if (change_literal0 || change_literal0) {
      currentProto = _protos[1];
      operation_not_equals1 =
          _gen.ChangeDetectionUtil.operation_not_equals(literal0, literal0);
      if (!_gen.looseIdentical(operation_not_equals1, _operation_not_equals1)) {
        change_operation_not_equals1 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_not_equals1, operation_not_equals1));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_not_equals1);

        _operation_not_equals1 = operation_not_equals1;
      }
    } else {
      operation_not_equals1 = _operation_not_equals1;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_not_equals1 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector9(a, b, c), def);
  }
}

class ChangeDetector10 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_equals2 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector10(this._dispatcher, this._protos, this._directiveRecords)
      : super("1 == true");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var operation_equals2 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_operation_equals2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 1;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = true;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      operation_equals2 =
          _gen.ChangeDetectionUtil.operation_equals(literal0, literal1);
      if (!_gen.looseIdentical(operation_equals2, _operation_equals2)) {
        change_operation_equals2 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_equals2, operation_equals2));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_equals2);

        _operation_equals2 = operation_equals2;
      }
    } else {
      operation_equals2 = _operation_equals2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_equals2 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector10(a, b, c), def);
  }
}

class ChangeDetector11 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_identical1 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector11(this._dispatcher, this._protos, this._directiveRecords)
      : super("1 === 1");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var operation_identical1 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_operation_identical1 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 1;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    if (change_literal0 || change_literal0) {
      currentProto = _protos[1];
      operation_identical1 =
          _gen.ChangeDetectionUtil.operation_identical(literal0, literal0);
      if (!_gen.looseIdentical(operation_identical1, _operation_identical1)) {
        change_operation_identical1 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_identical1, operation_identical1));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_identical1);

        _operation_identical1 = operation_identical1;
      }
    } else {
      operation_identical1 = _operation_identical1;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_identical1 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector11(a, b, c), def);
  }
}

class ChangeDetector12 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_not_identical1 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector12(this._dispatcher, this._protos, this._directiveRecords)
      : super("1 !== 1");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var operation_not_identical1 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_operation_not_identical1 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 1;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    if (change_literal0 || change_literal0) {
      currentProto = _protos[1];
      operation_not_identical1 =
          _gen.ChangeDetectionUtil.operation_not_identical(literal0, literal0);
      if (!_gen.looseIdentical(
          operation_not_identical1, _operation_not_identical1)) {
        change_operation_not_identical1 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_not_identical1, operation_not_identical1));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_not_identical1);

        _operation_not_identical1 = operation_not_identical1;
      }
    } else {
      operation_not_identical1 = _operation_not_identical1;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_not_identical1 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector12(a, b, c), def);
  }
}

class ChangeDetector13 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_identical2 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector13(this._dispatcher, this._protos, this._directiveRecords)
      : super("1 === true");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var operation_identical2 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_operation_identical2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 1;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = true;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      operation_identical2 =
          _gen.ChangeDetectionUtil.operation_identical(literal0, literal1);
      if (!_gen.looseIdentical(operation_identical2, _operation_identical2)) {
        change_operation_identical2 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_identical2, operation_identical2));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_identical2);

        _operation_identical2 = operation_identical2;
      }
    } else {
      operation_identical2 = _operation_identical2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_identical2 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector13(a, b, c), def);
  }
}

class ChangeDetector14 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_less_then2 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector14(this._dispatcher, this._protos, this._directiveRecords)
      : super("1 < 2");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var operation_less_then2 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_operation_less_then2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 1;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = 2;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      operation_less_then2 =
          _gen.ChangeDetectionUtil.operation_less_then(literal0, literal1);
      if (!_gen.looseIdentical(operation_less_then2, _operation_less_then2)) {
        change_operation_less_then2 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_less_then2, operation_less_then2));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_less_then2);

        _operation_less_then2 = operation_less_then2;
      }
    } else {
      operation_less_then2 = _operation_less_then2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_less_then2 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector14(a, b, c), def);
  }
}

class ChangeDetector15 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_less_then2 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector15(this._dispatcher, this._protos, this._directiveRecords)
      : super("2 < 1");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var operation_less_then2 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_operation_less_then2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 2;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = 1;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      operation_less_then2 =
          _gen.ChangeDetectionUtil.operation_less_then(literal0, literal1);
      if (!_gen.looseIdentical(operation_less_then2, _operation_less_then2)) {
        change_operation_less_then2 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_less_then2, operation_less_then2));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_less_then2);

        _operation_less_then2 = operation_less_then2;
      }
    } else {
      operation_less_then2 = _operation_less_then2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_less_then2 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector15(a, b, c), def);
  }
}

class ChangeDetector16 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_greater_then2 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector16(this._dispatcher, this._protos, this._directiveRecords)
      : super("1 > 2");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var operation_greater_then2 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_operation_greater_then2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 1;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = 2;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      operation_greater_then2 =
          _gen.ChangeDetectionUtil.operation_greater_then(literal0, literal1);
      if (!_gen.looseIdentical(
          operation_greater_then2, _operation_greater_then2)) {
        change_operation_greater_then2 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_greater_then2, operation_greater_then2));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_greater_then2);

        _operation_greater_then2 = operation_greater_then2;
      }
    } else {
      operation_greater_then2 = _operation_greater_then2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_greater_then2 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector16(a, b, c), def);
  }
}

class ChangeDetector17 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_greater_then2 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector17(this._dispatcher, this._protos, this._directiveRecords)
      : super("2 > 1");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var operation_greater_then2 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_operation_greater_then2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 2;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = 1;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      operation_greater_then2 =
          _gen.ChangeDetectionUtil.operation_greater_then(literal0, literal1);
      if (!_gen.looseIdentical(
          operation_greater_then2, _operation_greater_then2)) {
        change_operation_greater_then2 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_greater_then2, operation_greater_then2));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_greater_then2);

        _operation_greater_then2 = operation_greater_then2;
      }
    } else {
      operation_greater_then2 = _operation_greater_then2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_greater_then2 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector17(a, b, c), def);
  }
}

class ChangeDetector18 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_less_or_equals_then2 =
      _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector18(this._dispatcher, this._protos, this._directiveRecords)
      : super("1 <= 2");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var operation_less_or_equals_then2 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_operation_less_or_equals_then2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 1;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = 2;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      operation_less_or_equals_then2 = _gen.ChangeDetectionUtil
          .operation_less_or_equals_then(literal0, literal1);
      if (!_gen.looseIdentical(
          operation_less_or_equals_then2, _operation_less_or_equals_then2)) {
        change_operation_less_or_equals_then2 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_less_or_equals_then2,
                  operation_less_or_equals_then2));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_less_or_equals_then2);

        _operation_less_or_equals_then2 = operation_less_or_equals_then2;
      }
    } else {
      operation_less_or_equals_then2 = _operation_less_or_equals_then2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_less_or_equals_then2 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector18(a, b, c), def);
  }
}

class ChangeDetector19 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_less_or_equals_then1 =
      _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector19(this._dispatcher, this._protos, this._directiveRecords)
      : super("2 <= 2");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var operation_less_or_equals_then1 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_operation_less_or_equals_then1 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 2;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    if (change_literal0 || change_literal0) {
      currentProto = _protos[1];
      operation_less_or_equals_then1 = _gen.ChangeDetectionUtil
          .operation_less_or_equals_then(literal0, literal0);
      if (!_gen.looseIdentical(
          operation_less_or_equals_then1, _operation_less_or_equals_then1)) {
        change_operation_less_or_equals_then1 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_less_or_equals_then1,
                  operation_less_or_equals_then1));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_less_or_equals_then1);

        _operation_less_or_equals_then1 = operation_less_or_equals_then1;
      }
    } else {
      operation_less_or_equals_then1 = _operation_less_or_equals_then1;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_less_or_equals_then1 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector19(a, b, c), def);
  }
}

class ChangeDetector20 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_less_or_equals_then2 =
      _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector20(this._dispatcher, this._protos, this._directiveRecords)
      : super("2 <= 1");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var operation_less_or_equals_then2 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_operation_less_or_equals_then2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 2;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = 1;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      operation_less_or_equals_then2 = _gen.ChangeDetectionUtil
          .operation_less_or_equals_then(literal0, literal1);
      if (!_gen.looseIdentical(
          operation_less_or_equals_then2, _operation_less_or_equals_then2)) {
        change_operation_less_or_equals_then2 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_less_or_equals_then2,
                  operation_less_or_equals_then2));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_less_or_equals_then2);

        _operation_less_or_equals_then2 = operation_less_or_equals_then2;
      }
    } else {
      operation_less_or_equals_then2 = _operation_less_or_equals_then2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_less_or_equals_then2 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector20(a, b, c), def);
  }
}

class ChangeDetector21 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_greater_or_equals_then2 =
      _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector21(this._dispatcher, this._protos, this._directiveRecords)
      : super("2 >= 1");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var operation_greater_or_equals_then2 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_operation_greater_or_equals_then2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 2;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = 1;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      operation_greater_or_equals_then2 = _gen.ChangeDetectionUtil
          .operation_greater_or_equals_then(literal0, literal1);
      if (!_gen.looseIdentical(operation_greater_or_equals_then2,
          _operation_greater_or_equals_then2)) {
        change_operation_greater_or_equals_then2 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_greater_or_equals_then2,
                  operation_greater_or_equals_then2));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_greater_or_equals_then2);

        _operation_greater_or_equals_then2 = operation_greater_or_equals_then2;
      }
    } else {
      operation_greater_or_equals_then2 = _operation_greater_or_equals_then2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_greater_or_equals_then2 =
        _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector21(a, b, c), def);
  }
}

class ChangeDetector22 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_greater_or_equals_then1 =
      _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector22(this._dispatcher, this._protos, this._directiveRecords)
      : super("2 >= 2");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var operation_greater_or_equals_then1 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_operation_greater_or_equals_then1 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 2;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    if (change_literal0 || change_literal0) {
      currentProto = _protos[1];
      operation_greater_or_equals_then1 = _gen.ChangeDetectionUtil
          .operation_greater_or_equals_then(literal0, literal0);
      if (!_gen.looseIdentical(operation_greater_or_equals_then1,
          _operation_greater_or_equals_then1)) {
        change_operation_greater_or_equals_then1 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_greater_or_equals_then1,
                  operation_greater_or_equals_then1));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_greater_or_equals_then1);

        _operation_greater_or_equals_then1 = operation_greater_or_equals_then1;
      }
    } else {
      operation_greater_or_equals_then1 = _operation_greater_or_equals_then1;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_greater_or_equals_then1 =
        _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector22(a, b, c), def);
  }
}

class ChangeDetector23 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_greater_or_equals_then2 =
      _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector23(this._dispatcher, this._protos, this._directiveRecords)
      : super("1 >= 2");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var operation_greater_or_equals_then2 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_operation_greater_or_equals_then2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 1;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = 2;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      operation_greater_or_equals_then2 = _gen.ChangeDetectionUtil
          .operation_greater_or_equals_then(literal0, literal1);
      if (!_gen.looseIdentical(operation_greater_or_equals_then2,
          _operation_greater_or_equals_then2)) {
        change_operation_greater_or_equals_then2 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_greater_or_equals_then2,
                  operation_greater_or_equals_then2));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_greater_or_equals_then2);

        _operation_greater_or_equals_then2 = operation_greater_or_equals_then2;
      }
    } else {
      operation_greater_or_equals_then2 = _operation_greater_or_equals_then2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_greater_or_equals_then2 =
        _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector23(a, b, c), def);
  }
}

class ChangeDetector24 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_logical_and1 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector24(this._dispatcher, this._protos, this._directiveRecords)
      : super("true && true");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var operation_logical_and1 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_operation_logical_and1 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = true;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    if (change_literal0 || change_literal0) {
      currentProto = _protos[1];
      operation_logical_and1 =
          _gen.ChangeDetectionUtil.operation_logical_and(literal0, literal0);
      if (!_gen.looseIdentical(
          operation_logical_and1, _operation_logical_and1)) {
        change_operation_logical_and1 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_logical_and1, operation_logical_and1));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_logical_and1);

        _operation_logical_and1 = operation_logical_and1;
      }
    } else {
      operation_logical_and1 = _operation_logical_and1;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_logical_and1 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector24(a, b, c), def);
  }
}

class ChangeDetector25 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_logical_and2 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector25(this._dispatcher, this._protos, this._directiveRecords)
      : super("true && false");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var operation_logical_and2 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_operation_logical_and2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = true;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = false;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      operation_logical_and2 =
          _gen.ChangeDetectionUtil.operation_logical_and(literal0, literal1);
      if (!_gen.looseIdentical(
          operation_logical_and2, _operation_logical_and2)) {
        change_operation_logical_and2 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_logical_and2, operation_logical_and2));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_logical_and2);

        _operation_logical_and2 = operation_logical_and2;
      }
    } else {
      operation_logical_and2 = _operation_logical_and2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_logical_and2 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector25(a, b, c), def);
  }
}

class ChangeDetector26 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_logical_or2 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector26(this._dispatcher, this._protos, this._directiveRecords)
      : super("true || false");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var operation_logical_or2 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_operation_logical_or2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = true;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = false;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      operation_logical_or2 =
          _gen.ChangeDetectionUtil.operation_logical_or(literal0, literal1);
      if (!_gen.looseIdentical(operation_logical_or2, _operation_logical_or2)) {
        change_operation_logical_or2 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_logical_or2, operation_logical_or2));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_logical_or2);

        _operation_logical_or2 = operation_logical_or2;
      }
    } else {
      operation_logical_or2 = _operation_logical_or2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_logical_or2 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector26(a, b, c), def);
  }
}

class ChangeDetector27 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_logical_or1 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector27(this._dispatcher, this._protos, this._directiveRecords)
      : super("false || false");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var operation_logical_or1 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_operation_logical_or1 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = false;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    if (change_literal0 || change_literal0) {
      currentProto = _protos[1];
      operation_logical_or1 =
          _gen.ChangeDetectionUtil.operation_logical_or(literal0, literal0);
      if (!_gen.looseIdentical(operation_logical_or1, _operation_logical_or1)) {
        change_operation_logical_or1 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_logical_or1, operation_logical_or1));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_logical_or1);

        _operation_logical_or1 = operation_logical_or1;
      }
    } else {
      operation_logical_or1 = _operation_logical_or1;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_logical_or1 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector27(a, b, c), def);
  }
}

class ChangeDetector28 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_negate1 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector28(this._dispatcher, this._protos, this._directiveRecords)
      : super("!true");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var operation_negate1 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_operation_negate1 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = true;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    if (change_literal0) {
      currentProto = _protos[1];
      operation_negate1 = _gen.ChangeDetectionUtil.operation_negate(literal0);
      if (!_gen.looseIdentical(operation_negate1, _operation_negate1)) {
        change_operation_negate1 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_negate1, operation_negate1));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_negate1);

        _operation_negate1 = operation_negate1;
      }
    } else {
      operation_negate1 = _operation_negate1;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_negate1 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector28(a, b, c), def);
  }
}

class ChangeDetector29 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_negate1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_negate2 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector29(this._dispatcher, this._protos, this._directiveRecords)
      : super("!!true");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var operation_negate1 = null;
    var operation_negate2 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_operation_negate1 = false;
    var change_operation_negate2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = true;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    if (change_literal0) {
      currentProto = _protos[1];
      operation_negate1 = _gen.ChangeDetectionUtil.operation_negate(literal0);
      if (!_gen.looseIdentical(operation_negate1, _operation_negate1)) {
        change_operation_negate1 = true;

        _operation_negate1 = operation_negate1;
      }
    } else {
      operation_negate1 = _operation_negate1;
    }
    if (change_operation_negate1) {
      currentProto = _protos[2];
      operation_negate2 =
          _gen.ChangeDetectionUtil.operation_negate(operation_negate1);
      if (!_gen.looseIdentical(operation_negate2, _operation_negate2)) {
        change_operation_negate2 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _operation_negate2, operation_negate2));
        }

        _dispatcher.notifyOnBinding(
            currentProto.bindingRecord, operation_negate2);

        _operation_negate2 = operation_negate2;
      }
    } else {
      operation_negate2 = _operation_negate2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_negate1 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_negate2 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector29(a, b, c), def);
  }
}

class ChangeDetector30 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_less_then2 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _cond3 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector30(this._dispatcher, this._protos, this._directiveRecords)
      : super("1 < 2 ? 1 : 2");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var operation_less_then2 = null;
    var cond3 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_operation_less_then2 = false;
    var change_cond3 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 1;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = 2;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      operation_less_then2 =
          _gen.ChangeDetectionUtil.operation_less_then(literal0, literal1);
      if (!_gen.looseIdentical(operation_less_then2, _operation_less_then2)) {
        change_operation_less_then2 = true;

        _operation_less_then2 = operation_less_then2;
      }
    } else {
      operation_less_then2 = _operation_less_then2;
    }
    if (change_operation_less_then2 || change_literal0 || change_literal1) {
      currentProto = _protos[3];
      cond3 = _gen.ChangeDetectionUtil.cond(
          operation_less_then2, literal0, literal1);
      if (!_gen.looseIdentical(cond3, _cond3)) {
        change_cond3 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(_cond3, cond3));
        }

        _dispatcher.notifyOnBinding(currentProto.bindingRecord, cond3);

        _cond3 = cond3;
      }
    } else {
      cond3 = _cond3;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_less_then2 = _gen.ChangeDetectionUtil.uninitialized();
    _cond3 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector30(a, b, c), def);
  }
}

class ChangeDetector31 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _operation_greater_then2 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _cond3 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector31(this._dispatcher, this._protos, this._directiveRecords)
      : super("1 > 2 ? 1 : 2");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var operation_greater_then2 = null;
    var cond3 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_operation_greater_then2 = false;
    var change_cond3 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 1;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = 2;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      operation_greater_then2 =
          _gen.ChangeDetectionUtil.operation_greater_then(literal0, literal1);
      if (!_gen.looseIdentical(
          operation_greater_then2, _operation_greater_then2)) {
        change_operation_greater_then2 = true;

        _operation_greater_then2 = operation_greater_then2;
      }
    } else {
      operation_greater_then2 = _operation_greater_then2;
    }
    if (change_operation_greater_then2 || change_literal0 || change_literal1) {
      currentProto = _protos[3];
      cond3 = _gen.ChangeDetectionUtil.cond(
          operation_greater_then2, literal0, literal1);
      if (!_gen.looseIdentical(cond3, _cond3)) {
        change_cond3 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(_cond3, cond3));
        }

        _dispatcher.notifyOnBinding(currentProto.bindingRecord, cond3);

        _cond3 = cond3;
      }
    } else {
      cond3 = _cond3;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _operation_greater_then2 = _gen.ChangeDetectionUtil.uninitialized();
    _cond3 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector31(a, b, c), def);
  }
}

class ChangeDetector32 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _arrayFn22 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal3 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _keyedAccess4 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector32(this._dispatcher, this._protos, this._directiveRecords)
      : super("[\"foo\", \"bar\"][0]");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var arrayFn22 = null;
    var literal3 = null;
    var keyedAccess4 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_arrayFn22 = false;
    var change_literal3 = false;
    var change_keyedAccess4 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = "foo";
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = "bar";
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      arrayFn22 = _gen.ChangeDetectionUtil.arrayFn2(literal0, literal1);
      if (!_gen.looseIdentical(arrayFn22, _arrayFn22)) {
        change_arrayFn22 = true;

        _arrayFn22 = arrayFn22;
      }
    } else {
      arrayFn22 = _arrayFn22;
    }
    currentProto = _protos[3];
    literal3 = 0;
    if (!_gen.looseIdentical(literal3, _literal3)) {
      change_literal3 = true;

      _literal3 = literal3;
    }
    currentProto = _protos[4];
    keyedAccess4 = arrayFn22[literal3];
    if (!_gen.looseIdentical(keyedAccess4, _keyedAccess4)) {
      change_keyedAccess4 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(currentProto,
            _gen.ChangeDetectionUtil.simpleChange(_keyedAccess4, keyedAccess4));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, keyedAccess4);

      _keyedAccess4 = keyedAccess4;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _arrayFn22 = _gen.ChangeDetectionUtil.uninitialized();
    _literal3 = _gen.ChangeDetectionUtil.uninitialized();
    _keyedAccess4 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector32(a, b, c), def);
  }
}

class ChangeDetector33 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _mapFnfoo1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal2 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _keyedAccess3 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector33(this._dispatcher, this._protos, this._directiveRecords)
      : super("{\"foo\": \"bar\"}[\"foo\"]");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var mapFnfoo1 = null;
    var literal2 = null;
    var keyedAccess3 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_mapFnfoo1 = false;
    var change_literal2 = false;
    var change_keyedAccess3 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = "bar";
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    if (change_literal0) {
      currentProto = _protos[1];
      mapFnfoo1 = _gen.ChangeDetectionUtil.mapFn(["foo"])(literal0);
      if (!_gen.looseIdentical(mapFnfoo1, _mapFnfoo1)) {
        change_mapFnfoo1 = true;

        _mapFnfoo1 = mapFnfoo1;
      }
    } else {
      mapFnfoo1 = _mapFnfoo1;
    }
    currentProto = _protos[2];
    literal2 = "foo";
    if (!_gen.looseIdentical(literal2, _literal2)) {
      change_literal2 = true;

      _literal2 = literal2;
    }
    currentProto = _protos[3];
    keyedAccess3 = mapFnfoo1[literal2];
    if (!_gen.looseIdentical(keyedAccess3, _keyedAccess3)) {
      change_keyedAccess3 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(currentProto,
            _gen.ChangeDetectionUtil.simpleChange(_keyedAccess3, keyedAccess3));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, keyedAccess3);

      _keyedAccess3 = keyedAccess3;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _mapFnfoo1 = _gen.ChangeDetectionUtil.uninitialized();
    _literal2 = _gen.ChangeDetectionUtil.uninitialized();
    _keyedAccess3 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector33(a, b, c), def);
  }
}

class ChangeDetector34 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _name0 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector34(this._dispatcher, this._protos, this._directiveRecords)
      : super("name");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var name0 = null;
    var change_context = false;
    var change_name0 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    name0 = context.name;
    if (!_gen.looseIdentical(name0, _name0)) {
      change_name0 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(
            currentProto, _gen.ChangeDetectionUtil.simpleChange(_name0, name0));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, name0);

      _name0 = name0;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _name0 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector34(a, b, c), def);
  }
}

class ChangeDetector35 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _arrayFn22 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector35(this._dispatcher, this._protos, this._directiveRecords)
      : super("[1, 2]");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var arrayFn22 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_arrayFn22 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 1;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = 2;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    if (change_literal0 || change_literal1) {
      currentProto = _protos[2];
      arrayFn22 = _gen.ChangeDetectionUtil.arrayFn2(literal0, literal1);
      if (!_gen.looseIdentical(arrayFn22, _arrayFn22)) {
        change_arrayFn22 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(_arrayFn22, arrayFn22));
        }

        _dispatcher.notifyOnBinding(currentProto.bindingRecord, arrayFn22);

        _arrayFn22 = arrayFn22;
      }
    } else {
      arrayFn22 = _arrayFn22;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _arrayFn22 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector35(a, b, c), def);
  }
}

class ChangeDetector36 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _a1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _arrayFn22 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector36(this._dispatcher, this._protos, this._directiveRecords)
      : super("[1, a]");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var a1 = null;
    var arrayFn22 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_a1 = false;
    var change_arrayFn22 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 1;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    a1 = context.a;
    if (!_gen.looseIdentical(a1, _a1)) {
      change_a1 = true;

      _a1 = a1;
    }
    if (change_literal0 || change_a1) {
      currentProto = _protos[2];
      arrayFn22 = _gen.ChangeDetectionUtil.arrayFn2(literal0, a1);
      if (!_gen.looseIdentical(arrayFn22, _arrayFn22)) {
        change_arrayFn22 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(_arrayFn22, arrayFn22));
        }

        _dispatcher.notifyOnBinding(currentProto.bindingRecord, arrayFn22);

        _arrayFn22 = arrayFn22;
      }
    } else {
      arrayFn22 = _arrayFn22;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _a1 = _gen.ChangeDetectionUtil.uninitialized();
    _arrayFn22 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector36(a, b, c), def);
  }
}

class ChangeDetector37 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _mapFnz1 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector37(this._dispatcher, this._protos, this._directiveRecords)
      : super("{z: 1}");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var mapFnz1 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_mapFnz1 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 1;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    if (change_literal0) {
      currentProto = _protos[1];
      mapFnz1 = _gen.ChangeDetectionUtil.mapFn(["z"])(literal0);
      if (!_gen.looseIdentical(mapFnz1, _mapFnz1)) {
        change_mapFnz1 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(_mapFnz1, mapFnz1));
        }

        _dispatcher.notifyOnBinding(currentProto.bindingRecord, mapFnz1);

        _mapFnz1 = mapFnz1;
      }
    } else {
      mapFnz1 = _mapFnz1;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _mapFnz1 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector37(a, b, c), def);
  }
}

class ChangeDetector38 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _a0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _mapFnz1 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector38(this._dispatcher, this._protos, this._directiveRecords)
      : super("{z: a}");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var a0 = null;
    var mapFnz1 = null;
    var change_context = false;
    var change_a0 = false;
    var change_mapFnz1 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    a0 = context.a;
    if (!_gen.looseIdentical(a0, _a0)) {
      change_a0 = true;

      _a0 = a0;
    }
    if (change_a0) {
      currentProto = _protos[1];
      mapFnz1 = _gen.ChangeDetectionUtil.mapFn(["z"])(a0);
      if (!_gen.looseIdentical(mapFnz1, _mapFnz1)) {
        change_mapFnz1 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(_mapFnz1, mapFnz1));
        }

        _dispatcher.notifyOnBinding(currentProto.bindingRecord, mapFnz1);

        _mapFnz1 = mapFnz1;
      }
    } else {
      mapFnz1 = _mapFnz1;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _a0 = _gen.ChangeDetectionUtil.uninitialized();
    _mapFnz1 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector38(a, b, c), def);
  }
}

class ChangeDetector39 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _name0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _pipe1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _pipe1_pipe = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector39(this._dispatcher, this._protos, this._directiveRecords)
      : super("name | pipe");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var name0 = null;
    var pipe1 = null;
    var change_context = false;
    var change_name0 = false;
    var change_pipe1 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    name0 = context.name;
    if (!_gen.looseIdentical(name0, _name0)) {
      change_name0 = true;

      _name0 = name0;
    }
    currentProto = _protos[1];
    if (_gen.looseIdentical(
        _pipe1_pipe, _gen.ChangeDetectionUtil.uninitialized())) {
      _pipe1_pipe = _pipes.get('pipe', name0, this.ref);
    } else if (!_pipe1_pipe.supports(name0)) {
      _pipe1_pipe.onDestroy();
      _pipe1_pipe = _pipes.get('pipe', name0, this.ref);
    }

    pipe1 = _pipe1_pipe.transform(name0, []);
    if (!_gen.looseIdentical(_pipe1, pipe1)) {
      pipe1 = _gen.ChangeDetectionUtil.unwrapValue(pipe1);
      change_pipe1 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(
            currentProto, _gen.ChangeDetectionUtil.simpleChange(_pipe1, pipe1));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, pipe1);

      _pipe1 = pipe1;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _pipe1_pipe.onDestroy();
    _context = null;
    _name0 = _gen.ChangeDetectionUtil.uninitialized();
    _pipe1 = _gen.ChangeDetectionUtil.uninitialized();
    _pipe1_pipe = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector39(a, b, c), def);
  }
}

class ChangeDetector40 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _name0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _address2 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _city3 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _pipe4 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _pipe4_pipe = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector40(this._dispatcher, this._protos, this._directiveRecords)
      : super("name | pipe:'one':address.city");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var name0 = null;
    var literal1 = null;
    var address2 = null;
    var city3 = null;
    var pipe4 = null;
    var change_context = false;
    var change_name0 = false;
    var change_literal1 = false;
    var change_address2 = false;
    var change_city3 = false;
    var change_pipe4 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    name0 = context.name;
    if (!_gen.looseIdentical(name0, _name0)) {
      change_name0 = true;

      _name0 = name0;
    }
    currentProto = _protos[1];
    literal1 = "one";
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    currentProto = _protos[2];
    address2 = context.address;
    if (!_gen.looseIdentical(address2, _address2)) {
      change_address2 = true;

      _address2 = address2;
    }
    currentProto = _protos[3];
    city3 = address2.city;
    if (!_gen.looseIdentical(city3, _city3)) {
      change_city3 = true;

      _city3 = city3;
    }
    currentProto = _protos[4];
    if (_gen.looseIdentical(
        _pipe4_pipe, _gen.ChangeDetectionUtil.uninitialized())) {
      _pipe4_pipe = _pipes.get('pipe', name0, this.ref);
    } else if (!_pipe4_pipe.supports(name0)) {
      _pipe4_pipe.onDestroy();
      _pipe4_pipe = _pipes.get('pipe', name0, this.ref);
    }

    pipe4 = _pipe4_pipe.transform(name0, [literal1, city3]);
    if (!_gen.looseIdentical(_pipe4, pipe4)) {
      pipe4 = _gen.ChangeDetectionUtil.unwrapValue(pipe4);
      change_pipe4 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(
            currentProto, _gen.ChangeDetectionUtil.simpleChange(_pipe4, pipe4));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, pipe4);

      _pipe4 = pipe4;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _pipe4_pipe.onDestroy();
    _context = null;
    _name0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _address2 = _gen.ChangeDetectionUtil.uninitialized();
    _city3 = _gen.ChangeDetectionUtil.uninitialized();
    _pipe4 = _gen.ChangeDetectionUtil.uninitialized();
    _pipe4_pipe = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector40(a, b, c), def);
  }
}

class ChangeDetector41 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _value0 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector41(this._dispatcher, this._protos, this._directiveRecords)
      : super("value");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var value0 = null;
    var change_context = false;
    var change_value0 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    value0 = context.value;
    if (!_gen.looseIdentical(value0, _value0)) {
      change_value0 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(currentProto,
            _gen.ChangeDetectionUtil.simpleChange(_value0, value0));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, value0);

      _value0 = value0;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _value0 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector41(a, b, c), def);
  }
}

class ChangeDetector42 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _a0 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector42(this._dispatcher, this._protos, this._directiveRecords)
      : super("a");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var a0 = null;
    var change_context = false;
    var change_a0 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    a0 = context.a;
    if (!_gen.looseIdentical(a0, _a0)) {
      change_a0 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(
            currentProto, _gen.ChangeDetectionUtil.simpleChange(_a0, a0));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, a0);

      _a0 = a0;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _a0 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector42(a, b, c), def);
  }
}

class ChangeDetector43 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _address0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _city1 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector43(this._dispatcher, this._protos, this._directiveRecords)
      : super("address.city");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var address0 = null;
    var city1 = null;
    var change_context = false;
    var change_address0 = false;
    var change_city1 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    address0 = context.address;
    if (!_gen.looseIdentical(address0, _address0)) {
      change_address0 = true;

      _address0 = address0;
    }
    currentProto = _protos[1];
    city1 = address0.city;
    if (!_gen.looseIdentical(city1, _city1)) {
      change_city1 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(
            currentProto, _gen.ChangeDetectionUtil.simpleChange(_city1, city1));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, city1);

      _city1 = city1;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _address0 = _gen.ChangeDetectionUtil.uninitialized();
    _city1 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector43(a, b, c), def);
  }
}

class ChangeDetector44 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _address0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _city1 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector44(this._dispatcher, this._protos, this._directiveRecords)
      : super("address?.city");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var address0 = null;
    var city1 = null;
    var change_context = false;
    var change_address0 = false;
    var change_city1 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    address0 = context.address;
    if (!_gen.looseIdentical(address0, _address0)) {
      change_address0 = true;

      _address0 = address0;
    }
    currentProto = _protos[1];
    city1 =
        _gen.ChangeDetectionUtil.isValueBlank(address0) ? null : address0.city;
    if (!_gen.looseIdentical(city1, _city1)) {
      change_city1 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(
            currentProto, _gen.ChangeDetectionUtil.simpleChange(_city1, city1));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, city1);

      _city1 = city1;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _address0 = _gen.ChangeDetectionUtil.uninitialized();
    _city1 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector44(a, b, c), def);
  }
}

class ChangeDetector45 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _address0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _toString1 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector45(this._dispatcher, this._protos, this._directiveRecords)
      : super("address?.toString()");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var address0 = null;
    var toString1 = null;
    var change_context = false;
    var change_address0 = false;
    var change_toString1 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    address0 = context.address;
    if (!_gen.looseIdentical(address0, _address0)) {
      change_address0 = true;

      _address0 = address0;
    }
    currentProto = _protos[1];
    toString1 = _gen.ChangeDetectionUtil.isValueBlank(address0)
        ? null
        : address0.toString();
    if (!_gen.looseIdentical(toString1, _toString1)) {
      change_toString1 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(currentProto,
            _gen.ChangeDetectionUtil.simpleChange(_toString1, toString1));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, toString1);

      _toString1 = toString1;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _address0 = _gen.ChangeDetectionUtil.uninitialized();
    _toString1 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector45(a, b, c), def);
  }
}

class ChangeDetector46 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _sayHi1 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector46(this._dispatcher, this._protos, this._directiveRecords)
      : super("sayHi(\"Jim\")");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var sayHi1 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_sayHi1 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = "Jim";
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    sayHi1 = context.sayHi(literal0);
    if (!_gen.looseIdentical(sayHi1, _sayHi1)) {
      change_sayHi1 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(currentProto,
            _gen.ChangeDetectionUtil.simpleChange(_sayHi1, sayHi1));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, sayHi1);

      _sayHi1 = sayHi1;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _sayHi1 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector46(a, b, c), def);
  }
}

class ChangeDetector47 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _a0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _closure2 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector47(this._dispatcher, this._protos, this._directiveRecords)
      : super("a()(99)");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var a0 = null;
    var literal1 = null;
    var closure2 = null;
    var change_context = false;
    var change_a0 = false;
    var change_literal1 = false;
    var change_closure2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    a0 = context.a();
    if (!_gen.looseIdentical(a0, _a0)) {
      change_a0 = true;

      _a0 = a0;
    }
    currentProto = _protos[1];
    literal1 = 99;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    currentProto = _protos[2];
    closure2 = a0(literal1);
    if (!_gen.looseIdentical(closure2, _closure2)) {
      change_closure2 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(currentProto,
            _gen.ChangeDetectionUtil.simpleChange(_closure2, closure2));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, closure2);

      _closure2 = closure2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _a0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _closure2 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector47(a, b, c), def);
  }
}

class ChangeDetector48 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _a0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _sayHi2 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector48(this._dispatcher, this._protos, this._directiveRecords)
      : super("a.sayHi(\"Jim\")");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var a0 = null;
    var literal1 = null;
    var sayHi2 = null;
    var change_context = false;
    var change_a0 = false;
    var change_literal1 = false;
    var change_sayHi2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    a0 = context.a;
    if (!_gen.looseIdentical(a0, _a0)) {
      change_a0 = true;

      _a0 = a0;
    }
    currentProto = _protos[1];
    literal1 = "Jim";
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;

      _literal1 = literal1;
    }
    currentProto = _protos[2];
    sayHi2 = a0.sayHi(literal1);
    if (!_gen.looseIdentical(sayHi2, _sayHi2)) {
      change_sayHi2 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(currentProto,
            _gen.ChangeDetectionUtil.simpleChange(_sayHi2, sayHi2));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, sayHi2);

      _sayHi2 = sayHi2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _a0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _sayHi2 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector48(a, b, c), def);
  }
}

class ChangeDetector49 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _arrayFn11 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _passThrough2 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector49(this._dispatcher, this._protos, this._directiveRecords)
      : super("passThrough([12])");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var arrayFn11 = null;
    var passThrough2 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_arrayFn11 = false;
    var change_passThrough2 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 12;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    if (change_literal0) {
      currentProto = _protos[1];
      arrayFn11 = _gen.ChangeDetectionUtil.arrayFn1(literal0);
      if (!_gen.looseIdentical(arrayFn11, _arrayFn11)) {
        change_arrayFn11 = true;

        _arrayFn11 = arrayFn11;
      }
    } else {
      arrayFn11 = _arrayFn11;
    }
    currentProto = _protos[2];
    passThrough2 = context.passThrough(arrayFn11);
    if (!_gen.looseIdentical(passThrough2, _passThrough2)) {
      change_passThrough2 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(currentProto,
            _gen.ChangeDetectionUtil.simpleChange(_passThrough2, passThrough2));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, passThrough2);

      _passThrough2 = passThrough2;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _arrayFn11 = _gen.ChangeDetectionUtil.uninitialized();
    _passThrough2 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector49(a, b, c), def);
  }
}

class ChangeDetector50 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _invalidFn1 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector50(this._dispatcher, this._protos, this._directiveRecords)
      : super("invalidFn(1)");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var invalidFn1 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_invalidFn1 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 1;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    invalidFn1 = context.invalidFn(literal0);
    if (!_gen.looseIdentical(invalidFn1, _invalidFn1)) {
      change_invalidFn1 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(currentProto,
            _gen.ChangeDetectionUtil.simpleChange(_invalidFn1, invalidFn1));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, invalidFn1);

      _invalidFn1 = invalidFn1;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _invalidFn1 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector50(a, b, c), def);
  }
}

class ChangeDetector51 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _key0 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector51(this._dispatcher, this._protos, this._directiveRecords)
      : super("valueFromLocals");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var key0 = null;
    var change_context = false;
    var change_key0 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    key0 = _locals.get("key");
    if (!_gen.looseIdentical(key0, _key0)) {
      change_key0 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(
            currentProto, _gen.ChangeDetectionUtil.simpleChange(_key0, key0));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, key0);

      _key0 = key0;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _key0 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector51(a, b, c), def);
  }
}

class ChangeDetector52 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _key0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _closure1 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector52(this._dispatcher, this._protos, this._directiveRecords)
      : super("functionFromLocals");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var key0 = null;
    var closure1 = null;
    var change_context = false;
    var change_key0 = false;
    var change_closure1 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    key0 = _locals.get("key");
    if (!_gen.looseIdentical(key0, _key0)) {
      change_key0 = true;

      _key0 = key0;
    }
    currentProto = _protos[1];
    closure1 = key0();
    if (!_gen.looseIdentical(closure1, _closure1)) {
      change_closure1 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(currentProto,
            _gen.ChangeDetectionUtil.simpleChange(_closure1, closure1));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, closure1);

      _closure1 = closure1;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _key0 = _gen.ChangeDetectionUtil.uninitialized();
    _closure1 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector52(a, b, c), def);
  }
}

class ChangeDetector53 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _key0 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector53(this._dispatcher, this._protos, this._directiveRecords)
      : super("nestedLocals");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var key0 = null;
    var change_context = false;
    var change_key0 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    key0 = _locals.get("key");
    if (!_gen.looseIdentical(key0, _key0)) {
      change_key0 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(
            currentProto, _gen.ChangeDetectionUtil.simpleChange(_key0, key0));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, key0);

      _key0 = key0;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _key0 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector53(a, b, c), def);
  }
}

class ChangeDetector54 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _name0 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector54(this._dispatcher, this._protos, this._directiveRecords)
      : super("fallbackLocals");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var name0 = null;
    var change_context = false;
    var change_name0 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    name0 = context.name;
    if (!_gen.looseIdentical(name0, _name0)) {
      change_name0 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(
            currentProto, _gen.ChangeDetectionUtil.simpleChange(_name0, name0));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, name0);

      _name0 = name0;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _name0 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector54(a, b, c), def);
  }
}

class ChangeDetector55 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _address0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _city1 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector55(this._dispatcher, this._protos, this._directiveRecords)
      : super("contextNestedPropertyWithLocals");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var address0 = null;
    var city1 = null;
    var change_context = false;
    var change_address0 = false;
    var change_city1 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    address0 = context.address;
    if (!_gen.looseIdentical(address0, _address0)) {
      change_address0 = true;

      _address0 = address0;
    }
    currentProto = _protos[1];
    city1 = address0.city;
    if (!_gen.looseIdentical(city1, _city1)) {
      change_city1 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(
            currentProto, _gen.ChangeDetectionUtil.simpleChange(_city1, city1));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, city1);

      _city1 = city1;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _address0 = _gen.ChangeDetectionUtil.uninitialized();
    _city1 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector55(a, b, c), def);
  }
}

class ChangeDetector56 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _city0 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector56(this._dispatcher, this._protos, this._directiveRecords)
      : super("localPropertyWithSimilarContext");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var city0 = null;
    var change_context = false;
    var change_city0 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    city0 = _locals.get("city");
    if (!_gen.looseIdentical(city0, _city0)) {
      change_city0 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(
            currentProto, _gen.ChangeDetectionUtil.simpleChange(_city0, city0));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, city0);

      _city0 = city0;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _city0 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector56(a, b, c), def);
  }
}

class ChangeDetector57 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;

  ChangeDetector57(this._dispatcher, this._protos, this._directiveRecords)
      : super("emptyUsingDefaultStrategy");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var change_context = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector57(a, b, c), def);
  }
}

class ChangeDetector58 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;

  ChangeDetector58(this._dispatcher, this._protos, this._directiveRecords)
      : super("emptyUsingOnPushStrategy");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var change_context = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'CHECK_ONCE';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector58(a, b, c), def);
  }
}

class ChangeDetector59 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _directive_0_0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _detector_0_0 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector59(this._dispatcher, this._protos, this._directiveRecords)
      : super("onPushRecordsUsingDefaultStrategy");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var change_context = false;
    var change_literal0 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 42;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(currentProto,
            _gen.ChangeDetectionUtil.simpleChange(_literal0, literal0));
      }

      _directive_0_0.a = literal0;
      isChanged = true;

      _literal0 = literal0;
    }
    changes = null;
    if (isChanged) {
      _detector_0_0.markAsCheckOnce();
    }

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;
    _directive_0_0 =
        directives.getDirectiveFor(_directiveRecords[0].directiveIndex);

    _detector_0_0 =
        directives.getDetectorFor(_directiveRecords[0].directiveIndex);

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _directive_0_0 = _gen.ChangeDetectionUtil.uninitialized();
    _detector_0_0 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector59(a, b, c), def);
  }
}

class ChangeDetector60 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _directive_0_0 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector60(this._dispatcher, this._protos, this._directiveRecords)
      : super("directNoDispatcher");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var change_context = false;
    var change_literal0 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 42;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(currentProto,
            _gen.ChangeDetectionUtil.simpleChange(_literal0, literal0));
      }

      _directive_0_0.a = literal0;
      isChanged = true;

      changes = _gen.ChangeDetectionUtil.addChange(changes,
          currentProto.bindingRecord.propertyName,
          _gen.ChangeDetectionUtil.simpleChange(_literal0, literal0));

      _literal0 = literal0;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
    _directive_0_0.onAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;
    _directive_0_0 =
        directives.getDirectiveFor(_directiveRecords[0].directiveIndex);

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _directive_0_0 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector60(a, b, c), def);
  }
}

class ChangeDetector61 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal1 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _onChange2 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _literal3 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _onChange4 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _directive_0_0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _directive_0_1 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector61(this._dispatcher, this._protos, this._directiveRecords)
      : super("groupChanges");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var literal1 = null;
    var onChange2 = null;
    var literal3 = null;
    var onChange4 = null;
    var change_context = false;
    var change_literal0 = false;
    var change_literal1 = false;
    var change_onChange2 = false;
    var change_literal3 = false;
    var change_onChange4 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 1;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(currentProto,
            _gen.ChangeDetectionUtil.simpleChange(_literal0, literal0));
      }

      _directive_0_0.a = literal0;
      isChanged = true;

      changes = _gen.ChangeDetectionUtil.addChange(changes,
          currentProto.bindingRecord.propertyName,
          _gen.ChangeDetectionUtil.simpleChange(_literal0, literal0));

      _literal0 = literal0;
    }
    currentProto = _protos[1];
    literal1 = 2;
    if (!_gen.looseIdentical(literal1, _literal1)) {
      change_literal1 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(currentProto,
            _gen.ChangeDetectionUtil.simpleChange(_literal1, literal1));
      }

      _directive_0_0.b = literal1;
      isChanged = true;

      changes = _gen.ChangeDetectionUtil.addChange(changes,
          currentProto.bindingRecord.propertyName,
          _gen.ChangeDetectionUtil.simpleChange(_literal1, literal1));

      _literal1 = literal1;
    }
    if (!throwOnChange && changes != null) _directive_0_0.onChange(changes);
    changes = null;

    isChanged = false;
    currentProto = _protos[3];
    literal3 = 3;
    if (!_gen.looseIdentical(literal3, _literal3)) {
      change_literal3 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(currentProto,
            _gen.ChangeDetectionUtil.simpleChange(_literal3, literal3));
      }

      _directive_0_1.a = literal3;
      isChanged = true;

      changes = _gen.ChangeDetectionUtil.addChange(changes,
          currentProto.bindingRecord.propertyName,
          _gen.ChangeDetectionUtil.simpleChange(_literal3, literal3));

      _literal3 = literal3;
    }
    if (!throwOnChange && changes != null) _directive_0_1.onChange(changes);
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
    _directive_0_1.onAllChangesDone();
    _directive_0_0.onAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;
    _directive_0_0 =
        directives.getDirectiveFor(_directiveRecords[0].directiveIndex);
    _directive_0_1 =
        directives.getDirectiveFor(_directiveRecords[1].directiveIndex);

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _literal1 = _gen.ChangeDetectionUtil.uninitialized();
    _onChange2 = _gen.ChangeDetectionUtil.uninitialized();
    _literal3 = _gen.ChangeDetectionUtil.uninitialized();
    _onChange4 = _gen.ChangeDetectionUtil.uninitialized();
    _directive_0_0 = _gen.ChangeDetectionUtil.uninitialized();
    _directive_0_1 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector61(a, b, c), def);
  }
}

class ChangeDetector62 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _onCheck0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _directive_0_0 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector62(this._dispatcher, this._protos, this._directiveRecords)
      : super("directiveOnCheck");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var onCheck0 = null;
    var change_context = false;
    var change_onCheck0 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    if (!throwOnChange) _directive_0_0.onCheck();
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
    _directive_0_0.onAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;
    _directive_0_0 =
        directives.getDirectiveFor(_directiveRecords[0].directiveIndex);

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _onCheck0 = _gen.ChangeDetectionUtil.uninitialized();
    _directive_0_0 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector62(a, b, c), def);
  }
}

class ChangeDetector63 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _onInit0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _directive_0_0 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector63(this._dispatcher, this._protos, this._directiveRecords)
      : super("directiveOnInit");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var onInit0 = null;
    var change_context = false;
    var change_onInit0 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    if (!throwOnChange && !_alreadyChecked) _directive_0_0.onInit();
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
    _directive_0_0.onAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;
    _directive_0_0 =
        directives.getDirectiveFor(_directiveRecords[0].directiveIndex);

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _onInit0 = _gen.ChangeDetectionUtil.uninitialized();
    _directive_0_0 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector63(a, b, c), def);
  }
}

class ChangeDetector64 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _directive_0_0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _directive_0_1 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector64(this._dispatcher, this._protos, this._directiveRecords)
      : super("emptyWithDirectiveRecords");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var change_context = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
    _directive_0_1.onAllChangesDone();
    _directive_0_0.onAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;
    _directive_0_0 =
        directives.getDirectiveFor(_directiveRecords[0].directiveIndex);
    _directive_0_1 =
        directives.getDirectiveFor(_directiveRecords[1].directiveIndex);

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _directive_0_0 = _gen.ChangeDetectionUtil.uninitialized();
    _directive_0_1 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector64(a, b, c), def);
  }
}

class ChangeDetector65 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _literal0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _directive_0_0 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector65(this._dispatcher, this._protos, this._directiveRecords)
      : super("noCallbacks");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var literal0 = null;
    var change_context = false;
    var change_literal0 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    literal0 = 1;
    if (!_gen.looseIdentical(literal0, _literal0)) {
      change_literal0 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(currentProto,
            _gen.ChangeDetectionUtil.simpleChange(_literal0, literal0));
      }

      _directive_0_0.a = literal0;
      isChanged = true;

      _literal0 = literal0;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;
    _directive_0_0 =
        directives.getDirectiveFor(_directiveRecords[0].directiveIndex);

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _literal0 = _gen.ChangeDetectionUtil.uninitialized();
    _directive_0_0 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector65(a, b, c), def);
  }
}

class ChangeDetector66 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _a0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _directive_0_0 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector66(this._dispatcher, this._protos, this._directiveRecords)
      : super("readingDirectives");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var a0 = null;
    var change_context = false;
    var change_a0 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    a0 = _directive_0_0.a;
    if (!_gen.looseIdentical(a0, _a0)) {
      change_a0 = true;
      if (throwOnChange) {
        _gen.ChangeDetectionUtil.throwOnChange(
            currentProto, _gen.ChangeDetectionUtil.simpleChange(_a0, a0));
      }

      _dispatcher.notifyOnBinding(currentProto.bindingRecord, a0);

      _a0 = a0;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
    _directive_0_0.onAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;
    _directive_0_0 =
        directives.getDirectiveFor(_directiveRecords[0].directiveIndex);

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _a0 = _gen.ChangeDetectionUtil.uninitialized();
    _directive_0_0 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector66(a, b, c), def);
  }
}

class ChangeDetector67 extends _gen.AbstractChangeDetector {
  final dynamic _dispatcher;
  _gen.Pipes _pipes;
  final _gen.List<_gen.ProtoRecord> _protos;
  final _gen.List<_gen.DirectiveRecord> _directiveRecords;
  dynamic _locals = null;
  dynamic _alreadyChecked = false;
  dynamic currentProto = null;
  dynamic _context = null;
  dynamic _a0 = _gen.ChangeDetectionUtil.uninitialized();
  dynamic _interpolate1 = _gen.ChangeDetectionUtil.uninitialized();

  ChangeDetector67(this._dispatcher, this._protos, this._directiveRecords)
      : super("interpolation");

  void detectChangesInRecords(throwOnChange) {
    if (!hydrated()) {
      _gen.ChangeDetectionUtil.throwDehydrated();
    }
    try {
      this.__detectChangesInRecords(throwOnChange);
    } catch (e, s) {
      this.throwError(currentProto, e, s);
    }
  }

  void __detectChangesInRecords(throwOnChange) {
    var context = null;
    var a0 = null;
    var interpolate1 = null;
    var change_context = false;
    var change_a0 = false;
    var change_interpolate1 = false;
    var isChanged = false;
    currentProto = null;
    var changes = null;

    context = _context;
    currentProto = _protos[0];
    a0 = context.a;
    if (!_gen.looseIdentical(a0, _a0)) {
      change_a0 = true;

      _a0 = a0;
    }
    if (change_a0) {
      currentProto = _protos[1];
      interpolate1 = "B" "${a0 == null ? "" : a0}" "A";
      if (!_gen.looseIdentical(interpolate1, _interpolate1)) {
        change_interpolate1 = true;
        if (throwOnChange) {
          _gen.ChangeDetectionUtil.throwOnChange(currentProto,
              _gen.ChangeDetectionUtil.simpleChange(
                  _interpolate1, interpolate1));
        }

        _dispatcher.notifyOnBinding(currentProto.bindingRecord, interpolate1);

        _interpolate1 = interpolate1;
      }
    } else {
      interpolate1 = _interpolate1;
    }
    changes = null;

    isChanged = false;

    _alreadyChecked = true;
  }

  void callOnAllChangesDone() {
    _dispatcher.notifyOnAllChangesDone();
  }

  void hydrate(dynamic context, locals, directives, pipes) {
    mode = 'ALWAYS_CHECK';
    _context = context;
    _locals = locals;

    _alreadyChecked = false;
    _pipes = pipes;
  }

  void dehydrate() {
    _context = null;
    _a0 = _gen.ChangeDetectionUtil.uninitialized();
    _interpolate1 = _gen.ChangeDetectionUtil.uninitialized();
    _locals = null;
    _pipes = null;
  }

  hydrated() => _context != null;

  static _gen.ProtoChangeDetector newProtoChangeDetector(
      _gen.ChangeDetectorDefinition def) {
    return new _gen.PregenProtoChangeDetector(
        (a, b, c) => new ChangeDetector67(a, b, c), def);
  }
}

var _idToProtoMap = {
  '''10''': ChangeDetector0.newProtoChangeDetector,
  '''"str"''': ChangeDetector1.newProtoChangeDetector,
  '''"a

b"''': ChangeDetector2.newProtoChangeDetector,
  '''10 + 2''': ChangeDetector3.newProtoChangeDetector,
  '''10 - 2''': ChangeDetector4.newProtoChangeDetector,
  '''10 * 2''': ChangeDetector5.newProtoChangeDetector,
  '''10 / 2''': ChangeDetector6.newProtoChangeDetector,
  '''11 % 2''': ChangeDetector7.newProtoChangeDetector,
  '''1 == 1''': ChangeDetector8.newProtoChangeDetector,
  '''1 != 1''': ChangeDetector9.newProtoChangeDetector,
  '''1 == true''': ChangeDetector10.newProtoChangeDetector,
  '''1 === 1''': ChangeDetector11.newProtoChangeDetector,
  '''1 !== 1''': ChangeDetector12.newProtoChangeDetector,
  '''1 === true''': ChangeDetector13.newProtoChangeDetector,
  '''1 < 2''': ChangeDetector14.newProtoChangeDetector,
  '''2 < 1''': ChangeDetector15.newProtoChangeDetector,
  '''1 > 2''': ChangeDetector16.newProtoChangeDetector,
  '''2 > 1''': ChangeDetector17.newProtoChangeDetector,
  '''1 <= 2''': ChangeDetector18.newProtoChangeDetector,
  '''2 <= 2''': ChangeDetector19.newProtoChangeDetector,
  '''2 <= 1''': ChangeDetector20.newProtoChangeDetector,
  '''2 >= 1''': ChangeDetector21.newProtoChangeDetector,
  '''2 >= 2''': ChangeDetector22.newProtoChangeDetector,
  '''1 >= 2''': ChangeDetector23.newProtoChangeDetector,
  '''true && true''': ChangeDetector24.newProtoChangeDetector,
  '''true && false''': ChangeDetector25.newProtoChangeDetector,
  '''true || false''': ChangeDetector26.newProtoChangeDetector,
  '''false || false''': ChangeDetector27.newProtoChangeDetector,
  '''!true''': ChangeDetector28.newProtoChangeDetector,
  '''!!true''': ChangeDetector29.newProtoChangeDetector,
  '''1 < 2 ? 1 : 2''': ChangeDetector30.newProtoChangeDetector,
  '''1 > 2 ? 1 : 2''': ChangeDetector31.newProtoChangeDetector,
  '''["foo", "bar"][0]''': ChangeDetector32.newProtoChangeDetector,
  '''{"foo": "bar"}["foo"]''': ChangeDetector33.newProtoChangeDetector,
  '''name''': ChangeDetector34.newProtoChangeDetector,
  '''[1, 2]''': ChangeDetector35.newProtoChangeDetector,
  '''[1, a]''': ChangeDetector36.newProtoChangeDetector,
  '''{z: 1}''': ChangeDetector37.newProtoChangeDetector,
  '''{z: a}''': ChangeDetector38.newProtoChangeDetector,
  '''name | pipe''': ChangeDetector39.newProtoChangeDetector,
  '''name | pipe:'one':address.city''': ChangeDetector40.newProtoChangeDetector,
  '''value''': ChangeDetector41.newProtoChangeDetector,
  '''a''': ChangeDetector42.newProtoChangeDetector,
  '''address.city''': ChangeDetector43.newProtoChangeDetector,
  '''address?.city''': ChangeDetector44.newProtoChangeDetector,
  '''address?.toString()''': ChangeDetector45.newProtoChangeDetector,
  '''sayHi("Jim")''': ChangeDetector46.newProtoChangeDetector,
  '''a()(99)''': ChangeDetector47.newProtoChangeDetector,
  '''a.sayHi("Jim")''': ChangeDetector48.newProtoChangeDetector,
  '''passThrough([12])''': ChangeDetector49.newProtoChangeDetector,
  '''invalidFn(1)''': ChangeDetector50.newProtoChangeDetector,
  '''valueFromLocals''': ChangeDetector51.newProtoChangeDetector,
  '''functionFromLocals''': ChangeDetector52.newProtoChangeDetector,
  '''nestedLocals''': ChangeDetector53.newProtoChangeDetector,
  '''fallbackLocals''': ChangeDetector54.newProtoChangeDetector,
  '''contextNestedPropertyWithLocals''':
      ChangeDetector55.newProtoChangeDetector,
  '''localPropertyWithSimilarContext''':
      ChangeDetector56.newProtoChangeDetector,
  '''emptyUsingDefaultStrategy''': ChangeDetector57.newProtoChangeDetector,
  '''emptyUsingOnPushStrategy''': ChangeDetector58.newProtoChangeDetector,
  '''onPushRecordsUsingDefaultStrategy''':
      ChangeDetector59.newProtoChangeDetector,
  '''directNoDispatcher''': ChangeDetector60.newProtoChangeDetector,
  '''groupChanges''': ChangeDetector61.newProtoChangeDetector,
  '''directiveOnCheck''': ChangeDetector62.newProtoChangeDetector,
  '''directiveOnInit''': ChangeDetector63.newProtoChangeDetector,
  '''emptyWithDirectiveRecords''': ChangeDetector64.newProtoChangeDetector,
  '''noCallbacks''': ChangeDetector65.newProtoChangeDetector,
  '''readingDirectives''': ChangeDetector66.newProtoChangeDetector,
  '''interpolation''': ChangeDetector67.newProtoChangeDetector
};

getFactoryById(String id) => _idToProtoMap[id];

