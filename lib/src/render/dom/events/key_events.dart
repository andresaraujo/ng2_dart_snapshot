library angular2.src.render.dom.events.key_events;

import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/facade/lang.dart"
    show
        isPresent,
        isBlank,
        StringWrapper,
        RegExpWrapper,
        BaseException,
        NumberWrapper;
import "package:angular2/src/facade/collection.dart"
    show StringMapWrapper, ListWrapper;
import "event_manager.dart" show EventManagerPlugin;
import "package:angular2/src/core/zone/ng_zone.dart" show NgZone;

var modifierKeys = ["alt", "control", "meta", "shift"];
Map<String, Function> modifierKeyGetters = {
  "alt": (event) => event.altKey,
  "control": (event) => event.ctrlKey,
  "meta": (event) => event.metaKey,
  "shift": (event) => event.shiftKey
};
class KeyEventsPlugin extends EventManagerPlugin {
  KeyEventsPlugin() : super() {
    /* super call moved to initializer */;
  }
  bool supports(String eventName) {
    return isPresent(KeyEventsPlugin.parseEventName(eventName));
  }
  addEventListener(dynamic element, String eventName,
      dynamic /* (Event: any) => any */ handler, bool shouldSupportBubble) {
    var parsedEvent = KeyEventsPlugin.parseEventName(eventName);
    var outsideHandler = KeyEventsPlugin.eventCallback(element,
        shouldSupportBubble, StringMapWrapper.get(parsedEvent, "fullKey"),
        handler, this.manager.getZone());
    this.manager.getZone().runOutsideAngular(() {
      DOM.on(element, StringMapWrapper.get(parsedEvent, "domEventName"),
          outsideHandler);
    });
  }
  static Map<String, String> parseEventName(String eventName) {
    var parts = eventName.toLowerCase().split(".");
    var domEventName = ListWrapper.removeAt(parts, 0);
    if ((identical(parts.length, 0)) ||
        !(StringWrapper.equals(domEventName, "keydown") ||
            StringWrapper.equals(domEventName, "keyup"))) {
      return null;
    }
    var key = KeyEventsPlugin._normalizeKey(ListWrapper.removeLast(parts));
    var fullKey = "";
    ListWrapper.forEach(modifierKeys, (modifierName) {
      if (ListWrapper.contains(parts, modifierName)) {
        ListWrapper.remove(parts, modifierName);
        fullKey += modifierName + ".";
      }
    });
    fullKey += key;
    if (parts.length != 0 || identical(key.length, 0)) {
      // returning null instead of throwing to let another plugin process the event
      return null;
    }
    var result = StringMapWrapper.create();
    StringMapWrapper.set(result, "domEventName", domEventName);
    StringMapWrapper.set(result, "fullKey", fullKey);
    return result;
  }
  static String getEventFullKey(dynamic event) {
    var fullKey = "";
    var key = DOM.getEventKey(event);
    key = key.toLowerCase();
    if (StringWrapper.equals(key, " ")) {
      key = "space";
    } else if (StringWrapper.equals(key, ".")) {
      key = "dot";
    }
    ListWrapper.forEach(modifierKeys, (modifierName) {
      if (modifierName != key) {
        var modifierGetter =
            StringMapWrapper.get(modifierKeyGetters, modifierName);
        if (modifierGetter(event)) {
          fullKey += modifierName + ".";
        }
      }
    });
    fullKey += key;
    return fullKey;
  }
  static dynamic /* (event: Event) => void */ eventCallback(dynamic element,
      bool shouldSupportBubble, dynamic fullKey,
      dynamic /* (Event) => any */ handler, NgZone zone) {
    return (event) {
      var correctElement =
          shouldSupportBubble || identical(event.target, element);
      if (correctElement &&
          StringWrapper.equals(
              KeyEventsPlugin.getEventFullKey(event), fullKey)) {
        zone.run(() => handler(event));
      }
    };
  }
  static String _normalizeKey(String keyName) {
    // TODO: switch to a StringMap if the mapping grows too much
    switch (keyName) {
      case "esc":
        return "escape";
      default:
        return keyName;
    }
  }
}
