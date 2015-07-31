library angular2.test.render.dom.view.shared_styles_host_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        beforeEach,
        ddescribe,
        xdescribe,
        describe,
        el,
        dispatchEvent,
        expect,
        iit,
        inject,
        beforeEachBindings,
        it,
        xit,
        SpyObject,
        proxy;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/render/dom/view/shared_styles_host.dart"
    show DomSharedStylesHost;

main() {
  describe("DomSharedStylesHost", () {
    var doc;
    DomSharedStylesHost ssh;
    dynamic someHost;
    beforeEach(() {
      doc = DOM.createHtmlDocument();
      doc.title = "";
      ssh = new DomSharedStylesHost(doc);
      someHost = DOM.createElement("div");
    });
    it("should add existing styles to new hosts", () {
      ssh.addStyles(["a {};"]);
      ssh.addHost(someHost);
      expect(DOM.getInnerHTML(someHost)).toEqual("<style>a {};</style>");
    });
    it("should add new styles to hosts", () {
      ssh.addHost(someHost);
      ssh.addStyles(["a {};"]);
      expect(DOM.getInnerHTML(someHost)).toEqual("<style>a {};</style>");
    });
    it("should add styles only once to hosts", () {
      ssh.addStyles(["a {};"]);
      ssh.addHost(someHost);
      ssh.addStyles(["a {};"]);
      expect(DOM.getInnerHTML(someHost)).toEqual("<style>a {};</style>");
    });
    it("should use the document head as default host", () {
      ssh.addStyles(["a {};", "b {};"]);
      expect(doc.head).toHaveText("a {};b {};");
    });
  });
}
