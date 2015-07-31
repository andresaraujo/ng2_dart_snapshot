library angular2.src.di.exceptions;

import "package:angular2/src/facade/collection.dart" show ListWrapper, List;
import "package:angular2/src/facade/lang.dart"
    show stringify, BaseException, isBlank;
import "key.dart" show Key;
import "injector.dart" show Injector;

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
  List<Key> keys;
  List<Injector> injectors;
  Function constructResolvingMessage;
  AbstractBindingError(
      Injector injector, Key key, Function constructResolvingMessage,
      [originalException, originalStack])
      : super("DI Exception", originalException, originalStack, null) {
    /* super call moved to initializer */;
    this.keys = [key];
    this.injectors = [injector];
    this.constructResolvingMessage = constructResolvingMessage;
    this.message = this.constructResolvingMessage(this.keys);
  }
  void addKey(Injector injector, Key key) {
    this.injectors.add(injector);
    this.keys.add(key);
    this.message = this.constructResolvingMessage(this.keys);
  }
  get context {
    return this.injectors[this.injectors.length - 1].debugContext();
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
  NoBindingError(Injector injector, Key key) : super(injector, key,
          (List<dynamic> keys) {
        var first = stringify(ListWrapper.first(keys).token);
        return '''No provider for ${ first}!${ constructResolvingPath ( keys )}''';
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
  CyclicDependencyError(Injector injector, Key key) : super(injector, key,
          (List<dynamic> keys) {
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
  Key causeKey;
  InstantiationError(
      Injector injector, originalException, originalStack, Key key)
      : super(injector, key, (List<dynamic> keys) {
        var first = stringify(ListWrapper.first(keys).token);
        return '''Error during instantiation of ${ first}!${ constructResolvingPath ( keys )}.''';
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
