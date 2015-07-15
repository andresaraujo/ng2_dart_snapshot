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
        BaseException;
import "route_config_impl.dart" show RouteConfig;
import "package:angular2/src/reflection/reflection.dart" show reflector;
import "package:angular2/di.dart" show Injectable;

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
  void config(parentComponent, Map<String, dynamic> config) {
    assertValidConfig(config);
    RouteRecognizer recognizer = this._rules[parentComponent];
    if (isBlank(recognizer)) {
      recognizer = new RouteRecognizer();
      this._rules[parentComponent] = recognizer;
    }
    if (StringMapWrapper.contains(config, "redirectTo")) {
      recognizer.addRedirect(config["path"], config["redirectTo"]);
      return;
    }
    config = StringMapWrapper.merge(config, {
      "component": normalizeComponentDeclaration(config["component"])
    });
    var component = config["component"];
    var terminal = recognizer.addConfig(config["path"], config, config["as"]);
    if (component["type"] == "constructor") {
      if (terminal) {
        assertTerminalComponent(component["constructor"], config["path"]);
      } else {
        this.configFromComponent(component["constructor"]);
      }
    }
  }
  /**
   * Reads the annotations of a component and configures the registry based on them
   */
  void configFromComponent(component) {
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
          ListWrapper.forEach(
              annotation.configs, (config) => this.config(component, config));
        }
      }
    }
  }
  /**
   * Given a URL and a parent component, return the most specific instruction for navigating
   * the application into the state specified by the url
   */
  Future<Instruction> recognize(String url, parentComponent) {
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
          return new Instruction(
              componentType, partialMatch.matchedUrl, recognizer);
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
  String generate(List<dynamic> linkParams, parentComponent) {
    var url = "";
    var componentCursor = parentComponent;
    for (var i = 0; i < linkParams.length; i += 1) {
      var segment = linkParams[i];
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
            '''Could not find route config for "${ segment}".''');
      }
      var response = componentRecognizer.generate(segment, params);
      url += response["url"];
      componentCursor = response["nextComponent"];
    }
    return url;
  }
}
/*
 * A config should have a "path" property, and exactly one of:
 * - `component`
 * - `redirectTo`
 */
var ALLOWED_TARGETS = ["component", "redirectTo"];
void assertValidConfig(Map<String, dynamic> config) {
  if (!StringMapWrapper.contains(config, "path")) {
    throw new BaseException(
        '''Route config should contain a "path" property''');
  }
  var targets = 0;
  ListWrapper.forEach(ALLOWED_TARGETS, (target) {
    if (StringMapWrapper.contains(config, target)) {
      targets += 1;
    }
  });
  if (targets != 1) {
    throw new BaseException(
        '''Route config should contain exactly one \'component\', or \'redirectTo\' property''');
  }
}
/*
 * Returns a StringMap like: `{ 'constructor': SomeType, 'type': 'constructor' }`
 */
var VALID_COMPONENT_TYPES = ["constructor", "loader"];
Map<String, dynamic> normalizeComponentDeclaration(dynamic config) {
  if (isType(config)) {
    return {"constructor": config, "type": "constructor"};
  } else if (isStringMap(config)) {
    if (isBlank(config["type"])) {
      throw new BaseException(
          '''Component declaration when provided as a map should include a \'type\' property''');
    }
    var componentType = config["type"];
    if (!ListWrapper.contains(VALID_COMPONENT_TYPES, componentType)) {
      throw new BaseException(
          '''Invalid component type \'${ componentType}\'''');
    }
    return config;
  } else {
    throw new BaseException(
        '''Component declaration should be either a Map or a Type''');
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
