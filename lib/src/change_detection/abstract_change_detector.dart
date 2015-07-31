library angular2.src.change_detection.abstract_change_detector;

import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, BaseException;
import "package:angular2/src/facade/collection.dart" show List, ListWrapper;
import "change_detection_util.dart" show ChangeDetectionUtil;
import "change_detector_ref.dart" show ChangeDetectorRef;
import "directive_record.dart" show DirectiveRecord;
import "interfaces.dart" show ChangeDetector, ChangeDispatcher;
import "exceptions.dart"
    show
        ChangeDetectionError,
        ExpressionChangedAfterItHasBeenCheckedException,
        DehydratedException;
import "proto_record.dart" show ProtoRecord;
import "binding_record.dart" show BindingRecord;
import "parser/locals.dart" show Locals;
import "pipes/pipes.dart" show Pipes;
import "constants.dart"
    show CHECK_ALWAYS, CHECK_ONCE, CHECKED, DETACHED, ON_PUSH;

class _Context {
  dynamic element;
  dynamic componentElement;
  dynamic instance;
  dynamic context;
  dynamic locals;
  dynamic injector;
  dynamic expression;
  _Context(this.element, this.componentElement, this.instance, this.context,
      this.locals, this.injector, this.expression) {}
}
class AbstractChangeDetector<T> implements ChangeDetector {
  String id;
  String modeOnHydrate;
  List<dynamic> lightDomChildren = [];
  List<dynamic> shadowDomChildren = [];
  ChangeDetector parent;
  ChangeDetectorRef ref;
  // The names of the below fields must be kept in sync with codegen_name_util.ts or

  // change detection will fail.
  dynamic alreadyChecked = false;
  T context;
  List<DirectiveRecord> directiveRecords;
  ChangeDispatcher dispatcher;
  Locals locals = null;
  String mode = null;
  Pipes pipes = null;
  num firstProtoInCurrentBinding;
  List<ProtoRecord> protos;
  AbstractChangeDetector(this.id, ChangeDispatcher dispatcher,
      List<ProtoRecord> protos, List<DirectiveRecord> directiveRecords,
      this.modeOnHydrate) {
    this.ref = new ChangeDetectorRef(this);
    this.directiveRecords = directiveRecords;
    this.dispatcher = dispatcher;
    this.protos = protos;
  }
  void addChild(ChangeDetector cd) {
    this.lightDomChildren.add(cd);
    cd.parent = this;
  }
  void removeChild(ChangeDetector cd) {
    ListWrapper.remove(this.lightDomChildren, cd);
  }
  void addShadowDomChild(ChangeDetector cd) {
    this.shadowDomChildren.add(cd);
    cd.parent = this;
  }
  void removeShadowDomChild(ChangeDetector cd) {
    ListWrapper.remove(this.shadowDomChildren, cd);
  }
  void remove() {
    this.parent.removeChild(this);
  }
  void detectChanges() {
    this.runDetectChanges(false);
  }
  void checkNoChanges() {
    throw new BaseException("Not implemented");
  }
  void runDetectChanges(bool throwOnChange) {
    if (identical(this.mode, DETACHED) || identical(this.mode, CHECKED)) return;
    this.detectChangesInRecords(throwOnChange);
    this._detectChangesInLightDomChildren(throwOnChange);
    if (identical(throwOnChange, false)) this.callOnAllChangesDone();
    this._detectChangesInShadowDomChildren(throwOnChange);
    if (identical(this.mode, CHECK_ONCE)) this.mode = CHECKED;
  }
  // This method is not intended to be overridden. Subclasses should instead provide an

  // implementation of `detectChangesInRecordsInternal` which does the work of detecting changes

  // and which this method will call.

  // This method expects that `detectChangesInRecordsInternal` will set the property

  // `this.firstProtoInCurrentBinding` to the selfIndex of the first proto record. This is to

  // facilitate error reporting.
  void detectChangesInRecords(bool throwOnChange) {
    if (!this.hydrated()) {
      this.throwDehydratedError();
    }
    try {
      this.detectChangesInRecordsInternal(throwOnChange);
    } catch (e, e_stack) {
      this._throwError(e, e_stack);
    }
  }
  // Subclasses should override this method to perform any work necessary to detect and report

  // changes. For example, changes should be reported via `ChangeDetectionUtil.addChange`, lifecycle

  // methods should be called, etc.

  // This implementation should also set `this.firstProtoInCurrentBinding` to the selfIndex of the

  // first proto record

  // to facilitate error reporting. See {@link #detectChangesInRecords}.
  void detectChangesInRecordsInternal(bool throwOnChange) {}
  // This method is not intended to be overridden. Subclasses should instead provide an

  // implementation of `hydrateDirectives`.
  void hydrate(T context, Locals locals, dynamic directives, dynamic pipes) {
    this.mode = this.modeOnHydrate;
    this.context = context;
    this.locals = locals;
    this.pipes = pipes;
    this.hydrateDirectives(directives);
    this.alreadyChecked = false;
  }
  // Subclasses should override this method to hydrate any directives.
  void hydrateDirectives(dynamic directives) {}
  // This method is not intended to be overridden. Subclasses should instead provide an

  // implementation of `dehydrateDirectives`.
  void dehydrate() {
    this.dehydrateDirectives(true);
    this.context = null;
    this.locals = null;
    this.pipes = null;
  }
  // Subclasses should override this method to dehydrate any directives. This method should reverse

  // any work done in `hydrateDirectives`.
  void dehydrateDirectives(bool destroyPipes) {}
  bool hydrated() {
    return !identical(this.context, null);
  }
  void callOnAllChangesDone() {
    this.dispatcher.notifyOnAllChangesDone();
  }
  void _detectChangesInLightDomChildren(bool throwOnChange) {
    var c = this.lightDomChildren;
    for (var i = 0; i < c.length; ++i) {
      c[i].runDetectChanges(throwOnChange);
    }
  }
  void _detectChangesInShadowDomChildren(bool throwOnChange) {
    var c = this.shadowDomChildren;
    for (var i = 0; i < c.length; ++i) {
      c[i].runDetectChanges(throwOnChange);
    }
  }
  void markAsCheckOnce() {
    this.mode = CHECK_ONCE;
  }
  void markPathToRootAsCheckOnce() {
    ChangeDetector c = this;
    while (isPresent(c) && c.mode != DETACHED) {
      if (identical(c.mode, CHECKED)) c.mode = CHECK_ONCE;
      c = c.parent;
    }
  }
  void notifyDispatcher(dynamic value) {
    this.dispatcher.notifyOnBinding(this._currentBinding(), value);
  }
  Map<String, dynamic> addChange(
      Map<String, dynamic> changes, dynamic oldValue, dynamic newValue) {
    if (isBlank(changes)) {
      changes = {};
    }
    changes[this._currentBinding().propertyName] =
        ChangeDetectionUtil.simpleChange(oldValue, newValue);
    return changes;
  }
  void _throwError(dynamic exception, dynamic stack) {
    var proto = this._currentBindingProto();
    var c = this.dispatcher.getDebugContext(
        proto.bindingRecord.elementIndex, proto.directiveIndex);
    var context = isPresent(c)
        ? new _Context(c.element, c.componentElement, c.directive, c.context,
            c.locals, c.injector, proto.expressionAsString)
        : null;
    throw new ChangeDetectionError(proto, exception, stack, context);
  }
  void throwOnChangeError(dynamic oldValue, dynamic newValue) {
    var change = ChangeDetectionUtil.simpleChange(oldValue, newValue);
    throw new ExpressionChangedAfterItHasBeenCheckedException(
        this._currentBindingProto(), change, null);
  }
  void throwDehydratedError() {
    throw new DehydratedException();
  }
  BindingRecord _currentBinding() {
    return this._currentBindingProto().bindingRecord;
  }
  ProtoRecord _currentBindingProto() {
    return ChangeDetectionUtil.protoByIndex(
        this.protos, this.firstProtoInCurrentBinding);
  }
}
