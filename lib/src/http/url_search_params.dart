library angular2.src.http.url_search_params;

import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, StringWrapper;
import "package:angular2/src/facade/collection.dart"
    show Map, MapWrapper, List, ListWrapper, isListLikeIterable;

Map<String, List<String>> paramParser(String rawParams) {
  Map<String, List<String>> map = new Map();
  List<String> params = StringWrapper.split(rawParams, new RegExp("&"));
  ListWrapper.forEach(params, (String param) {
    List<String> split = StringWrapper.split(param, new RegExp("="));
    var key = ListWrapper.get(split, 0);
    var val = ListWrapper.get(split, 1);
    var list = isPresent(map[key]) ? map[key] : [];
    list.add(val);
    map[key] = list;
  });
  return map;
}
/**
 * Map-like representation of url search parameters, based on
 * [URLSearchParams](https://url.spec.whatwg.org/#urlsearchparams) in the url living standard.
 *
 */
class URLSearchParams {
  String rawParams;
  Map<String, List<String>> paramsMap;
  URLSearchParams(this.rawParams) {
    this.paramsMap = paramParser(rawParams);
  }
  bool has(String param) {
    return this.paramsMap.containsKey(param);
  }
  String get(String param) {
    var storedParam = this.paramsMap[param];
    if (isListLikeIterable(storedParam)) {
      return ListWrapper.first(storedParam);
    } else {
      return null;
    }
  }
  List<String> getAll(String param) {
    var mapParam = this.paramsMap[param];
    return isPresent(mapParam) ? mapParam : [];
  }
  void append(String param, String val) {
    var mapParam = this.paramsMap[param];
    var list = isPresent(mapParam) ? mapParam : [];
    list.add(val);
    this.paramsMap[param] = list;
  }
  String toString() {
    var paramsList = [];
    MapWrapper.forEach(this.paramsMap, (values, k) {
      ListWrapper.forEach(values, (v) {
        paramsList.add(k + "=" + v);
      });
    });
    return ListWrapper.join(paramsList, "&");
  }
  void delete(String param) {
    MapWrapper.delete(this.paramsMap, param);
  }
}
