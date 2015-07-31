/**
 * Contains everything you need to bootstrap your application.
 */
library angular2.bootstrap;

export "package:angular2/src/core/application.dart" show bootstrap;
// TODO(someone familiar with systemjs): the exports below are copied from

// angular2_exports.ts. Re-exporting from angular2_exports.ts causes systemjs

// to resolve imports very very very slowly. See also a similar notice in

// angular2.ts
export "annotations.dart";
export "change_detection.dart";
export "core.dart";
export "di.dart";
export "directives.dart";
export "http.dart";
export "forms.dart";
export "render.dart";
