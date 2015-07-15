library angular2.src.render.dom.view.element_binder;

import "package:angular2/change_detection.dart" show AST;
import "package:angular2/src/facade/collection.dart" show List, ListWrapper;
import "proto_view.dart" as protoViewModule;

class ElementBinder {
  String contentTagSelector;
  List<num> textNodeIndices;
  protoViewModule.DomProtoView nestedProtoView;
  AST eventLocals;
  List<Event> localEvents;
  List<Event> globalEvents;
  String componentId;
  num parentIndex;
  num distanceToParent;
  bool elementIsEmpty;
  ElementBinder({textNodeIndices, contentTagSelector, nestedProtoView,
      componentId, eventLocals, localEvents, globalEvents, parentIndex,
      distanceToParent, elementIsEmpty}) {
    this.textNodeIndices = textNodeIndices;
    this.contentTagSelector = contentTagSelector;
    this.nestedProtoView = nestedProtoView;
    this.componentId = componentId;
    this.eventLocals = eventLocals;
    this.localEvents = localEvents;
    this.globalEvents = globalEvents;
    this.parentIndex = parentIndex;
    this.distanceToParent = distanceToParent;
    this.elementIsEmpty = elementIsEmpty;
  }
}
class Event {
  String name;
  String target;
  String fullName;
  Event(this.name, this.target, this.fullName) {}
}
class HostAction {
  String actionName;
  String actionExpression;
  AST expression;
  HostAction(this.actionName, this.actionExpression, this.expression) {}
}
