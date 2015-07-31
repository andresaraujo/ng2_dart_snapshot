library angular2.src.reflection.reflector;

import "package:angular2/src/facade/lang.dart"
    show Type, isPresent, stringify, BaseException;
import "package:angular2/src/facade/collection.dart"
    show List, ListWrapper, Map, MapWrapper, Map, StringMapWrapper;
import "types.dart" show SetterFn, GetterFn, MethodFn;
import "platform_reflection_capabilities.dart"
    show PlatformReflectionCapabilities;
export "types.dart" show SetterFn, GetterFn, MethodFn;
export "platform_reflection_capabilities.dart"
    show PlatformReflectionCapabilities;

class ReflectionInfo {
  Function _factory;
  List<dynamic> _annotations;
  List<List<dynamic>> _parameters;
  List<dynamic> _interfaces;
  ReflectionInfo([List<dynamic> annotations, List<List<dynamic>> parameters,
      Function factory, List<dynamic> interfaces]) {
    this._annotations = annotations;
    this._parameters = parameters;
    this._factory = factory;
    this._interfaces = interfaces;
  }
}
class Reflector {
  Map<dynamic, ReflectionInfo> _injectableInfo;
  Map<String, GetterFn> _getters;
  Map<String, SetterFn> _setters;
  Map<String, MethodFn> _methods;
  PlatformReflectionCapabilities reflectionCapabilities;
  Reflector(PlatformReflectionCapabilities reflectionCapabilities) {
    this._injectableInfo = new Map();
    this._getters = new Map();
    this._setters = new Map();
    this._methods = new Map();
    this.reflectionCapabilities = reflectionCapabilities;
  }
  bool isReflectionEnabled() {
    return this.reflectionCapabilities.isReflectionEnabled();
  }
  void registerFunction(Function func, ReflectionInfo funcInfo) {
    this._injectableInfo[func] = funcInfo;
  }
  void registerType(Type type, ReflectionInfo typeInfo) {
    this._injectableInfo[type] = typeInfo;
  }
  void registerGetters(Map<String, GetterFn> getters) {
    _mergeMaps(this._getters, getters);
  }
  void registerSetters(Map<String, SetterFn> setters) {
    _mergeMaps(this._setters, setters);
  }
  void registerMethods(Map<String, MethodFn> methods) {
    _mergeMaps(this._methods, methods);
  }
  Function factory(Type type) {
    if (this._containsReflectionInfo(type)) {
      var res = this._injectableInfo[type]._factory;
      return isPresent(res) ? res : null;
    } else {
      return this.reflectionCapabilities.factory(type);
    }
  }
  List<dynamic> parameters(dynamic typeOrFunc) {
    if (this._injectableInfo.containsKey(typeOrFunc)) {
      var res = this._injectableInfo[typeOrFunc]._parameters;
      return isPresent(res) ? res : [];
    } else {
      return this.reflectionCapabilities.parameters(typeOrFunc);
    }
  }
  List<dynamic> annotations(dynamic typeOrFunc) {
    if (this._injectableInfo.containsKey(typeOrFunc)) {
      var res = this._injectableInfo[typeOrFunc]._annotations;
      return isPresent(res) ? res : [];
    } else {
      return this.reflectionCapabilities.annotations(typeOrFunc);
    }
  }
  List<dynamic> interfaces(Type type) {
    if (this._injectableInfo.containsKey(type)) {
      var res = this._injectableInfo[type]._interfaces;
      return isPresent(res) ? res : [];
    } else {
      return this.reflectionCapabilities.interfaces(type);
    }
  }
  GetterFn getter(String name) {
    if (this._getters.containsKey(name)) {
      return this._getters[name];
    } else {
      return this.reflectionCapabilities.getter(name);
    }
  }
  SetterFn setter(String name) {
    if (this._setters.containsKey(name)) {
      return this._setters[name];
    } else {
      return this.reflectionCapabilities.setter(name);
    }
  }
  MethodFn method(String name) {
    if (this._methods.containsKey(name)) {
      return this._methods[name];
    } else {
      return this.reflectionCapabilities.method(name);
    }
  }
  _containsReflectionInfo(typeOrFunc) {
    return this._injectableInfo.containsKey(typeOrFunc);
  }
}
void _mergeMaps(Map<dynamic, dynamic> target, Map<String, Function> config) {
  StringMapWrapper.forEach(config, (v, k) => target[k] = v);
}
