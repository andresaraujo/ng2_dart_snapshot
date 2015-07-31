library angular2.src.change_detection.pipes.null_pipe;

import "package:angular2/src/facade/lang.dart" show isBlank;
import "pipe.dart" show Pipe, BasePipe, WrappedValue, PipeFactory;
import "../change_detector_ref.dart" show ChangeDetectorRef;

class NullPipeFactory implements PipeFactory {
  bool supports(dynamic obj) {
    return NullPipe.supportsObj(obj);
  }
  Pipe create(ChangeDetectorRef cdRef) {
    return new NullPipe();
  }
  const NullPipeFactory();
}
class NullPipe extends BasePipe {
  bool called = false;
  static bool supportsObj(dynamic obj) {
    return isBlank(obj);
  }
  bool supports(dynamic obj) {
    return NullPipe.supportsObj(obj);
  }
  WrappedValue transform(dynamic value, [List<dynamic> args = null]) {
    if (!this.called) {
      this.called = true;
      return WrappedValue.wrap(null);
    } else {
      return null;
    }
  }
}
