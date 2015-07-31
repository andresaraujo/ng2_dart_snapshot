library examples.src.hello_world.absolute_url_expression_files.ng_deps.dart;

import 'hello.dart';
export 'hello.dart';
import 'package:angular2/src/reflection/reflection.dart' as _ngRef;
import 'package:angular2/angular2.dart'
    show Component, Directive, View, NgElement;

var _visited = false;
void initReflector() {
  if (_visited) return;
  _visited = true;
  _ngRef.reflector
    ..registerType(HelloCmp, new _ngRef.ReflectionInfo(const [
      const Component(selector: 'hello-app'),
      const View(
          template: r'''{{greeting}}''',
          templateUrl: r'package:other_package/template.html',
          styles: const [r'''.greeting { .color: blue; }''',])
    ], const [], () => new HelloCmp()))
    ..registerFunction(
        hello, new _ngRef.ReflectionInfo(const [const Injectable()], const []));
}
