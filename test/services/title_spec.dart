library angular2.test.services.title_spec;

import "package:angular2/test_lib.dart"
    show ddescribe, describe, it, iit, xit, expect, afterEach;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/services/title.dart" show Title;

main() {
  describe("title service", () {
    var initialTitle = DOM.getTitle();
    var titleService = new Title();
    afterEach(() {
      DOM.setTitle(initialTitle);
    });
    it("should allow reading initial title", () {
      expect(titleService.getTitle()).toEqual(initialTitle);
    });
    it("should set a title on the injected document", () {
      titleService.setTitle("test title");
      expect(DOM.getTitle()).toEqual("test title");
      expect(titleService.getTitle()).toEqual("test title");
    });
    it("should reset title to empty string if title not provided", () {
      titleService.setTitle(null);
      expect(DOM.getTitle()).toEqual("");
    });
  });
}
