library angular2.src.router.interfaces;

import "instruction.dart" show Instruction;
import "package:angular2/src/facade/lang.dart" show global;
// This is here only so that after TS transpilation the file is not empty.

// TODO(rado): find a better way to fix this, or remove if likely culprit

// https://github.com/systemjs/systemjs/issues/487 gets closed.
var ___ignore_me = global;
/**
 * Defines route lifecycle method [onActivate]
 */
abstract class OnActivate {
  dynamic onActivate(Instruction nextInstruction, Instruction prevInstruction);
}
/**
 * Defines route lifecycle method [onReuse]
 */
abstract class OnReuse {
  dynamic onReuse(Instruction nextInstruction, Instruction prevInstruction);
}
/**
 * Defines route lifecycle method [onDeactivate]
 */
abstract class OnDeactivate {
  dynamic onDeactivate(
      Instruction nextInstruction, Instruction prevInstruction);
}
/**
 * Defines route lifecycle method [canReuse]
 */
abstract class CanReuse {
  dynamic canReuse(Instruction nextInstruction, Instruction prevInstruction);
}
/**
 * Defines route lifecycle method [canDeactivate]
 */
abstract class CanDeactivate {
  dynamic canDeactivate(
      Instruction nextInstruction, Instruction prevInstruction);
}
