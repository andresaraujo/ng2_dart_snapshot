library angular2.src.directives.ng_non_bindable;

import "package:angular2/annotations.dart" show Directive;

/**
 * The `NgNonBindable` directive tells Angular not to compile or bind the contents of the current
 * DOM element. This is useful if the element contains what appears to be Angular directives and
 * bindings but which should be ignored by Angular. This could be the case if you have a site that
 * displays snippets of code, for instance.
 *
 * Example:
 *
 * ```
 * <div>Normal: {{1 + 2}}</div> // output "Normal: 3"
 * <div non-bindable>Ignored: {{1 + 2}}</div> // output "Ignored: {{1 + 2}}"
 * ```
 */
@Directive(selector: "[ng-non-bindable]", compileChildren: false)
class NgNonBindable {}
