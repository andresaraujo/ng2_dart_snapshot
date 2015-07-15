library angular2.src.http.static_response;

import "enums.dart" show ResponseTypes;
import "package:angular2/src/facade/lang.dart"
    show BaseException, isString, isPresent, Json;
import "headers.dart" show Headers;
import "base_response_options.dart" show ResponseOptions;
import "http_utils.dart" show isJsObject;

/**
 * Creates `Response` instances from provided values.
 *
 * Though this object isn't
 * usually instantiated by end-users, it is the primary object interacted with when it comes time to
 * add data to a view.
 *
 * #Example
 *
 * ```
 * http.request('my-friends.txt').subscribe(response => this.friends = response.text());
 * ```
 *
 * The Response's interface is inspired by the Response constructor defined in the [Fetch
 * Spec](https://fetch.spec.whatwg.org/#response-class), but is considered a static value whose body
 * can be accessed many times. There are other differences in the implementation, but this is the
 * most significant.
 */
class Response {
  /**
   * One of "basic", "cors", "default", "error, or "opaque".
   *
   * Defaults to "default".
   */
  ResponseTypes type;
  /**
   * True if the response's status is within 200-299
   */
  bool ok;
  /**
   * URL of response.
   *
   * Defaults to empty string.
   */
  String url;
  /**
   * Status code returned by server.
   *
   * Defaults to 200.
   */
  num status;
  /**
   * Text representing the corresponding reason phrase to the `status`, as defined in [ietf rfc 2616
   * section 6.1.1](https://tools.ietf.org/html/rfc2616#section-6.1.1)
   *
   * Defaults to "OK"
   */
  String statusText;
  /**
   * Non-standard property
   *
   * Denotes how many of the response body's bytes have been loaded, for example if the response is
   * the result of a progress event.
   */
  num bytesLoaded;
  /**
   * Non-standard property
   *
   * Denotes how many bytes are expected in the final response body.
   */
  num totalBytes;
  /**
   * Headers object based on the `Headers` class in the [Fetch
   * Spec](https://fetch.spec.whatwg.org/#headers-class).
   */
  Headers headers;
  // TODO: Support ArrayBuffer, JSON, FormData, Blob
  dynamic /* String | Object */ _body;
  Response(ResponseOptions responseOptions) {
    this._body = responseOptions.body;
    this.status = responseOptions.status;
    this.statusText = responseOptions.statusText;
    this.headers = responseOptions.headers;
    this.type = responseOptions.type;
    this.url = responseOptions.url;
  }
  /**
   * Not yet implemented
   */

  // TODO: Blob return type
  dynamic blob() {
    throw new BaseException(
        "\"blob()\" method not implemented on Response superclass");
  }
  /**
   * Attempts to return body as parsed `JSON` object, or raises an exception.
   */
  Object json() {
    var jsonResponse;
    if (isJsObject(this._body)) {
      jsonResponse = this._body;
    } else if (isString(this._body)) {
      jsonResponse = Json.parse((this._body as String));
    }
    return jsonResponse;
  }
  /**
   * Returns the body as a string, presuming `toString()` can be called on the response body.
   */
  String text() {
    return this._body.toString();
  }
  /**
   * Not yet implemented
   */

  // TODO: ArrayBuffer return type
  dynamic arrayBuffer() {
    throw new BaseException(
        "\"arrayBuffer()\" method not implemented on Response superclass");
  }
}
