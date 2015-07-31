library angular2.test.web_workers.worker.broker_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        inject,
        describe,
        it,
        expect,
        beforeEach,
        createTestInjector,
        beforeEachBindings,
        SpyObject,
        proxy;
import "package:angular2/src/web-workers/shared/serializer.dart"
    show Serializer;
import "package:angular2/src/core/zone/ng_zone.dart" show NgZone;
import "package:angular2/src/web-workers/worker/broker.dart" show MessageBroker;
import "worker_test_util.dart"
    show MockMessageBus, MockMessageBusSink, MockMessageBusSource;
import "package:angular2/src/web-workers/shared/api.dart" show ON_WEBWORKER;
import "package:angular2/di.dart" show bind;
import "package:angular2/src/web-workers/shared/render_proto_view_ref_store.dart"
    show RenderProtoViewRefStore;
import "package:angular2/src/web-workers/shared/render_view_with_fragments_store.dart"
    show RenderViewWithFragmentsStore, WorkerRenderViewRef;
import "package:angular2/src/render/api.dart"
    show RenderEventDispatcher, RenderViewRef;

main() {
  describe("MessageBroker", () {
    beforeEachBindings(() => [
      bind(ON_WEBWORKER).toValue(true),
      RenderProtoViewRefStore,
      RenderViewWithFragmentsStore
    ]);
    it("should dispatch events", inject([
      Serializer,
      NgZone
    ], (serializer, zone) {
      var bus = new MockMessageBus(
          new MockMessageBusSink(), new MockMessageBusSource());
      var broker = new MessageBroker(bus, serializer, zone);
      var eventDispatcher = new SpyEventDispatcher();
      var viewRef = new WorkerRenderViewRef(0);
      serializer.allocateRenderViews(0);
      viewRef = serializer.deserialize(
          serializer.serialize(viewRef, RenderViewRef), RenderViewRef);
      broker.registerEventDispatcher(viewRef, eventDispatcher);
      var elementIndex = 15;
      var eventName = "click";
      bus.source.receive({
        "data": {
          "type": "event",
          "value": {
            "viewRef": viewRef.serialize(),
            "elementIndex": elementIndex,
            "eventName": eventName,
            "locals": {"\$event": {"target": {"value": null}}}
          }
        }
      });
      expect(eventDispatcher.wasDispatched).toBeTruthy();
      expect(eventDispatcher.elementIndex).toEqual(elementIndex);
      expect(eventDispatcher.eventName).toEqual(eventName);
    }));
  });
}
class SpyEventDispatcher implements RenderEventDispatcher {
  bool wasDispatched = false;
  num elementIndex;
  String eventName;
  dispatchRenderEvent(
      num elementIndex, String eventName, Map<String, dynamic> locals) {
    this.wasDispatched = true;
    this.elementIndex = elementIndex;
    this.eventName = eventName;
  }
}
