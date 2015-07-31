library angular2.src.web_workers.shared.render_view_with_fragments_store;

import "package:angular2/di.dart" show Injectable, Inject;
import "package:angular2/src/render/api.dart"
    show RenderViewRef, RenderFragmentRef, RenderViewWithFragments;
import "package:angular2/src/web-workers/shared/api.dart" show ON_WEBWORKER;
import "package:angular2/src/facade/collection.dart" show List, ListWrapper;

@Injectable()
class RenderViewWithFragmentsStore {
  num _nextIndex = 0;
  bool _onWebWorker;
  Map<num, dynamic /* RenderViewRef | RenderFragmentRef */ > _lookupByIndex;
  Map<dynamic /* RenderViewRef | RenderFragmentRef */, num> _lookupByView;
  RenderViewWithFragmentsStore(@Inject(ON_WEBWORKER) onWebWorker) {
    this._onWebWorker = onWebWorker;
    this._lookupByIndex =
        new Map<num, dynamic /* RenderViewRef | RenderFragmentRef */ >();
    this._lookupByView =
        new Map<dynamic /* RenderViewRef | RenderFragmentRef */, num>();
  }
  RenderViewWithFragments allocate(num fragmentCount) {
    var initialIndex = this._nextIndex;
    var viewRef = new WorkerRenderViewRef(this._nextIndex++);
    var fragmentRefs = ListWrapper.createGrowableSize(fragmentCount);
    for (var i = 0; i < fragmentCount; i++) {
      fragmentRefs[i] = new WorkerRenderFragmentRef(this._nextIndex++);
    }
    var renderViewWithFragments =
        new RenderViewWithFragments(viewRef, fragmentRefs);
    this.store(renderViewWithFragments, initialIndex);
    return renderViewWithFragments;
  }
  store(RenderViewWithFragments view, num startIndex) {
    this._lookupByIndex[startIndex] = view.viewRef;
    this._lookupByView[view.viewRef] = startIndex;
    startIndex++;
    ListWrapper.forEach(view.fragmentRefs, (ref) {
      this._lookupByIndex[startIndex] = ref;
      this._lookupByView[ref] = startIndex;
      startIndex++;
    });
  }
  dynamic /* RenderViewRef | RenderFragmentRef */ retreive(num ref) {
    if (ref == null) {
      return null;
    }
    return this._lookupByIndex[ref];
  }
  num serializeRenderViewRef(RenderViewRef viewRef) {
    return this._serializeRenderFragmentOrViewRef(viewRef);
  }
  num serializeRenderFragmentRef(RenderFragmentRef fragmentRef) {
    return this._serializeRenderFragmentOrViewRef(fragmentRef);
  }
  RenderViewRef deserializeRenderViewRef(num ref) {
    if (ref == null) {
      return null;
    }
    return this.retreive(ref);
  }
  RenderFragmentRef deserializeRenderFragmentRef(num ref) {
    if (ref == null) {
      return null;
    }
    return this.retreive(ref);
  }
  num _serializeRenderFragmentOrViewRef(
      dynamic /* RenderViewRef | RenderFragmentRef */ ref) {
    if (ref == null) {
      return null;
    }
    if (this._onWebWorker) {
      return ((ref as dynamic /* WorkerRenderFragmentRef | WorkerRenderViewRef */))
          .serialize();
    } else {
      return this._lookupByView[ref];
    }
  }
  Map<String, dynamic> serializeViewWithFragments(
      RenderViewWithFragments view) {
    if (view == null) {
      return null;
    }
    if (this._onWebWorker) {
      return {
        "viewRef": ((view.viewRef as WorkerRenderViewRef)).serialize(),
        "fragmentRefs":
            ListWrapper.map(view.fragmentRefs, (val) => val.serialize())
      };
    } else {
      return {
        "viewRef": this._lookupByView[view.viewRef],
        "fragmentRefs":
            ListWrapper.map(view.fragmentRefs, (val) => this._lookupByView[val])
      };
    }
  }
  RenderViewWithFragments deserializeViewWithFragments(
      Map<String, dynamic> obj) {
    if (obj == null) {
      return null;
    }
    var viewRef = this.deserializeRenderViewRef(obj["viewRef"]);
    var fragments = ListWrapper.map(
        obj["fragmentRefs"], (val) => this.deserializeRenderFragmentRef(val));
    return new RenderViewWithFragments(viewRef, fragments);
  }
}
class WorkerRenderViewRef extends RenderViewRef {
  num refNumber;
  WorkerRenderViewRef(this.refNumber) : super() {
    /* super call moved to initializer */;
  }
  num serialize() {
    return this.refNumber;
  }
  static WorkerRenderViewRef deserialize(num ref) {
    return new WorkerRenderViewRef(ref);
  }
}
class WorkerRenderFragmentRef extends RenderFragmentRef {
  num refNumber;
  WorkerRenderFragmentRef(this.refNumber) : super() {
    /* super call moved to initializer */;
  }
  num serialize() {
    return this.refNumber;
  }
  static WorkerRenderFragmentRef deserialize(num ref) {
    return new WorkerRenderFragmentRef(ref);
  }
}
