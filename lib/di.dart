/**
 * @module
 * @description
 * The `di` module provides dependency injection container services.
 */
library angular2.di;

export "src/di/metadata.dart"
    show
        InjectMetadata,
        OptionalMetadata,
        InjectableMetadata,
        VisibilityMetadata,
        SelfMetadata,
        ParentMetadata,
        AncestorMetadata,
        UnboundedMetadata,
        DependencyMetadata,
        DEFAULT_VISIBILITY;
// we have to reexport * because Dart and TS export two different sets of types
export "src/di/decorators.dart";
export "src/di/forward_ref.dart"
    show forwardRef, resolveForwardRef, ForwardRefFn;
export "src/di/injector.dart"
    show
        Injector,
        ProtoInjector,
        DependencyProvider,
        PUBLIC_AND_PRIVATE,
        PUBLIC,
        PRIVATE,
        undefinedValue;
export "src/di/binding.dart"
    show Binding, BindingBuilder, ResolvedBinding, Dependency, bind;
export "src/di/key.dart" show Key, KeyRegistry, TypeLiteral;
export "src/di/exceptions.dart"
    show
        NoBindingError,
        AbstractBindingError,
        AsyncBindingError,
        CyclicDependencyError,
        InstantiationError,
        InvalidBindingError,
        NoAnnotationError,
        OutOfBoundsError;
export "src/di/opaque_token.dart" show OpaqueToken;
