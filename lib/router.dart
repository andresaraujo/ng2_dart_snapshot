/**
 * @module
 * @description
 * Maps application URLs into application states, to support deep-linking and navigation.
 */
library angular2.router;

export "src/router/router.dart" show Router, RootRouter;
export "src/router/router_outlet.dart" show RouterOutlet;
export "src/router/router_link.dart" show RouterLink;
export "src/router/instruction.dart" show RouteParams;
export "src/router/route_registry.dart" show RouteRegistry;
export "src/router/location_strategy.dart" show LocationStrategy;
export "src/router/hash_location_strategy.dart" show HashLocationStrategy;
export "src/router/html5_location_strategy.dart" show HTML5LocationStrategy;
export "src/router/location.dart" show Location, appBaseHrefToken;
export "src/router/pipeline.dart" show Pipeline;
export "src/router/route_config_decorator.dart";
export "src/router/interfaces.dart"
    show OnActivate, OnDeactivate, OnReuse, CanDeactivate, CanReuse;
export "src/router/lifecycle_annotations.dart" show CanActivate;
import "src/router/location_strategy.dart" show LocationStrategy;
import "src/router/html5_location_strategy.dart" show HTML5LocationStrategy;
import "src/router/router.dart" show Router, RootRouter;
import "src/router/router_outlet.dart" show RouterOutlet;
import "src/router/router_link.dart" show RouterLink;
import "src/router/route_registry.dart" show RouteRegistry;
import "src/router/pipeline.dart" show Pipeline;
import "src/router/location.dart" show Location;
import "src/core/application_tokens.dart" show appComponentTypeToken;
import "di.dart" show bind;
import "src/facade/collection.dart" show List;

const List<dynamic> routerDirectives = const [RouterOutlet, RouterLink];
List<dynamic> routerInjectables = [
  RouteRegistry,
  Pipeline,
  bind(LocationStrategy).toClass(HTML5LocationStrategy),
  Location,
  bind(Router).toFactory((registry, pipeline, location, appRoot) {
    return new RootRouter(registry, pipeline, location, appRoot);
  }, [RouteRegistry, Pipeline, Location, appComponentTypeToken])
];
