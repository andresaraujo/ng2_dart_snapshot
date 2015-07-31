library angular2.src.change_detection.exceptions;

import "proto_record.dart" show ProtoRecord;
import "package:angular2/src/facade/lang.dart" show BaseException;

/**
 * An error thrown if application changes model breaking the top-down data flow.
 *
 * Angular expects that the data flows from top (root) component to child (leaf) components.
 * This is known as directed acyclic graph. This allows Angular to only execute change detection
 * once and prevents loops in change detection data flow.
 *
 * This exception is only thrown in dev mode.
 */
class ExpressionChangedAfterItHasBeenCheckedException extends BaseException {
  ExpressionChangedAfterItHasBeenCheckedException(
      ProtoRecord proto, dynamic change, dynamic context)
      : super('''Expression \'${ proto . expressionAsString}\' has changed after it was checked. ''' +
          '''Previous value: \'${ change . previousValue}\'. Current value: \'${ change . currentValue}\'''') {
    /* super call moved to initializer */;
  }
}
/**
 * Thrown when an expression evaluation raises an exception.
 *
 * This error wraps the original exception, this is done to attach expression location information.
 */
class ChangeDetectionError extends BaseException {
  /**
   * Location of the expression.
   */
  String location;
  ChangeDetectionError(ProtoRecord proto, dynamic originalException,
      dynamic originalStack, dynamic context)
      : super('''${ originalException} in [${ proto . expressionAsString}]''',
          originalException, originalStack, context) {
    /* super call moved to initializer */;
    this.location = proto.expressionAsString;
  }
}
/**
 * Thrown when change detector executes on dehydrated view.
 *
 * This is angular internal error.
 */
class DehydratedException extends BaseException {
  DehydratedException()
      : super("Attempt to detect changes on a dehydrated detector.") {
    /* super call moved to initializer */;
  }
}
