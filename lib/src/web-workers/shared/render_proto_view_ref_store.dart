library angular2.src.web_workers.shared.render_proto_view_ref_store;

import "package:angular2/di.dart" show Injectable, Inject;
import "package:angular2/src/render/api.dart" show RenderProtoViewRef;
import "package:angular2/src/web-workers/shared/api.dart" show ON_WEBWORKER;

@Injectable()
class RenderProtoViewRefStore {
  Map<num, RenderProtoViewRef> _lookupByIndex =
      new Map<num, RenderProtoViewRef>();
  Map<RenderProtoViewRef, num> _lookupByProtoView =
      new Map<RenderProtoViewRef, num>();
  num _nextIndex = 0;
  bool _onWebworker;
  RenderProtoViewRefStore(@Inject(ON_WEBWORKER) onWebworker) {
    this._onWebworker = onWebworker;
  }
  num storeRenderProtoViewRef(RenderProtoViewRef ref) {
    if (this._lookupByProtoView.containsKey(ref)) {
      return this._lookupByProtoView[ref];
    } else {
      this._lookupByIndex[this._nextIndex] = ref;
      this._lookupByProtoView[ref] = this._nextIndex;
      return this._nextIndex++;
    }
  }
  RenderProtoViewRef retreiveRenderProtoViewRef(num index) {
    return this._lookupByIndex[index];
  }
  RenderProtoViewRef deserialize(num index) {
    if (index == null) {
      return null;
    }
    if (this._onWebworker) {
      return new WebworkerRenderProtoViewRef(index);
    } else {
      return this.retreiveRenderProtoViewRef(index);
    }
  }
  num serialize(RenderProtoViewRef ref) {
    if (ref == null) {
      return null;
    }
    if (this._onWebworker) {
      return ((ref as WebworkerRenderProtoViewRef)).refNumber;
    } else {
      return this.storeRenderProtoViewRef(ref);
    }
  }
}
class WebworkerRenderProtoViewRef extends RenderProtoViewRef {
  num refNumber;
  WebworkerRenderProtoViewRef(this.refNumber) : super() {
    /* super call moved to initializer */;
  }
}
