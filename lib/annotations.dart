/**
 * @module
 * @description
 *
 * Annotations provide the additional information that Angular requires in order to run your
 * application. This module
 * contains {@link Component}, {@link Directive}, and {@link View} annotations, as well as
 * the {@link Host} annotation that is used by Angular to resolve dependencies.
 *
 */
library angular2.annotations;

export "src/core/annotations/annotations.dart"
    show ComponentAnnotation, DirectiveAnnotation, LifecycleEvent;
export "package:angular2/src/core/annotations/view.dart"
    show ViewAnnotation, ViewEncapsulation;
export "package:angular2/src/core/annotations/di.dart"
    show QueryAnnotation, AttributeAnnotation;
export "package:angular2/src/core/compiler/interfaces.dart"
    show OnAllChangesDone, OnChange, OnDestroy, OnInit, OnCheck;
export "package:angular2/src/util/decorators.dart"
    show Class, ClassDefinition, TypeDecorator;
export "package:angular2/src/core/annotations/decorators.dart"
    show
        Attribute,
        AttributeFactory,
        Component,
        ComponentDecorator,
        ComponentFactory,
        Directive,
        DirectiveDecorator,
        DirectiveFactory,
        View,
        ViewDecorator,
        ViewFactory,
        Query,
        QueryFactory,
        ViewQuery;
