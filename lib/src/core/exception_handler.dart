library angular2.src.core.exception_handler;

import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/facade/lang.dart" show isPresent, print;
import "package:angular2/src/facade/collection.dart"
    show ListWrapper, isListLikeIterable;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;

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
 * @Component({
 *   selector: 'my-app',
 *   viewInjector: [
 *     bind(ExceptionHandler).toClass(MyExceptionHandler)
 *   ]
 * })
 * @View(...)
 * class MyApp { ... }
 *
 *
 * class MyExceptionHandler implements ExceptionHandler {
 *   call(error, stackTrace = null, reason = null) {
 *     // do something with the exception
 *   }
 * }
 *
 * ```
 */
@Injectable()
class ExceptionHandler {
  call(error, [stackTrace = null, reason = null]) {
    var longStackTrace = isListLikeIterable(stackTrace)
        ? ListWrapper.join(stackTrace, "\n\n")
        : stackTrace;
    var reasonStr = isPresent(reason)
        ? '''
${ reason}'''
        : "";
    DOM.logError('''${ error}${ reasonStr}
STACKTRACE:
${ longStackTrace}''');
  }
}
