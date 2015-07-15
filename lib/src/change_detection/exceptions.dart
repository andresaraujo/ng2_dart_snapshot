library angular2.src.change_detection.exceptions;

import "proto_record.dart" show ProtoRecord;
import "package:angular2/src/facade/lang.dart" show BaseException;

class ExpressionChangedAfterItHasBeenChecked extends BaseException {
  ExpressionChangedAfterItHasBeenChecked(ProtoRecord proto, dynamic change)
      : super('''Expression \'${ proto . expressionAsString}\' has changed after it was checked. ''' +
          '''Previous value: \'${ change . previousValue}\'. Current value: \'${ change . currentValue}\'''') {
    /* super call moved to initializer */;
  }
}
class ChangeDetectionError extends BaseException {
  String location;
  ChangeDetectionError(
      ProtoRecord proto, dynamic originalException, dynamic originalStack)
      : super('''${ originalException} in [${ proto . expressionAsString}]''',
          originalException, originalStack) {
    /* super call moved to initializer */;
    this.location = proto.expressionAsString;
  }
}
class DehydratedException extends BaseException {
  DehydratedException()
      : super("Attempt to detect changes on a dehydrated detector.") {
    /* super call moved to initializer */;
  }
}
