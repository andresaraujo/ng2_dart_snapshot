library angular2.test.web_workers.worker.worker_test_util;

import "package:angular2/src/web-workers/shared/message_bus.dart"
    show MessageBus, MessageBusSource, MessageBusSink, SourceListener;
import "package:angular2/src/facade/collection.dart" show MapWrapper;

class MockMessageBusSource implements MessageBusSource {
  Map<int, SourceListener> _listenerStore = new Map<int, SourceListener>();
  num _numListeners = 0;
  int addListener(SourceListener fn) {
    this._listenerStore[++this._numListeners] = fn;
    return this._numListeners;
  }
  void removeListener(int index) {
    MapWrapper.delete(this._listenerStore, index);
  }
  void receive(Object message) {
    MapWrapper.forEach(this._listenerStore, (SourceListener fn, int key) {
      fn(message);
    });
  }
}
class MockMessageBusSink implements MessageBusSink {
  MockMessageBusSource _sendTo;
  void send(Object message) {
    this._sendTo.receive({"data": message});
  }
  attachToSource(MockMessageBusSource source) {
    this._sendTo = source;
  }
}
class MockMessageBus implements MessageBus {
  MockMessageBusSink sink;
  MockMessageBusSource source;
  MockMessageBus(this.sink, this.source) {}
  attachToBus(MockMessageBus bus) {
    this.sink.attachToSource(bus.source);
  }
}
