library examples.src.hello_world.url_expression_files;

import 'package:angular2/angular2.dart'
    show bootstrap, Component, Directive, View, NgElement;

@Component(selector: 'hello-app')
@View(templateUrl: 'template.html')
class HelloCmp {}
