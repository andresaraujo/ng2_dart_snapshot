library bar.ng_deps.dart;

import 'bar.dart';
import 'package:angular2/src/core/annotations_impl/annotations.dart';

var _visited = false;
void initReflector(reflector) {
  if (_visited) return;
  _visited = true;
  reflector
    ..registerType(ToolTip, new ReflectionInfo(const [
      const Directive(
          selector: '[tool-tip]', events: const ['onOpen', 'close: onClose'])
    ], const [], () => new ToolTip()))
    ..registerGetters({'onOpen': (o) => o.onOpen, 'close': (o) => o.close});
}
