library angular2.src.core.exception_handler;

import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, print, BaseException;
import "package:angular2/src/facade/collection.dart"
    show ListWrapper, isListLikeIterable;

class _ArrayLogger {
  List<dynamic> res = [];
  void log(dynamic s) {
    this.res.add(s);
  }
  void logGroup(dynamic s) {
    this.res.add(s);
  }
  logGroupEnd() {}
}
/**
 * Provides a hook for centralized exception handling.
 *
 * The default implementation of `ExceptionHandler` prints error messages to the `Console`. To
 * intercept error handling,
 * write a custom exception handler that replaces this default as appropriate for your app.
 *
 * # Example
 *
 * ```javascript
 *
 * class MyExceptionHandler implements ExceptionHandler {
 *   call(error, stackTrace = null, reason = null) {
 *     // do something with the exception
 *   }
 * }
 *
 * bootstrap(MyApp, [bind(ExceptionHandler).toClass(MyExceptionHandler)])
 *
 * ```
 */
@Injectable()
class ExceptionHandler {
  dynamic logger;
  bool rethrowException;
  ExceptionHandler(this.logger, [this.rethrowException = true]) {}
  static String exceptionToString(dynamic exception,
      [dynamic stackTrace = null, String reason = null]) {
    var l = new _ArrayLogger();
    var e = new ExceptionHandler(l, false);
    e.call(exception, stackTrace, reason);
    return l.res.join("\n");
  }
  void call(dynamic exception,
      [dynamic stackTrace = null, String reason = null]) {
    var originalException = this._findOriginalException(exception);
    var originalStack = this._findOriginalStack(exception);
    var context = this._findContext(exception);
    this.logger.logGroup('''EXCEPTION: ${ exception}''');
    if (isPresent(stackTrace) && isBlank(originalStack)) {
      this.logger.log("STACKTRACE:");
      this.logger.log(this._longStackTrace(stackTrace));
    }
    if (isPresent(reason)) {
      this.logger.log('''REASON: ${ reason}''');
    }
    if (isPresent(originalException)) {
      this.logger.log('''ORIGINAL EXCEPTION: ${ originalException}''');
    }
    if (isPresent(originalStack)) {
      this.logger.log("ORIGINAL STACKTRACE:");
      this.logger.log(this._longStackTrace(originalStack));
    }
    if (isPresent(context)) {
      this.logger.log("ERROR CONTEXT:");
      this.logger.log(context);
    }
    this.logger.logGroupEnd();
    // We rethrow exceptions, so operations like 'bootstrap' will result in an error

    // when an exception happens. If we do not rethrow, bootstrap will always succeed.
    if (this.rethrowException) throw exception;
  }
  dynamic _longStackTrace(dynamic stackTrace) {
    return isListLikeIterable(stackTrace)
        ? ((stackTrace as dynamic)).join("\n\n-----async gap-----\n")
        : stackTrace.toString();
  }
  dynamic _findContext(dynamic exception) {
    try {
      if (!(exception is BaseException)) return null;
      return isPresent(exception.context)
          ? exception.context
          : this._findContext(exception.originalException);
    } catch (e, e_stack) {
      // exception.context can throw an exception. if it happens, we ignore the context.
      return null;
    }
  }
  dynamic _findOriginalException(dynamic exception) {
    if (!(exception is BaseException)) return null;
    var e = exception.originalException;
    while (e is BaseException && isPresent(e.originalException)) {
      e = e.originalException;
    }
    return e;
  }
  dynamic _findOriginalStack(dynamic exception) {
    if (!(exception is BaseException)) return null;
    var e = exception;
    var stack = exception.originalStack;
    while (e is BaseException && isPresent(e.originalException)) {
      e = e.originalException;
      if (e is BaseException && isPresent(e.originalException)) {
        stack = e.originalStack;
      }
    }
    return stack;
  }
}
