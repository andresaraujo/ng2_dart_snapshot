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

class Reflector {
  Map<dynamic, Map<String, dynamic>> _injectableInfo;
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
  void registerFunction(Function func, Map<String, dynamic> funcInfo) {
    this._injectableInfo[func] = funcInfo;
  }
  void registerType(Type type, Map<String, dynamic> typeInfo) {
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
    if (this._containsTypeInfo(type)) {
      return this._getTypeInfoField(type, "factory", null);
    } else {
      return this.reflectionCapabilities.factory(type);
    }
  }
  List<dynamic> parameters(typeOrFunc) {
    if (this._injectableInfo.containsKey(typeOrFunc)) {
      return this._getTypeInfoField(typeOrFunc, "parameters", []);
    } else {
      return this.reflectionCapabilities.parameters(typeOrFunc);
    }
  }
  List<dynamic> annotations(typeOrFunc) {
    if (this._injectableInfo.containsKey(typeOrFunc)) {
      return this._getTypeInfoField(typeOrFunc, "annotations", []);
    } else {
      return this.reflectionCapabilities.annotations(typeOrFunc);
    }
  }
  List<dynamic> interfaces(type) {
    if (this._injectableInfo.containsKey(type)) {
      return this._getTypeInfoField(type, "interfaces", []);
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
  _getTypeInfoField(typeOrFunc, key, defaultValue) {
    var res = this._injectableInfo[typeOrFunc][key];
    return isPresent(res) ? res : defaultValue;
  }
  _containsTypeInfo(typeOrFunc) {
    return this._injectableInfo.containsKey(typeOrFunc);
  }
}
void _mergeMaps(Map<dynamic, dynamic> target, Map<String, Function> config) {
  StringMapWrapper.forEach(config, (v, k) => target[k] = v);
}
