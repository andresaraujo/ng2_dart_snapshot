library angular2.src.core.compiler.interfaces;

import "package:angular2/src/facade/collection.dart" show Map;
import "package:angular2/src/facade/lang.dart" show global;
// This is here only so that after TS transpilation the file is not empty.

// TODO(rado): find a better way to fix this, or remove if likely culprit

// https://github.com/systemjs/systemjs/issues/487 gets closed.
var ___ignore_me = global;
/**
 * Defines lifecycle method [onChange] called after all of component's bound
 * properties are updated.
 */
abstract class OnChange {
  void onChange(Map<String, dynamic> changes);
}
/**
 * Defines lifecycle method [onDestroy] called when a directive is being destroyed.
 */
abstract class OnDestroy {
  void onDestroy();
}
/**
 * Defines lifecycle method [onCheck] called when a directive is being checked.
 */
abstract class OnCheck {
  void onCheck();
}
/**
 * Defines lifecycle method [onInit] called when a directive is being checked the first time.
 */
abstract class OnInit {
  void onInit();
}
/**
 * Defines lifecycle method [onAllChangesDone ] called when the bindings of all its children have
 * been changed.
 */
abstract class OnAllChangesDone {
  void onAllChangesDone();
}
