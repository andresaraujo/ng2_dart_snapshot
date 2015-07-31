library angular2.src.core.testability.testability;

import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/facade/collection.dart"
    show Map, MapWrapper, List, ListWrapper;
import "package:angular2/src/facade/lang.dart"
    show StringWrapper, isBlank, BaseException;
import "get_testability.dart" as getTestabilityModule;
import "../zone/ng_zone.dart" show NgZone;
import "package:angular2/src/facade/async.dart" show PromiseWrapper;

/**
 * The Testability service provides testing hooks that can be accessed from
 * the browser and by services such as Protractor. Each bootstrapped Angular
 * application on the page will have an instance of Testability.
 */
@Injectable()
class Testability {
  NgZone _ngZone;
  num _pendingCount = 0;
  List<Function> _callbacks = [];
  bool _isAngularEventPending = false;
  Testability(this._ngZone) {
    this._watchAngularEvents(_ngZone);
  }
  void _watchAngularEvents(NgZone _ngZone) {
    _ngZone.overrideOnTurnStart(() {
      this._isAngularEventPending = true;
    });
    _ngZone.overrideOnEventDone(() {
      this._isAngularEventPending = false;
      this._runCallbacksIfReady();
    }, true);
  }
  num increasePendingRequestCount() {
    this._pendingCount += 1;
    return this._pendingCount;
  }
  num decreasePendingRequestCount() {
    this._pendingCount -= 1;
    if (this._pendingCount < 0) {
      throw new BaseException("pending async requests below zero");
    }
    this._runCallbacksIfReady();
    return this._pendingCount;
  }
  void _runCallbacksIfReady() {
    if (this._pendingCount != 0 || this._isAngularEventPending) {
      return;
    }
    // Schedules the call backs in a new frame so that it is always async.
    PromiseWrapper.resolve(null).then((_) {
      while (!identical(this._callbacks.length, 0)) {
        (this._callbacks.removeLast())();
      }
    });
  }
  void whenStable(Function callback) {
    this._callbacks.add(callback);
    this._runCallbacksIfReady();
  }
  num getPendingRequestCount() {
    return this._pendingCount;
  }
  // This only accounts for ngZone, and not pending counts. Use `whenStable` to

  // check for stability.
  bool isAngularEventPending() {
    return this._isAngularEventPending;
  }
  List<dynamic> findBindings(dynamic using, String binding, bool exactMatch) {
    // TODO(juliemr): implement.
    return [];
  }
}
@Injectable()
class TestabilityRegistry {
  Map<dynamic, Testability> _applications = new Map();
  TestabilityRegistry() {
    getTestabilityModule.GetTestability.addToWindow(this);
  }
  registerApplication(dynamic token, Testability testability) {
    this._applications[token] = testability;
  }
  List<Testability> getAllTestabilities() {
    return MapWrapper.values(this._applications);
  }
  Testability findTestabilityInTree(dynamic elem) {
    if (elem == null) {
      return null;
    }
    if (this._applications.containsKey(elem)) {
      return this._applications[elem];
    }
    if (DOM.isShadowRoot(elem)) {
      return this.findTestabilityInTree(DOM.getHost(elem));
    }
    return this.findTestabilityInTree(DOM.parentElement(elem));
  }
}
