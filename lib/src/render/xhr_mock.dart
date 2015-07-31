library angular2.src.render.xhr_mock;

import "package:angular2/src/render/xhr.dart" show XHR;
import "package:angular2/src/facade/collection.dart"
    show List, ListWrapper, Map, MapWrapper;
import "package:angular2/src/facade/lang.dart"
    show isBlank, isPresent, normalizeBlank, BaseException;
import "package:angular2/src/facade/async.dart"
    show PromiseCompleter, PromiseWrapper, Future;

class MockXHR extends XHR {
  List<_Expectation> _expectations;
  Map<String, String> _definitions;
  List<_PendingRequest> _requests;
  MockXHR() : super() {
    /* super call moved to initializer */;
    this._expectations = [];
    this._definitions = new Map();
    this._requests = [];
  }
  Future<String> get(String url) {
    var request = new _PendingRequest(url);
    this._requests.add(request);
    return request.getPromise();
  }
  expect(String url, String response) {
    var expectation = new _Expectation(url, response);
    this._expectations.add(expectation);
  }
  when(String url, String response) {
    this._definitions[url] = response;
  }
  flush() {
    if (identical(this._requests.length, 0)) {
      throw new BaseException("No pending requests to flush");
    }
    do {
      var request = ListWrapper.removeAt(this._requests, 0);
      this._processRequest(request);
    } while (this._requests.length > 0);
    this.verifyNoOustandingExpectations();
  }
  verifyNoOustandingExpectations() {
    if (identical(this._expectations.length, 0)) return;
    var urls = [];
    for (var i = 0; i < this._expectations.length; i++) {
      var expectation = this._expectations[i];
      urls.add(expectation.url);
    }
    throw new BaseException(
        '''Unsatisfied requests: ${ ListWrapper . join ( urls , ", " )}''');
  }
  _processRequest(_PendingRequest request) {
    var url = request.url;
    if (this._expectations.length > 0) {
      var expectation = this._expectations[0];
      if (expectation.url == url) {
        ListWrapper.remove(this._expectations, expectation);
        request.complete(expectation.response);
        return;
      }
    }
    if (this._definitions.containsKey(url)) {
      var response = this._definitions[url];
      request.complete(normalizeBlank(response));
      return;
    }
    throw new BaseException('''Unexpected request ${ url}''');
  }
}
class _PendingRequest {
  String url;
  PromiseCompleter<String> completer;
  _PendingRequest(url) {
    this.url = url;
    this.completer = PromiseWrapper.completer();
  }
  complete(String response) {
    if (isBlank(response)) {
      this.completer.reject('''Failed to load ${ this . url}''', null);
    } else {
      this.completer.resolve(response);
    }
  }
  Future<String> getPromise() {
    return this.completer.promise;
  }
}
class _Expectation {
  String url;
  String response;
  _Expectation(String url, String response) {
    this.url = url;
    this.response = response;
  }
}
