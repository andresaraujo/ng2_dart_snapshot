library angular2.test.render.dom.shadow_dom_emulation_integration_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        beforeEach,
        ddescribe,
        describe,
        el,
        expect,
        iit,
        inject,
        it,
        xit,
        beforeEachBindings,
        SpyObject;
import "package:angular2/di.dart" show bind;
import "package:angular2/src/facade/collection.dart"
    show MapWrapper, ListWrapper, StringMapWrapper;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/render/api.dart"
    show ViewDefinition, DirectiveMetadata;
import "package:angular2/src/render/dom/shadow_dom/shadow_dom_strategy.dart"
    show ShadowDomStrategy;
import "package:angular2/src/render/dom/shadow_dom/emulated_scoped_shadow_dom_strategy.dart"
    show EmulatedScopedShadowDomStrategy;
import "package:angular2/src/render/dom/shadow_dom/emulated_unscoped_shadow_dom_strategy.dart"
    show EmulatedUnscopedShadowDomStrategy;
import "package:angular2/src/render/dom/shadow_dom/native_shadow_dom_strategy.dart"
    show NativeShadowDomStrategy;
import "dom_testbed.dart" show DomTestbed, elRef;

main() {
  describe("ShadowDom integration tests", () {
    var styleHost = DOM.createElement("div");
    var strategies = {
      "scoped": bind(ShadowDomStrategy)
          .toValue(new EmulatedScopedShadowDomStrategy(styleHost)),
      "unscoped": bind(ShadowDomStrategy)
          .toValue(new EmulatedUnscopedShadowDomStrategy(styleHost))
    };
    if (DOM.supportsNativeShadowDOM()) {
      StringMapWrapper.set(strategies, "native",
          bind(ShadowDomStrategy).toValue(new NativeShadowDomStrategy()));
    }
    StringMapWrapper.forEach(strategies, (strategyBinding, name) {
      describe('''${ name} shadow dom strategy''', () {
        beforeEachBindings(() {
          return [strategyBinding, DomTestbed];
        });
        // GH-2095 - https://github.com/angular/angular/issues/2095

        // important as we are adding a content end element during compilation,

        // which could skrew up text node indices.
        it("should support text nodes after content tags", inject([
          DomTestbed,
          AsyncTestCompleter
        ], (tb, async) {
          tb
              .compileAll([
            simple,
            new ViewDefinition(
                componentId: "simple",
                template: "<content></content><p>P,</p>{{a}}",
                directives: [])
          ])
              .then((protoViewDtos) {
            var rootView = tb.createRootView(protoViewDtos[0]);
            var cmpView =
                tb.createComponentView(rootView.viewRef, 0, protoViewDtos[1]);
            tb.renderer.setText(cmpView.viewRef, 0, "text");
            expect(tb.rootEl).toHaveText("P,text");
            async.done();
          });
        }));
        // important as we are moving style tags around during compilation,

        // which could skrew up text node indices.
        it("should support text nodes after style tags", inject([
          DomTestbed,
          AsyncTestCompleter
        ], (tb, async) {
          tb
              .compileAll([
            simple,
            new ViewDefinition(
                componentId: "simple",
                template: "<style></style><p>P,</p>{{a}}",
                directives: [])
          ])
              .then((protoViewDtos) {
            var rootView = tb.createRootView(protoViewDtos[0]);
            var cmpView =
                tb.createComponentView(rootView.viewRef, 0, protoViewDtos[1]);
            tb.renderer.setText(cmpView.viewRef, 0, "text");
            expect(tb.rootEl).toHaveText("P,text");
            async.done();
          });
        }));
        it("should support simple components", inject([
          AsyncTestCompleter,
          DomTestbed
        ], (async, tb) {
          tb
              .compileAll([
            mainDir,
            new ViewDefinition(
                componentId: "main",
                template: "<simple>" + "<div>A</div>" + "</simple>",
                directives: [simple]),
            simpleTemplate
          ])
              .then((protoViews) {
            tb.createRootViews(protoViews);
            expect(tb.rootEl).toHaveText("SIMPLE(A)");
            async.done();
          });
        }));
        it("should support simple components with text interpolation as direct children",
            inject([AsyncTestCompleter, DomTestbed], (async, tb) {
          tb
              .compileAll([
            mainDir,
            new ViewDefinition(
                componentId: "main",
                template: "<simple>" + "{{text}}" + "</simple>",
                directives: [simple]),
            simpleTemplate
          ])
              .then((protoViews) {
            var cmpView = tb.createRootViews(protoViews)[1];
            tb.renderer.setText(cmpView.viewRef, 0, "A");
            expect(tb.rootEl).toHaveText("SIMPLE(A)");
            async.done();
          });
        }));
        it("should not show the light dom even if there is not content tag",
            inject([AsyncTestCompleter, DomTestbed], (async, tb) {
          tb
              .compileAll([
            mainDir,
            new ViewDefinition(
                componentId: "main",
                template: "<empty>" + "<div>A</div>" + "</empty>",
                directives: [empty]),
            emptyTemplate
          ])
              .then((protoViews) {
            tb.createRootViews(protoViews);
            expect(tb.rootEl).toHaveText("");
            async.done();
          });
        }));
        it("should support dynamic components", inject([
          AsyncTestCompleter,
          DomTestbed
        ], (async, tb) {
          tb
              .compileAll([
            mainDir,
            new ViewDefinition(
                componentId: "main",
                template: "<dynamic>" + "<div>A</div>" + "</dynamic>",
                directives: [dynamicComponent]),
            simpleTemplate
          ])
              .then((protoViews) {
            var views = tb.createRootViews(ListWrapper.slice(protoViews, 0, 2));
            tb.createComponentView(views[1].viewRef, 0, protoViews[2]);
            expect(tb.rootEl).toHaveText("SIMPLE(A)");
            async.done();
          });
        }));
        it("should support multiple content tags", inject([
          AsyncTestCompleter,
          DomTestbed
        ], (async, tb) {
          tb
              .compileAll([
            mainDir,
            new ViewDefinition(
                componentId: "main",
                template: "<multiple-content-tags>" +
                    "<div>B</div>" +
                    "<div>C</div>" +
                    "<div class=\"left\">A</div>" +
                    "</multiple-content-tags>",
                directives: [multipleContentTagsComponent]),
            multipleContentTagsTemplate
          ])
              .then((protoViews) {
            tb.createRootViews(protoViews);
            expect(tb.rootEl).toHaveText("(A, BC)");
            async.done();
          });
        }));
        it("should redistribute only direct children", inject([
          AsyncTestCompleter,
          DomTestbed
        ], (async, tb) {
          tb
              .compileAll([
            mainDir,
            new ViewDefinition(
                componentId: "main",
                template: "<multiple-content-tags>" +
                    "<div>B<div class=\"left\">A</div></div>" +
                    "<div>C</div>" +
                    "</multiple-content-tags>",
                directives: [multipleContentTagsComponent]),
            multipleContentTagsTemplate
          ])
              .then((protoViews) {
            tb.createRootViews(protoViews);
            expect(tb.rootEl).toHaveText("(, BAC)");
            async.done();
          });
        }));
        it("should redistribute direct child viewcontainers when the light dom changes",
            inject([AsyncTestCompleter, DomTestbed], (async, tb) {
          tb
              .compileAll([
            mainDir,
            new ViewDefinition(
                componentId: "main",
                template: "<multiple-content-tags>" +
                    "<div><div template=\"manual\" class=\"left\">A</div></div>" +
                    "<div>B</div>" +
                    "</multiple-content-tags>",
                directives: [
              multipleContentTagsComponent,
              manualViewportDirective
            ]),
            multipleContentTagsTemplate
          ])
              .then((protoViews) {
            var views = tb.createRootViews(protoViews);
            var childProtoView =
                protoViews[1].elementBinders[1].nestedProtoView;
            expect(tb.rootEl).toHaveText("(, B)");
            var childView = tb.createViewInContainer(
                views[1].viewRef, 1, 0, childProtoView);
            expect(tb.rootEl).toHaveText("(, AB)");
            tb.destroyViewInContainer(
                views[1].viewRef, 1, 0, childView.viewRef);
            expect(tb.rootEl).toHaveText("(, B)");
            async.done();
          });
        }));
        it("should redistribute when the light dom changes", inject([
          AsyncTestCompleter,
          DomTestbed
        ], (async, tb) {
          tb
              .compileAll([
            mainDir,
            new ViewDefinition(
                componentId: "main",
                template: "<multiple-content-tags>" +
                    "<div template=\"manual\" class=\"left\">A</div>" +
                    "<div>B</div>" +
                    "</multiple-content-tags>",
                directives: [
              multipleContentTagsComponent,
              manualViewportDirective
            ]),
            multipleContentTagsTemplate
          ])
              .then((protoViews) {
            var views = tb.createRootViews(protoViews);
            var childProtoView =
                protoViews[1].elementBinders[1].nestedProtoView;
            expect(tb.rootEl).toHaveText("(, B)");
            var childView = tb.createViewInContainer(
                views[1].viewRef, 1, 0, childProtoView);
            expect(tb.rootEl).toHaveText("(A, B)");
            tb.destroyViewInContainer(
                views[1].viewRef, 1, 0, childView.viewRef);
            expect(tb.rootEl).toHaveText("(, B)");
            async.done();
          });
        }));
        it("should support nested components", inject([
          AsyncTestCompleter,
          DomTestbed
        ], (async, tb) {
          tb
              .compileAll([
            mainDir,
            new ViewDefinition(
                componentId: "main",
                template: "<outer-with-indirect-nested>" +
                    "<div>A</div>" +
                    "<div>B</div>" +
                    "</outer-with-indirect-nested>",
                directives: [outerWithIndirectNestedComponent]),
            outerWithIndirectNestedTemplate,
            simpleTemplate
          ])
              .then((protoViews) {
            tb.createRootViews(protoViews);
            expect(tb.rootEl).toHaveText("OUTER(SIMPLE(AB))");
            async.done();
          });
        }));
        it("should support nesting with content being direct child of a nested component",
            inject([AsyncTestCompleter, DomTestbed], (async, tb) {
          tb
              .compileAll([
            mainDir,
            new ViewDefinition(
                componentId: "main",
                template: "<outer>" +
                    "<div template=\"manual\" class=\"left\">A</div>" +
                    "<div>B</div>" +
                    "<div>C</div>" +
                    "</outer>",
                directives: [outerComponent, manualViewportDirective]),
            outerTemplate,
            innerTemplate,
            innerInnerTemplate
          ])
              .then((protoViews) {
            var views = tb.createRootViews(protoViews);
            var childProtoView =
                protoViews[1].elementBinders[1].nestedProtoView;
            expect(tb.rootEl).toHaveText("OUTER(INNER(INNERINNER(,BC)))");
            tb.createViewInContainer(views[1].viewRef, 1, 0, childProtoView);
            expect(tb.rootEl).toHaveText("OUTER(INNER(INNERINNER(A,BC)))");
            async.done();
          });
        }));
        it("should redistribute when the shadow dom changes", inject([
          AsyncTestCompleter,
          DomTestbed
        ], (async, tb) {
          tb
              .compileAll([
            mainDir,
            new ViewDefinition(
                componentId: "main",
                template: "<conditional-content>" +
                    "<div class=\"left\">A</div>" +
                    "<div>B</div>" +
                    "<div>C</div>" +
                    "</conditional-content>",
                directives: [conditionalContentComponent]),
            conditionalContentTemplate
          ])
              .then((protoViews) {
            var views = tb.createRootViews(protoViews);
            var childProtoView =
                protoViews[2].elementBinders[0].nestedProtoView;
            expect(tb.rootEl).toHaveText("(, ABC)");
            var childView = tb.createViewInContainer(
                views[2].viewRef, 0, 0, childProtoView);
            expect(tb.rootEl).toHaveText("(A, BC)");
            tb.destroyViewInContainer(
                views[2].viewRef, 0, 0, childView.viewRef);
            expect(tb.rootEl).toHaveText("(, ABC)");
            async.done();
          });
        }));
        it("should support tabs with view caching", inject([
          AsyncTestCompleter,
          DomTestbed
        ], (async, tb) {
          tb
              .compileAll([
            mainDir,
            new ViewDefinition(
                componentId: "main",
                template: "(<tab><span>0</span></tab>" +
                    "<tab><span>1</span></tab>" +
                    "<tab><span>2</span></tab>)",
                directives: [tabComponent]),
            tabTemplate
          ])
              .then((protoViews) {
            var views = tb.createRootViews(ListWrapper.slice(protoViews, 0, 2));
            var tabProtoView = protoViews[2];
            var tabChildProtoView =
                tabProtoView.elementBinders[0].nestedProtoView;
            var tab1View =
                tb.createComponentView(views[1].viewRef, 0, tabProtoView);
            var tab2View =
                tb.createComponentView(views[1].viewRef, 1, tabProtoView);
            var tab3View =
                tb.createComponentView(views[1].viewRef, 2, tabProtoView);
            expect(tb.rootEl).toHaveText("()");
            var tabChildView = tb.createViewInContainer(
                tab1View.viewRef, 0, 0, tabChildProtoView);
            expect(tb.rootEl).toHaveText("(TAB(0))");
            tb.renderer.dehydrateView(tabChildView.viewRef);
            tb.renderer.detachViewInContainer(
                elRef(tab1View.viewRef, 0), 0, tabChildView.viewRef);
            tb.renderer.attachViewInContainer(
                elRef(tab2View.viewRef, 0), 0, tabChildView.viewRef);
            tb.renderer.hydrateView(tabChildView.viewRef);
            expect(tb.rootEl).toHaveText("(TAB(1))");
            tb.renderer.dehydrateView(tabChildView.viewRef);
            tb.renderer.detachViewInContainer(
                elRef(tab2View.viewRef, 0), 0, tabChildView.viewRef);
            tb.renderer.attachViewInContainer(
                elRef(tab3View.viewRef, 0), 0, tabChildView.viewRef);
            tb.renderer.hydrateView(tabChildView.viewRef);
            expect(tb.rootEl).toHaveText("(TAB(2))");
            async.done();
          });
        }));
      });
    });
  });
}
var mainDir = DirectiveMetadata.create(
    selector: "main", id: "main", type: DirectiveMetadata.COMPONENT_TYPE);
var simple = DirectiveMetadata.create(
    selector: "simple", id: "simple", type: DirectiveMetadata.COMPONENT_TYPE);
var empty = DirectiveMetadata.create(
    selector: "empty", id: "empty", type: DirectiveMetadata.COMPONENT_TYPE);
var dynamicComponent = DirectiveMetadata.create(
    selector: "dynamic", id: "dynamic", type: DirectiveMetadata.COMPONENT_TYPE);
var multipleContentTagsComponent = DirectiveMetadata.create(
    selector: "multiple-content-tags",
    id: "multiple-content-tags",
    type: DirectiveMetadata.COMPONENT_TYPE);
var manualViewportDirective = DirectiveMetadata.create(
    selector: "[manual]", id: "manual", type: DirectiveMetadata.DIRECTIVE_TYPE);
var outerWithIndirectNestedComponent = DirectiveMetadata.create(
    selector: "outer-with-indirect-nested",
    id: "outer-with-indirect-nested",
    type: DirectiveMetadata.COMPONENT_TYPE);
var outerComponent = DirectiveMetadata.create(
    selector: "outer", id: "outer", type: DirectiveMetadata.COMPONENT_TYPE);
var innerComponent = DirectiveMetadata.create(
    selector: "inner", id: "inner", type: DirectiveMetadata.COMPONENT_TYPE);
var innerInnerComponent = DirectiveMetadata.create(
    selector: "innerinner",
    id: "innerinner",
    type: DirectiveMetadata.COMPONENT_TYPE);
var conditionalContentComponent = DirectiveMetadata.create(
    selector: "conditional-content",
    id: "conditional-content",
    type: DirectiveMetadata.COMPONENT_TYPE);
var autoViewportDirective = DirectiveMetadata.create(
    selector: "[auto]",
    id: "auto",
    properties: ["auto"],
    type: DirectiveMetadata.DIRECTIVE_TYPE);
var tabComponent = DirectiveMetadata.create(
    selector: "tab", id: "tab", type: DirectiveMetadata.COMPONENT_TYPE);
var simpleTemplate = new ViewDefinition(
    componentId: "simple",
    template: "SIMPLE(<content></content>)",
    directives: []);
var emptyTemplate =
    new ViewDefinition(componentId: "empty", template: "", directives: []);
var multipleContentTagsTemplate = new ViewDefinition(
    componentId: "multiple-content-tags",
    template: "(<content select=\".left\"></content>, <content></content>)",
    directives: []);
var outerWithIndirectNestedTemplate = new ViewDefinition(
    componentId: "outer-with-indirect-nested",
    template: "OUTER(<simple><div><content></content></div></simple>)",
    directives: [simple]);
var outerTemplate = new ViewDefinition(
    componentId: "outer",
    template: "OUTER(<inner><content></content></inner>)",
    directives: [innerComponent]);
var innerTemplate = new ViewDefinition(
    componentId: "inner",
    template: "INNER(<innerinner><content></content></innerinner>)",
    directives: [innerInnerComponent]);
var innerInnerTemplate = new ViewDefinition(
    componentId: "innerinner",
    template: "INNERINNER(<content select=\".left\"></content>,<content></content>)",
    directives: []);
var conditionalContentTemplate = new ViewDefinition(
    componentId: "conditional-content",
    template: "<div>(<div *auto=\"cond\"><content select=\".left\"></content></div>, <content></content>)</div>",
    directives: [autoViewportDirective]);
var tabTemplate = new ViewDefinition(
    componentId: "tab",
    template: "<div><div *auto=\"cond\">TAB(<content></content>)</div></div>",
    directives: [autoViewportDirective]);
