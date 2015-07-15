library angular2.src.core.compiler.element_injector;

import "package:angular2/src/facade/lang.dart"
    show isPresent, isBlank, Type, BaseException, stringify, StringWrapper;
import "package:angular2/src/facade/async.dart"
    show EventEmitter, ObservableWrapper;
import "package:angular2/src/facade/collection.dart"
    show List, ListWrapper, MapWrapper, StringMapWrapper;
import "package:angular2/di.dart"
    show
        Injector,
        ProtoInjector,
        PUBLIC_AND_PRIVATE,
        PUBLIC,
        PRIVATE,
        undefinedValue,
        Key,
        Dependency,
        bind,
        Binding,
        ResolvedBinding,
        NoBindingError,
        AbstractBindingError,
        CyclicDependencyError,
        resolveForwardRef,
        VisibilityMetadata,
        DependencyProvider;
import "package:angular2/src/di/injector.dart"
    show InjectorInlineStrategy, InjectorDynamicStrategy, BindingWithVisibility;
import "package:angular2/src/core/annotations_impl/di.dart"
    show Attribute, Query;
import "view.dart" as viewModule;
import "view_manager.dart" as avmModule;
import "view_container_ref.dart" show ViewContainerRef;
import "element_ref.dart" show ElementRef;
import "view_ref.dart" show ProtoViewRef, ViewRef;
import "package:angular2/src/core/annotations_impl/annotations.dart"
    show Directive, Component, LifecycleEvent;
import "directive_lifecycle_reflector.dart" show hasLifecycleHook;
import "package:angular2/change_detection.dart"
    show ChangeDetector, ChangeDetectorRef, Pipes;
import "query_list.dart" show QueryList;
import "package:angular2/src/reflection/reflection.dart" show reflector;
import "package:angular2/src/render/api.dart" show DirectiveMetadata;

var _staticKeys;
class StaticKeys {
  num viewManagerId;
  num protoViewId;
  num viewContainerId;
  num changeDetectorRefId;
  num elementRefId;
  Key pipesKey;
  StaticKeys() {
    this.viewManagerId = Key.get(avmModule.AppViewManager).id;
    this.protoViewId = Key.get(ProtoViewRef).id;
    this.viewContainerId = Key.get(ViewContainerRef).id;
    this.changeDetectorRefId = Key.get(ChangeDetectorRef).id;
    this.elementRefId = Key.get(ElementRef).id;
    // not an id because the public API of injector works only with keys and tokens
    this.pipesKey = Key.get(Pipes);
  }
  static StaticKeys instance() {
    if (isBlank(_staticKeys)) _staticKeys = new StaticKeys();
    return _staticKeys;
  }
}
class TreeNode<T extends TreeNode<dynamic>> {
  T _parent;
  T _head = null;
  T _tail = null;
  T _next = null;
  TreeNode(T parent) {
    if (isPresent(parent)) parent.addChild(this);
  }
  /**
   * Adds a child to the parent node. The child MUST NOT be a part of a tree.
   */
  void addChild(T child) {
    if (isPresent(this._tail)) {
      this._tail._next = child;
      this._tail = child;
    } else {
      this._tail = this._head = child;
    }
    child._next = null;
    child._parent = this;
  }
  /**
   * Adds a child to the parent node after a given sibling.
   * The child MUST NOT be a part of a tree and the sibling must be present.
   */
  void addChildAfter(T child, T prevSibling) {
    if (isBlank(prevSibling)) {
      var prevHead = this._head;
      this._head = child;
      child._next = prevHead;
      if (isBlank(this._tail)) this._tail = child;
    } else if (isBlank(prevSibling._next)) {
      this.addChild(child);
      return;
    } else {
      child._next = prevSibling._next;
      prevSibling._next = child;
    }
    child._parent = this;
  }
  /**
   * Detaches a node from the parent's tree.
   */
  void remove() {
    if (isBlank(this.parent)) return;
    var nextSibling = this._next;
    var prevSibling = this._findPrev();
    if (isBlank(prevSibling)) {
      this.parent._head = this._next;
    } else {
      prevSibling._next = this._next;
    }
    if (isBlank(nextSibling)) {
      this._parent._tail = prevSibling;
    }
    this._parent = null;
    this._next = null;
  }
  /**
   * Finds a previous sibling or returns null if first child.
   * Assumes the node has a parent.
   * TODO(rado): replace with DoublyLinkedList to avoid O(n) here.
   */
  _findPrev() {
    var node = this.parent._head;
    if (node == this) return null;
    while (!identical(node._next, this)) node = node._next;
    return node;
  }
  get parent {
    return this._parent;
  }
  // TODO(rado): replace with a function call, does too much work for a getter.
  List<T> get children {
    var res = [];
    var child = this._head;
    while (child != null) {
      res.add(child);
      child = child._next;
    }
    return res;
  }
}
class DirectiveDependency extends Dependency {
  String attributeName;
  Query queryDecorator;
  DirectiveDependency(Key key, bool optional, dynamic visibility,
      List<dynamic> properties, this.attributeName, this.queryDecorator)
      : super(key, optional, visibility, properties) {
    /* super call moved to initializer */;
    this._verify();
  }
  void _verify() {
    var count = 0;
    if (isPresent(this.queryDecorator)) count++;
    if (isPresent(this.attributeName)) count++;
    if (count > 1) throw new BaseException(
        "A directive injectable can contain only one of the following @Attribute or @Query.");
  }
  static Dependency createFrom(Dependency d) {
    return new DirectiveDependency(d.key, d.optional, d.visibility,
        d.properties, DirectiveDependency._attributeName(d.properties),
        DirectiveDependency._query(d.properties));
  }
  static String _attributeName(properties) {
    var p = (ListWrapper.find(properties, (p) => p is Attribute) as Attribute);
    return isPresent(p) ? p.attributeName : null;
  }
  static Query _query(properties) {
    return (ListWrapper.find(properties, (p) => p is Query) as Query);
  }
}
class DirectiveBinding extends ResolvedBinding {
  List<ResolvedBinding> resolvedHostInjectables;
  List<ResolvedBinding> resolvedViewInjectables;
  DirectiveMetadata metadata;
  DirectiveBinding(Key key, Function factory, List<Dependency> dependencies,
      this.resolvedHostInjectables, this.resolvedViewInjectables, this.metadata)
      : super(key, factory, dependencies) {
    /* super call moved to initializer */;
  }
  bool get callOnDestroy {
    return this.metadata.callOnDestroy;
  }
  bool get callOnChange {
    return this.metadata.callOnChange;
  }
  bool get callOnAllChangesDone {
    return this.metadata.callOnAllChangesDone;
  }
  String get displayName {
    return this.key.displayName;
  }
  List<String> get eventEmitters {
    return isPresent(this.metadata) && isPresent(this.metadata.events)
        ? this.metadata.events
        : [];
  }
  Map<String, String> get hostActions {
    return isPresent(this.metadata) && isPresent(this.metadata.hostActions)
        ? this.metadata.hostActions
        : new Map();
  }
  get changeDetection {
    return this.metadata.changeDetection;
  }
  static DirectiveBinding createFromBinding(Binding binding, Directive ann) {
    if (isBlank(ann)) {
      ann = new Directive();
    }
    var rb = binding.resolve();
    var deps = ListWrapper.map(rb.dependencies, DirectiveDependency.createFrom);
    var resolvedHostInjectables =
        isPresent(ann.hostInjector) ? Injector.resolve(ann.hostInjector) : [];
    var resolvedViewInjectables = ann is Component &&
        isPresent(ann.viewInjector) ? Injector.resolve(ann.viewInjector) : [];
    var metadata = DirectiveMetadata.create(
        id: stringify(rb.key.token),
        type: ann is Component
            ? DirectiveMetadata.COMPONENT_TYPE
            : DirectiveMetadata.DIRECTIVE_TYPE,
        selector: ann.selector,
        compileChildren: ann.compileChildren,
        events: ann.events,
        host: isPresent(ann.host)
            ? MapWrapper.createFromStringMap(ann.host)
            : null,
        properties: ann.properties,
        readAttributes: DirectiveBinding._readAttributes(deps),
        callOnDestroy: hasLifecycleHook(
            LifecycleEvent.onDestroy, rb.key.token, ann),
        callOnChange: hasLifecycleHook(
            LifecycleEvent.onChange, rb.key.token, ann),
        callOnCheck: hasLifecycleHook(
            LifecycleEvent.onCheck, rb.key.token, ann),
        callOnInit: hasLifecycleHook(LifecycleEvent.onInit, rb.key.token, ann),
        callOnAllChangesDone: hasLifecycleHook(
            LifecycleEvent.onAllChangesDone, rb.key.token, ann),
        changeDetection: ann is Component ? ann.changeDetection : null,
        exportAs: ann.exportAs);
    return new DirectiveBinding(rb.key, rb.factory, deps,
        resolvedHostInjectables, resolvedViewInjectables, metadata);
  }
  static _readAttributes(deps) {
    var readAttributes = [];
    ListWrapper.forEach(deps, (dep) {
      if (isPresent(dep.attributeName)) {
        readAttributes.add(dep.attributeName);
      }
    });
    return readAttributes;
  }
  static DirectiveBinding createFromType(Type type, Directive annotation) {
    var binding = new Binding(type, toClass: type);
    return DirectiveBinding.createFromBinding(binding, annotation);
  }
}
// TODO(rado): benchmark and consider rolling in as ElementInjector fields.
class PreBuiltObjects {
  avmModule.AppViewManager viewManager;
  viewModule.AppView view;
  viewModule.AppProtoView protoView;
  PreBuiltObjects(this.viewManager, this.view, this.protoView) {}
}
class EventEmitterAccessor {
  String eventName;
  Function getter;
  EventEmitterAccessor(this.eventName, this.getter) {}
  Object subscribe(
      viewModule.AppView view, num boundElementIndex, Object directive) {
    var eventEmitter = this.getter(directive);
    return ObservableWrapper.subscribe(eventEmitter, (eventObj) =>
        view.triggerEventHandlers(this.eventName, eventObj, boundElementIndex));
  }
}
class HostActionAccessor {
  String methodName;
  Function getter;
  HostActionAccessor(this.methodName, this.getter) {}
  Object subscribe(
      viewModule.AppView view, num boundElementIndex, Object directive) {
    var eventEmitter = this.getter(directive);
    return ObservableWrapper.subscribe(eventEmitter, (actionArgs) => view
        .invokeElementMethod(boundElementIndex, this.methodName, actionArgs));
  }
}
List<EventEmitterAccessor> _createEventEmitterAccessors(
    BindingWithVisibility bwv) {
  var binding = bwv.binding;
  if (!(binding is DirectiveBinding)) return [];
  var db = (binding as DirectiveBinding);
  return ListWrapper.map(db.eventEmitters, (eventConfig) {
    var fieldName;
    var eventName;
    var colonIdx = eventConfig.indexOf(":");
    if (colonIdx > -1) {
      // long format: 'fieldName: eventName'
      fieldName = StringWrapper.substring(eventConfig, 0, colonIdx).trim();
      eventName = StringWrapper.substring(eventConfig, colonIdx + 1).trim();
    } else {
      // short format: 'name' when fieldName and eventName are the same
      fieldName = eventName = eventConfig;
    }
    return new EventEmitterAccessor(eventName, reflector.getter(fieldName));
  });
}
List<HostActionAccessor> _createHostActionAccessors(BindingWithVisibility bwv) {
  var binding = bwv.binding;
  if (!(binding is DirectiveBinding)) return [];
  var res = [];
  var db = (binding as DirectiveBinding);
  MapWrapper.forEach(db.hostActions, (actionExpression, actionName) {
    res.add(
        new HostActionAccessor(actionExpression, reflector.getter(actionName)));
  });
  return res;
}
class ProtoElementInjector {
  ProtoElementInjector parent;
  int index;
  num distanceToParent;
  bool _firstBindingIsComponent;
  Map<String, num> directiveVariableBindings;
  viewModule.AppView view;
  Map<String, String> attributes;
  List<List<EventEmitterAccessor>> eventEmitterAccessors;
  List<List<HostActionAccessor>> hostActionAccessors;
  ProtoInjector protoInjector;
  static ProtoElementInjector create(ProtoElementInjector parent, num index,
      List<ResolvedBinding> bindings, bool firstBindingIsComponent,
      num distanceToParent, Map<String, num> directiveVariableBindings) {
    var bd = [];
    ProtoElementInjector._createDirectiveBindingWithVisibility(
        bindings, bd, firstBindingIsComponent);
    if (firstBindingIsComponent) {
      ProtoElementInjector._createViewInjectorBindingWithVisibility(
          bindings, bd);
    }
    ProtoElementInjector._createHostInjectorBindingWithVisibility(
        bindings, bd, firstBindingIsComponent);
    return new ProtoElementInjector(parent, index, bd, distanceToParent,
        firstBindingIsComponent, directiveVariableBindings);
  }
  static _createDirectiveBindingWithVisibility(
      List<ResolvedBinding> dirBindings, List<BindingWithVisibility> bd,
      bool firstBindingIsComponent) {
    ListWrapper.forEach(dirBindings, (dirBinding) {
      bd.add(ProtoElementInjector._createBindingWithVisibility(
          firstBindingIsComponent, dirBinding, dirBindings, dirBinding));
    });
  }
  static _createHostInjectorBindingWithVisibility(
      List<ResolvedBinding> dirBindings, List<BindingWithVisibility> bd,
      bool firstBindingIsComponent) {
    ListWrapper.forEach(dirBindings, (dirBinding) {
      ListWrapper.forEach(dirBinding.resolvedHostInjectables, (b) {
        bd.add(ProtoElementInjector._createBindingWithVisibility(
            firstBindingIsComponent, dirBinding, dirBindings, b));
      });
    });
  }
  static _createBindingWithVisibility(
      firstBindingIsComponent, dirBinding, dirBindings, binding) {
    var isComponent =
        firstBindingIsComponent && identical(dirBindings[0], dirBinding);
    return new BindingWithVisibility(
        binding, isComponent ? PUBLIC_AND_PRIVATE : PUBLIC);
  }
  static _createViewInjectorBindingWithVisibility(
      List<ResolvedBinding> bindings, List<BindingWithVisibility> bd) {
    var db = (bindings[0] as DirectiveBinding);
    ListWrapper.forEach(db.resolvedViewInjectables,
        (b) => bd.add(new BindingWithVisibility(b, PRIVATE)));
  }
  ProtoElementInjector(this.parent, this.index, List<BindingWithVisibility> bwv,
      this.distanceToParent, this._firstBindingIsComponent,
      this.directiveVariableBindings) {
    var length = bwv.length;
    this.protoInjector = new ProtoInjector(bwv, distanceToParent);
    this.eventEmitterAccessors = ListWrapper.createFixedSize(length);
    this.hostActionAccessors = ListWrapper.createFixedSize(length);
    for (var i = 0; i < length; ++i) {
      this.eventEmitterAccessors[i] = _createEventEmitterAccessors(bwv[i]);
      this.hostActionAccessors[i] = _createHostActionAccessors(bwv[i]);
    }
  }
  ElementInjector instantiate(ElementInjector parent) {
    return new ElementInjector(this, parent);
  }
  ProtoElementInjector directParent() {
    return this.distanceToParent < 2 ? this.parent : null;
  }
  bool get hasBindings {
    return this.eventEmitterAccessors.length > 0;
  }
  dynamic getBindingAtIndex(num index) {
    return this.protoInjector.getBindingAtIndex(index);
  }
}
class ElementInjector extends TreeNode<ElementInjector>
    implements DependencyProvider {
  ProtoElementInjector _proto;
  ElementInjector _host;
  var _preBuiltObjects = null;
  // Queries are added during construction or linking with a new parent.

  // They are removed only through unlinking.
  QueryRef _query0;
  QueryRef _query1;
  QueryRef _query2;
  bool hydrated;
  Injector _injector;
  _ElementInjectorStrategy _strategy;
  ElementInjector(this._proto, ElementInjector parent) : super(parent) {
    /* super call moved to initializer */;
    this._injector = new Injector(this._proto.protoInjector, null, this);
    // we couple ourselves to the injector strategy to avoid polymoprhic calls
    var injectorStrategy = (this._injector.internalStrategy as dynamic);
    this._strategy = injectorStrategy is InjectorInlineStrategy
        ? new ElementInjectorInlineStrategy(injectorStrategy, this)
        : new ElementInjectorDynamicStrategy(injectorStrategy, this);
    this.hydrated = false;
    this._buildQueries();
    this._addParentQueries();
  }
  void dehydrate() {
    this.hydrated = false;
    this._host = null;
    this._preBuiltObjects = null;
    this._strategy.callOnDestroy();
    this._strategy.dehydrate();
  }
  void onAllChangesDone() {
    if (isPresent(this._query0) && identical(this._query0.originator, this)) {
      this._query0.list.fireCallbacks();
    }
    if (isPresent(this._query1) && identical(this._query1.originator, this)) {
      this._query1.list.fireCallbacks();
    }
    if (isPresent(this._query2) && identical(this._query2.originator, this)) {
      this._query2.list.fireCallbacks();
    }
  }
  void hydrate(Injector imperativelyCreatedInjector, ElementInjector host,
      PreBuiltObjects preBuiltObjects) {
    this._host = host;
    this._preBuiltObjects = preBuiltObjects;
    this._reattachInjectors(imperativelyCreatedInjector, host);
    this._strategy.hydrate();
    if (isPresent(host)) {
      this._addViewQueries(host);
    }
    this._addDirectivesToQueries();
    this._addVarBindingsToQueries();
    this.hydrated = true;
  }
  void _reattachInjectors(
      Injector imperativelyCreatedInjector, ElementInjector host) {
    if (isPresent(this._parent)) {
      this._reattachInjector(this._injector, this._parent._injector, false);
    } else {
      // This injector is at the boundary.

      //

      // The injector tree we are assembling:

      //

      // host._injector (only if present)

      //   |

      //   |boundary

      //   |

      // imperativelyCreatedInjector (only if present)

      //   |

      //   |boundary

      //   |

      // this._injector

      //

      // host._injector (only if present)

      //   |

      //   |boundary

      //   |

      // imperativelyCreatedInjector (only if present)
      if (isPresent(imperativelyCreatedInjector) && isPresent(host)) {
        this._reattachInjector(
            imperativelyCreatedInjector, host._injector, true);
      }
      // host._injector OR imperativelyCreatedInjector OR null

      //   |

      //   |boundary

      //   |

      // this._injector
      var parent =
          this._closestBoundaryInjector(imperativelyCreatedInjector, host);
      this._reattachInjector(this._injector, parent, true);
    }
  }
  Injector _closestBoundaryInjector(
      Injector imperativelyCreatedInjector, ElementInjector host) {
    if (isPresent(imperativelyCreatedInjector)) {
      return imperativelyCreatedInjector;
    } else if (isPresent(host)) {
      return host._injector;
    } else {
      return null;
    }
  }
  _reattachInjector(
      Injector injector, Injector parentInjector, bool isBoundary) {
    injector.internalStrategy.attach(parentInjector, isBoundary);
  }
  Pipes getPipes() {
    var pipesKey = StaticKeys.instance().pipesKey;
    return this._injector.getOptional(pipesKey);
  }
  bool hasVariableBinding(String name) {
    var vb = this._proto.directiveVariableBindings;
    return isPresent(vb) && vb.containsKey(name);
  }
  dynamic getVariableBinding(String name) {
    var index = this._proto.directiveVariableBindings[name];
    return isPresent(index)
        ? this.getDirectiveAtIndex((index as num))
        : this.getElementRef();
  }
  dynamic get(token) {
    return this._injector.get(token);
  }
  bool hasDirective(Type type) {
    return isPresent(this._injector.getOptional(type));
  }
  List<List<EventEmitterAccessor>> getEventEmitterAccessors() {
    return this._proto.eventEmitterAccessors;
  }
  List<List<HostActionAccessor>> getHostActionAccessors() {
    return this._proto.hostActionAccessors;
  }
  Map<String, num> getDirectiveVariableBindings() {
    return this._proto.directiveVariableBindings;
  }
  dynamic getComponent() {
    return this._strategy.getComponent();
  }
  ElementRef getElementRef() {
    return this._preBuiltObjects.view.elementRefs[this._proto.index];
  }
  ViewContainerRef getViewContainerRef() {
    return new ViewContainerRef(
        this._preBuiltObjects.viewManager, this.getElementRef());
  }
  ElementInjector directParent() {
    return this._proto.distanceToParent < 2 ? this.parent : null;
  }
  bool isComponentKey(Key key) {
    return this._strategy.isComponentKey(key);
  }
  dynamic getDependency(
      Injector injector, ResolvedBinding binding, Dependency dep) {
    Key key = dep.key;
    if (!(dep is DirectiveDependency)) return undefinedValue;
    var dirDep = (dep as DirectiveDependency);
    var staticKeys = StaticKeys.instance();
    if (identical(key.id,
        staticKeys.viewManagerId)) return this._preBuiltObjects.viewManager;
    if (isPresent(dirDep.attributeName)) return this._buildAttribute(dirDep);
    if (isPresent(dirDep.queryDecorator)) return this
        ._findQuery(dirDep.queryDecorator).list;
    if (identical(dirDep.key.id, StaticKeys.instance().changeDetectorRefId)) {
      var componentView =
          this._preBuiltObjects.view.componentChildViews[this._proto.index];
      return componentView.changeDetector.ref;
    }
    if (identical(dirDep.key.id, StaticKeys.instance().elementRefId)) {
      return this.getElementRef();
    }
    if (identical(dirDep.key.id, StaticKeys.instance().viewContainerId)) {
      return this.getViewContainerRef();
    }
    if (identical(dirDep.key.id, StaticKeys.instance().protoViewId)) {
      if (isBlank(this._preBuiltObjects.protoView)) {
        if (dirDep.optional) {
          return null;
        }
        throw new NoBindingError(dirDep.key);
      }
      return new ProtoViewRef(this._preBuiltObjects.protoView);
    }
    return undefinedValue;
  }
  String _buildAttribute(DirectiveDependency dep) {
    var attributes = this._proto.attributes;
    if (isPresent(attributes) && attributes.containsKey(dep.attributeName)) {
      return attributes[dep.attributeName];
    } else {
      return null;
    }
  }
  void _buildQueriesForDeps(List<DirectiveDependency> deps) {
    for (var i = 0; i < deps.length; i++) {
      var dep = deps[i];
      if (isPresent(dep.queryDecorator)) {
        this._createQueryRef(dep.queryDecorator);
      }
    }
  }
  void _addViewQueries(ElementInjector host) {
    if (isPresent(host._query0) && host._query0.originator == host) this
        ._addViewQuery(host._query0);
    if (isPresent(host._query1) && host._query1.originator == host) this
        ._addViewQuery(host._query1);
    if (isPresent(host._query2) && host._query2.originator == host) this
        ._addViewQuery(host._query2);
  }
  void _addViewQuery(QueryRef queryRef) {
    // TODO(rado): Replace this.parent check with distanceToParent = 1 when

    // https://github.com/angular/angular/issues/2707 is fixed.
    if (!queryRef.query.descendants && isPresent(this.parent)) return;
    this._assignQueryRef(queryRef);
  }
  void _addVarBindingsToQueries() {
    this._addVarBindingsToQuery(this._query0);
    this._addVarBindingsToQuery(this._query1);
    this._addVarBindingsToQuery(this._query2);
  }
  void _addDirectivesToQueries() {
    this._addDirectivesToQuery(this._query0);
    this._addDirectivesToQuery(this._query1);
    this._addDirectivesToQuery(this._query2);
  }
  void _addVarBindingsToQuery(QueryRef queryRef) {
    if (isBlank(queryRef) || !queryRef.query.isVarBindingQuery) return;
    var vb = queryRef.query.varBindings;
    for (var i = 0; i < vb.length; ++i) {
      if (this.hasVariableBinding(vb[i])) {
        queryRef.list.add(this.getVariableBinding(vb[i]));
      }
    }
  }
  void _addDirectivesToQuery(QueryRef queryRef) {
    if (isBlank(queryRef) || queryRef.query.isVarBindingQuery) return;
    var matched = [];
    this.addDirectivesMatchingQuery(queryRef.query, matched);
    matched.forEach((s) => queryRef.list.add(s));
  }
  void _createQueryRef(Query query) {
    var queryList = new QueryList<dynamic>();
    if (isBlank(this._query0)) {
      this._query0 = new QueryRef(query, queryList, this);
    } else if (isBlank(this._query1)) {
      this._query1 = new QueryRef(query, queryList, this);
    } else if (isBlank(this._query2)) {
      this._query2 = new QueryRef(query, queryList, this);
    } else {
      throw new QueryError();
    }
  }
  void addDirectivesMatchingQuery(Query query, List<dynamic> list) {
    this._strategy.addDirectivesMatchingQuery(query, list);
  }
  void _buildQueries() {
    if (isPresent(this._proto)) {
      this._strategy.buildQueries();
    }
  }
  QueryRef _findQuery(query) {
    if (isPresent(this._query0) && identical(this._query0.query, query)) {
      return this._query0;
    }
    if (isPresent(this._query1) && identical(this._query1.query, query)) {
      return this._query1;
    }
    if (isPresent(this._query2) && identical(this._query2.query, query)) {
      return this._query2;
    }
    throw new BaseException('''Cannot find query for directive ${ query}.''');
  }
  bool _hasQuery(QueryRef query) {
    return this._query0 == query ||
        this._query1 == query ||
        this._query2 == query;
  }
  void link(ElementInjector parent) {
    parent.addChild(this);
    this._addParentQueries();
  }
  void linkAfter(ElementInjector parent, ElementInjector prevSibling) {
    parent.addChildAfter(this, prevSibling);
    this._addParentQueries();
  }
  void _addParentQueries() {
    if (isBlank(this.parent)) return;
    if (isPresent(this.parent._query0) &&
        !this.parent._query0.query.isViewQuery) {
      this._addQueryToTree(this.parent._query0);
      if (this.hydrated) this.parent._query0.update();
    }
    if (isPresent(this.parent._query1) &&
        !this.parent._query1.query.isViewQuery) {
      this._addQueryToTree(this.parent._query1);
      if (this.hydrated) this.parent._query1.update();
    }
    if (isPresent(this.parent._query2) &&
        !this.parent._query2.query.isViewQuery) {
      this._addQueryToTree(this.parent._query2);
      if (this.hydrated) this.parent._query2.update();
    }
  }
  void unlink() {
    var queriesToUpdate = [];
    if (isPresent(this.parent._query0)) {
      this._pruneQueryFromTree(this.parent._query0);
      queriesToUpdate.add(this.parent._query0);
    }
    if (isPresent(this.parent._query1)) {
      this._pruneQueryFromTree(this.parent._query1);
      queriesToUpdate.add(this.parent._query1);
    }
    if (isPresent(this.parent._query2)) {
      this._pruneQueryFromTree(this.parent._query2);
      queriesToUpdate.add(this.parent._query2);
    }
    this.remove();
    ListWrapper.forEach(queriesToUpdate, (q) => q.update());
  }
  void _pruneQueryFromTree(QueryRef query) {
    this._removeQueryRef(query);
    var child = this._head;
    while (isPresent(child)) {
      child._pruneQueryFromTree(query);
      child = child._next;
    }
  }
  void _addQueryToTree(QueryRef queryRef) {
    if (queryRef.query.descendants == false) {
      if (this == queryRef.originator) {
        this._addQueryToTreeSelfAndRecurse(queryRef);
      } else if (this.parent == queryRef.originator) {
        this._assignQueryRef(queryRef);
      }
    } else {
      this._addQueryToTreeSelfAndRecurse(queryRef);
    }
  }
  void _addQueryToTreeSelfAndRecurse(QueryRef queryRef) {
    this._assignQueryRef(queryRef);
    var child = this._head;
    while (isPresent(child)) {
      child._addQueryToTree(queryRef);
      child = child._next;
    }
  }
  void _assignQueryRef(QueryRef query) {
    if (isBlank(this._query0)) {
      this._query0 = query;
      return;
    } else if (isBlank(this._query1)) {
      this._query1 = query;
      return;
    } else if (isBlank(this._query2)) {
      this._query2 = query;
      return;
    }
    throw new QueryError();
  }
  void _removeQueryRef(QueryRef query) {
    if (this._query0 == query) this._query0 = null;
    if (this._query1 == query) this._query1 = null;
    if (this._query2 == query) this._query2 = null;
  }
  dynamic getDirectiveAtIndex(num index) {
    return this._injector.getAt(index);
  }
  bool hasInstances() {
    return this._proto.hasBindings && this.hydrated;
  }
  ElementInjector getHost() {
    return this._host;
  }
  num getBoundElementIndex() {
    return this._proto.index;
  }
}
abstract class _ElementInjectorStrategy {
  void callOnDestroy();
  dynamic getComponent();
  bool isComponentKey(Key key);
  void buildQueries();
  void addDirectivesMatchingQuery(Query q, List<dynamic> res);
  DirectiveBinding getComponentBinding();
  void hydrate();
  void dehydrate();
}
/**
 * Strategy used by the `ElementInjector` when the number of bindings is 10 or less.
 * In such a case, inlining fields is benefitial for performances.
 */
class ElementInjectorInlineStrategy implements _ElementInjectorStrategy {
  InjectorInlineStrategy injectorStrategy;
  ElementInjector _ei;
  ElementInjectorInlineStrategy(this.injectorStrategy, this._ei) {}
  void hydrate() {
    var i = this.injectorStrategy;
    var p = i.protoStrategy;
    i.resetContructionCounter();
    if (p.binding0 is DirectiveBinding &&
        isPresent(p.keyId0) &&
        identical(i.obj0, undefinedValue)) i.obj0 =
        i.instantiateBinding(p.binding0, p.visibility0);
    if (p.binding1 is DirectiveBinding &&
        isPresent(p.keyId1) &&
        identical(i.obj1, undefinedValue)) i.obj1 =
        i.instantiateBinding(p.binding1, p.visibility1);
    if (p.binding2 is DirectiveBinding &&
        isPresent(p.keyId2) &&
        identical(i.obj2, undefinedValue)) i.obj2 =
        i.instantiateBinding(p.binding2, p.visibility2);
    if (p.binding3 is DirectiveBinding &&
        isPresent(p.keyId3) &&
        identical(i.obj3, undefinedValue)) i.obj3 =
        i.instantiateBinding(p.binding3, p.visibility3);
    if (p.binding4 is DirectiveBinding &&
        isPresent(p.keyId4) &&
        identical(i.obj4, undefinedValue)) i.obj4 =
        i.instantiateBinding(p.binding4, p.visibility4);
    if (p.binding5 is DirectiveBinding &&
        isPresent(p.keyId5) &&
        identical(i.obj5, undefinedValue)) i.obj5 =
        i.instantiateBinding(p.binding5, p.visibility5);
    if (p.binding6 is DirectiveBinding &&
        isPresent(p.keyId6) &&
        identical(i.obj6, undefinedValue)) i.obj6 =
        i.instantiateBinding(p.binding6, p.visibility6);
    if (p.binding7 is DirectiveBinding &&
        isPresent(p.keyId7) &&
        identical(i.obj7, undefinedValue)) i.obj7 =
        i.instantiateBinding(p.binding7, p.visibility7);
    if (p.binding8 is DirectiveBinding &&
        isPresent(p.keyId8) &&
        identical(i.obj8, undefinedValue)) i.obj8 =
        i.instantiateBinding(p.binding8, p.visibility8);
    if (p.binding9 is DirectiveBinding &&
        isPresent(p.keyId9) &&
        identical(i.obj9, undefinedValue)) i.obj9 =
        i.instantiateBinding(p.binding9, p.visibility9);
  }
  dehydrate() {
    var i = this.injectorStrategy;
    i.obj0 = undefinedValue;
    i.obj1 = undefinedValue;
    i.obj2 = undefinedValue;
    i.obj3 = undefinedValue;
    i.obj4 = undefinedValue;
    i.obj5 = undefinedValue;
    i.obj6 = undefinedValue;
    i.obj7 = undefinedValue;
    i.obj8 = undefinedValue;
    i.obj9 = undefinedValue;
  }
  void callOnDestroy() {
    var i = this.injectorStrategy;
    var p = i.protoStrategy;
    if (p.binding0 is DirectiveBinding &&
        ((p.binding0 as DirectiveBinding)).callOnDestroy) {
      i.obj0.onDestroy();
    }
    if (p.binding1 is DirectiveBinding &&
        ((p.binding1 as DirectiveBinding)).callOnDestroy) {
      i.obj1.onDestroy();
    }
    if (p.binding2 is DirectiveBinding &&
        ((p.binding2 as DirectiveBinding)).callOnDestroy) {
      i.obj2.onDestroy();
    }
    if (p.binding3 is DirectiveBinding &&
        ((p.binding3 as DirectiveBinding)).callOnDestroy) {
      i.obj3.onDestroy();
    }
    if (p.binding4 is DirectiveBinding &&
        ((p.binding4 as DirectiveBinding)).callOnDestroy) {
      i.obj4.onDestroy();
    }
    if (p.binding5 is DirectiveBinding &&
        ((p.binding5 as DirectiveBinding)).callOnDestroy) {
      i.obj5.onDestroy();
    }
    if (p.binding6 is DirectiveBinding &&
        ((p.binding6 as DirectiveBinding)).callOnDestroy) {
      i.obj6.onDestroy();
    }
    if (p.binding7 is DirectiveBinding &&
        ((p.binding7 as DirectiveBinding)).callOnDestroy) {
      i.obj7.onDestroy();
    }
    if (p.binding8 is DirectiveBinding &&
        ((p.binding8 as DirectiveBinding)).callOnDestroy) {
      i.obj8.onDestroy();
    }
    if (p.binding9 is DirectiveBinding &&
        ((p.binding9 as DirectiveBinding)).callOnDestroy) {
      i.obj9.onDestroy();
    }
  }
  dynamic getComponent() {
    return this.injectorStrategy.obj0;
  }
  bool isComponentKey(Key key) {
    return this._ei._proto._firstBindingIsComponent &&
        isPresent(key) &&
        identical(key.id, this.injectorStrategy.protoStrategy.keyId0);
  }
  void buildQueries() {
    var p = this.injectorStrategy.protoStrategy;
    if (p.binding0 is DirectiveBinding) {
      this._ei._buildQueriesForDeps(
          (p.binding0.dependencies as List<DirectiveDependency>));
    }
    if (p.binding1 is DirectiveBinding) {
      this._ei._buildQueriesForDeps(
          (p.binding1.dependencies as List<DirectiveDependency>));
    }
    if (p.binding2 is DirectiveBinding) {
      this._ei._buildQueriesForDeps(
          (p.binding2.dependencies as List<DirectiveDependency>));
    }
    if (p.binding3 is DirectiveBinding) {
      this._ei._buildQueriesForDeps(
          (p.binding3.dependencies as List<DirectiveDependency>));
    }
    if (p.binding4 is DirectiveBinding) {
      this._ei._buildQueriesForDeps(
          (p.binding4.dependencies as List<DirectiveDependency>));
    }
    if (p.binding5 is DirectiveBinding) {
      this._ei._buildQueriesForDeps(
          (p.binding5.dependencies as List<DirectiveDependency>));
    }
    if (p.binding6 is DirectiveBinding) {
      this._ei._buildQueriesForDeps(
          (p.binding6.dependencies as List<DirectiveDependency>));
    }
    if (p.binding7 is DirectiveBinding) {
      this._ei._buildQueriesForDeps(
          (p.binding7.dependencies as List<DirectiveDependency>));
    }
    if (p.binding8 is DirectiveBinding) {
      this._ei._buildQueriesForDeps(
          (p.binding8.dependencies as List<DirectiveDependency>));
    }
    if (p.binding9 is DirectiveBinding) {
      this._ei._buildQueriesForDeps(
          (p.binding9.dependencies as List<DirectiveDependency>));
    }
  }
  void addDirectivesMatchingQuery(Query query, List<dynamic> list) {
    var i = this.injectorStrategy;
    var p = i.protoStrategy;
    if (isPresent(p.binding0) &&
        identical(p.binding0.key.token, query.selector)) {
      if (identical(i.obj0, undefinedValue)) i.obj0 =
          i.instantiateBinding(p.binding0, p.visibility0);
      list.add(i.obj0);
    }
    if (isPresent(p.binding1) &&
        identical(p.binding1.key.token, query.selector)) {
      if (identical(i.obj1, undefinedValue)) i.obj1 =
          i.instantiateBinding(p.binding1, p.visibility1);
      list.add(i.obj1);
    }
    if (isPresent(p.binding2) &&
        identical(p.binding2.key.token, query.selector)) {
      if (identical(i.obj2, undefinedValue)) i.obj2 =
          i.instantiateBinding(p.binding2, p.visibility2);
      list.add(i.obj2);
    }
    if (isPresent(p.binding3) &&
        identical(p.binding3.key.token, query.selector)) {
      if (identical(i.obj3, undefinedValue)) i.obj3 =
          i.instantiateBinding(p.binding3, p.visibility3);
      list.add(i.obj3);
    }
    if (isPresent(p.binding4) &&
        identical(p.binding4.key.token, query.selector)) {
      if (identical(i.obj4, undefinedValue)) i.obj4 =
          i.instantiateBinding(p.binding4, p.visibility4);
      list.add(i.obj4);
    }
    if (isPresent(p.binding5) &&
        identical(p.binding5.key.token, query.selector)) {
      if (identical(i.obj5, undefinedValue)) i.obj5 =
          i.instantiateBinding(p.binding5, p.visibility5);
      list.add(i.obj5);
    }
    if (isPresent(p.binding6) &&
        identical(p.binding6.key.token, query.selector)) {
      if (identical(i.obj6, undefinedValue)) i.obj6 =
          i.instantiateBinding(p.binding6, p.visibility6);
      list.add(i.obj6);
    }
    if (isPresent(p.binding7) &&
        identical(p.binding7.key.token, query.selector)) {
      if (identical(i.obj7, undefinedValue)) i.obj7 =
          i.instantiateBinding(p.binding7, p.visibility7);
      list.add(i.obj7);
    }
    if (isPresent(p.binding8) &&
        identical(p.binding8.key.token, query.selector)) {
      if (identical(i.obj8, undefinedValue)) i.obj8 =
          i.instantiateBinding(p.binding8, p.visibility8);
      list.add(i.obj8);
    }
    if (isPresent(p.binding9) &&
        identical(p.binding9.key.token, query.selector)) {
      if (identical(i.obj9, undefinedValue)) i.obj9 =
          i.instantiateBinding(p.binding9, p.visibility9);
      list.add(i.obj9);
    }
  }
  DirectiveBinding getComponentBinding() {
    var p = this.injectorStrategy.protoStrategy;
    return (p.binding0 as DirectiveBinding);
  }
}
/**
 * Strategy used by the `ElementInjector` when the number of bindings is 10 or less.
 * In such a case, inlining fields is benefitial for performances.
 */
class ElementInjectorDynamicStrategy implements _ElementInjectorStrategy {
  InjectorDynamicStrategy injectorStrategy;
  ElementInjector _ei;
  ElementInjectorDynamicStrategy(this.injectorStrategy, this._ei) {}
  void hydrate() {
    var inj = this.injectorStrategy;
    var p = inj.protoStrategy;
    for (var i = 0; i < p.keyIds.length; i++) {
      if (p.bindings[i] is DirectiveBinding &&
          isPresent(p.keyIds[i]) &&
          identical(inj.objs[i], undefinedValue)) {
        inj.objs[i] = inj.instantiateBinding(p.bindings[i], p.visibilities[i]);
      }
    }
  }
  void dehydrate() {
    var inj = this.injectorStrategy;
    ListWrapper.fill(inj.objs, undefinedValue);
  }
  void callOnDestroy() {
    var ist = this.injectorStrategy;
    var p = ist.protoStrategy;
    for (var i = 0; i < p.bindings.length; i++) {
      if (p.bindings[i] is DirectiveBinding &&
          ((p.bindings[i] as DirectiveBinding)).callOnDestroy) {
        ist.objs[i].onDestroy();
      }
    }
  }
  dynamic getComponent() {
    return this.injectorStrategy.objs[0];
  }
  bool isComponentKey(Key key) {
    var p = this.injectorStrategy.protoStrategy;
    return this._ei._proto._firstBindingIsComponent &&
        isPresent(key) &&
        identical(key.id, p.keyIds[0]);
  }
  void buildQueries() {
    var inj = this.injectorStrategy;
    var p = inj.protoStrategy;
    for (var i = 0; i < p.bindings.length; i++) {
      if (p.bindings[i] is DirectiveBinding) {
        this._ei._buildQueriesForDeps(
            (p.bindings[i].dependencies as List<DirectiveDependency>));
      }
    }
  }
  void addDirectivesMatchingQuery(Query query, List<dynamic> list) {
    var ist = this.injectorStrategy;
    var p = ist.protoStrategy;
    for (var i = 0; i < p.bindings.length; i++) {
      if (identical(p.bindings[i].key.token, query.selector)) {
        if (identical(ist.objs[i], undefinedValue)) {
          ist.objs[i] =
              ist.instantiateBinding(p.bindings[i], p.visibilities[i]);
        }
        list.add(ist.objs[i]);
      }
    }
  }
  DirectiveBinding getComponentBinding() {
    var p = this.injectorStrategy.protoStrategy;
    return (p.bindings[0] as DirectiveBinding);
  }
}
class QueryError extends BaseException {
  String message;
  // TODO(rado): pass the names of the active directives.
  QueryError() : super() {
    /* super call moved to initializer */;
    this.message = "Only 3 queries can be concurrently active in a template.";
  }
  String toString() {
    return this.message;
  }
}
class QueryRef {
  Query query;
  QueryList<dynamic> list;
  ElementInjector originator;
  QueryRef(this.query, this.list, this.originator) {}
  void update() {
    var aggregator = [];
    this.visit(this.originator, aggregator);
    this.list.reset(aggregator);
  }
  void visit(ElementInjector inj, List<dynamic> aggregator) {
    if (isBlank(inj) || !inj._hasQuery(this)) return;
    if (this.query.isVarBindingQuery) {
      this._aggregateVariableBindings(inj, aggregator);
    } else {
      this._aggregateDirective(inj, aggregator);
    }
    var child = inj._head;
    while (isPresent(child)) {
      this.visit(child, aggregator);
      child = child._next;
    }
  }
  void _aggregateVariableBindings(
      ElementInjector inj, List<dynamic> aggregator) {
    var vb = this.query.varBindings;
    for (var i = 0; i < vb.length; ++i) {
      if (inj.hasVariableBinding(vb[i])) {
        aggregator.add(inj.getVariableBinding(vb[i]));
      }
    }
  }
  void _aggregateDirective(ElementInjector inj, List<dynamic> aggregator) {
    inj.addDirectivesMatchingQuery(this.query, aggregator);
  }
}
