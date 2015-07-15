///<reference path="../../src/change_detection/pipes/pipe.ts"/>
library angular2.test.change_detection.change_detector_spec;

import "package:angular2/test_lib.dart"
    show
        ddescribe,
        describe,
        it,
        iit,
        xit,
        expect,
        beforeEach,
        afterEach,
        IS_DARTIUM;
import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, isJsObject, BaseException, FunctionWrapper;
import "package:angular2/src/facade/collection.dart"
    show List, ListWrapper, MapWrapper, StringMapWrapper;
import "package:angular2/change_detection.dart"
    show
        ChangeDispatcher,
        DehydratedException,
        DynamicChangeDetector,
        ChangeDetectionError,
        BindingRecord,
        DirectiveRecord,
        DirectiveIndex,
        Pipes,
        Pipe,
        CHECK_ALWAYS,
        CHECK_ONCE,
        CHECKED,
        DETACHED,
        ON_PUSH,
        DEFAULT,
        WrappedValue,
        DynamicProtoChangeDetector,
        ChangeDetectorDefinition,
        Lexer,
        Parser,
        Locals,
        ProtoChangeDetector;
import "package:angular2/src/change_detection/jit_proto_change_detector.dart"
    show JitProtoChangeDetector;
import "change_detector_config.dart" show getDefinition;
import "generated/change_detector_classes.dart" show getFactoryById;

const _DEFAULT_CONTEXT = const Object();
/**
 * Tests in this spec run against three different implementations of `AbstractChangeDetector`,
 * `dynamic` (which use reflection to inspect objects), `JIT` (which are generated only for
 * Javascript at runtime using `eval`) and `Pregen` (which are generated only for Dart prior
 * to app deploy to avoid the need for reflection).
 *
 * Pre-generated classes require knowledge of the shape of the change detector at the time of Dart
 * transformation, so in these tests we abstract a `ChangeDetectorDefinition` out into the
 * change_detector_config library and define a build step which pre-generates the necessary change
 * detectors to execute these tests. Once that built step has run, those generated change detectors
 * can be found in the generated/change_detector_classes library.
 */
main() {
  ListWrapper.forEach(["dynamic", "JIT", "Pregen"], (cdType) {
    if (cdType == "JIT" && IS_DARTIUM) return;
    if (cdType == "Pregen" && !IS_DARTIUM) return;
    describe('''${ cdType} Change Detector''', () {
      _getProtoChangeDetector(ChangeDetectorDefinition def) {
        switch (cdType) {
          case "dynamic":
            return new DynamicProtoChangeDetector(def);
          case "JIT":
            return new JitProtoChangeDetector(def);
          case "Pregen":
            return getFactoryById(def.id)(def);
          default:
            return null;
        }
      }
      _createWithoutHydrate(String expression) {
        var dispatcher = new TestDispatcher();
        var cd = _getProtoChangeDetector(getDefinition(expression).cdDef)
            .instantiate(dispatcher);
        return new _ChangeDetectorAndDispatcher(cd, dispatcher);
      }
      _createChangeDetector(String expression,
          [context = _DEFAULT_CONTEXT, registry = null]) {
        var dispatcher = new TestDispatcher();
        var testDef = getDefinition(expression);
        var protoCd = _getProtoChangeDetector(testDef.cdDef);
        var cd = protoCd.instantiate(dispatcher);
        cd.hydrate(context, testDef.locals, null, registry);
        return new _ChangeDetectorAndDispatcher(cd, dispatcher);
      }
      _bindSimpleValue(String expression, [context = _DEFAULT_CONTEXT]) {
        var val = _createChangeDetector(expression, context);
        val.changeDetector.detectChanges();
        return val.dispatcher.log;
      }
      it("should support literals", () {
        expect(_bindSimpleValue("10")).toEqual(["propName=10"]);
      });
      it("should strip quotes from literals", () {
        expect(_bindSimpleValue("\"str\"")).toEqual(["propName=str"]);
      });
      it("should support newlines in literals", () {
        expect(_bindSimpleValue("\"a\n\nb\"")).toEqual(["propName=a\n\nb"]);
      });
      it("should support + operations", () {
        expect(_bindSimpleValue("10 + 2")).toEqual(["propName=12"]);
      });
      it("should support - operations", () {
        expect(_bindSimpleValue("10 - 2")).toEqual(["propName=8"]);
      });
      it("should support * operations", () {
        expect(_bindSimpleValue("10 * 2")).toEqual(["propName=20"]);
      });
      it("should support / operations", () {
        expect(_bindSimpleValue("10 / 2")).toEqual(['''propName=${ 5.0}''']);
      });
      it("should support % operations", () {
        expect(_bindSimpleValue("11 % 2")).toEqual(["propName=1"]);
      });
      it("should support == operations on identical", () {
        expect(_bindSimpleValue("1 == 1")).toEqual(["propName=true"]);
      });
      it("should support != operations", () {
        expect(_bindSimpleValue("1 != 1")).toEqual(["propName=false"]);
      });
      it("should support == operations on coerceible", () {
        var expectedValue = IS_DARTIUM ? "false" : "true";
        expect(_bindSimpleValue("1 == true"))
            .toEqual(['''propName=${ expectedValue}''']);
      });
      it("should support === operations on identical", () {
        expect(_bindSimpleValue("1 === 1")).toEqual(["propName=true"]);
      });
      it("should support !== operations", () {
        expect(_bindSimpleValue("1 !== 1")).toEqual(["propName=false"]);
      });
      it("should support === operations on coerceible", () {
        expect(_bindSimpleValue("1 === true")).toEqual(["propName=false"]);
      });
      it("should support true < operations", () {
        expect(_bindSimpleValue("1 < 2")).toEqual(["propName=true"]);
      });
      it("should support false < operations", () {
        expect(_bindSimpleValue("2 < 1")).toEqual(["propName=false"]);
      });
      it("should support false > operations", () {
        expect(_bindSimpleValue("1 > 2")).toEqual(["propName=false"]);
      });
      it("should support true > operations", () {
        expect(_bindSimpleValue("2 > 1")).toEqual(["propName=true"]);
      });
      it("should support true <= operations", () {
        expect(_bindSimpleValue("1 <= 2")).toEqual(["propName=true"]);
      });
      it("should support equal <= operations", () {
        expect(_bindSimpleValue("2 <= 2")).toEqual(["propName=true"]);
      });
      it("should support false <= operations", () {
        expect(_bindSimpleValue("2 <= 1")).toEqual(["propName=false"]);
      });
      it("should support true >= operations", () {
        expect(_bindSimpleValue("2 >= 1")).toEqual(["propName=true"]);
      });
      it("should support equal >= operations", () {
        expect(_bindSimpleValue("2 >= 2")).toEqual(["propName=true"]);
      });
      it("should support false >= operations", () {
        expect(_bindSimpleValue("1 >= 2")).toEqual(["propName=false"]);
      });
      it("should support true && operations", () {
        expect(_bindSimpleValue("true && true")).toEqual(["propName=true"]);
      });
      it("should support false && operations", () {
        expect(_bindSimpleValue("true && false")).toEqual(["propName=false"]);
      });
      it("should support true || operations", () {
        expect(_bindSimpleValue("true || false")).toEqual(["propName=true"]);
      });
      it("should support false || operations", () {
        expect(_bindSimpleValue("false || false")).toEqual(["propName=false"]);
      });
      it("should support negate", () {
        expect(_bindSimpleValue("!true")).toEqual(["propName=false"]);
      });
      it("should support double negate", () {
        expect(_bindSimpleValue("!!true")).toEqual(["propName=true"]);
      });
      it("should support true conditionals", () {
        expect(_bindSimpleValue("1 < 2 ? 1 : 2")).toEqual(["propName=1"]);
      });
      it("should support false conditionals", () {
        expect(_bindSimpleValue("1 > 2 ? 1 : 2")).toEqual(["propName=2"]);
      });
      it("should support keyed access to a list item", () {
        expect(_bindSimpleValue("[\"foo\", \"bar\"][0]"))
            .toEqual(["propName=foo"]);
      });
      it("should support keyed access to a map item", () {
        expect(_bindSimpleValue("{\"foo\": \"bar\"}[\"foo\"]"))
            .toEqual(["propName=bar"]);
      });
      it("should report all changes on the first run including uninitialized values",
          () {
        expect(_bindSimpleValue("value", new Uninitialized()))
            .toEqual(["propName=null"]);
      });
      it("should report all changes on the first run including null values",
          () {
        var td = new TestData(null);
        expect(_bindSimpleValue("a", td)).toEqual(["propName=null"]);
      });
      it("should support simple chained property access", () {
        var address = new Address("Grenoble");
        var person = new Person("Victor", address);
        expect(_bindSimpleValue("address.city", person))
            .toEqual(["propName=Grenoble"]);
      });
      it("should support the safe navigation operator", () {
        var person = new Person("Victor", null);
        expect(_bindSimpleValue("address?.city", person))
            .toEqual(["propName=null"]);
        expect(_bindSimpleValue("address?.toString()", person))
            .toEqual(["propName=null"]);
        person.address = new Address("MTV");
        expect(_bindSimpleValue("address?.city", person))
            .toEqual(["propName=MTV"]);
        expect(_bindSimpleValue("address?.toString()", person))
            .toEqual(["propName=MTV"]);
      });
      it("should support method calls", () {
        var person = new Person("Victor");
        expect(_bindSimpleValue("sayHi(\"Jim\")", person))
            .toEqual(["propName=Hi, Jim"]);
      });
      it("should support function calls", () {
        var td = new TestData(() => (a) => a);
        expect(_bindSimpleValue("a()(99)", td)).toEqual(["propName=99"]);
      });
      it("should support chained method calls", () {
        var person = new Person("Victor");
        var td = new TestData(person);
        expect(_bindSimpleValue("a.sayHi(\"Jim\")", td))
            .toEqual(["propName=Hi, Jim"]);
      });
      it("should do simple watching", () {
        var person = new Person("misko");
        var val = _createChangeDetector("name", person);
        val.changeDetector.detectChanges();
        expect(val.dispatcher.log).toEqual(["propName=misko"]);
        val.dispatcher.clear();
        val.changeDetector.detectChanges();
        expect(val.dispatcher.log).toEqual([]);
        val.dispatcher.clear();
        person.name = "Misko";
        val.changeDetector.detectChanges();
        expect(val.dispatcher.log).toEqual(["propName=Misko"]);
      });
      it("should support literal array", () {
        var val = _createChangeDetector("[1, 2]");
        val.changeDetector.detectChanges();
        expect(val.dispatcher.loggedValues).toEqual([[1, 2]]);
        val = _createChangeDetector("[1, a]", new TestData(2));
        val.changeDetector.detectChanges();
        expect(val.dispatcher.loggedValues).toEqual([[1, 2]]);
      });
      it("should support literal maps", () {
        var val = _createChangeDetector("{z: 1}");
        val.changeDetector.detectChanges();
        expect(val.dispatcher.loggedValues[0]["z"]).toEqual(1);
        val = _createChangeDetector("{z: a}", new TestData(1));
        val.changeDetector.detectChanges();
        expect(val.dispatcher.loggedValues[0]["z"]).toEqual(1);
      });
      it("should support interpolation", () {
        var val = _createChangeDetector("interpolation", new TestData("value"));
        val.changeDetector.hydrate(new TestData("value"), null, null, null);
        val.changeDetector.detectChanges();
        expect(val.dispatcher.log).toEqual(["propName=BvalueA"]);
      });
      describe("pure functions", () {
        it("should preserve memoized result", () {
          var person = new Person("bob");
          var val = _createChangeDetector("passThrough([12])", person);
          val.changeDetector.detectChanges();
          val.changeDetector.detectChanges();
          expect(val.dispatcher.loggedValues).toEqual([[12]]);
        });
      });
      describe("change notification", () {
        describe("simple checks", () {
          it("should pass a change record to the dispatcher", () {
            var person = new Person("bob");
            var val = _createChangeDetector("name", person);
            val.changeDetector.detectChanges();
            expect(val.dispatcher.loggedValues).toEqual(["bob"]);
          });
        });
        describe("pipes", () {
          it("should pass a change record to the dispatcher", () {
            var registry = new FakePipes("pipe", () => new CountingPipe());
            var person = new Person("bob");
            var val = _createChangeDetector("name | pipe", person, registry);
            val.changeDetector.detectChanges();
            expect(val.dispatcher.loggedValues).toEqual(["bob state:0"]);
          });
          it("should support arguments in pipes", () {
            var registry = new FakePipes("pipe", () => new MultiArgPipe());
            var address = new Address("two");
            var person = new Person("value", address);
            var val = _createChangeDetector(
                "name | pipe:'one':address.city", person, registry);
            val.changeDetector.detectChanges();
            expect(val.dispatcher.loggedValues)
                .toEqual(["value one two default"]);
          });
        });
        it("should notify the dispatcher on all changes done", () {
          var val = _createChangeDetector("name", new Person("bob"));
          val.changeDetector.detectChanges();
          expect(val.dispatcher.onAllChangesDoneCalled).toEqual(true);
        });
        describe("updating directives", () {
          var directive1;
          var directive2;
          beforeEach(() {
            directive1 = new TestDirective();
            directive2 = new TestDirective();
          });
          it("should happen directly, without invoking the dispatcher", () {
            var val = _createWithoutHydrate("directNoDispatcher");
            val.changeDetector.hydrate(_DEFAULT_CONTEXT, null,
                new FakeDirectives([directive1], []), null);
            val.changeDetector.detectChanges();
            expect(val.dispatcher.loggedValues).toEqual([]);
            expect(directive1.a).toEqual(42);
          });
          describe("onChange", () {
            it("should notify the directive when a group of records changes",
                () {
              var cd = _createWithoutHydrate("groupChanges").changeDetector;
              cd.hydrate(_DEFAULT_CONTEXT, null,
                  new FakeDirectives([directive1, directive2], []), null);
              cd.detectChanges();
              expect(directive1.changes).toEqual({"a": 1, "b": 2});
              expect(directive2.changes).toEqual({"a": 3});
            });
          });
          describe("onCheck", () {
            it("should notify the directive when it is checked", () {
              var cd = _createWithoutHydrate("directiveOnCheck").changeDetector;
              cd.hydrate(_DEFAULT_CONTEXT, null,
                  new FakeDirectives([directive1], []), null);
              cd.detectChanges();
              expect(directive1.onCheckCalled).toBe(true);
              directive1.onCheckCalled = false;
              cd.detectChanges();
              expect(directive1.onCheckCalled).toBe(true);
            });
            it("should not call onCheck in detectNoChanges", () {
              var cd = _createWithoutHydrate("directiveOnCheck").changeDetector;
              cd.hydrate(_DEFAULT_CONTEXT, null,
                  new FakeDirectives([directive1], []), null);
              cd.checkNoChanges();
              expect(directive1.onCheckCalled).toBe(false);
            });
          });
          describe("onInit", () {
            it("should notify the directive after it has been checked the first time",
                () {
              var cd = _createWithoutHydrate("directiveOnInit").changeDetector;
              cd.hydrate(_DEFAULT_CONTEXT, null,
                  new FakeDirectives([directive1], []), null);
              cd.detectChanges();
              expect(directive1.onInitCalled).toBe(true);
              directive1.onInitCalled = false;
              cd.detectChanges();
              expect(directive1.onInitCalled).toBe(false);
            });
            it("should not call onInit in detectNoChanges", () {
              var cd = _createWithoutHydrate("directiveOnInit").changeDetector;
              cd.hydrate(_DEFAULT_CONTEXT, null,
                  new FakeDirectives([directive1], []), null);
              cd.checkNoChanges();
              expect(directive1.onInitCalled).toBe(false);
            });
          });
          describe("onAllChangesDone", () {
            it("should be called after processing all the children", () {
              var cd = _createWithoutHydrate(
                  "emptyWithDirectiveRecords").changeDetector;
              cd.hydrate(_DEFAULT_CONTEXT, null,
                  new FakeDirectives([directive1, directive2], []), null);
              cd.detectChanges();
              expect(directive1.onChangesDoneCalled).toBe(true);
              expect(directive2.onChangesDoneCalled).toBe(true);
              // reset directives
              directive1.onChangesDoneCalled = false;
              directive2.onChangesDoneCalled = false;
              // Verify that checking should not call them.
              cd.checkNoChanges();
              expect(directive1.onChangesDoneCalled).toBe(false);
              expect(directive2.onChangesDoneCalled).toBe(false);
              // re-verify that changes are still detected
              cd.detectChanges();
              expect(directive1.onChangesDoneCalled).toBe(true);
              expect(directive2.onChangesDoneCalled).toBe(true);
            });
            it("should not be called when onAllChangesDone is false", () {
              var cd = _createWithoutHydrate("noCallbacks").changeDetector;
              cd.hydrate(_DEFAULT_CONTEXT, null,
                  new FakeDirectives([directive1], []), null);
              cd.detectChanges();
              expect(directive1.onChangesDoneCalled).toEqual(false);
            });
            it("should be called in reverse order so the child is always notified before the parent",
                () {
              var cd = _createWithoutHydrate(
                  "emptyWithDirectiveRecords").changeDetector;
              var onChangesDoneCalls = [];
              var td1;
              td1 = new TestDirective(() => onChangesDoneCalls.add(td1));
              var td2;
              td2 = new TestDirective(() => onChangesDoneCalls.add(td2));
              cd.hydrate(_DEFAULT_CONTEXT, null,
                  new FakeDirectives([td1, td2], []), null);
              cd.detectChanges();
              expect(onChangesDoneCalls).toEqual([td2, td1]);
            });
            it("should be called before processing shadow dom children", () {
              var parent =
                  _createWithoutHydrate("directNoDispatcher").changeDetector;
              var child =
                  _createWithoutHydrate("directNoDispatcher").changeDetector;
              parent.addShadowDomChild(child);
              var orderOfOperations = [];
              var directiveInShadowDom = null;
              directiveInShadowDom = new TestDirective(() {
                orderOfOperations.add(directiveInShadowDom);
              });
              var parentDirective = null;
              parentDirective = new TestDirective(() {
                orderOfOperations.add(parentDirective);
              });
              parent.hydrate(_DEFAULT_CONTEXT, null,
                  new FakeDirectives([parentDirective], []), null);
              child.hydrate(_DEFAULT_CONTEXT, null,
                  new FakeDirectives([directiveInShadowDom], []), null);
              parent.detectChanges();
              expect(orderOfOperations)
                  .toEqual([parentDirective, directiveInShadowDom]);
            });
          });
        });
      });
      describe("reading directives", () {
        it("should read directive properties", () {
          var directive = new TestDirective();
          directive.a = "aaa";
          var val = _createWithoutHydrate("readingDirectives");
          val.changeDetector.hydrate(_DEFAULT_CONTEXT, null,
              new FakeDirectives([directive], []), null);
          val.changeDetector.detectChanges();
          expect(val.dispatcher.loggedValues).toEqual(["aaa"]);
        });
      });
      describe("enforce no new changes", () {
        it("should throw when a record gets changed after it has been checked",
            () {
          var val = _createChangeDetector("a", new TestData("value"));
          expect(() {
            val.changeDetector.checkNoChanges();
          }).toThrowError(new RegExp(
              "Expression ['\"]a in location['\"] has changed after it was checked"));
        });
        it("should not break the next run", () {
          var val = _createChangeDetector("a", new TestData("value"));
          expect(() =>
              val.changeDetector.checkNoChanges()).toThrowError(new RegExp(
              "Expression ['\"]a in location['\"] has changed after it was checked."));
          val.changeDetector.detectChanges();
          expect(val.dispatcher.loggedValues).toEqual(["value"]);
        });
      });
      describe("error handling", () {
        it("should wrap exceptions into ChangeDetectionError", () {
          var val = _createChangeDetector("invalidFn(1)");
          try {
            val.changeDetector.detectChanges();
            throw new BaseException("fail");
          } catch (e, e_stack) {
            expect(e).toBeAnInstanceOf(ChangeDetectionError);
            expect(e.location).toEqual("invalidFn(1) in location");
          }
        });
      });
      describe("Locals", () {
        it("should read a value from locals", () {
          expect(_bindSimpleValue("valueFromLocals"))
              .toEqual(["propName=value"]);
        });
        it("should invoke a function from local", () {
          expect(_bindSimpleValue("functionFromLocals"))
              .toEqual(["propName=value"]);
        });
        it("should handle nested locals", () {
          expect(_bindSimpleValue("nestedLocals")).toEqual(["propName=value"]);
        });
        it("should fall back to a regular field read when the locals map" +
            "does not have the requested field", () {
          expect(_bindSimpleValue("fallbackLocals", new Person("Jim")))
              .toEqual(["propName=Jim"]);
        });
        it("should correctly handle nested properties", () {
          var address = new Address("Grenoble");
          var person = new Person("Victor", address);
          expect(_bindSimpleValue("contextNestedPropertyWithLocals", person))
              .toEqual(["propName=Grenoble"]);
          expect(_bindSimpleValue("localPropertyWithSimilarContext", person))
              .toEqual(["propName=MTV"]);
        });
      });
      describe("handle children", () {
        var parent, child;
        beforeEach(() {
          parent = _createChangeDetector("10").changeDetector;
          child = _createChangeDetector("\"str\"").changeDetector;
        });
        it("should add light dom children", () {
          parent.addChild(child);
          expect(parent.lightDomChildren.length).toEqual(1);
          expect(parent.lightDomChildren[0]).toBe(child);
        });
        it("should add shadow dom children", () {
          parent.addShadowDomChild(child);
          expect(parent.shadowDomChildren.length).toEqual(1);
          expect(parent.shadowDomChildren[0]).toBe(child);
        });
        it("should remove light dom children", () {
          parent.addChild(child);
          parent.removeChild(child);
          expect(parent.lightDomChildren).toEqual([]);
        });
        it("should remove shadow dom children", () {
          parent.addShadowDomChild(child);
          parent.removeShadowDomChild(child);
          expect(parent.shadowDomChildren.length).toEqual(0);
        });
      });
      describe("mode", () {
        it("should set the mode to CHECK_ALWAYS when the default change detection is used",
            () {
          var cd =
              _createWithoutHydrate("emptyUsingDefaultStrategy").changeDetector;
          expect(cd.mode).toEqual(null);
          cd.hydrate(_DEFAULT_CONTEXT, null, null, null);
          expect(cd.mode).toEqual(CHECK_ALWAYS);
        });
        it("should set the mode to CHECK_ONCE when the push change detection is used",
            () {
          var cd =
              _createWithoutHydrate("emptyUsingOnPushStrategy").changeDetector;
          cd.hydrate(_DEFAULT_CONTEXT, null, null, null);
          expect(cd.mode).toEqual(CHECK_ONCE);
        });
        it("should not check a detached change detector", () {
          var val = _createChangeDetector("a", new TestData("value"));
          val.changeDetector.hydrate(_DEFAULT_CONTEXT, null, null, null);
          val.changeDetector.mode = DETACHED;
          val.changeDetector.detectChanges();
          expect(val.dispatcher.log).toEqual([]);
        });
        it("should not check a checked change detector", () {
          var val = _createChangeDetector("a", new TestData("value"));
          val.changeDetector.hydrate(_DEFAULT_CONTEXT, null, null, null);
          val.changeDetector.mode = CHECKED;
          val.changeDetector.detectChanges();
          expect(val.dispatcher.log).toEqual([]);
        });
        it("should change CHECK_ONCE to CHECKED", () {
          var cd = _createChangeDetector("10").changeDetector;
          cd.hydrate(_DEFAULT_CONTEXT, null, null, null);
          cd.mode = CHECK_ONCE;
          cd.detectChanges();
          expect(cd.mode).toEqual(CHECKED);
        });
        it("should not change the CHECK_ALWAYS", () {
          var cd = _createChangeDetector("10").changeDetector;
          cd.hydrate(_DEFAULT_CONTEXT, null, null, null);
          cd.mode = CHECK_ALWAYS;
          cd.detectChanges();
          expect(cd.mode).toEqual(CHECK_ALWAYS);
        });
        describe("marking ON_PUSH detectors as CHECK_ONCE after an update", () {
          var checkedDetector;
          var directives;
          beforeEach(() {
            checkedDetector = _createWithoutHydrate(
                "emptyUsingOnPushStrategy").changeDetector;
            checkedDetector.hydrate(_DEFAULT_CONTEXT, null, null, null);
            checkedDetector.mode = CHECKED;
            var targetDirective = new TestData(null);
            directives =
                new FakeDirectives([targetDirective], [checkedDetector]);
          });
          it("should set the mode to CHECK_ONCE when a binding is updated", () {
            var cd = _createWithoutHydrate(
                "onPushRecordsUsingDefaultStrategy").changeDetector;
            cd.hydrate(_DEFAULT_CONTEXT, null, directives, null);
            expect(checkedDetector.mode).toEqual(CHECKED);
            // evaluate the record, update the targetDirective, and mark its detector as

            // CHECK_ONCE
            cd.detectChanges();
            expect(checkedDetector.mode).toEqual(CHECK_ONCE);
          });
        });
      });
      describe("markPathToRootAsCheckOnce", () {
        changeDetector(mode, parent) {
          var val = _createChangeDetector("10");
          val.changeDetector.mode = mode;
          if (isPresent(parent)) parent.addChild(val.changeDetector);
          return val.changeDetector;
        }
        it("should mark all checked detectors as CHECK_ONCE until reaching a detached one",
            () {
          var root = changeDetector(CHECK_ALWAYS, null);
          var disabled = changeDetector(DETACHED, root);
          var parent = changeDetector(CHECKED, disabled);
          var checkAlwaysChild = changeDetector(CHECK_ALWAYS, parent);
          var checkOnceChild = changeDetector(CHECK_ONCE, checkAlwaysChild);
          var checkedChild = changeDetector(CHECKED, checkOnceChild);
          checkedChild.markPathToRootAsCheckOnce();
          expect(root.mode).toEqual(CHECK_ALWAYS);
          expect(disabled.mode).toEqual(DETACHED);
          expect(parent.mode).toEqual(CHECK_ONCE);
          expect(checkAlwaysChild.mode).toEqual(CHECK_ALWAYS);
          expect(checkOnceChild.mode).toEqual(CHECK_ONCE);
          expect(checkedChild.mode).toEqual(CHECK_ONCE);
        });
      });
      describe("hydration", () {
        it("should be able to rehydrate a change detector", () {
          var cd = _createChangeDetector("name").changeDetector;
          cd.hydrate("some context", null, null, null);
          expect(cd.hydrated()).toBe(true);
          cd.dehydrate();
          expect(cd.hydrated()).toBe(false);
          cd.hydrate("other context", null, null, null);
          expect(cd.hydrated()).toBe(true);
        });
        it("should destroy all active pipes during dehyration", () {
          var pipe = new OncePipe();
          var registry = new FakePipes("pipe", () => pipe);
          var cd = _createChangeDetector(
              "name | pipe", new Person("bob"), registry).changeDetector;
          cd.detectChanges();
          cd.dehydrate();
          expect(pipe.destroyCalled).toBe(true);
        });
        it("should throw when detectChanges is called on a dehydrated detector",
            () {
          var context = new Person("Bob");
          var val = _createChangeDetector("name", context);
          val.changeDetector.detectChanges();
          expect(val.dispatcher.log).toEqual(["propName=Bob"]);
          val.changeDetector.dehydrate();
          var dehydratedException = new DehydratedException();
          expect(() {
            val.changeDetector.detectChanges();
          }).toThrowError(dehydratedException.toString());
          expect(val.dispatcher.log).toEqual(["propName=Bob"]);
        });
      });
      describe("pipes", () {
        it("should support pipes", () {
          var registry = new FakePipes("pipe", () => new CountingPipe());
          var ctx = new Person("Megatron");
          var val = _createChangeDetector("name | pipe", ctx, registry);
          val.changeDetector.detectChanges();
          expect(val.dispatcher.log).toEqual(["propName=Megatron state:0"]);
          val.dispatcher.clear();
          val.changeDetector.detectChanges();
          expect(val.dispatcher.log).toEqual(["propName=Megatron state:1"]);
        });
        it("should lookup pipes in the registry when the context is not supported",
            () {
          var registry = new FakePipes("pipe", () => new OncePipe());
          var ctx = new Person("Megatron");
          var cd = _createChangeDetector(
              "name | pipe", ctx, registry).changeDetector;
          cd.detectChanges();
          expect(registry.numberOfLookups).toEqual(1);
          ctx.name = "Optimus Prime";
          cd.detectChanges();
          expect(registry.numberOfLookups).toEqual(2);
        });
        it("should invoke onDestroy on a pipe before switching to another one",
            () {
          var pipe = new OncePipe();
          var registry = new FakePipes("pipe", () => pipe);
          var ctx = new Person("Megatron");
          var cd = _createChangeDetector(
              "name | pipe", ctx, registry).changeDetector;
          cd.detectChanges();
          ctx.name = "Optimus Prime";
          cd.detectChanges();
          expect(pipe.destroyCalled).toEqual(true);
        });
        it("should inject the ChangeDetectorRef " +
            "of the encompassing component into a pipe", () {
          var registry = new FakePipes("pipe", () => new IdentityPipe());
          var cd = _createChangeDetector(
              "name | pipe", new Person("bob"), registry).changeDetector;
          cd.detectChanges();
          expect(registry.cdRef).toBe(cd.ref);
        });
      });
      it("should do nothing when no change", () {
        var registry = new FakePipes("pipe", () => new IdentityPipe());
        var ctx = new Person("Megatron");
        var val = _createChangeDetector("name | pipe", ctx, registry);
        val.changeDetector.detectChanges();
        expect(val.dispatcher.log).toEqual(["propName=Megatron"]);
        val.dispatcher.clear();
        val.changeDetector.detectChanges();
        expect(val.dispatcher.log).toEqual([]);
      });
      it("should unwrap the wrapped value", () {
        var registry = new FakePipes("pipe", () => new WrappedPipe());
        var ctx = new Person("Megatron");
        var val = _createChangeDetector("name | pipe", ctx, registry);
        val.changeDetector.detectChanges();
        expect(val.dispatcher.log).toEqual(["propName=Megatron"]);
      });
    });
  });
}
class CountingPipe implements Pipe {
  num state = 0;
  onDestroy() {}
  supports(newValue) {
    return true;
  }
  transform(value, [args = null]) {
    return '''${ value} state:${ this . state ++}''';
  }
}
class OncePipe implements Pipe {
  bool called = false;
  bool destroyCalled = false;
  supports(newValue) {
    return !this.called;
  }
  onDestroy() {
    this.destroyCalled = true;
  }
  transform(value, [args = null]) {
    this.called = true;
    return value;
  }
}
class IdentityPipe implements Pipe {
  bool supports(obj) {
    return true;
  }
  onDestroy() {}
  transform(value, [args = null]) {
    return value;
  }
}
class WrappedPipe implements Pipe {
  bool supports(obj) {
    return true;
  }
  onDestroy() {}
  transform(value, [args = null]) {
    return WrappedValue.wrap(value);
  }
}
class MultiArgPipe implements Pipe {
  transform(value, [args = null]) {
    var arg1 = args[0];
    var arg2 = args[1];
    var arg3 = args.length > 2 ? args[2] : "default";
    return '''${ value} ${ arg1} ${ arg2} ${ arg3}''';
  }
  bool supports(obj) {
    return true;
  }
  void onDestroy() {}
}
class FakePipes extends Pipes {
  num numberOfLookups;
  String pipeType;
  Function factory;
  dynamic cdRef;
  FakePipes(pipeType, factory) : super({}) {
    /* super call moved to initializer */;
    this.pipeType = pipeType;
    this.factory = factory;
    this.numberOfLookups = 0;
  }
  get(String type, obj, [cdRef, existingPipe]) {
    if (type != this.pipeType) return null;
    this.numberOfLookups++;
    this.cdRef = cdRef;
    return this.factory();
  }
}
class TestDirective {
  var a;
  var b;
  var changes;
  var onChangesDoneCalled;
  var onChangesDoneSpy;
  var onCheckCalled;
  var onInitCalled;
  TestDirective([onChangesDoneSpy = null]) {
    this.onChangesDoneCalled = false;
    this.onCheckCalled = false;
    this.onInitCalled = false;
    this.onChangesDoneSpy = onChangesDoneSpy;
    this.a = null;
    this.b = null;
    this.changes = null;
  }
  onCheck() {
    this.onCheckCalled = true;
  }
  onInit() {
    this.onInitCalled = true;
  }
  onChange(changes) {
    var r = {};
    StringMapWrapper.forEach(changes, (c, key) => r[key] = c.currentValue);
    this.changes = r;
  }
  onAllChangesDone() {
    this.onChangesDoneCalled = true;
    if (isPresent(this.onChangesDoneSpy)) {
      this.onChangesDoneSpy();
    }
  }
}
class Person {
  String name;
  Address address;
  num age;
  Person(this.name, [this.address = null]) {}
  sayHi(m) {
    return '''Hi, ${ m}''';
  }
  passThrough(val) {
    return val;
  }
  String toString() {
    var address =
        this.address == null ? "" : " address=" + this.address.toString();
    return "name=" + this.name + address;
  }
}
class Address {
  String city;
  Address(this.city) {}
  String toString() {
    return isBlank(this.city) ? "-" : this.city;
  }
}
class Uninitialized {
  dynamic value;
}
class TestData {
  dynamic a;
  TestData(this.a) {}
}
class FakeDirectives {
  List<dynamic /* TestData | TestDirective */ > directives;
  List<ProtoChangeDetector> detectors;
  FakeDirectives(this.directives, this.detectors) {}
  getDirectiveFor(DirectiveIndex di) {
    return this.directives[di.directiveIndex];
  }
  getDetectorFor(DirectiveIndex di) {
    return this.detectors[di.directiveIndex];
  }
}
class TestDispatcher implements ChangeDispatcher {
  List<String> log;
  List<dynamic> loggedValues;
  bool onAllChangesDoneCalled = false;
  TestDispatcher() {
    this.clear();
  }
  clear() {
    this.log = [];
    this.loggedValues = [];
    this.onAllChangesDoneCalled = true;
  }
  notifyOnBinding(binding, value) {
    this.log
        .add('''${ binding . propertyName}=${ this . _asString ( value )}''');
    this.loggedValues.add(value);
  }
  notifyOnAllChangesDone() {
    this.onAllChangesDoneCalled = true;
  }
  _asString(value) {
    return (isBlank(value) ? "null" : value.toString());
  }
}
class _ChangeDetectorAndDispatcher {
  dynamic changeDetector;
  TestDispatcher dispatcher;
  _ChangeDetectorAndDispatcher(this.changeDetector, this.dispatcher) {}
}
