library angular2.src.http.base_request_options;

import "package:angular2/src/facade/lang.dart" show isPresent;
import "headers.dart" show Headers;
import "enums.dart"
    show
        RequestModesOpts,
        RequestMethods,
        RequestCacheOpts,
        RequestCredentialsOpts;
import "interfaces.dart" show IRequestOptions;
import "package:angular2/di.dart" show Injectable;

/**
 * Creates a request options object similar to the `RequestInit` description
 * in the [Fetch
 * Spec](https://fetch.spec.whatwg.org/#requestinit) to be optionally provided when instantiating a
 * {@link Request}.
 *
 * All values are null by default.
 */
class RequestOptions implements IRequestOptions {
  /**
   * Http method with which to execute the request.
   *
   * Defaults to "GET".
   */
  RequestMethods method;
  /**
   * Headers object based on the `Headers` class in the [Fetch
   * Spec](https://fetch.spec.whatwg.org/#headers-class).
   */
  Headers headers;
  /**
   * Body to be used when creating the request.
   */

  // TODO: support FormData, Blob, URLSearchParams
  String body;
  RequestModesOpts mode;
  RequestCredentialsOpts credentials;
  RequestCacheOpts cache;
  String url;
  RequestOptions({method, headers, body, mode, credentials, cache, url}) {
    this.method = isPresent(method) ? method : null;
    this.headers = isPresent(headers) ? headers : null;
    this.body = isPresent(body) ? body : null;
    this.mode = isPresent(mode) ? mode : null;
    this.credentials = isPresent(credentials) ? credentials : null;
    this.cache = isPresent(cache) ? cache : null;
    this.url = isPresent(url) ? url : null;
  }
  /**
   * Creates a copy of the `RequestOptions` instance, using the optional input as values to override
   * existing values.
   */
  RequestOptions merge([IRequestOptions options]) {
    return new RequestOptions(
        method: isPresent(options) && isPresent(options.method)
            ? options.method
            : this.method,
        headers: isPresent(options) && isPresent(options.headers)
            ? options.headers
            : this.headers,
        body: isPresent(options) && isPresent(options.body)
            ? options.body
            : this.body,
        mode: isPresent(options) && isPresent(options.mode)
            ? options.mode
            : this.mode,
        credentials: isPresent(options) && isPresent(options.credentials)
            ? options.credentials
            : this.credentials,
        cache: isPresent(options) && isPresent(options.cache)
            ? options.cache
            : this.cache,
        url: isPresent(options) && isPresent(options.url)
            ? options.url
            : this.url);
  }
}
/**
 * Injectable version of {@link RequestOptions}, with overridable default values.
 *
 * #Example
 *
 * ```
 * import {Http, BaseRequestOptions, Request} from 'angular2/http';
 * ...
 * class MyComponent {
 *   constructor(baseRequestOptions:BaseRequestOptions, http:Http) {
 *     var options = baseRequestOptions.merge({body: 'foobar', url: 'https://foo'});
 *     var request = new Request(options);
 *     http.request(request).subscribe(res => this.bars = res.json());
 *   }
 * }
 *
 * ```
 */
@Injectable()
class BaseRequestOptions extends RequestOptions {
  BaseRequestOptions() : super(
          method: RequestMethods.GET,
          headers: new Headers(),
          mode: RequestModesOpts.Cors) {
    /* super call moved to initializer */;
  }
}
