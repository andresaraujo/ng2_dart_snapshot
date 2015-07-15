library angular2.src.core.compiler.view_pool;

import "package:angular2/di.dart" show Inject, Injectable, OpaqueToken;
import "package:angular2/src/facade/collection.dart"
    show ListWrapper, MapWrapper, Map, List;
import "package:angular2/src/facade/lang.dart" show isPresent, isBlank;
import "view.dart" as viewModule;

const APP_VIEW_POOL_CAPACITY =
    const OpaqueToken("AppViewPool.viewPoolCapacity");
@Injectable()
class AppViewPool {
  num _poolCapacityPerProtoView;
  Map<viewModule.AppProtoView, List<viewModule.AppView>> _pooledViewsPerProtoView =
      new Map();
  AppViewPool(@Inject(APP_VIEW_POOL_CAPACITY) poolCapacityPerProtoView) {
    this._poolCapacityPerProtoView = poolCapacityPerProtoView;
  }
  viewModule.AppView getView(viewModule.AppProtoView protoView) {
    var pooledViews = this._pooledViewsPerProtoView[protoView];
    if (isPresent(pooledViews) && pooledViews.length > 0) {
      return ListWrapper.removeLast(pooledViews);
    }
    return null;
  }
  bool returnView(viewModule.AppView view) {
    var protoView = view.proto;
    var pooledViews = this._pooledViewsPerProtoView[protoView];
    if (isBlank(pooledViews)) {
      pooledViews = [];
      this._pooledViewsPerProtoView[protoView] = pooledViews;
    }
    var haveRemainingCapacity =
        pooledViews.length < this._poolCapacityPerProtoView;
    if (haveRemainingCapacity) {
      pooledViews.add(view);
    }
    return haveRemainingCapacity;
  }
}
