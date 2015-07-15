library angular2.src.di.exceptions;

import "package:angular2/src/facade/collection.dart" show ListWrapper, List;
import "package:angular2/src/facade/lang.dart"
    show stringify, BaseException, isBlank;

List<dynamic> findFirstClosedCycle(List<dynamic> keys) {
  var res = [];
  for (var i = 0; i < keys.length; ++i) {
    if (ListWrapper.contains(res, keys[i])) {
      res.add(keys[i]);
      return res;
    } else {
      res.add(keys[i]);
    }
  }
  return res;
}
String constructResolvingPath(List<dynamic> keys) {
  if (keys.length > 1) {
    var reversed = findFirstClosedCycle(ListWrapper.reversed(keys));
    var tokenStrs = ListWrapper.map(reversed, (k) => stringify(k.token));
    return " (" + tokenStrs.join(" -> ") + ")";
  } else {
    return "";
  }
}
/**
 * Base class for all errors arising from misconfigured bindings.
 */
class AbstractBindingError extends BaseException {
  String name;
  String message;
  List<dynamic> keys;
  Function constructResolvingMessage;
  // TODO(tbosch): Can't do key:Key as this results in a circular dependency!
  AbstractBindingError(key, Function constructResolvingMessage,
      [originalException, originalStack])
      : super(null, originalException, originalStack) {
    /* super call moved to initializer */;
    this.keys = [key];
    this.constructResolvingMessage = constructResolvingMessage;
    this.message = this.constructResolvingMessage(this.keys);
  }
  // TODO(tbosch): Can't do key:Key as this results in a circular dependency!
  void addKey(key) {
    this.keys.add(key);
    this.message = this.constructResolvingMessage(this.keys);
  }
  String toString() {
    return this.message;
  }
}
/**
 * Thrown when trying to retrieve a dependency by `Key` from {@link Injector}, but the
 * {@link Injector} does not have a {@link Binding} for {@link Key}.
 */
class NoBindingError extends AbstractBindingError {
  // TODO(tbosch): Can't do key:Key as this results in a circular dependency!
  NoBindingError(key) : super(key, (List<dynamic> keys) {
        var first = stringify(ListWrapper.first(keys).token);
        return '''No provider for ${ first}!${ constructResolvingPath ( keys )}''';
      }) {
    /* super call moved to initializer */;
  }
}
/**
 * Thrown when trying to retrieve an async {@link Binding} using the sync API.
 *
 * ## Example
 *
 * ```javascript
 * var injector = Injector.resolveAndCreate([
 *   bind(Number).toAsyncFactory(() => {
 *     return new Promise((resolve) => resolve(1 + 2));
 *   }),
 *   bind(String).toFactory((v) => { return "Value: " + v; }, [String])
 * ]);
 *
 * injector.asyncGet(String).then((v) => expect(v).toBe('Value: 3'));
 * expect(() => {
 *   injector.get(String);
 * }).toThrowError(AsycBindingError);
 * ```
 *
 * The above example throws because `String` depends on `Number` which is async. If any binding in
 * the dependency graph is async then the graph can only be retrieved using the `asyncGet` API.
 */
class AsyncBindingError extends AbstractBindingError {
  // TODO(tbosch): Can't do key:Key as this results in a circular dependency!
  AsyncBindingError(key) : super(key, (List<dynamic> keys) {
        var first = stringify(ListWrapper.first(keys).token);
        return '''Cannot instantiate ${ first} synchronously. It is provided as a promise!${ constructResolvingPath ( keys )}''';
      }) {
    /* super call moved to initializer */;
  }
}
/**
 * Thrown when dependencies form a cycle.
 *
 * ## Example:
 *
 * ```javascript
 * class A {
 *   constructor(b:B) {}
 * }
 * class B {
 *   constructor(a:A) {}
 * }
 * ```
 *
 * Retrieving `A` or `B` throws a `CyclicDependencyError` as the graph above cannot be constructed.
 */
class CyclicDependencyError extends AbstractBindingError {
  // TODO(tbosch): Can't do key:Key as this results in a circular dependency!
  CyclicDependencyError(key) : super(key, (List<dynamic> keys) {
        return '''Cannot instantiate cyclic dependency!${ constructResolvingPath ( keys )}''';
      }) {
    /* super call moved to initializer */;
  }
}
/**
 * Thrown when a constructing type returns with an Error.
 *
 * The `InstantiationError` class contains the original error plus the dependency graph which caused
 * this object to be instantiated.
 */
class InstantiationError extends AbstractBindingError {
  var causeKey;
  // TODO(tbosch): Can't do key:Key as this results in a circular dependency!
  InstantiationError(originalException, originalStack, key) : super(key,
          (List<dynamic> keys) {
        var first = stringify(ListWrapper.first(keys).token);
        return '''Error during instantiation of ${ first}!${ constructResolvingPath ( keys )}.''' +
            ''' ORIGINAL ERROR: ${ originalException}''' +
            '''

 ORIGINAL STACK: ${ originalStack}''';
      }, originalException, originalStack) {
    /* super call moved to initializer */;
    this.causeKey = key;
  }
}
/**
 * Thrown when an object other then {@link Binding} (or `Type`) is passed to {@link Injector}
 * creation.
 */
class InvalidBindingError extends BaseException {
  String message;
  InvalidBindingError(binding) : super() {
    /* super call moved to initializer */;
    this.message =
        "Invalid binding - only instances of Binding and Type are allowed, got: " +
            binding.toString();
  }
  String toString() {
    return this.message;
  }
}
/**
 * Thrown when the class has no annotation information.
 *
 * Lack of annotation information prevents the {@link Injector} from determining which dependencies
 * need to be injected into the constructor.
 */
class NoAnnotationError extends BaseException {
  String name;
  String message;
  NoAnnotationError(typeOrFunc, List<List<dynamic>> params) : super() {
    /* super call moved to initializer */;
    var signature = [];
    for (var i = 0, ii = params.length; i < ii; i++) {
      var parameter = params[i];
      if (isBlank(parameter) || parameter.length == 0) {
        signature.add("?");
      } else {
        signature.add(ListWrapper.map(parameter, stringify).join(" "));
      }
    }
    this.message = "Cannot resolve all parameters for " +
        stringify(typeOrFunc) +
        "(" +
        signature.join(", ") +
        "). " +
        "Make sure they all have valid type or annotations.";
  }
  String toString() {
    return this.message;
  }
}
/**
 * Thrown when getting an object by index.
 */
class OutOfBoundsError extends BaseException {
  String message;
  OutOfBoundsError(index) : super() {
    /* super call moved to initializer */;
    this.message = '''Index ${ index} is out-of-bounds.''';
  }
  String toString() {
    return this.message;
  }
}
