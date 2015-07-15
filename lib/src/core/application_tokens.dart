library angular2.src.core.application_tokens;

import "package:angular2/di.dart" show OpaqueToken;

/**
 *  @private
 */
const appComponentRefPromiseToken = const OpaqueToken("Promise<ComponentRef>");
/**
 * An opaque token representing the application root type in the {@link Injector}.
 *
 * ```
 * @Component(...)
 * @View(...)
 * class MyApp {
 *   ...
 * }
 *
 * bootstrap(MyApp).then((appRef:ApplicationRef) {
 *   expect(appRef.injector.get(appComponentTypeToken)).toEqual(MyApp);
 * });
 *
 * ```
 */
const appComponentTypeToken = const OpaqueToken("RootComponent");
