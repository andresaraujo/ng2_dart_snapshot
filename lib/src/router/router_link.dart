library angular2.src.router.router_link;

import "package:angular2/src/core/annotations/decorators.dart" show Directive;
import "package:angular2/src/facade/collection.dart"
    show List, Map, StringMapWrapper;
import "router.dart" show Router;
import "location.dart" show Location;

/**
 * The RouterLink directive lets you link to specific parts of your app.
 *
 * Consider the following route configuration:

 * ```
 * @RouteConfig({
 *   path: '/user', component: UserCmp, as: 'user'
 * });
 * class MyComp {}
 * ```
 *
 * When linking to this `user` route, you can write:
 *
 * ```
 * <a [router-link]="['./user']">link to user component</a>
 * ```
 *
 * RouterLink expects the value to be an array of route names, followed by the params
 * for that level of routing. For instance `['/team', {teamId: 1}, 'user', {userId: 2}]`
 * means that we want to generate a link for the `team` route with params `{teamId: 1}`,
 * and with a child route `user` with params `{userId: 2}`.
 *
 * The first route name should be prepended with `/`, `./`, or `../`.
 * If the route begins with `/`, the router will look up the route from the root of the app.
 * If the route begins with `./`, the router will instead look in the current component's
 * children for the route. And if the route begins with `../`, the router will look at the
 * current component's parent.
 */
@Directive(
    selector: "[router-link]",
    properties: const ["routeParams: routerLink"],
    host: const {"(^click)": "onClick()", "[attr.href]": "visibleHref"})
class RouterLink {
  Router _router;
  Location _location;
  List<dynamic> _routeParams;
  // the url displayed on the anchor element.
  String visibleHref;
  // the url passed to the router navigation.
  String _navigationHref;
  RouterLink(this._router, this._location) {}
  set routeParams(List<dynamic> changes) {
    this._routeParams = changes;
    this._navigationHref = this._router.generate(this._routeParams);
    this.visibleHref = this._location.normalizeAbsolutely(this._navigationHref);
  }
  bool onClick() {
    this._router.navigate(this._navigationHref);
    return false;
  }
}
