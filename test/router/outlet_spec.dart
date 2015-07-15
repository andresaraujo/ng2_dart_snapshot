library angular2.test.router.outlet_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        TestComponentBuilder,
        asNativeElements,
        beforeEach,
        ddescribe,
        xdescribe,
        describe,
        el,
        expect,
        iit,
        inject,
        beforeEachBindings,
        it,
        xit;
import "package:angular2/di.dart" show Injector, bind;
import "package:angular2/src/core/annotations/decorators.dart"
    show Component, View;
import "package:angular2/src/core/annotations_impl/view.dart" as annotations;
import "package:angular2/src/facade/lang.dart" show NumberWrapper, isPresent;
import "package:angular2/src/facade/async.dart"
    show Future, PromiseWrapper, EventEmitter, ObservableWrapper;
import "package:angular2/src/router/router.dart" show RootRouter;
import "package:angular2/src/router/pipeline.dart" show Pipeline;
import "package:angular2/router.dart"
    show Router, RouterOutlet, RouterLink, RouteParams;
import "package:angular2/src/router/route_config_decorator.dart"
    show RouteConfig;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/mock/location_mock.dart" show SpyLocation;
import "package:angular2/src/router/location.dart" show Location;
import "package:angular2/src/router/route_registry.dart" show RouteRegistry;
import "package:angular2/src/router/interfaces.dart"
    show OnActivate, OnDeactivate, OnReuse, CanDeactivate, CanReuse;
import "package:angular2/src/router/lifecycle_annotations.dart"
    show CanActivate;
import "package:angular2/src/router/instruction.dart" show Instruction;
import "package:angular2/src/core/compiler/directive_resolver.dart"
    show DirectiveResolver;

var cmpInstanceCount, log, eventBus, completer;
main() {
  describe("Outlet Directive", () {
    TestComponentBuilder tcb;
    var rootTC, rtr, location;
    beforeEachBindings(() => [
      Pipeline,
      RouteRegistry,
      DirectiveResolver,
      bind(Location).toClass(SpyLocation),
      bind(Router).toFactory((registry, pipeline, location) {
        return new RootRouter(registry, pipeline, location, MyComp);
      }, [RouteRegistry, Pipeline, Location])
    ]);
    beforeEach(inject([
      TestComponentBuilder,
      Router,
      Location
    ], (tcBuilder, router, loc) {
      tcb = tcBuilder;
      rtr = router;
      location = loc;
      cmpInstanceCount = 0;
      log = "";
      eventBus = new EventEmitter();
    }));
    compile([String template = "<router-outlet></router-outlet>"]) {
      return tcb
          .overrideView(MyComp, new annotations.View(
              template: ("<div>" + template + "</div>"),
              directives: [RouterOutlet, RouterLink]))
          .createAsync(MyComp)
          .then((tc) {
        rootTC = tc;
      });
    }
    it("should work in a simple case", inject([AsyncTestCompleter], (async) {
      compile()
          .then((_) => rtr.config({"path": "/test", "component": HelloCmp}))
          .then((_) => rtr.navigate("/test"))
          .then((_) {
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("hello");
        async.done();
      });
    }));
    it("should navigate between components with different parameters", inject(
        [AsyncTestCompleter], (async) {
      compile()
          .then(
              (_) => rtr.config({"path": "/user/:name", "component": UserCmp}))
          .then((_) => rtr.navigate("/user/brian"))
          .then((_) {
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("hello brian");
      }).then((_) => rtr.navigate("/user/igor")).then((_) {
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("hello igor");
        async.done();
      });
    }));
    it("should work with child routers", inject([AsyncTestCompleter], (async) {
      compile("outer { <router-outlet></router-outlet> }")
          .then((_) => rtr.config({"path": "/a/...", "component": ParentCmp}))
          .then((_) => rtr.navigate("/a/b"))
          .then((_) {
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("outer { inner { hello } }");
        async.done();
      });
    }));
    it("should work with redirects", inject([
      AsyncTestCompleter,
      Location
    ], (async, location) {
      compile()
          .then((_) =>
              rtr.config({"path": "/original", "redirectTo": "/redirected"}))
          .then((_) => rtr.config({"path": "/redirected", "component": A}))
          .then((_) => rtr.navigate("/original"))
          .then((_) {
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("A");
        expect(location.urlChanges).toEqual(["/redirected"]);
        async.done();
      });
    }));
    getHref(tc) {
      return DOM.getAttribute(
          tc.componentViewChildren[0].nativeElement, "href");
    }
    it("should generate absolute hrefs that include the base href", inject(
        [AsyncTestCompleter], (async) {
      location.setBaseHref("/my/base");
      compile("<a href=\"hello\" [router-link]=\"['./user']\"></a>")
          .then((_) =>
              rtr.config({"path": "/user", "component": UserCmp, "as": "user"}))
          .then((_) => rtr.navigate("/a/b"))
          .then((_) {
        rootTC.detectChanges();
        expect(getHref(rootTC)).toEqual("/my/base/user");
        async.done();
      });
    }));
    it("should generate link hrefs without params", inject([AsyncTestCompleter],
        (async) {
      compile("<a href=\"hello\" [router-link]=\"['./user']\"></a>")
          .then((_) =>
              rtr.config({"path": "/user", "component": UserCmp, "as": "user"}))
          .then((_) => rtr.navigate("/a/b"))
          .then((_) {
        rootTC.detectChanges();
        expect(getHref(rootTC)).toEqual("/user");
        async.done();
      });
    }));
    it("should reuse common parent components", inject([AsyncTestCompleter],
        (async) {
      compile()
          .then((_) =>
              rtr.config({"path": "/team/:id/...", "component": TeamCmp}))
          .then((_) => rtr.navigate("/team/angular/user/rado"))
          .then((_) {
        rootTC.detectChanges();
        expect(cmpInstanceCount).toBe(1);
        expect(rootTC.nativeElement).toHaveText("team angular { hello rado }");
      }).then((_) => rtr.navigate("/team/angular/user/victor")).then((_) {
        rootTC.detectChanges();
        expect(cmpInstanceCount).toBe(1);
        expect(rootTC.nativeElement)
            .toHaveText("team angular { hello victor }");
        async.done();
      });
    }));
    it("should generate link hrefs with params", inject([AsyncTestCompleter],
        (async) {
      compile("<a href=\"hello\" [router-link]=\"['./user', {name: name}]\">{{name}}</a>")
          .then((_) => rtr.config(
              {"path": "/user/:name", "component": UserCmp, "as": "user"}))
          .then((_) => rtr.navigate("/a/b"))
          .then((_) {
        rootTC.componentInstance.name = "brian";
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("brian");
        expect(DOM.getAttribute(
                rootTC.componentViewChildren[0].nativeElement, "href"))
            .toEqual("/user/brian");
        async.done();
      });
    }));
    it("should generate link hrefs from a child to its sibling", inject(
        [AsyncTestCompleter], (async) {
      compile()
          .then((_) => rtr.config({
        "path": "/page/:number",
        "component": SiblingPageCmp,
        "as": "page"
      }))
          .then((_) => rtr.navigate("/page/1"))
          .then((_) {
        rootTC.detectChanges();
        expect(DOM.getAttribute(rootTC.componentViewChildren[
                1].componentViewChildren[0].children[0].nativeElement, "href"))
            .toEqual("/page/2");
        async.done();
      });
    }));
    it("should generate relative links preserving the existing parent route",
        inject([AsyncTestCompleter], (async) {
      compile()
          .then((_) => rtr.config(
              {"path": "/book/:title/...", "component": BookCmp, "as": "book"}))
          .then((_) => rtr.navigate("/book/1984/page/1"))
          .then((_) {
        rootTC.detectChanges();
        expect(DOM.getAttribute(rootTC.componentViewChildren[
                1].componentViewChildren[0].nativeElement, "href"))
            .toEqual("/book/1984/page/100");
        expect(DOM.getAttribute(
                rootTC.componentViewChildren[1].componentViewChildren[
                2].componentViewChildren[0].children[0].nativeElement, "href"))
            .toEqual("/book/1984/page/2");
        async.done();
      });
    }));
    it("should call the onActivate hook", inject([AsyncTestCompleter], (async) {
      compile()
          .then((_) => rtr.config({"path": "/...", "component": LifecycleCmp}))
          .then((_) => rtr.navigate("/on-activate"))
          .then((_) {
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("activate cmp");
        expect(log).toEqual("activate: null -> /on-activate;");
        async.done();
      });
    }));
    it("should wait for a parent component's onActivate hook to resolve before calling its child's",
        inject([AsyncTestCompleter], (async) {
      compile()
          .then((_) => rtr.config({"path": "/...", "component": LifecycleCmp}))
          .then((_) {
        ObservableWrapper.subscribe(eventBus, (ev) {
          if (ev.startsWith("parent activate")) {
            completer.resolve(true);
          }
        });
        rtr.navigate("/parent-activate/child-activate").then((_) {
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("parent {activate cmp}");
          expect(log).toEqual(
              "parent activate: null -> /parent-activate/child-activate;activate: null -> /child-activate;");
          async.done();
        });
      });
    }));
    it("should call the onDeactivate hook", inject([AsyncTestCompleter],
        (async) {
      compile()
          .then((_) => rtr.config({"path": "/...", "component": LifecycleCmp}))
          .then((_) => rtr.navigate("/on-deactivate"))
          .then((_) => rtr.navigate("/a"))
          .then((_) {
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("A");
        expect(log).toEqual("deactivate: /on-deactivate -> /a;");
        async.done();
      });
    }));
    it("should wait for a child component's onDeactivate hook to resolve before calling its parent's",
        inject([AsyncTestCompleter], (async) {
      compile()
          .then((_) => rtr.config({"path": "/...", "component": LifecycleCmp}))
          .then((_) => rtr.navigate("/parent-deactivate/child-deactivate"))
          .then((_) {
        ObservableWrapper.subscribe(eventBus, (ev) {
          if (ev.startsWith("deactivate")) {
            completer.resolve(true);
            rootTC.detectChanges();
            expect(rootTC.nativeElement).toHaveText("parent {deactivate cmp}");
          }
        });
        rtr.navigate("/a").then((_) {
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("A");
          expect(log).toEqual(
              "deactivate: /child-deactivate -> null;parent deactivate: /parent-deactivate/child-deactivate -> /a;");
          async.done();
        });
      });
    }));
    it("should reuse a component when the canReuse hook returns false", inject(
        [AsyncTestCompleter], (async) {
      compile()
          .then((_) => rtr.config({"path": "/...", "component": LifecycleCmp}))
          .then((_) => rtr.navigate("/on-reuse/1/a"))
          .then((_) {
        rootTC.detectChanges();
        expect(log).toEqual("");
        expect(rootTC.nativeElement).toHaveText("reuse {A}");
        expect(cmpInstanceCount).toBe(1);
      }).then((_) => rtr.navigate("/on-reuse/2/b")).then((_) {
        rootTC.detectChanges();
        expect(log).toEqual("reuse: /on-reuse/1/a -> /on-reuse/2/b;");
        expect(rootTC.nativeElement).toHaveText("reuse {B}");
        expect(cmpInstanceCount).toBe(1);
        async.done();
      });
    }));
    it("should not reuse a component when the canReuse hook returns false",
        inject([AsyncTestCompleter], (async) {
      compile()
          .then((_) => rtr.config({"path": "/...", "component": LifecycleCmp}))
          .then((_) => rtr.navigate("/never-reuse/1/a"))
          .then((_) {
        rootTC.detectChanges();
        expect(log).toEqual("");
        expect(rootTC.nativeElement).toHaveText("reuse {A}");
        expect(cmpInstanceCount).toBe(1);
      }).then((_) => rtr.navigate("/never-reuse/2/b")).then((_) {
        rootTC.detectChanges();
        expect(log).toEqual("");
        expect(rootTC.nativeElement).toHaveText("reuse {B}");
        expect(cmpInstanceCount).toBe(2);
        async.done();
      });
    }));
    it("should navigate when canActivate returns true", inject(
        [AsyncTestCompleter], (async) {
      compile()
          .then((_) => rtr.config({"path": "/...", "component": LifecycleCmp}))
          .then((_) {
        ObservableWrapper.subscribe(eventBus, (ev) {
          if (ev.startsWith("canActivate")) {
            completer.resolve(true);
          }
        });
        rtr.navigate("/can-activate/a").then((_) {
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("canActivate {A}");
          expect(log).toEqual("canActivate: null -> /can-activate/a;");
          async.done();
        });
      });
    }));
    it("should not navigate when canActivate returns false", inject(
        [AsyncTestCompleter], (async) {
      compile()
          .then((_) => rtr.config({"path": "/...", "component": LifecycleCmp}))
          .then((_) {
        ObservableWrapper.subscribe(eventBus, (ev) {
          if (ev.startsWith("canActivate")) {
            completer.resolve(false);
          }
        });
        rtr.navigate("/can-activate/a").then((_) {
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("");
          expect(log).toEqual("canActivate: null -> /can-activate/a;");
          async.done();
        });
      });
    }));
    it("should navigate away when canDeactivate returns true", inject(
        [AsyncTestCompleter], (async) {
      compile()
          .then((_) => rtr.config({"path": "/...", "component": LifecycleCmp}))
          .then((_) => rtr.navigate("/can-deactivate/a"))
          .then((_) {
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("canDeactivate {A}");
        expect(log).toEqual("");
        ObservableWrapper.subscribe(eventBus, (ev) {
          if (ev.startsWith("canDeactivate")) {
            completer.resolve(true);
          }
        });
        rtr.navigate("/a").then((_) {
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("A");
          expect(log).toEqual("canDeactivate: /can-deactivate/a -> /a;");
          async.done();
        });
      });
    }));
    it("should not navigate away when canDeactivate returns false", inject(
        [AsyncTestCompleter], (async) {
      compile()
          .then((_) => rtr.config({"path": "/...", "component": LifecycleCmp}))
          .then((_) => rtr.navigate("/can-deactivate/a"))
          .then((_) {
        rootTC.detectChanges();
        expect(rootTC.nativeElement).toHaveText("canDeactivate {A}");
        expect(log).toEqual("");
        ObservableWrapper.subscribe(eventBus, (ev) {
          if (ev.startsWith("canDeactivate")) {
            completer.resolve(false);
          }
        });
        rtr.navigate("/a").then((_) {
          rootTC.detectChanges();
          expect(rootTC.nativeElement).toHaveText("canDeactivate {A}");
          expect(log).toEqual("canDeactivate: /can-deactivate/a -> /a;");
          async.done();
        });
      });
    }));
    it("should run activation and deactivation hooks in the correct order",
        inject([AsyncTestCompleter], (async) {
      compile()
          .then((_) => rtr.config({"path": "/...", "component": LifecycleCmp}))
          .then((_) => rtr.navigate("/activation-hooks/child"))
          .then((_) {
        expect(log).toEqual("canActivate child: null -> /child;" +
            "canActivate parent: null -> /activation-hooks/child;" +
            "onActivate parent: null -> /activation-hooks/child;" +
            "onActivate child: null -> /child;");
        log = "";
        return rtr.navigate("/a");
      }).then((_) {
        expect(log).toEqual(
            "canDeactivate parent: /activation-hooks/child -> /a;" +
                "canDeactivate child: /child -> null;" +
                "onDeactivate child: /child -> null;" +
                "onDeactivate parent: /activation-hooks/child -> /a;");
        async.done();
      });
    }));
    it("should only run reuse hooks when reusing", inject([AsyncTestCompleter],
        (async) {
      compile()
          .then((_) => rtr.config({"path": "/...", "component": LifecycleCmp}))
          .then((_) => rtr.navigate("/reuse-hooks/1"))
          .then((_) {
        expect(log).toEqual("canActivate: null -> /reuse-hooks/1;" +
            "onActivate: null -> /reuse-hooks/1;");
        ObservableWrapper.subscribe(eventBus, (ev) {
          if (ev.startsWith("canReuse")) {
            completer.resolve(true);
          }
        });
        log = "";
        return rtr.navigate("/reuse-hooks/2");
      }).then((_) {
        expect(log).toEqual("canReuse: /reuse-hooks/1 -> /reuse-hooks/2;" +
            "onReuse: /reuse-hooks/1 -> /reuse-hooks/2;");
        async.done();
      });
    }));
    it("should not run reuse hooks when not reusing", inject(
        [AsyncTestCompleter], (async) {
      compile()
          .then((_) => rtr.config({"path": "/...", "component": LifecycleCmp}))
          .then((_) => rtr.navigate("/reuse-hooks/1"))
          .then((_) {
        expect(log).toEqual("canActivate: null -> /reuse-hooks/1;" +
            "onActivate: null -> /reuse-hooks/1;");
        ObservableWrapper.subscribe(eventBus, (ev) {
          if (ev.startsWith("canReuse")) {
            completer.resolve(false);
          }
        });
        log = "";
        return rtr.navigate("/reuse-hooks/2");
      }).then((_) {
        expect(log).toEqual("canReuse: /reuse-hooks/1 -> /reuse-hooks/2;" +
            "canActivate: /reuse-hooks/1 -> /reuse-hooks/2;" +
            "canDeactivate: /reuse-hooks/1 -> /reuse-hooks/2;" +
            "onDeactivate: /reuse-hooks/1 -> /reuse-hooks/2;" +
            "onActivate: /reuse-hooks/1 -> /reuse-hooks/2;");
        async.done();
      });
    }));
    describe("when clicked", () {
      var clickOnElement = (view) {
        var anchorEl = rootTC.componentViewChildren[0].nativeElement;
        var dispatchedEvent = DOM.createMouseEvent("click");
        DOM.dispatchEvent(anchorEl, dispatchedEvent);
        return dispatchedEvent;
      };
      it("should navigate to link hrefs without params", inject(
          [AsyncTestCompleter], (async) {
        compile("<a href=\"hello\" [router-link]=\"['./user']\"></a>")
            .then((_) => rtr
                .config({"path": "/user", "component": UserCmp, "as": "user"}))
            .then((_) => rtr.navigate("/a/b"))
            .then((_) {
          rootTC.detectChanges();
          var dispatchedEvent = clickOnElement(rootTC);
          expect(dispatchedEvent.defaultPrevented ||
              !dispatchedEvent.returnValue).toBe(true);
          // router navigation is async.
          rtr.subscribe((_) {
            expect(location.urlChanges).toEqual(["/user"]);
            async.done();
          });
        });
      }));
      it("should navigate to link hrefs in presence of base href", inject(
          [AsyncTestCompleter], (async) {
        location.setBaseHref("/base");
        compile("<a href=\"hello\" [router-link]=\"['./user']\"></a>")
            .then((_) => rtr
                .config({"path": "/user", "component": UserCmp, "as": "user"}))
            .then((_) => rtr.navigate("/a/b"))
            .then((_) {
          rootTC.detectChanges();
          var dispatchedEvent = clickOnElement(rootTC);
          expect(dispatchedEvent.defaultPrevented ||
              !dispatchedEvent.returnValue).toBe(true);
          // router navigation is async.
          rtr.subscribe((_) {
            expect(location.urlChanges).toEqual(["/base/user"]);
            async.done();
          });
        });
      }));
    });
  });
}
@Component(selector: "hello-cmp")
@View(template: "{{greeting}}")
class HelloCmp {
  String greeting;
  HelloCmp() {
    this.greeting = "hello";
  }
}
@Component(selector: "a-cmp")
@View(template: "A")
class A {}
@Component(selector: "b-cmp")
@View(template: "B")
class B {}
@Component(selector: "user-cmp")
@View(template: "hello {{user}}")
class UserCmp {
  String user;
  UserCmp(RouteParams params) {
    this.user = params.get("name");
  }
}
@Component(selector: "page-cmp")
@View(
    template: '''page #{{pageNumber}} | <a href="hello" [router-link]="[\'../page\', {number: nextPage}]">next</a>''',
    directives: const [RouterLink])
class SiblingPageCmp {
  num pageNumber;
  num nextPage;
  SiblingPageCmp(RouteParams params) {
    this.pageNumber = NumberWrapper.parseInt(params.get("number"), 10);
    this.nextPage = this.pageNumber + 1;
  }
}
@Component(selector: "book-cmp")
@View(
    template: '''<a href="hello" [router-link]="[\'./page\', {number: 100}]">{{title}}</a> |
    <router-outlet></router-outlet>''',
    directives: const [RouterLink, RouterOutlet])
@RouteConfig(const [
  const {"path": "/page/:number", "component": SiblingPageCmp, "as": "page"}
])
class BookCmp {
  String title;
  BookCmp(RouteParams params) {
    this.title = params.get("title");
  }
}
@Component(selector: "parent-cmp")
@View(
    template: "inner { <router-outlet></router-outlet> }",
    directives: const [RouterOutlet])
@RouteConfig(const [const {"path": "/b", "component": HelloCmp}])
class ParentCmp {
  ParentCmp() {}
}
@Component(selector: "team-cmp")
@View(
    template: "team {{id}} { <router-outlet></router-outlet> }",
    directives: const [RouterOutlet])
@RouteConfig(const [const {"path": "/user/:name", "component": UserCmp}])
class TeamCmp {
  String id;
  TeamCmp(RouteParams params) {
    this.id = params.get("id");
    cmpInstanceCount += 1;
  }
}
@Component(selector: "my-comp")
class MyComp {
  var name;
}
logHook(String name, Instruction next, Instruction prev) {
  var message = name +
      ": " +
      (isPresent(prev) ? prev.accumulatedUrl : "null") +
      " -> " +
      (isPresent(next) ? next.accumulatedUrl : "null") +
      ";";
  log += message;
  ObservableWrapper.callNext(eventBus, message);
}
@Component(selector: "activate-cmp")
@View(template: "activate cmp")
class ActivateCmp implements OnActivate {
  onActivate(Instruction next, Instruction prev) {
    logHook("activate", next, prev);
  }
}
@Component(selector: "parent-activate-cmp")
@View(
    template: '''parent {<router-outlet></router-outlet>}''',
    directives: const [RouterOutlet])
@RouteConfig(
    const [const {"path": "/child-activate", "component": ActivateCmp}])
class ParentActivateCmp implements OnActivate {
  Future<dynamic> onActivate(Instruction next, Instruction prev) {
    completer = PromiseWrapper.completer();
    logHook("parent activate", next, prev);
    return completer.promise;
  }
}
@Component(selector: "deactivate-cmp")
@View(template: "deactivate cmp")
class DeactivateCmp implements OnDeactivate {
  onDeactivate(Instruction next, Instruction prev) {
    logHook("deactivate", next, prev);
  }
}
@Component(selector: "deactivate-cmp")
@View(template: "deactivate cmp")
class WaitDeactivateCmp implements OnDeactivate {
  Future<dynamic> onDeactivate(Instruction next, Instruction prev) {
    completer = PromiseWrapper.completer();
    logHook("deactivate", next, prev);
    return completer.promise;
  }
}
@Component(selector: "parent-deactivate-cmp")
@View(
    template: '''parent {<router-outlet></router-outlet>}''',
    directives: const [RouterOutlet])
@RouteConfig(
    const [const {"path": "/child-deactivate", "component": WaitDeactivateCmp}])
class ParentDeactivateCmp implements OnDeactivate {
  onDeactivate(Instruction next, Instruction prev) {
    logHook("parent deactivate", next, prev);
  }
}
@Component(selector: "reuse-cmp")
@View(
    template: '''reuse {<router-outlet></router-outlet>}''',
    directives: const [RouterOutlet])
@RouteConfig(const [
  const {"path": "/a", "component": A},
  const {"path": "/b", "component": B}
])
class ReuseCmp implements OnReuse, CanReuse {
  ReuseCmp() {
    cmpInstanceCount += 1;
  }
  canReuse(Instruction next, Instruction prev) {
    return true;
  }
  onReuse(Instruction next, Instruction prev) {
    logHook("reuse", next, prev);
  }
}
@Component(selector: "never-reuse-cmp")
@View(
    template: '''reuse {<router-outlet></router-outlet>}''',
    directives: const [RouterOutlet])
@RouteConfig(const [
  const {"path": "/a", "component": A},
  const {"path": "/b", "component": B}
])
class NeverReuseCmp implements OnReuse, CanReuse {
  NeverReuseCmp() {
    cmpInstanceCount += 1;
  }
  canReuse(Instruction next, Instruction prev) {
    return false;
  }
  onReuse(Instruction next, Instruction prev) {
    logHook("reuse", next, prev);
  }
}
@Component(selector: "can-activate-cmp")
@View(
    template: '''canActivate {<router-outlet></router-outlet>}''',
    directives: const [RouterOutlet])
@RouteConfig(const [
  const {"path": "/a", "component": A},
  const {"path": "/b", "component": B}
])
@CanActivate(CanActivateCmp.canActivate)
class CanActivateCmp {
  static canActivate(Instruction next, Instruction prev) {
    completer = PromiseWrapper.completer();
    logHook("canActivate", next, prev);
    return completer.promise;
  }
}
@Component(selector: "can-deactivate-cmp")
@View(
    template: '''canDeactivate {<router-outlet></router-outlet>}''',
    directives: const [RouterOutlet])
@RouteConfig(const [
  const {"path": "/a", "component": A},
  const {"path": "/b", "component": B}
])
class CanDeactivateCmp implements CanDeactivate {
  canDeactivate(Instruction next, Instruction prev) {
    completer = PromiseWrapper.completer();
    logHook("canDeactivate", next, prev);
    return completer.promise;
  }
}
@Component(selector: "all-hooks-child-cmp")
@View(template: '''child''')
@CanActivate(AllHooksChildCmp.canActivate)
class AllHooksChildCmp implements CanDeactivate, OnDeactivate, OnActivate {
  canDeactivate(Instruction next, Instruction prev) {
    logHook("canDeactivate child", next, prev);
    return true;
  }
  onDeactivate(Instruction next, Instruction prev) {
    logHook("onDeactivate child", next, prev);
  }
  static canActivate(Instruction next, Instruction prev) {
    logHook("canActivate child", next, prev);
    return true;
  }
  onActivate(Instruction next, Instruction prev) {
    logHook("onActivate child", next, prev);
  }
}
@Component(selector: "all-hooks-parent-cmp")
@View(
    template: '''<router-outlet></router-outlet>''',
    directives: const [RouterOutlet])
@RouteConfig(const [const {"path": "/child", "component": AllHooksChildCmp}])
@CanActivate(AllHooksParentCmp.canActivate)
class AllHooksParentCmp implements CanDeactivate, OnDeactivate, OnActivate {
  canDeactivate(Instruction next, Instruction prev) {
    logHook("canDeactivate parent", next, prev);
    return true;
  }
  onDeactivate(Instruction next, Instruction prev) {
    logHook("onDeactivate parent", next, prev);
  }
  static canActivate(Instruction next, Instruction prev) {
    logHook("canActivate parent", next, prev);
    return true;
  }
  onActivate(Instruction next, Instruction prev) {
    logHook("onActivate parent", next, prev);
  }
}
@Component(selector: "reuse-hooks-cmp")
@View(template: "reuse hooks cmp")
@CanActivate(ReuseHooksCmp.canActivate)
class ReuseHooksCmp
    implements OnActivate, OnReuse, OnDeactivate, CanReuse, CanDeactivate {
  Future<dynamic> canReuse(Instruction next, Instruction prev) {
    completer = PromiseWrapper.completer();
    logHook("canReuse", next, prev);
    return completer.promise;
  }
  onReuse(Instruction next, Instruction prev) {
    logHook("onReuse", next, prev);
  }
  canDeactivate(Instruction next, Instruction prev) {
    logHook("canDeactivate", next, prev);
    return true;
  }
  onDeactivate(Instruction next, Instruction prev) {
    logHook("onDeactivate", next, prev);
  }
  static canActivate(Instruction next, Instruction prev) {
    logHook("canActivate", next, prev);
    return true;
  }
  onActivate(Instruction next, Instruction prev) {
    logHook("onActivate", next, prev);
  }
}
@Component(selector: "lifecycle-cmp")
@View(
    template: '''<router-outlet></router-outlet>''',
    directives: const [RouterOutlet])
@RouteConfig(const [
  const {"path": "/a", "component": A},
  const {"path": "/on-activate", "component": ActivateCmp},
  const {"path": "/parent-activate/...", "component": ParentActivateCmp},
  const {"path": "/on-deactivate", "component": DeactivateCmp},
  const {"path": "/parent-deactivate/...", "component": ParentDeactivateCmp},
  const {"path": "/on-reuse/:number/...", "component": ReuseCmp},
  const {"path": "/never-reuse/:number/...", "component": NeverReuseCmp},
  const {"path": "/can-activate/...", "component": CanActivateCmp},
  const {"path": "/can-deactivate/...", "component": CanDeactivateCmp},
  const {"path": "/activation-hooks/...", "component": AllHooksParentCmp},
  const {"path": "/reuse-hooks/:number", "component": ReuseHooksCmp}
])
class LifecycleCmp {}
