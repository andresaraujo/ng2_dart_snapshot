library angular2.src.di.metadata;

import "package:angular2/src/facade/lang.dart"
    show stringify, isBlank, isPresent;

/**
 * A parameter metadata that specifies a dependency.
 *
 * ```
 * class AComponent {
 *   constructor(@Inject(MyService) aService:MyService) {}
 * }
 * ```
 */
class InjectMetadata {
  final token;
  const InjectMetadata(this.token);
  String toString() {
    return '''@Inject(${ stringify ( this . token )})''';
  }
}
/**
 * A parameter metadata that marks a dependency as optional. {@link Injector} provides `null` if
 * the dependency is not found.
 *
 * ```
 * class AComponent {
 *   constructor(@Optional() aService:MyService) {
 *     this.aService = aService;
 *   }
 * }
 * ```
 */
class OptionalMetadata {
  String toString() {
    return '''@Optional()''';
  }
  const OptionalMetadata();
}
/**
 * `DependencyMetadata is used by the framework to extend DI.
 *
 * Only metadata implementing `DependencyMetadata` are added to the list of dependency
 * properties.
 *
 * For example:
 *
 * ```
 * class Exclude extends DependencyMetadata {}
 * class NotDependencyProperty {}
 *
 * class AComponent {
 *   constructor(@Exclude @NotDependencyProperty aService:AService) {}
 * }
 * ```
 *
 * will create the following dependency:
 *
 * ```
 * new Dependency(Key.get(AService), [new Exclude()])
 * ```
 *
 * The framework can use `new Exclude()` to handle the `aService` dependency
 * in a specific way.
 */
class DependencyMetadata {
  get token {
    return null;
  }
  const DependencyMetadata();
}
/**
 * A marker metadata that marks a class as available to `Injector` for creation. Used by tooling
 * for generating constructor stubs.
 *
 * ```
 * class NeedsService {
 *   constructor(svc:UsefulService) {}
 * }
 *
 * @Injectable
 * class UsefulService {}
 * ```
 */
class InjectableMetadata {
  const InjectableMetadata();
}
/**
 * Specifies that an injector should retrieve a dependency from itself.
 *
 * ## Example
 *
 * ```
 * class Dependency {
 * }
 *
 * class NeedsDependency {
 *   constructor(public @Self() dependency:Dependency) {}
 * }
 *
 * var inj = Injector.resolveAndCreate([Dependency, NeedsDependency]);
 * var nd = inj.get(NeedsDependency);
 * expect(nd.dependency).toBeAnInstanceOf(Dependency);
 * ```
 */
class SelfMetadata {
  String toString() {
    return '''@Self()''';
  }
  const SelfMetadata();
}
/**
 * Specifies that the dependency resolution should start from the parent injector.
 *
 * ## Example
 *
 *
 * ```
 * class Service {}
 *
 * class ParentService implements Service {
 * }
 *
 * class ChildService implements Service {
 *   constructor(public @SkipSelf() parentService:Service) {}
 * }
 *
 * var parent = Injector.resolveAndCreate([
 *   bind(Service).toClass(ParentService)
 * ]);
 * var child = parent.resolveAndCreateChild([
 *   bind(Service).toClass(ChildSerice)
 * ]);
 * var s = child.get(Service);
 * expect(s).toBeAnInstanceOf(ChildService);
 * expect(s.parentService).toBeAnInstanceOf(ParentService);
 * ```
 */
class SkipSelfMetadata {
  String toString() {
    return '''@SkipSelf()''';
  }
  const SkipSelfMetadata();
}
/**
 * Specifies that an injector should retrieve a dependency from any injector until reaching the
 * closest host.
 *
 * ## Example
 *
 * ```
 * class Dependency {
 * }
 *
 * class NeedsDependency {
 *   constructor(public @Host() dependency:Dependency) {}
 * }
 *
 * var parent = Injector.resolveAndCreate([
 *   bind(Dependency).toClass(HostDependency)
 * ]);
 * var child = parent.resolveAndCreateChild([]);
 * var grandChild = child.resolveAndCreateChild([NeedsDependency, Depedency]);
 * var nd = grandChild.get(NeedsDependency);
 * expect(nd.dependency).toBeAnInstanceOf(HostDependency);
 * ```
 * ```
 */
class HostMetadata {
  String toString() {
    return '''@Host()''';
  }
  const HostMetadata();
}
