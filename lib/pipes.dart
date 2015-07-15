/**
 * @module
 * @description
 * This module provides advanced support for extending change detection.
 */
library angular2.pipes;

export "src/change_detection/pipes/promise_pipe.dart" show PromisePipe;
export "src/change_detection/pipes/uppercase_pipe.dart" show UpperCasePipe;
export "src/change_detection/pipes/lowercase_pipe.dart" show LowerCasePipe;
export "src/change_detection/pipes/observable_pipe.dart" show ObservablePipe;
export "src/change_detection/pipes/json_pipe.dart" show JsonPipe;
export "src/change_detection/pipes/iterable_changes.dart" show IterableChanges;
export "src/change_detection/pipes/keyvalue_changes.dart" show KeyValueChanges;
export "src/change_detection/pipes/date_pipe.dart" show DatePipe;
export "src/change_detection/pipes/number_pipe.dart"
    show DecimalPipe, PercentPipe, CurrencyPipe;
export "src/change_detection/pipes/limit_to_pipe.dart" show LimitToPipe;
