library angular2.src.render.dom.compiler.view_loader;

import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/facade/lang.dart"
    show isBlank, isPresent, BaseException, stringify, isPromise, StringWrapper;
import "package:angular2/src/facade/collection.dart"
    show Map, MapWrapper, ListWrapper, List;
import "package:angular2/src/facade/async.dart" show PromiseWrapper, Future;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "../../api.dart" show ViewDefinition;
import "package:angular2/src/render/xhr.dart" show XHR;
import "style_inliner.dart" show StyleInliner;
import "style_url_resolver.dart" show StyleUrlResolver;

class TemplateAndStyles {
  String template;
  List<String> styles;
  TemplateAndStyles(this.template, this.styles) {}
}
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
  Future<TemplateAndStyles> load(ViewDefinition viewDef) {
    List<dynamic /* Future < TemplateAndStyles > | Future < String > | String */ > tplAndStyles =
        [this._loadHtml(viewDef.template, viewDef.templateAbsUrl)];
    if (isPresent(viewDef.styles)) {
      viewDef.styles.forEach((String cssText) {
        var textOrPromise =
            this._resolveAndInlineCssText(cssText, viewDef.templateAbsUrl);
        tplAndStyles.add(textOrPromise);
      });
    }
    if (isPresent(viewDef.styleAbsUrls)) {
      viewDef.styleAbsUrls.forEach((url) {
        var promise = this._loadText(url).then((cssText) =>
            this._resolveAndInlineCssText(cssText, viewDef.templateAbsUrl));
        tplAndStyles.add(promise);
      });
    }
    // Inline the styles from the @View annotation
    return PromiseWrapper
        .all(tplAndStyles)
        .then((List<dynamic /* TemplateAndStyles | String */ > res) {
      var loadedTplAndStyles = (res[0] as TemplateAndStyles);
      var styles = (ListWrapper.slice(res, 1) as List<String>);
      return new TemplateAndStyles(loadedTplAndStyles.template,
          new List.from(loadedTplAndStyles.styles)..addAll(styles));
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
  Future<TemplateAndStyles> _loadHtml(String template, String templateAbsUrl) {
    var html;
    // Load the HTML
    if (isPresent(template)) {
      html = PromiseWrapper.resolve(template);
    } else if (isPresent(templateAbsUrl)) {
      html = this._loadText(templateAbsUrl);
    } else {
      throw new BaseException(
          "View should have either the templateUrl or template property set");
    }
    return html.then((html) {
      var tplEl = DOM.createTemplate(html);
      // Replace $baseUrl with the base url for the template
      if (isPresent(templateAbsUrl) && templateAbsUrl.indexOf("/") >= 0) {
        var baseUrl =
            templateAbsUrl.substring(0, templateAbsUrl.lastIndexOf("/"));
        this._substituteBaseUrl(DOM.content(tplEl), baseUrl);
      }
      var styleEls = DOM.querySelectorAll(DOM.content(tplEl), "STYLE");
      List<String> unresolvedStyles = [];
      for (var i = 0; i < styleEls.length; i++) {
        var styleEl = styleEls[i];
        unresolvedStyles.add(DOM.getText(styleEl));
        DOM.remove(styleEl);
      }
      List<String> syncStyles = [];
      List<Future<String>> asyncStyles = [];
      // Inline the style tags from the html
      for (var i = 0; i < styleEls.length; i++) {
        var styleEl = styleEls[i];
        var resolvedStyled =
            this._resolveAndInlineCssText(DOM.getText(styleEl), templateAbsUrl);
        if (isPromise(resolvedStyled)) {
          asyncStyles.add((resolvedStyled as Future<String>));
        } else {
          syncStyles.add((resolvedStyled as String));
        }
      }
      if (identical(asyncStyles.length, 0)) {
        return PromiseWrapper.resolve(
            new TemplateAndStyles(DOM.getInnerHTML(tplEl), syncStyles));
      } else {
        return PromiseWrapper.all(asyncStyles).then(
            (loadedStyles) => new TemplateAndStyles(DOM.getInnerHTML(tplEl),
                new List.from(syncStyles)
          ..addAll((loadedStyles as List<String>))));
      }
    });
  }
  /**
   * Replace all occurrences of $baseUrl in the attributes of an element and its
   * children with the base URL of the template.
   *
   * @param element The element to process
   * @param baseUrl The base URL of the template.
   * @private
   */
  void _substituteBaseUrl(element, String baseUrl) {
    if (DOM.isElementNode(element)) {
      var attrs = DOM.attributeMap(element);
      MapWrapper.forEach(attrs, (v, k) {
        if (isPresent(v) && v.indexOf("\$baseUrl") >= 0) {
          DOM.setAttribute(element, k,
              StringWrapper.replaceAll(v, new RegExp(r'\$baseUrl'), baseUrl));
        }
      });
    }
    var children = DOM.childNodes(element);
    for (var i = 0; i < children.length; i++) {
      if (DOM.isElementNode(children[i])) {
        this._substituteBaseUrl(children[i], baseUrl);
      }
    }
  }
  dynamic /* String | Future < String > */ _resolveAndInlineCssText(
      String cssText, String baseUrl) {
    cssText = this._styleUrlResolver.resolveUrls(cssText, baseUrl);
    return this._styleInliner.inlineImports(cssText, baseUrl);
  }
}
