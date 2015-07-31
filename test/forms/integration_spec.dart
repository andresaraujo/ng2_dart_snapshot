library angular2.test.forms.integration_spec;

import "package:angular2/angular2.dart" show Component, Directive, View;
import "package:angular2/test_lib.dart"
    show
        afterEach,
        AsyncTestCompleter,
        TestComponentBuilder,
        By,
        beforeEach,
        ddescribe,
        describe,
        dispatchEvent,
        fakeAsync,
        tick,
        expect,
        it,
        inject,
        iit,
        xit;
import "package:angular2/src/dom/dom_adapter.dart" show DOM;
import "package:angular2/directives.dart" show NgIf, NgFor;
import "package:angular2/forms.dart"
    show
        Control,
        ControlGroup,
        NgForm,
        formDirectives,
        Validators,
        NgControl,
        ControlValueAccessor;

main() {
  describe("integration tests", () {
    it("should initialize DOM elements with the given form object", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      var t = '''<div [ng-form-model]="form">
                <input type="text" ng-control="login">
               </div>''';
      tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
        rootTC.componentInstance.form =
            new ControlGroup({"login": new Control("loginValue")});
        rootTC.detectChanges();
        var input = rootTC.query(By.css("input"));
        expect(input.nativeElement.value).toEqual("loginValue");
        async.done();
      });
    }));
    it("should update the control group values on DOM change", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      var form = new ControlGroup({"login": new Control("oldValue")});
      var t = '''<div [ng-form-model]="form">
                <input type="text" ng-control="login">
              </div>''';
      tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
        rootTC.componentInstance.form = form;
        rootTC.detectChanges();
        var input = rootTC.query(By.css("input"));
        input.nativeElement.value = "updatedValue";
        dispatchEvent(input.nativeElement, "change");
        expect(form.value).toEqual({"login": "updatedValue"});
        async.done();
      });
    }));
    it("should emit ng-submit event on submit", inject([TestComponentBuilder],
        fakeAsync((TestComponentBuilder tcb) {
      var t =
          '''<div><form [ng-form-model]="form" (ng-submit)="name=\'updated\'"></form><span>{{name}}</span></div>''';
      var rootTC;
      tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((root) {
        rootTC = root;
      });
      tick();
      rootTC.componentInstance.form = new ControlGroup({});
      rootTC.componentInstance.name = "old";
      tick();
      var form = rootTC.query(By.css("form"));
      dispatchEvent(form.nativeElement, "submit");
      tick();
      expect(rootTC.componentInstance.name).toEqual("updated");
    })));
    it("should work with single controls", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      var control = new Control("loginValue");
      var t = '''<div><input type="text" [ng-form-control]="form"></div>''';
      tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
        rootTC.componentInstance.form = control;
        rootTC.detectChanges();
        var input = rootTC.query(By.css("input"));
        expect(input.nativeElement.value).toEqual("loginValue");
        input.nativeElement.value = "updatedValue";
        dispatchEvent(input.nativeElement, "change");
        expect(control.value).toEqual("updatedValue");
        async.done();
      });
    }));
    it("should update DOM elements when rebinding the control group", inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      var t = '''<div [ng-form-model]="form">
                <input type="text" ng-control="login">
               </div>''';
      tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
        rootTC.componentInstance.form =
            new ControlGroup({"login": new Control("oldValue")});
        rootTC.detectChanges();
        rootTC.componentInstance.form =
            new ControlGroup({"login": new Control("newValue")});
        rootTC.detectChanges();
        var input = rootTC.query(By.css("input"));
        expect(input.nativeElement.value).toEqual("newValue");
        async.done();
      });
    }));
    it("should update DOM elements when updating the value of a control",
        inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      var login = new Control("oldValue");
      var form = new ControlGroup({"login": login});
      var t = '''<div [ng-form-model]="form">
                <input type="text" ng-control="login">
               </div>''';
      tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
        rootTC.componentInstance.form = form;
        rootTC.detectChanges();
        login.updateValue("newValue");
        rootTC.detectChanges();
        var input = rootTC.query(By.css("input"));
        expect(input.nativeElement.value).toEqual("newValue");
        async.done();
      });
    }));
    it("should mark controls as touched after interacting with the DOM control",
        inject([
      TestComponentBuilder,
      AsyncTestCompleter
    ], (TestComponentBuilder tcb, async) {
      var login = new Control("oldValue");
      var form = new ControlGroup({"login": login});
      var t = '''<div [ng-form-model]="form">
                <input type="text" ng-control="login">
               </div>''';
      tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
        rootTC.componentInstance.form = form;
        rootTC.detectChanges();
        var loginEl = rootTC.query(By.css("input"));
        expect(login.touched).toBe(false);
        dispatchEvent(loginEl.nativeElement, "blur");
        expect(login.touched).toBe(true);
        async.done();
      });
    }));
    describe("different control types", () {
      it("should support <input type=text>", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var t = '''<div [ng-form-model]="form">
                  <input type="text" ng-control="text">
                </div>''';
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
          rootTC.componentInstance.form =
              new ControlGroup({"text": new Control("old")});
          rootTC.detectChanges();
          var input = rootTC.query(By.css("input"));
          expect(input.nativeElement.value).toEqual("old");
          input.nativeElement.value = "new";
          dispatchEvent(input.nativeElement, "input");
          expect(rootTC.componentInstance.form.value).toEqual({"text": "new"});
          async.done();
        });
      }));
      it("should support <input> without type", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var t = '''<div [ng-form-model]="form">
                  <input ng-control="text">
                </div>''';
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
          rootTC.componentInstance.form =
              new ControlGroup({"text": new Control("old")});
          rootTC.detectChanges();
          var input = rootTC.query(By.css("input"));
          expect(input.nativeElement.value).toEqual("old");
          input.nativeElement.value = "new";
          dispatchEvent(input.nativeElement, "input");
          expect(rootTC.componentInstance.form.value).toEqual({"text": "new"});
          async.done();
        });
      }));
      it("should support <textarea>", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var t = '''<div [ng-form-model]="form">
                  <textarea ng-control="text"></textarea>
                </div>''';
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
          rootTC.componentInstance.form =
              new ControlGroup({"text": new Control("old")});
          rootTC.detectChanges();
          var textarea = rootTC.query(By.css("textarea"));
          expect(textarea.nativeElement.value).toEqual("old");
          textarea.nativeElement.value = "new";
          dispatchEvent(textarea.nativeElement, "input");
          expect(rootTC.componentInstance.form.value).toEqual({"text": "new"});
          async.done();
        });
      }));
      it("should support <type=checkbox>", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var t = '''<div [ng-form-model]="form">
                  <input type="checkbox" ng-control="checkbox">
                </div>''';
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
          rootTC.componentInstance.form =
              new ControlGroup({"checkbox": new Control(true)});
          rootTC.detectChanges();
          var input = rootTC.query(By.css("input"));
          expect(input.nativeElement.checked).toBe(true);
          input.nativeElement.checked = false;
          dispatchEvent(input.nativeElement, "change");
          expect(rootTC.componentInstance.form.value)
              .toEqual({"checkbox": false});
          async.done();
        });
      }));
      it("should support <select>", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var t = '''<div [ng-form-model]="form">
                    <select ng-control="city">
                      <option value="SF"></option>
                      <option value="NYC"></option>
                    </select>
                  </div>''';
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
          rootTC.componentInstance.form =
              new ControlGroup({"city": new Control("SF")});
          rootTC.detectChanges();
          var select = rootTC.query(By.css("select"));
          var sfOption = rootTC.query(By.css("option"));
          expect(select.nativeElement.value).toEqual("SF");
          expect(sfOption.nativeElement.selected).toBe(true);
          select.nativeElement.value = "NYC";
          dispatchEvent(select.nativeElement, "change");
          expect(rootTC.componentInstance.form.value).toEqual({"city": "NYC"});
          expect(sfOption.nativeElement.selected).toBe(false);
          async.done();
        });
      }));
      it("should support <select> with a dynamic list of options", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var t = '''<div [ng-form-model]="form">
                      <select ng-control="city">
                        <option *ng-for="#c of data" [value]="c"></option>
                      </select>
                  </div>''';
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
          rootTC.componentInstance.form =
              new ControlGroup({"city": new Control("NYC")});
          rootTC.componentInstance.data = ["SF", "NYC"];
          rootTC.detectChanges();
          var select = rootTC.query(By.css("select"));
          expect(select.nativeElement.value).toEqual("NYC");
          async.done();
        });
      }));
      it("should support custom value accessors", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var t = '''<div [ng-form-model]="form">
                  <input type="text" ng-control="name" wrapped-value>
                </div>''';
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
          rootTC.componentInstance.form =
              new ControlGroup({"name": new Control("aa")});
          rootTC.detectChanges();
          var input = rootTC.query(By.css("input"));
          expect(input.nativeElement.value).toEqual("!aa!");
          input.nativeElement.value = "!bb!";
          dispatchEvent(input.nativeElement, "change");
          expect(rootTC.componentInstance.form.value).toEqual({"name": "bb"});
          async.done();
        });
      }));
    });
    describe("validations", () {
      it("should use validators defined in html", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var form = new ControlGroup({"login": new Control("aa")});
        var t = '''<div [ng-form-model]="form">
                  <input type="text" ng-control="login" required>
                 </div>''';
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
          rootTC.componentInstance.form = form;
          rootTC.detectChanges();
          expect(form.valid).toEqual(true);
          var input = rootTC.query(By.css("input"));
          input.nativeElement.value = "";
          dispatchEvent(input.nativeElement, "change");
          expect(form.valid).toEqual(false);
          async.done();
        });
      }));
      it("should use validators defined in the model", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var form =
            new ControlGroup({"login": new Control("aa", Validators.required)});
        var t = '''<div [ng-form-model]="form">
                  <input type="text" ng-control="login">
                 </div>''';
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
          rootTC.componentInstance.form = form;
          rootTC.detectChanges();
          expect(form.valid).toEqual(true);
          var input = rootTC.query(By.css("input"));
          input.nativeElement.value = "";
          dispatchEvent(input.nativeElement, "change");
          expect(form.valid).toEqual(false);
          async.done();
        });
      }));
    });
    describe("nested forms", () {
      it("should init DOM with the given form object", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var form = new ControlGroup(
            {"nested": new ControlGroup({"login": new Control("value")})});
        var t = '''<div [ng-form-model]="form">
                  <div ng-control-group="nested">
                    <input type="text" ng-control="login">
                  </div>
              </div>''';
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
          rootTC.componentInstance.form = form;
          rootTC.detectChanges();
          var input = rootTC.query(By.css("input"));
          expect(input.nativeElement.value).toEqual("value");
          async.done();
        });
      }));
      it("should update the control group values on DOM change", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var form = new ControlGroup(
            {"nested": new ControlGroup({"login": new Control("value")})});
        var t = '''<div [ng-form-model]="form">
                    <div ng-control-group="nested">
                      <input type="text" ng-control="login">
                    </div>
                </div>''';
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
          rootTC.componentInstance.form = form;
          rootTC.detectChanges();
          var input = rootTC.query(By.css("input"));
          input.nativeElement.value = "updatedValue";
          dispatchEvent(input.nativeElement, "change");
          expect(form.value).toEqual({"nested": {"login": "updatedValue"}});
          async.done();
        });
      }));
    });
    it("should support ng-model for complex forms", inject(
        [TestComponentBuilder], fakeAsync((TestComponentBuilder tcb) {
      var form = new ControlGroup({"name": new Control("")});
      var t =
          '''<div [ng-form-model]="form"><input type="text" ng-control="name" [(ng-model)]="name"></div>''';
      var rootTC;
      tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((root) {
        rootTC = root;
      });
      tick();
      rootTC.componentInstance.name = "oldValue";
      rootTC.componentInstance.form = form;
      rootTC.detectChanges();
      var input = rootTC.query(By.css("input")).nativeElement;
      expect(input.value).toEqual("oldValue");
      input.value = "updatedValue";
      dispatchEvent(input, "change");
      tick();
      expect(rootTC.componentInstance.name).toEqual("updatedValue");
    })));
    it("should support ng-model for single fields", inject(
        [TestComponentBuilder], fakeAsync((TestComponentBuilder tcb) {
      var form = new Control("");
      var t =
          '''<div><input type="text" [ng-form-control]="form" [(ng-model)]="name"></div>''';
      var rootTC;
      tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((root) {
        rootTC = root;
      });
      tick();
      rootTC.componentInstance.form = form;
      rootTC.componentInstance.name = "oldValue";
      rootTC.detectChanges();
      var input = rootTC.query(By.css("input")).nativeElement;
      expect(input.value).toEqual("oldValue");
      input.value = "updatedValue";
      dispatchEvent(input, "change");
      tick();
      expect(rootTC.componentInstance.name).toEqual("updatedValue");
    })));
    describe("template-driven forms", () {
      it("should add new controls and control groups", inject(
          [TestComponentBuilder], fakeAsync((TestComponentBuilder tcb) {
        var t = '''<form>
                     <div ng-control-group="user">
                      <input type="text" ng-control="login">
                     </div>
               </form>''';
        var rootTC;
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((root) {
          rootTC = root;
        });
        tick();
        rootTC.componentInstance.name = null;
        rootTC.detectChanges();
        var form = rootTC.componentViewChildren[0].inject(NgForm);
        expect(form.controls["user"]).not.toBeDefined();
        tick();
        expect(form.controls["user"]).toBeDefined();
        expect(form.controls["user"].controls["login"]).toBeDefined();
      })));
      it("should emit ng-submit event on submit", inject([TestComponentBuilder],
          fakeAsync((TestComponentBuilder tcb) {
        var t = '''<div><form (ng-submit)="name=\'updated\'"></form></div>''';
        var rootTC;
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((root) {
          rootTC = root;
        });
        tick();
        rootTC.componentInstance.name = "old";
        var form = rootTC.query(By.css("form"));
        dispatchEvent(form.nativeElement, "submit");
        tick();
        expect(rootTC.componentInstance.name).toEqual("updated");
      })));
      it("should not create a template-driven form when ng-no-form is used",
          inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var t = '''<form ng-no-form>
               </form>''';
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
          rootTC.componentInstance.name = null;
          rootTC.detectChanges();
          expect(rootTC.componentViewChildren.length).toEqual(0);
          async.done();
        });
      }));
      it("should remove controls", inject([TestComponentBuilder],
          fakeAsync((TestComponentBuilder tcb) {
        var t = '''<form>
                    <div *ng-if="name == \'show\'">
                      <input type="text" ng-control="login">
                    </div>
                  </form>''';
        var rootTC;
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((root) {
          rootTC = root;
        });
        tick();
        rootTC.componentInstance.name = "show";
        rootTC.detectChanges();
        tick();
        var form = rootTC.componentViewChildren[0].inject(NgForm);
        expect(form.controls["login"]).toBeDefined();
        rootTC.componentInstance.name = "hide";
        rootTC.detectChanges();
        tick();
        expect(form.controls["login"]).not.toBeDefined();
      })));
      it("should remove control groups", inject([TestComponentBuilder],
          fakeAsync((TestComponentBuilder tcb) {
        var t = '''<form>
                     <div *ng-if="name==\'show\'" ng-control-group="user">
                      <input type="text" ng-control="login">
                     </div>
               </form>''';
        var rootTC;
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((root) {
          rootTC = root;
        });
        tick();
        rootTC.componentInstance.name = "show";
        rootTC.detectChanges();
        tick();
        var form = rootTC.componentViewChildren[0].inject(NgForm);
        expect(form.controls["user"]).toBeDefined();
        rootTC.componentInstance.name = "hide";
        rootTC.detectChanges();
        tick();
        expect(form.controls["user"]).not.toBeDefined();
      })));
      it("should support ng-model for complex forms", inject(
          [TestComponentBuilder], fakeAsync((TestComponentBuilder tcb) {
        var t = '''<form>
                      <input type="text" ng-control="name" [(ng-model)]="name">
               </form>''';
        var rootTC;
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((root) {
          rootTC = root;
        });
        tick();
        rootTC.componentInstance.name = "oldValue";
        rootTC.detectChanges();
        tick();
        var input = rootTC.query(By.css("input")).nativeElement;
        expect(input.value).toEqual("oldValue");
        input.value = "updatedValue";
        dispatchEvent(input, "change");
        tick();
        expect(rootTC.componentInstance.name).toEqual("updatedValue");
      })));
      it("should support ng-model for single fields", inject(
          [TestComponentBuilder], fakeAsync((TestComponentBuilder tcb) {
        var t = '''<div><input type="text" [(ng-model)]="name"></div>''';
        var rootTC;
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((root) {
          rootTC = root;
        });
        tick();
        rootTC.componentInstance.name = "oldValue";
        rootTC.detectChanges();
        var input = rootTC.query(By.css("input")).nativeElement;
        expect(input.value).toEqual("oldValue");
        input.value = "updatedValue";
        dispatchEvent(input, "change");
        tick();
        expect(rootTC.componentInstance.name).toEqual("updatedValue");
      })));
    });
    describe("setting status classes", () {
      it("should work with single fields", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var form = new Control("", Validators.required);
        var t = '''<div><input type="text" [ng-form-control]="form"></div>''';
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
          rootTC.componentInstance.form = form;
          rootTC.detectChanges();
          var input = rootTC.query(By.css("input")).nativeElement;
          expect(DOM.classList(input)).toEqual(
              ["ng-binding", "ng-invalid", "ng-pristine", "ng-untouched"]);
          dispatchEvent(input, "blur");
          rootTC.detectChanges();
          expect(DOM.classList(input)).toEqual(
              ["ng-binding", "ng-invalid", "ng-pristine", "ng-touched"]);
          input.value = "updatedValue";
          dispatchEvent(input, "change");
          rootTC.detectChanges();
          expect(DOM.classList(input))
              .toEqual(["ng-binding", "ng-touched", "ng-dirty", "ng-valid"]);
          async.done();
        });
      }));
      it("should work with complex model-driven forms", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var form =
            new ControlGroup({"name": new Control("", Validators.required)});
        var t =
            '''<form [ng-form-model]="form"><input type="text" ng-control="name"></form>''';
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
          rootTC.componentInstance.form = form;
          rootTC.detectChanges();
          var input = rootTC.query(By.css("input")).nativeElement;
          expect(DOM.classList(input)).toEqual(
              ["ng-binding", "ng-invalid", "ng-pristine", "ng-untouched"]);
          dispatchEvent(input, "blur");
          rootTC.detectChanges();
          expect(DOM.classList(input)).toEqual(
              ["ng-binding", "ng-invalid", "ng-pristine", "ng-touched"]);
          input.value = "updatedValue";
          dispatchEvent(input, "change");
          rootTC.detectChanges();
          expect(DOM.classList(input))
              .toEqual(["ng-binding", "ng-touched", "ng-dirty", "ng-valid"]);
          async.done();
        });
      }));
      it("should work with ng-model", inject([
        TestComponentBuilder,
        AsyncTestCompleter
      ], (TestComponentBuilder tcb, async) {
        var t = '''<div><input [(ng-model)]="name" required></div>''';
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((rootTC) {
          rootTC.componentInstance.name = "";
          rootTC.detectChanges();
          var input = rootTC.query(By.css("input")).nativeElement;
          expect(DOM.classList(input)).toEqual(
              ["ng-binding", "ng-invalid", "ng-pristine", "ng-untouched"]);
          dispatchEvent(input, "blur");
          rootTC.detectChanges();
          expect(DOM.classList(input)).toEqual(
              ["ng-binding", "ng-invalid", "ng-pristine", "ng-touched"]);
          input.value = "updatedValue";
          dispatchEvent(input, "change");
          rootTC.detectChanges();
          expect(DOM.classList(input))
              .toEqual(["ng-binding", "ng-touched", "ng-dirty", "ng-valid"]);
          async.done();
        });
      }));
    });
    describe("ng-model corner cases", () {
      it("should not update the view when the value initially came from the view",
          inject([TestComponentBuilder], fakeAsync((TestComponentBuilder tcb) {
        var form = new Control("");
        var t =
            '''<div><input type="text" [ng-form-control]="form" [(ng-model)]="name"></div>''';
        var rootTC;
        tcb.overrideTemplate(MyComp, t).createAsync(MyComp).then((root) {
          rootTC = root;
        });
        tick();
        rootTC.componentInstance.form = form;
        rootTC.detectChanges();
        var input = rootTC.query(By.css("input")).nativeElement;
        input.value = "aa";
        input.selectionStart = 1;
        dispatchEvent(input, "change");
        tick();
        rootTC.detectChanges();
        // selection start has not changed because we did not reset the value
        expect(input.selectionStart).toEqual(1);
      })));
    });
  });
}
@Directive(
    selector: "[wrapped-value]",
    host: const {
  "(change)": "handleOnChange(\$event.target.value)",
  "[value]": "value"
})
class WrappedValue implements ControlValueAccessor {
  var value;
  Function onChange;
  WrappedValue(NgControl cd) {
    cd.valueAccessor = this;
  }
  writeValue(value) {
    this.value = '''!${ value}!''';
  }
  registerOnChange(fn) {
    this.onChange = fn;
  }
  registerOnTouched(fn) {}
  handleOnChange(value) {
    this.onChange(value.substring(1, value.length - 1));
  }
}
@Component(selector: "my-comp")
@View(directives: const [formDirectives, WrappedValue, NgIf, NgFor])
class MyComp {
  dynamic form;
  String name;
  dynamic data;
}
