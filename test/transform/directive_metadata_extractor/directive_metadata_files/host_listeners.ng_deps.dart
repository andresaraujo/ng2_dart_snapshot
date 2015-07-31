library examples.hello_world.index_common_dart.ng_deps.dart;

import 'hello.dart';
import 'package:angular2/angular2.dart'
    show Component, Directive, View, NgElement;

var _visited = false;
void initReflector(reflector) {
  if (_visited) return;
  _visited = true;
  reflector
    ..registerType(HelloCmp, new ReflectionInfo(const [
      const Component(
          host: const {
        '(change)': 'onChange(\$event)',
        '[value]': 'value',
        '@actionName': 'actionValue',
        'attName': 'attValue'
      })
    ], const [const []], () => new HelloCmp()));
}
