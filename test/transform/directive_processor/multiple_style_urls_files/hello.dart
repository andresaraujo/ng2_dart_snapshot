library examples.src.hello_world.multiple_style_urls_files;

import 'package:angular2/angular2.dart'
    show bootstrap, Component, Directive, View, NgElement;

@Component(selector: 'hello-app')
@View(
    templateUrl: 'template.html',
    styleUrls: const ['template.css', 'template_other.css'])
class HelloCmp {}
