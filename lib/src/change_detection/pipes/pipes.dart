library angular2.src.change_detection.pipes.pipes;

import "package:angular2/src/facade/collection.dart"
    show ListWrapper, isListLikeIterable, StringMapWrapper;
import "package:angular2/src/facade/lang.dart"
    show isBlank, isPresent, BaseException;
import "pipe.dart" show Pipe, PipeFactory;
import "package:angular2/di.dart"
    show Injectable, UnboundedMetadata, OptionalMetadata;
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
   *   viewInjector: [
   *     bind(Pipes).toValue(new Pipes(pipesConfig))
   *   ]
   * })
   * ```
   */
  final Map<String, List<PipeFactory>> config;
  const Pipes(Map<String, List<PipeFactory>> config) : config = config;
  Pipe get(String type, obj, [ChangeDetectorRef cdRef, Pipe existingPipe]) {
    if (isPresent(existingPipe) &&
        existingPipe.supports(obj)) return existingPipe;
    if (isPresent(existingPipe)) existingPipe.onDestroy();
    var factories = this._getListOfFactories(type, obj);
    var factory = this._getMatchingFactory(factories, type, obj);
    return factory.create(cdRef);
  }
  /**
   * Takes a {@link Pipes} config object and returns a binding used to append the
   * provided config to an inherited {@link Pipes} instance and return a new
   * {@link Pipes} instance.
   *
   * If the provided config contains a key that is not yet present in the
   * inherited {@link Pipes}' config, a new {@link PipeFactory} list will be created
   * for that key. Otherwise, the provided config will be merged with the inherited
   * {@link Pipes} instance by appending pipes to their respective keys, without mutating
   * the inherited {@link Pipes}.
   *
   * The following example shows how to append a new {@link PipeFactory} to the
   * existing list of `async` factories, which will only be applied to the injector
   * for this component and its children. This step is all that's required to make a new
   * pipe available to this component's template.
   *
   * # Example
   *
   * ```
   * @Component({
   *   viewInjector: [
   *     Pipes.append({
   *       async: [newAsyncPipe]
   *     })
   *   ]
   * })
   * ```
   */
  static Binding append(config) {
    return new Binding(Pipes, toFactory: (Pipes pipes) {
      if (!isPresent(pipes)) {
        // Typically would occur when calling Pipe.append inside of dependencies passed to

        // bootstrap(), which would override default pipes instead of append.
        throw new BaseException(
            "Cannot append to Pipes without a parent injector");
      }
      Map<String, List<PipeFactory>> mergedConfig = ({
      } as Map<String, List<PipeFactory>>);
      // Manual deep copy of existing Pipes config,

      // so that lists of PipeFactories don't get mutated.
      StringMapWrapper.forEach(pipes.config, (List<PipeFactory> v, String k) {
        List<PipeFactory> localPipeList = mergedConfig[k] = [];
        v.forEach((PipeFactory p) {
          localPipeList.add(p);
        });
      });
      StringMapWrapper.forEach(config, (List<PipeFactory> v, String k) {
        if (isListLikeIterable(mergedConfig[k])) {
          mergedConfig[k] = ListWrapper.concat(mergedConfig[k], config[k]);
        } else {
          mergedConfig[k] = config[k];
        }
      });
      return new Pipes(mergedConfig);
    }, deps: [[Pipes, new UnboundedMetadata(), new OptionalMetadata()]]);
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
