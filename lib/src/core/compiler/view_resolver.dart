library angular2.src.core.compiler.view_resolver;

import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/core/annotations_impl/view.dart" show View;
import "package:angular2/src/facade/lang.dart"
    show Type, stringify, isBlank, BaseException;
import "package:angular2/src/facade/collection.dart"
    show Map, MapWrapper, List, ListWrapper;
import "package:angular2/src/reflection/reflection.dart" show reflector;

@Injectable()
class ViewResolver {
  Map<Type, dynamic> _cache = new Map();
  View resolve(Type component) {
    var view = this._cache[component];
    if (isBlank(view)) {
      view = this._resolve(component);
      this._cache[component] = view;
    }
    return view;
  }
  View _resolve(Type component) {
    var annotations = reflector.annotations(component);
    for (var i = 0; i < annotations.length; i++) {
      var annotation = annotations[i];
      if (annotation is View) {
        return annotation;
      }
    }
    throw new BaseException(
        '''No View annotation found on component ${ stringify ( component )}''');
  }
}
