library angular2.src.di.key;

import "package:angular2/src/facade/collection.dart" show MapWrapper;
import "package:angular2/src/facade/lang.dart"
    show stringify, Type, isBlank, BaseException;
import "type_literal.dart" show TypeLiteral;
import "forward_ref.dart" show resolveForwardRef;
export "type_literal.dart" show TypeLiteral;

/**
 * A unique object used for retrieving items from the {@link Injector}.
 *
 * Keys have:
 * - a system-wide unique `id`.
 * - a `token`, usually the `Type` of the instance.
 *
 * Keys are used internally by the {@link Injector} because their system-wide unique `id`s allow the
 * injector to index in arrays rather than looking up items in maps.
 */
class Key {
  Object token;
  num id;
  /**
   * @private
   */
  Key(this.token, this.id) {
    if (isBlank(token)) {
      throw new BaseException("Token must be defined!");
    }
  }
  String get displayName {
    return stringify(this.token);
  }
  /**
   * Retrieves a `Key` for a token.
   */
  static Key get(Object token) {
    return _globalKeyRegistry.get(resolveForwardRef(token));
  }
  /**
   * @returns the number of keys registered in the system.
   */
  static num get numberOfKeys {
    return _globalKeyRegistry.numberOfKeys;
  }
}
/**
 * @private
 */
class KeyRegistry {
  Map<Object, Key> _allKeys = new Map();
  Key get(Object token) {
    if (token is Key) return token;
    // TODO: workaround for https://github.com/Microsoft/TypeScript/issues/3123
    var theToken = token;
    if (token is TypeLiteral) {
      theToken = token.type;
    }
    token = theToken;
    if (this._allKeys.containsKey(token)) {
      return this._allKeys[token];
    }
    var newKey = new Key(token, Key.numberOfKeys);
    this._allKeys[token] = newKey;
    return newKey;
  }
  num get numberOfKeys {
    return MapWrapper.size(this._allKeys);
  }
}
var _globalKeyRegistry = new KeyRegistry();
