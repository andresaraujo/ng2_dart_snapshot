library angular2.src.web_workers.shared.serializer;

import "package:angular2/src/facade/lang.dart"
    show
        Type,
        isArray,
        isPresent,
        serializeEnum,
        deserializeEnum,
        BaseException;
import "package:angular2/src/facade/collection.dart"
    show List, ListWrapper, Map, Map, StringMapWrapper, MapWrapper;
import "package:angular2/src/render/api.dart"
    show
        ProtoViewDto,
        DirectiveMetadata,
        ElementBinder,
        DirectiveBinder,
        ElementPropertyBinding,
        EventBinding,
        ViewDefinition,
        RenderProtoViewRef,
        RenderProtoViewMergeMapping,
        RenderViewRef,
        RenderFragmentRef,
        RenderElementRef,
        ViewType,
        ViewEncapsulation,
        PropertyBindingType;
import "package:angular2/src/web-workers/shared/api.dart" show WorkerElementRef;
import "package:angular2/src/change_detection/change_detection.dart"
    show AST, ASTWithSource;
import "package:angular2/src/change_detection/parser/parser.dart" show Parser;
import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/web-workers/shared/render_proto_view_ref_store.dart"
    show RenderProtoViewRefStore;
import "package:angular2/src/web-workers/shared/render_view_with_fragments_store.dart"
    show RenderViewWithFragmentsStore;

@Injectable()
class Serializer {
  Parser _parser;
  RenderProtoViewRefStore _protoViewStore;
  RenderViewWithFragmentsStore _renderViewStore;
  Map<dynamic, Map<int, dynamic>> _enumRegistry;
  Serializer(this._parser, this._protoViewStore, this._renderViewStore) {
    this._enumRegistry = new Map<dynamic, Map<int, dynamic>>();
    var viewTypeMap = new Map<int, dynamic>();
    viewTypeMap[0] = ViewType.HOST;
    viewTypeMap[1] = ViewType.COMPONENT;
    viewTypeMap[2] = ViewType.EMBEDDED;
    this._enumRegistry[ViewType] = viewTypeMap;
    var viewEncapsulationMap = new Map<int, dynamic>();
    viewEncapsulationMap[0] = ViewEncapsulation.EMULATED;
    viewEncapsulationMap[1] = ViewEncapsulation.NATIVE;
    viewEncapsulationMap[2] = ViewEncapsulation.NONE;
    this._enumRegistry[ViewEncapsulation] = viewEncapsulationMap;
    var propertyBindingTypeMap = new Map<int, dynamic>();
    propertyBindingTypeMap[0] = PropertyBindingType.PROPERTY;
    propertyBindingTypeMap[1] = PropertyBindingType.ATTRIBUTE;
    propertyBindingTypeMap[2] = PropertyBindingType.CLASS;
    propertyBindingTypeMap[3] = PropertyBindingType.STYLE;
    this._enumRegistry[PropertyBindingType] = propertyBindingTypeMap;
  }
  Object serialize(dynamic obj, Type type) {
    if (!isPresent(obj)) {
      return null;
    }
    if (isArray(obj)) {
      var serializedObj = [];
      ListWrapper.forEach(obj, (val) {
        serializedObj.add(this.serialize(val, type));
      });
      return serializedObj;
    }
    if (type == String) {
      return obj;
    }
    if (type == ViewDefinition) {
      return this._serializeViewDefinition(obj);
    } else if (type == DirectiveBinder) {
      return this._serializeDirectiveBinder(obj);
    } else if (type == ProtoViewDto) {
      return this._serializeProtoViewDto(obj);
    } else if (type == ElementBinder) {
      return this._serializeElementBinder(obj);
    } else if (type == DirectiveMetadata) {
      return this._serializeDirectiveMetadata(obj);
    } else if (type == ASTWithSource) {
      return this._serializeASTWithSource(obj);
    } else if (type == RenderProtoViewRef) {
      return this._protoViewStore.serialize(obj);
    } else if (type == RenderProtoViewMergeMapping) {
      return this._serializeRenderProtoViewMergeMapping(obj);
    } else if (type == RenderViewRef) {
      return this._renderViewStore.serializeRenderViewRef(obj);
    } else if (type == RenderFragmentRef) {
      return this._renderViewStore.serializeRenderFragmentRef(obj);
    } else if (type == WorkerElementRef) {
      return this._serializeWorkerElementRef(obj);
    } else if (type == ElementPropertyBinding) {
      return this._serializeElementPropertyBinding(obj);
    } else if (type == EventBinding) {
      return this._serializeEventBinding(obj);
    } else {
      throw new BaseException("No serializer for " + type.toString());
    }
  }
  dynamic deserialize(dynamic map, Type type, [dynamic data]) {
    if (!isPresent(map)) {
      return null;
    }
    if (isArray(map)) {
      List<dynamic> obj = new List<dynamic>();
      ListWrapper.forEach(map, (val) {
        obj.add(this.deserialize(val, type, data));
      });
      return obj;
    }
    if (type == String) {
      return map;
    }
    if (type == ViewDefinition) {
      return this._deserializeViewDefinition(map);
    } else if (type == DirectiveBinder) {
      return this._deserializeDirectiveBinder(map);
    } else if (type == ProtoViewDto) {
      return this._deserializeProtoViewDto(map);
    } else if (type == DirectiveMetadata) {
      return this._deserializeDirectiveMetadata(map);
    } else if (type == ElementBinder) {
      return this._deserializeElementBinder(map);
    } else if (type == ASTWithSource) {
      return this._deserializeASTWithSource(map, data);
    } else if (type == RenderProtoViewRef) {
      return this._protoViewStore.deserialize(map);
    } else if (type == RenderProtoViewMergeMapping) {
      return this._deserializeRenderProtoViewMergeMapping(map);
    } else if (type == RenderViewRef) {
      return this._renderViewStore.deserializeRenderViewRef(map);
    } else if (type == RenderFragmentRef) {
      return this._renderViewStore.deserializeRenderFragmentRef(map);
    } else if (type == WorkerElementRef) {
      return this._deserializeWorkerElementRef(map);
    } else if (type == EventBinding) {
      return this._deserializeEventBinding(map);
    } else if (type == ElementPropertyBinding) {
      return this._deserializeElementPropertyBinding(map);
    } else {
      throw new BaseException("No deserializer for " + type.toString());
    }
  }
  Object mapToObject(Map<String, dynamic> map, [Type type]) {
    var object = {};
    var serialize = isPresent(type);
    MapWrapper.forEach(map, (value, key) {
      if (serialize) {
        object[key] = this.serialize(value, type);
      } else {
        object[key] = value;
      }
    });
    return object;
  }
  /*
   * Transforms a Javascript object (StringMap) into a Map<string, V>
   * If the values need to be deserialized pass in their type
   * and they will be deserialized before being placed in the map
   */
  Map<String, dynamic> objectToMap(Map<String, dynamic> obj,
      [Type type, dynamic data]) {
    if (isPresent(type)) {
      Map<String, dynamic> map = new Map();
      StringMapWrapper.forEach(obj, (val, key) {
        map[key] = this.deserialize(val, type, data);
      });
      return map;
    } else {
      return MapWrapper.createFromStringMap(obj);
    }
  }
  allocateRenderViews(num fragmentCount) {
    this._renderViewStore.allocate(fragmentCount);
  }
  Map<String, dynamic> _serializeElementPropertyBinding(
      ElementPropertyBinding binding) {
    return {
      "type": serializeEnum(binding.type),
      "astWithSource": this.serialize(binding.astWithSource, ASTWithSource),
      "property": binding.property,
      "unit": binding.unit
    };
  }
  ElementPropertyBinding _deserializeElementPropertyBinding(
      Map<String, dynamic> map) {
    var type =
        deserializeEnum(map["type"], this._enumRegistry[PropertyBindingType]);
    var ast = this.deserialize(map["astWithSource"], ASTWithSource, "binding");
    return new ElementPropertyBinding(type, ast, map["property"], map["unit"]);
  }
  Map<String, dynamic> _serializeEventBinding(EventBinding binding) {
    return {
      "fullName": binding.fullName,
      "source": this.serialize(binding.source, ASTWithSource)
    };
  }
  EventBinding _deserializeEventBinding(Map<String, dynamic> map) {
    return new EventBinding(map["fullName"],
        this.deserialize(map["source"], ASTWithSource, "action"));
  }
  Map<String, dynamic> _serializeWorkerElementRef(RenderElementRef elementRef) {
    return {
      "renderView": this.serialize(elementRef.renderView, RenderViewRef),
      "renderBoundElementIndex": elementRef.renderBoundElementIndex
    };
  }
  RenderElementRef _deserializeWorkerElementRef(Map<String, dynamic> map) {
    return new WorkerElementRef(
        this.deserialize(map["renderView"], RenderViewRef),
        map["renderBoundElementIndex"]);
  }
  Object _serializeRenderProtoViewMergeMapping(
      RenderProtoViewMergeMapping mapping) {
    return {
      "mergedProtoViewRef":
          this._protoViewStore.serialize(mapping.mergedProtoViewRef),
      "fragmentCount": mapping.fragmentCount,
      "mappedElementIndices": mapping.mappedElementIndices,
      "mappedElementCount": mapping.mappedElementCount,
      "mappedTextIndices": mapping.mappedTextIndices,
      "hostElementIndicesByViewIndex": mapping.hostElementIndicesByViewIndex,
      "nestedViewCountByViewIndex": mapping.nestedViewCountByViewIndex
    };
  }
  RenderProtoViewMergeMapping _deserializeRenderProtoViewMergeMapping(
      Map<String, dynamic> obj) {
    return new RenderProtoViewMergeMapping(
        this._protoViewStore.deserialize(obj["mergedProtoViewRef"]),
        obj["fragmentCount"], obj["mappedElementIndices"],
        obj["mappedElementCount"], obj["mappedTextIndices"],
        obj["hostElementIndicesByViewIndex"],
        obj["nestedViewCountByViewIndex"]);
  }
  Object _serializeASTWithSource(ASTWithSource tree) {
    return {"input": tree.source, "location": tree.location};
  }
  AST _deserializeASTWithSource(Map<String, dynamic> obj, String data) {
    // TODO: make ASTs serializable
    AST ast;
    switch (data) {
      case "action":
        ast = this._parser.parseAction(obj["input"], obj["location"]);
        break;
      case "binding":
        ast = this._parser.parseBinding(obj["input"], obj["location"]);
        break;
      case "interpolation":
        ast = this._parser.parseInterpolation(obj["input"], obj["location"]);
        break;
      default:
        throw "No AST deserializer for " + data;
    }
    return ast;
  }
  Object _serializeViewDefinition(ViewDefinition view) {
    return {
      "componentId": view.componentId,
      "templateAbsUrl": view.templateAbsUrl,
      "template": view.template,
      "directives": this.serialize(view.directives, DirectiveMetadata),
      "styleAbsUrls": view.styleAbsUrls,
      "styles": view.styles,
      "encapsulation": serializeEnum(view.encapsulation)
    };
  }
  ViewDefinition _deserializeViewDefinition(Map<String, dynamic> obj) {
    return new ViewDefinition(
        componentId: obj["componentId"],
        templateAbsUrl: obj["templateAbsUrl"],
        template: obj["template"],
        directives: this.deserialize(obj["directives"], DirectiveMetadata),
        styleAbsUrls: obj["styleAbsUrls"],
        styles: obj["styles"],
        encapsulation: deserializeEnum(
            obj["encapsulation"], this._enumRegistry[ViewEncapsulation]));
  }
  Object _serializeDirectiveBinder(DirectiveBinder binder) {
    return {
      "directiveIndex": binder.directiveIndex,
      "propertyBindings":
          this.mapToObject(binder.propertyBindings, ASTWithSource),
      "eventBindings": this.serialize(binder.eventBindings, EventBinding),
      "hostPropertyBindings":
          this.serialize(binder.hostPropertyBindings, ElementPropertyBinding)
    };
  }
  DirectiveBinder _deserializeDirectiveBinder(Map<String, dynamic> obj) {
    return new DirectiveBinder(
        directiveIndex: obj["directiveIndex"],
        propertyBindings: this.objectToMap(
            obj["propertyBindings"], ASTWithSource, "binding"),
        eventBindings: this.deserialize(obj["eventBindings"], EventBinding),
        hostPropertyBindings: this.deserialize(
            obj["hostPropertyBindings"], ElementPropertyBinding));
  }
  Object _serializeElementBinder(ElementBinder binder) {
    return {
      "index": binder.index,
      "parentIndex": binder.parentIndex,
      "distanceToParent": binder.distanceToParent,
      "directives": this.serialize(binder.directives, DirectiveBinder),
      "nestedProtoView": this.serialize(binder.nestedProtoView, ProtoViewDto),
      "propertyBindings":
          this.serialize(binder.propertyBindings, ElementPropertyBinding),
      "variableBindings": this.mapToObject(binder.variableBindings),
      "eventBindings": this.serialize(binder.eventBindings, EventBinding),
      "readAttributes": this.mapToObject(binder.readAttributes)
    };
  }
  ElementBinder _deserializeElementBinder(Map<String, dynamic> obj) {
    return new ElementBinder(
        index: obj["index"],
        parentIndex: obj["parentIndex"],
        distanceToParent: obj["distanceToParent"],
        directives: this.deserialize(obj["directives"], DirectiveBinder),
        nestedProtoView: this.deserialize(obj["nestedProtoView"], ProtoViewDto),
        propertyBindings: this.deserialize(
            obj["propertyBindings"], ElementPropertyBinding),
        variableBindings: this.objectToMap(obj["variableBindings"]),
        eventBindings: this.deserialize(obj["eventBindings"], EventBinding),
        readAttributes: this.objectToMap(obj["readAttributes"]));
  }
  Object _serializeProtoViewDto(ProtoViewDto view) {
    return {
      "render": this._protoViewStore.serialize(view.render),
      "elementBinders": this.serialize(view.elementBinders, ElementBinder),
      "variableBindings": this.mapToObject(view.variableBindings),
      "type": serializeEnum(view.type),
      "textBindings": this.serialize(view.textBindings, ASTWithSource),
      "transitiveNgContentCount": view.transitiveNgContentCount
    };
  }
  ProtoViewDto _deserializeProtoViewDto(Map<String, dynamic> obj) {
    return new ProtoViewDto(
        render: this._protoViewStore.deserialize(obj["render"]),
        elementBinders: this.deserialize(obj["elementBinders"], ElementBinder),
        variableBindings: this.objectToMap(obj["variableBindings"]),
        textBindings: this.deserialize(
            obj["textBindings"], ASTWithSource, "interpolation"),
        type: deserializeEnum(obj["type"], this._enumRegistry[ViewType]),
        transitiveNgContentCount: obj["transitiveNgContentCount"]);
  }
  Object _serializeDirectiveMetadata(DirectiveMetadata meta) {
    var obj = {
      "id": meta.id,
      "selector": meta.selector,
      "compileChildren": meta.compileChildren,
      "events": meta.events,
      "properties": meta.properties,
      "readAttributes": meta.readAttributes,
      "type": meta.type,
      "callOnDestroy": meta.callOnDestroy,
      "callOnChange": meta.callOnChange,
      "callOnCheck": meta.callOnCheck,
      "callOnInit": meta.callOnInit,
      "callOnAllChangesDone": meta.callOnAllChangesDone,
      "changeDetection": meta.changeDetection,
      "exportAs": meta.exportAs,
      "hostProperties": this.mapToObject(meta.hostProperties),
      "hostListeners": this.mapToObject(meta.hostListeners),
      "hostActions": this.mapToObject(meta.hostActions),
      "hostAttributes": this.mapToObject(meta.hostAttributes)
    };
    return obj;
  }
  DirectiveMetadata _deserializeDirectiveMetadata(Map<String, dynamic> obj) {
    return new DirectiveMetadata(
        id: obj["id"],
        selector: obj["selector"],
        compileChildren: obj["compileChildren"],
        hostProperties: this.objectToMap(obj["hostProperties"]),
        hostListeners: this.objectToMap(obj["hostListeners"]),
        hostActions: this.objectToMap(obj["hostActions"]),
        hostAttributes: this.objectToMap(obj["hostAttributes"]),
        properties: obj["properties"],
        readAttributes: obj["readAttributes"],
        type: obj["type"],
        exportAs: obj["exportAs"],
        callOnDestroy: obj["callOnDestroy"],
        callOnChange: obj["callOnChange"],
        callOnCheck: obj["callOnCheck"],
        callOnInit: obj["callOnInit"],
        callOnAllChangesDone: obj["callOnAllChangesDone"],
        changeDetection: obj["changeDetection"],
        events: obj["events"]);
  }
}
