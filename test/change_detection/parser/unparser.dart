library angular2.test.change_detection.parser.unparser;

import "package:angular2/src/change_detection/parser/ast.dart"
    show
        AST,
        AstVisitor,
        AccessMember,
        Assignment,
        Binary,
        Chain,
        Conditional,
        EmptyExpr,
        If,
        BindingPipe,
        FunctionCall,
        ImplicitReceiver,
        Interpolation,
        KeyedAccess,
        LiteralArray,
        LiteralMap,
        LiteralPrimitive,
        MethodCall,
        PrefixNot,
        SafeAccessMember,
        SafeMethodCall;
import "package:angular2/src/facade/lang.dart"
    show StringWrapper, isPresent, isString;

class Unparser implements AstVisitor {
  static var _quoteRegExp = new RegExp(r'"');
  String _expression;
  unparse(AST ast) {
    this._expression = "";
    this._visit(ast);
    return this._expression;
  }
  visitAccessMember(AccessMember ast) {
    this._visit(ast.receiver);
    this._expression += ast.receiver is ImplicitReceiver
        ? '''${ ast . name}'''
        : '''.${ ast . name}''';
  }
  visitAssignment(Assignment ast) {
    this._visit(ast.target);
    this._expression += " = ";
    this._visit(ast.value);
  }
  visitBinary(Binary ast) {
    this._visit(ast.left);
    this._expression += ''' ${ ast . operation} ''';
    this._visit(ast.right);
  }
  visitChain(Chain ast) {
    var len = ast.expressions.length;
    for (var i = 0; i < len; i++) {
      this._visit(ast.expressions[i]);
      this._expression += i == len - 1 ? ";" : "; ";
    }
  }
  visitConditional(Conditional ast) {
    this._visit(ast.condition);
    this._expression += " ? ";
    this._visit(ast.trueExp);
    this._expression += " : ";
    this._visit(ast.falseExp);
  }
  visitIf(If ast) {
    this._expression += "if (";
    this._visit(ast.condition);
    this._expression += ") ";
    this._visitExpOrBlock(ast.trueExp);
    if (isPresent(ast.falseExp)) {
      this._expression += " else ";
      this._visitExpOrBlock(ast.falseExp);
    }
  }
  visitPipe(BindingPipe ast) {
    this._expression += "(";
    this._visit(ast.exp);
    this._expression += ''' | ${ ast . name}''';
    ast.args.forEach((arg) {
      this._expression += ":";
      this._visit(arg);
    });
    this._expression += ")";
  }
  visitFunctionCall(FunctionCall ast) {
    this._visit(ast.target);
    this._expression += "(";
    var isFirst = true;
    ast.args.forEach((arg) {
      if (!isFirst) this._expression += ", ";
      isFirst = false;
      this._visit(arg);
    });
    this._expression += ")";
  }
  visitImplicitReceiver(ImplicitReceiver ast) {}
  visitInterpolation(Interpolation ast) {
    for (var i = 0; i < ast.strings.length; i++) {
      this._expression += ast.strings[i];
      if (i < ast.expressions.length) {
        this._expression += "{{ ";
        this._visit(ast.expressions[i]);
        this._expression += " }}";
      }
    }
  }
  visitKeyedAccess(KeyedAccess ast) {
    this._visit(ast.obj);
    this._expression += "[";
    this._visit(ast.key);
    this._expression += "]";
  }
  visitLiteralArray(LiteralArray ast) {
    this._expression += "[";
    var isFirst = true;
    ast.expressions.forEach((expression) {
      if (!isFirst) this._expression += ", ";
      isFirst = false;
      this._visit(expression);
    });
    this._expression += "]";
  }
  visitLiteralMap(LiteralMap ast) {
    this._expression += "{";
    var isFirst = true;
    for (var i = 0; i < ast.keys.length; i++) {
      if (!isFirst) this._expression += ", ";
      isFirst = false;
      this._expression += '''${ ast . keys [ i ]}: ''';
      this._visit(ast.values[i]);
    }
    this._expression += "}";
  }
  visitLiteralPrimitive(LiteralPrimitive ast) {
    if (isString(ast.value)) {
      this._expression +=
          '''"${ StringWrapper . replaceAll ( ast . value , Unparser . _quoteRegExp , "\"" )}"''';
    } else {
      this._expression += '''${ ast . value}''';
    }
  }
  visitMethodCall(MethodCall ast) {
    this._visit(ast.receiver);
    this._expression += ast.receiver is ImplicitReceiver
        ? '''${ ast . name}('''
        : '''.${ ast . name}(''';
    var isFirst = true;
    ast.args.forEach((arg) {
      if (!isFirst) this._expression += ", ";
      isFirst = false;
      this._visit(arg);
    });
    this._expression += ")";
  }
  visitPrefixNot(PrefixNot ast) {
    this._expression += "!";
    this._visit(ast.expression);
  }
  visitSafeAccessMember(SafeAccessMember ast) {
    this._visit(ast.receiver);
    this._expression += '''?.${ ast . name}''';
  }
  visitSafeMethodCall(SafeMethodCall ast) {
    this._visit(ast.receiver);
    this._expression += '''?.${ ast . name}(''';
    var isFirst = true;
    ast.args.forEach((arg) {
      if (!isFirst) this._expression += ", ";
      isFirst = false;
      this._visit(arg);
    });
    this._expression += ")";
  }
  _visit(AST ast) {
    ast.visit(this);
  }
  _visitExpOrBlock(AST ast) {
    var isBlock = ast is Chain || ast is EmptyExpr;
    if (isBlock) this._expression += "{ ";
    this._visit(ast);
    if (isBlock) this._expression += " }";
  }
}
