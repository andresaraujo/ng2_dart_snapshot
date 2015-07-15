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
import "async_route_handler.dart" show AsyncRouteHandler;
import "sync_route_handler.dart" show SyncRouteHandler;

/**
 * `RouteRecognizer` is responsible for recognizing routes for a single component.
 * It is consumed by `RouteRegistry`, which knows how to recognize an entire hierarchy of
 * components.
 */
class RouteRecognizer {
  Map<String, PathRecognizer> names = new Map();
  Map<String, String> redirects = new Map();
  Map<RegExp, PathRecognizer> matchers = new Map();
  void addRedirect(String path, String target) {
    if (path == "/") {
      path = "";
    }
    this.redirects[path] = target;
  }
  bool addConfig(String path, dynamic handlerObj, [String alias = null]) {
    var handler = configObjToHandler(handlerObj["component"]);
    var recognizer = new PathRecognizer(path, handler);
    MapWrapper.forEach(this.matchers, (matcher, _) {
      if (recognizer.regex.toString() == matcher.regex.toString()) {
        throw new BaseException(
            '''Configuration \'${ path}\' conflicts with existing route \'${ matcher . path}\'''');
      }
    });
    this.matchers[recognizer.regex] = recognizer;
    if (isPresent(alias)) {
      this.names[alias] = recognizer;
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
    MapWrapper.forEach(this.matchers, (pathRecognizer, regex) {
      var match;
      if (isPresent(match = RegExpWrapper.firstMatch(regex, url))) {
        var matchedUrl = "/";
        var unmatchedUrl = "";
        if (url != "/") {
          matchedUrl = match[0];
          unmatchedUrl = url.substring(match[0].length);
        }
        solutions.add(new RouteMatch(pathRecognizer, matchedUrl, unmatchedUrl));
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
  RouteMatch(this.recognizer, this.matchedUrl, this.unmatchedUrl) {}
  Map<String, String> params() {
    return this.recognizer.parseParams(this.matchedUrl);
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
