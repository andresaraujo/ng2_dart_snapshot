library angular2.test.debug.debug_element_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        beforeEach,
        ddescribe,
        xdescribe,
        describe,
        dispatchEvent,
        expect,
        iit,
        inject,
        IS_DARTIUM,
        beforeEachBindings,
        it,
        xit,
        TestComponentBuilder,
        By,
        Scope;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/src/facade/collection.dart" show List, ListWrapper;
import "package:angular2/src/facade/async.dart"
    show PromiseWrapper, EventEmitter, ObservableWrapper;
import "package:angular2/di.dart" show Injectable;
import "package:angular2/annotations.dart" show Directive, Component, View;
import "package:angular2/src/directives/ng_for.dart" show NgFor;

@Injectable()
class Logger {
  List<String> log;
  Logger() {
    this.log = [];
  }
  add(String thing) {
    this.log.add(thing);
  }
}
@Directive(selector: "[message]", properties: const ["message"])
@Injectable()
class MessageDir {
  Logger logger;
  MessageDir(Logger logger) {
    this.logger = logger;
  }
  set message(newMessage) {
    this.logger.add(newMessage);
  }
}
@Component(selector: "child-comp")
@View(template: '''<div class="child" message="child">
               <span class="childnested" message="nestedchild">Child</span>
             </div>
             <span class="child">{{childBinding}}</span>''',
    directives: const [MessageDir])
@Injectable()
class ChildComp {
  String childBinding;
  ChildComp() {
    this.childBinding = "Original";
  }
}
@Component(selector: "parent-comp", viewBindings: const [Logger])
@View(template: '''<div class="parent" message="parent">
               <span class="parentnested" message="nestedparent">Parent</span>
             </div>
             <span class="parent">{{parentBinding}}</span>
             <child-comp class="child-comp-class"></child-comp>''',
    directives: const [ChildComp, MessageDir])
@Injectable()
class ParentComp {
  String parentBinding;
  ParentComp() {
    this.parentBinding = "OriginalParent";
  }
}
@Directive(selector: "custom-emitter", events: const ["myevent"])
@Injectable()
class CustomEmitter {
  EventEmitter myevent;
  CustomEmitter() {
    this.myevent = new EventEmitter();
  }
}
@Component(selector: "events-comp")
@View(template: '''<button (click)="handleClick()"></button>
             <custom-emitter (myevent)="handleCustom()"></custom-emitter>''',
    directives: const [CustomEmitter])
@Injectable()
class EventsComp {
  bool clicked;
  bool customed;
  EventsComp() {
    this.clicked = false;
    this.customed = false;
  }
  handleClick() {
    this.clicked = true;
  }
  handleCustom() {
    this.customed = true;
  }
}
@Component(selector: "using-for", viewBindings: const [Logger])
@View(template: '''<span *ng-for="#thing of stuff">{{thing}}</span>
            <ul message="list">
              <li *ng-for="#item of stuff">{{item}}</li>
            </ul>''', directives: const [NgFor, MessageDir])
@Injectable()
class UsingFor {
  List<String> stuff;
  UsingFor() {
    this.stuff = ["one", "two", "three"];
  }
}
main() {
  describe("debug element", () {
    it("should list component child elements", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (tcb, async) {
      tcb.createAsync(ParentComp).then((rootTestComponent) {
        rootTestComponent.detectChanges();
        var childEls = rootTestComponent.children;
        // The root is a lone component, and has no children in the light dom.
        expect(childEls.length).toEqual(0);
        var rootCompChildren = rootTestComponent.componentViewChildren;
        // The root component has 3 elements in its shadow view.
        expect(rootCompChildren.length).toEqual(3);
        expect(DOM.hasClass(rootCompChildren[0].nativeElement, "parent"))
            .toBe(true);
        expect(DOM.hasClass(rootCompChildren[1].nativeElement, "parent"))
            .toBe(true);
        expect(DOM.hasClass(
            rootCompChildren[2].nativeElement, "child-comp-class")).toBe(true);
        var nested = rootCompChildren[0].children;
        expect(nested.length).toEqual(1);
        expect(DOM.hasClass(nested[0].nativeElement, "parentnested"))
            .toBe(true);
        var childComponent = rootCompChildren[2];
        expect(childComponent.children.length).toEqual(0);
        var childCompChildren = childComponent.componentViewChildren;
        expect(childCompChildren.length).toEqual(2);
        expect(DOM.hasClass(childCompChildren[0].nativeElement, "child"))
            .toBe(true);
        expect(DOM.hasClass(childCompChildren[1].nativeElement, "child"))
            .toBe(true);
        var childNested = childCompChildren[0].children;
        expect(childNested.length).toEqual(1);
        expect(DOM.hasClass(childNested[0].nativeElement, "childnested"))
            .toBe(true);
        async.done();
      });
    }));
    it("should list child elements within viewports", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (tcb, async) {
      tcb.createAsync(UsingFor).then((rootTestComponent) {
        rootTestComponent.detectChanges();
        var childEls = rootTestComponent.componentViewChildren;
        // TODO should this count include the <template> element?
        expect(childEls.length).toEqual(5);
        var list = childEls[4];
        expect(list.children.length).toEqual(4);
        async.done();
      });
    }));
    it("should query child elements", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (tcb, async) {
      tcb.createAsync(ParentComp).then((rootTestComponent) {
        rootTestComponent.detectChanges();
        var childTestEls = rootTestComponent.queryAll(By.directive(MessageDir));
        expect(childTestEls.length).toBe(4);
        expect(DOM.hasClass(childTestEls[0].nativeElement, "parent"))
            .toBe(true);
        expect(DOM.hasClass(childTestEls[1].nativeElement, "parentnested"))
            .toBe(true);
        expect(DOM.hasClass(childTestEls[2].nativeElement, "child")).toBe(true);
        expect(DOM.hasClass(childTestEls[3].nativeElement, "childnested"))
            .toBe(true);
        async.done();
      });
    }));
    it("should query child elements in the light DOM", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (tcb, async) {
      tcb.createAsync(ParentComp).then((rootTestComponent) {
        rootTestComponent.detectChanges();
        var parentEl = rootTestComponent.componentViewChildren[0];
        var childTestEls =
            parentEl.queryAll(By.directive(MessageDir), Scope.light);
        expect(childTestEls.length).toBe(1);
        expect(DOM.hasClass(childTestEls[0].nativeElement, "parentnested"))
            .toBe(true);
        async.done();
      });
    }));
    it("should query child elements in the current component view DOM", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (tcb, async) {
      tcb.createAsync(ParentComp).then((rootTestComponent) {
        rootTestComponent.detectChanges();
        var childTestEls =
            rootTestComponent.queryAll(By.directive(MessageDir), Scope.view);
        expect(childTestEls.length).toBe(2);
        expect(DOM.hasClass(childTestEls[0].nativeElement, "parent"))
            .toBe(true);
        expect(DOM.hasClass(childTestEls[1].nativeElement, "parentnested"))
            .toBe(true);
        async.done();
      });
    }));
    it("should allow injecting from the element injector", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (tcb, async) {
      tcb.createAsync(ParentComp).then((rootTestComponent) {
        rootTestComponent.detectChanges();
        expect(rootTestComponent.componentViewChildren[0].inject(Logger).log)
            .toEqual(["parent", "nestedparent", "child", "nestedchild"]);
        async.done();
      });
    }));
    it("should trigger event handlers", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (tcb, async) {
      tcb.createAsync(EventsComp).then((rootTestComponent) {
        rootTestComponent.detectChanges();
        expect(rootTestComponent.componentInstance.clicked).toBe(false);
        expect(rootTestComponent.componentInstance.customed).toBe(false);
        rootTestComponent.componentViewChildren[0].triggerEventHandler(
            "click", {});
        expect(rootTestComponent.componentInstance.clicked).toBe(true);
        rootTestComponent.componentViewChildren[1].triggerEventHandler(
            "myevent", {});
        expect(rootTestComponent.componentInstance.customed).toBe(true);
        async.done();
      });
    }));
  });
}
