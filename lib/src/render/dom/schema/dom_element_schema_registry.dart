library angular2.src.render.dom.schema.dom_element_schema_registry;

import "package:angular2/src/facade/lang.dart" show isPresent;
import "package:angular2/src/facade/collection.dart" show StringMapWrapper;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "element_schema_registry.dart" show ElementSchemaRegistry;

class DomElementSchemaRegistry extends ElementSchemaRegistry {
  bool hasProperty(dynamic elm, String propName) {
    var tagName = DOM.tagName(elm);
    if (!identical(tagName.indexOf("-"), -1)) {
      // can't tell now as we don't know which properties a custom element will get

      // once it is instantiated
      return true;
    } else {
      return DOM.hasProperty(elm, propName);
    }
  }
  String getMappedPropName(String propName) {
    var mappedPropName = StringMapWrapper.get(DOM.attrToPropMap, propName);
    return isPresent(mappedPropName) ? mappedPropName : propName;
  }
}
