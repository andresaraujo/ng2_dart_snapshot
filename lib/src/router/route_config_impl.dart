library angular2.src.router.route_config_impl;

import "package:angular2/src/facade/collection.dart" show List, Map;

/**
 * You use the RouteConfig annotation to add routes to a component.
 *
 * Supported keys:
 * - `path` (required)
 * - `component`,  `redirectTo` (requires exactly one of these)
 * - `as` (optional)
 */
class RouteConfig {
  final List<Map<dynamic, dynamic>> configs;
  const RouteConfig(this.configs);
}
