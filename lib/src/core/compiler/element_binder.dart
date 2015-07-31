library angular2.src.core.compiler.element_binder;

import "package:angular2/src/change_detection/change_detection.dart" show AST;
import "package:angular2/src/facade/lang.dart"
    show isBlank, isPresent, BaseException;
import "element_injector.dart" as eiModule;
import "element_injector.dart" show DirectiveBinding;
import "package:angular2/src/facade/collection.dart" show List, Map;
import "view.dart" as viewModule;

class ElementBinder {
  int index;
  ElementBinder parent;
  int distanceToParent;
  eiModule.ProtoElementInjector protoElementInjector;
  DirectiveBinding componentDirective;
  // updated later, so we are able to resolve cycles
  viewModule.AppProtoView nestedProtoView = null;
  // updated later when events are bound
  Map<String, Map<num, AST>> hostListeners = null;
  ElementBinder(this.index, this.parent, this.distanceToParent,
      this.protoElementInjector, this.componentDirective) {
    if (isBlank(index)) {
      throw new BaseException("null index not allowed.");
    }
  }
  bool hasStaticComponent() {
    return isPresent(this.componentDirective) &&
        isPresent(this.nestedProtoView);
  }
  bool hasEmbeddedProtoView() {
    return !isPresent(this.componentDirective) &&
        isPresent(this.nestedProtoView);
  }
}
