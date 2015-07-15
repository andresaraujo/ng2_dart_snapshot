library angular2.src.http.base_response_options;

import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/facade/lang.dart" show isPresent, isJsObject;
import "headers.dart" show Headers;
import "enums.dart" show ResponseTypes;
import "interfaces.dart" show IResponseOptions;

/**
 * Creates a response options object similar to the
 * [ResponseInit](https://fetch.spec.whatwg.org/#responseinit) description
 * in the Fetch
 * Spec to be optionally provided when instantiating a
 * {@link Response}.
 *
 * All values are null by default.
 */
class ResponseOptions implements IResponseOptions {
  // TODO: ArrayBuffer | FormData | Blob
  dynamic /* String | Object */ body;
  num status;
  Headers headers;
  String statusText;
  ResponseTypes type;
  String url;
  ResponseOptions({body, status, headers, statusText, type, url}) {
    this.body = isPresent(body) ? body : null;
    this.status = isPresent(status) ? status : null;
    this.headers = isPresent(headers) ? headers : null;
    this.statusText = isPresent(statusText) ? statusText : null;
    this.type = isPresent(type) ? type : null;
    this.url = isPresent(url) ? url : null;
  }
  ResponseOptions merge([IResponseOptions options]) {
    return new ResponseOptions(
        body: isPresent(options) && isPresent(options.body)
            ? options.body
            : this.body,
        status: isPresent(options) && isPresent(options.status)
            ? options.status
            : this.status,
        headers: isPresent(options) && isPresent(options.headers)
            ? options.headers
            : this.headers,
        statusText: isPresent(options) && isPresent(options.statusText)
            ? options.statusText
            : this.statusText,
        type: isPresent(options) && isPresent(options.type)
            ? options.type
            : this.type,
        url: isPresent(options) && isPresent(options.url)
            ? options.url
            : this.url);
  }
}
/**
 * Injectable version of {@link ResponseOptions}, with overridable default values.
 */
@Injectable()
class BaseResponseOptions extends ResponseOptions {
  // TODO: Object | ArrayBuffer | JSON | FormData | Blob
  dynamic /* String | Object | ArrayBuffer | JSON | FormData | Blob */ body;
  num status;
  Headers headers;
  String statusText;
  ResponseTypes type;
  String url;
  BaseResponseOptions() : super(
          status: 200,
          statusText: "Ok",
          type: ResponseTypes.Default,
          headers: new Headers()) {
    /* super call moved to initializer */;
  }
}
