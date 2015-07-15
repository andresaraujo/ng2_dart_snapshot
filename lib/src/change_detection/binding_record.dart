library angular2.src.change_detection.binding_record;

import "package:angular2/src/facade/lang.dart" show isPresent, isBlank;
import "package:angular2/src/reflection/types.dart" show SetterFn;
import "parser/ast.dart" show AST;
import "directive_record.dart" show DirectiveIndex, DirectiveRecord;

const DIRECTIVE = "directive";
const DIRECTIVE_LIFECYCLE = "directiveLifecycle";
const ELEMENT_PROPERTY = "elementProperty";
const ELEMENT_ATTRIBUTE = "elementAttribute";
const ELEMENT_CLASS = "elementClass";
const ELEMENT_STYLE = "elementStyle";
const TEXT_NODE = "textNode";
class BindingRecord {
  String mode;
  dynamic implicitReceiver;
  AST ast;
  num elementIndex;
  String propertyName;
  String propertyUnit;
  SetterFn setter;
  String lifecycleEvent;
  DirectiveRecord directiveRecord;
  BindingRecord(this.mode, this.implicitReceiver, this.ast, this.elementIndex,
      this.propertyName, this.propertyUnit, this.setter, this.lifecycleEvent,
      this.directiveRecord) {}
  bool callOnChange() {
    return isPresent(this.directiveRecord) && this.directiveRecord.callOnChange;
  }
  bool isOnPushChangeDetection() {
    return isPresent(this.directiveRecord) &&
        this.directiveRecord.isOnPushChangeDetection();
  }
  bool isDirective() {
    return identical(this.mode, DIRECTIVE);
  }
  bool isDirectiveLifecycle() {
    return identical(this.mode, DIRECTIVE_LIFECYCLE);
  }
  bool isElementProperty() {
    return identical(this.mode, ELEMENT_PROPERTY);
  }
  bool isElementAttribute() {
    return identical(this.mode, ELEMENT_ATTRIBUTE);
  }
  bool isElementClass() {
    return identical(this.mode, ELEMENT_CLASS);
  }
  bool isElementStyle() {
    return identical(this.mode, ELEMENT_STYLE);
  }
  bool isTextNode() {
    return identical(this.mode, TEXT_NODE);
  }
  static BindingRecord createForDirective(AST ast, String propertyName,
      SetterFn setter, DirectiveRecord directiveRecord) {
    return new BindingRecord(DIRECTIVE, 0, ast, 0, propertyName, null, setter,
        null, directiveRecord);
  }
  static BindingRecord createDirectiveOnCheck(DirectiveRecord directiveRecord) {
    return new BindingRecord(DIRECTIVE_LIFECYCLE, 0, null, 0, null, null, null,
        "onCheck", directiveRecord);
  }
  static BindingRecord createDirectiveOnInit(DirectiveRecord directiveRecord) {
    return new BindingRecord(DIRECTIVE_LIFECYCLE, 0, null, 0, null, null, null,
        "onInit", directiveRecord);
  }
  static BindingRecord createDirectiveOnChange(
      DirectiveRecord directiveRecord) {
    return new BindingRecord(DIRECTIVE_LIFECYCLE, 0, null, 0, null, null, null,
        "onChange", directiveRecord);
  }
  static BindingRecord createForElementProperty(
      AST ast, num elementIndex, String propertyName) {
    return new BindingRecord(ELEMENT_PROPERTY, 0, ast, elementIndex,
        propertyName, null, null, null, null);
  }
  static BindingRecord createForElementAttribute(
      AST ast, num elementIndex, String attributeName) {
    return new BindingRecord(ELEMENT_ATTRIBUTE, 0, ast, elementIndex,
        attributeName, null, null, null, null);
  }
  static BindingRecord createForElementClass(
      AST ast, num elementIndex, String className) {
    return new BindingRecord(
        ELEMENT_CLASS, 0, ast, elementIndex, className, null, null, null, null);
  }
  static BindingRecord createForElementStyle(
      AST ast, num elementIndex, String styleName, String unit) {
    return new BindingRecord(
        ELEMENT_STYLE, 0, ast, elementIndex, styleName, unit, null, null, null);
  }
  static BindingRecord createForHostProperty(
      DirectiveIndex directiveIndex, AST ast, String propertyName) {
    return new BindingRecord(ELEMENT_PROPERTY, directiveIndex, ast,
        directiveIndex.elementIndex, propertyName, null, null, null, null);
  }
  static BindingRecord createForHostAttribute(
      DirectiveIndex directiveIndex, AST ast, String attributeName) {
    return new BindingRecord(ELEMENT_ATTRIBUTE, directiveIndex, ast,
        directiveIndex.elementIndex, attributeName, null, null, null, null);
  }
  static BindingRecord createForHostClass(
      DirectiveIndex directiveIndex, AST ast, String className) {
    return new BindingRecord(ELEMENT_CLASS, directiveIndex, ast,
        directiveIndex.elementIndex, className, null, null, null, null);
  }
  static BindingRecord createForHostStyle(
      DirectiveIndex directiveIndex, AST ast, String styleName, String unit) {
    return new BindingRecord(ELEMENT_STYLE, directiveIndex, ast,
        directiveIndex.elementIndex, styleName, unit, null, null, null);
  }
  static BindingRecord createForTextNode(AST ast, num elementIndex) {
    return new BindingRecord(
        TEXT_NODE, 0, ast, elementIndex, null, null, null, null, null);
  }
}
