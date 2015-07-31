library angular2.src.core.compiler.directive_resolver;

import "package:angular2/di.dart" show resolveForwardRef, Injectable;
import "package:angular2/src/facade/lang.dart"
    show Type, isPresent, BaseException, stringify;
import "../annotations_impl/annotations.dart" show Directive;
import "package:angular2/src/reflection/reflection.dart" show reflector;

/**
 * Resolve a `Type` for {@link Directive}.
 *
 * This interface can be overridden by the application developer to create custom behavior.
 *
 * See {@link Compiler}
 */
@Injectable()
class DirectiveResolver {
  /**
   * Return {@link Directive} for a given `Type`.
   */
  Directive resolve(Type type) {
    var annotations = reflector.annotations(resolveForwardRef(type));
    if (isPresent(annotations)) {
      for (var i = 0; i < annotations.length; i++) {
        var annotation = annotations[i];
        if (annotation is Directive) {
          return annotation;
        }
      }
    }
    throw new BaseException(
        '''No Directive annotation found on ${ stringify ( type )}''');
  }
}
