library angular2.src.render.dom.compiler.view_loader;

import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/facade/lang.dart"
    show isBlank, isPresent, BaseException, stringify, isPromise;
import "package:angular2/src/facade/collection.dart"
    show Map, MapWrapper, ListWrapper, List;
import "package:angular2/src/facade/async.dart" show PromiseWrapper, Future;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/render/xhr.dart" show XHR;
import "../../api.dart" show ViewDefinition;
import "style_inliner.dart" show StyleInliner;
import "style_url_resolver.dart" show StyleUrlResolver;

/**
 * Strategy to load component views.
 * TODO: Make public API once we are more confident in this approach.
 */
@Injectable()
class ViewLoader {
  XHR _xhr;
  StyleInliner _styleInliner;
  StyleUrlResolver _styleUrlResolver;
  Map<String, Future<String>> _cache = new Map();
  ViewLoader(this._xhr, this._styleInliner, this._styleUrlResolver) {}
  Future<dynamic> load(ViewDefinition view) {
    List<dynamic /* String | Future < String > */ > tplElAndStyles =
        [this._loadHtml(view)];
    if (isPresent(view.styles)) {
      view.styles.forEach((String cssText) {
        var textOrPromise =
            this._resolveAndInlineCssText(cssText, view.templateAbsUrl);
        tplElAndStyles.add(textOrPromise);
      });
    }
    if (isPresent(view.styleAbsUrls)) {
      view.styleAbsUrls.forEach((url) {
        var promise = this._loadText(url).then((cssText) =>
            this._resolveAndInlineCssText(cssText, view.templateAbsUrl));
        tplElAndStyles.add(promise);
      });
    }
    // Inline the styles from the @View annotation and return a template element
    return PromiseWrapper.all(tplElAndStyles).then((List<String> res) {
      var tplEl = res[0];
      var cssTexts = ListWrapper.slice(res, 1);
      _insertCssTexts(DOM.content(tplEl), cssTexts);
      return tplEl;
    });
  }
  Future<String> _loadText(String url) {
    var response = this._cache[url];
    if (isBlank(response)) {
      // TODO(vicb): change error when TS gets fixed

      // https://github.com/angular/angular/issues/2280

      // throw new BaseException(`Failed to fetch url "${url}"`);
      response = PromiseWrapper.catchError(this._xhr.get(url),
          (_) => PromiseWrapper.reject(
              new BaseException('''Failed to fetch url "${ url}"'''), null));
      this._cache[url] = response;
    }
    return response;
  }
  // Load the html and inline any style tags
  Future<dynamic> _loadHtml(ViewDefinition view) {
    var html;
    // Load the HTML
    if (isPresent(view.template)) {
      html = PromiseWrapper.resolve(view.template);
    } else if (isPresent(view.templateAbsUrl)) {
      html = this._loadText(view.templateAbsUrl);
    } else {
      throw new BaseException(
          "View should have either the templateUrl or template property set");
    }
    // Inline the style tags from the html
    return html.then((html) {
      var tplEl = DOM.createTemplate(html);
      var styleEls = DOM.querySelectorAll(DOM.content(tplEl), "STYLE");
      List<Future<String>> promises = [];
      for (var i = 0; i < styleEls.length; i++) {
        var promise =
            this._resolveAndInlineElement(styleEls[i], view.templateAbsUrl);
        if (isPromise(promise)) {
          promises.add(promise);
        }
      }
      return promises.length > 0
          ? PromiseWrapper.all(promises).then((_) => tplEl)
          : tplEl;
    });
  }
  /**
   * Inlines a style element.
   *
   * @param styleEl The style element
   * @param baseUrl The base url
   * @returns {Promise<any>} null when no @import rule exist in the css or a Promise
   * @private
   */
  Future<dynamic> _resolveAndInlineElement(styleEl, String baseUrl) {
    var textOrPromise =
        this._resolveAndInlineCssText(DOM.getText(styleEl), baseUrl);
    if (isPromise(textOrPromise)) {
      return ((textOrPromise as Future<String>)).then((css) {
        DOM.setText(styleEl, css);
      });
    } else {
      DOM.setText(styleEl, (textOrPromise as String));
      return null;
    }
  }
  dynamic /* String | Future < String > */ _resolveAndInlineCssText(
      String cssText, String baseUrl) {
    cssText = this._styleUrlResolver.resolveUrls(cssText, baseUrl);
    return this._styleInliner.inlineImports(cssText, baseUrl);
  }
}
void _insertCssTexts(element, List<String> cssTexts) {
  if (cssTexts.length == 0) return;
  var insertBefore = DOM.firstChild(element);
  for (var i = cssTexts.length - 1; i >= 0; i--) {
    var styleEl = DOM.createStyleElement(cssTexts[i]);
    if (isPresent(insertBefore)) {
      DOM.insertBefore(insertBefore, styleEl);
    } else {
      DOM.appendChild(element, styleEl);
    }
    insertBefore = styleEl;
  }
}
