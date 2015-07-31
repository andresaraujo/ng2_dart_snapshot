library angular2.test.core.compiler.compiler_spec;

import "package:angular2/test_lib.dart"
    show
        AsyncTestCompleter,
        beforeEach,
        xdescribe,
        ddescribe,
        describe,
        el,
        expect,
        iit,
        inject,
        IS_DARTIUM,
        it,
        SpyObject,
        proxy;
import "package:angular2/src/facade/collection.dart"
    show List, ListWrapper, Map, MapWrapper, StringMapWrapper;
import "package:angular2/src/facade/lang.dart"
    show Type, isBlank, stringify, isPresent, isArray;
import "package:angular2/src/facade/async.dart"
    show PromiseCompleter, PromiseWrapper, Future;
import "package:angular2/src/core/compiler/compiler.dart"
    show Compiler, CompilerCache;
import "package:angular2/src/core/compiler/view.dart" show AppProtoView;
import "package:angular2/src/core/compiler/element_binder.dart"
    show ElementBinder;
import "package:angular2/src/core/compiler/directive_resolver.dart"
    show DirectiveResolver;
import "package:angular2/annotations.dart"
    show Attribute, View, Component, Directive;
import "package:angular2/src/core/annotations_impl/view.dart" as viewAnn;
import "package:angular2/src/core/compiler/view_ref.dart"
    show internalProtoView;
import "package:angular2/src/core/compiler/element_injector.dart"
    show DirectiveBinding;
import "package:angular2/src/core/compiler/view_resolver.dart"
    show ViewResolver;
import "package:angular2/src/core/compiler/component_url_mapper.dart"
    show ComponentUrlMapper, RuntimeComponentUrlMapper;
import "package:angular2/src/core/compiler/proto_view_factory.dart"
    show ProtoViewFactory;
import "package:angular2/src/services/url_resolver.dart" show UrlResolver;
import "package:angular2/src/services/app_root_url.dart" show AppRootUrl;
import "package:angular2/src/render/api.dart" as renderApi;
// TODO(tbosch): Spys don't support named modules...
import "package:angular2/src/render/api.dart" show RenderCompiler;

main() {
  describe("compiler", () {
    var directiveResolver,
        tplResolver,
        renderCompiler,
        protoViewFactory,
        cmpUrlMapper,
        rootProtoView;
    List<dynamic> renderCompileRequests;
    createCompiler(
        List<dynamic /* renderApi . ProtoViewDto | Future < renderApi . ProtoViewDto > */ > renderCompileResults,
        List<AppProtoView> protoViewFactoryResults) {
      var urlResolver = new UrlResolver();
      renderCompileRequests = [];
      renderCompileResults = ListWrapper.clone(renderCompileResults);
      renderCompiler.spy("compile").andCallFake((view) {
        renderCompileRequests.add(view);
        return PromiseWrapper
            .resolve(ListWrapper.removeAt(renderCompileResults, 0));
      });
      protoViewFactory = new FakeProtoViewFactory(protoViewFactoryResults);
      return new Compiler(directiveResolver, new CompilerCache(), tplResolver,
          cmpUrlMapper, urlResolver, renderCompiler, protoViewFactory,
          new AppRootUrl("http://www.app.com"));
    }
    beforeEach(() {
      directiveResolver = new DirectiveResolver();
      tplResolver = new FakeViewResolver();
      cmpUrlMapper = new RuntimeComponentUrlMapper();
      renderCompiler = new SpyRenderCompiler();
      renderCompiler.spy("compileHost").andCallFake((componentId) {
        return PromiseWrapper.resolve(createRenderProtoView(
            [createRenderComponentElementBinder(0)], renderApi.ViewType.HOST));
      });
      renderCompiler.spy("mergeProtoViewsRecursively").andCallFake(
          (List<dynamic /* renderApi . RenderProtoViewRef | List < dynamic > */ > protoViewRefs) {
        return PromiseWrapper.resolve(new renderApi.RenderProtoViewMergeMapping(
            new MergedRenderProtoViewRef(protoViewRefs), 1, [], 0, [], [],
            [null]));
      });
      // TODO spy on .compile and return RenderProtoViewRef, same for compileHost
      rootProtoView = createRootProtoView(directiveResolver, MainComponent);
    });
    describe("serialize template", () {
      Future<renderApi.ViewDefinition> captureTemplate(viewAnn.View template) {
        tplResolver.setView(MainComponent, template);
        var compiler = createCompiler(
            [createRenderProtoView()], [rootProtoView, createProtoView()]);
        return compiler.compileInHost(MainComponent).then((_) {
          expect(renderCompileRequests.length).toBe(1);
          return renderCompileRequests[0];
        });
      }
      Future<renderApi.DirectiveMetadata> captureDirective(directive) {
        return captureTemplate(new viewAnn.View(
                template: "<div></div>", directives: [directive]))
            .then((renderTpl) {
          expect(renderTpl.directives.length).toBe(1);
          return renderTpl.directives[0];
        });
      }
      it("should fill the componentId", inject([AsyncTestCompleter], (async) {
        captureTemplate(new viewAnn.View(template: "<div></div>"))
            .then((renderTpl) {
          expect(renderTpl.componentId).toEqual(stringify(MainComponent));
          async.done();
        });
      }));
      it("should fill inline template", inject([AsyncTestCompleter], (async) {
        captureTemplate(new viewAnn.View(template: "<div></div>"))
            .then((renderTpl) {
          expect(renderTpl.template).toEqual("<div></div>");
          async.done();
        });
      }));
      it("should fill templateAbsUrl given inline templates", inject(
          [AsyncTestCompleter], (async) {
        cmpUrlMapper.setComponentUrl(MainComponent, "/cmp/main.js");
        captureTemplate(new viewAnn.View(template: "<div></div>"))
            .then((renderTpl) {
          expect(renderTpl.templateAbsUrl)
              .toEqual("http://www.app.com/cmp/main.js");
          async.done();
        });
      }));
      it("should not fill templateAbsUrl given no inline template or template url",
          inject([AsyncTestCompleter], (async) {
        cmpUrlMapper.setComponentUrl(MainComponent, "/cmp/main.js");
        captureTemplate(new viewAnn.View(template: null, templateUrl: null))
            .then((renderTpl) {
          expect(renderTpl.templateAbsUrl).toBe(null);
          async.done();
        });
      }));
      it("should fill templateAbsUrl given url template", inject(
          [AsyncTestCompleter], (async) {
        cmpUrlMapper.setComponentUrl(MainComponent, "/cmp/main.js");
        captureTemplate(new viewAnn.View(templateUrl: "tpl/main.html"))
            .then((renderTpl) {
          expect(renderTpl.templateAbsUrl)
              .toEqual("http://www.app.com/cmp/tpl/main.html");
          async.done();
        });
      }));
      it("should fill styleAbsUrls given styleUrls", inject(
          [AsyncTestCompleter], (async) {
        cmpUrlMapper.setComponentUrl(MainComponent, "/cmp/main.js");
        captureTemplate(new viewAnn.View(styleUrls: ["css/1.css", "css/2.css"]))
            .then((renderTpl) {
          expect(renderTpl.styleAbsUrls).toEqual([
            "http://www.app.com/cmp/css/1.css",
            "http://www.app.com/cmp/css/2.css"
          ]);
          async.done();
        });
      }));
      it("should fill directive.id", inject([AsyncTestCompleter], (async) {
        captureDirective(MainComponent).then((renderDir) {
          expect(renderDir.id).toEqual(stringify(MainComponent));
          async.done();
        });
      }));
      it("should fill directive.selector", inject([AsyncTestCompleter],
          (async) {
        captureDirective(MainComponent).then((renderDir) {
          expect(renderDir.selector).toEqual("main-comp");
          async.done();
        });
      }));
      it("should fill directive.type for components", inject(
          [AsyncTestCompleter], (async) {
        captureDirective(MainComponent).then((renderDir) {
          expect(renderDir.type)
              .toEqual(renderApi.DirectiveMetadata.COMPONENT_TYPE);
          async.done();
        });
      }));
      it("should fill directive.type for dynamic components", inject(
          [AsyncTestCompleter], (async) {
        captureDirective(SomeDynamicComponentDirective).then((renderDir) {
          expect(renderDir.type)
              .toEqual(renderApi.DirectiveMetadata.COMPONENT_TYPE);
          async.done();
        });
      }));
      it("should fill directive.type for decorator directives", inject(
          [AsyncTestCompleter], (async) {
        captureDirective(SomeDirective).then((renderDir) {
          expect(renderDir.type)
              .toEqual(renderApi.DirectiveMetadata.DIRECTIVE_TYPE);
          async.done();
        });
      }));
      it("should set directive.compileChildren to false for other directives",
          inject([AsyncTestCompleter], (async) {
        captureDirective(MainComponent).then((renderDir) {
          expect(renderDir.compileChildren).toEqual(true);
          async.done();
        });
      }));
      it("should set directive.compileChildren to true for decorator directives",
          inject([AsyncTestCompleter], (async) {
        captureDirective(SomeDirective).then((renderDir) {
          expect(renderDir.compileChildren).toEqual(true);
          async.done();
        });
      }));
      it("should set directive.compileChildren to false for decorator directives",
          inject([AsyncTestCompleter], (async) {
        captureDirective(IgnoreChildrenDirective).then((renderDir) {
          expect(renderDir.compileChildren).toEqual(false);
          async.done();
        });
      }));
      it("should set directive.hostListeners", inject([AsyncTestCompleter],
          (async) {
        captureDirective(DirectiveWithEvents).then((renderDir) {
          expect(renderDir.hostListeners).toEqual(
              MapWrapper.createFromStringMap({"someEvent": "someAction"}));
          async.done();
        });
      }));
      it("should set directive.hostProperties", inject([AsyncTestCompleter],
          (async) {
        captureDirective(DirectiveWithProperties).then((renderDir) {
          expect(renderDir.hostProperties)
              .toEqual(MapWrapper.createFromStringMap({"someProp": "someExp"}));
          async.done();
        });
      }));
      it("should set directive.bind", inject([AsyncTestCompleter], (async) {
        captureDirective(DirectiveWithBind).then((renderDir) {
          expect(renderDir.properties).toEqual(["a: b"]);
          async.done();
        });
      }));
      it("should read @Attribute", inject([AsyncTestCompleter], (async) {
        captureDirective(DirectiveWithAttributes).then((renderDir) {
          expect(renderDir.readAttributes).toEqual(["someAttr"]);
          async.done();
        });
      }));
    });
    describe("call ProtoViewFactory", () {
      it("should pass the ProtoViewDto", inject([AsyncTestCompleter], (async) {
        tplResolver.setView(
            MainComponent, new viewAnn.View(template: "<div></div>"));
        var renderProtoView = createRenderProtoView();
        var expectedProtoView = createProtoView();
        var compiler = createCompiler(
            [renderProtoView], [rootProtoView, expectedProtoView]);
        compiler.compileInHost(MainComponent).then((_) {
          var request = protoViewFactory.requests[1];
          expect(request[1]).toBe(renderProtoView);
          async.done();
        });
      }));
      it("should pass the component binding", inject([AsyncTestCompleter],
          (async) {
        tplResolver.setView(
            MainComponent, new viewAnn.View(template: "<div></div>"));
        var compiler = createCompiler(
            [createRenderProtoView()], [rootProtoView, createProtoView()]);
        compiler.compileInHost(MainComponent).then((_) {
          var request = protoViewFactory.requests[1];
          expect(request[0].key.token).toBe(MainComponent);
          async.done();
        });
      }));
      it("should pass the directive bindings", inject([AsyncTestCompleter],
          (async) {
        tplResolver.setView(MainComponent, new viewAnn.View(
            template: "<div></div>", directives: [SomeDirective]));
        var compiler = createCompiler(
            [createRenderProtoView()], [rootProtoView, createProtoView()]);
        compiler.compileInHost(MainComponent).then((_) {
          var request = protoViewFactory.requests[1];
          var binding = request[2][0];
          expect(binding.key.token).toBe(SomeDirective);
          async.done();
        });
      }));
      it("should use the protoView of the ProtoViewFactory", inject(
          [AsyncTestCompleter], (async) {
        tplResolver.setView(
            MainComponent, new viewAnn.View(template: "<div></div>"));
        var compiler = createCompiler(
            [createRenderProtoView()], [rootProtoView, createProtoView()]);
        compiler.compileInHost(MainComponent).then((protoViewRef) {
          expect(internalProtoView(protoViewRef)).toBe(rootProtoView);
          async.done();
        });
      }));
    });
    it("should load nested components", inject([AsyncTestCompleter], (async) {
      tplResolver.setView(
          MainComponent, new viewAnn.View(template: "<div></div>"));
      tplResolver.setView(
          NestedComponent, new viewAnn.View(template: "<div></div>"));
      var mainProtoView = createProtoView(
          [createComponentElementBinder(directiveResolver, NestedComponent)]);
      var nestedProtoView = createProtoView();
      var renderPvDtos = [
        createRenderProtoView([createRenderComponentElementBinder(0)]),
        createRenderProtoView()
      ];
      var compiler = createCompiler(
          renderPvDtos, [rootProtoView, mainProtoView, nestedProtoView]);
      compiler.compileInHost(MainComponent).then((protoViewRef) {
        expect(originalRenderProtoViewRefs(internalProtoView(protoViewRef)))
            .toEqual([
          rootProtoView.render,
          [mainProtoView.render, [nestedProtoView.render]]
        ]);
        expect(internalProtoView(protoViewRef).elementBinders[
            0].nestedProtoView).toBe(mainProtoView);
        expect(mainProtoView.elementBinders[0].nestedProtoView)
            .toBe(nestedProtoView);
        async.done();
      });
    }));
    it("should load nested components in viewcontainers", inject(
        [AsyncTestCompleter], (async) {
      tplResolver.setView(
          MainComponent, new viewAnn.View(template: "<div></div>"));
      tplResolver.setView(
          NestedComponent, new viewAnn.View(template: "<div></div>"));
      var viewportProtoView = createProtoView(
          [createComponentElementBinder(directiveResolver, NestedComponent)],
          renderApi.ViewType.EMBEDDED);
      var mainProtoView =
          createProtoView([createViewportElementBinder(viewportProtoView)]);
      var nestedProtoView = createProtoView();
      var renderPvDtos = [
        createRenderProtoView([
          createRenderViewportElementBinder(createRenderProtoView(
              [createRenderComponentElementBinder(0)],
              renderApi.ViewType.EMBEDDED))
        ]),
        createRenderProtoView()
      ];
      var compiler = createCompiler(
          renderPvDtos, [rootProtoView, mainProtoView, nestedProtoView]);
      compiler.compileInHost(MainComponent).then((protoViewRef) {
        expect(internalProtoView(protoViewRef).elementBinders[
            0].nestedProtoView).toBe(mainProtoView);
        expect(originalRenderProtoViewRefs(internalProtoView(protoViewRef)))
            .toEqual([rootProtoView.render, [mainProtoView.render, null]]);
        expect(viewportProtoView.elementBinders[0].nestedProtoView)
            .toBe(nestedProtoView);
        expect(originalRenderProtoViewRefs(viewportProtoView))
            .toEqual([viewportProtoView.render, [nestedProtoView.render]]);
        async.done();
      });
    }));
    it("should cache compiled host components", inject([AsyncTestCompleter],
        (async) {
      tplResolver.setView(
          MainComponent, new viewAnn.View(template: "<div></div>"));
      var mainPv = createProtoView();
      var compiler =
          createCompiler([createRenderProtoView([])], [rootProtoView, mainPv]);
      compiler.compileInHost(MainComponent).then((protoViewRef) {
        expect(internalProtoView(protoViewRef).elementBinders[
            0].nestedProtoView).toBe(mainPv);
        return compiler.compileInHost(MainComponent);
      }).then((protoViewRef) {
        expect(internalProtoView(protoViewRef).elementBinders[
            0].nestedProtoView).toBe(mainPv);
        async.done();
      });
    }));
    it("should not bind directives for cached components", inject(
        [AsyncTestCompleter], (async) {
      // set up the cache with the test proto view
      AppProtoView mainPv = createProtoView();
      CompilerCache cache = new CompilerCache();
      cache.setHost(MainComponent, mainPv);
      // create the spy resolver
      dynamic reader = new SpyDirectiveResolver();
      // create the compiler
      var compiler = new Compiler(reader, cache, tplResolver, cmpUrlMapper,
          new UrlResolver(), renderCompiler, protoViewFactory,
          new AppRootUrl("http://www.app.com"));
      compiler.compileInHost(MainComponent).then((protoViewRef) {
        // the test should have failed if the resolver was called, so we're good
        async.done();
      });
    }));
    it("should cache compiled nested components", inject([AsyncTestCompleter],
        (async) {
      tplResolver.setView(
          MainComponent, new viewAnn.View(template: "<div></div>"));
      tplResolver.setView(
          MainComponent2, new viewAnn.View(template: "<div></div>"));
      tplResolver.setView(
          NestedComponent, new viewAnn.View(template: "<div></div>"));
      var rootProtoView2 =
          createRootProtoView(directiveResolver, MainComponent2);
      var mainPv = createProtoView(
          [createComponentElementBinder(directiveResolver, NestedComponent)]);
      var nestedPv = createProtoView([]);
      var compiler = createCompiler([
        createRenderProtoView(),
        createRenderProtoView(),
        createRenderProtoView()
      ], [rootProtoView, mainPv, nestedPv, rootProtoView2, mainPv]);
      compiler.compileInHost(MainComponent).then((protoViewRef) {
        expect(internalProtoView(protoViewRef).elementBinders[
                0].nestedProtoView.elementBinders[0].nestedProtoView)
            .toBe(nestedPv);
        return compiler.compileInHost(MainComponent2);
      }).then((protoViewRef) {
        expect(internalProtoView(protoViewRef).elementBinders[
                0].nestedProtoView.elementBinders[0].nestedProtoView)
            .toBe(nestedPv);
        async.done();
      });
    }));
    it("should re-use components being compiled", inject([AsyncTestCompleter],
        (async) {
      tplResolver.setView(
          MainComponent, new viewAnn.View(template: "<div></div>"));
      PromiseCompleter<renderApi.ProtoViewDto> renderProtoViewCompleter =
          PromiseWrapper.completer();
      var expectedProtoView = createProtoView();
      var compiler = createCompiler([renderProtoViewCompleter.promise], [
        rootProtoView,
        rootProtoView,
        expectedProtoView
      ]);
      var result = PromiseWrapper.all([
        compiler.compileInHost(MainComponent),
        compiler.compileInHost(MainComponent),
        renderProtoViewCompleter.promise
      ]);
      renderProtoViewCompleter.resolve(createRenderProtoView());
      result.then((protoViewRefs) {
        expect(internalProtoView(protoViewRefs[0]).elementBinders[
            0].nestedProtoView).toBe(expectedProtoView);
        expect(internalProtoView(protoViewRefs[1]).elementBinders[
            0].nestedProtoView).toBe(expectedProtoView);
        async.done();
      });
    }));
    it("should throw on unconditional recursive components", inject(
        [AsyncTestCompleter], (async) {
      tplResolver.setView(
          MainComponent, new viewAnn.View(template: "<div></div>"));
      var mainProtoView = createProtoView(
          [createComponentElementBinder(directiveResolver, MainComponent)]);
      var compiler = createCompiler(
          [createRenderProtoView([createRenderComponentElementBinder(0)])], [
        rootProtoView,
        mainProtoView
      ]);
      PromiseWrapper.catchError(compiler.compileInHost(MainComponent), (e) {
        expect(() {
          throw e;
        }).toThrowError(
            '''Unconditional component cycle in ${ stringify ( MainComponent )}''');
        async.done();
        return null;
      });
    }));
    it("should allow recursive components that are connected via an embedded ProtoView",
        inject([AsyncTestCompleter], (async) {
      tplResolver.setView(
          MainComponent, new viewAnn.View(template: "<div></div>"));
      var viewportProtoView = createProtoView(
          [createComponentElementBinder(directiveResolver, MainComponent)],
          renderApi.ViewType.EMBEDDED);
      var mainProtoView =
          createProtoView([createViewportElementBinder(viewportProtoView)]);
      var renderPvDtos = [
        createRenderProtoView([
          createRenderViewportElementBinder(createRenderProtoView(
              [createRenderComponentElementBinder(0)],
              renderApi.ViewType.EMBEDDED))
        ]),
        createRenderProtoView()
      ];
      var compiler =
          createCompiler(renderPvDtos, [rootProtoView, mainProtoView]);
      compiler.compileInHost(MainComponent).then((protoViewRef) {
        expect(internalProtoView(protoViewRef).elementBinders[
            0].nestedProtoView).toBe(mainProtoView);
        expect(mainProtoView.elementBinders[0].nestedProtoView.elementBinders[
            0].nestedProtoView).toBe(mainProtoView);
        // In case of a cycle, don't merge the embedded proto views into the component!
        expect(originalRenderProtoViewRefs(internalProtoView(protoViewRef)))
            .toEqual([rootProtoView.render, [mainProtoView.render, null]]);
        expect(originalRenderProtoViewRefs(viewportProtoView))
            .toEqual([viewportProtoView.render, [mainProtoView.render, null]]);
        async.done();
      });
    }));
    it("should throw on recursive components that are connected via an embedded ProtoView with <ng-content>",
        inject([AsyncTestCompleter], (async) {
      tplResolver.setView(
          MainComponent, new viewAnn.View(template: "<div></div>"));
      var viewportProtoView = createProtoView(
          [createComponentElementBinder(directiveResolver, MainComponent)],
          renderApi.ViewType.EMBEDDED, true);
      var mainProtoView =
          createProtoView([createViewportElementBinder(viewportProtoView)]);
      var renderPvDtos = [
        createRenderProtoView([
          createRenderViewportElementBinder(createRenderProtoView(
              [createRenderComponentElementBinder(0)],
              renderApi.ViewType.EMBEDDED))
        ]),
        createRenderProtoView()
      ];
      var compiler =
          createCompiler(renderPvDtos, [rootProtoView, mainProtoView]);
      PromiseWrapper.catchError(compiler.compileInHost(MainComponent), (e) {
        expect(() {
          throw e;
        }).toThrowError(
            '''<ng-content> is used within the recursive path of ${ stringify ( MainComponent )}''');
        async.done();
        return null;
      });
    }));
    it("should create host proto views", inject([AsyncTestCompleter], (async) {
      tplResolver.setView(
          MainComponent, new viewAnn.View(template: "<div></div>"));
      var rootProtoView = createProtoView(
          [createComponentElementBinder(directiveResolver, MainComponent)],
          renderApi.ViewType.HOST);
      var mainProtoView = createProtoView();
      var compiler = createCompiler(
          [createRenderProtoView()], [rootProtoView, mainProtoView]);
      compiler.compileInHost(MainComponent).then((protoViewRef) {
        expect(internalProtoView(protoViewRef)).toBe(rootProtoView);
        expect(rootProtoView.elementBinders[0].nestedProtoView)
            .toBe(mainProtoView);
        async.done();
      });
    }));
    it("should throw for non component types", () {
      var compiler = createCompiler([], []);
      expect(() => compiler.compileInHost(SomeDirective)).toThrowError(
          '''Could not load \'${ stringify ( SomeDirective )}\' because it is not a component.''');
    });
  });
}
DirectiveBinding createDirectiveBinding(directiveResolver, type) {
  var annotation = directiveResolver.resolve(type);
  return DirectiveBinding.createFromType(type, annotation);
}
AppProtoView createProtoView([elementBinders = null,
    renderApi.ViewType type = null, bool isEmbeddedFragment = false]) {
  if (isBlank(type)) {
    type = renderApi.ViewType.COMPONENT;
  }
  var pv = new AppProtoView(type, isEmbeddedFragment,
      new renderApi.RenderProtoViewRef(), null, null, new Map(), null);
  if (isBlank(elementBinders)) {
    elementBinders = [];
  }
  pv.elementBinders = elementBinders;
  return pv;
}
ElementBinder createComponentElementBinder(directiveResolver, type) {
  var binding = createDirectiveBinding(directiveResolver, type);
  return new ElementBinder(0, null, 0, null, binding);
}
ElementBinder createViewportElementBinder(nestedProtoView) {
  var elBinder = new ElementBinder(0, null, 0, null, null);
  elBinder.nestedProtoView = nestedProtoView;
  return elBinder;
}
renderApi.ProtoViewDto createRenderProtoView(
    [elementBinders = null, renderApi.ViewType type = null]) {
  if (isBlank(type)) {
    type = renderApi.ViewType.COMPONENT;
  }
  if (isBlank(elementBinders)) {
    elementBinders = [];
  }
  return new renderApi.ProtoViewDto(
      elementBinders: elementBinders,
      type: type,
      render: new renderApi.RenderProtoViewRef());
}
renderApi.ElementBinder createRenderComponentElementBinder(directiveIndex) {
  return new renderApi.ElementBinder(
      directives: [
    new renderApi.DirectiveBinder(directiveIndex: directiveIndex)
  ]);
}
renderApi.ElementBinder createRenderViewportElementBinder(nestedProtoView) {
  return new renderApi.ElementBinder(nestedProtoView: nestedProtoView);
}
AppProtoView createRootProtoView(directiveResolver, type) {
  return createProtoView(
      [createComponentElementBinder(directiveResolver, type)],
      renderApi.ViewType.HOST);
}
@Component(selector: "main-comp")
class MainComponent {}
@Component(selector: "main-comp2")
class MainComponent2 {}
@Component(selector: "nested")
class NestedComponent {}
class RecursiveComponent {}
@Component(selector: "some-dynamic")
class SomeDynamicComponentDirective {}
@Directive(selector: "some")
class SomeDirective {}
@Directive(compileChildren: false)
class IgnoreChildrenDirective {}
@Directive(host: const {"(someEvent)": "someAction"})
class DirectiveWithEvents {}
@Directive(host: const {"[someProp]": "someExp"})
class DirectiveWithProperties {}
@Directive(properties: const ["a: b"])
class DirectiveWithBind {}
@Directive(selector: "directive-with-accts")
class DirectiveWithAttributes {
  DirectiveWithAttributes(@Attribute("someAttr") String someAttr) {}
}
@proxy()
class SpyRenderCompiler extends SpyObject implements RenderCompiler {
  SpyRenderCompiler() : super(RenderCompiler) {
    /* super call moved to initializer */;
  }
  noSuchMethod(m) {
    return super.noSuchMethod(m);
  }
}
@proxy()
class SpyDirectiveResolver extends SpyObject implements DirectiveResolver {
  SpyDirectiveResolver() : super(DirectiveResolver) {
    /* super call moved to initializer */;
  }
  noSuchMethod(m) {
    return super.noSuchMethod(m);
  }
}
class FakeViewResolver extends ViewResolver {
  Map<Type, viewAnn.View> _cmpViews = new Map();
  FakeViewResolver() : super() {
    /* super call moved to initializer */;
  }
  viewAnn.View resolve(Type component) {
    // returns null for dynamic components
    return this._cmpViews.containsKey(component)
        ? this._cmpViews[component]
        : null;
  }
  void setView(Type component, viewAnn.View view) {
    this._cmpViews[component] = view;
  }
}
class FakeProtoViewFactory extends ProtoViewFactory {
  List<AppProtoView> results;
  List<List<dynamic>> requests;
  FakeProtoViewFactory(this.results) : super(null) {
    /* super call moved to initializer */;
    this.requests = [];
  }
  List<AppProtoView> createAppProtoViews(DirectiveBinding componentBinding,
      renderApi.ProtoViewDto renderProtoView,
      List<DirectiveBinding> directives) {
    this.requests.add([componentBinding, renderProtoView, directives]);
    return collectEmbeddedPvs(ListWrapper.removeAt(this.results, 0));
  }
}
class MergedRenderProtoViewRef extends renderApi.RenderProtoViewRef {
  List<renderApi.RenderProtoViewRef> originals;
  MergedRenderProtoViewRef(this.originals) : super() {
    /* super call moved to initializer */;
  }
}
originalRenderProtoViewRefs(AppProtoView appProtoView) {
  return ((appProtoView.mergeMapping.renderProtoViewRef as MergedRenderProtoViewRef)).originals;
}
List<AppProtoView> collectEmbeddedPvs(AppProtoView pv,
    [List<AppProtoView> target = null]) {
  if (isBlank(target)) {
    target = [];
  }
  target.add(pv);
  pv.elementBinders.forEach((elementBinder) {
    if (elementBinder.hasEmbeddedProtoView()) {
      collectEmbeddedPvs(elementBinder.nestedProtoView, target);
    }
  });
  return target;
}
