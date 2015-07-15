library angular2.src.http.headers;

import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, isJsObject, isType, StringWrapper, BaseException;
import "package:angular2/src/facade/collection.dart"
    show isListLikeIterable, List, Map, MapWrapper, ListWrapper, Map;

/**
 * Polyfill for [Headers](https://developer.mozilla.org/en-US/docs/Web/API/Headers/Headers), as
 * specified in the [Fetch Spec](https://fetch.spec.whatwg.org/#headers-class). The only known
 * difference from the spec is the lack of an `entries` method.
 */
class Headers {
  Map<String, List<String>> _headersMap;
  Headers([dynamic /* Headers | Map < String , dynamic > */ headers]) {
    if (isBlank(headers)) {
      this._headersMap = new Map();
      return;
    }
    if (headers is Headers) {
      this._headersMap = ((headers as Headers))._headersMap;
    } else if (headers is Map) {
      this._headersMap = MapWrapper.createFromStringMap(headers);
      MapWrapper.forEach(this._headersMap, (v, k) {
        if (!isListLikeIterable(v)) {
          var list = [];
          list.add(v);
          this._headersMap[k] = list;
        }
      });
    }
  }
  /**
   * Appends a header to existing list of header values for a given header name.
   */
  void append(String name, String value) {
    var mapName = this._headersMap[name];
    var list = isListLikeIterable(mapName) ? mapName : [];
    list.add(value);
    this._headersMap[name] = list;
  }
  /**
   * Deletes all header values for the given name.
   */
  void delete(String name) {
    MapWrapper.delete(this._headersMap, name);
  }
  forEach(Function fn) {
    MapWrapper.forEach(this._headersMap, fn);
  }
  /**
   * Returns first header that matches given name.
   */
  String get(String header) {
    return ListWrapper.first(this._headersMap[header]);
  }
  /**
   * Check for existence of header by given name.
   */
  bool has(String header) {
    return this._headersMap.containsKey(header);
  }
  /**
   * Provides names of set headers
   */
  List<String> keys() {
    return MapWrapper.keys(this._headersMap);
  }
  /**
   * Sets or overrides header value for given name.
   */
  void set(String header, dynamic /* String | List < String > */ value) {
    var list = [];
    if (isListLikeIterable(value)) {
      var pushValue = ((value as List<String>)).join(",");
      list.add(pushValue);
    } else {
      list.add(value);
    }
    this._headersMap[header] = list;
  }
  /**
   * Returns values of all headers.
   */
  List<List<String>> values() {
    return MapWrapper.values(this._headersMap);
  }
  /**
   * Returns list of header values for a given name.
   */
  List<String> getAll(String header) {
    var headers = this._headersMap[header];
    return isListLikeIterable(headers) ? headers : [];
  }
  /**
   * This method is not implemented.
   */
  entries() {
    throw new BaseException(
        "\"entries\" method is not implemented on Headers class");
  }
}
