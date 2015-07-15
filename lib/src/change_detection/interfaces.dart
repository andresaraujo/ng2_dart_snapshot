library angular2.src.change_detection.interfaces;

import "package:angular2/src/facade/collection.dart" show List;
import "parser/locals.dart" show Locals;
import "binding_record.dart" show BindingRecord;
import "directive_record.dart" show DirectiveRecord;

/**
 * Interface used by Angular to control the change detection strategy for an application.
 *
 * Angular implements the following change detection strategies by default:
 *
 * - {@link DynamicChangeDetection}: slower, but does not require `eval()`.
 * - {@link JitChangeDetection}: faster, but requires `eval()`.
 *
 * In JavaScript, you should always use `JitChangeDetection`, unless you are in an environment that
 *has
 * [CSP](https://developer.mozilla.org/en-US/docs/Web/Security/CSP), such as a Chrome Extension.
 *
 * In Dart, use `DynamicChangeDetection` during development. The Angular transformer generates an
 *analog to the
 * `JitChangeDetection` strategy at compile time.
 *
 *
 * See: {@link DynamicChangeDetection}, {@link JitChangeDetection},
 * {@link PreGeneratedChangeDetection}
 *
 * # Example
 * ```javascript
 * bootstrap(MyApp, [bind(ChangeDetection).toClass(DynamicChangeDetection)]);
 * ```
 */
class ChangeDetection {
  ProtoChangeDetector createProtoChangeDetector(
      ChangeDetectorDefinition definition) {
    return null;
  }
  const ChangeDetection();
}
abstract class ChangeDispatcher {
  void notifyOnBinding(BindingRecord bindingRecord, dynamic value);
  void notifyOnAllChangesDone();
}
abstract class ChangeDetector {
  ChangeDetector parent;
  String mode;
  void addChild(ChangeDetector cd);
  void addShadowDomChild(ChangeDetector cd);
  void removeChild(ChangeDetector cd);
  void removeShadowDomChild(ChangeDetector cd);
  void remove();
  void hydrate(
      dynamic context, Locals locals, dynamic directives, dynamic pipes);
  void dehydrate();
  void markPathToRootAsCheckOnce();
  void detectChanges();
  void checkNoChanges();
}
abstract class ProtoChangeDetector {
  ChangeDetector instantiate(dynamic dispatcher);
}
class ChangeDetectorDefinition {
  String id;
  String strategy;
  List<String> variableNames;
  List<BindingRecord> bindingRecords;
  List<DirectiveRecord> directiveRecords;
  ChangeDetectorDefinition(this.id, this.strategy, this.variableNames,
      this.bindingRecords, this.directiveRecords) {}
}
