library angular2.src.change_detection.abstract_change_detector;

import "package:angular2/src/facade/lang.dart" show isPresent;
import "package:angular2/src/facade/collection.dart" show List, ListWrapper;
import "change_detector_ref.dart" show ChangeDetectorRef;
import "interfaces.dart" show ChangeDetector;
import "exceptions.dart" show ChangeDetectionError;
import "proto_record.dart" show ProtoRecord;
import "parser/locals.dart" show Locals;
import "constants.dart"
    show CHECK_ALWAYS, CHECK_ONCE, CHECKED, DETACHED, ON_PUSH;

class AbstractChangeDetector implements ChangeDetector {
  String id;
  List<dynamic> lightDomChildren = [];
  List<dynamic> shadowDomChildren = [];
  ChangeDetector parent;
  String mode = null;
  ChangeDetectorRef ref;
  AbstractChangeDetector(this.id) {
    this.ref = new ChangeDetectorRef(this);
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
    this._detectChanges(false);
  }
  void checkNoChanges() {
    this._detectChanges(true);
  }
  void _detectChanges(bool throwOnChange) {
    if (identical(this.mode, DETACHED) || identical(this.mode, CHECKED)) return;
    this.detectChangesInRecords(throwOnChange);
    this._detectChangesInLightDomChildren(throwOnChange);
    if (identical(throwOnChange, false)) this.callOnAllChangesDone();
    this._detectChangesInShadowDomChildren(throwOnChange);
    if (identical(this.mode, CHECK_ONCE)) this.mode = CHECKED;
  }
  void detectChangesInRecords(bool throwOnChange) {}
  void hydrate(
      dynamic context, Locals locals, dynamic directives, dynamic pipes) {}
  void dehydrate() {}
  void callOnAllChangesDone() {}
  void _detectChangesInLightDomChildren(bool throwOnChange) {
    var c = this.lightDomChildren;
    for (var i = 0; i < c.length; ++i) {
      c[i]._detectChanges(throwOnChange);
    }
  }
  void _detectChangesInShadowDomChildren(bool throwOnChange) {
    var c = this.shadowDomChildren;
    for (var i = 0; i < c.length; ++i) {
      c[i]._detectChanges(throwOnChange);
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
  void throwError(ProtoRecord proto, dynamic exception, dynamic stack) {
    throw new ChangeDetectionError(proto, exception, stack);
  }
}
