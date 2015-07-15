library angular2.test.http.base_request_options_spec;

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
        xit;
import "package:angular2/src/http/base_request_options.dart"
    show BaseRequestOptions, RequestOptions;
import "package:angular2/src/http/enums.dart"
    show RequestMethods, RequestModesOpts;

main() {
  describe("BaseRequestOptions", () {
    it("should create a new object when calling merge", () {
      var options1 = new BaseRequestOptions();
      var options2 =
          options1.merge(new RequestOptions(method: RequestMethods.DELETE));
      expect(options2).not.toBe(options1);
      expect(options2.method).toBe(RequestMethods.DELETE);
    });
    it("should retain previously merged values when merging again", () {
      var options1 = new BaseRequestOptions();
      var options2 =
          options1.merge(new RequestOptions(method: RequestMethods.DELETE));
      var options3 =
          options2.merge(new RequestOptions(mode: RequestModesOpts.NoCors));
      expect(options3.mode).toBe(RequestModesOpts.NoCors);
      expect(options3.method).toBe(RequestMethods.DELETE);
    });
  });
}
