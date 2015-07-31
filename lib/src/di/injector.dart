/// <reference path="../../typings/es6-promise/es6-promise.d.ts" />
library angular2.src.di.injector;

import "package:angular2/src/facade/collection.dart"
    show Map, List, MapWrapper, ListWrapper;
import "binding.dart"
    show ResolvedBinding, Binding, Dependency, BindingBuilder, bind;
import "exceptions.dart"
    show
        AbstractBindingError,
        NoBindingError,
        CyclicDependencyError,
        InstantiationError,
        InvalidBindingError,
        OutOfBoundsError;
import "package:angular2/src/facade/lang.dart"
    show FunctionWrapper, Type, isPresent, isBlank;
import "key.dart" show Key;
import "forward_ref.dart" show resolveForwardRef;
import "metadata.dart" show SelfMetadata, HostMetadata, SkipSelfMetadata;

const _constructing = const Object();
const _notFound = const Object();
// Threshold for the dynamic version
const _MAX_CONSTRUCTION_COUNTER = 10;
const Object undefinedValue = const Object();
const num PUBLIC = 1;
const num PRIVATE = 2;
const num PUBLIC_AND_PRIVATE = 3;
abstract class ProtoInjectorStrategy {
  ResolvedBinding getBindingAtIndex(num index);
  InjectorStrategy createInjectorStrategy(Injector inj);
}
class ProtoInjectorInlineStrategy implements ProtoInjectorStrategy {
  ResolvedBinding binding0 = null;
  ResolvedBinding binding1 = null;
  ResolvedBinding binding2 = null;
  ResolvedBinding binding3 = null;
  ResolvedBinding binding4 = null;
  ResolvedBinding binding5 = null;
  ResolvedBinding binding6 = null;
  ResolvedBinding binding7 = null;
  ResolvedBinding binding8 = null;
  ResolvedBinding binding9 = null;
  num keyId0 = null;
  num keyId1 = null;
  num keyId2 = null;
  num keyId3 = null;
  num keyId4 = null;
  num keyId5 = null;
  num keyId6 = null;
  num keyId7 = null;
  num keyId8 = null;
  num keyId9 = null;
  num visibility0 = null;
  num visibility1 = null;
  num visibility2 = null;
  num visibility3 = null;
  num visibility4 = null;
  num visibility5 = null;
  num visibility6 = null;
  num visibility7 = null;
  num visibility8 = null;
  num visibility9 = null;
  ProtoInjectorInlineStrategy(
      ProtoInjector protoEI, List<BindingWithVisibility> bwv) {
    var length = bwv.length;
    if (length > 0) {
      this.binding0 = bwv[0].binding;
      this.keyId0 = bwv[0].getKeyId();
      this.visibility0 = bwv[0].visibility;
    }
    if (length > 1) {
      this.binding1 = bwv[1].binding;
      this.keyId1 = bwv[1].getKeyId();
      this.visibility1 = bwv[1].visibility;
    }
    if (length > 2) {
      this.binding2 = bwv[2].binding;
      this.keyId2 = bwv[2].getKeyId();
      this.visibility2 = bwv[2].visibility;
    }
    if (length > 3) {
      this.binding3 = bwv[3].binding;
      this.keyId3 = bwv[3].getKeyId();
      this.visibility3 = bwv[3].visibility;
    }
    if (length > 4) {
      this.binding4 = bwv[4].binding;
      this.keyId4 = bwv[4].getKeyId();
      this.visibility4 = bwv[4].visibility;
    }
    if (length > 5) {
      this.binding5 = bwv[5].binding;
      this.keyId5 = bwv[5].getKeyId();
      this.visibility5 = bwv[5].visibility;
    }
    if (length > 6) {
      this.binding6 = bwv[6].binding;
      this.keyId6 = bwv[6].getKeyId();
      this.visibility6 = bwv[6].visibility;
    }
    if (length > 7) {
      this.binding7 = bwv[7].binding;
      this.keyId7 = bwv[7].getKeyId();
      this.visibility7 = bwv[7].visibility;
    }
    if (length > 8) {
      this.binding8 = bwv[8].binding;
      this.keyId8 = bwv[8].getKeyId();
      this.visibility8 = bwv[8].visibility;
    }
    if (length > 9) {
      this.binding9 = bwv[9].binding;
      this.keyId9 = bwv[9].getKeyId();
      this.visibility9 = bwv[9].visibility;
    }
  }
  dynamic getBindingAtIndex(num index) {
    if (index == 0) return this.binding0;
    if (index == 1) return this.binding1;
    if (index == 2) return this.binding2;
    if (index == 3) return this.binding3;
    if (index == 4) return this.binding4;
    if (index == 5) return this.binding5;
    if (index == 6) return this.binding6;
    if (index == 7) return this.binding7;
    if (index == 8) return this.binding8;
    if (index == 9) return this.binding9;
    throw new OutOfBoundsError(index);
  }
  InjectorStrategy createInjectorStrategy(Injector injector) {
    return new InjectorInlineStrategy(injector, this);
  }
}
class ProtoInjectorDynamicStrategy implements ProtoInjectorStrategy {
  List<ResolvedBinding> bindings;
  List<num> keyIds;
  List<num> visibilities;
  ProtoInjectorDynamicStrategy(
      ProtoInjector protoInj, List<BindingWithVisibility> bwv) {
    var len = bwv.length;
    this.bindings = ListWrapper.createFixedSize(len);
    this.keyIds = ListWrapper.createFixedSize(len);
    this.visibilities = ListWrapper.createFixedSize(len);
    for (var i = 0; i < len; i++) {
      this.bindings[i] = bwv[i].binding;
      this.keyIds[i] = bwv[i].getKeyId();
      this.visibilities[i] = bwv[i].visibility;
    }
  }
  dynamic getBindingAtIndex(num index) {
    if (index < 0 || index >= this.bindings.length) {
      throw new OutOfBoundsError(index);
    }
    return this.bindings[index];
  }
  InjectorStrategy createInjectorStrategy(Injector ei) {
    return new InjectorDynamicStrategy(this, ei);
  }
}
class ProtoInjector {
  ProtoInjectorStrategy _strategy;
  num numberOfBindings;
  ProtoInjector(List<BindingWithVisibility> bwv) {
    this.numberOfBindings = bwv.length;
    this._strategy = bwv.length > _MAX_CONSTRUCTION_COUNTER
        ? new ProtoInjectorDynamicStrategy(this, bwv)
        : new ProtoInjectorInlineStrategy(this, bwv);
  }
  dynamic getBindingAtIndex(num index) {
    return this._strategy.getBindingAtIndex(index);
  }
}
abstract class InjectorStrategy {
  dynamic getObjByKeyId(num keyId, num visibility);
  dynamic getObjAtIndex(num index);
  num getMaxNumberOfObjects();
  void attach(Injector parent, bool isHost);
  void resetConstructionCounter();
  dynamic instantiateBinding(ResolvedBinding binding, num visibility);
}
class InjectorInlineStrategy implements InjectorStrategy {
  Injector injector;
  ProtoInjectorInlineStrategy protoStrategy;
  dynamic obj0 = undefinedValue;
  dynamic obj1 = undefinedValue;
  dynamic obj2 = undefinedValue;
  dynamic obj3 = undefinedValue;
  dynamic obj4 = undefinedValue;
  dynamic obj5 = undefinedValue;
  dynamic obj6 = undefinedValue;
  dynamic obj7 = undefinedValue;
  dynamic obj8 = undefinedValue;
  dynamic obj9 = undefinedValue;
  InjectorInlineStrategy(this.injector, this.protoStrategy) {}
  void resetConstructionCounter() {
    this.injector._constructionCounter = 0;
  }
  dynamic instantiateBinding(ResolvedBinding binding, num visibility) {
    return this.injector._new(binding, visibility);
  }
  void attach(Injector parent, bool isHost) {
    var inj = this.injector;
    inj._parent = parent;
    inj._isHost = isHost;
  }
  dynamic getObjByKeyId(num keyId, num visibility) {
    var p = this.protoStrategy;
    var inj = this.injector;
    if (identical(p.keyId0, keyId) && (p.visibility0 & visibility) > 0) {
      if (identical(this.obj0, undefinedValue)) {
        this.obj0 = inj._new(p.binding0, p.visibility0);
      }
      return this.obj0;
    }
    if (identical(p.keyId1, keyId) && (p.visibility1 & visibility) > 0) {
      if (identical(this.obj1, undefinedValue)) {
        this.obj1 = inj._new(p.binding1, p.visibility1);
      }
      return this.obj1;
    }
    if (identical(p.keyId2, keyId) && (p.visibility2 & visibility) > 0) {
      if (identical(this.obj2, undefinedValue)) {
        this.obj2 = inj._new(p.binding2, p.visibility2);
      }
      return this.obj2;
    }
    if (identical(p.keyId3, keyId) && (p.visibility3 & visibility) > 0) {
      if (identical(this.obj3, undefinedValue)) {
        this.obj3 = inj._new(p.binding3, p.visibility3);
      }
      return this.obj3;
    }
    if (identical(p.keyId4, keyId) && (p.visibility4 & visibility) > 0) {
      if (identical(this.obj4, undefinedValue)) {
        this.obj4 = inj._new(p.binding4, p.visibility4);
      }
      return this.obj4;
    }
    if (identical(p.keyId5, keyId) && (p.visibility5 & visibility) > 0) {
      if (identical(this.obj5, undefinedValue)) {
        this.obj5 = inj._new(p.binding5, p.visibility5);
      }
      return this.obj5;
    }
    if (identical(p.keyId6, keyId) && (p.visibility6 & visibility) > 0) {
      if (identical(this.obj6, undefinedValue)) {
        this.obj6 = inj._new(p.binding6, p.visibility6);
      }
      return this.obj6;
    }
    if (identical(p.keyId7, keyId) && (p.visibility7 & visibility) > 0) {
      if (identical(this.obj7, undefinedValue)) {
        this.obj7 = inj._new(p.binding7, p.visibility7);
      }
      return this.obj7;
    }
    if (identical(p.keyId8, keyId) && (p.visibility8 & visibility) > 0) {
      if (identical(this.obj8, undefinedValue)) {
        this.obj8 = inj._new(p.binding8, p.visibility8);
      }
      return this.obj8;
    }
    if (identical(p.keyId9, keyId) && (p.visibility9 & visibility) > 0) {
      if (identical(this.obj9, undefinedValue)) {
        this.obj9 = inj._new(p.binding9, p.visibility9);
      }
      return this.obj9;
    }
    return undefinedValue;
  }
  dynamic getObjAtIndex(num index) {
    if (index == 0) return this.obj0;
    if (index == 1) return this.obj1;
    if (index == 2) return this.obj2;
    if (index == 3) return this.obj3;
    if (index == 4) return this.obj4;
    if (index == 5) return this.obj5;
    if (index == 6) return this.obj6;
    if (index == 7) return this.obj7;
    if (index == 8) return this.obj8;
    if (index == 9) return this.obj9;
    throw new OutOfBoundsError(index);
  }
  num getMaxNumberOfObjects() {
    return _MAX_CONSTRUCTION_COUNTER;
  }
}
class InjectorDynamicStrategy implements InjectorStrategy {
  ProtoInjectorDynamicStrategy protoStrategy;
  Injector injector;
  List<dynamic> objs;
  InjectorDynamicStrategy(this.protoStrategy, this.injector) {
    this.objs = ListWrapper.createFixedSize(protoStrategy.bindings.length);
    ListWrapper.fill(this.objs, undefinedValue);
  }
  void resetConstructionCounter() {
    this.injector._constructionCounter = 0;
  }
  dynamic instantiateBinding(ResolvedBinding binding, num visibility) {
    return this.injector._new(binding, visibility);
  }
  void attach(Injector parent, bool isHost) {
    var inj = this.injector;
    inj._parent = parent;
    inj._isHost = isHost;
  }
  dynamic getObjByKeyId(num keyId, num visibility) {
    var p = this.protoStrategy;
    for (var i = 0; i < p.keyIds.length; i++) {
      if (identical(p.keyIds[i], keyId) &&
          (p.visibilities[i] & visibility) > 0) {
        if (identical(this.objs[i], undefinedValue)) {
          this.objs[i] = this.injector._new(p.bindings[i], p.visibilities[i]);
        }
        return this.objs[i];
      }
    }
    return undefinedValue;
  }
  dynamic getObjAtIndex(num index) {
    if (index < 0 || index >= this.objs.length) {
      throw new OutOfBoundsError(index);
    }
    return this.objs[index];
  }
  num getMaxNumberOfObjects() {
    return this.objs.length;
  }
}
class BindingWithVisibility {
  ResolvedBinding binding;
  num visibility;
  BindingWithVisibility(this.binding, this.visibility) {}
  num getKeyId() {
    return this.binding.key.id;
  }
}
/**
 * Used to provide dependencies that cannot be easily expressed as bindings.
 */
abstract class DependencyProvider {
  dynamic getDependency(
      Injector injector, ResolvedBinding binding, Dependency dependency);
}
/**
 * A dependency injection container used for resolving dependencies.
 *
 * An `Injector` is a replacement for a `new` operator, which can automatically resolve the
 * constructor dependencies.
 * In typical use, application code asks for the dependencies in the constructor and they are
 * resolved by the `Injector`.
 *
 * ## Example:
 *
 * Suppose that we want to inject an `Engine` into class `Car`, we would define it like this:
 *
 * ```javascript
 * class Engine {
 * }
 *
 * class Car {
 *   constructor(@Inject(Engine) engine) {
 *   }
 * }
 *
 * ```
 *
 * Next we need to write the code that creates and instantiates the `Injector`. We then ask for the
 * `root` object, `Car`, so that the `Injector` can recursively build all of that object's
 *dependencies.
 *
 * ```javascript
 * main() {
 *   var injector = Injector.resolveAndCreate([Car, Engine]);
 *
 *   // Get a reference to the `root` object, which will recursively instantiate the tree.
 *   var car = injector.get(Car);
 * }
 * ```
 * Notice that we don't use the `new` operator because we explicitly want to have the `Injector`
 * resolve all of the object's dependencies automatically.
 */
class Injector {
  ProtoInjector _proto;
  Injector _parent;
  DependencyProvider _depProvider;
  Function _debugContext;
  /**
   * Turns a list of binding definitions into an internal resolved list of resolved bindings.
   *
   * A resolution is a process of flattening multiple nested lists and converting individual
   * bindings into a list of {@link ResolvedBinding}s. The resolution can be cached by `resolve`
   * for the {@link Injector} for performance-sensitive code.
   *
   * @param `bindings` can be a list of `Type`, {@link Binding}, {@link ResolvedBinding}, or a
   * recursive list of more bindings.
   *
   * The returned list is sparse, indexed by `id` for the {@link Key}. It is generally not useful to
   *application code
   * other than for passing it to {@link Injector} functions that require resolved binding lists,
   *such as
   * `fromResolvedBindings` and `createChildFromResolved`.
   */
  static List<ResolvedBinding> resolve(
      List<dynamic /* Type | Binding | List < dynamic > */ > bindings) {
    var resolvedBindings = _resolveBindings(bindings);
    var flatten = _flattenBindings(resolvedBindings, new Map());
    return _createListOfBindings(flatten);
  }
  /**
   * Resolves bindings and creates an injector based on those bindings. This function is slower than
   * the corresponding `fromResolvedBindings` because it needs to resolve bindings first. See
   *`resolve`
   * for the {@link Injector}.
   *
   * Prefer `fromResolvedBindings` in performance-critical code that creates lots of injectors.
   *
   * @param `bindings` can be a list of `Type`, {@link Binding}, {@link ResolvedBinding}, or a
   *recursive list of more
   * bindings.
   * @param `depProvider`
   */
  static Injector resolveAndCreate(
      List<dynamic /* Type | Binding | List < dynamic > */ > bindings,
      [DependencyProvider depProvider = null]) {
    var resolvedBindings = Injector.resolve(bindings);
    return Injector.fromResolvedBindings(resolvedBindings, depProvider);
  }
  /**
   * Creates an injector from previously resolved bindings. This bypasses resolution and flattening.
   * This API is the recommended way to construct injectors in performance-sensitive parts.
   *
   * @param `bindings` A sparse list of {@link ResolvedBinding}s. See `resolve` for the
   * {@link Injector}.
   * @param `depProvider`
   */
  static Injector fromResolvedBindings(List<ResolvedBinding> bindings,
      [DependencyProvider depProvider = null]) {
    var bd = bindings.map((b) => new BindingWithVisibility(b, PUBLIC)).toList();
    var proto = new ProtoInjector(bd);
    var inj = new Injector(proto, null, depProvider);
    return inj;
  }
  InjectorStrategy _strategy;
  bool _isHost = false;
  num _constructionCounter = 0;
  Injector(this._proto, [this._parent = null, this._depProvider = null,
      this._debugContext = null]) {
    this._strategy = _proto._strategy.createInjectorStrategy(this);
  }
  /**
   * Returns debug information about the injector.
   *
   * This information is included into exceptions thrown by the injector.
   */
  dynamic debugContext() {
    return this._debugContext();
  }
  /**
   * Retrieves an instance from the injector.
   *
   * @param `token`: usually the `Type` of an object. (Same as the token used while setting up a
   *binding).
   * @returns an instance represented by the token. Throws if not found.
   */
  dynamic get(dynamic token) {
    return this._getByKey(
        Key.get(token), null, null, false, PUBLIC_AND_PRIVATE);
  }
  /**
   * Retrieves an instance from the injector.
   *
   * @param `token`: usually a `Type`. (Same as the token used while setting up a binding).
   * @returns an instance represented by the token. Returns `null` if not found.
   */
  dynamic getOptional(dynamic token) {
    return this._getByKey(Key.get(token), null, null, true, PUBLIC_AND_PRIVATE);
  }
  /**
   * Retrieves an instance from the injector.
   *
   * @param `index`: index of an instance.
   * @returns an instance represented by the index. Throws if not found.
   */
  dynamic getAt(num index) {
    return this._strategy.getObjAtIndex(index);
  }
  /**
   * Direct parent of this injector.
   */
  Injector get parent {
    return this._parent;
  }
  /**
   * Internal. Do not use.
   *
   * We return `any` not to export the InjectorStrategy type.
   */
  dynamic get internalStrategy {
    return this._strategy;
  }
  /**
  * Creates a child injector and loads a new set of bindings into it.
  *
  * A resolution is a process of flattening multiple nested lists and converting individual
  * bindings into a list of {@link ResolvedBinding}s. The resolution can be cached by `resolve`
  * for the {@link Injector} for performance-sensitive code.
  *
  * @param `bindings` can be a list of `Type`, {@link Binding}, {@link ResolvedBinding}, or a
  * recursive list of more bindings.
  * @param `depProvider`
  */
  Injector resolveAndCreateChild(
      List<dynamic /* Type | Binding | List < dynamic > */ > bindings,
      [DependencyProvider depProvider = null]) {
    var resovledBindings = Injector.resolve(bindings);
    return this.createChildFromResolved(resovledBindings, depProvider);
  }
  /**
   * Creates a child injector and loads a new set of {@link ResolvedBinding}s into it.
   *
   * @param `bindings`: A sparse list of {@link ResolvedBinding}s.
   * See `resolve` for the {@link Injector}.
   * @param `depProvider`
   * @returns a new child {@link Injector}.
   */
  Injector createChildFromResolved(List<ResolvedBinding> bindings,
      [DependencyProvider depProvider = null]) {
    var bd = bindings.map((b) => new BindingWithVisibility(b, PUBLIC)).toList();
    var proto = new ProtoInjector(bd);
    var inj = new Injector(proto, null, depProvider);
    inj._parent = this;
    return inj;
  }
  dynamic _new(ResolvedBinding binding, num visibility) {
    if (this._constructionCounter++ > this._strategy.getMaxNumberOfObjects()) {
      throw new CyclicDependencyError(this, binding.key);
    }
    var factory = binding.factory;
    var deps = binding.dependencies;
    var length = deps.length;
    var d0,
        d1,
        d2,
        d3,
        d4,
        d5,
        d6,
        d7,
        d8,
        d9,
        d10,
        d11,
        d12,
        d13,
        d14,
        d15,
        d16,
        d17,
        d18,
        d19;
    try {
      d0 = length > 0
          ? this._getByDependency(binding, deps[0], visibility)
          : null;
      d1 = length > 1
          ? this._getByDependency(binding, deps[1], visibility)
          : null;
      d2 = length > 2
          ? this._getByDependency(binding, deps[2], visibility)
          : null;
      d3 = length > 3
          ? this._getByDependency(binding, deps[3], visibility)
          : null;
      d4 = length > 4
          ? this._getByDependency(binding, deps[4], visibility)
          : null;
      d5 = length > 5
          ? this._getByDependency(binding, deps[5], visibility)
          : null;
      d6 = length > 6
          ? this._getByDependency(binding, deps[6], visibility)
          : null;
      d7 = length > 7
          ? this._getByDependency(binding, deps[7], visibility)
          : null;
      d8 = length > 8
          ? this._getByDependency(binding, deps[8], visibility)
          : null;
      d9 = length > 9
          ? this._getByDependency(binding, deps[9], visibility)
          : null;
      d10 = length > 10
          ? this._getByDependency(binding, deps[10], visibility)
          : null;
      d11 = length > 11
          ? this._getByDependency(binding, deps[11], visibility)
          : null;
      d12 = length > 12
          ? this._getByDependency(binding, deps[12], visibility)
          : null;
      d13 = length > 13
          ? this._getByDependency(binding, deps[13], visibility)
          : null;
      d14 = length > 14
          ? this._getByDependency(binding, deps[14], visibility)
          : null;
      d15 = length > 15
          ? this._getByDependency(binding, deps[15], visibility)
          : null;
      d16 = length > 16
          ? this._getByDependency(binding, deps[16], visibility)
          : null;
      d17 = length > 17
          ? this._getByDependency(binding, deps[17], visibility)
          : null;
      d18 = length > 18
          ? this._getByDependency(binding, deps[18], visibility)
          : null;
      d19 = length > 19
          ? this._getByDependency(binding, deps[19], visibility)
          : null;
    } catch (e, e_stack) {
      if (e is AbstractBindingError) {
        e.addKey(this, binding.key);
      }
      rethrow;
    }
    var obj;
    try {
      switch (length) {
        case 0:
          obj = factory();
          break;
        case 1:
          obj = factory(d0);
          break;
        case 2:
          obj = factory(d0, d1);
          break;
        case 3:
          obj = factory(d0, d1, d2);
          break;
        case 4:
          obj = factory(d0, d1, d2, d3);
          break;
        case 5:
          obj = factory(d0, d1, d2, d3, d4);
          break;
        case 6:
          obj = factory(d0, d1, d2, d3, d4, d5);
          break;
        case 7:
          obj = factory(d0, d1, d2, d3, d4, d5, d6);
          break;
        case 8:
          obj = factory(d0, d1, d2, d3, d4, d5, d6, d7);
          break;
        case 9:
          obj = factory(d0, d1, d2, d3, d4, d5, d6, d7, d8);
          break;
        case 10:
          obj = factory(d0, d1, d2, d3, d4, d5, d6, d7, d8, d9);
          break;
        case 11:
          obj = factory(d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10);
          break;
        case 12:
          obj = factory(d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11);
          break;
        case 13:
          obj = factory(d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12);
          break;
        case 14:
          obj = factory(
              d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13);
          break;
        case 15:
          obj = factory(
              d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14);
          break;
        case 16:
          obj = factory(d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12,
              d13, d14, d15);
          break;
        case 17:
          obj = factory(d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12,
              d13, d14, d15, d16);
          break;
        case 18:
          obj = factory(d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12,
              d13, d14, d15, d16, d17);
          break;
        case 19:
          obj = factory(d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12,
              d13, d14, d15, d16, d17, d18);
          break;
        case 20:
          obj = factory(d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12,
              d13, d14, d15, d16, d17, d18, d19);
          break;
      }
    } catch (e, e_stack) {
      throw new InstantiationError(this, e, e_stack, binding.key);
    }
    return obj;
  }
  dynamic _getByDependency(
      ResolvedBinding binding, Dependency dep, num bindingVisibility) {
    var special = isPresent(this._depProvider)
        ? this._depProvider.getDependency(this, binding, dep)
        : undefinedValue;
    if (!identical(special, undefinedValue)) {
      return special;
    } else {
      return this._getByKey(dep.key, dep.lowerBoundVisibility,
          dep.upperBoundVisibility, dep.optional, bindingVisibility);
    }
  }
  dynamic _getByKey(Key key, Object lowerBoundVisibility,
      Object upperBoundVisibility, bool optional, num bindingVisibility) {
    if (identical(key, INJECTOR_KEY)) {
      return this;
    }
    if (upperBoundVisibility is SelfMetadata) {
      return this._getByKeySelf(key, optional, bindingVisibility);
    } else if (upperBoundVisibility is HostMetadata) {
      return this._getByKeyHost(
          key, optional, bindingVisibility, lowerBoundVisibility);
    } else {
      return this._getByKeyDefault(
          key, optional, bindingVisibility, lowerBoundVisibility);
    }
  }
  dynamic _throwOrNull(Key key, bool optional) {
    if (optional) {
      return null;
    } else {
      throw new NoBindingError(this, key);
    }
  }
  dynamic _getByKeySelf(Key key, bool optional, num bindingVisibility) {
    var obj = this._strategy.getObjByKeyId(key.id, bindingVisibility);
    return (!identical(obj, undefinedValue))
        ? obj
        : this._throwOrNull(key, optional);
  }
  dynamic _getByKeyHost(Key key, bool optional, num bindingVisibility,
      Object lowerBoundVisibility) {
    var inj = this;
    if (lowerBoundVisibility is SkipSelfMetadata) {
      if (inj._isHost) {
        return this._getPrivateDependency(key, optional, inj);
      } else {
        inj = inj._parent;
      }
    }
    while (inj != null) {
      var obj = inj._strategy.getObjByKeyId(key.id, bindingVisibility);
      if (!identical(obj, undefinedValue)) return obj;
      if (isPresent(inj._parent) && inj._isHost) {
        return this._getPrivateDependency(key, optional, inj);
      } else {
        inj = inj._parent;
      }
    }
    return this._throwOrNull(key, optional);
  }
  dynamic _getPrivateDependency(Key key, bool optional, Injector inj) {
    var obj = inj._parent._strategy.getObjByKeyId(key.id, PRIVATE);
    return (!identical(obj, undefinedValue))
        ? obj
        : this._throwOrNull(key, optional);
  }
  dynamic _getByKeyDefault(Key key, bool optional, num bindingVisibility,
      Object lowerBoundVisibility) {
    var inj = this;
    if (lowerBoundVisibility is SkipSelfMetadata) {
      bindingVisibility = inj._isHost ? PUBLIC_AND_PRIVATE : PUBLIC;
      inj = inj._parent;
    }
    while (inj != null) {
      var obj = inj._strategy.getObjByKeyId(key.id, bindingVisibility);
      if (!identical(obj, undefinedValue)) return obj;
      bindingVisibility = inj._isHost ? PUBLIC_AND_PRIVATE : PUBLIC;
      inj = inj._parent;
    }
    return this._throwOrNull(key, optional);
  }
  String get displayName {
    return '''Injector(bindings: [${ _mapBindings ( this , ( b ) => ''' "${ b . key . displayName}" ''' ) . join ( ", " )}])''';
  }
  String toString() {
    return this.displayName;
  }
}
var INJECTOR_KEY = Key.get(Injector);
List<ResolvedBinding> _resolveBindings(
    List<dynamic /* Type | Binding | List < dynamic > */ > bindings) {
  var resolvedList = ListWrapper.createFixedSize(bindings.length);
  for (var i = 0; i < bindings.length; i++) {
    var unresolved = resolveForwardRef(bindings[i]);
    var resolved;
    if (unresolved is ResolvedBinding) {
      resolved = unresolved;
    } else if (unresolved is Type) {
      resolved = bind(unresolved).toClass(unresolved).resolve();
    } else if (unresolved is Binding) {
      resolved = unresolved.resolve();
    } else if (unresolved is List) {
      resolved = _resolveBindings(unresolved);
    } else if (unresolved is BindingBuilder) {
      throw new InvalidBindingError(unresolved.token);
    } else {
      throw new InvalidBindingError(unresolved);
    }
    resolvedList[i] = resolved;
  }
  return resolvedList;
}
List<ResolvedBinding> _createListOfBindings(
    Map<num, ResolvedBinding> flattenedBindings) {
  return MapWrapper.values(flattenedBindings);
}
Map<num, ResolvedBinding> _flattenBindings(
    List<dynamic /* ResolvedBinding | List < dynamic > */ > bindings,
    Map<num, ResolvedBinding> res) {
  ListWrapper.forEach(bindings, (b) {
    if (b is ResolvedBinding) {
      res[b.key.id] = b;
    } else if (b is List) {
      _flattenBindings(b, res);
    }
  });
  return res;
}
List<dynamic> _mapBindings(Injector injector, Function fn) {
  var res = [];
  for (var i = 0; i < injector._proto.numberOfBindings; ++i) {
    res.add(fn(injector._proto.getBindingAtIndex(i)));
  }
  return res;
}
