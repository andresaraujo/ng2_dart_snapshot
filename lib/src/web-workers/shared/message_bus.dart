// TODO(jteplitz602) to be idiomatic these should be releated to Observable's or Streams

/**
 * Message Bus is a low level API used to communicate between the UI and the worker.
 * It smooths out the differences between Javascript's postMessage and Dart's Isolate
 * allowing you to work with one consistent API.
 */
library angular2.src.web_workers.shared.message_bus;

abstract class MessageBus {
  MessageBusSink sink;
  MessageBusSource source;
}
typedef void SourceListener(dynamic data);
abstract class MessageBusSource {
  /**
   * Attaches the SourceListener to this source.
   * The SourceListener will get called whenever the bus receives a message
   * Returns a listener id that can be passed to {@link removeListener}
   */
  num addListener(SourceListener fn);
  removeListener(num index);
}
abstract class MessageBusSink {
  void send(Object message);
}
