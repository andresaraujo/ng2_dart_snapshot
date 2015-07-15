library angular2.src.router.path_recognizer;

import "package:angular2/src/facade/lang.dart"
    show
        RegExp,
        RegExpWrapper,
        RegExpMatcherWrapper,
        StringWrapper,
        isPresent,
        isBlank,
        BaseException;
import "package:angular2/src/facade/async.dart" show Future, PromiseWrapper;
import "package:angular2/src/facade/collection.dart"
    show Map, MapWrapper, Map, StringMapWrapper, List, ListWrapper;
import "url.dart" show escapeRegex;
import "route_handler.dart" show RouteHandler;
// TODO(jeffbcross): implement as interface when ts2dart adds support:

// https://github.com/angular/ts2dart/issues/173
class Segment {
  String name;
  String regex;
  String generate(TouchMap params) {
    return "";
  }
}
class TouchMap {
  Map<String, String> map = StringMapWrapper.create();
  Map<String, bool> keys = StringMapWrapper.create();
  TouchMap(Map<String, dynamic> map) {
    if (isPresent(map)) {
      StringMapWrapper.forEach(map, (value, key) {
        this.map[key] = isPresent(value) ? value.toString() : null;
        this.keys[key] = true;
      });
    }
  }
  String get(String key) {
    StringMapWrapper.delete(this.keys, key);
    return this.map[key];
  }
  Map<String, dynamic> getUnused() {
    Map<String, dynamic> unused = StringMapWrapper.create();
    var keys = StringMapWrapper.keys(this.keys);
    ListWrapper.forEach(keys, (key) {
      unused[key] = StringMapWrapper.get(this.map, key);
    });
    return unused;
  }
}
String normalizeString(dynamic obj) {
  if (isBlank(obj)) {
    return null;
  } else {
    return obj.toString();
  }
}
parseAndAssignMatrixParams(keyValueMap, matrixString) {
  if (matrixString[0] == ";") {
    matrixString = matrixString.substring(1);
  }
  matrixString.split(";").forEach((entry) {
    var tuple = entry.split("=");
    var key = tuple[0];
    var value = tuple.length > 1 ? tuple[1] : true;
    keyValueMap[key] = value;
  });
}
class ContinuationSegment extends Segment {}
class StaticSegment extends Segment {
  String string;
  String regex;
  String name = "";
  StaticSegment(this.string) : super() {
    /* super call moved to initializer */;
    this.regex = escapeRegex(string);
    // we add this property so that the route matcher still sees

    // this segment as a valid path even if do not use the matrix

    // parameters
    this.regex += "(;[^/]+)?";
  }
  String generate(TouchMap params) {
    return this.string;
  }
}
class DynamicSegment implements Segment {
  String name;
  String regex = "([^/]+)";
  DynamicSegment(this.name) {}
  String generate(TouchMap params) {
    if (!StringMapWrapper.contains(params.map, this.name)) {
      throw new BaseException(
          '''Route generator for \'${ this . name}\' was not included in parameters passed.''');
    }
    return normalizeString(params.get(this.name));
  }
}
class StarSegment {
  String name;
  String regex = "(.+)";
  StarSegment(this.name) {}
  String generate(TouchMap params) {
    return normalizeString(params.get(this.name));
  }
}
var paramMatcher = new RegExp(r'^:([^\/]+)$');
var wildcardMatcher = new RegExp(r'^\*([^\/]+)$');
Map<String, dynamic> parsePathString(String route) {
  // normalize route as not starting with a "/". Recognition will

  // also normalize.
  if (StringWrapper.startsWith(route, "/")) {
    route = StringWrapper.substring(route, 1);
  }
  var segments = splitBySlash(route);
  var results = [];
  var specificity = 0;
  // The "specificity" of a path is used to determine which route is used when multiple routes match

  // a URL.

  // Static segments (like "/foo") are the most specific, followed by dynamic segments (like

  // "/:id"). Star segments

  // add no specificity. Segments at the start of the path are more specific than proceeding ones.

  // The code below uses place values to combine the different types of segments into a single

  // integer that we can

  // sort later. Each static segment is worth hundreds of points of specificity (10000, 9900, ...,

  // 200), and each

  // dynamic segment is worth single points of specificity (100, 99, ... 2).
  if (segments.length > 98) {
    throw new BaseException(
        '''\'${ route}\' has more than the maximum supported number of segments.''');
  }
  var limit = segments.length - 1;
  for (var i = 0; i <= limit; i++) {
    var segment = segments[i],
        match;
    if (isPresent(match = RegExpWrapper.firstMatch(paramMatcher, segment))) {
      results.add(new DynamicSegment(match[1]));
      specificity += (100 - i);
    } else if (isPresent(
        match = RegExpWrapper.firstMatch(wildcardMatcher, segment))) {
      results.add(new StarSegment(match[1]));
    } else if (segment == "...") {
      if (i < limit) {
        // TODO (matsko): setup a proper error here `
        throw new BaseException(
            '''Unexpected "..." before the end of the path for "${ route}".''');
      }
      results.add(new ContinuationSegment());
    } else if (segment.length > 0) {
      results.add(new StaticSegment(segment));
      specificity += 100 * (100 - i);
    }
  }
  var result = StringMapWrapper.create();
  StringMapWrapper.set(result, "segments", results);
  StringMapWrapper.set(result, "specificity", specificity);
  return result;
}
List<String> splitBySlash(String url) {
  return url.split("/");
}
// represents something like '/foo/:bar'
class PathRecognizer {
  String path;
  RouteHandler handler;
  List<Segment> segments;
  RegExp regex;
  num specificity;
  bool terminal = true;
  PathRecognizer(this.path, this.handler) {
    var parsed = parsePathString(path);
    var specificity = parsed["specificity"];
    var segments = parsed["segments"];
    var regexString = "^";
    ListWrapper.forEach(segments, (segment) {
      if (segment is ContinuationSegment) {
        this.terminal = false;
      } else {
        regexString += "/" + segment.regex;
      }
    });
    if (this.terminal) {
      regexString += "\$";
    }
    this.regex = RegExpWrapper.create(regexString);
    this.segments = segments;
    this.specificity = specificity;
  }
  Map<String, String> parseParams(String url) {
    // the last segment is always the star one since it's terminal
    var segmentsLimit = this.segments.length - 1;
    var containsStarSegment =
        segmentsLimit >= 0 && this.segments[segmentsLimit] is StarSegment;
    var matrixString;
    if (!containsStarSegment) {
      var matches = RegExpWrapper.firstMatch(
          RegExpWrapper.create("^(.*/[^/]+?)(;[^/]+)?/?\$"), url);
      if (isPresent(matches)) {
        url = matches[1];
        matrixString = matches[2];
      }
      url = StringWrapper.replaceAll(
          url, new RegExp(r'(;[^\/]+)(?=(\/|\Z))'), "");
    }
    var params = StringMapWrapper.create();
    var urlPart = url;
    for (var i = 0; i <= segmentsLimit; i++) {
      var segment = this.segments[i];
      if (segment is ContinuationSegment) {
        continue;
      }
      var match = RegExpWrapper.firstMatch(
          RegExpWrapper.create("/" + segment.regex), urlPart);
      urlPart = StringWrapper.substring(urlPart, match[0].length);
      if (segment.name.length > 0) {
        params[segment.name] = match[1];
      }
    }
    if (isPresent(matrixString) &&
        matrixString.length > 0 &&
        matrixString[0] == ";") {
      parseAndAssignMatrixParams(params, matrixString);
    }
    return params;
  }
  String generate(Map<String, dynamic> params) {
    var paramTokens = new TouchMap(params);
    var applyLeadingSlash = false;
    var url = "";
    for (var i = 0; i < this.segments.length; i++) {
      var segment = this.segments[i];
      var s = segment.generate(paramTokens);
      applyLeadingSlash = applyLeadingSlash || (segment is ContinuationSegment);
      if (s.length > 0) {
        url += (i > 0 ? "/" : "") + s;
      }
    }
    var unusedParams = paramTokens.getUnused();
    StringMapWrapper.forEach(unusedParams, (value, key) {
      url += ";" + key;
      if (isPresent(value)) {
        url += "=" + value;
      }
    });
    if (applyLeadingSlash) {
      url += "/";
    }
    return url;
  }
  Future<dynamic> resolveComponentType() {
    return this.handler.resolveComponentType();
  }
}
