library angular2.src.web_workers.worker.renderer;

import "package:angular2/src/render/api.dart"
    show
        Renderer,
        RenderCompiler,
        DirectiveMetadata,
        ProtoViewDto,
        ViewDefinition,
        RenderProtoViewRef,
        RenderViewRef,
        RenderElementRef,
        RenderEventDispatcher,
        RenderProtoViewMergeMapping,
        RenderViewWithFragments,
        RenderFragmentRef;
import "package:angular2/src/facade/async.dart" show Future, PromiseWrapper;
import "package:angular2/src/web-workers/worker/broker.dart"
    show MessageBroker, FnArg, UiArguments;
import "package:angular2/src/facade/lang.dart"
    show isPresent, print, BaseException;
import "package:angular2/di.dart" show Injectable;
import "package:angular2/src/web-workers/shared/render_view_with_fragments_store.dart"
    show RenderViewWithFragmentsStore, WorkerRenderViewRef;
import "package:angular2/src/web-workers/shared/api.dart" show WorkerElementRef;

@Injectable()
class WorkerCompiler implements RenderCompiler {
  MessageBroker _messageBroker;
  WorkerCompiler(this._messageBroker) {}
  /**
   * Creats a ProtoViewDto that contains a single nested component with the given componentId.
   */
  Future<ProtoViewDto> compileHost(DirectiveMetadata directiveMetadata) {
    List<FnArg> fnArgs = [new FnArg(directiveMetadata, DirectiveMetadata)];
    UiArguments args = new UiArguments("compiler", "compileHost", fnArgs);
    return this._messageBroker.runOnUiThread(args, ProtoViewDto);
  }
  /**
   * Compiles a single DomProtoView. Non recursive so that
   * we don't need to serialize all possible components over the wire,
   * but only the needed ones based on previous calls.
   */
  Future<ProtoViewDto> compile(ViewDefinition view) {
    List<FnArg> fnArgs = [new FnArg(view, ViewDefinition)];
    UiArguments args = new UiArguments("compiler", "compile", fnArgs);
    return this._messageBroker.runOnUiThread(args, ProtoViewDto);
  }
  /**
   * Merges ProtoViews.
   * The first entry of the array is the protoview into which all the other entries of the array
   * should be merged.
   * If the array contains other arrays, they will be merged before processing the parent array.
   * The array must contain an entry for every component and embedded ProtoView of the first entry.
   * @param protoViewRefs List of ProtoViewRefs or nested
   * @return the merge result for every input array in depth first order.
   */
  Future<RenderProtoViewMergeMapping> mergeProtoViewsRecursively(
      List<dynamic /* RenderProtoViewRef | List < dynamic > */ > protoViewRefs) {
    List<FnArg> fnArgs = [new FnArg(protoViewRefs, RenderProtoViewRef)];
    UiArguments args =
        new UiArguments("compiler", "mergeProtoViewsRecursively", fnArgs);
    return this._messageBroker.runOnUiThread(args, RenderProtoViewMergeMapping);
  }
}
@Injectable()
class WorkerRenderer implements Renderer {
  MessageBroker _messageBroker;
  RenderViewWithFragmentsStore _renderViewStore;
  WorkerRenderer(this._messageBroker, this._renderViewStore) {}
  /**
   * Creates a root host view that includes the given element.
   * Note that the fragmentCount needs to be passed in so that we can create a result
   * synchronously even when dealing with webworkers!
   *
   * @param {RenderProtoViewRef} hostProtoViewRef a RenderProtoViewRef of type
   * ProtoViewDto.HOST_VIEW_TYPE
   * @param {any} hostElementSelector css selector for the host element (will be queried against the
   * main document)
   * @return {RenderViewRef} the created view
   */
  RenderViewWithFragments createRootHostView(
      RenderProtoViewRef hostProtoViewRef, num fragmentCount,
      String hostElementSelector) {
    return this._createViewHelper(
        hostProtoViewRef, fragmentCount, hostElementSelector);
  }
  /**
   * Creates a regular view out of the given ProtoView
   * Note that the fragmentCount needs to be passed in so that we can create a result
   * synchronously even when dealing with webworkers!
   */
  RenderViewWithFragments createView(
      RenderProtoViewRef protoViewRef, num fragmentCount) {
    return this._createViewHelper(protoViewRef, fragmentCount);
  }
  RenderViewWithFragments _createViewHelper(
      RenderProtoViewRef protoViewRef, num fragmentCount,
      [String hostElementSelector]) {
    var renderViewWithFragments = this._renderViewStore.allocate(fragmentCount);
    var startIndex =
        (((renderViewWithFragments.viewRef) as WorkerRenderViewRef)).refNumber;
    List<FnArg> fnArgs = [
      new FnArg(protoViewRef, RenderProtoViewRef),
      new FnArg(fragmentCount, null)
    ];
    var method = "createView";
    if (isPresent(hostElementSelector) && hostElementSelector != null) {
      fnArgs.add(new FnArg(hostElementSelector, null));
      method = "createRootHostView";
    }
    fnArgs.add(new FnArg(startIndex, null));
    var args = new UiArguments("renderer", method, fnArgs);
    this._messageBroker.runOnUiThread(args, null);
    return renderViewWithFragments;
  }
  /**
   * Destroys the given view after it has been dehydrated and detached
   */
  destroyView(RenderViewRef viewRef) {
    var fnArgs = [new FnArg(viewRef, RenderViewRef)];
    var args = new UiArguments("renderer", "destroyView", fnArgs);
    this._messageBroker.runOnUiThread(args, null);
  }
  /**
   * Attaches a fragment after another fragment.
   */
  attachFragmentAfterFragment(
      RenderFragmentRef previousFragmentRef, RenderFragmentRef fragmentRef) {
    var fnArgs = [
      new FnArg(previousFragmentRef, RenderFragmentRef),
      new FnArg(fragmentRef, RenderFragmentRef)
    ];
    var args =
        new UiArguments("renderer", "attachFragmentAfterFragment", fnArgs);
    this._messageBroker.runOnUiThread(args, null);
  }
  /**
   * Attaches a fragment after an element.
   */
  attachFragmentAfterElement(
      RenderElementRef elementRef, RenderFragmentRef fragmentRef) {
    var fnArgs = [
      new FnArg(elementRef, WorkerElementRef),
      new FnArg(fragmentRef, RenderFragmentRef)
    ];
    var args =
        new UiArguments("renderer", "attachFragmentAfterElement", fnArgs);
    this._messageBroker.runOnUiThread(args, null);
  }
  /**
   * Detaches a fragment.
   */
  detachFragment(RenderFragmentRef fragmentRef) {
    var fnArgs = [new FnArg(fragmentRef, RenderFragmentRef)];
    var args = new UiArguments("renderer", "detachFragment", fnArgs);
    this._messageBroker.runOnUiThread(args, null);
  }
  /**
   * Hydrates a view after it has been attached. Hydration/dehydration is used for reusing views
   * inside of the view pool.
   */
  hydrateView(RenderViewRef viewRef) {
    var fnArgs = [new FnArg(viewRef, RenderViewRef)];
    var args = new UiArguments("renderer", "hydrateView", fnArgs);
    this._messageBroker.runOnUiThread(args, null);
  }
  /**
   * Dehydrates a view after it has been attached. Hydration/dehydration is used for reusing views
   * inside of the view pool.
   */
  dehydrateView(RenderViewRef viewRef) {
    var fnArgs = [new FnArg(viewRef, RenderViewRef)];
    var args = new UiArguments("renderer", "dehydrateView", fnArgs);
    this._messageBroker.runOnUiThread(args, null);
  }
  /**
   * Returns the native element at the given location.
   * Attention: In a WebWorker scenario, this should always return null!
   */
  dynamic getNativeElementSync(RenderElementRef location) {
    return null;
  }
  /**
   * Sets a property on an element.
   */
  setElementProperty(
      RenderElementRef location, String propertyName, dynamic propertyValue) {
    var fnArgs = [
      new FnArg(location, WorkerElementRef),
      new FnArg(propertyName, null),
      new FnArg(propertyValue, null)
    ];
    var args = new UiArguments("renderer", "setElementProperty", fnArgs);
    this._messageBroker.runOnUiThread(args, null);
  }
  /**
   * Sets an attribute on an element.
   */
  setElementAttribute(
      RenderElementRef location, String attributeName, String attributeValue) {
    var fnArgs = [
      new FnArg(location, WorkerElementRef),
      new FnArg(attributeName, null),
      new FnArg(attributeValue, null)
    ];
    var args = new UiArguments("renderer", "setElementAttribute", fnArgs);
    this._messageBroker.runOnUiThread(args, null);
  }
  /**
   * Sets a class on an element.
   */
  setElementClass(RenderElementRef location, String className, bool isAdd) {
    var fnArgs = [
      new FnArg(location, WorkerElementRef),
      new FnArg(className, null),
      new FnArg(isAdd, null)
    ];
    var args = new UiArguments("renderer", "setElementClass", fnArgs);
    this._messageBroker.runOnUiThread(args, null);
  }
  /**
   * Sets a style on an element.
   */
  setElementStyle(
      RenderElementRef location, String styleName, String styleValue) {
    var fnArgs = [
      new FnArg(location, WorkerElementRef),
      new FnArg(styleName, null),
      new FnArg(styleValue, null)
    ];
    var args = new UiArguments("renderer", "setElementStyle", fnArgs);
    this._messageBroker.runOnUiThread(args, null);
  }
  /**
   * Calls a method on an element.
   * Note: For now we're assuming that everything in the args list are primitive
   */
  invokeElementMethod(
      RenderElementRef location, String methodName, List<dynamic> args) {
    var fnArgs = [
      new FnArg(location, WorkerElementRef),
      new FnArg(methodName, null),
      new FnArg(args, null)
    ];
    var uiArgs = new UiArguments("renderer", "invokeElementMethod", fnArgs);
    this._messageBroker.runOnUiThread(uiArgs, null);
  }
  /**
   * Sets the value of a text node.
   */
  setText(RenderViewRef viewRef, num textNodeIndex, String text) {
    var fnArgs = [
      new FnArg(viewRef, RenderViewRef),
      new FnArg(textNodeIndex, null),
      new FnArg(text, null)
    ];
    var args = new UiArguments("renderer", "setText", fnArgs);
    this._messageBroker.runOnUiThread(args, null);
  }
  /**
   * Sets the dispatcher for all events of the given view
   */
  setEventDispatcher(RenderViewRef viewRef, RenderEventDispatcher dispatcher) {
    var fnArgs = [new FnArg(viewRef, RenderViewRef)];
    var args = new UiArguments("renderer", "setEventDispatcher", fnArgs);
    this._messageBroker.registerEventDispatcher(viewRef, dispatcher);
    this._messageBroker.runOnUiThread(args, null);
  }
}
