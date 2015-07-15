library angular2.src.di.binding;

import "package:angular2/src/facade/lang.dart"
    show Type, isBlank, isPresent, BaseException, stringify, isArray;
import "package:angular2/src/facade/collection.dart"
    show List, MapWrapper, ListWrapper;
import "package:angular2/src/reflection/reflection.dart" show reflector;
import "key.dart" show Key;
import "metadata.dart"
    show
        InjectMetadata,
        InjectableMetadata,
        VisibilityMetadata,
        OptionalMetadata,
        DEFAULT_VISIBILITY,
        DependencyMetadata;
import "exceptions.dart" show NoAnnotationError;
import "forward_ref.dart" show resolveForwardRef;

/**
 * @private
 */
class Dependency {
  Key key;
  bool optional;
  VisibilityMetadata visibility;
  List<dynamic> properties;
  Dependency(this.key, this.optional, this.visibility, this.properties) {}
  static Dependency fromKey(Key key) {
    return new Dependency(key, false, DEFAULT_VISIBILITY, []);
  }
}
const _EMPTY_LIST = const [];
/**
 * Describes how the {@link Injector} should instantiate a given token.
 *
 * See {@link bind}.
 *
 * ## Example
 *
 * ```javascript
 * var injector = Injector.resolveAndCreate([
 *   new Binding(String, { toValue: 'Hello' })
 * ]);
 *
 * expect(injector.get(String)).toEqual('Hello');
 * ```
 */
class Binding {
  /**
   * Token used when retrieving this binding. Usually the `Type`.
   */
  final token;
  /**
   * Binds an interface to an implementation / subclass.
   *
   * ## Example
   *
   * Becuse `toAlias` and `toClass` are often confused, the example contains both use cases for easy
   * comparison.
   *
   * ```javascript
   *
   * class Vehicle {}
   *
   * class Car extends Vehicle {}
   *
   * var injectorClass = Injector.resolveAndCreate([
   *   Car,
   *   new Binding(Vehicle, { toClass: Car })
   * ]);
   * var injectorAlias = Injector.resolveAndCreate([
   *   Car,
   *   new Binding(Vehicle, { toAlias: Car })
   * ]);
   *
   * expect(injectorClass.get(Vehicle)).not.toBe(injectorClass.get(Car));
   * expect(injectorClass.get(Vehicle) instanceof Car).toBe(true);
   *
   * expect(injectorAlias.get(Vehicle)).toBe(injectorAlias.get(Car));
   * expect(injectorAlias.get(Vehicle) instanceof Car).toBe(true);
   * ```
   */
  final Type toClass;
  /**
   * Binds a key to a value.
   *
   * ## Example
   *
   * ```javascript
   * var injector = Injector.resolveAndCreate([
   *   new Binding(String, { toValue: 'Hello' })
   * ]);
   *
   * expect(injector.get(String)).toEqual('Hello');
   * ```
   */
  final toValue;
  /**
   * Binds a key to the alias for an existing key.
   *
   * An alias means that {@link Injector} returns the same instance as if the alias token was used.
   * This is in contrast to `toClass` where a separate instance of `toClass` is returned.
   *
   * ## Example
   *
   * Becuse `toAlias` and `toClass` are often confused the example contains both use cases for easy
   * comparison.
   *
   * ```javascript
   *
   * class Vehicle {}
   *
   * class Car extends Vehicle {}
   *
   * var injectorAlias = Injector.resolveAndCreate([
   *   Car,
   *   new Binding(Vehicle, { toAlias: Car })
   * ]);
   * var injectorClass = Injector.resolveAndCreate([
   *   Car,
   *   new Binding(Vehicle, { toClass: Car })
   * ]);
   *
   * expect(injectorAlias.get(Vehicle)).toBe(injectorAlias.get(Car));
   * expect(injectorAlias.get(Vehicle) instanceof Car).toBe(true);
   *
   * expect(injectorClass.get(Vehicle)).not.toBe(injectorClass.get(Car));
   * expect(injectorClass.get(Vehicle) instanceof Car).toBe(true);
   * ```
   */
  final toAlias;
  /**
   * Binds a key to a function which computes the value.
   *
   * ## Example
   *
   * ```javascript
   * var injector = Injector.resolveAndCreate([
   *   new Binding(Number, { toFactory: () => { return 1+2; }}),
   *   new Binding(String, { toFactory: (value) => { return "Value: " + value; },
   *                         dependencies: [Number] })
   * ]);
   *
   * expect(injector.get(Number)).toEqual(3);
   * expect(injector.get(String)).toEqual('Value: 3');
   * ```
   */
  final Function toFactory;
  /**
   * Used in conjunction with `toFactory` and specifies a set of dependencies
   * (as `token`s) which should be injected into the factory function.
   *
   * ## Example
   *
   * ```javascript
   * var injector = Injector.resolveAndCreate([
   *   new Binding(Number, { toFactory: () => { return 1+2; }}),
   *   new Binding(String, { toFactory: (value) => { return "Value: " + value; },
   *                         dependencies: [Number] })
   * ]);
   *
   * expect(injector.get(Number)).toEqual(3);
   * expect(injector.get(String)).toEqual('Value: 3');
   * ```
   */
  final List<dynamic> dependencies;
  const Binding(token, {toClass, toValue, toAlias, toFactory, deps})
      : token = token,
        toClass = toClass,
        toValue = toValue,
        toAlias = toAlias,
        toFactory = toFactory,
        dependencies = deps;
  /**
   * Converts the {@link Binding} into {@link ResolvedBinding}.
   *
   * {@link Injector} internally only uses {@link ResolvedBinding}, {@link Binding} contains
   * convenience binding syntax.
   */
  ResolvedBinding resolve() {
    Function factoryFn;
    var resolvedDeps;
    if (isPresent(this.toClass)) {
      var toClass = resolveForwardRef(this.toClass);
      factoryFn = reflector.factory(toClass);
      resolvedDeps = _dependenciesFor(toClass);
    } else if (isPresent(this.toAlias)) {
      factoryFn = (aliasInstance) => aliasInstance;
      resolvedDeps = [Dependency.fromKey(Key.get(this.toAlias))];
    } else if (isPresent(this.toFactory)) {
      factoryFn = this.toFactory;
      resolvedDeps = _constructDependencies(this.toFactory, this.dependencies);
    } else {
      factoryFn = () => this.toValue;
      resolvedDeps = _EMPTY_LIST;
    }
    return new ResolvedBinding(Key.get(this.token), factoryFn, resolvedDeps);
  }
}
/**
 * An internal resolved representation of a {@link Binding} used by the {@link Injector}.
 *
 * A {@link Binding} is resolved when it has a factory function. Binding to a class, alias, or
 * value, are just convenience methods, as {@link Injector} only operates on calling factory
 * functions.
 */
class ResolvedBinding {
  Key key;
  Function factory;
  List<Dependency> dependencies;
  ResolvedBinding(
      /**
       * A key, usually a `Type`.
       */
      this.key,
      /**
       * Factory function which can return an instance of an object represented by a key.
       */
      this.factory,
      /**
       * Arguments (dependencies) to the `factory` function.
       */
      this.dependencies) {}
}
/**
 * Provides an API for imperatively constructing {@link Binding}s.
 *
 * This is only relevant for JavaScript. See {@link BindingBuilder}.
 *
 * ## Example
 *
 * ```javascript
 * bind(MyInterface).toClass(MyClass)
 *
 * ```
 */
BindingBuilder bind(token) {
  return new BindingBuilder(token);
}
/**
 * Helper class for the {@link bind} function.
 */
class BindingBuilder {
  var token;
  BindingBuilder(this.token) {}
  /**
   * Binds an interface to an implementation / subclass.
   *
   * ## Example
   *
   * Because `toAlias` and `toClass` are often confused, the example contains both use cases for
   * easy comparison.
   *
   * ```javascript
   *
   * class Vehicle {}
   *
   * class Car extends Vehicle {}
   *
   * var injectorClass = Injector.resolveAndCreate([
   *   Car,
   *   bind(Vehicle).toClass(Car)
   * ]);
   * var injectorAlias = Injector.resolveAndCreate([
   *   Car,
   *   bind(Vehicle).toAlias(Car)
   * ]);
   *
   * expect(injectorClass.get(Vehicle)).not.toBe(injectorClass.get(Car));
   * expect(injectorClass.get(Vehicle) instanceof Car).toBe(true);
   *
   * expect(injectorAlias.get(Vehicle)).toBe(injectorAlias.get(Car));
   * expect(injectorAlias.get(Vehicle) instanceof Car).toBe(true);
   * ```
   */
  Binding toClass(Type type) {
    return new Binding(this.token, toClass: type);
  }
  /**
   * Binds a key to a value.
   *
   * ## Example
   *
   * ```javascript
   * var injector = Injector.resolveAndCreate([
   *   bind(String).toValue('Hello')
   * ]);
   *
   * expect(injector.get(String)).toEqual('Hello');
   * ```
   */
  Binding toValue(value) {
    return new Binding(this.token, toValue: value);
  }
  /**
   * Binds a key to the alias for an existing key.
   *
   * An alias means that we will return the same instance as if the alias token was used. (This is
   * in contrast to `toClass` where a separet instance of `toClass` will be returned.)
   *
   * ## Example
   *
   * Becuse `toAlias` and `toClass` are often confused, the example contains both use cases for easy
   * comparison.
   *
   * ```javascript
   *
   * class Vehicle {}
   *
   * class Car extends Vehicle {}
   *
   * var injectorAlias = Injector.resolveAndCreate([
   *   Car,
   *   bind(Vehicle).toAlias(Car)
   * ]);
   * var injectorClass = Injector.resolveAndCreate([
   *   Car,
   *   bind(Vehicle).toClass(Car)
   * ]);
   *
   * expect(injectorAlias.get(Vehicle)).toBe(injectorAlias.get(Car));
   * expect(injectorAlias.get(Vehicle) instanceof Car).toBe(true);
   *
   * expect(injectorClass.get(Vehicle)).not.toBe(injectorClass.get(Car));
   * expect(injectorClass.get(Vehicle) instanceof Car).toBe(true);
   * ```
   */
  Binding toAlias(aliasToken) {
    if (isBlank(aliasToken)) {
      throw new BaseException(
          '''Can not alias ${ stringify ( this . token )} to a blank value!''');
    }
    return new Binding(this.token, toAlias: aliasToken);
  }
  /**
   * Binds a key to a function which computes the value.
   *
   * ## Example
   *
   * ```javascript
   * var injector = Injector.resolveAndCreate([
   *   bind(Number).toFactory(() => { return 1+2; }),
   *   bind(String).toFactory((v) => { return "Value: " + v; }, [Number])
   * ]);
   *
   * expect(injector.get(Number)).toEqual(3);
   * expect(injector.get(String)).toEqual('Value: 3');
   * ```
   */
  Binding toFactory(Function factoryFunction, [List<dynamic> dependencies]) {
    return new Binding(this.token,
        toFactory: factoryFunction, deps: dependencies);
  }
}
List<Dependency> _constructDependencies(
    Function factoryFunction, List<dynamic> dependencies) {
  if (isBlank(dependencies)) {
    return _dependenciesFor(factoryFunction);
  } else {
    List<List<dynamic>> params = ListWrapper.map(dependencies, (t) => [t]);
    return ListWrapper.map(
        dependencies, (t) => _extractToken(factoryFunction, t, params));
  }
}
List<Dependency> _dependenciesFor(typeOrFunc) {
  var params = reflector.parameters(typeOrFunc);
  if (isBlank(params)) return [];
  if (ListWrapper.any(params, (p) => isBlank(p))) {
    throw new NoAnnotationError(typeOrFunc, params);
  }
  return ListWrapper.map(
      params, (List<dynamic> p) => _extractToken(typeOrFunc, p, params));
}
Dependency _extractToken(typeOrFunc, annotations, List<List<dynamic>> params) {
  var depProps = [];
  var token = null;
  var optional = false;
  if (!isArray(annotations)) {
    return _createDependency(
        annotations, optional, DEFAULT_VISIBILITY, depProps);
  }
  var visibility = DEFAULT_VISIBILITY;
  for (var i = 0; i < annotations.length; ++i) {
    var paramAnnotation = annotations[i];
    if (paramAnnotation is Type) {
      token = paramAnnotation;
    } else if (paramAnnotation is InjectMetadata) {
      token = paramAnnotation.token;
    } else if (paramAnnotation is OptionalMetadata) {
      optional = true;
    } else if (paramAnnotation is VisibilityMetadata) {
      visibility = paramAnnotation;
    } else if (paramAnnotation is DependencyMetadata) {
      if (isPresent(paramAnnotation.token)) {
        token = paramAnnotation.token;
      }
      depProps.add(paramAnnotation);
    }
  }
  token = resolveForwardRef(token);
  if (isPresent(token)) {
    return _createDependency(token, optional, visibility, depProps);
  } else {
    throw new NoAnnotationError(typeOrFunc, params);
  }
}
Dependency _createDependency(token, optional, visibility, depProps) {
  return new Dependency(Key.get(token), optional, visibility, depProps);
}
