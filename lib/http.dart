/**
 * @module
 * @description
 * The http module provides services to perform http requests. To get started, see the {@link Http}
 * class.
 */
library angular2.http;

import "package:angular2/di.dart" show bind, Binding;
import "package:angular2/src/http/http.dart" show Http, Jsonp;
import "package:angular2/src/http/backends/xhr_backend.dart"
    show XHRBackend, XHRConnection;
import "package:angular2/src/http/backends/jsonp_backend.dart"
    show JSONPBackend, JSONPConnection;
import "package:angular2/src/http/backends/browser_xhr.dart" show BrowserXhr;
import "package:angular2/src/http/backends/browser_jsonp.dart"
    show BrowserJsonp;
import "package:angular2/src/http/base_request_options.dart"
    show BaseRequestOptions, RequestOptions;
import "package:angular2/src/http/interfaces.dart" show ConnectionBackend;
export "package:angular2/src/http/backends/mock_backend.dart"
    show MockConnection, MockBackend;
export "package:angular2/src/http/static_request.dart" show Request;
export "package:angular2/src/http/static_response.dart" show Response;
import "package:angular2/src/http/base_response_options.dart"
    show BaseResponseOptions, ResponseOptions;
export "package:angular2/src/http/interfaces.dart"
    show IRequestOptions, IResponseOptions, Connection, ConnectionBackend;
export "package:angular2/src/http/base_request_options.dart"
    show BaseRequestOptions, RequestOptions;
export "package:angular2/src/http/base_response_options.dart"
    show BaseResponseOptions, ResponseOptions;
export "package:angular2/src/http/backends/xhr_backend.dart"
    show XHRBackend, XHRConnection;
export "package:angular2/src/http/backends/jsonp_backend.dart"
    show JSONPBackend, JSONPConnection;
export "package:angular2/src/http/http.dart" show Http, Jsonp;
export "package:angular2/src/http/headers.dart" show Headers;
export "package:angular2/src/http/enums.dart"
    show
        ResponseTypes,
        ReadyStates,
        RequestMethods,
        RequestCredentialsOpts,
        RequestCacheOpts,
        RequestModesOpts;
export "package:angular2/src/http/url_search_params.dart" show URLSearchParams;

/**
 * Provides a basic set of injectables to use the {@link Http} service in any application.
 *
 * #Example
 *
 * ```
 * import {httpInjectables, Http} from 'angular2/http';
 * @Component({selector: 'http-app', viewInjector: [httpInjectables]})
 * @View({template: '{{data}}'})
 * class MyApp {
 *   constructor(http:Http) {
 *     http.request('data.txt').subscribe(res => this.data = res.text());
 *   }
 * }
 * ```
 *
 */
List<dynamic> httpInjectables = [
  bind(ConnectionBackend).toClass(XHRBackend),
  BrowserXhr,
  bind(RequestOptions).toClass(BaseRequestOptions),
  bind(ResponseOptions).toClass(BaseResponseOptions),
  Http
];
List<dynamic> jsonpInjectables = [
  bind(ConnectionBackend).toClass(JSONPBackend),
  BrowserJsonp,
  bind(RequestOptions).toClass(BaseRequestOptions),
  bind(ResponseOptions).toClass(BaseResponseOptions),
  Jsonp
];
