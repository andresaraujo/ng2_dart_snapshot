/*
 * This file is the entry point for the main thread
 * It takes care of spawning the worker and sending it the initial init message
 * It also acts and the messenger between the worker thread and the renderer running on the UI
 * thread
*/
library angular2.src.web_workers.ui.impl;

import "di_bindings.dart" show createInjector;
import "package:angular2/src/render/api.dart"
    show
        Renderer,
        RenderCompiler,
        DirectiveMetadata,
        ProtoViewDto,
        ViewDefinition,
        RenderProtoViewRef,
        RenderProtoViewMergeMapping,
        RenderViewRef,
        RenderEventDispatcher,
        RenderFragmentRef;
import "package:angular2/src/facade/lang.dart"
    show Type, print, BaseException, isFunction;
import "package:angular2/src/facade/async.dart" show Future, PromiseWrapper;
import "package:angular2/src/facade/collection.dart"
    show StringMapWrapper, SetWrapper;
import "package:angular2/src/web-workers/shared/serializer.dart"
    show Serializer;
import "package:angular2/src/web-workers/shared/message_bus.dart"
    show MessageBus, MessageBusSink;
import "package:angular2/src/web-workers/shared/render_view_with_fragments_store.dart"
    show RenderViewWithFragmentsStore;
import "package:angular2/src/core/application_common.dart" show createNgZone;
import "package:angular2/src/web-workers/shared/api.dart" show WorkerElementRef;
import "package:angular2/src/services/anchor_based_app_root_url.dart"
    show AnchorBasedAppRootUrl;
import "package:angular2/src/core/exception_handler.dart" show ExceptionHandler;
import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/dom/browser_adapter.dart" show BrowserDomAdapter;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/web-workers/ui/event_serializer.dart"
    show
        serializeMouseEvent,
        serializeKeyboardEvent,
        serializeGenericEvent,
        serializeEventWithValue;

/**
 * Creates a zone, sets up the DI bindings
 * And then creates a new WebWorkerMain object to handle messages from the worker
 */
bootstrapUICommon(MessageBus bus) {
  BrowserDomAdapter.makeCurrent();
  var zone = createNgZone(new ExceptionHandler(DOM));
  zone.run(() {
    var injector = createInjector(zone);
    var webWorkerMain = injector.get(WebWorkerMain);
    webWorkerMain.attachToWorker(bus);
  });
}
@Injectable()
class WebWorkerMain {
  RenderCompiler _renderCompiler;
  Renderer _renderer;
  RenderViewWithFragmentsStore _renderViewWithFragmentsStore;
  Serializer _serializer;
  String _rootUrl;
  MessageBus _bus;
  WebWorkerMain(this._renderCompiler, this._renderer,
      this._renderViewWithFragmentsStore, this._serializer,
      AnchorBasedAppRootUrl rootUrl) {
    this._rootUrl = rootUrl.value;
  }
  /**
   * Attach's this WebWorkerMain instance to the given MessageBus
   * This instance will now listen for all messages from the worker and handle them appropriately
   * Note: Don't attach more than one WebWorkerMain instance to the same MessageBus.
   */
  attachToWorker(MessageBus bus) {
    this._bus = bus;
    this._bus.source.addListener((message) {
      this._handleWorkerMessage(message);
    });
  }
  _sendInitMessage() {
    this._sendWorkerMessage("init", {"rootUrl": this._rootUrl});
  }
  /*
   * Sends an error back to the worker thread in response to an opeartion on the UI thread
   */
  _sendWorkerError(String id, dynamic error) {
    this._sendWorkerMessage("error", {"error": error}, id);
  }
  _sendWorkerMessage(String type, Map<String, dynamic> value, [String id]) {
    this._bus.sink.send({"type": type, "id": id, "value": value});
  }
  // TODO: Transfer the types with the serialized data so this can be automated?
  _handleCompilerMessage(ReceivedMessage data) {
    Future<dynamic> promise;
    switch (data.method) {
      case "compileHost":
        var directiveMetadata =
            this._serializer.deserialize(data.args[0], DirectiveMetadata);
        promise = this._renderCompiler.compileHost(directiveMetadata);
        this._wrapWorkerPromise(data.id, promise, ProtoViewDto);
        break;
      case "compile":
        var view = this._serializer.deserialize(data.args[0], ViewDefinition);
        promise = this._renderCompiler.compile(view);
        this._wrapWorkerPromise(data.id, promise, ProtoViewDto);
        break;
      case "mergeProtoViewsRecursively":
        var views =
            this._serializer.deserialize(data.args[0], RenderProtoViewRef);
        promise = this._renderCompiler.mergeProtoViewsRecursively(views);
        this._wrapWorkerPromise(data.id, promise, RenderProtoViewMergeMapping);
        break;
      default:
        throw new BaseException("not implemented");
    }
  }
  _createViewHelper(List<dynamic> args, method) {
    var hostProtoView =
        this._serializer.deserialize(args[0], RenderProtoViewRef);
    var fragmentCount = args[1];
    var startIndex, renderViewWithFragments;
    if (method == "createView") {
      startIndex = args[2];
      renderViewWithFragments =
          this._renderer.createView(hostProtoView, fragmentCount);
    } else {
      var selector = args[2];
      startIndex = args[3];
      renderViewWithFragments = this._renderer.createRootHostView(
          hostProtoView, fragmentCount, selector);
    }
    this._renderViewWithFragmentsStore.store(
        renderViewWithFragments, startIndex);
  }
  _handleRendererMessage(ReceivedMessage data) {
    var args = data.args;
    switch (data.method) {
      case "createRootHostView":
      case "createView":
        this._createViewHelper(args, data.method);
        break;
      case "destroyView":
        var viewRef = this._serializer.deserialize(args[0], RenderViewRef);
        this._renderer.destroyView(viewRef);
        break;
      case "attachFragmentAfterFragment":
        var previousFragment =
            this._serializer.deserialize(args[0], RenderFragmentRef);
        var fragment = this._serializer.deserialize(args[1], RenderFragmentRef);
        this._renderer.attachFragmentAfterFragment(previousFragment, fragment);
        break;
      case "attachFragmentAfterElement":
        var element = this._serializer.deserialize(args[0], WorkerElementRef);
        var fragment = this._serializer.deserialize(args[1], RenderFragmentRef);
        this._renderer.attachFragmentAfterElement(element, fragment);
        break;
      case "detachFragment":
        var fragment = this._serializer.deserialize(args[0], RenderFragmentRef);
        this._renderer.detachFragment(fragment);
        break;
      case "hydrateView":
        var viewRef = this._serializer.deserialize(args[0], RenderViewRef);
        this._renderer.hydrateView(viewRef);
        break;
      case "dehydrateView":
        var viewRef = this._serializer.deserialize(args[0], RenderViewRef);
        this._renderer.dehydrateView(viewRef);
        break;
      case "setText":
        var viewRef = this._serializer.deserialize(args[0], RenderViewRef);
        var textNodeIndex = args[1];
        var text = args[2];
        this._renderer.setText(viewRef, textNodeIndex, text);
        break;
      case "setElementProperty":
        var elementRef =
            this._serializer.deserialize(args[0], WorkerElementRef);
        var propName = args[1];
        var propValue = args[2];
        this._renderer.setElementProperty(elementRef, propName, propValue);
        break;
      case "setElementAttribute":
        var elementRef =
            this._serializer.deserialize(args[0], WorkerElementRef);
        var attributeName = args[1];
        var attributeValue = args[2];
        this._renderer.setElementAttribute(
            elementRef, attributeName, attributeValue);
        break;
      case "setElementClass":
        var elementRef =
            this._serializer.deserialize(args[0], WorkerElementRef);
        var className = args[1];
        var isAdd = args[2];
        this._renderer.setElementClass(elementRef, className, isAdd);
        break;
      case "setElementStyle":
        var elementRef =
            this._serializer.deserialize(args[0], WorkerElementRef);
        var styleName = args[1];
        var styleValue = args[2];
        this._renderer.setElementStyle(elementRef, styleName, styleValue);
        break;
      case "invokeElementMethod":
        var elementRef =
            this._serializer.deserialize(args[0], WorkerElementRef);
        var methodName = args[1];
        var methodArgs = args[2];
        this._renderer.invokeElementMethod(elementRef, methodName, methodArgs);
        break;
      case "setEventDispatcher":
        var viewRef = this._serializer.deserialize(args[0], RenderViewRef);
        var dispatcher =
            new EventDispatcher(viewRef, this._bus.sink, this._serializer);
        this._renderer.setEventDispatcher(viewRef, dispatcher);
        break;
      default:
        throw new BaseException("Not Implemented");
    }
  }
  // TODO(jteplitz602): Create message type enum #3044
  _handleWorkerMessage(Map<String, dynamic> message) {
    ReceivedMessage data = new ReceivedMessage(message["data"]);
    switch (data.type) {
      case "ready":
        return this._sendInitMessage();
      case "compiler":
        return this._handleCompilerMessage(data);
      case "renderer":
        return this._handleRendererMessage(data);
    }
  }
  void _wrapWorkerPromise(String id, Future<dynamic> promise, Type type) {
    PromiseWrapper.then(promise, (dynamic result) {
      try {
        this._sendWorkerMessage(
            "result", this._serializer.serialize(result, type), id);
      } catch (e, e_stack) {
        print(e);
      }
    }, (dynamic error) {
      this._sendWorkerError(id, error);
    });
  }
}
class EventDispatcher implements RenderEventDispatcher {
  RenderViewRef _viewRef;
  MessageBusSink _sink;
  Serializer _serializer;
  EventDispatcher(this._viewRef, this._sink, this._serializer) {}
  dispatchRenderEvent(
      num elementIndex, String eventName, Map<String, dynamic> locals) {
    var e = locals["\$event"];
    var serializedEvent;
    // TODO (jteplitz602): support custom events #3350
    switch (e.type) {
      case "click":
      case "mouseup":
      case "mousedown":
      case "dblclick":
      case "contextmenu":
      case "mouseenter":
      case "mouseleave":
      case "mousemove":
      case "mouseout":
      case "mouseover":
      case "show":
        serializedEvent = serializeMouseEvent(e);
        break;
      case "keydown":
      case "keypress":
      case "keyup":
        serializedEvent = serializeKeyboardEvent(e);
        break;
      case "input":
      case "change":
      case "blur":
        serializedEvent = serializeEventWithValue(e);
        break;
      case "abort":
      case "afterprint":
      case "beforeprint":
      case "cached":
      case "canplay":
      case "canplaythrough":
      case "chargingchange":
      case "chargingtimechange":
      case "close":
      case "dischargingtimechange":
      case "DOMContentLoaded":
      case "downloading":
      case "durationchange":
      case "emptied":
      case "ended":
      case "error":
      case "fullscreenchange":
      case "fullscreenerror":
      case "invalid":
      case "languagechange":
      case "levelfchange":
      case "loadeddata":
      case "loadedmetadata":
      case "obsolete":
      case "offline":
      case "online":
      case "open":
      case "orientatoinchange":
      case "pause":
      case "pointerlockchange":
      case "pointerlockerror":
      case "play":
      case "playing":
      case "ratechange":
      case "readystatechange":
      case "reset":
      case "seeked":
      case "seeking":
      case "stalled":
      case "submit":
      case "success":
      case "suspend":
      case "timeupdate":
      case "updateready":
      case "visibilitychange":
      case "volumechange":
      case "waiting":
        serializedEvent = serializeGenericEvent(e);
        break;
      default:
        throw new BaseException(eventName + " not supported on WebWorkers");
    }
    var serializedLocals = StringMapWrapper.create();
    StringMapWrapper.set(serializedLocals, "\$event", serializedEvent);
    this._sink.send({
      "type": "event",
      "value": {
        "viewRef": this._serializer.serialize(this._viewRef, RenderViewRef),
        "elementIndex": elementIndex,
        "eventName": eventName,
        "locals": serializedLocals
      }
    });
  }
}
class ReceivedMessage {
  String method;
  List<dynamic> args;
  String id;
  String type;
  ReceivedMessage(Map<String, dynamic> data) {
    this.method = data["method"];
    this.args = data["args"];
    this.id = data["id"];
    this.type = data["type"];
  }
}
