library angular2.src.change_detection.pipes.limit_to_pipe;

import "package:angular2/src/facade/lang.dart"
    show isBlank, isString, isArray, StringWrapper, BaseException;
import "package:angular2/src/facade/collection.dart" show ListWrapper;
import "package:angular2/src/facade/math.dart" show Math;
import "pipe.dart" show WrappedValue, Pipe, PipeFactory;
import "../change_detector_ref.dart" show ChangeDetectorRef;

/**
 * Creates a new List or String containing only a prefix/suffix of the
 * elements.
 *
 * The number of elements to return is specified by the `limitTo` parameter.
 *
 * # Usage
 *
 *     expression | limitTo:number
 *
 * Where the input expression is a [List] or [String], and `limitTo` is:
 *
 * - **a positive integer**: return _number_ items from the beginning of the list or string
 * expression.
 * - **a negative integer**: return _number_ items from the end of the list or string expression.
 * - **`|limitTo|` greater than the size of the expression**: return the entire expression.
 *
 * When operating on a [List], the returned list is always a copy even when all
 * the elements are being returned.
 *
 * # Examples
 *
 * ## List Example
 *
 * Assuming `var collection = ['a', 'b', 'c']`, this `ng-for` directive:
 *
 *     <li *ng-for="var i in collection | limitTo:2">{{i}}</li>
 *
 * produces the following:
 *
 *     <li>a</li>
 *     <li>b</li>
 *
 * ## String Examples
 *
 *     {{ 'abcdefghij' | limitTo: 4 }}       // output is 'abcd'
 *     {{ 'abcdefghij' | limitTo: -4 }}      // output is 'ghij'
 *     {{ 'abcdefghij' | limitTo: -100 }}    // output is 'abcdefghij'
 */
class LimitToPipe implements Pipe {
  static bool supportsObj(obj) {
    return isString(obj) || isArray(obj);
  }
  bool supports(obj) {
    return LimitToPipe.supportsObj(obj);
  }
  dynamic transform(value, [List<dynamic> args = null]) {
    if (isBlank(args) || args.length == 0) {
      throw new BaseException("limitTo pipe requires one argument");
    }
    int limit = args[0];
    var left = 0,
        right = Math.min(limit, value.length);
    if (limit < 0) {
      left = Math.max(0, value.length + limit);
      right = value.length;
    }
    if (isString(value)) {
      return StringWrapper.substring(value, left, right);
    }
    return ListWrapper.slice(value, left, right);
  }
  void onDestroy() {}
}
class LimitToPipeFactory implements PipeFactory {
  bool supports(obj) {
    return LimitToPipe.supportsObj(obj);
  }
  Pipe create(ChangeDetectorRef cdRef) {
    return new LimitToPipe();
  }
  const LimitToPipeFactory();
}
