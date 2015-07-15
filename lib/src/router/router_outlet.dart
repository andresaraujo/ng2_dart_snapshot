library angular2.src.router.router_outlet;

import "package:angular2/src/facade/async.dart" show Future, PromiseWrapper;
import "package:angular2/src/facade/collection.dart" show StringMapWrapper;
import "package:angular2/src/facade/lang.dart" show isBlank, isPresent;
import "package:angular2/src/core/annotations/decorators.dart"
    show Directive, Attribute;
import "package:angular2/core.dart"
    show DynamicComponentLoader, ComponentRef, ElementRef;
import "package:angular2/di.dart"
    show Injector, bind, Dependency, undefinedValue;
import "router.dart" as routerMod;
import "instruction.dart" show Instruction, RouteParams;
import "lifecycle_annotations.dart" as hookMod;
import "route_lifecycle_reflector.dart" show hasLifecycleHook;

/**
 * A router outlet is a placeholder that Angular dynamically fills based on the application's route.
 *
 * ## Use
 *
 * ```
 * <router-outlet></router-outlet>
 * ```
 */
@Directive(selector: "router-outlet")
class RouterOutlet {
  ElementRef _elementRef;
  DynamicComponentLoader _loader;
  routerMod.Router _parentRouter;
  routerMod.Router childRouter = null;
  ComponentRef _componentRef = null;
  Instruction _currentInstruction = null;
  RouterOutlet(this._elementRef, this._loader, this._parentRouter,
      @Attribute("name") String nameAttr) {
    // TODO: reintroduce with new // sibling routes

    // if (isBlank(nameAttr)) {

    //  nameAttr = 'default';

    //}
    this._parentRouter.registerOutlet(this);
  }
  /**
   * Given an instruction, update the contents of this outlet.
   */
  Future<dynamic> commit(Instruction instruction) {
    var next;
    if (instruction.reuse) {
      next = this._reuse(instruction);
    } else {
      next =
          this.deactivate(instruction).then((_) => this._activate(instruction));
    }
    return next.then((_) => this._commitChild(instruction));
  }
  Future<dynamic> _commitChild(Instruction instruction) {
    if (isPresent(this.childRouter)) {
      return this.childRouter.commit(instruction.child);
    } else {
      return PromiseWrapper.resolve(true);
    }
  }
  Future<dynamic> _activate(Instruction instruction) {
    var previousInstruction = this._currentInstruction;
    this._currentInstruction = instruction;
    this.childRouter = this._parentRouter.childRouter(instruction.component);
    var bindings = Injector.resolve([
      bind(RouteParams).toValue(new RouteParams(instruction.params())),
      bind(routerMod.Router).toValue(this.childRouter)
    ]);
    return this._loader
        .loadNextToLocation(instruction.component, this._elementRef, bindings)
        .then((componentRef) {
      this._componentRef = componentRef;
      if (hasLifecycleHook(hookMod.onActivate, instruction.component)) {
        return this._componentRef.instance.onActivate(
            instruction, previousInstruction);
      }
    });
  }
  /**
   * Called by Router during recognition phase
   */
  Future<bool> canDeactivate(Instruction nextInstruction) {
    if (isBlank(this._currentInstruction)) {
      return PromiseWrapper.resolve(true);
    }
    if (hasLifecycleHook(
        hookMod.canDeactivate, this._currentInstruction.component)) {
      return PromiseWrapper.resolve(this._componentRef.instance.canDeactivate(
          nextInstruction, this._currentInstruction));
    }
    return PromiseWrapper.resolve(true);
  }
  /**
   * Called by Router during recognition phase
   */
  Future<bool> canReuse(Instruction nextInstruction) {
    var result;
    if (isBlank(this._currentInstruction) ||
        this._currentInstruction.component != nextInstruction.component) {
      result = false;
    } else if (hasLifecycleHook(
        hookMod.canReuse, this._currentInstruction.component)) {
      result = this._componentRef.instance.canReuse(
          nextInstruction, this._currentInstruction);
    } else {
      result = nextInstruction == this._currentInstruction ||
          StringMapWrapper.equals(
              nextInstruction.params(), this._currentInstruction.params());
    }
    return PromiseWrapper.resolve(result);
  }
  Future<dynamic> _reuse(instruction) {
    var previousInstruction = this._currentInstruction;
    this._currentInstruction = instruction;
    return PromiseWrapper.resolve(hasLifecycleHook(
            hookMod.onReuse, this._currentInstruction.component)
        ? this._componentRef.instance.onReuse(instruction, previousInstruction)
        : true);
  }
  Future<dynamic> deactivate(Instruction nextInstruction) {
    return (isPresent(this.childRouter)
        ? this.childRouter.deactivate(
            isPresent(nextInstruction) ? nextInstruction.child : null)
        : PromiseWrapper.resolve(true)).then((_) {
      if (isPresent(this._componentRef) &&
          isPresent(this._currentInstruction) &&
          hasLifecycleHook(
              hookMod.onDeactivate, this._currentInstruction.component)) {
        return this._componentRef.instance.onDeactivate(
            nextInstruction, this._currentInstruction);
      }
    }).then((_) {
      if (isPresent(this._componentRef)) {
        this._componentRef.dispose();
        this._componentRef = null;
      }
    });
  }
}
