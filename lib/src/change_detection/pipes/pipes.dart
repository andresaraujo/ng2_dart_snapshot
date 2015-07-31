library angular2.src.change_detection.pipes.pipes;

import "package:angular2/src/facade/collection.dart"
    show ListWrapper, isListLikeIterable, StringMapWrapper;
import "package:angular2/src/facade/lang.dart"
    show isBlank, isPresent, BaseException;
import "pipe.dart" show Pipe, PipeFactory;
import "package:angular2/di.dart"
    show Injectable, OptionalMetadata, SkipSelfMetadata;
import "../change_detector_ref.dart" show ChangeDetectorRef;
import "package:angular2/di.dart" show Binding;

@Injectable()
class Pipes {
  /**
   * Map of {@link Pipe} names to {@link PipeFactory} lists used to configure the
   * {@link Pipes} registry.
   *
   * #Example
   *
   * ```
   * var pipesConfig = {
   *   'json': [jsonPipeFactory]
   * }
   * @Component({
   *   viewBindings: [
   *     bind(Pipes).toValue(new Pipes(pipesConfig))
   *   ]
   * })
   * ```
   */
  final Map<String, List<PipeFactory>> config;
  const Pipes(Map<String, List<PipeFactory>> config) : config = config;
  Pipe get(String type, dynamic obj,
      [ChangeDetectorRef cdRef, Pipe existingPipe]) {
    if (isPresent(existingPipe) &&
        existingPipe.supports(obj)) return existingPipe;
    if (isPresent(existingPipe)) existingPipe.onDestroy();
    var factories = this._getListOfFactories(type, obj);
    var factory = this._getMatchingFactory(factories, type, obj);
    return factory.create(cdRef);
  }
  /**
   * Takes a {@link Pipes} config object and returns a binding used to extend the
   * inherited {@link Pipes} instance with the provided config and return a new
   * {@link Pipes} instance.
   *
   * If the provided config contains a key that is not yet present in the
   * inherited {@link Pipes}' config, a new {@link PipeFactory} list will be created
   * for that key. Otherwise, the provided config will be merged with the inherited
   * {@link Pipes} instance by prepending pipes to their respective keys, without mutating
   * the inherited {@link Pipes}.
   *
   * The following example shows how to extend an existing list of `async` factories
   * with a new {@link PipeFactory}, which will only be applied to the injector
   * for this component and its children. This step is all that's required to make a new
   * pipe available to this component's template.
   *
   * # Example
   *
   * ```
   * @Component({
   *   viewBindings: [
   *     Pipes.extend({
   *       async: [newAsyncPipe]
   *     })
   *   ]
   * })
   * ```
   */
  static Binding extend(Map<String, List<PipeFactory>> config) {
    return new Binding(Pipes, toFactory: (Pipes pipes) {
      if (isBlank(pipes)) {
        // Typically would occur when calling Pipe.extend inside of dependencies passed to

        // bootstrap(), which would override default pipes instead of extending them.
        throw new BaseException(
            "Cannot extend Pipes without a parent injector");
      }
      return Pipes.create(config, pipes);
    }, deps: [[Pipes, new SkipSelfMetadata(), new OptionalMetadata()]]);
  }
  static Pipes create(Map<String, List<PipeFactory>> config,
      [Pipes pipes = null]) {
    if (isPresent(pipes)) {
      StringMapWrapper.forEach(pipes.config, (List<PipeFactory> v, String k) {
        if (StringMapWrapper.contains(config, k)) {
          List<PipeFactory> configFactories = config[k];
          config[k] = new List.from(configFactories)..addAll(v);
        } else {
          config[k] = ListWrapper.clone(v);
        }
      });
    }
    return new Pipes(config);
  }
  List<PipeFactory> _getListOfFactories(String type, dynamic obj) {
    var listOfFactories = this.config[type];
    if (isBlank(listOfFactories)) {
      throw new BaseException(
          '''Cannot find \'${ type}\' pipe supporting object \'${ obj}\'''');
    }
    return listOfFactories;
  }
  PipeFactory _getMatchingFactory(
      List<PipeFactory> listOfFactories, String type, dynamic obj) {
    var matchingFactory = ListWrapper.find(
        listOfFactories, (pipeFactory) => pipeFactory.supports(obj));
    if (isBlank(matchingFactory)) {
      throw new BaseException(
          '''Cannot find \'${ type}\' pipe supporting object \'${ obj}\'''');
    }
    return matchingFactory;
  }
}
