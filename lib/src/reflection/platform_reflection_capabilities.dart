library angular2.src.reflection.platform_reflection_capabilities;

import "package:angular2/src/facade/lang.dart" show Type;
import "types.dart" show GetterFn, SetterFn, MethodFn;
import "package:angular2/src/facade/collection.dart" show List;

abstract class PlatformReflectionCapabilities {
  bool isReflectionEnabled();
  Function factory(Type type);
  List<dynamic> interfaces(Type type);
  List<List<dynamic>> parameters(Type type);
  List<dynamic> annotations(Type type);
  GetterFn getter(String name);
  SetterFn setter(String name);
  MethodFn method(String name);
}
