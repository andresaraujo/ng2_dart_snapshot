library angular2.src.change_detection.parser.ast;

import "package:angular2/src/facade/lang.dart"
    show isBlank, isPresent, FunctionWrapper, BaseException;
import "package:angular2/src/facade/collection.dart"
    show List, Map, ListWrapper, StringMapWrapper;
import "locals.dart" show Locals;

class AST {
  dynamic eval(dynamic context, Locals locals) {
    throw new BaseException("Not supported");
  }
  bool get isAssignable {
    return false;
  }
  assign(dynamic context, Locals locals, dynamic value) {
    throw new BaseException("Not supported");
  }
  dynamic visit(AstVisitor visitor) {
    return null;
  }
  String toString() {
    return "AST";
  }
}
class EmptyExpr extends AST {
  dynamic eval(dynamic context, Locals locals) {
    return null;
  }
  visit(AstVisitor visitor) {}
}
class ImplicitReceiver extends AST {
  dynamic eval(dynamic context, Locals locals) {
    return context;
  }
  dynamic visit(AstVisitor visitor) {
    return visitor.visitImplicitReceiver(this);
  }
}
/**
 * Multiple expressions separated by a semicolon.
 */
class Chain extends AST {
  List<dynamic> expressions;
  Chain(this.expressions) : super() {
    /* super call moved to initializer */;
  }
  dynamic eval(dynamic context, Locals locals) {
    var result;
    for (var i = 0; i < this.expressions.length; i++) {
      var last = this.expressions[i].eval(context, locals);
      if (isPresent(last)) result = last;
    }
    return result;
  }
  dynamic visit(AstVisitor visitor) {
    return visitor.visitChain(this);
  }
}
class Conditional extends AST {
  AST condition;
  AST trueExp;
  AST falseExp;
  Conditional(this.condition, this.trueExp, this.falseExp) : super() {
    /* super call moved to initializer */;
  }
  dynamic eval(dynamic context, Locals locals) {
    if (this.condition.eval(context, locals)) {
      return this.trueExp.eval(context, locals);
    } else {
      return this.falseExp.eval(context, locals);
    }
  }
  dynamic visit(AstVisitor visitor) {
    return visitor.visitConditional(this);
  }
}
class If extends AST {
  AST condition;
  AST trueExp;
  AST falseExp;
  If(this.condition, this.trueExp, [this.falseExp]) : super() {
    /* super call moved to initializer */;
  }
  eval(dynamic context, Locals locals) {
    if (this.condition.eval(context, locals)) {
      this.trueExp.eval(context, locals);
    } else if (isPresent(this.falseExp)) {
      this.falseExp.eval(context, locals);
    }
  }
  dynamic visit(AstVisitor visitor) {
    return visitor.visitIf(this);
  }
}
class AccessMember extends AST {
  AST receiver;
  String name;
  Function getter;
  Function setter;
  AccessMember(this.receiver, this.name, this.getter, this.setter) : super() {
    /* super call moved to initializer */;
  }
  dynamic eval(dynamic context, Locals locals) {
    if (this.receiver is ImplicitReceiver &&
        isPresent(locals) &&
        locals.contains(this.name)) {
      return locals.get(this.name);
    } else {
      var evaluatedReceiver = this.receiver.eval(context, locals);
      return this.getter(evaluatedReceiver);
    }
  }
  bool get isAssignable {
    return true;
  }
  dynamic assign(dynamic context, Locals locals, dynamic value) {
    var evaluatedContext = this.receiver.eval(context, locals);
    if (this.receiver is ImplicitReceiver &&
        isPresent(locals) &&
        locals.contains(this.name)) {
      throw new BaseException(
          '''Cannot reassign a variable binding ${ this . name}''');
    } else {
      return this.setter(evaluatedContext, value);
    }
  }
  dynamic visit(AstVisitor visitor) {
    return visitor.visitAccessMember(this);
  }
}
class SafeAccessMember extends AST {
  AST receiver;
  String name;
  Function getter;
  Function setter;
  SafeAccessMember(this.receiver, this.name, this.getter, this.setter)
      : super() {
    /* super call moved to initializer */;
  }
  dynamic eval(dynamic context, Locals locals) {
    var evaluatedReceiver = this.receiver.eval(context, locals);
    return isBlank(evaluatedReceiver) ? null : this.getter(evaluatedReceiver);
  }
  dynamic visit(AstVisitor visitor) {
    return visitor.visitSafeAccessMember(this);
  }
}
class KeyedAccess extends AST {
  AST obj;
  AST key;
  KeyedAccess(this.obj, this.key) : super() {
    /* super call moved to initializer */;
  }
  dynamic eval(dynamic context, Locals locals) {
    dynamic obj = this.obj.eval(context, locals);
    dynamic key = this.key.eval(context, locals);
    return obj[key];
  }
  bool get isAssignable {
    return true;
  }
  dynamic assign(dynamic context, Locals locals, dynamic value) {
    dynamic obj = this.obj.eval(context, locals);
    dynamic key = this.key.eval(context, locals);
    obj[key] = value;
    return value;
  }
  dynamic visit(AstVisitor visitor) {
    return visitor.visitKeyedAccess(this);
  }
}
class BindingPipe extends AST {
  AST exp;
  String name;
  List<dynamic> args;
  BindingPipe(this.exp, this.name, this.args) : super() {
    /* super call moved to initializer */;
  }
  dynamic visit(AstVisitor visitor) {
    return visitor.visitPipe(this);
  }
}
class LiteralPrimitive extends AST {
  var value;
  LiteralPrimitive(this.value) : super() {
    /* super call moved to initializer */;
  }
  dynamic eval(dynamic context, Locals locals) {
    return this.value;
  }
  dynamic visit(AstVisitor visitor) {
    return visitor.visitLiteralPrimitive(this);
  }
}
class LiteralArray extends AST {
  List<dynamic> expressions;
  LiteralArray(this.expressions) : super() {
    /* super call moved to initializer */;
  }
  dynamic eval(dynamic context, Locals locals) {
    return ListWrapper.map(this.expressions, (e) => e.eval(context, locals));
  }
  dynamic visit(AstVisitor visitor) {
    return visitor.visitLiteralArray(this);
  }
}
class LiteralMap extends AST {
  List<dynamic> keys;
  List<dynamic> values;
  LiteralMap(this.keys, this.values) : super() {
    /* super call moved to initializer */;
  }
  dynamic eval(dynamic context, Locals locals) {
    var res = StringMapWrapper.create();
    for (var i = 0; i < this.keys.length; ++i) {
      StringMapWrapper.set(
          res, this.keys[i], this.values[i].eval(context, locals));
    }
    return res;
  }
  dynamic visit(AstVisitor visitor) {
    return visitor.visitLiteralMap(this);
  }
}
class Interpolation extends AST {
  List<dynamic> strings;
  List<dynamic> expressions;
  Interpolation(this.strings, this.expressions) : super() {
    /* super call moved to initializer */;
  }
  dynamic eval(dynamic context, Locals locals) {
    throw new BaseException("evaluating an Interpolation is not supported");
  }
  visit(AstVisitor visitor) {
    visitor.visitInterpolation(this);
  }
}
class Binary extends AST {
  String operation;
  AST left;
  AST right;
  Binary(this.operation, this.left, this.right) : super() {
    /* super call moved to initializer */;
  }
  dynamic eval(dynamic context, Locals locals) {
    dynamic left = this.left.eval(context, locals);
    switch (this.operation) {
      case "&&":
        return left && this.right.eval(context, locals);
      case "||":
        return left || this.right.eval(context, locals);
    }
    dynamic right = this.right.eval(context, locals);
    switch (this.operation) {
      case "+":
        return left + right;
      case "-":
        return left - right;
      case "*":
        return left * right;
      case "/":
        return left / right;
      case "%":
        return left % right;
      case "==":
        return left == right;
      case "!=":
        return left != right;
      case "===":
        return identical(left, right);
      case "!==":
        return !identical(left, right);
      case "<":
        return left < right;
      case ">":
        return left > right;
      case "<=":
        return left <= right;
      case ">=":
        return left >= right;
      case "^":
        return left ^ right;
      case "&":
        return left & right;
    }
    throw "Internal error [\$operation] not handled";
  }
  dynamic visit(AstVisitor visitor) {
    return visitor.visitBinary(this);
  }
}
class PrefixNot extends AST {
  AST expression;
  PrefixNot(this.expression) : super() {
    /* super call moved to initializer */;
  }
  dynamic eval(dynamic context, Locals locals) {
    return !this.expression.eval(context, locals);
  }
  dynamic visit(AstVisitor visitor) {
    return visitor.visitPrefixNot(this);
  }
}
class Assignment extends AST {
  AST target;
  dynamic value;
  Assignment(this.target, this.value) : super() {
    /* super call moved to initializer */;
  }
  dynamic eval(dynamic context, Locals locals) {
    return this.target.assign(
        context, locals, this.value.eval(context, locals));
  }
  dynamic visit(AstVisitor visitor) {
    return visitor.visitAssignment(this);
  }
}
class MethodCall extends AST {
  AST receiver;
  String name;
  Function fn;
  List<dynamic> args;
  MethodCall(this.receiver, this.name, this.fn, this.args) : super() {
    /* super call moved to initializer */;
  }
  dynamic eval(dynamic context, Locals locals) {
    var evaluatedArgs = evalList(context, locals, this.args);
    if (this.receiver is ImplicitReceiver &&
        isPresent(locals) &&
        locals.contains(this.name)) {
      var fn = locals.get(this.name);
      return FunctionWrapper.apply(fn, evaluatedArgs);
    } else {
      var evaluatedReceiver = this.receiver.eval(context, locals);
      return this.fn(evaluatedReceiver, evaluatedArgs);
    }
  }
  dynamic visit(AstVisitor visitor) {
    return visitor.visitMethodCall(this);
  }
}
class SafeMethodCall extends AST {
  AST receiver;
  String name;
  Function fn;
  List<dynamic> args;
  SafeMethodCall(this.receiver, this.name, this.fn, this.args) : super() {
    /* super call moved to initializer */;
  }
  dynamic eval(dynamic context, Locals locals) {
    var evaluatedReceiver = this.receiver.eval(context, locals);
    if (isBlank(evaluatedReceiver)) return null;
    var evaluatedArgs = evalList(context, locals, this.args);
    return this.fn(evaluatedReceiver, evaluatedArgs);
  }
  dynamic visit(AstVisitor visitor) {
    return visitor.visitSafeMethodCall(this);
  }
}
class FunctionCall extends AST {
  AST target;
  List<dynamic> args;
  FunctionCall(this.target, this.args) : super() {
    /* super call moved to initializer */;
  }
  dynamic eval(dynamic context, Locals locals) {
    dynamic obj = this.target.eval(context, locals);
    if (!(obj is Function)) {
      throw new BaseException('''${ obj} is not a function''');
    }
    return FunctionWrapper.apply(obj, evalList(context, locals, this.args));
  }
  dynamic visit(AstVisitor visitor) {
    return visitor.visitFunctionCall(this);
  }
}
class ASTWithSource extends AST {
  AST ast;
  String source;
  String location;
  ASTWithSource(this.ast, this.source, this.location) : super() {
    /* super call moved to initializer */;
  }
  dynamic eval(dynamic context, Locals locals) {
    return this.ast.eval(context, locals);
  }
  bool get isAssignable {
    return this.ast.isAssignable;
  }
  dynamic assign(dynamic context, Locals locals, dynamic value) {
    return this.ast.assign(context, locals, value);
  }
  dynamic visit(AstVisitor visitor) {
    return this.ast.visit(visitor);
  }
  String toString() {
    return '''${ this . source} in ${ this . location}''';
  }
}
class TemplateBinding {
  String key;
  bool keyIsVar;
  String name;
  ASTWithSource expression;
  TemplateBinding(this.key, this.keyIsVar, this.name, this.expression) {}
}
abstract class AstVisitor {
  dynamic visitAccessMember(AccessMember ast);
  dynamic visitAssignment(Assignment ast);
  dynamic visitBinary(Binary ast);
  dynamic visitChain(Chain ast);
  dynamic visitConditional(Conditional ast);
  dynamic visitIf(If ast);
  dynamic visitPipe(BindingPipe ast);
  dynamic visitFunctionCall(FunctionCall ast);
  dynamic visitImplicitReceiver(ImplicitReceiver ast);
  dynamic visitInterpolation(Interpolation ast);
  dynamic visitKeyedAccess(KeyedAccess ast);
  dynamic visitLiteralArray(LiteralArray ast);
  dynamic visitLiteralMap(LiteralMap ast);
  dynamic visitLiteralPrimitive(LiteralPrimitive ast);
  dynamic visitMethodCall(MethodCall ast);
  dynamic visitPrefixNot(PrefixNot ast);
  dynamic visitSafeAccessMember(SafeAccessMember ast);
  dynamic visitSafeMethodCall(SafeMethodCall ast);
}
class AstTransformer implements AstVisitor {
  ImplicitReceiver visitImplicitReceiver(ImplicitReceiver ast) {
    return ast;
  }
  Interpolation visitInterpolation(Interpolation ast) {
    return new Interpolation(ast.strings, this.visitAll(ast.expressions));
  }
  LiteralPrimitive visitLiteralPrimitive(LiteralPrimitive ast) {
    return new LiteralPrimitive(ast.value);
  }
  AccessMember visitAccessMember(AccessMember ast) {
    return new AccessMember(
        ast.receiver.visit(this), ast.name, ast.getter, ast.setter);
  }
  SafeAccessMember visitSafeAccessMember(SafeAccessMember ast) {
    return new SafeAccessMember(
        ast.receiver.visit(this), ast.name, ast.getter, ast.setter);
  }
  MethodCall visitMethodCall(MethodCall ast) {
    return new MethodCall(
        ast.receiver.visit(this), ast.name, ast.fn, this.visitAll(ast.args));
  }
  SafeMethodCall visitSafeMethodCall(SafeMethodCall ast) {
    return new SafeMethodCall(
        ast.receiver.visit(this), ast.name, ast.fn, this.visitAll(ast.args));
  }
  FunctionCall visitFunctionCall(FunctionCall ast) {
    return new FunctionCall(ast.target.visit(this), this.visitAll(ast.args));
  }
  LiteralArray visitLiteralArray(LiteralArray ast) {
    return new LiteralArray(this.visitAll(ast.expressions));
  }
  LiteralMap visitLiteralMap(LiteralMap ast) {
    return new LiteralMap(ast.keys, this.visitAll(ast.values));
  }
  Binary visitBinary(Binary ast) {
    return new Binary(
        ast.operation, ast.left.visit(this), ast.right.visit(this));
  }
  PrefixNot visitPrefixNot(PrefixNot ast) {
    return new PrefixNot(ast.expression.visit(this));
  }
  Conditional visitConditional(Conditional ast) {
    return new Conditional(ast.condition.visit(this), ast.trueExp.visit(this),
        ast.falseExp.visit(this));
  }
  BindingPipe visitPipe(BindingPipe ast) {
    return new BindingPipe(
        ast.exp.visit(this), ast.name, this.visitAll(ast.args));
  }
  KeyedAccess visitKeyedAccess(KeyedAccess ast) {
    return new KeyedAccess(ast.obj.visit(this), ast.key.visit(this));
  }
  List<dynamic> visitAll(List<dynamic> asts) {
    var res = ListWrapper.createFixedSize(asts.length);
    for (var i = 0; i < asts.length; ++i) {
      res[i] = asts[i].visit(this);
    }
    return res;
  }
  Chain visitChain(Chain ast) {
    return new Chain(this.visitAll(ast.expressions));
  }
  Assignment visitAssignment(Assignment ast) {
    return new Assignment(ast.target.visit(this), ast.value.visit(this));
  }
  If visitIf(If ast) {
    var falseExp = isPresent(ast.falseExp) ? ast.falseExp.visit(this) : null;
    return new If(ast.condition.visit(this), ast.trueExp.visit(this), falseExp);
  }
}
var _evalListCache = [
  [],
  [0],
  [0, 0],
  [0, 0, 0],
  [0, 0, 0, 0],
  [0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
];
List<dynamic> evalList(context, Locals locals, List<dynamic> exps) {
  var length = exps.length;
  if (length > 10) {
    throw new BaseException("Cannot have more than 10 argument");
  }
  var result = _evalListCache[length];
  for (var i = 0; i < length; i++) {
    result[i] = exps[i].eval(context, locals);
  }
  return result;
}
