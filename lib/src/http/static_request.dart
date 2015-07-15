library angular2.src.http.static_request;

import "enums.dart"
    show
        RequestMethods,
        RequestModesOpts,
        RequestCredentialsOpts,
        RequestCacheOpts;
import "base_request_options.dart" show RequestOptions;
import "headers.dart" show Headers;
import "package:angular2/src/facade/lang.dart"
    show BaseException, RegExpWrapper, isPresent, isJsObject;
// TODO(jeffbcross): properly implement body accessors

/**
 * Creates `Request` instances from provided values.
 *
 * The Request's interface is inspired by the Request constructor defined in the [Fetch
 * Spec](https://fetch.spec.whatwg.org/#request-class),
 * but is considered a static value whose body can be accessed many times. There are other
 * differences in the implementation, but this is the most significant.
 */
class Request {
  /**
   * Http method with which to perform the request.
   *
   * Defaults to GET.
   */
  RequestMethods method;
  RequestModesOpts mode;
  RequestCredentialsOpts credentials;
  /**
   * Headers object based on the `Headers` class in the [Fetch
   * Spec](https://fetch.spec.whatwg.org/#headers-class). {@link Headers} class reference.
   */
  Headers headers;
  /** Url of the remote resource */
  String url;
  // TODO: support URLSearchParams | FormData | Blob | ArrayBuffer
  String _body;
  RequestCacheOpts cache;
  Request(RequestOptions requestOptions) {
    // TODO: assert that url is present
    this.url = requestOptions.url;
    this._body = requestOptions.body;
    this.method = requestOptions.method;
    // TODO(jeffbcross): implement behavior
    this.mode = requestOptions.mode;
    // Defaults to 'omit', consistent with browser

    // TODO(jeffbcross): implement behavior
    this.credentials = requestOptions.credentials;
    this.headers = new Headers(requestOptions.headers);
    this.cache = requestOptions.cache;
  }
  /**
   * Returns the request's body as string, assuming that body exists. If body is undefined, return
   * empty
   * string.
   */
  String text() {
    return isPresent(this._body) ? this._body.toString() : "";
  }
}
