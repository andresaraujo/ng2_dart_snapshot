library angular2.src.render.dom.view.element_binder;

import "package:angular2/src/change_detection/change_detection.dart" show AST;
import "package:angular2/src/facade/collection.dart" show List, ListWrapper;
import "package:angular2/src/facade/lang.dart" show isPresent;

class DomElementBinder {
  List<num> textNodeIndices;
  bool hasNestedProtoView;
  AST eventLocals;
  List<Event> localEvents;
  List<Event> globalEvents;
  bool hasNativeShadowRoot;
  DomElementBinder({textNodeIndices, hasNestedProtoView, eventLocals,
      localEvents, globalEvents, hasNativeShadowRoot}) {
    this.textNodeIndices = textNodeIndices;
    this.hasNestedProtoView = hasNestedProtoView;
    this.eventLocals = eventLocals;
    this.localEvents = localEvents;
    this.globalEvents = globalEvents;
    this.hasNativeShadowRoot =
        isPresent(hasNativeShadowRoot) ? hasNativeShadowRoot : false;
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
