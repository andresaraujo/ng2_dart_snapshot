library angular2.src.web_workers.shared.api;

import "package:angular2/di.dart" show OpaqueToken;
import "package:angular2/src/render/api.dart"
    show RenderElementRef, RenderViewRef;

const ON_WEBWORKER = const OpaqueToken("WebWorker.onWebWorker");
class WorkerElementRef implements RenderElementRef {
  RenderViewRef renderView;
  num renderBoundElementIndex;
  WorkerElementRef(this.renderView, this.renderBoundElementIndex) {}
}
