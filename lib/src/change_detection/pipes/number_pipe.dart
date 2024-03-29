library angular2.src.change_detection.pipes.number_pipe;

import "package:angular2/src/facade/lang.dart"
    show
        isNumber,
        isPresent,
        isBlank,
        StringWrapper,
        NumberWrapper,
        RegExpWrapper,
        BaseException,
        FunctionWrapper;
import "package:angular2/src/facade/intl.dart"
    show NumberFormatter, NumberFormatStyle;
import "package:angular2/src/facade/collection.dart" show ListWrapper;
import "pipe.dart" show Pipe, BasePipe, PipeFactory;
import "../change_detector_ref.dart" show ChangeDetectorRef;

String defaultLocale = "en-US";
var _re = RegExpWrapper.create("^(\\d+)?\\.((\\d+)(\\-(\\d+))?)?\$");
class NumberPipe extends BasePipe implements PipeFactory {
  static String _format(num value, NumberFormatStyle style, String digits,
      [String currency = null, bool currencyAsSymbol = false]) {
    var minInt = 1,
        minFraction = 0,
        maxFraction = 3;
    if (isPresent(digits)) {
      var parts = RegExpWrapper.firstMatch(_re, digits);
      if (isBlank(parts)) {
        throw new BaseException(
            '''${ digits} is not a valid digit info for number pipes''');
      }
      if (isPresent(parts[1])) {
        minInt = NumberWrapper.parseIntAutoRadix(parts[1]);
      }
      if (isPresent(parts[3])) {
        minFraction = NumberWrapper.parseIntAutoRadix(parts[3]);
      }
      if (isPresent(parts[5])) {
        maxFraction = NumberWrapper.parseIntAutoRadix(parts[5]);
      }
    }
    return NumberFormatter.format(value, defaultLocale, style,
        minimumIntegerDigits: minInt,
        minimumFractionDigits: minFraction,
        maximumFractionDigits: maxFraction,
        currency: currency,
        currencyAsSymbol: currencyAsSymbol);
  }
  bool supports(dynamic obj) {
    return isNumber(obj);
  }
  Pipe create(ChangeDetectorRef cdRef) {
    return this;
  }
  const NumberPipe();
}
/**
 * Formats a number as local text. i.e. group sizing and seperator and other locale-specific
 * configurations are based on the active locale.
 *
 * # Usage
 *
 *     expression | number[:digitInfo]
 *
 * where `expression` is a number and `digitInfo` has the following format:
 *
 *     {minIntegerDigits}.{minFractionDigits}-{maxFractionDigits}
 *
 * - minIntegerDigits is the minimum number of integer digits to use. Defaults to 1.
 * - minFractionDigits is the minimum number of digits after fraction. Defaults to 0.
 * - maxFractionDigits is the maximum number of digits after fraction. Defaults to 3.
 *
 * For more information on the acceptable range for each of these numbers and other
 * details see your native internationalization library.
 *
 * # Examples
 *
 *     {{ 123 | number }}              // output is 123
 *     {{ 123.1 | number: '.2-3' }}    // output is 123.10
 *     {{ 1 | number: '2.2' }}         // output is 01.00
 */
class DecimalPipe extends NumberPipe {
  String transform(dynamic value, List<dynamic> args) {
    String digits = ListWrapper.first(args);
    return NumberPipe._format(value, NumberFormatStyle.DECIMAL, digits);
  }
  const DecimalPipe();
}
/**
 * Formats a number as local percent.
 *
 * # Usage
 *
 *     expression | percent[:digitInfo]
 *
 * For more information about `digitInfo` see {@link DecimalPipe}
 */
class PercentPipe extends NumberPipe {
  String transform(dynamic value, List<dynamic> args) {
    String digits = ListWrapper.first(args);
    return NumberPipe._format(value, NumberFormatStyle.PERCENT, digits);
  }
  const PercentPipe();
}
/**
 * Formats a number as local currency.
 *
 * # Usage
 *
 *     expression | currency[:currencyCode[:symbolDisplay[:digitInfo]]]
 *
 * where `currencyCode` is the ISO 4217 currency code, such as "USD" for the US dollar and
 * "EUR" for the euro. `symbolDisplay` is a boolean indicating whether to use the currency
 * symbol (e.g. $) or the currency code (e.g. USD) in the output. The default for this value
 * is `false`.
 * For more information about `digitInfo` see {@link DecimalPipe}
 */
class CurrencyPipe extends NumberPipe {
  String transform(dynamic value, List<dynamic> args) {
    String currencyCode = isPresent(args) && args.length > 0 ? args[0] : "USD";
    bool symbolDisplay = isPresent(args) && args.length > 1 ? args[1] : false;
    String digits = isPresent(args) && args.length > 2 ? args[2] : null;
    return NumberPipe._format(
        value, NumberFormatStyle.CURRENCY, digits, currencyCode, symbolDisplay);
  }
  const CurrencyPipe();
}
