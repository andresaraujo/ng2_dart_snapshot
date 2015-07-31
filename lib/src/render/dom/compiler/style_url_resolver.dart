// Some of the code comes from WebComponents.JS

// https://github.com/webcomponents/webcomponentsjs/blob/master/src/HTMLImports/path.js
library angular2.src.render.dom.compiler.style_url_resolver;

import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/facade/lang.dart"
    show RegExp, RegExpWrapper, StringWrapper;
import "package:angular2/src/services/url_resolver.dart" show UrlResolver;

/**
 * Rewrites URLs by resolving '@import' and 'url()' URLs from the given base URL.
 */
@Injectable()
class StyleUrlResolver {
  UrlResolver _resolver;
  StyleUrlResolver(this._resolver) {}
  String resolveUrls(String cssText, String baseUrl) {
    cssText = this._replaceUrls(cssText, _cssUrlRe, baseUrl);
    cssText = this._replaceUrls(cssText, _cssImportRe, baseUrl);
    return cssText;
  }
  _replaceUrls(String cssText, RegExp re, String baseUrl) {
    return StringWrapper.replaceAllMapped(cssText, re, (m) {
      var pre = m[1];
      var originalUrl = m[2];
      if (RegExpWrapper.test(_dataUrlRe, originalUrl)) {
        // Do not attempt to resolve data: URLs
        return m[0];
      }
      var url = StringWrapper.replaceAll(originalUrl, _quoteRe, "");
      var post = m[3];
      var resolvedUrl = this._resolver.resolve(baseUrl, url);
      return pre + "'" + resolvedUrl + "'" + post;
    });
  }
}
var _cssUrlRe = new RegExp(r'(url\()([^)]*)(\))');
var _cssImportRe = new RegExp(r'(@import[\s]+(?!url\())[' +
    "'" +
    r'"]([^' +
    "'" +
    r'"]*)[' +
    "'" +
    r'"](.*;)');
var _quoteRe = new RegExp(r'[' + "'" + r'"]');
var _dataUrlRe = new RegExp(r'^[' + "'" + r'"]?data:');
