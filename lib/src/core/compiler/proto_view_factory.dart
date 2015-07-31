library angular2.src.core.compiler.proto_view_factory;

import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/facade/collection.dart"
    show List, ListWrapper, MapWrapper;
import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, BaseException, assertionsEnabled;
import "package:angular2/src/reflection/reflection.dart" show reflector;
import "package:angular2/src/change_detection/change_detection.dart"
    show
        ChangeDetection,
        DirectiveIndex,
        BindingRecord,
        DirectiveRecord,
        ProtoChangeDetector,
        DEFAULT,
        ChangeDetectorDefinition,
        ASTWithSource;
import "package:angular2/src/render/api.dart" as renderApi;
import "view.dart" show AppProtoView;
import "element_binder.dart" show ElementBinder;
import "element_injector.dart" show ProtoElementInjector, DirectiveBinding;

class BindingRecordsCreator {
  Map<num, DirectiveRecord> _directiveRecordsMap = new Map();
  List<BindingRecord> getBindingRecords(List<ASTWithSource> textBindings,
      List<renderApi.ElementBinder> elementBinders,
      List<renderApi.DirectiveMetadata> allDirectiveMetadatas) {
    var bindings = [];
    this._createTextNodeRecords(bindings, textBindings);
    for (var boundElementIndex = 0;
        boundElementIndex < elementBinders.length;
        boundElementIndex++) {
      var renderElementBinder = elementBinders[boundElementIndex];
      this._createElementPropertyRecords(
          bindings, boundElementIndex, renderElementBinder);
      this._createDirectiveRecords(bindings, boundElementIndex,
          renderElementBinder.directives, allDirectiveMetadatas);
    }
    return bindings;
  }
  List<DirectiveRecord> getDirectiveRecords(
      List<renderApi.ElementBinder> elementBinders,
      List<renderApi.DirectiveMetadata> allDirectiveMetadatas) {
    var directiveRecords = [];
    for (var elementIndex = 0;
        elementIndex < elementBinders.length;
        ++elementIndex) {
      var dirs = elementBinders[elementIndex].directives;
      for (var dirIndex = 0; dirIndex < dirs.length; ++dirIndex) {
        directiveRecords.add(this._getDirectiveRecord(elementIndex, dirIndex,
            allDirectiveMetadatas[dirs[dirIndex].directiveIndex]));
      }
    }
    return directiveRecords;
  }
  _createTextNodeRecords(
      List<BindingRecord> bindings, List<ASTWithSource> textBindings) {
    for (var i = 0; i < textBindings.length; i++) {
      bindings.add(BindingRecord.createForTextNode(textBindings[i], i));
    }
  }
  _createElementPropertyRecords(List<BindingRecord> bindings,
      num boundElementIndex, renderApi.ElementBinder renderElementBinder) {
    ListWrapper.forEach(renderElementBinder.propertyBindings, (binding) {
      if (identical(binding.type, renderApi.PropertyBindingType.PROPERTY)) {
        bindings.add(BindingRecord.createForElementProperty(
            binding.astWithSource, boundElementIndex, binding.property));
      } else if (identical(
          binding.type, renderApi.PropertyBindingType.ATTRIBUTE)) {
        bindings.add(BindingRecord.createForElementAttribute(
            binding.astWithSource, boundElementIndex, binding.property));
      } else if (identical(binding.type, renderApi.PropertyBindingType.CLASS)) {
        bindings.add(BindingRecord.createForElementClass(
            binding.astWithSource, boundElementIndex, binding.property));
      } else if (identical(binding.type, renderApi.PropertyBindingType.STYLE)) {
        bindings.add(BindingRecord.createForElementStyle(binding.astWithSource,
            boundElementIndex, binding.property, binding.unit));
      }
    });
  }
  _createDirectiveRecords(List<BindingRecord> bindings, num boundElementIndex,
      List<renderApi.DirectiveBinder> directiveBinders,
      List<renderApi.DirectiveMetadata> allDirectiveMetadatas) {
    for (var i = 0; i < directiveBinders.length; i++) {
      var directiveBinder = directiveBinders[i];
      var directiveMetadata =
          allDirectiveMetadatas[directiveBinder.directiveIndex];
      var directiveRecord =
          this._getDirectiveRecord(boundElementIndex, i, directiveMetadata);
      // directive properties
      MapWrapper.forEach(directiveBinder.propertyBindings,
          (astWithSource, propertyName) {
        // TODO: these setters should eventually be created by change detection, to make

        // it monomorphic!
        var setter = reflector.setter(propertyName);
        bindings.add(BindingRecord.createForDirective(
            astWithSource, propertyName, setter, directiveRecord));
      });
      if (directiveRecord.callOnChange) {
        bindings.add(BindingRecord.createDirectiveOnChange(directiveRecord));
      }
      if (directiveRecord.callOnInit) {
        bindings.add(BindingRecord.createDirectiveOnInit(directiveRecord));
      }
      if (directiveRecord.callOnCheck) {
        bindings.add(BindingRecord.createDirectiveOnCheck(directiveRecord));
      }
    }
    for (var i = 0; i < directiveBinders.length; i++) {
      var directiveBinder = directiveBinders[i];
      // host properties
      ListWrapper.forEach(directiveBinder.hostPropertyBindings, (binding) {
        var dirIndex = new DirectiveIndex(boundElementIndex, i);
        if (identical(binding.type, renderApi.PropertyBindingType.PROPERTY)) {
          bindings.add(BindingRecord.createForHostProperty(
              dirIndex, binding.astWithSource, binding.property));
        } else if (identical(
            binding.type, renderApi.PropertyBindingType.ATTRIBUTE)) {
          bindings.add(BindingRecord.createForHostAttribute(
              dirIndex, binding.astWithSource, binding.property));
        } else if (identical(
            binding.type, renderApi.PropertyBindingType.CLASS)) {
          bindings.add(BindingRecord.createForHostClass(
              dirIndex, binding.astWithSource, binding.property));
        } else if (identical(
            binding.type, renderApi.PropertyBindingType.STYLE)) {
          bindings.add(BindingRecord.createForHostStyle(
              dirIndex, binding.astWithSource, binding.property, binding.unit));
        }
      });
    }
  }
  DirectiveRecord _getDirectiveRecord(num boundElementIndex, num directiveIndex,
      renderApi.DirectiveMetadata directiveMetadata) {
    var id = boundElementIndex * 100 + directiveIndex;
    if (!this._directiveRecordsMap.containsKey(id)) {
      this._directiveRecordsMap[id] = new DirectiveRecord(
          directiveIndex: new DirectiveIndex(boundElementIndex, directiveIndex),
          callOnAllChangesDone: directiveMetadata.callOnAllChangesDone,
          callOnChange: directiveMetadata.callOnChange,
          callOnCheck: directiveMetadata.callOnCheck,
          callOnInit: directiveMetadata.callOnInit,
          changeDetection: directiveMetadata.changeDetection);
    }
    return this._directiveRecordsMap[id];
  }
}
@Injectable()
class ProtoViewFactory {
  ChangeDetection _changeDetection;
  /**
   * @private
   */
  ProtoViewFactory(this._changeDetection) {}
  List<AppProtoView> createAppProtoViews(DirectiveBinding hostComponentBinding,
      renderApi.ProtoViewDto rootRenderProtoView,
      List<DirectiveBinding> allDirectives) {
    var allRenderDirectiveMetadata = ListWrapper.map(
        allDirectives, (directiveBinding) => directiveBinding.metadata);
    var nestedPvsWithIndex = _collectNestedProtoViews(rootRenderProtoView);
    var nestedPvVariableBindings =
        _collectNestedProtoViewsVariableBindings(nestedPvsWithIndex);
    var nestedPvVariableNames =
        _collectNestedProtoViewsVariableNames(nestedPvsWithIndex);
    var changeDetectorDefs = _getChangeDetectorDefinitions(
        hostComponentBinding.metadata, nestedPvsWithIndex,
        nestedPvVariableNames, allRenderDirectiveMetadata);
    var protoChangeDetectors = ListWrapper.map(changeDetectorDefs,
        (changeDetectorDef) =>
            this._changeDetection.createProtoChangeDetector(changeDetectorDef));
    var appProtoViews = ListWrapper.createFixedSize(nestedPvsWithIndex.length);
    ListWrapper.forEach(nestedPvsWithIndex,
        (RenderProtoViewWithIndex pvWithIndex) {
      var appProtoView = _createAppProtoView(pvWithIndex.renderProtoView,
          protoChangeDetectors[pvWithIndex.index],
          nestedPvVariableBindings[pvWithIndex.index], allDirectives);
      if (isPresent(pvWithIndex.parentIndex)) {
        var parentView = appProtoViews[pvWithIndex.parentIndex];
        parentView.elementBinders[
            pvWithIndex.boundElementIndex].nestedProtoView = appProtoView;
      }
      appProtoViews[pvWithIndex.index] = appProtoView;
    });
    return appProtoViews;
  }
}
/**
 * Returns the data needed to create ChangeDetectors
 * for the given ProtoView and all nested ProtoViews.
 */
List<ChangeDetectorDefinition> getChangeDetectorDefinitions(
    renderApi.DirectiveMetadata hostComponentMetadata,
    renderApi.ProtoViewDto rootRenderProtoView,
    List<renderApi.DirectiveMetadata> allRenderDirectiveMetadata) {
  var nestedPvsWithIndex = _collectNestedProtoViews(rootRenderProtoView);
  var nestedPvVariableNames =
      _collectNestedProtoViewsVariableNames(nestedPvsWithIndex);
  return _getChangeDetectorDefinitions(hostComponentMetadata,
      nestedPvsWithIndex, nestedPvVariableNames, allRenderDirectiveMetadata);
}
List<RenderProtoViewWithIndex> _collectNestedProtoViews(
    renderApi.ProtoViewDto renderProtoView, [num parentIndex = null,
    boundElementIndex = null, List<RenderProtoViewWithIndex> result = null]) {
  if (isBlank(result)) {
    result = [];
  }
  // reserve the place in the array
  result.add(new RenderProtoViewWithIndex(
      renderProtoView, result.length, parentIndex, boundElementIndex));
  var currentIndex = result.length - 1;
  var childBoundElementIndex = 0;
  ListWrapper.forEach(renderProtoView.elementBinders, (elementBinder) {
    if (isPresent(elementBinder.nestedProtoView)) {
      _collectNestedProtoViews(elementBinder.nestedProtoView, currentIndex,
          childBoundElementIndex, result);
    }
    childBoundElementIndex++;
  });
  return result;
}
List<ChangeDetectorDefinition> _getChangeDetectorDefinitions(
    renderApi.DirectiveMetadata hostComponentMetadata,
    List<RenderProtoViewWithIndex> nestedPvsWithIndex,
    List<List<String>> nestedPvVariableNames,
    List<renderApi.DirectiveMetadata> allRenderDirectiveMetadata) {
  return ListWrapper.map(nestedPvsWithIndex, (pvWithIndex) {
    var elementBinders = pvWithIndex.renderProtoView.elementBinders;
    var bindingRecordsCreator = new BindingRecordsCreator();
    var bindingRecords = bindingRecordsCreator.getBindingRecords(
        pvWithIndex.renderProtoView.textBindings, elementBinders,
        allRenderDirectiveMetadata);
    var directiveRecords = bindingRecordsCreator.getDirectiveRecords(
        elementBinders, allRenderDirectiveMetadata);
    var strategyName = DEFAULT;
    var typeString;
    if (identical(
        pvWithIndex.renderProtoView.type, renderApi.ViewType.COMPONENT)) {
      strategyName = hostComponentMetadata.changeDetection;
      typeString = "comp";
    } else if (identical(
        pvWithIndex.renderProtoView.type, renderApi.ViewType.HOST)) {
      typeString = "host";
    } else {
      typeString = "embedded";
    }
    var id =
        '''${ hostComponentMetadata . id}_${ typeString}_${ pvWithIndex . index}''';
    var variableNames = nestedPvVariableNames[pvWithIndex.index];
    return new ChangeDetectorDefinition(id, strategyName, variableNames,
        bindingRecords, directiveRecords, assertionsEnabled());
  });
}
AppProtoView _createAppProtoView(renderApi.ProtoViewDto renderProtoView,
    ProtoChangeDetector protoChangeDetector,
    Map<String, String> variableBindings,
    List<DirectiveBinding> allDirectives) {
  var elementBinders = renderProtoView.elementBinders;
  // Embedded ProtoViews that contain `<ng-content>` will be merged into their parents and use

  // a RenderFragmentRef. I.e. renderProtoView.transitiveNgContentCount > 0.
  var protoView = new AppProtoView(renderProtoView.type,
      renderProtoView.transitiveNgContentCount > 0, renderProtoView.render,
      protoChangeDetector, variableBindings,
      createVariableLocations(elementBinders),
      renderProtoView.textBindings.length);
  _createElementBinders(protoView, elementBinders, allDirectives);
  _bindDirectiveEvents(protoView, elementBinders);
  return protoView;
}
List<Map<String, String>> _collectNestedProtoViewsVariableBindings(
    List<RenderProtoViewWithIndex> nestedPvsWithIndex) {
  return ListWrapper.map(nestedPvsWithIndex, (pvWithIndex) {
    return _createVariableBindings(pvWithIndex.renderProtoView);
  });
}
Map<String, String> _createVariableBindings(renderProtoView) {
  var variableBindings = new Map();
  MapWrapper.forEach(renderProtoView.variableBindings, (mappedName, varName) {
    variableBindings[varName] = mappedName;
  });
  return variableBindings;
}
List<List<String>> _collectNestedProtoViewsVariableNames(
    List<RenderProtoViewWithIndex> nestedPvsWithIndex) {
  var nestedPvVariableNames =
      ListWrapper.createFixedSize(nestedPvsWithIndex.length);
  ListWrapper.forEach(nestedPvsWithIndex, (pvWithIndex) {
    var parentVariableNames = isPresent(pvWithIndex.parentIndex)
        ? nestedPvVariableNames[pvWithIndex.parentIndex]
        : null;
    nestedPvVariableNames[pvWithIndex.index] =
        _createVariableNames(parentVariableNames, pvWithIndex.renderProtoView);
  });
  return nestedPvVariableNames;
}
List<String> _createVariableNames(
    List<String> parentVariableNames, renderProtoView) {
  var res = isBlank(parentVariableNames)
      ? ([] as List<String>)
      : ListWrapper.clone(parentVariableNames);
  MapWrapper.forEach(renderProtoView.variableBindings, (mappedName, varName) {
    res.add(mappedName);
  });
  ListWrapper.forEach(renderProtoView.elementBinders, (binder) {
    MapWrapper.forEach(binder.variableBindings,
        (String mappedName, String varName) {
      res.add(mappedName);
    });
  });
  return res;
}
Map<String, num> createVariableLocations(
    List<renderApi.ElementBinder> elementBinders) {
  var variableLocations = new Map();
  for (var i = 0; i < elementBinders.length; i++) {
    var binder = elementBinders[i];
    MapWrapper.forEach(binder.variableBindings, (mappedName, varName) {
      variableLocations[mappedName] = i;
    });
  }
  return variableLocations;
}
_createElementBinders(protoView, elementBinders, allDirectiveBindings) {
  for (var i = 0; i < elementBinders.length; i++) {
    var renderElementBinder = elementBinders[i];
    var dirs = elementBinders[i].directives;
    var parentPeiWithDistance = _findParentProtoElementInjectorWithDistance(
        i, protoView.elementBinders, elementBinders);
    var directiveBindings = ListWrapper.map(
        dirs, (dir) => allDirectiveBindings[dir.directiveIndex]);
    var componentDirectiveBinding = null;
    if (directiveBindings.length > 0) {
      if (identical(directiveBindings[0].metadata.type,
          renderApi.DirectiveMetadata.COMPONENT_TYPE)) {
        componentDirectiveBinding = directiveBindings[0];
      }
    }
    var protoElementInjector = _createProtoElementInjector(i,
        parentPeiWithDistance, renderElementBinder, componentDirectiveBinding,
        directiveBindings);
    _createElementBinder(protoView, i, renderElementBinder,
        protoElementInjector, componentDirectiveBinding, directiveBindings);
  }
}
ParentProtoElementInjectorWithDistance _findParentProtoElementInjectorWithDistance(
    binderIndex, elementBinders, renderElementBinders) {
  var distance = 0;
  do {
    var renderElementBinder = renderElementBinders[binderIndex];
    binderIndex = renderElementBinder.parentIndex;
    if (!identical(binderIndex, -1)) {
      distance += renderElementBinder.distanceToParent;
      var elementBinder = elementBinders[binderIndex];
      if (isPresent(elementBinder.protoElementInjector)) {
        return new ParentProtoElementInjectorWithDistance(
            elementBinder.protoElementInjector, distance);
      }
    }
  } while (!identical(binderIndex, -1));
  return new ParentProtoElementInjectorWithDistance(null, 0);
}
_createProtoElementInjector(binderIndex, parentPeiWithDistance,
    renderElementBinder, componentDirectiveBinding, directiveBindings) {
  var protoElementInjector = null;
  // Create a protoElementInjector for any element that either has bindings *or* has one

  // or more var- defined. Elements with a var- defined need a their own element injector

  // so that, when hydrating, $implicit can be set to the element.
  var hasVariables = MapWrapper.size(renderElementBinder.variableBindings) > 0;
  if (directiveBindings.length > 0 || hasVariables) {
    var directiveVariableBindings =
        createDirectiveVariableBindings(renderElementBinder, directiveBindings);
    protoElementInjector = ProtoElementInjector.create(
        parentPeiWithDistance.protoElementInjector, binderIndex,
        directiveBindings, isPresent(componentDirectiveBinding),
        parentPeiWithDistance.distance, directiveVariableBindings);
    protoElementInjector.attributes = renderElementBinder.readAttributes;
  }
  return protoElementInjector;
}
ElementBinder _createElementBinder(AppProtoView protoView, boundElementIndex,
    renderElementBinder, protoElementInjector, componentDirectiveBinding,
    directiveBindings) {
  var parent = null;
  if (!identical(renderElementBinder.parentIndex, -1)) {
    parent = protoView.elementBinders[renderElementBinder.parentIndex];
  }
  var elBinder = protoView.bindElement(parent,
      renderElementBinder.distanceToParent, protoElementInjector,
      componentDirectiveBinding);
  protoView.bindEvent(renderElementBinder.eventBindings, boundElementIndex, -1);
  // variables

  // The view's locals needs to have a full set of variable names at construction time

  // in order to prevent new variables from being set later in the lifecycle. Since we don't want

  // to actually create variable bindings for the $implicit bindings, add to the

  // protoLocals manually.
  MapWrapper.forEach(renderElementBinder.variableBindings,
      (mappedName, varName) {
    protoView.protoLocals[mappedName] = null;
  });
  return elBinder;
}
Map<String, num> createDirectiveVariableBindings(
    renderApi.ElementBinder renderElementBinder,
    List<DirectiveBinding> directiveBindings) {
  var directiveVariableBindings = new Map();
  MapWrapper.forEach(renderElementBinder.variableBindings,
      (templateName, exportAs) {
    var dirIndex = _findDirectiveIndexByExportAs(
        renderElementBinder, directiveBindings, exportAs);
    directiveVariableBindings[templateName] = dirIndex;
  });
  return directiveVariableBindings;
}
_findDirectiveIndexByExportAs(
    renderElementBinder, directiveBindings, exportAs) {
  var matchedDirectiveIndex = null;
  var matchedDirective;
  for (var i = 0; i < directiveBindings.length; ++i) {
    var directive = directiveBindings[i];
    if (_directiveExportAs(directive) == exportAs) {
      if (isPresent(matchedDirective)) {
        throw new BaseException(
            '''More than one directive have exportAs = \'${ exportAs}\'. Directives: [${ matchedDirective . displayName}, ${ directive . displayName}]''');
      }
      matchedDirectiveIndex = i;
      matchedDirective = directive;
    }
  }
  if (isBlank(matchedDirective) && !identical(exportAs, "\$implicit")) {
    throw new BaseException(
        '''Cannot find directive with exportAs = \'${ exportAs}\'''');
  }
  return matchedDirectiveIndex;
}
String _directiveExportAs(directive) {
  var directiveExportAs = directive.metadata.exportAs;
  if (isBlank(directiveExportAs) &&
      identical(directive.metadata.type,
          renderApi.DirectiveMetadata.COMPONENT_TYPE)) {
    return "\$implicit";
  } else {
    return directiveExportAs;
  }
}
_bindDirectiveEvents(protoView, List<renderApi.ElementBinder> elementBinders) {
  for (var boundElementIndex = 0;
      boundElementIndex < elementBinders.length;
      ++boundElementIndex) {
    var dirs = elementBinders[boundElementIndex].directives;
    for (var i = 0; i < dirs.length; i++) {
      var directiveBinder = dirs[i];
      // directive events
      protoView.bindEvent(directiveBinder.eventBindings, boundElementIndex, i);
    }
  }
}
class RenderProtoViewWithIndex {
  renderApi.ProtoViewDto renderProtoView;
  num index;
  num parentIndex;
  num boundElementIndex;
  RenderProtoViewWithIndex(this.renderProtoView, this.index, this.parentIndex,
      this.boundElementIndex) {}
}
class ParentProtoElementInjectorWithDistance {
  ProtoElementInjector protoElementInjector;
  num distance;
  ParentProtoElementInjectorWithDistance(
      this.protoElementInjector, this.distance) {}
}
