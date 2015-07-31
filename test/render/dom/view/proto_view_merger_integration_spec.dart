library angular2.test.render.dom.view.proto_view_merger_integration_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        beforeEach,
        ddescribe,
        describe,
        xdescribe,
        el,
        expect,
        iit,
        inject,
        it,
        xit,
        beforeEachBindings,
        SpyObject,
        stringifyElement;
import "package:angular2/src/facade/lang.dart" show isPresent;
import "../dom_testbed.dart" show DomTestbed;
import "package:angular2/src/render/api.dart"
    show
        ViewDefinition,
        DirectiveMetadata,
        RenderProtoViewMergeMapping,
        ViewEncapsulation,
        ViewType;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/render/dom/util.dart" show cloneAndQueryProtoView;
import "package:angular2/src/render/dom/template_cloner.dart"
    show TemplateCloner;
import "package:angular2/src/render/dom/view/proto_view.dart"
    show resolveInternalDomProtoView, DomProtoView;
import "package:angular2/src/render/dom/view/proto_view_builder.dart"
    show ProtoViewBuilder;
import "package:angular2/src/render/dom/schema/element_schema_registry.dart"
    show ElementSchemaRegistry;

main() {
  describe("ProtoViewMerger integration test", () {
    beforeEachBindings(() => [DomTestbed]);
    describe("component views", () {
      it("should merge a component view", runAndAssert(
          "root", ["a"], ["<root class=\"ng-binding\" idx=\"0\">a</root>"]));
      it("should merge component views with interpolation at root level",
          runAndAssert("root", ["{{a}}"],
              ["<root class=\"ng-binding\" idx=\"0\">{0}</root>"]));
      it("should merge component views with interpolation not at root level",
          runAndAssert("root", ["<div>{{a}}</div>"], [
        "<root class=\"ng-binding\" idx=\"0\"><div class=\"ng-binding\" idx=\"1\">{0}</div></root>"
      ]));
      it("should merge component views with bound elements", runAndAssert(
          "root", ["<div #a></div>"], [
        "<root class=\"ng-binding\" idx=\"0\"><div #a=\"\" class=\"ng-binding\" idx=\"1\"></div></root>"
      ]));
    });
    describe("embedded views", () {
      it("should merge embedded views as fragments", runAndAssert("root",
          ["<template>a</template>"], [
        "<root class=\"ng-binding\" idx=\"0\"><template class=\"ng-binding\" idx=\"1\"></template></root>",
        "a"
      ]));
      it("should merge embedded views with interpolation at root level",
          runAndAssert("root", ["<template>{{a}}</template>"], [
        "<root class=\"ng-binding\" idx=\"0\"><template class=\"ng-binding\" idx=\"1\"></template></root>",
        "{0}"
      ]));
      it("should merge embedded views with interpolation not at root level",
          runAndAssert("root", ["<div *ng-if>{{a}}</div>"], [
        "<root class=\"ng-binding\" idx=\"0\"><template class=\"ng-binding\" idx=\"1\" ng-if=\"\"></template></root>",
        "<div *ng-if=\"\" class=\"ng-binding\" idx=\"2\">{0}</div>"
      ]));
      it("should merge embedded views with bound elements", runAndAssert("root",
          ["<div *ng-if #a></div>"], [
        "<root class=\"ng-binding\" idx=\"0\"><template class=\"ng-binding\" idx=\"1\" ng-if=\"\"></template></root>",
        "<div #a=\"\" *ng-if=\"\" class=\"ng-binding\" idx=\"2\"></div>"
      ]));
    });
    describe("projection", () {
      it("should remove text nodes if there is no ng-content", runAndAssert(
          "root", ["<a>b</a>", ""], [
        "<root class=\"ng-binding\" idx=\"0\"><a class=\"ng-binding\" idx=\"1\"></a></root>"
      ]));
      it("should project static text", runAndAssert("root", [
        "<a>b</a>",
        "A(<ng-content></ng-content>)"
      ], [
        "<root class=\"ng-binding\" idx=\"0\"><a class=\"ng-binding\" idx=\"1\">A(<!--[-->b<!--]-->)</a></root>"
      ]));
      it("should project text interpolation", runAndAssert("root", [
        "<a>{{b}}</a>",
        "A(<ng-content></ng-content>)"
      ], [
        "<root class=\"ng-binding\" idx=\"0\"><a class=\"ng-binding\" idx=\"1\">A(<!--[-->{0}<!--]-->)</a></root>"
      ]));
      it("should project text interpolation to elements without bindings",
          runAndAssert("root", [
        "<a>{{b}}</a>",
        "<div><ng-content></ng-content></div>"
      ], [
        "<root class=\"ng-binding\" idx=\"0\"><a class=\"ng-binding\" idx=\"1\"><div class=\"ng-binding\"><!--[-->{0}<!--]--></div></a></root>"
      ]));
      it("should project elements", runAndAssert("root", [
        "<a><div></div></a>",
        "A(<ng-content></ng-content>)"
      ], [
        "<root class=\"ng-binding\" idx=\"0\"><a class=\"ng-binding\" idx=\"1\">A(<!--[--><div></div><!--]-->)</a></root>"
      ]));
      it("should project elements using the selector", runAndAssert("root", [
        "<a><div class=\"x\">a</div><span></span><div class=\"x\">b</div></a>",
        "A(<ng-content select=\".x\"></ng-content>)"
      ], [
        "<root class=\"ng-binding\" idx=\"0\"><a class=\"ng-binding\" idx=\"1\">A(<!--[--><div class=\"x\">a</div><div class=\"x\">b</div><!--]-->)</a></root>"
      ]));
      it("should reproject", runAndAssert("root", [
        "<a>x</a>",
        "A(<b><ng-content></ng-content></b>)",
        "B(<ng-content></ng-content>)"
      ], [
        "<root class=\"ng-binding\" idx=\"0\"><a class=\"ng-binding\" idx=\"1\">A(<b class=\"ng-binding\" idx=\"2\">B(<!--[--><!--[-->x<!--]--><!--]-->)</b>)</a></root>"
      ]));
      it("should reproject text interpolation to sibling text nodes",
          runAndAssert("root", [
        "<a>{{x}}</a>",
        "<b>A(<ng-content></ng-content>)</b>)",
        "B(<ng-content></ng-content>)"
      ], [
        "<root class=\"ng-binding\" idx=\"0\"><a class=\"ng-binding\" idx=\"1\"><b class=\"ng-binding\" idx=\"2\">B(<!--[-->A(<!--[-->{0}<!--]-->)<!--]-->)</b>)</a></root>"
      ]));
      it("should reproject by combining selectors", runAndAssert("root", [
        "<a><div class=\"x\"></div><div class=\"x y\"></div><div class=\"y\"></div></a>",
        "A(<b><ng-content select=\".x\"></ng-content></b>)",
        "B(<ng-content select=\".y\"></ng-content>)"
      ], [
        "<root class=\"ng-binding\" idx=\"0\"><a class=\"ng-binding\" idx=\"1\">A(<b class=\"ng-binding\" idx=\"2\">B(<!--[--><div class=\"x y\"></div><!--]-->)</b>)</a></root>"
      ]));
      it("should keep non projected embedded views as fragments (so that they can be moved manually)",
          runAndAssert("root", [
        "<a><template class=\"x\">b</template></a>",
        ""
      ], [
        "<root class=\"ng-binding\" idx=\"0\"><a class=\"ng-binding\" idx=\"1\"></a></root>",
        "b"
      ]));
      it("should project embedded views and match the template element",
          runAndAssert("root", [
        "<a><template class=\"x\">b</template></a>",
        "A(<ng-content></ng-content>)"
      ], [
        "<root class=\"ng-binding\" idx=\"0\"><a class=\"ng-binding\" idx=\"1\">A(<!--[--><template class=\"x ng-binding\" idx=\"2\"></template><!--]-->)</a></root>",
        "b"
      ]));
      it("should project nodes using the ng-content in embedded views",
          runAndAssert("root", [
        "<a>b</a>",
        "A(<ng-content *ng-if></ng-content>)"
      ], [
        "<root class=\"ng-binding\" idx=\"0\"><a class=\"ng-binding\" idx=\"1\">A(<template class=\"ng-binding\" idx=\"2\" ng-if=\"\"></template>)</a></root>",
        "<!--[-->b<!--]-->"
      ]));
      it("should allow to use wildcard selector after embedded view with non wildcard selector",
          runAndAssert("root", [
        "<a><div class=\"x\">a</div>b</a>",
        "A(<ng-content select=\".x\" *ng-if></ng-content>, <ng-content></ng-content>)"
      ], [
        "<root class=\"ng-binding\" idx=\"0\"><a class=\"ng-binding\" idx=\"1\">A(<template class=\"ng-binding\" idx=\"2\" ng-if=\"\"></template>, <!--[-->b<!--]-->)</a></root>",
        "<!--[--><div class=\"x\">a</div><!--]-->"
      ]));
    });
    describe("composition", () {
      it("should merge multiple component views", runAndAssert("root", [
        "<a></a><b></b>",
        "c",
        "d"
      ], [
        "<root class=\"ng-binding\" idx=\"0\"><a class=\"ng-binding\" idx=\"1\">c</a><b class=\"ng-binding\" idx=\"2\">d</b></root>"
      ]));
      it("should merge multiple embedded views as fragments", runAndAssert(
          "root", ["<div *ng-if></div><span *ng-for></span>"], [
        "<root class=\"ng-binding\" idx=\"0\"><template class=\"ng-binding\" idx=\"1\" ng-if=\"\"></template><template class=\"ng-binding\" idx=\"2\" ng-for=\"\"></template></root>",
        "<div *ng-if=\"\"></div>",
        "<span *ng-for=\"\"></span>"
      ]));
      it("should merge nested embedded views as fragments", runAndAssert("root",
          ["<div *ng-if><span *ng-for></span></div>"], [
        "<root class=\"ng-binding\" idx=\"0\"><template class=\"ng-binding\" idx=\"1\" ng-if=\"\"></template></root>",
        "<div *ng-if=\"\"><template class=\"ng-binding\" idx=\"2\" ng-for=\"\"></template></div>",
        "<span *ng-for=\"\"></span>"
      ]));
    });
    describe(
        "element index mapping should be grouped by view and view depth first",
        () {
      it("should map component views correctly", runAndAssert("root", [
        "<a></a><b></b>",
        "<c></c>"
      ], [
        "<root class=\"ng-binding\" idx=\"0\"><a class=\"ng-binding\" idx=\"1\"><c class=\"ng-binding\" idx=\"3\"></c></a><b class=\"ng-binding\" idx=\"2\"></b></root>"
      ]));
      it("should map moved projected elements correctly", runAndAssert("root", [
        "<a><b></b><c></c></a>",
        "<ng-content select=\"c\"></ng-content><ng-content select=\"b\"></ng-content>"
      ], [
        "<root class=\"ng-binding\" idx=\"0\"><a class=\"ng-binding\" idx=\"1\"><!--[--><c class=\"ng-binding\" idx=\"3\"></c><!--]--><!--[--><b class=\"ng-binding\" idx=\"2\"></b><!--]--></a></root>"
      ]));
    });
    describe(
        "text index mapping should be grouped by view and view depth first",
        () {
      it("should map component views correctly", runAndAssert("root", [
        "<a></a>{{b}}",
        "{{c}}"
      ], [
        "<root class=\"ng-binding\" idx=\"0\"><a class=\"ng-binding\" idx=\"1\">{1}</a>{0}</root>"
      ]));
      it("should map moved projected elements correctly", runAndAssert("root", [
        "<a><div x>{{x}}</div><div y>{{y}}</div></a>",
        "<ng-content select=\"[y]\"></ng-content><ng-content select=\"[x]\"></ng-content>"
      ], [
        "<root class=\"ng-binding\" idx=\"0\"><a class=\"ng-binding\" idx=\"1\"><!--[--><div class=\"ng-binding\" idx=\"3\" y=\"\">{1}</div><!--]--><!--[--><div class=\"ng-binding\" idx=\"2\" x=\"\">{0}</div><!--]--></a></root>"
      ]));
    });
    describe("native shadow dom support", () {
      it("should keep the non projected light dom and wrap the component view into a shadow-root element",
          runAndAssert("native-root", ["<a>b</a>", "c"], [
        "<native-root class=\"ng-binding\" idx=\"0\"><shadow-root><a class=\"ng-binding\" idx=\"1\"><shadow-root>c</shadow-root>b</a></shadow-root></native-root>"
      ]));
    });
    describe("host attributes", () {
      it("should set host attributes while merging", inject([
        AsyncTestCompleter,
        DomTestbed,
        TemplateCloner
      ], (async, DomTestbed tb, TemplateCloner cloner) {
        tb.compiler.compileHost(rootDirective("root")).then((rootProtoViewDto) {
          var builder = new ProtoViewBuilder(DOM.createTemplate(""),
              ViewType.COMPONENT, ViewEncapsulation.NONE);
          builder.setHostAttribute("a", "b");
          var componentProtoViewDto =
              builder.build(new ElementSchemaRegistry(), cloner);
          tb
              .merge([rootProtoViewDto, componentProtoViewDto])
              .then((mergeMappings) {
            var domPv =
                resolveInternalDomProtoView(mergeMappings.mergedProtoViewRef);
            expect(DOM.getInnerHTML(templateRoot(domPv)))
                .toEqual("<root class=\"ng-binding\" a=\"b\"></root>");
            async.done();
          });
        });
      }));
    });
  });
}
templateRoot(DomProtoView pv) {
  return (pv.cloneableTemplate as dynamic);
}
runAndAssert(String hostElementName, List<String> componentTemplates,
    List<String> expectedFragments) {
  var useNativeEncapsulation = hostElementName.startsWith("native-");
  var rootComp = rootDirective(hostElementName);
  return inject([
    AsyncTestCompleter,
    DomTestbed,
    TemplateCloner
  ], (async, DomTestbed tb, TemplateCloner cloner) {
    tb
        .compileAndMerge(rootComp, componentTemplates
            .map((template) => componentView(template, useNativeEncapsulation
                ? ViewEncapsulation.NATIVE
                : ViewEncapsulation.NONE))
            .toList())
        .then((mergeMappings) {
      expect(stringify(cloner, mergeMappings)).toEqual(expectedFragments);
      async.done();
    });
  });
}
rootDirective(String hostElementName) {
  return DirectiveMetadata.create(
      id: "rootComp",
      type: DirectiveMetadata.COMPONENT_TYPE,
      selector: hostElementName);
}
componentView(String template,
    [ViewEncapsulation encapsulation = ViewEncapsulation.NONE]) {
  return new ViewDefinition(
      componentId: "someComp",
      template: template,
      directives: [aComp, bComp, cComp],
      encapsulation: encapsulation);
}
List<String> stringify(
    TemplateCloner cloner, RenderProtoViewMergeMapping protoViewMergeMapping) {
  var testView = cloneAndQueryProtoView(cloner,
      resolveInternalDomProtoView(protoViewMergeMapping.mergedProtoViewRef),
      false);
  for (var i = 0; i < protoViewMergeMapping.mappedElementIndices.length; i++) {
    var renderElIdx = protoViewMergeMapping.mappedElementIndices[i];
    if (isPresent(renderElIdx)) {
      DOM.setAttribute(testView.boundElements[renderElIdx], "idx", '''${ i}''');
    }
  }
  for (var i = 0; i < protoViewMergeMapping.mappedTextIndices.length; i++) {
    var renderTextIdx = protoViewMergeMapping.mappedTextIndices[i];
    if (isPresent(renderTextIdx)) {
      DOM.setText(testView.boundTextNodes[renderTextIdx], '''{${ i}}''');
    }
  }
  expect(protoViewMergeMapping.fragmentCount)
      .toEqual(testView.fragments.length);
  return testView.fragments
      .map((nodes) =>
          nodes.map((node) => stringifyElement(node)).toList().join(""))
      .toList();
}
var aComp = DirectiveMetadata.create(
    id: "aComp", type: DirectiveMetadata.COMPONENT_TYPE, selector: "a");
var bComp = DirectiveMetadata.create(
    id: "bComp", type: DirectiveMetadata.COMPONENT_TYPE, selector: "b");
var cComp = DirectiveMetadata.create(
    id: "cComp", type: DirectiveMetadata.COMPONENT_TYPE, selector: "c");
