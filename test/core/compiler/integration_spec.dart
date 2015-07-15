library angular2.test.core.compiler.integration_spec;

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
        IS_DARTIUM,
        beforeEachBindings,
        it,
        xit,
        containsRegexp,
        stringifyElement,
        TestComponentBuilder;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/facade/lang.dart"
    show
        Type,
        isPresent,
        BaseException,
        assertionsEnabled,
        isJsObject,
        global,
        stringify;
import "package:angular2/src/facade/async.dart"
    show PromiseWrapper, EventEmitter, ObservableWrapper;
import "package:angular2/di.dart"
    show
        Injector,
        bind,
        Injectable,
        Binding,
        OpaqueToken,
        Inject,
        Parent,
        Ancestor,
        Unbounded,
        UnboundedMetadata;
import "package:angular2/change_detection.dart"
    show
        PipeFactory,
        Pipes,
        defaultPipes,
        ChangeDetection,
        DynamicChangeDetection,
        Pipe,
        ChangeDetectorRef,
        ON_PUSH;
import "package:angular2/annotations.dart"
    show Directive, Component, View, Attribute, Query;
import "package:angular2/src/core/annotations_impl/view.dart" as viewAnn;
import "package:angular2/src/core/compiler/query_list.dart" show QueryList;
import "package:angular2/src/directives/ng_if.dart" show NgIf;
import "package:angular2/src/directives/ng_for.dart" show NgFor;
import "package:angular2/src/core/compiler/view_container_ref.dart"
    show ViewContainerRef;
import "package:angular2/src/core/compiler/view_ref.dart"
    show ProtoViewRef, ViewRef;
import "package:angular2/src/core/compiler/compiler.dart" show Compiler;
import "package:angular2/src/core/compiler/element_ref.dart" show ElementRef;
import "package:angular2/src/render/dom/dom_renderer.dart" show DomRenderer;
import "package:angular2/src/core/compiler/view_manager.dart"
    show AppViewManager;

const ANCHOR_ELEMENT = const OpaqueToken("AnchorElement");
main() {
  describe("integration tests", () {
    beforeEachBindings(() => [bind(ANCHOR_ELEMENT).toValue(el("<div></div>"))]);
    describe("react to record changes", () {
      it("should consume text node changes", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(
                MyComp, new viewAnn.View(template: "<div>{{ctxProp}}</div>"))
            .createAsync(MyComp)
            .then((rootTC) {
          rootTC.componentInstance.ctxProp = "Hello World!";
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("Hello World!");
          async.done();
        });
      }));
      it("should consume element binding changes", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp,
                new viewAnn.View(template: "<div [id]=\"ctxProp\"></div>"))
            .createAsync(MyComp)
            .then((rootTC) {
          rootTC.componentInstance.ctxProp = "Hello World!";
          rootTC.detectChanges();
          expect(rootTC.componentViewChildren[0].nativeElement.id)
              .toEqual("Hello World!");
          async.done();
        });
      }));
      it("should consume binding to aria-* attributes", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<div [attr.aria-label]=\"ctxProp\"></div>"))
            .createAsync(MyComp)
            .then((rootTC) {
          rootTC.componentInstance.ctxProp = "Initial aria label";
          rootTC.detectChanges();
          expect(DOM.getAttribute(
                  rootTC.componentViewChildren[0].nativeElement, "aria-label"))
              .toEqual("Initial aria label");
          rootTC.componentInstance.ctxProp = "Changed aria label";
          rootTC.detectChanges();
          expect(DOM.getAttribute(
                  rootTC.componentViewChildren[0].nativeElement, "aria-label"))
              .toEqual("Changed aria label");
          async.done();
        });
      }));
      it("should consume binding to property names where attr name and property name do not match",
          inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<div [tabindex]=\"ctxNumProp\"></div>"))
            .createAsync(MyComp)
            .then((rootTC) {
          rootTC.detectChanges();
          expect(rootTC.componentViewChildren[0].nativeElement.tabIndex)
              .toEqual(0);
          rootTC.componentInstance.ctxNumProp = 5;
          rootTC.detectChanges();
          expect(rootTC.componentViewChildren[0].nativeElement.tabIndex)
              .toEqual(5);
          async.done();
        });
      }));
      it("should consume binding to camel-cased properties using dash-cased syntax in templates",
          inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<input [read-only]=\"ctxBoolProp\">"))
            .createAsync(MyComp)
            .then((rootTC) {
          rootTC.detectChanges();
          expect(rootTC.componentViewChildren[0].nativeElement.readOnly)
              .toBeFalsy();
          rootTC.componentInstance.ctxBoolProp = true;
          rootTC.detectChanges();
          expect(rootTC.componentViewChildren[0].nativeElement.readOnly)
              .toBeTruthy();
          async.done();
        });
      }));
      it("should consume binding to inner-html", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<div inner-html=\"{{ctxProp}}\"></div>"))
            .createAsync(MyComp)
            .then((rootTC) {
          rootTC.componentInstance.ctxProp = "Some <span>HTML</span>";
          rootTC.detectChanges();
          expect(DOM
                  .getInnerHTML(rootTC.componentViewChildren[0].nativeElement))
              .toEqual("Some <span>HTML</span>");
          rootTC.componentInstance.ctxProp = "Some other <div>HTML</div>";
          rootTC.detectChanges();
          expect(DOM
                  .getInnerHTML(rootTC.componentViewChildren[0].nativeElement))
              .toEqual("Some other <div>HTML</div>");
          async.done();
        });
      }));
      it("should consume directive watch expression change.", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var tpl = "<div>" +
            "<div my-dir [elprop]=\"ctxProp\"></div>" +
            "<div my-dir elprop=\"Hi there!\"></div>" +
            "<div my-dir elprop=\"Hi {{'there!'}}\"></div>" +
            "<div my-dir elprop=\"One more {{ctxProp}}\"></div>" +
            "</div>";
        tcb
            .overrideView(
                MyComp, new viewAnn.View(template: tpl, directives: [MyDir]))
            .createAsync(MyComp)
            .then((rootTC) {
          rootTC.componentInstance.ctxProp = "Hello World!";
          rootTC.detectChanges();
          expect(rootTC.componentViewChildren[0].inject(MyDir).dirProp)
              .toEqual("Hello World!");
          expect(rootTC.componentViewChildren[1].inject(MyDir).dirProp)
              .toEqual("Hi there!");
          expect(rootTC.componentViewChildren[2].inject(MyDir).dirProp)
              .toEqual("Hi there!");
          expect(rootTC.componentViewChildren[3].inject(MyDir).dirProp)
              .toEqual("One more Hello World!");
          async.done();
        });
      }));
      describe("pipes", () {
        it("should support pipes in bindings", inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          tcb
              .overrideView(MyCompWithPipes, new viewAnn.View(
                  template: "<div my-dir #dir=\"mydir\" [elprop]=\"ctxProp | double\"></div>",
                  directives: [MyDir]))
              .createAsync(MyCompWithPipes)
              .then((rootTC) {
            rootTC.componentInstance.ctxProp = "a";
            rootTC.detectChanges();
            var dir = rootTC.componentViewChildren[0].getLocal("dir");
            expect(dir.dirProp).toEqual("aa");
            async.done();
          });
        }));
      });
      it("should support nested components.", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<child-cmp></child-cmp>", directives: [ChildComp]))
            .createAsync(MyComp)
            .then((rootTC) {
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("hello");
          async.done();
        });
      }));
      // GH issue 328 - https://github.com/angular/angular/issues/328
      it("should support different directive types on a single node", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<child-cmp my-dir [elprop]=\"ctxProp\"></child-cmp>",
                directives: [MyDir, ChildComp]))
            .createAsync(MyComp)
            .then((rootTC) {
          rootTC.componentInstance.ctxProp = "Hello World!";
          rootTC.detectChanges();
          var tc = rootTC.componentViewChildren[0];
          expect(tc.inject(MyDir).dirProp).toEqual("Hello World!");
          expect(tc.inject(ChildComp).dirProp).toEqual(null);
          async.done();
        });
      }));
      it("should support directives where a binding attribute is not given",
          inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<p my-dir></p>", directives: [MyDir]))
            .createAsync(MyComp)
            .then((rootTC) {
          async.done();
        });
      }));
      it("should execute a given directive once, even if specified multiple times",
          inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<p no-duplicate></p>",
                directives: [
          DuplicateDir,
          DuplicateDir,
          [
            DuplicateDir,
            [DuplicateDir, bind(DuplicateDir).toClass(DuplicateDir)]
          ]
        ]))
            .createAsync(MyComp)
            .then((rootTC) {
          expect(rootTC.nativeElement).toHaveText("noduplicate");
          async.done();
        });
      }));
      it("should use the last directive binding per directive", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<p no-duplicate></p>",
                directives: [
          bind(DuplicateDir).toClass(DuplicateDir),
          bind(DuplicateDir).toClass(OtherDuplicateDir)
        ]))
            .createAsync(MyComp)
            .then((rootTC) {
          expect(rootTC.nativeElement).toHaveText("othernoduplicate");
          async.done();
        });
      }));
      it("should support directives where a selector matches property binding",
          inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<p [id]=\"ctxProp\"></p>", directives: [IdDir]))
            .createAsync(MyComp)
            .then((rootTC) {
          var tc = rootTC.componentViewChildren[0];
          var idDir = tc.inject(IdDir);
          rootTC.componentInstance.ctxProp = "some_id";
          rootTC.detectChanges();
          expect(idDir.id).toEqual("some_id");
          rootTC.componentInstance.ctxProp = "other_id";
          rootTC.detectChanges();
          expect(idDir.id).toEqual("other_id");
          async.done();
        });
      }));
      it("should allow specifying directives as bindings", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<child-cmp></child-cmp>",
                directives: [bind(ChildComp).toClass(ChildComp)]))
            .createAsync(MyComp)
            .then((rootTC) {
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("hello");
          async.done();
        });
      }));
      it("should read directives metadata from their binding token", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<div public-api><div needs-public-api></div></div>",
                directives: [
          bind(PublicApi).toClass(PrivateImpl),
          NeedsPublicApi
        ]))
            .createAsync(MyComp)
            .then((rootTC) {
          async.done();
        });
      }));
      it("should support template directives via `<template>` elements.",
          inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<div><template some-viewport var-greeting=\"some-tmpl\"><copy-me>{{greeting}}</copy-me></template></div>",
                directives: [SomeViewport]))
            .createAsync(MyComp)
            .then((rootTC) {
          rootTC.detectChanges();
          var childNodesOfWrapper = rootTC.componentViewChildren;
          // 1 template + 2 copies.
          expect(childNodesOfWrapper.length).toBe(3);
          expect(childNodesOfWrapper[1].nativeElement).toHaveText("hello");
          expect(childNodesOfWrapper[2].nativeElement).toHaveText("again");
          async.done();
        });
      }));
      it("should support template directives via `template` attribute.", inject(
          [
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<div><copy-me template=\"some-viewport: var greeting=some-tmpl\">{{greeting}}</copy-me></div>",
                directives: [SomeViewport]))
            .createAsync(MyComp)
            .then((rootTC) {
          rootTC.detectChanges();
          var childNodesOfWrapper = rootTC.componentViewChildren;
          // 1 template + 2 copies.
          expect(childNodesOfWrapper.length).toBe(3);
          expect(childNodesOfWrapper[1].nativeElement).toHaveText("hello");
          expect(childNodesOfWrapper[2].nativeElement).toHaveText("again");
          async.done();
        });
      }));
      it("should allow to transplant embedded ProtoViews into other ViewContainers",
          inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<some-directive><toolbar><template toolbarpart var-toolbar-prop=\"toolbarProp\">{{ctxProp}},{{toolbarProp}},<cmp-with-parent></cmp-with-parent></template></toolbar></some-directive>",
                directives: [
          SomeDirective,
          CompWithParent,
          ToolbarComponent,
          ToolbarPart
        ]))
            .createAsync(MyComp)
            .then((rootTC) {
          rootTC.componentInstance.ctxProp = "From myComp";
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText(
              "TOOLBAR(From myComp,From toolbar,Component with an injected parent)");
          async.done();
        });
      }));
      describe("variable bindings", () {
        it("should assign a component to a var-", inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          tcb
              .overrideView(MyComp, new viewAnn.View(
                  template: "<p><child-cmp var-alice></child-cmp></p>",
                  directives: [ChildComp]))
              .createAsync(MyComp)
              .then((rootTC) {
            expect(rootTC.componentViewChildren[0].getLocal("alice"))
                .toBeAnInstanceOf(ChildComp);
            async.done();
          });
        }));
        it("should assign a directive to a var-", inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          tcb
              .overrideView(MyComp, new viewAnn.View(
                  template: "<p><div export-dir #localdir=\"dir\"></div></p>",
                  directives: [ExportDir]))
              .createAsync(MyComp)
              .then((rootTC) {
            expect(rootTC.componentViewChildren[0].getLocal("localdir"))
                .toBeAnInstanceOf(ExportDir);
            async.done();
          });
        }));
        it("should make the assigned component accessible in property bindings",
            inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          tcb
              .overrideView(MyComp, new viewAnn.View(
                  template: "<p><child-cmp var-alice></child-cmp>{{alice.ctxProp}}</p>",
                  directives: [ChildComp]))
              .createAsync(MyComp)
              .then((rootTC) {
            rootTC.detectChanges();
            expect(rootTC.nativeElement).toHaveText("hellohello");
            // component, the second one is

            // the text binding
            async.done();
          });
        }));
        it("should assign two component instances each with a var-", inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          tcb
              .overrideView(MyComp, new viewAnn.View(
                  template: "<p><child-cmp var-alice></child-cmp><child-cmp var-bob></p>",
                  directives: [ChildComp]))
              .createAsync(MyComp)
              .then((rootTC) {
            expect(rootTC.componentViewChildren[0].getLocal("alice"))
                .toBeAnInstanceOf(ChildComp);
            expect(rootTC.componentViewChildren[0].getLocal("bob"))
                .toBeAnInstanceOf(ChildComp);
            expect(rootTC.componentViewChildren[0].getLocal("alice")).not
                .toBe(rootTC.componentViewChildren[0].getLocal("bob"));
            async.done();
          });
        }));
        it("should assign the component instance to a var- with shorthand syntax",
            inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          tcb
              .overrideView(MyComp, new viewAnn.View(
                  template: "<child-cmp #alice></child-cmp>",
                  directives: [ChildComp]))
              .createAsync(MyComp)
              .then((rootTC) {
            expect(rootTC.componentViewChildren[0].getLocal("alice"))
                .toBeAnInstanceOf(ChildComp);
            async.done();
          });
        }));
        it("should assign the element instance to a user-defined variable",
            inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          tcb
              .overrideView(MyComp, new viewAnn.View(
                  template: "<p><div var-alice><i>Hello</i></div></p>"))
              .createAsync(MyComp)
              .then((rootTC) {
            var value = rootTC.componentViewChildren[0].getLocal("alice");
            expect(value).not.toBe(null);
            expect(value.tagName.toLowerCase()).toEqual("div");
            async.done();
          });
        }));
        it("should change dash-case to camel-case", inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          tcb
              .overrideView(MyComp, new viewAnn.View(
                  template: "<p><child-cmp var-super-alice></child-cmp></p>",
                  directives: [ChildComp]))
              .createAsync(MyComp)
              .then((rootTC) {
            expect(rootTC.componentViewChildren[0].getLocal("superAlice"))
                .toBeAnInstanceOf(ChildComp);
            async.done();
          });
        }));
        it("should allow to use variables in a for loop", inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          tcb
              .overrideView(MyComp, new viewAnn.View(
                  template: "<div><div *ng-for=\"var i of [1]\"><child-cmp-no-template #cmp></child-cmp-no-template>{{i}}-{{cmp.ctxProp}}</div></div>",
                  directives: [ChildCompNoTemplate, NgFor]))
              .createAsync(MyComp)
              .then((rootTC) {
            rootTC.detectChanges();
            // Get the element at index 1, since index 0 is the <template>.
            expect(rootTC.componentViewChildren[1].nativeElement)
                .toHaveText("1-hello");
            async.done();
          });
        }));
      });
      describe("ON_PUSH components", () {
        it("should use ChangeDetectorRef to manually request a check", inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          tcb
              .overrideView(MyComp, new viewAnn.View(
                  template: "<push-cmp-with-ref #cmp></push-cmp-with-ref>",
                  directives: [[[PushCmpWithRef]]]))
              .createAsync(MyComp)
              .then((rootTC) {
            var cmp = rootTC.componentViewChildren[0].getLocal("cmp");
            rootTC.detectChanges();
            expect(cmp.numberOfChecks).toEqual(1);
            rootTC.detectChanges();
            expect(cmp.numberOfChecks).toEqual(1);
            cmp.propagate();
            rootTC.detectChanges();
            expect(cmp.numberOfChecks).toEqual(2);
            async.done();
          });
        }));
        it("should be checked when its bindings got updated", inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          tcb
              .overrideView(MyComp, new viewAnn.View(
                  template: "<push-cmp [prop]=\"ctxProp\" #cmp></push-cmp>",
                  directives: [[[PushCmp]]]))
              .createAsync(MyComp)
              .then((rootTC) {
            var cmp = rootTC.componentViewChildren[0].getLocal("cmp");
            rootTC.componentInstance.ctxProp = "one";
            rootTC.detectChanges();
            expect(cmp.numberOfChecks).toEqual(1);
            rootTC.componentInstance.ctxProp = "two";
            rootTC.detectChanges();
            expect(cmp.numberOfChecks).toEqual(2);
            async.done();
          });
        }));
        it("should not affect updating properties on the component", inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          tcb
              .overrideView(MyComp, new viewAnn.View(
                  template: "<push-cmp-with-ref [prop]=\"ctxProp\" #cmp></push-cmp-with-ref>",
                  directives: [[[PushCmpWithRef]]]))
              .createAsync(MyComp)
              .then((rootTC) {
            var cmp = rootTC.componentViewChildren[0].getLocal("cmp");
            rootTC.componentInstance.ctxProp = "one";
            rootTC.detectChanges();
            expect(cmp.prop).toEqual("one");
            rootTC.componentInstance.ctxProp = "two";
            rootTC.detectChanges();
            expect(cmp.prop).toEqual("two");
            async.done();
          });
        }));
      });
      it("should create a component that injects a @Parent", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<some-directive><cmp-with-parent #child></cmp-with-parent></some-directive>",
                directives: [SomeDirective, CompWithParent]))
            .createAsync(MyComp)
            .then((rootTC) {
          var childComponent =
              rootTC.componentViewChildren[0].getLocal("child");
          expect(childComponent.myParent).toBeAnInstanceOf(SomeDirective);
          async.done();
        });
      }));
      it("should create a component that injects an @Ancestor", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb.overrideView(MyComp, new viewAnn.View(template: '''
            <some-directive>
              <p>
                <cmp-with-ancestor #child></cmp-with-ancestor>
              </p>
            </some-directive>''',
                directives: [SomeDirective, CompWithAncestor]))
            .createAsync(MyComp)
            .then((rootTC) {
          var childComponent =
              rootTC.componentViewChildren[0].getLocal("child");
          expect(childComponent.myAncestor).toBeAnInstanceOf(SomeDirective);
          async.done();
        });
      }));
      it("should create a component that injects an @Ancestor through viewcontainer directive",
          inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb.overrideView(MyComp, new viewAnn.View(template: '''
            <some-directive>
              <p *ng-if="true">
                <cmp-with-ancestor #child></cmp-with-ancestor>
              </p>
            </some-directive>''',
                directives: [SomeDirective, CompWithAncestor, NgIf]))
            .createAsync(MyComp)
            .then((rootTC) {
          rootTC.detectChanges();
          var tc = rootTC.componentViewChildren[0].children[1];
          var childComponent = tc.getLocal("child");
          expect(childComponent.myAncestor).toBeAnInstanceOf(SomeDirective);
          async.done();
        });
      }));
      it("should support events via EventEmitter", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<div emitter listener></div>",
                directives: [DirectiveEmitingEvent, DirectiveListeningEvent]))
            .createAsync(MyComp)
            .then((rootTC) {
          var tc = rootTC.componentViewChildren[0];
          var emitter = tc.inject(DirectiveEmitingEvent);
          var listener = tc.inject(DirectiveListeningEvent);
          expect(listener.msg).toEqual("");
          ObservableWrapper.subscribe(emitter.event, (_) {
            expect(listener.msg).toEqual("fired !");
            async.done();
          });
          emitter.fireEvent("fired !");
        });
      }));
      it("should support [()] syntax", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<div [(control)]=\"ctxProp\" two-way></div>",
                directives: [DirectiveWithTwoWayBinding]))
            .createAsync(MyComp)
            .then((rootTC) {
          var tc = rootTC.componentViewChildren[0];
          var dir = tc.inject(DirectiveWithTwoWayBinding);
          rootTC.componentInstance.ctxProp = "one";
          rootTC.detectChanges();
          expect(dir.value).toEqual("one");
          ObservableWrapper.subscribe(dir.control, (_) {
            expect(rootTC.componentInstance.ctxProp).toEqual("two");
            async.done();
          });
          dir.triggerChange("two");
        });
      }));
      if (DOM.supportsDOMEvents()) {
        it("should support invoking methods on the host element via hostActions",
            inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          tcb
              .overrideView(MyComp, new viewAnn.View(
                  template: "<div update-host-actions></div>",
                  directives: [DirectiveUpdatingHostActions]))
              .createAsync(MyComp)
              .then((rootTC) {
            var tc = rootTC.componentViewChildren[0];
            var nativeElement = tc.nativeElement;
            var updateHost = tc.inject(DirectiveUpdatingHostActions);
            ObservableWrapper.subscribe(updateHost.setAttr, (_) {
              expect(DOM.hasAttribute(nativeElement, "update-host-actions"))
                  .toBe(true);
              async.done();
            });
            updateHost.triggerSetAttr("value");
          });
        }));
      }
      it("should support render events", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<div listener></div>",
                directives: [DirectiveListeningDomEvent]))
            .createAsync(MyComp)
            .then((rootTC) {
          var tc = rootTC.componentViewChildren[0];
          var listener = tc.inject(DirectiveListeningDomEvent);
          dispatchEvent(tc.nativeElement, "domEvent");
          expect(listener.eventType).toEqual("domEvent");
          async.done();
        });
      }));
      it("should support render global events", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<div listener></div>",
                directives: [DirectiveListeningDomEvent]))
            .createAsync(MyComp)
            .then((rootTC) {
          var tc = rootTC.componentViewChildren[0];
          var listener = tc.inject(DirectiveListeningDomEvent);
          dispatchEvent(DOM.getGlobalEventTarget("window"), "domEvent");
          expect(listener.eventType).toEqual("window_domEvent");
          listener = tc.inject(DirectiveListeningDomEvent);
          dispatchEvent(DOM.getGlobalEventTarget("document"), "domEvent");
          expect(listener.eventType).toEqual("document_domEvent");
          rootTC.destroy();
          listener = tc.inject(DirectiveListeningDomEvent);
          dispatchEvent(DOM.getGlobalEventTarget("body"), "domEvent");
          expect(listener.eventType).toEqual("");
          async.done();
        });
      }));
      it("should support updating host element via hostAttributes", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<div update-host-attributes></div>",
                directives: [DirectiveUpdatingHostAttributes]))
            .createAsync(MyComp)
            .then((rootTC) {
          rootTC.detectChanges();
          expect(DOM.getAttribute(
                  rootTC.componentViewChildren[0].nativeElement, "role"))
              .toEqual("button");
          async.done();
        });
      }));
      it("should support updating host element via hostProperties", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<div update-host-properties></div>",
                directives: [DirectiveUpdatingHostProperties]))
            .createAsync(MyComp)
            .then((rootTC) {
          var tc = rootTC.componentViewChildren[0];
          var updateHost = tc.inject(DirectiveUpdatingHostProperties);
          updateHost.id = "newId";
          rootTC.detectChanges();
          expect(tc.nativeElement.id).toEqual("newId");
          async.done();
        });
      }));
      if (DOM.supportsDOMEvents()) {
        it("should support preventing default on render events", inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          tcb
              .overrideView(MyComp, new viewAnn.View(
                  template: "<input type=\"checkbox\" listenerprevent></input><input type=\"checkbox\" listenernoprevent></input>",
                  directives: [
            DirectiveListeningDomEventPrevent,
            DirectiveListeningDomEventNoPrevent
          ]))
              .createAsync(MyComp)
              .then((rootTC) {
            expect(DOM
                    .getChecked(rootTC.componentViewChildren[0].nativeElement))
                .toBeFalsy();
            expect(DOM
                    .getChecked(rootTC.componentViewChildren[1].nativeElement))
                .toBeFalsy();
            DOM.dispatchEvent(rootTC.componentViewChildren[0].nativeElement,
                DOM.createMouseEvent("click"));
            DOM.dispatchEvent(rootTC.componentViewChildren[1].nativeElement,
                DOM.createMouseEvent("click"));
            expect(DOM
                    .getChecked(rootTC.componentViewChildren[0].nativeElement))
                .toBeFalsy();
            expect(DOM
                    .getChecked(rootTC.componentViewChildren[1].nativeElement))
                .toBeTruthy();
            async.done();
          });
        }));
      }
      it("should support render global events from multiple directives", inject(
          [
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<div *ng-if=\"ctxBoolProp\" listener listenerother></div>",
                directives: [
          NgIf,
          DirectiveListeningDomEvent,
          DirectiveListeningDomEventOther
        ]))
            .createAsync(MyComp)
            .then((rootTC) {
          globalCounter = 0;
          rootTC.componentInstance.ctxBoolProp = true;
          rootTC.detectChanges();
          var tc = rootTC.componentViewChildren[1];
          var listener = tc.inject(DirectiveListeningDomEvent);
          var listenerother = tc.inject(DirectiveListeningDomEventOther);
          dispatchEvent(DOM.getGlobalEventTarget("window"), "domEvent");
          expect(listener.eventType).toEqual("window_domEvent");
          expect(listenerother.eventType).toEqual("other_domEvent");
          expect(globalCounter).toEqual(1);
          rootTC.componentInstance.ctxBoolProp = false;
          rootTC.detectChanges();
          dispatchEvent(DOM.getGlobalEventTarget("window"), "domEvent");
          expect(globalCounter).toEqual(1);
          rootTC.componentInstance.ctxBoolProp = true;
          rootTC.detectChanges();
          dispatchEvent(DOM.getGlobalEventTarget("window"), "domEvent");
          expect(globalCounter).toEqual(2);
          async.done();
        });
      }));
      describe("dynamic ViewContainers", () {
        it("should allow to create a ViewContainerRef at any bound location",
            inject([
          TestComponentBuilder,
          AsyncTestCompleter,
          Compiler
        ], (TestComponentBuilder tcb, async, compiler) {
          tcb
              .overrideView(MyComp, new viewAnn.View(
                  template: "<div><dynamic-vp #dynamic></dynamic-vp></div>",
                  directives: [DynamicViewport]))
              .createAsync(MyComp)
              .then((rootTC) {
            var tc = rootTC.componentViewChildren[0];
            var dynamicVp = tc.inject(DynamicViewport);
            dynamicVp.done.then((_) {
              rootTC.detectChanges();
              expect(rootTC.componentViewChildren[1].nativeElement)
                  .toHaveText("dynamic greet");
              async.done();
            });
          });
        }));
      });
      it("should support static attributes", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<input static type=\"text\" title>",
                directives: [NeedsAttribute]))
            .createAsync(MyComp)
            .then((rootTC) {
          var tc = rootTC.componentViewChildren[0];
          var needsAttribute = tc.inject(NeedsAttribute);
          expect(needsAttribute.typeAttribute).toEqual("text");
          expect(needsAttribute.titleAttribute).toEqual("");
          expect(needsAttribute.fooAttribute).toEqual(null);
          async.done();
        });
      }));
    });
    describe("dependency injection", () {
      it("should support hostInjector", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb.overrideView(MyComp, new viewAnn.View(template: '''
            <directive-providing-injectable >
              <directive-consuming-injectable #consuming>
              </directive-consuming-injectable>
            </directive-providing-injectable>
          ''',
            directives: [
          DirectiveProvidingInjectable,
          DirectiveConsumingInjectable
        ]))
            .createAsync(MyComp)
            .then((rootTC) {
          var comp = rootTC.componentViewChildren[0].getLocal("consuming");
          expect(comp.injectable).toBeAnInstanceOf(InjectableService);
          async.done();
        });
      }));
      it("should support viewInjector", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(DirectiveProvidingInjectableInView, new viewAnn.View(
                template: '''
              <directive-consuming-injectable #consuming>
              </directive-consuming-injectable>
          ''', directives: [DirectiveConsumingInjectable]))
            .createAsync(DirectiveProvidingInjectableInView)
            .then((rootTC) {
          var comp = rootTC.componentViewChildren[0].getLocal("consuming");
          expect(comp.injectable).toBeAnInstanceOf(InjectableService);
          async.done();
        });
      }));
      it("should support unbounded lookup", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb.overrideView(MyComp, new viewAnn.View(template: '''
            <directive-providing-injectable>
              <directive-containing-directive-consuming-an-injectable #dir>
              </directive-containing-directive-consuming-an-injectable>
            </directive-providing-injectable>
          ''',
            directives: [
          DirectiveProvidingInjectable,
          DirectiveContainingDirectiveConsumingAnInjectable
        ]))
            .overrideView(DirectiveContainingDirectiveConsumingAnInjectable,
                new viewAnn.View(template: '''
            <directive-consuming-injectable-unbounded></directive-consuming-injectable-unbounded>
          ''', directives: [DirectiveConsumingInjectableUnbounded]))
            .createAsync(MyComp)
            .then((rootTC) {
          var comp = rootTC.componentViewChildren[0].getLocal("dir");
          expect(comp.directive.injectable).toBeAnInstanceOf(InjectableService);
          async.done();
        });
      }));
      it("should support the event-bus scenario", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb.overrideView(MyComp, new viewAnn.View(template: '''
            <grand-parent-providing-event-bus>
              <parent-providing-event-bus>
                <child-consuming-event-bus>
                </child-consuming-event-bus>
              </parent-providing-event-bus>
            </grand-parent-providing-event-bus>
          ''',
            directives: [
          GrandParentProvidingEventBus,
          ParentProvidingEventBus,
          ChildConsumingEventBus
        ]))
            .createAsync(MyComp)
            .then((rootTC) {
          var gpComp = rootTC.componentViewChildren[0];
          var parentComp = gpComp.children[0];
          var childComp = parentComp.children[0];
          var grandParent = gpComp.inject(GrandParentProvidingEventBus);
          var parent = parentComp.inject(ParentProvidingEventBus);
          var child = childComp.inject(ChildConsumingEventBus);
          expect(grandParent.bus.name).toEqual("grandparent");
          expect(parent.bus.name).toEqual("parent");
          expect(parent.grandParentBus).toBe(grandParent.bus);
          expect(child.bus).toBe(parent.bus);
          async.done();
        });
      }));
      it("should create viewInjector injectables lazily", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb.overrideView(MyComp, new viewAnn.View(template: '''
              <component-providing-logging-injectable #providing>
                <directive-consuming-injectable *ng-if="ctxBoolProp">
                </directive-consuming-injectable>
              </component-providing-logging-injectable>
          ''',
            directives: [
          DirectiveConsumingInjectable,
          ComponentProvidingLoggingInjectable,
          NgIf
        ]))
            .createAsync(MyComp)
            .then((rootTC) {
          var providing = rootTC.componentViewChildren[0].getLocal("providing");
          expect(providing.created).toBe(false);
          rootTC.componentInstance.ctxBoolProp = true;
          rootTC.detectChanges();
          expect(providing.created).toBe(true);
          async.done();
        });
      }));
    });
    describe("error handling", () {
      it("should report a meaningful error when a directive is missing annotation",
          inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb = tcb.overrideView(MyComp,
            new viewAnn.View(directives: [SomeDirectiveMissingAnnotation]));
        PromiseWrapper.catchError(tcb.createAsync(MyComp), (e) {
          expect(e.message).toEqual(
              '''No Directive annotation found on ${ stringify ( SomeDirectiveMissingAnnotation )}''');
          async.done();
          return null;
        });
      }));
      it("should report a meaningful error when a component is missing view annotation",
          inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        PromiseWrapper.catchError(tcb.createAsync(ComponentWithoutView), (e) {
          expect(e.message).toEqual(
              '''No View annotation found on component ${ stringify ( ComponentWithoutView )}''');
          async.done();
          return null;
        });
      }));
      it("should report a meaningful error when a directive is null", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb = tcb.overrideView(MyComp, new viewAnn.View(directives: [[null]]));
        PromiseWrapper.catchError(tcb.createAsync(MyComp), (e) {
          expect(e.message).toEqual(
              '''Unexpected directive value \'null\' on the View of component \'${ stringify ( MyComp )}\'''');
          async.done();
          return null;
        });
      }));
      if (!IS_DARTIUM) {
        it("should report a meaningful error when a directive is undefined",
            inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          var undefinedValue;
          tcb = tcb.overrideView(
              MyComp, new viewAnn.View(directives: [undefinedValue]));
          PromiseWrapper.catchError(tcb.createAsync(MyComp), (e) {
            expect(e.message).toEqual(
                '''Unexpected directive value \'undefined\' on the View of component \'${ stringify ( MyComp )}\'''');
            async.done();
            return null;
          });
        }));
      }
      it("should specify a location of an error that happened during change detection (text)",
          inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(template: "{{a.b}}"))
            .createAsync(MyComp)
            .then((rootTC) {
          expect(() => rootTC.detectChanges()).toThrowError(
              containsRegexp('''{{a.b}} in ${ stringify ( MyComp )}'''));
          async.done();
        });
      }));
      it("should specify a location of an error that happened during change detection (element property)",
          inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp,
                new viewAnn.View(template: "<div [title]=\"a.b\"></div>"))
            .createAsync(MyComp)
            .then((rootTC) {
          expect(() => rootTC.detectChanges()).toThrowError(
              containsRegexp('''a.b in ${ stringify ( MyComp )}'''));
          async.done();
        });
      }));
      it("should specify a location of an error that happened during change detection (directive property)",
          inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        tcb
            .overrideView(MyComp, new viewAnn.View(
                template: "<child-cmp [title]=\"a.b\"></child-cmp>",
                directives: [ChildComp]))
            .createAsync(MyComp)
            .then((rootTC) {
          expect(() => rootTC.detectChanges()).toThrowError(
              containsRegexp('''a.b in ${ stringify ( MyComp )}'''));
          async.done();
        });
      }));
    });
    it("should support imperative views", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      tcb
          .overrideView(MyComp, new viewAnn.View(
              template: "<simple-imp-cmp></simple-imp-cmp>",
              directives: [SimpleImperativeViewComponent]))
          .createAsync(MyComp)
          .then((rootTC) {
        expect(rootTC.nativeElement).toHaveText("hello imp view");
        async.done();
      });
    }));
    it("should support moving embedded views around", inject([
      TestComponentBuilder,
      AsyncTestCompleter,
      ANCHOR_ELEMENT
    ], (tcb, async, anchorElement) {
      tcb
          .overrideView(MyComp, new viewAnn.View(
              template: "<div><div *some-impvp=\"ctxBoolProp\">hello</div></div>",
              directives: [SomeImperativeViewport]))
          .createAsync(MyComp)
          .then((rootTC) {
        rootTC.detectChanges();
        expect(anchorElement).toHaveText("");
        rootTC.componentInstance.ctxBoolProp = true;
        rootTC.detectChanges();
        expect(anchorElement).toHaveText("hello");
        rootTC.componentInstance.ctxBoolProp = false;
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("");
        async.done();
      });
    }));
    if (!IS_DARTIUM) {
      describe("Missing property bindings", () {
        it("should throw on bindings to unknown properties", inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          tcb = tcb.overrideView(MyComp, new viewAnn.View(
              template: "<div unknown=\"{{ctxProp}}\"></div>"));
          PromiseWrapper.catchError(tcb.createAsync(MyComp), (e) {
            expect(e.message).toEqual(
                '''Can\'t bind to \'unknown\' since it isn\'t a know property of the \'div\' element and there are no matching directives with a corresponding property''');
            async.done();
            return null;
          });
        }));
        it("should not throw for property binding to a non-existing property when there is a matching directive property",
            inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          tcb
              .overrideView(MyComp, new viewAnn.View(
                  template: "<div my-dir [elprop]=\"ctxProp\"></div>",
                  directives: [MyDir]))
              .createAsync(MyComp)
              .then((val) {
            async.done();
          });
        }));
      });
    }
    // Disabled until a solution is found, refs:

    // - https://github.com/angular/angular/issues/776

    // - https://github.com/angular/angular/commit/81f3f32
    xdescribe("Missing directive checks", () {
      expectCompileError(tcb, inlineTpl, errMessage, done) {
        tcb = tcb.overrideView(MyComp, new viewAnn.View(template: inlineTpl));
        PromiseWrapper.then(tcb.createAsync(MyComp), (value) {
          throw new BaseException(
              "Test failure: should not have come here as an exception was expected");
        }, (err) {
          expect(err.message).toEqual(errMessage);
          done();
        });
      }
      if (assertionsEnabled()) {
        it("should raise an error if no directive is registered for a template with template bindings",
            inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          expectCompileError(tcb, "<div><div template=\"if: foo\"></div></div>",
              "Missing directive to handle 'if' in <div template=\"if: foo\">",
              () => async.done());
        }));
        it("should raise an error for missing template directive (1)", inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          expectCompileError(tcb, "<div><template foo></template></div>",
              "Missing directive to handle: <template foo>",
              () => async.done());
        }));
        it("should raise an error for missing template directive (2)", inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          expectCompileError(tcb,
              "<div><template *ng-if=\"condition\"></template></div>",
              "Missing directive to handle: <template *ng-if=\"condition\">",
              () => async.done());
        }));
        it("should raise an error for missing template directive (3)", inject([
          TestComponentBuilder,
          AsyncTestCompleter
        ], (TestComponentBuilder tcb, async) {
          expectCompileError(tcb, "<div *ng-if=\"condition\"></div>",
              "Missing directive to handle 'if' in MyComp: <div *ng-if=\"condition\">",
              () => async.done());
        }));
      }
    });
  });
}
@Injectable()
class MyService {
  String greeting;
  MyService() {
    this.greeting = "hello";
  }
}
@Component(selector: "simple-imp-cmp")
@View(renderer: "simple-imp-cmp-renderer", template: "")
@Injectable()
class SimpleImperativeViewComponent {
  var done;
  SimpleImperativeViewComponent(
      ElementRef self, AppViewManager viewManager, DomRenderer renderer) {
    var shadowViewRef = viewManager.getComponentView(self);
    renderer.setComponentViewRootNodes(
        shadowViewRef.render, [el("hello imp view")]);
  }
}
@Directive(selector: "dynamic-vp")
@Injectable()
class DynamicViewport {
  var done;
  DynamicViewport(ViewContainerRef vc, Compiler compiler) {
    var myService = new MyService();
    myService.greeting = "dynamic greet";
    var bindings = Injector.resolve([bind(MyService).toValue(myService)]);
    this.done = compiler.compileInHost(ChildCompUsingService).then((hostPv) {
      vc.create(hostPv, 0, null, bindings);
    });
  }
}
@Directive(
    selector: "[my-dir]",
    properties: const ["dirProp: elprop"],
    exportAs: "mydir")
@Injectable()
class MyDir {
  String dirProp;
  MyDir() {
    this.dirProp = "";
  }
}
@Component(
    selector: "push-cmp", properties: const ["prop"], changeDetection: ON_PUSH)
@View(template: "{{field}}")
@Injectable()
class PushCmp {
  num numberOfChecks;
  var prop;
  PushCmp() {
    this.numberOfChecks = 0;
  }
  get field {
    this.numberOfChecks++;
    return "fixed";
  }
}
@Component(
    selector: "push-cmp-with-ref",
    properties: const ["prop"],
    changeDetection: ON_PUSH)
@View(template: "{{field}}")
@Injectable()
class PushCmpWithRef {
  num numberOfChecks;
  ChangeDetectorRef ref;
  var prop;
  PushCmpWithRef(ChangeDetectorRef ref) {
    this.numberOfChecks = 0;
    this.ref = ref;
  }
  get field {
    this.numberOfChecks++;
    return "fixed";
  }
  propagate() {
    this.ref.requestCheck();
  }
}
@Injectable()
class PipesWithDouble extends Pipes {
  PipesWithDouble() : super({"double": [new DoublePipeFactory()]}) {
    /* super call moved to initializer */;
  }
}
@Component(
    selector: "my-comp-with-pipes",
    viewInjector: const [const Binding(Pipes, toClass: PipesWithDouble)])
@View(directives: const [])
@Injectable()
class MyCompWithPipes {
  String ctxProp = "initial value";
}
@Component(selector: "my-comp")
@View(directives: const [])
@Injectable()
class MyComp {
  String ctxProp;
  var ctxNumProp;
  var ctxBoolProp;
  MyComp() {
    this.ctxProp = "initial value";
    this.ctxNumProp = 0;
    this.ctxBoolProp = false;
  }
}
@Component(
    selector: "child-cmp",
    properties: const ["dirProp"],
    viewInjector: const [MyService])
@View(directives: const [MyDir], template: "{{ctxProp}}")
@Injectable()
class ChildComp {
  String ctxProp;
  String dirProp;
  ChildComp(MyService service) {
    this.ctxProp = service.greeting;
    this.dirProp = null;
  }
}
@Component(selector: "child-cmp-no-template")
@View(directives: const [], template: "")
@Injectable()
class ChildCompNoTemplate {
  String ctxProp = "hello";
}
@Component(selector: "child-cmp-svc")
@View(template: "{{ctxProp}}")
@Injectable()
class ChildCompUsingService {
  String ctxProp;
  ChildCompUsingService(MyService service) {
    this.ctxProp = service.greeting;
  }
}
@Directive(selector: "some-directive")
@Injectable()
class SomeDirective {}
class SomeDirectiveMissingAnnotation {}
@Component(selector: "cmp-with-parent")
@View(
    template: "<p>Component with an injected parent</p>",
    directives: const [SomeDirective])
@Injectable()
class CompWithParent {
  SomeDirective myParent;
  CompWithParent(@Parent() SomeDirective someComp) {
    this.myParent = someComp;
  }
}
@Component(selector: "cmp-with-ancestor")
@View(
    template: "<p>Component with an injected ancestor</p>",
    directives: const [SomeDirective])
@Injectable()
class CompWithAncestor {
  SomeDirective myAncestor;
  CompWithAncestor(@Ancestor() SomeDirective someComp) {
    this.myAncestor = someComp;
  }
}
@Component(selector: "[child-cmp2]", viewInjector: const [MyService])
@Injectable()
class ChildComp2 {
  String ctxProp;
  String dirProp;
  ChildComp2(MyService service) {
    this.ctxProp = service.greeting;
    this.dirProp = null;
  }
}
@Directive(selector: "[some-viewport]")
@Injectable()
class SomeViewport {
  SomeViewport(ViewContainerRef container, ProtoViewRef protoView) {
    container.create(protoView).setLocal("some-tmpl", "hello");
    container.create(protoView).setLocal("some-tmpl", "again");
  }
}
@Injectable()
class DoublePipe implements Pipe {
  onDestroy() {}
  supports(obj) {
    return true;
  }
  transform(value, [args = null]) {
    return '''${ value}${ value}''';
  }
}
@Injectable()
class DoublePipeFactory implements PipeFactory {
  supports(obj) {
    return true;
  }
  create(cdRef) {
    return new DoublePipe();
  }
}
@Directive(selector: "[emitter]", events: const ["event"])
@Injectable()
class DirectiveEmitingEvent {
  String msg;
  EventEmitter event;
  DirectiveEmitingEvent() {
    this.msg = "";
    this.event = new EventEmitter();
  }
  fireEvent(String msg) {
    ObservableWrapper.callNext(this.event, msg);
  }
}
@Directive(selector: "[update-host-attributes]", host: const {"role": "button"})
@Injectable()
class DirectiveUpdatingHostAttributes {}
@Directive(selector: "[update-host-properties]", host: const {"[id]": "id"})
@Injectable()
class DirectiveUpdatingHostProperties {
  String id;
  DirectiveUpdatingHostProperties() {
    this.id = "one";
  }
}
@Directive(
    selector: "[update-host-actions]", host: const {"@setAttr": "setAttribute"})
@Injectable()
class DirectiveUpdatingHostActions {
  EventEmitter setAttr;
  DirectiveUpdatingHostActions() {
    this.setAttr = new EventEmitter();
  }
  triggerSetAttr(attrValue) {
    ObservableWrapper.callNext(this.setAttr, ["key", attrValue]);
  }
}
@Directive(selector: "[listener]", host: const {"(event)": "onEvent(\$event)"})
@Injectable()
class DirectiveListeningEvent {
  String msg;
  DirectiveListeningEvent() {
    this.msg = "";
  }
  onEvent(String msg) {
    this.msg = msg;
  }
}
@Directive(
    selector: "[listener]",
    host: const {
  "(domEvent)": "onEvent(\$event.type)",
  "(window:domEvent)": "onWindowEvent(\$event.type)",
  "(document:domEvent)": "onDocumentEvent(\$event.type)",
  "(body:domEvent)": "onBodyEvent(\$event.type)"
})
@Injectable()
class DirectiveListeningDomEvent {
  String eventType;
  DirectiveListeningDomEvent() {
    this.eventType = "";
  }
  onEvent(String eventType) {
    this.eventType = eventType;
  }
  onWindowEvent(String eventType) {
    this.eventType = "window_" + eventType;
  }
  onDocumentEvent(String eventType) {
    this.eventType = "document_" + eventType;
  }
  onBodyEvent(String eventType) {
    this.eventType = "body_" + eventType;
  }
}
var globalCounter = 0;
@Directive(
    selector: "[listenerother]",
    host: const {"(window:domEvent)": "onEvent(\$event.type)"})
@Injectable()
class DirectiveListeningDomEventOther {
  String eventType;
  int counter;
  DirectiveListeningDomEventOther() {
    this.eventType = "";
  }
  onEvent(String eventType) {
    globalCounter++;
    this.eventType = "other_" + eventType;
  }
}
@Directive(
    selector: "[listenerprevent]", host: const {"(click)": "onEvent(\$event)"})
@Injectable()
class DirectiveListeningDomEventPrevent {
  onEvent(event) {
    return false;
  }
}
@Directive(
    selector: "[listenernoprevent]",
    host: const {"(click)": "onEvent(\$event)"})
@Injectable()
class DirectiveListeningDomEventNoPrevent {
  onEvent(event) {
    return true;
  }
}
@Directive(selector: "[id]", properties: const ["id"])
@Injectable()
class IdDir {
  String id;
}
@Directive(selector: "[static]")
@Injectable()
class NeedsAttribute {
  var typeAttribute;
  var titleAttribute;
  var fooAttribute;
  NeedsAttribute(@Attribute("type") String typeAttribute,
      @Attribute("title") String titleAttribute,
      @Attribute("foo") String fooAttribute) {
    this.typeAttribute = typeAttribute;
    this.titleAttribute = titleAttribute;
    this.fooAttribute = fooAttribute;
  }
}
@Directive(selector: "[public-api]")
@Injectable()
class PublicApi {}
@Directive(selector: "[private-impl]")
@Injectable()
class PrivateImpl extends PublicApi {}
@Directive(selector: "[needs-public-api]")
@Injectable()
class NeedsPublicApi {
  NeedsPublicApi(@Parent() PublicApi api) {
    expect(api is PrivateImpl).toBe(true);
  }
}
@Directive(selector: "[toolbarpart]")
@Injectable()
class ToolbarPart {
  ProtoViewRef protoViewRef;
  ElementRef elementRef;
  ToolbarPart(ProtoViewRef protoViewRef, ElementRef elementRef) {
    this.elementRef = elementRef;
    this.protoViewRef = protoViewRef;
  }
}
@Directive(selector: "[toolbar-vc]", properties: const ["toolbarVc"])
@Injectable()
class ToolbarViewContainer {
  ViewContainerRef vc;
  ToolbarViewContainer(ViewContainerRef vc) {
    this.vc = vc;
  }
  set toolbarVc(ToolbarPart part) {
    var view = this.vc.create(part.protoViewRef, 0, part.elementRef);
    view.setLocal("toolbarProp", "From toolbar");
  }
}
@Component(selector: "toolbar")
@View(
    template: "TOOLBAR(<div *ng-for=\"var part of query\" [toolbar-vc]=\"part\"></div>)",
    directives: const [ToolbarViewContainer, NgFor])
@Injectable()
class ToolbarComponent {
  QueryList<ToolbarPart> query;
  String ctxProp;
  ToolbarComponent(@Query(ToolbarPart) QueryList<ToolbarPart> query) {
    this.ctxProp = "hello world";
    this.query = query;
  }
}
@Directive(
    selector: "[two-way]",
    properties: const ["value: control"],
    events: const ["control"])
@Injectable()
class DirectiveWithTwoWayBinding {
  EventEmitter control;
  dynamic value;
  DirectiveWithTwoWayBinding() {
    this.control = new EventEmitter();
  }
  triggerChange(value) {
    ObservableWrapper.callNext(this.control, value);
  }
}
@Injectable()
class InjectableService {}
createInjectableWithLogging(Injector inj) {
  inj.get(ComponentProvidingLoggingInjectable).created = true;
  return new InjectableService();
}
@Component(
    selector: "component-providing-logging-injectable",
    hostInjector: const [
  const Binding(InjectableService,
      toFactory: createInjectableWithLogging, deps: const [Injector])
])
@View(template: "")
@Injectable()
class ComponentProvidingLoggingInjectable {
  bool created = false;
}
@Directive(
    selector: "directive-providing-injectable",
    hostInjector: const [const [InjectableService]])
@Injectable()
class DirectiveProvidingInjectable {}
@Component(
    selector: "directive-providing-injectable",
    viewInjector: const [const [InjectableService]])
@View(template: "")
@Injectable()
class DirectiveProvidingInjectableInView {}
@Component(
    selector: "directive-providing-injectable",
    hostInjector: const [const Binding(InjectableService, toValue: "host")],
    viewInjector: const [const Binding(InjectableService, toValue: "view")])
@View(template: "")
@Injectable()
class DirectiveProvidingInjectableInHostAndView {}
@Component(selector: "directive-consuming-injectable")
@View(template: "")
@Injectable()
class DirectiveConsumingInjectable {
  var injectable;
  DirectiveConsumingInjectable(
      @Ancestor() @Inject(InjectableService) injectable) {
    this.injectable = injectable;
  }
}
@Component(selector: "directive-containing-directive-consuming-an-injectable")
@Injectable()
class DirectiveContainingDirectiveConsumingAnInjectable {
  var directive;
}
@Component(selector: "directive-consuming-injectable-unbounded")
@View(template: "")
@Injectable()
class DirectiveConsumingInjectableUnbounded {
  var injectable;
  DirectiveConsumingInjectableUnbounded(
      @Unbounded() InjectableService injectable,
      @Ancestor() DirectiveContainingDirectiveConsumingAnInjectable parent) {
    this.injectable = injectable;
    parent.directive = this;
  }
}
class EventBus {
  final EventBus parentEventBus;
  final String name;
  const EventBus(EventBus parentEventBus, String name)
      : parentEventBus = parentEventBus,
        name = name;
}
@Directive(
    selector: "grand-parent-providing-event-bus",
    hostInjector: const [
  const Binding(EventBus, toValue: const EventBus(null, "grandparent"))
])
class GrandParentProvidingEventBus {
  EventBus bus;
  GrandParentProvidingEventBus(EventBus bus) {
    this.bus = bus;
  }
}
createParentBus(peb) {
  return new EventBus(peb, "parent");
}
@Component(
    selector: "parent-providing-event-bus",
    hostInjector: const [
  const Binding(EventBus,
      toFactory: createParentBus,
      deps: const [const [EventBus, const UnboundedMetadata()]])
])
@View(directives: const [ChildConsumingEventBus], template: '''
    <child-consuming-event-bus></child-consuming-event-bus>
  ''')
class ParentProvidingEventBus {
  EventBus bus;
  EventBus grandParentBus;
  ParentProvidingEventBus(EventBus bus, @Unbounded() EventBus grandParentBus) {
    this.bus = bus;
    this.grandParentBus = grandParentBus;
  }
}
@Directive(selector: "child-consuming-event-bus")
class ChildConsumingEventBus {
  EventBus bus;
  ChildConsumingEventBus(@Unbounded() EventBus bus) {
    this.bus = bus;
  }
}
@Directive(selector: "[some-impvp]", properties: const ["someImpvp"])
@Injectable()
class SomeImperativeViewport {
  ViewContainerRef vc;
  ProtoViewRef protoView;
  DomRenderer renderer;
  ViewRef view;
  var anchor;
  SomeImperativeViewport(
      this.vc, this.protoView, this.renderer, @Inject(ANCHOR_ELEMENT) anchor) {
    this.view = null;
    this.anchor = anchor;
  }
  set someImpvp(bool value) {
    if (isPresent(this.view)) {
      this.vc.clear();
      this.view = null;
    }
    if (value) {
      this.view = this.vc.create(this.protoView);
      var nodes = this.renderer.getRootNodes(this.view.render);
      for (var i = 0; i < nodes.length; i++) {
        DOM.appendChild(this.anchor, nodes[i]);
      }
    }
  }
}
@Directive(selector: "[export-dir]", exportAs: "dir")
class ExportDir {}
@Component(selector: "comp")
class ComponentWithoutView {}
@Directive(selector: "[no-duplicate]")
class DuplicateDir {
  ElementRef elRef;
  DuplicateDir(DomRenderer renderer, this.elRef) {
    DOM.setText(
        elRef.nativeElement, DOM.getText(elRef.nativeElement) + "noduplicate");
  }
}
@Directive(selector: "[no-duplicate]")
class OtherDuplicateDir {
  ElementRef elRef;
  OtherDuplicateDir(DomRenderer renderer, this.elRef) {
    DOM.setText(elRef.nativeElement,
        DOM.getText(elRef.nativeElement) + "othernoduplicate");
  }
}
