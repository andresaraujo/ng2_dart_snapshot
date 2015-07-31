library angular2.test.core.exception_handler_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        beforeEach,
        ddescribe,
        describe,
        expect,
        iit,
        inject,
        it,
        xdescribe,
        xit,
        IS_DARTIUM,
        Log;
import "package:angular2/src/facade/lang.dart" show BaseException;
import "package:angular2/src/core/exception_handler.dart" show ExceptionHandler;

class _CustomException {
  var context = "some context";
  String toString() {
    return "custom";
  }
}
main() {
  describe("ExceptionHandler", () {
    it("should output exception", () {
      var e = ExceptionHandler.exceptionToString(new BaseException("message!"));
      expect(e).toContain("message!");
    });
    it("should output stackTrace", () {
      var e = ExceptionHandler.exceptionToString(
          new BaseException("message!"), "stack!");
      expect(e).toContain("stack!");
    });
    it("should join a long stackTrace", () {
      var e = ExceptionHandler.exceptionToString(
          new BaseException("message!"), ["stack1", "stack2"]);
      expect(e).toContain("stack1");
      expect(e).toContain("stack2");
    });
    it("should output reason when present", () {
      var e = ExceptionHandler.exceptionToString(
          new BaseException("message!"), null, "reason!");
      expect(e).toContain("reason!");
    });
    describe("context", () {
      it("should print context", () {
        var e = ExceptionHandler.exceptionToString(
            new BaseException("message!", null, null, "context!"));
        expect(e).toContain("context!");
      });
      it("should print nested context", () {
        var original = new BaseException("message!", null, null, "context!");
        var e = ExceptionHandler
            .exceptionToString(new BaseException("message", original));
        expect(e).toContain("context!");
      });
      it("should not print context when the passed-in exception is not a BaseException",
          () {
        var e = ExceptionHandler.exceptionToString(new _CustomException());
        expect(e).not.toContain("context");
      });
    });
    describe("original exception", () {
      it("should print original exception message if available (original is BaseException)",
          () {
        var realOriginal = new BaseException("inner");
        var original = new BaseException("wrapped", realOriginal);
        var e = ExceptionHandler
            .exceptionToString(new BaseException("wrappedwrapped", original));
        expect(e).toContain("inner");
      });
      it("should print original exception message if available (original is not BaseException)",
          () {
        var realOriginal = new _CustomException();
        var original = new BaseException("wrapped", realOriginal);
        var e = ExceptionHandler
            .exceptionToString(new BaseException("wrappedwrapped", original));
        expect(e).toContain("custom");
      });
    });
    describe("original stack", () {
      it("should print original stack if available", () {
        var realOriginal = new BaseException("inner");
        var original =
            new BaseException("wrapped", realOriginal, "originalStack");
        var e = ExceptionHandler.exceptionToString(
            new BaseException("wrappedwrapped", original, "wrappedStack"));
        expect(e).toContain("originalStack");
      });
    });
  });
}
