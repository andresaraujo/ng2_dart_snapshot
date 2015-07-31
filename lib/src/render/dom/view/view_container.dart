library angular2.src.render.dom.view.view_container;

import "package:angular2/src/facade/collection.dart"
    show ListWrapper, MapWrapper, List;
import "view.dart" as viewModule;

class DomViewContainer {
  // The order in this list matches the DOM order.
  List<viewModule.DomView> views = [];
}
