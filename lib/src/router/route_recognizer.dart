library angular2.src.router.route_recognizer;

import "package:angular2/src/facade/lang.dart"
    show
        RegExp,
        RegExpWrapper,
        StringWrapper,
        isBlank,
        isPresent,
        isType,
        isStringMap,
        BaseException;
import "package:angular2/src/facade/collection.dart"
    show Map, MapWrapper, List, ListWrapper, Map, StringMapWrapper;
import "path_recognizer.dart" show PathRecognizer;
import "route_handler.dart" show RouteHandler;
import "route_config_impl.dart"
    show Route, AsyncRoute, Redirect, RouteDefinition;
import "async_route_handler.dart" show AsyncRouteHandler;
import "sync_route_handler.dart" show SyncRouteHandler;
import "package:angular2/src/router/helpers.dart"
    show parseAndAssignParamString;

/**
 * `RouteRecognizer` is responsible for recognizing routes for a single component.
 * It is consumed by `RouteRegistry`, which knows how to recognize an entire hierarchy of
 * components.
 */
class RouteRecognizer {
  bool isRoot;
  Map<String, PathRecognizer> names = new Map();
  Map<String, String> redirects = new Map();
  Map<RegExp, PathRecognizer> matchers = new Map();
  RouteRecognizer([this.isRoot = false]) {}
  bool config(RouteDefinition config) {
    var handler;
    if (config is Redirect) {
      var path = config.path == "/" ? "" : config.path;
      this.redirects[path] = config.redirectTo;
      return true;
    } else if (config is Route) {
      handler = new SyncRouteHandler(config.component);
    } else if (config is AsyncRoute) {
      handler = new AsyncRouteHandler(config.loader);
    }
    var recognizer = new PathRecognizer(config.path, handler, this.isRoot);
    MapWrapper.forEach(this.matchers, (matcher, _) {
      if (recognizer.regex.toString() == matcher.regex.toString()) {
        throw new BaseException(
            '''Configuration \'${ config . path}\' conflicts with existing route \'${ matcher . path}\'''');
      }
    });
    this.matchers[recognizer.regex] = recognizer;
    if (isPresent(config.as)) {
      this.names[config.as] = recognizer;
    }
    return recognizer.terminal;
  }
  /**
   * Given a URL, returns a list of `RouteMatch`es, which are partial recognitions for some route.
   *
   */
  List<RouteMatch> recognize(String url) {
    var solutions = [];
    if (url.length > 0 && url[url.length - 1] == "/") {
      url = url.substring(0, url.length - 1);
    }
    MapWrapper.forEach(this.redirects, (target, path) {
      // "/" redirect case
      if (path == "/" || path == "") {
        if (path == url) {
          url = target;
        }
      } else if (url.startsWith(path)) {
        url = target + url.substring(path.length);
      }
    });
    var queryParams = StringMapWrapper.create();
    var queryString = "";
    var queryIndex = url.indexOf("?");
    if (queryIndex >= 0) {
      queryString = url.substring(queryIndex + 1);
      url = url.substring(0, queryIndex);
    }
    if (this.isRoot && queryString.length > 0) {
      parseAndAssignParamString("&", queryString, queryParams);
    }
    MapWrapper.forEach(this.matchers, (pathRecognizer, regex) {
      var match;
      if (isPresent(match = RegExpWrapper.firstMatch(regex, url))) {
        var matchedUrl = "/";
        var unmatchedUrl = "";
        if (url != "/") {
          matchedUrl = match[0];
          unmatchedUrl = url.substring(match[0].length);
        }
        var params = null;
        if (pathRecognizer.terminal && !StringMapWrapper.isEmpty(queryParams)) {
          params = queryParams;
          matchedUrl += "?" + queryString;
        }
        solutions.add(
            new RouteMatch(pathRecognizer, matchedUrl, unmatchedUrl, params));
      }
    });
    return solutions;
  }
  bool hasRoute(String name) {
    return this.names.containsKey(name);
  }
  Map<String, dynamic> generate(String name, dynamic params) {
    PathRecognizer pathRecognizer = this.names[name];
    if (isBlank(pathRecognizer)) {
      return null;
    }
    var url = pathRecognizer.generate(params);
    return {"url": url, "nextComponent": pathRecognizer.handler.componentType};
  }
}
class RouteMatch {
  PathRecognizer recognizer;
  String matchedUrl;
  String unmatchedUrl;
  Map<String, dynamic> _params;
  bool _paramsParsed = false;
  RouteMatch(this.recognizer, this.matchedUrl, this.unmatchedUrl,
      [Map<String, dynamic> p = null]) {
    this._params = isPresent(p) ? p : StringMapWrapper.create();
  }
  Map<String, dynamic> params() {
    if (!this._paramsParsed) {
      this._paramsParsed = true;
      StringMapWrapper.forEach(this.recognizer.parseParams(this.matchedUrl),
          (value, key) {
        StringMapWrapper.set(this._params, key, value);
      });
    }
    return this._params;
  }
}
RouteHandler configObjToHandler(dynamic config) {
  if (isType(config)) {
    return new SyncRouteHandler(config);
  } else if (isStringMap(config)) {
    if (isBlank(config["type"])) {
      throw new BaseException(
          '''Component declaration when provided as a map should include a \'type\' property''');
    }
    var componentType = config["type"];
    if (componentType == "constructor") {
      return new SyncRouteHandler(config["constructor"]);
    } else if (componentType == "loader") {
      return new AsyncRouteHandler(config["loader"]);
    } else {
      throw new BaseException('''oops''');
    }
  }
  throw new BaseException('''Unexpected component "${ config}".''');
}
