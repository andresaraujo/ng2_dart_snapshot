library angular2.src.render.dom.schema.element_schema_registry;

class ElementSchemaRegistry {
  bool hasProperty(dynamic elm, String propName) {
    return true;
  }
  String getMappedPropName(String propName) {
    return propName;
  }
}
