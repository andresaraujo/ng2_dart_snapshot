/// <reference path="../../../globals.d.ts" />
library angular2.src.web_workers.worker.broker;

import "package:angular2/src/web-workers/shared/message_bus.dart"
    show MessageBus;
import "../../facade/lang.dart" show print, isPresent, DateWrapper, stringify;
import "package:angular2/src/facade/async.dart"
    show Future, PromiseCompleter, PromiseWrapper;
import "../../facade/collection.dart"
    show ListWrapper, StringMapWrapper, MapWrapper;
import "package:angular2/src/web-workers/shared/serializer.dart"
    show Serializer;
import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/facade/lang.dart" show Type;
import "package:angular2/src/render/api.dart"
    show RenderViewRef, RenderEventDispatcher;
import "package:angular2/src/core/zone/ng_zone.dart" show NgZone;
import "event_deserializer.dart" show deserializeGenericEvent;

@Injectable()
class MessageBroker {
  MessageBus _messageBus;
  Serializer _serializer;
  NgZone _zone;
  Map<String, PromiseCompleter<dynamic>> _pending =
      new Map<String, PromiseCompleter<dynamic>>();
  Map<RenderViewRef, RenderEventDispatcher> _eventDispatchRegistry =
      new Map<RenderViewRef, RenderEventDispatcher>();
  MessageBroker(this._messageBus, this._serializer, this._zone) {
    this._messageBus.source
        .addListener((data) => this._handleMessage(data["data"]));
  }
  String _generateMessageId(String name) {
    String time = stringify(DateWrapper.toMillis(DateWrapper.now()));
    num iteration = 0;
    String id = name + time + stringify(iteration);
    while (isPresent(this._pending[id])) {
      id = '''${ name}${ time}${ iteration}''';
      iteration++;
    }
    return id;
  }
  Future<dynamic> runOnUiThread(UiArguments args, Type returnType) {
    var fnArgs = [];
    if (isPresent(args.args)) {
      ListWrapper.forEach(args.args, (argument) {
        if (argument.type != null) {
          fnArgs.add(this._serializer.serialize(argument.value, argument.type));
        } else {
          fnArgs.add(argument.value);
        }
      });
    }
    Future<dynamic> promise;
    String id = null;
    if (returnType != null) {
      PromiseCompleter<dynamic> completer = PromiseWrapper.completer();
      id = this._generateMessageId(args.type + args.method);
      this._pending[id] = completer;
      PromiseWrapper.catchError(completer.promise, (err, [stack]) {
        print(err);
        completer.reject(err, stack);
      });
      promise = PromiseWrapper.then(completer.promise, (dynamic value) {
        if (this._serializer == null) {
          return value;
        } else {
          return this._serializer.deserialize(value, returnType);
        }
      });
    } else {
      promise = null;
    }
    // TODO(jteplitz602): Create a class for these messages so we don't keep using StringMap
    var message = {"type": args.type, "method": args.method, "args": fnArgs};
    if (id != null) {
      message["id"] = id;
    }
    this._messageBus.sink.send(message);
    return promise;
  }
  void _handleMessage(Map<String, dynamic> message) {
    var data = new MessageData(message);
    // TODO(jteplitz602): replace these strings with messaging constants
    if (identical(data.type, "event")) {
      this._dispatchEvent(new RenderEventData(data.value, this._serializer));
    } else if (identical(data.type, "result") ||
        identical(data.type, "error")) {
      var id = data.id;
      if (this._pending.containsKey(id)) {
        if (identical(data.type, "result")) {
          this._pending[id].resolve(data.value);
        } else {
          this._pending[id].reject(data.value, null);
        }
        (this._pending.containsKey(id) &&
            (this._pending.remove(id) != null || true));
      }
    }
  }
  void _dispatchEvent(RenderEventData eventData) {
    var dispatcher = this._eventDispatchRegistry[eventData.viewRef];
    this._zone.run(() {
      eventData.locals["\$event"] =
          deserializeGenericEvent(eventData.locals["\$event"]);
      dispatcher.dispatchRenderEvent(
          eventData.elementIndex, eventData.eventName, eventData.locals);
    });
  }
  void registerEventDispatcher(
      RenderViewRef viewRef, RenderEventDispatcher dispatcher) {
    this._eventDispatchRegistry[viewRef] = dispatcher;
  }
}
class RenderEventData {
  RenderViewRef viewRef;
  num elementIndex;
  String eventName;
  Map<String, dynamic> locals;
  RenderEventData(Map<String, dynamic> message, Serializer serializer) {
    this.viewRef = serializer.deserialize(message["viewRef"], RenderViewRef);
    this.elementIndex = message["elementIndex"];
    this.eventName = message["eventName"];
    this.locals = MapWrapper.createFromStringMap(message["locals"]);
  }
}
class MessageData {
  String type;
  dynamic value;
  String id;
  MessageData(Map<String, dynamic> data) {
    this.type = StringMapWrapper.get(data, "type");
    this.id = this._getValueIfPresent(data, "id");
    this.value = this._getValueIfPresent(data, "value");
  }
  /**
   * Returns the value from the StringMap if present. Otherwise returns null
   */
  _getValueIfPresent(Map<String, dynamic> data, String key) {
    if (StringMapWrapper.contains(data, key)) {
      return StringMapWrapper.get(data, key);
    } else {
      return null;
    }
  }
}
class FnArg {
  var value;
  var type;
  FnArg(this.value, this.type) {}
}
class UiArguments {
  String type;
  String method;
  List<FnArg> args;
  UiArguments(this.type, this.method, [this.args]) {}
}
