library angular2.src.core.compiler.component_url_mapper;

import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/facade/lang.dart" show Type, isPresent;
import "package:angular2/src/facade/collection.dart" show Map, MapWrapper;

/**
 * Resolve a `Type` from a {@link Component} into a URL.
 *
 * This interface can be overridden by the application developer to create custom behavior.
 *
 * See {@link Compiler}
 */
@Injectable()
class ComponentUrlMapper {
  /**
   * Returns the base URL to the component source file.
   * The returned URL could be:
   * - an absolute URL,
   * - a path relative to the application
   */
  String getUrl(Type component) {
    return "./";
  }
}
class RuntimeComponentUrlMapper extends ComponentUrlMapper {
  Map<Type, String> _componentUrls;
  RuntimeComponentUrlMapper() : super() {
    /* super call moved to initializer */;
    this._componentUrls = new Map();
  }
  setComponentUrl(Type component, String url) {
    this._componentUrls[component] = url;
  }
  String getUrl(Type component) {
    var url = this._componentUrls[component];
    if (isPresent(url)) return url;
    return super.getUrl(component);
  }
}
