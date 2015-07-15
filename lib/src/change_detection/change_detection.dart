library angular2.src.change_detection.change_detection;

import "jit_proto_change_detector.dart" show JitProtoChangeDetector;
import "pregen_proto_change_detector.dart" show PregenProtoChangeDetector;
import "proto_change_detector.dart" show DynamicProtoChangeDetector;
import "pipes/pipe.dart" show PipeFactory, Pipe;
import "pipes/pipes.dart" show Pipes;
import "pipes/iterable_changes.dart" show IterableChangesFactory;
import "pipes/keyvalue_changes.dart" show KeyValueChangesFactory;
import "pipes/observable_pipe.dart" show ObservablePipeFactory;
import "pipes/promise_pipe.dart" show PromisePipeFactory;
import "pipes/uppercase_pipe.dart" show UpperCaseFactory;
import "pipes/lowercase_pipe.dart" show LowerCaseFactory;
import "pipes/json_pipe.dart" show JsonPipe;
import "pipes/limit_to_pipe.dart" show LimitToPipeFactory;
import "pipes/date_pipe.dart" show DatePipe;
import "pipes/number_pipe.dart" show DecimalPipe, PercentPipe, CurrencyPipe;
import "pipes/null_pipe.dart" show NullPipeFactory;
import "interfaces.dart"
    show ChangeDetection, ProtoChangeDetector, ChangeDetectorDefinition;
import "package:angular2/di.dart"
    show Inject, Injectable, OpaqueToken, Optional;
import "package:angular2/src/facade/collection.dart"
    show List, Map, StringMapWrapper;
import "package:angular2/src/facade/lang.dart" show isPresent, BaseException;

/**
 * Structural diffing for `Object`s and `Map`s.
 */
const List<PipeFactory> keyValDiff = const [
  const KeyValueChangesFactory(),
  const NullPipeFactory()
];
/**
 * Structural diffing for `Iterable` types such as `Array`s.
 */
const List<PipeFactory> iterableDiff = const [
  const IterableChangesFactory(),
  const NullPipeFactory()
];
/**
 * Async binding to such types as Observable.
 */
const List<PipeFactory> async = const [
  const ObservablePipeFactory(),
  const PromisePipeFactory(),
  const NullPipeFactory()
];
/**
 * Uppercase text transform.
 */
const List<PipeFactory> uppercase = const [
  const UpperCaseFactory(),
  const NullPipeFactory()
];
/**
 * Lowercase text transform.
 */
const List<PipeFactory> lowercase = const [
  const LowerCaseFactory(),
  const NullPipeFactory()
];
/**
 * Json stringify transform.
 */
const List<PipeFactory> json = const [
  const JsonPipe(),
  const NullPipeFactory()
];
/**
 * LimitTo text transform.
 */
const List<PipeFactory> limitTo = const [
  const LimitToPipeFactory(),
  const NullPipeFactory()
];
/**
 * Number number transform.
 */
const List<PipeFactory> decimal = const [
  const DecimalPipe(),
  const NullPipeFactory()
];
/**
 * Percent number transform.
 */
const List<PipeFactory> percent = const [
  const PercentPipe(),
  const NullPipeFactory()
];
/**
 * Currency number transform.
 */
const List<PipeFactory> currency = const [
  const CurrencyPipe(),
  const NullPipeFactory()
];
/**
 * Date/time formatter.
 */
const List<PipeFactory> date = const [
  const DatePipe(),
  const NullPipeFactory()
];
const Pipes defaultPipes = const Pipes(const {
  "iterableDiff": iterableDiff,
  "keyValDiff": keyValDiff,
  "async": async,
  "uppercase": uppercase,
  "lowercase": lowercase,
  "json": json,
  "limitTo": limitTo,
  "number": decimal,
  "percent": percent,
  "currency": currency,
  "date": date
});
/**
 * Map from {@link ChangeDetectorDefinition#id} to a factory method which takes a
 * {@link Pipes} and a {@link ChangeDetectorDefinition} and generates a
 * {@link ProtoChangeDetector} associated with the definition.
 */

// TODO(kegluneq): Use PregenProtoChangeDetectorFactory rather than Function once possible in

// dart2js. See https://github.com/dart-lang/sdk/issues/23630 for details.
Map<String, Function> preGeneratedProtoDetectors = {};
const PROTO_CHANGE_DETECTOR_KEY = const OpaqueToken("ProtoChangeDetectors");
/**
 * Implements change detection using a map of pregenerated proto detectors.
 */
@Injectable()
class PreGeneratedChangeDetection extends ChangeDetection {
  ChangeDetection _dynamicChangeDetection;
  Map<String, Function> _protoChangeDetectorFactories;
  PreGeneratedChangeDetection([@Inject(
      PROTO_CHANGE_DETECTOR_KEY) @Optional() Map<String, Function> protoChangeDetectorsForTest])
      : super() {
    /* super call moved to initializer */;
    this._dynamicChangeDetection = new DynamicChangeDetection();
    this._protoChangeDetectorFactories = isPresent(protoChangeDetectorsForTest)
        ? protoChangeDetectorsForTest
        : preGeneratedProtoDetectors;
  }
  static bool isSupported() {
    return PregenProtoChangeDetector.isSupported();
  }
  ProtoChangeDetector createProtoChangeDetector(
      ChangeDetectorDefinition definition) {
    var id = definition.id;
    if (StringMapWrapper.contains(this._protoChangeDetectorFactories, id)) {
      return StringMapWrapper.get(this._protoChangeDetectorFactories, id)(
          definition);
    }
    return this._dynamicChangeDetection.createProtoChangeDetector(definition);
  }
}
/**
 * Implements change detection that does not require `eval()`.
 *
 * This is slower than {@link JitChangeDetection}.
 */
@Injectable()
class DynamicChangeDetection extends ChangeDetection {
  ProtoChangeDetector createProtoChangeDetector(
      ChangeDetectorDefinition definition) {
    return new DynamicProtoChangeDetector(definition);
  }
}
/**
 * Implements faster change detection by generating source code.
 *
 * This requires `eval()`. For change detection that does not require `eval()`, see
 * {@link DynamicChangeDetection} and {@link PreGeneratedChangeDetection}.
 */
@Injectable()
class JitChangeDetection extends ChangeDetection {
  static bool isSupported() {
    return JitProtoChangeDetector.isSupported();
  }
  ProtoChangeDetector createProtoChangeDetector(
      ChangeDetectorDefinition definition) {
    return new JitProtoChangeDetector(definition);
  }
  const JitChangeDetection();
}
