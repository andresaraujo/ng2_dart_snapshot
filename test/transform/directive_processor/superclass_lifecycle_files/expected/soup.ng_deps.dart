library dinner.soup.ng_deps.dart;

import 'soup.dart';
export 'soup.dart';
import 'package:angular2/src/reflection/reflection.dart' as _ngRef;
import 'package:angular2/annotations.dart';

var _visited = false;
void initReflector() {
  if (_visited) return;
  _visited = true;
  _ngRef.reflector
    ..registerType(OnChangeSoupComponent, new _ngRef.ReflectionInfo(const [
      const Component(
          selector: '[soup]', lifecycle: const [LifecycleEvent.onChange])
    ], const [], () => new OnChangeSoupComponent()));
}
