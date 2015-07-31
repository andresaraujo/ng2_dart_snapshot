library angular2.src.router.route_registry;

import "route_recognizer.dart" show RouteRecognizer, RouteMatch;
import "instruction.dart" show Instruction;
import "package:angular2/src/facade/collection.dart"
    show List, ListWrapper, Map, MapWrapper, Map, StringMapWrapper;
import "package:angular2/src/facade/async.dart" show Future, PromiseWrapper;
import "package:angular2/src/facade/lang.dart"
    show
        isPresent,
        isBlank,
        isType,
        isString,
        isStringMap,
        isFunction,
        StringWrapper,
        BaseException,
        getTypeNameForDebugging;
import "route_config_impl.dart"
    show RouteConfig, AsyncRoute, Route, Redirect, RouteDefinition;
import "package:angular2/src/reflection/reflection.dart" show reflector;
import "package:angular2/di.dart" show Injectable;
import "route_config_nomalizer.dart" show normalizeRouteConfig;

/**
 * The RouteRegistry holds route configurations for each component in an Angular app.
 * It is responsible for creating Instructions from URLs, and generating URLs based on route and
 * parameters.
 */
@Injectable()
class RouteRegistry {
  Map<dynamic, RouteRecognizer> _rules = new Map();
  /**
   * Given a component and a configuration object, add the route to this registry
   */
  void config(dynamic parentComponent, RouteDefinition config,
      [bool isRootLevelRoute = false]) {
    config = normalizeRouteConfig(config);
    RouteRecognizer recognizer = this._rules[parentComponent];
    if (isBlank(recognizer)) {
      recognizer = new RouteRecognizer(isRootLevelRoute);
      this._rules[parentComponent] = recognizer;
    }
    var terminal = recognizer.config(config);
    if (config is Route) {
      if (terminal) {
        assertTerminalComponent(config.component, config.path);
      } else {
        this.configFromComponent(config.component);
      }
    }
  }
  /**
   * Reads the annotations of a component and configures the registry based on them
   */
  void configFromComponent(dynamic component, [bool isRootComponent = false]) {
    if (!isType(component)) {
      return;
    }
    // Don't read the annotations from a type more than once –

    // this prevents an infinite loop if a component routes recursively.
    if (this._rules.containsKey(component)) {
      return;
    }
    var annotations = reflector.annotations(component);
    if (isPresent(annotations)) {
      for (var i = 0; i < annotations.length; i++) {
        var annotation = annotations[i];
        if (annotation is RouteConfig) {
          ListWrapper.forEach(annotation.configs,
              (config) => this.config(component, config, isRootComponent));
        }
      }
    }
  }
  /**
   * Given a URL and a parent component, return the most specific instruction for navigating
   * the application into the state specified by the url
   */
  Future<Instruction> recognize(String url, dynamic parentComponent) {
    var componentRecognizer = this._rules[parentComponent];
    if (isBlank(componentRecognizer)) {
      return PromiseWrapper.resolve(null);
    }
    // Matches some beginning part of the given URL
    var possibleMatches = componentRecognizer.recognize(url);
    var matchPromises = ListWrapper.map(
        possibleMatches, (candidate) => this._completeRouteMatch(candidate));
    return PromiseWrapper
        .all(matchPromises)
        .then((List<Instruction> solutions) {
      // remove nulls
      var fullSolutions =
          ListWrapper.filter(solutions, (solution) => isPresent(solution));
      if (fullSolutions.length > 0) {
        return mostSpecific(fullSolutions);
      }
      return null;
    });
  }
  Future<Instruction> _completeRouteMatch(RouteMatch partialMatch) {
    var recognizer = partialMatch.recognizer;
    var handler = recognizer.handler;
    return handler.resolveComponentType().then((componentType) {
      this.configFromComponent(componentType);
      if (partialMatch.unmatchedUrl.length == 0) {
        if (recognizer.terminal) {
          return new Instruction(componentType, partialMatch.matchedUrl,
              recognizer, null, partialMatch.params());
        } else {
          return null;
        }
      }
      return this
          .recognize(partialMatch.unmatchedUrl, componentType)
          .then((childInstruction) {
        if (isBlank(childInstruction)) {
          return null;
        } else {
          return new Instruction(componentType, partialMatch.matchedUrl,
              recognizer, childInstruction);
        }
      });
    });
  }
  /**
   * Given a normalized list with component names and params like: `['user', {id: 3 }]`
   * generates a url with a leading slash relative to the provided `parentComponent`.
   */
  String generate(List<dynamic> linkParams, dynamic parentComponent) {
    var url = "";
    var componentCursor = parentComponent;
    for (var i = 0; i < linkParams.length; i += 1) {
      var segment = linkParams[i];
      if (isBlank(componentCursor)) {
        throw new BaseException(
            '''Could not find route named "${ segment}".''');
      }
      if (!isString(segment)) {
        throw new BaseException(
            '''Unexpected segment "${ segment}" in link DSL. Expected a string.''');
      } else if (segment == "" || segment == "." || segment == "..") {
        throw new BaseException(
            '''"${ segment}/" is only allowed at the beginning of a link DSL.''');
      }
      var params = null;
      if (i + 1 < linkParams.length) {
        var nextSegment = linkParams[i + 1];
        if (isStringMap(nextSegment)) {
          params = nextSegment;
          i += 1;
        }
      }
      var componentRecognizer = this._rules[componentCursor];
      if (isBlank(componentRecognizer)) {
        throw new BaseException(
            '''Component "${ getTypeNameForDebugging ( componentCursor )}" has no route config.''');
      }
      var response = componentRecognizer.generate(segment, params);
      if (isBlank(response)) {
        throw new BaseException(
            '''Component "${ getTypeNameForDebugging ( componentCursor )}" has no route named "${ segment}".''');
      }
      url += response["url"];
      componentCursor = response["nextComponent"];
    }
    return url;
  }
}
/*
 * Given a list of instructions, returns the most specific instruction
 */
Instruction mostSpecific(List<Instruction> instructions) {
  var mostSpecificSolution = instructions[0];
  for (var solutionIndex = 1;
      solutionIndex < instructions.length;
      solutionIndex++) {
    var solution = instructions[solutionIndex];
    if (solution.specificity > mostSpecificSolution.specificity) {
      mostSpecificSolution = solution;
    }
  }
  return mostSpecificSolution;
}
assertTerminalComponent(component, path) {
  if (!isType(component)) {
    return;
  }
  var annotations = reflector.annotations(component);
  if (isPresent(annotations)) {
    for (var i = 0; i < annotations.length; i++) {
      var annotation = annotations[i];
      if (annotation is RouteConfig) {
        throw new BaseException(
            '''Child routes are not allowed for "${ path}". Use "..." on the parent\'s route path.''');
      }
    }
  }
}
