library examples.src.hello_world.multiple_style_urls_not_inlined_files.ng_deps.dart;

import 'hello.dart';
import 'package:angular2/angular2.dart'
    show bootstrap, Component, Directive, View, NgElement;

var _visited = false;
void initReflector(reflector) {
  if (_visited) return;
  _visited = true;
  reflector
    ..registerType(HelloCmp, {
      'factory': () => new HelloCmp(),
      'parameters': const [],
      'annotations': const [
        const Component(selector: 'hello-app'),
        const View(
            templateUrl: 'package:a/template.html',
            styleUrls: const [
          'package:a/template.css',
          'package:a/template_other.css'
        ])
      ]
    });
}
