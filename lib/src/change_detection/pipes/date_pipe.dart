library angular2.src.change_detection.pipes.date_pipe;

import "package:angular2/src/facade/lang.dart"
    show isDate, isNumber, isPresent, DateTime, DateWrapper, FunctionWrapper;
import "package:angular2/src/facade/intl.dart" show DateFormatter;
import "package:angular2/src/facade/collection.dart"
    show StringMapWrapper, ListWrapper;
import "pipe.dart" show Pipe, BasePipe, PipeFactory;
import "../change_detector_ref.dart" show ChangeDetectorRef;

// TODO: move to a global configable location along with other i18n components.
String defaultLocale = "en-US";
/**
 * Formats a date value to a string based on the requested format.
 *
 * # Usage
 *
 *     expression | date[:format]
 *
 * where `expression` is a date object or a number (milliseconds since UTC epoch) and
 * `format` indicates which date/time components to include:
 *
 *  | Component | Symbol | Short Form   | Long Form         | Numeric   | 2-digit   |
 *  |-----------|:------:|--------------|-------------------|-----------|-----------|
 *  | era       |   G    | G (AD)       | GGGG (Anno Domini)| -         | -         |
 *  | year      |   y    | -            | -                 | y (2015)  | yy (15)   |
 *  | month     |   M    | MMM (Sep)    | MMMM (September)  | M (9)     | MM (09)   |
 *  | day       |   d    | -            | -                 | d (3)     | dd (03)   |
 *  | weekday   |   E    | EEE (Sun)    | EEEE (Sunday)     | -         | -         |
 *  | hour      |   j    | -            | -                 | j (13)    | jj (13)   |
 *  | hour12    |   h    | -            | -                 | h (1 PM)  | hh (01 PM)|
 *  | hour24    |   H    | -            | -                 | H (13)    | HH (13)   |
 *  | minute    |   m    | -            | -                 | m (5)     | mm (05)   |
 *  | second    |   s    | -            | -                 | s (9)     | ss (09)   |
 *  | timezone  |   z    | -            | z (Pacific Standard Time)| -  | -         |
 *  | timezone  |   Z    | Z (GMT-8:00) | -                 | -         | -         |
 *
 * In javascript, only the components specified will be respected (not the ordering,
 * punctuations, ...) and details of the the formatting will be dependent on the locale.
 * On the other hand in Dart version, you can also include quoted text as well as some extra
 * date/time components such as quarter. For more information see:
 * https://api.dartlang.org/apidocs/channels/stable/dartdoc-viewer/intl/intl.DateFormat.
 *
 * `format` can also be one of the following predefined formats:
 *
 *  - `'medium'`: equivalent to `'yMMMdjms'` (e.g. Sep 3, 2010, 12:05:08 PM for en-US)
 *  - `'short'`: equivalent to `'yMdjm'` (e.g. 9/3/2010, 12:05 PM for en-US)
 *  - `'fullDate'`: equivalent to `'yMMMMEEEEd'` (e.g. Friday, September 3, 2010 for en-US)
 *  - `'longDate'`: equivalent to `'yMMMMd'` (e.g. September 3, 2010)
 *  - `'mediumDate'`: equivalent to `'yMMMd'` (e.g. Sep 3, 2010 for en-US)
 *  - `'shortDate'`: equivalent to `'yMd'` (e.g. 9/3/2010 for en-US)
 *  - `'mediumTime'`: equivalent to `'jms'` (e.g. 12:05:08 PM for en-US)
 *  - `'shortTime'`: equivalent to `'jm'` (e.g. 12:05 PM for en-US)
 *
 * Timezone of the formatted text will be the local system timezone of the end-users machine.
 *
 * # Examples
 *
 * Assuming `dateObj` is (year: 2015, month: 6, day: 15, hour: 21, minute: 43, second: 11)
 * in the _local_ time and locale is 'en-US':
 *
 *     {{ dateObj | date }}               // output is 'Jun 15, 2015'
 *     {{ dateObj | date:'medium' }}      // output is 'Jun 15, 2015, 9:43:11 PM'
 *     {{ dateObj | date:'shortTime' }}   // output is '9:43 PM'
 *     {{ dateObj | date:'mmss' }}        // output is '43:11'
 */
class DatePipe extends BasePipe implements PipeFactory {
  static final _ALIASES = {
    "medium": "yMMMdjms",
    "short": "yMdjm",
    "fullDate": "yMMMMEEEEd",
    "longDate": "yMMMMd",
    "mediumDate": "yMMMd",
    "shortDate": "yMd",
    "mediumTime": "jms",
    "shortTime": "jm"
  };
  String transform(dynamic value, List<dynamic> args) {
    String pattern =
        isPresent(args) && args.length > 0 ? args[0] : "mediumDate";
    if (isNumber(value)) {
      value = DateWrapper.fromMillis(value);
    }
    if (StringMapWrapper.contains(DatePipe._ALIASES, pattern)) {
      pattern = (StringMapWrapper.get(DatePipe._ALIASES, pattern) as String);
    }
    return DateFormatter.format(value, defaultLocale, pattern);
  }
  bool supports(dynamic obj) {
    return isDate(obj) || isNumber(obj);
  }
  Pipe create(ChangeDetectorRef cdRef) {
    return this;
  }
  const DatePipe();
}
