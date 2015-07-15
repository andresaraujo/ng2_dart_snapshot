library angular2.src.router.router;

import "package:angular2/src/facade/async.dart"
    show Future, PromiseWrapper, EventEmitter, ObservableWrapper;
import "package:angular2/src/facade/collection.dart"
    show Map, MapWrapper, List, ListWrapper;
import "package:angular2/src/facade/lang.dart"
    show
        isBlank,
        isString,
        StringWrapper,
        isPresent,
        Type,
        isArray,
        BaseException;
import "route_registry.dart" show RouteRegistry;
import "pipeline.dart" show Pipeline;
import "instruction.dart" show Instruction;
import "router_outlet.dart" show RouterOutlet;
import "location.dart" show Location;
import "route_lifecycle_reflector.dart" show getCanActivateHook;

var _resolveToTrue = PromiseWrapper.resolve(true);
var _resolveToFalse = PromiseWrapper.resolve(false);
/**
 * # Router
 * The router is responsible for mapping URLs to components.
 *
 * You can see the state of the router by inspecting the read-only field `router.navigating`.
 * This may be useful for showing a spinner, for instance.
 *
 * ## Concepts
 * Routers and component instances have a 1:1 correspondence.
 *
 * The router holds reference to a number of "outlets." An outlet is a placeholder that the
 * router dynamically fills in depending on the current URL.
 *
 * When the router navigates from a URL, it must first recognizes it and serialize it into an
 * `Instruction`.
 * The router uses the `RouteRegistry` to get an `Instruction`.
 */
class Router {
  RouteRegistry registry;
  Pipeline _pipeline;
  Router parent;
  dynamic hostComponent;
  bool navigating = false;
  String lastNavigationAttempt;
  Instruction _currentInstruction = null;
  Future<dynamic> _currentNavigation = _resolveToTrue;
  RouterOutlet _outlet = null;
  EventEmitter _subject = new EventEmitter();
  // todo(jeffbcross): rename _registry to registry since it is accessed from subclasses

  // todo(jeffbcross): rename _pipeline to pipeline since it is accessed from subclasses
  Router(this.registry, this._pipeline, this.parent, this.hostComponent) {}
  /**
   * Constructs a child router. You probably don't need to use this unless you're writing a reusable
   * component.
   */
  Router childRouter(dynamic hostComponent) {
    return new ChildRouter(this, hostComponent);
  }
  /**
   * Register an object to notify of route changes. You probably don't need to use this unless
   * you're writing a reusable component.
   */
  Future<bool> registerOutlet(RouterOutlet outlet) {
    // TODO: sibling routes
    this._outlet = outlet;
    if (isPresent(this._currentInstruction)) {
      return outlet.commit(this._currentInstruction);
    }
    return _resolveToTrue;
  }
  /**
   * Dynamically update the routing configuration and trigger a navigation.
   *
   * # Usage
   *
   * ```
   * router.config({ 'path': '/', 'component': IndexCmp});
   * ```
   *
   * Or:
   *
   * ```
   * router.config([
   *   { 'path': '/', 'component': IndexComp },
   *   { 'path': '/user/:id', 'component': UserComp },
   * ]);
   * ```
   */
  Future<dynamic> config(
      dynamic /* Map < String , dynamic > | List < Map < String , dynamic > > */ config) {
    if (isArray(config)) {
      ((config as List<dynamic>)).forEach((configObject) {
        this.registry.config(this.hostComponent, configObject);
      });
    } else {
      this.registry.config(this.hostComponent, config);
    }
    return this.renavigate();
  }
  /**
   * Navigate to a URL. Returns a promise that resolves when navigation is complete.
   *
   * If the given URL begins with a `/`, router will navigate absolutely.
   * If the given URL does not begin with `/`, the router will navigate relative to this component.
   */
  Future<dynamic> navigate(String url) {
    return this._currentNavigation = this._currentNavigation.then((_) {
      this.lastNavigationAttempt = url;
      this._startNavigating();
      return this._afterPromiseFinishNavigating(this
          .recognize(url)
          .then((matchedInstruction) {
        if (isBlank(matchedInstruction)) {
          return false;
        }
        return this
            ._reuse(matchedInstruction)
            .then((_) => this._canActivate(matchedInstruction))
            .then((result) {
          if (!result) {
            return false;
          }
          return this._canDeactivate(matchedInstruction).then((result) {
            if (result) {
              return this.commit(matchedInstruction).then((_) {
                this._emitNavigationFinish(matchedInstruction.accumulatedUrl);
                return true;
              });
            }
          });
        });
      }));
    });
  }
  void _emitNavigationFinish(url) {
    ObservableWrapper.callNext(this._subject, url);
  }
  Future<dynamic> _afterPromiseFinishNavigating(Future<dynamic> promise) {
    return PromiseWrapper.catchError(
        promise.then((_) => this._finishNavigating()), (err) {
      this._finishNavigating();
      throw err;
    });
  }
  Future<dynamic> _reuse(instruction) {
    if (isBlank(this._outlet)) {
      return _resolveToFalse;
    }
    return this._outlet.canReuse(instruction).then((result) {
      instruction.reuse = result;
      if (isPresent(this._outlet.childRouter) && isPresent(instruction.child)) {
        return this._outlet.childRouter._reuse(instruction.child);
      }
    });
  }
  Future<bool> _canActivate(Instruction instruction) {
    return canActivateOne(instruction, this._currentInstruction);
  }
  Future<bool> _canDeactivate(Instruction instruction) {
    if (isBlank(this._outlet)) {
      return _resolveToTrue;
    }
    Future<bool> next;
    if (isPresent(instruction) && instruction.reuse) {
      next = _resolveToTrue;
    } else {
      next = this._outlet.canDeactivate(instruction);
    }
    return next.then((result) {
      if (result == false) {
        return false;
      }
      if (isPresent(this._outlet.childRouter)) {
        return this._outlet.childRouter
            ._canDeactivate(isPresent(instruction) ? instruction.child : null);
      }
      return true;
    });
  }
  /**
   * Updates this router and all descendant routers according to the given instruction
   */
  Future<dynamic> commit(Instruction instruction) {
    this._currentInstruction = instruction;
    if (isPresent(this._outlet)) {
      return this._outlet.commit(instruction);
    }
    return _resolveToTrue;
  }
  void _startNavigating() {
    this.navigating = true;
  }
  void _finishNavigating() {
    this.navigating = false;
  }
  /**
   * Subscribe to URL updates from the router
   */
  void subscribe(onNext) {
    ObservableWrapper.subscribe(this._subject, onNext);
  }
  /**
   * Removes the contents of this router's outlet and all descendant outlets
   */
  Future<dynamic> deactivate(Instruction instruction) {
    if (isPresent(this._outlet)) {
      return this._outlet.deactivate(instruction);
    }
    return _resolveToTrue;
  }
  /**
   * Given a URL, returns an instruction representing the component graph
   */
  Future<Instruction> recognize(String url) {
    return this.registry.recognize(url, this.hostComponent);
  }
  /**
   * Navigates to either the last URL successfully navigated to, or the last URL requested if the
   * router has yet to successfully navigate.
   */
  Future<dynamic> renavigate() {
    if (isBlank(this.lastNavigationAttempt)) {
      return this._currentNavigation;
    }
    return this.navigate(this.lastNavigationAttempt);
  }
  /**
   * Generate a URL from a component name and optional map of parameters. The URL is relative to the
   * app's base href.
   */
  String generate(List<dynamic> linkParams) {
    var normalizedLinkParams = splitAndFlattenLinkParams(linkParams);
    var first = ListWrapper.first(normalizedLinkParams);
    var rest = ListWrapper.slice(normalizedLinkParams, 1);
    var router = this;
    // The first segment should be either '.' (generate from parent) or '' (generate from root).

    // When we normalize above, we strip all the slashes, './' becomes '.' and '/' becomes ''.
    if (first == "") {
      while (isPresent(router.parent)) {
        router = router.parent;
      }
    } else if (first == "..") {
      router = router.parent;
      while (ListWrapper.first(rest) == "..") {
        rest = ListWrapper.slice(rest, 1);
        router = router.parent;
        if (isBlank(router)) {
          throw new BaseException(
              '''Link "${ ListWrapper . toJSON ( linkParams )}" has too many "../" segments.''');
        }
      }
    } else if (first != ".") {
      throw new BaseException(
          '''Link "${ ListWrapper . toJSON ( linkParams )}" must start with "/", "./", or "../"''');
    }
    if (rest[rest.length - 1] == "") {
      ListWrapper.removeLast(rest);
    }
    if (rest.length < 1) {
      var msg =
          '''Link "${ ListWrapper . toJSON ( linkParams )}" must include a route name.''';
      throw new BaseException(msg);
    }
    var url = "";
    if (isPresent(router.parent) &&
        isPresent(router.parent._currentInstruction)) {
      url = router.parent._currentInstruction.capturedUrl;
    }
    return url + "/" + this.registry.generate(rest, router.hostComponent);
  }
}
class RootRouter extends Router {
  Location _location;
  RootRouter(RouteRegistry registry, Pipeline pipeline, Location location,
      Type hostComponent)
      : super(registry, pipeline, null, hostComponent) {
    /* super call moved to initializer */;
    this._location = location;
    this._location.subscribe((change) => this.navigate(change["url"]));
    this.registry.configFromComponent(hostComponent);
    this.navigate(location.path());
  }
  Future<dynamic> commit(instruction) {
    return super.commit(instruction).then((_) {
      this._location.go(instruction.accumulatedUrl);
    });
  }
}
class ChildRouter extends Router {
  ChildRouter(Router parent, hostComponent)
      : super(parent.registry, parent._pipeline, parent, hostComponent) {
    /* super call moved to initializer */;
    this.parent = parent;
  }
  Future<dynamic> navigate(String url) {
    // Delegate navigation to the root router
    return this.parent.navigate(url);
  }
}
/*
 * Given: ['/a/b', {c: 2}]
 * Returns: ['', 'a', 'b', {c: 2}]
 */
var SLASH = new RegExp("/");
List<dynamic> splitAndFlattenLinkParams(List<dynamic> linkParams) {
  return ListWrapper.reduce(linkParams, (accumulation, item) {
    if (isString(item)) {
      return ListWrapper.concat(accumulation, StringWrapper.split(item, SLASH));
    }
    accumulation.add(item);
    return accumulation;
  }, []);
}
Future<bool> canActivateOne(nextInstruction, currentInstruction) {
  var next = _resolveToTrue;
  if (isPresent(nextInstruction.child)) {
    next = canActivateOne(nextInstruction.child,
        isPresent(currentInstruction) ? currentInstruction.child : null);
  }
  return next.then((res) {
    if (res == false) {
      return false;
    }
    if (nextInstruction.reuse) {
      return true;
    }
    var hook = getCanActivateHook(nextInstruction.component);
    if (isPresent(hook)) {
      return hook(nextInstruction, currentInstruction);
    }
    return true;
  });
}
