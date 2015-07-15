library angular2.src.render.dom.convert;

import "package:angular2/src/facade/collection.dart"
    show ListWrapper, MapWrapper;
import "package:angular2/src/facade/lang.dart" show isPresent, isArray;
import "package:angular2/src/render/api.dart" show DirectiveMetadata;

/**
 * Converts a [DirectiveMetadata] to a map representation. This creates a copy,
 * that is, subsequent changes to `meta` will not be mirrored in the map.
 */
Map<String, dynamic> directiveMetadataToMap(DirectiveMetadata meta) {
  return MapWrapper.createFromPairs([
    ["id", meta.id],
    ["selector", meta.selector],
    ["compileChildren", meta.compileChildren],
    ["hostProperties", _cloneIfPresent(meta.hostProperties)],
    ["hostListeners", _cloneIfPresent(meta.hostListeners)],
    ["hostActions", _cloneIfPresent(meta.hostActions)],
    ["hostAttributes", _cloneIfPresent(meta.hostAttributes)],
    ["properties", _cloneIfPresent(meta.properties)],
    ["readAttributes", _cloneIfPresent(meta.readAttributes)],
    ["type", meta.type],
    ["exportAs", meta.exportAs],
    ["callOnDestroy", meta.callOnDestroy],
    ["callOnCheck", meta.callOnCheck],
    ["callOnInit", meta.callOnInit],
    ["callOnChange", meta.callOnChange],
    ["callOnAllChangesDone", meta.callOnAllChangesDone],
    ["events", meta.events],
    ["changeDetection", meta.changeDetection],
    ["version", 1]
  ]);
}
/**
 * Converts a map representation of [DirectiveMetadata] into a
 * [DirectiveMetadata] object. This creates a copy, that is, subsequent changes
 * to `map` will not be mirrored in the [DirectiveMetadata] object.
 */
DirectiveMetadata directiveMetadataFromMap(Map<String, dynamic> map) {
  return new DirectiveMetadata(
      id: (map["id"] as String),
      selector: (map["selector"] as String),
      compileChildren: (map["compileChildren"] as bool),
      hostProperties: (_cloneIfPresent(
          map["hostProperties"]) as Map<String, String>),
      hostListeners: (_cloneIfPresent(
          map["hostListeners"]) as Map<String, String>),
      hostActions: (_cloneIfPresent(map["hostActions"]) as Map<String, String>),
      hostAttributes: (_cloneIfPresent(
          map["hostAttributes"]) as Map<String, String>),
      properties: (_cloneIfPresent(map["properties"]) as List<String>),
      readAttributes: (_cloneIfPresent(map["readAttributes"]) as List<String>),
      type: (map["type"] as num),
      exportAs: (map["exportAs"] as String),
      callOnDestroy: (map["callOnDestroy"] as bool),
      callOnCheck: (map["callOnCheck"] as bool),
      callOnChange: (map["callOnChange"] as bool),
      callOnInit: (map["callOnInit"] as bool),
      callOnAllChangesDone: (map["callOnAllChangesDone"] as bool),
      events: (_cloneIfPresent(map["events"]) as List<String>),
      changeDetection: (map["changeDetection"] as String));
}
/**
 * Clones the [List] or [Map] `o` if it is present.
 */
dynamic _cloneIfPresent(o) {
  if (!isPresent(o)) return null;
  return isArray(o) ? ListWrapper.clone(o) : MapWrapper.clone(o);
}
