library angular2.src.render.dom.template_cloner;

import "package:angular2/src/facade/lang.dart" show isString;
import "package:angular2/di.dart" show Injectable, Inject;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "dom_tokens.dart" show MAX_IN_MEMORY_ELEMENTS_PER_TEMPLATE_TOKEN;

@Injectable()
class TemplateCloner {
  num maxInMemoryElementsPerTemplate;
  TemplateCloner(@Inject(
      MAX_IN_MEMORY_ELEMENTS_PER_TEMPLATE_TOKEN) maxInMemoryElementsPerTemplate) {
    this.maxInMemoryElementsPerTemplate = maxInMemoryElementsPerTemplate;
  }
  dynamic /* dynamic | String */ prepareForClone(dynamic templateRoot) {
    var elementCount =
        DOM.querySelectorAll(DOM.content(templateRoot), "*").length;
    if (this.maxInMemoryElementsPerTemplate >= 0 &&
        elementCount >= this.maxInMemoryElementsPerTemplate) {
      return DOM.getInnerHTML(templateRoot);
    } else {
      return templateRoot;
    }
  }
  dynamic cloneContent(
      dynamic /* dynamic | String */ preparedTemplateRoot, bool importNode) {
    var templateContent;
    if (isString(preparedTemplateRoot)) {
      templateContent = DOM.content(DOM.createTemplate(preparedTemplateRoot));
      if (importNode) {
        // Attention: We can't use document.adoptNode here

        // as this does NOT wake up custom elements in Chrome 43

        // TODO: Use div.innerHTML instead of template.innerHTML when we

        // have code to support the various special cases and

        // don't use importNode additionally (e.g. for <tr>, svg elements, ...)

        // see https://github.com/angular/angular/issues/3364
        templateContent = DOM.importIntoDoc(templateContent);
      }
    } else {
      templateContent = DOM.content((preparedTemplateRoot as dynamic));
      if (importNode) {
        templateContent = DOM.importIntoDoc(templateContent);
      } else {
        templateContent = DOM.clone(templateContent);
      }
    }
    return templateContent;
  }
}
