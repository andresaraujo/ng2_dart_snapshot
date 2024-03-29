/**
 * @module
 * @description
 * Define angular core API here.
 */
library angular2.core;

export "package:angular2/src/core/application_tokens.dart"
    show appComponentTypeToken;
export "package:angular2/src/core/application_common.dart" show ApplicationRef;
export "package:angular2/src/facade/lang.dart" show Type;
// Compiler Related Dependencies.
export "package:angular2/src/services/app_root_url.dart" show AppRootUrl;
export "package:angular2/src/services/url_resolver.dart" show UrlResolver;
export "package:angular2/src/core/compiler/component_url_mapper.dart"
    show ComponentUrlMapper;
export "package:angular2/src/core/compiler/directive_resolver.dart"
    show DirectiveResolver;
export "package:angular2/src/core/compiler/compiler.dart" show Compiler;
export "package:angular2/src/core/compiler/view_manager.dart"
    show AppViewManager;
export "package:angular2/src/core/compiler/interface_query.dart"
    show IQueryList;
export "package:angular2/src/core/compiler/query_list.dart" show QueryList;
export "package:angular2/src/core/compiler/dynamic_component_loader.dart"
    show DynamicComponentLoader;
export "package:angular2/src/core/life_cycle/life_cycle.dart" show LifeCycle;
export "package:angular2/src/core/compiler/element_ref.dart" show ElementRef;
export "package:angular2/src/core/compiler/template_ref.dart" show TemplateRef;
export "package:angular2/src/render/api.dart" show RenderElementRef;
export "package:angular2/src/core/compiler/view_ref.dart"
    show ViewRef, HostViewRef, ProtoViewRef;
export "package:angular2/src/core/compiler/view_container_ref.dart"
    show ViewContainerRef;
export "package:angular2/src/core/compiler/dynamic_component_loader.dart"
    show ComponentRef;
export "package:angular2/src/core/zone/ng_zone.dart" show NgZone;
export "package:angular2/src/facade/async.dart" show Stream, EventEmitter;
