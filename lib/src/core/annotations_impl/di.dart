library angular2.src.core.annotations_impl.di;

import "package:angular2/src/facade/lang.dart"
    show Type, stringify, isPresent, StringWrapper, isString;
import "package:angular2/src/di/metadata.dart" show DependencyMetadata;
import "package:angular2/di.dart" show resolveForwardRef;

/**
 * Specifies that a constant attribute value should be injected.
 *
 * The directive can inject constant string literals of host element attributes.
 *
 * ## Example
 *
 * Suppose we have an `<input>` element and want to know its `type`.
 *
 * ```html
 * <input type="text">
 * ```
 *
 * A decorator can inject string literal `text` like so:
 *
 * ```javascript
 * @Directive({
 *   selector: `input'
 * })
 * class InputDirective {
 *   constructor(@Attribute('type') type) {
 *     // type would be `text` in this example
 *   }
 * }
 * ```
 */
class Attribute extends DependencyMetadata {
  final String attributeName;
  const Attribute(this.attributeName) : super();
  get token {
    // Normally one would default a token to a type of an injected value but here

    // the type of a variable is "string" and we can't use primitive type as a return value

    // so we use instance of Attribute instead. This doesn't matter much in practice as arguments

    // with @Attribute annotation are injected by ElementInjector that doesn't take tokens into

    // account.
    return this;
  }
  String toString() {
    return '''@Attribute(${ stringify ( this . attributeName )})''';
  }
}
/**
 * Specifies that a {@link QueryList} should be injected.
 *
 * See {@link QueryList} for usage and example.
 */
class Query extends DependencyMetadata {
  final dynamic /* Type | String */ _selector;
  final bool descendants;
  const Query(this._selector, {descendants: false})
      : descendants = descendants,
        super();
  get isViewQuery {
    return false;
  }
  get selector {
    return resolveForwardRef(this._selector);
  }
  bool get isVarBindingQuery {
    return isString(this.selector);
  }
  List<String> get varBindings {
    return StringWrapper.split(this.selector, new RegExp(","));
  }
  String toString() {
    return '''@Query(${ stringify ( this . selector )})''';
  }
}
/**
 * Specifies that a {@link QueryList} should be injected.
 *
 * See {@link QueryList} for usage and example.
 *
 * @exportedAs angular2/annotations
 */
class ViewQuery extends Query {
  const ViewQuery(dynamic /* Type | String */ _selector, {descendants: false})
      : super(_selector, descendants: descendants);
  get isViewQuery {
    return true;
  }
  String toString() {
    return '''@ViewQuery(${ stringify ( this . selector )})''';
  }
}
