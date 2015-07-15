library angular2.src.core.annotations_impl.view;

import "package:angular2/src/facade/lang.dart" show Type;

/**
 * Declares the available HTML templates for an application.
 *
 * Each angular component requires a single `@Component` and at least one `@View` annotation. The
 * `@View` annotation specifies the HTML template to use, and lists the directives that are active
 * within the template.
 *
 * When a component is instantiated, the template is loaded into the component's shadow root, and
 * the expressions and statements in the template are evaluated against the component.
 *
 * For details on the `@Component` annotation, see {@link Component}.
 *
 * ## Example
 *
 * ```
 * @Component({
 *   selector: 'greet'
 * })
 * @View({
 *   template: 'Hello {{name}}!',
 *   directives: [GreetUser, Bold]
 * })
 * class Greet {
 *   name: string;
 *
 *   constructor() {
 *     this.name = 'World';
 *   }
 * }
 * ```
 */
class View {
  /**
   * Specifies an inline template for an angular component.
   *
   * NOTE: either `templateUrl` or `template` should be used, but not both.
   */
  final String templateUrl;
  /**
   * Specifies a template URL for an angular component.
   *
   * NOTE: either `templateUrl` or `template` should be used, but not both.
   */
  final String template;
  /**
   * Specifies stylesheet URLs for an angular component.
   */
  final List<String> styleUrls;
  /**
   * Specifies an inline stylesheet for an angular component.
   */
  final List<String> styles;
  /**
   * Specifies a list of directives that can be used within a template.
   *
   * Directives must be listed explicitly to provide proper component encapsulation.
   *
   * ## Example
   *
   * ```javascript
   * @Component({
   *     selector: 'my-component'
   *   })
   * @View({
   *   directives: [For]
   *   template: '
   *   <ul>
   *     <li *ng-for="#item of items">{{item}}</li>
   *   </ul>'
   * })
   * class MyComponent {
   * }
   * ```
   */

  // TODO(tbosch): use Type | Binding | List<any> when Dart supports union types,

  // as otherwise we would need to import Binding type and Dart would warn

  // for an unused import.
  final List<dynamic /* Type | dynamic | List < dynamic > */ > directives;
  /**
   * Specify a custom renderer for this View.
   * If this is set, neither `template`, `templateUrl`, `styles`, `styleUrls` nor `directives` are
   * used.
   */
  final String renderer;
  const View({templateUrl, template, directives, renderer, styles, styleUrls})
      : templateUrl = templateUrl,
        template = template,
        styleUrls = styleUrls,
        styles = styles,
        directives = directives,
        renderer = renderer;
}
