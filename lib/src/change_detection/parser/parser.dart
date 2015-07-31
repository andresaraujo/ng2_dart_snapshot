library angular2.src.change_detection.parser.parser;

import "package:angular2/src/di/decorators.dart" show Injectable;
import "package:angular2/src/facade/lang.dart"
    show isBlank, isPresent, BaseException, StringWrapper;
import "package:angular2/src/facade/collection.dart" show ListWrapper, List;
import "lexer.dart"
    show
        Lexer,
        EOF,
        Token,
        $PERIOD,
        $COLON,
        $SEMICOLON,
        $LBRACKET,
        $RBRACKET,
        $COMMA,
        $LBRACE,
        $RBRACE,
        $LPAREN,
        $RPAREN;
import "package:angular2/src/reflection/reflection.dart"
    show reflector, Reflector;
import "ast.dart"
    show
        AST,
        EmptyExpr,
        ImplicitReceiver,
        AccessMember,
        SafeAccessMember,
        LiteralPrimitive,
        Binary,
        PrefixNot,
        Conditional,
        If,
        BindingPipe,
        Assignment,
        Chain,
        KeyedAccess,
        LiteralArray,
        LiteralMap,
        Interpolation,
        MethodCall,
        SafeMethodCall,
        FunctionCall,
        TemplateBinding,
        ASTWithSource,
        AstVisitor;

var _implicitReceiver = new ImplicitReceiver();
// TODO(tbosch): Cannot make this const/final right now because of the transpiler...
var INTERPOLATION_REGEXP = new RegExp(r'\{\{(.*?)\}\}');
@Injectable()
class Parser {
  Lexer _lexer;
  Reflector _reflector;
  Parser(this._lexer, [Reflector providedReflector = null]) {
    this._reflector =
        isPresent(providedReflector) ? providedReflector : reflector;
  }
  ASTWithSource parseAction(String input, dynamic location) {
    var tokens = this._lexer.tokenize(input);
    var ast = new _ParseAST(input, location, tokens, this._reflector, true)
        .parseChain();
    return new ASTWithSource(ast, input, location);
  }
  ASTWithSource parseBinding(String input, dynamic location) {
    var tokens = this._lexer.tokenize(input);
    var ast = new _ParseAST(input, location, tokens, this._reflector, false)
        .parseChain();
    return new ASTWithSource(ast, input, location);
  }
  ASTWithSource parseSimpleBinding(String input, String location) {
    var tokens = this._lexer.tokenize(input);
    var ast = new _ParseAST(input, location, tokens, this._reflector, false)
        .parseSimpleBinding();
    return new ASTWithSource(ast, input, location);
  }
  List<TemplateBinding> parseTemplateBindings(String input, dynamic location) {
    var tokens = this._lexer.tokenize(input);
    return new _ParseAST(input, location, tokens, this._reflector, false)
        .parseTemplateBindings();
  }
  ASTWithSource parseInterpolation(String input, dynamic location) {
    var parts = StringWrapper.split(input, INTERPOLATION_REGEXP);
    if (parts.length <= 1) {
      return null;
    }
    var strings = [];
    var expressions = [];
    for (var i = 0; i < parts.length; i++) {
      var part = parts[i];
      if (identical(i % 2, 0)) {
        // fixed string
        strings.add(part);
      } else {
        var tokens = this._lexer.tokenize(part);
        var ast = new _ParseAST(input, location, tokens, this._reflector, false)
            .parseChain();
        expressions.add(ast);
      }
    }
    return new ASTWithSource(
        new Interpolation(strings, expressions), input, location);
  }
  ASTWithSource wrapLiteralPrimitive(String input, dynamic location) {
    return new ASTWithSource(new LiteralPrimitive(input), input, location);
  }
}
class _ParseAST {
  String input;
  dynamic location;
  List<dynamic> tokens;
  Reflector reflector;
  bool parseAction;
  int index = 0;
  _ParseAST(this.input, this.location, this.tokens, this.reflector,
      this.parseAction) {}
  Token peek(int offset) {
    var i = this.index + offset;
    return i < this.tokens.length ? this.tokens[i] : EOF;
  }
  Token get next {
    return this.peek(0);
  }
  int get inputIndex {
    return (this.index < this.tokens.length)
        ? this.next.index
        : this.input.length;
  }
  advance() {
    this.index++;
  }
  bool optionalCharacter(int code) {
    if (this.next.isCharacter(code)) {
      this.advance();
      return true;
    } else {
      return false;
    }
  }
  bool optionalKeywordVar() {
    if (this.peekKeywordVar()) {
      this.advance();
      return true;
    } else {
      return false;
    }
  }
  bool peekKeywordVar() {
    return this.next.isKeywordVar() || this.next.isOperator("#");
  }
  expectCharacter(int code) {
    if (this.optionalCharacter(code)) return;
    this.error(
        '''Missing expected ${ StringWrapper . fromCharCode ( code )}''');
  }
  bool optionalOperator(String op) {
    if (this.next.isOperator(op)) {
      this.advance();
      return true;
    } else {
      return false;
    }
  }
  expectOperator(String operator) {
    if (this.optionalOperator(operator)) return;
    this.error('''Missing expected operator ${ operator}''');
  }
  String expectIdentifierOrKeyword() {
    var n = this.next;
    if (!n.isIdentifier() && !n.isKeyword()) {
      this.error('''Unexpected token ${ n}, expected identifier or keyword''');
    }
    this.advance();
    return n.toString();
  }
  String expectIdentifierOrKeywordOrString() {
    var n = this.next;
    if (!n.isIdentifier() && !n.isKeyword() && !n.isString()) {
      this.error(
          '''Unexpected token ${ n}, expected identifier, keyword, or string''');
    }
    this.advance();
    return n.toString();
  }
  AST parseChain() {
    var exprs = [];
    while (this.index < this.tokens.length) {
      var expr = this.parsePipe();
      exprs.add(expr);
      if (this.optionalCharacter($SEMICOLON)) {
        if (!this.parseAction) {
          this.error("Binding expression cannot contain chained expression");
        }
        while (this.optionalCharacter($SEMICOLON)) {}
      } else if (this.index < this.tokens.length) {
        this.error('''Unexpected token \'${ this . next}\'''');
      }
    }
    if (exprs.length == 0) return new EmptyExpr();
    if (exprs.length == 1) return exprs[0];
    return new Chain(exprs);
  }
  AST parseSimpleBinding() {
    var ast = this.parseChain();
    if (!SimpleExpressionChecker.check(ast)) {
      this.error(
          '''Simple binding expression can only contain field access and constants\'''');
    }
    return ast;
  }
  AST parsePipe() {
    var result = this.parseExpression();
    if (this.optionalOperator("|")) {
      if (this.parseAction) {
        this.error("Cannot have a pipe in an action expression");
      }
      do {
        var name = this.expectIdentifierOrKeyword();
        var args = [];
        while (this.optionalCharacter($COLON)) {
          args.add(this.parsePipe());
        }
        result = new BindingPipe(result, name, args);
      } while (this.optionalOperator("|"));
    }
    return result;
  }
  AST parseExpression() {
    var start = this.inputIndex;
    var result = this.parseConditional();
    while (this.next.isOperator("=")) {
      if (!result.isAssignable) {
        var end = this.inputIndex;
        var expression = this.input.substring(start, end);
        this.error('''Expression ${ expression} is not assignable''');
      }
      if (!this.parseAction) {
        this.error("Binding expression cannot contain assignments");
      }
      this.expectOperator("=");
      result = new Assignment(result, this.parseConditional());
    }
    return result;
  }
  AST parseConditional() {
    var start = this.inputIndex;
    var result = this.parseLogicalOr();
    if (this.optionalOperator("?")) {
      var yes = this.parsePipe();
      if (!this.optionalCharacter($COLON)) {
        var end = this.inputIndex;
        var expression = this.input.substring(start, end);
        this.error(
            '''Conditional expression ${ expression} requires all 3 expressions''');
      }
      var no = this.parsePipe();
      return new Conditional(result, yes, no);
    } else {
      return result;
    }
  }
  AST parseLogicalOr() {
    // '||'
    var result = this.parseLogicalAnd();
    while (this.optionalOperator("||")) {
      result = new Binary("||", result, this.parseLogicalAnd());
    }
    return result;
  }
  AST parseLogicalAnd() {
    // '&&'
    var result = this.parseEquality();
    while (this.optionalOperator("&&")) {
      result = new Binary("&&", result, this.parseEquality());
    }
    return result;
  }
  AST parseEquality() {
    // '==','!=','===','!=='
    var result = this.parseRelational();
    while (true) {
      if (this.optionalOperator("==")) {
        result = new Binary("==", result, this.parseRelational());
      } else if (this.optionalOperator("===")) {
        result = new Binary("===", result, this.parseRelational());
      } else if (this.optionalOperator("!=")) {
        result = new Binary("!=", result, this.parseRelational());
      } else if (this.optionalOperator("!==")) {
        result = new Binary("!==", result, this.parseRelational());
      } else {
        return result;
      }
    }
  }
  AST parseRelational() {
    // '<', '>', '<=', '>='
    var result = this.parseAdditive();
    while (true) {
      if (this.optionalOperator("<")) {
        result = new Binary("<", result, this.parseAdditive());
      } else if (this.optionalOperator(">")) {
        result = new Binary(">", result, this.parseAdditive());
      } else if (this.optionalOperator("<=")) {
        result = new Binary("<=", result, this.parseAdditive());
      } else if (this.optionalOperator(">=")) {
        result = new Binary(">=", result, this.parseAdditive());
      } else {
        return result;
      }
    }
  }
  AST parseAdditive() {
    // '+', '-'
    var result = this.parseMultiplicative();
    while (true) {
      if (this.optionalOperator("+")) {
        result = new Binary("+", result, this.parseMultiplicative());
      } else if (this.optionalOperator("-")) {
        result = new Binary("-", result, this.parseMultiplicative());
      } else {
        return result;
      }
    }
  }
  AST parseMultiplicative() {
    // '*', '%', '/'
    var result = this.parsePrefix();
    while (true) {
      if (this.optionalOperator("*")) {
        result = new Binary("*", result, this.parsePrefix());
      } else if (this.optionalOperator("%")) {
        result = new Binary("%", result, this.parsePrefix());
      } else if (this.optionalOperator("/")) {
        result = new Binary("/", result, this.parsePrefix());
      } else {
        return result;
      }
    }
  }
  AST parsePrefix() {
    if (this.optionalOperator("+")) {
      return this.parsePrefix();
    } else if (this.optionalOperator("-")) {
      return new Binary("-", new LiteralPrimitive(0), this.parsePrefix());
    } else if (this.optionalOperator("!")) {
      return new PrefixNot(this.parsePrefix());
    } else {
      return this.parseCallChain();
    }
  }
  AST parseCallChain() {
    var result = this.parsePrimary();
    while (true) {
      if (this.optionalCharacter($PERIOD)) {
        result = this.parseAccessMemberOrMethodCall(result, false);
      } else if (this.optionalOperator("?.")) {
        result = this.parseAccessMemberOrMethodCall(result, true);
      } else if (this.optionalCharacter($LBRACKET)) {
        var key = this.parsePipe();
        this.expectCharacter($RBRACKET);
        result = new KeyedAccess(result, key);
      } else if (this.optionalCharacter($LPAREN)) {
        var args = this.parseCallArguments();
        this.expectCharacter($RPAREN);
        result = new FunctionCall(result, args);
      } else {
        return result;
      }
    }
  }
  AST parsePrimary() {
    if (this.optionalCharacter($LPAREN)) {
      var result = this.parsePipe();
      this.expectCharacter($RPAREN);
      return result;
    } else if (this.next.isKeywordNull() || this.next.isKeywordUndefined()) {
      this.advance();
      return new LiteralPrimitive(null);
    } else if (this.next.isKeywordTrue()) {
      this.advance();
      return new LiteralPrimitive(true);
    } else if (this.next.isKeywordFalse()) {
      this.advance();
      return new LiteralPrimitive(false);
    } else if (this.parseAction && this.next.isKeywordIf()) {
      this.advance();
      this.expectCharacter($LPAREN);
      var condition = this.parseExpression();
      this.expectCharacter($RPAREN);
      var ifExp = this.parseExpressionOrBlock();
      var elseExp;
      if (this.next.isKeywordElse()) {
        this.advance();
        elseExp = this.parseExpressionOrBlock();
      }
      return new If(condition, ifExp, elseExp);
    } else if (this.optionalCharacter($LBRACKET)) {
      var elements = this.parseExpressionList($RBRACKET);
      this.expectCharacter($RBRACKET);
      return new LiteralArray(elements);
    } else if (this.next.isCharacter($LBRACE)) {
      return this.parseLiteralMap();
    } else if (this.next.isIdentifier()) {
      return this.parseAccessMemberOrMethodCall(_implicitReceiver, false);
    } else if (this.next.isNumber()) {
      var value = this.next.toNumber();
      this.advance();
      return new LiteralPrimitive(value);
    } else if (this.next.isString()) {
      var literalValue = this.next.toString();
      this.advance();
      return new LiteralPrimitive(literalValue);
    } else if (this.index >= this.tokens.length) {
      this.error('''Unexpected end of expression: ${ this . input}''');
    } else {
      this.error('''Unexpected token ${ this . next}''');
    }
    // error() throws, so we don't reach here.
    throw new BaseException("Fell through all cases in parsePrimary");
  }
  List<dynamic> parseExpressionList(int terminator) {
    var result = [];
    if (!this.next.isCharacter(terminator)) {
      do {
        result.add(this.parsePipe());
      } while (this.optionalCharacter($COMMA));
    }
    return result;
  }
  LiteralMap parseLiteralMap() {
    var keys = [];
    var values = [];
    this.expectCharacter($LBRACE);
    if (!this.optionalCharacter($RBRACE)) {
      do {
        var key = this.expectIdentifierOrKeywordOrString();
        keys.add(key);
        this.expectCharacter($COLON);
        values.add(this.parsePipe());
      } while (this.optionalCharacter($COMMA));
      this.expectCharacter($RBRACE);
    }
    return new LiteralMap(keys, values);
  }
  AST parseAccessMemberOrMethodCall(AST receiver, [bool isSafe = false]) {
    var id = this.expectIdentifierOrKeyword();
    if (this.optionalCharacter($LPAREN)) {
      var args = this.parseCallArguments();
      this.expectCharacter($RPAREN);
      var fn = this.reflector.method(id);
      return isSafe
          ? new SafeMethodCall(receiver, id, fn, args)
          : new MethodCall(receiver, id, fn, args);
    } else {
      var getter = this.reflector.getter(id);
      var setter = this.reflector.setter(id);
      return isSafe
          ? new SafeAccessMember(receiver, id, getter, setter)
          : new AccessMember(receiver, id, getter, setter);
    }
  }
  List<BindingPipe> parseCallArguments() {
    if (this.next.isCharacter($RPAREN)) return [];
    var positionals = [];
    do {
      positionals.add(this.parsePipe());
    } while (this.optionalCharacter($COMMA));
    return positionals;
  }
  AST parseExpressionOrBlock() {
    if (this.optionalCharacter($LBRACE)) {
      var block = this.parseBlockContent();
      this.expectCharacter($RBRACE);
      return block;
    }
    return this.parseExpression();
  }
  AST parseBlockContent() {
    if (!this.parseAction) {
      this.error("Binding expression cannot contain chained expression");
    }
    var exprs = [];
    while (this.index < this.tokens.length && !this.next.isCharacter($RBRACE)) {
      var expr = this.parseExpression();
      exprs.add(expr);
      if (this.optionalCharacter($SEMICOLON)) {
        while (this.optionalCharacter($SEMICOLON)) {}
      }
    }
    if (exprs.length == 0) return new EmptyExpr();
    if (exprs.length == 1) return exprs[0];
    return new Chain(exprs);
  }
  /**
   * An identifier, a keyword, a string with an optional `-` inbetween.
   */
  String expectTemplateBindingKey() {
    var result = "";
    var operatorFound = false;
    do {
      result += this.expectIdentifierOrKeywordOrString();
      operatorFound = this.optionalOperator("-");
      if (operatorFound) {
        result += "-";
      }
    } while (operatorFound);
    return result.toString();
  }
  List<dynamic> parseTemplateBindings() {
    var bindings = [];
    var prefix = null;
    while (this.index < this.tokens.length) {
      bool keyIsVar = this.optionalKeywordVar();
      var key = this.expectTemplateBindingKey();
      if (!keyIsVar) {
        if (prefix == null) {
          prefix = key;
        } else {
          key = prefix + "-" + key;
        }
      }
      this.optionalCharacter($COLON);
      var name = null;
      var expression = null;
      if (keyIsVar) {
        if (this.optionalOperator("=")) {
          name = this.expectTemplateBindingKey();
        } else {
          name = "\$implicit";
        }
      } else if (!identical(this.next, EOF) && !this.peekKeywordVar()) {
        var start = this.inputIndex;
        var ast = this.parsePipe();
        var source = this.input.substring(start, this.inputIndex);
        expression = new ASTWithSource(ast, source, this.location);
      }
      bindings.add(new TemplateBinding(key, keyIsVar, name, expression));
      if (!this.optionalCharacter($SEMICOLON)) {
        this.optionalCharacter($COMMA);
      }
    }
    return bindings;
  }
  error(String message, [int index = null]) {
    if (isBlank(index)) index = this.index;
    var location = (index < this.tokens.length)
        ? '''at column ${ this . tokens [ index ] . index + 1} in'''
        : '''at the end of the expression''';
    throw new BaseException(
        '''Parser Error: ${ message} ${ location} [${ this . input}] in ${ this . location}''');
  }
}
class SimpleExpressionChecker implements AstVisitor {
  static bool check(AST ast) {
    var s = new SimpleExpressionChecker();
    ast.visit(s);
    return s.simple;
  }
  var simple = true;
  visitImplicitReceiver(ImplicitReceiver ast) {}
  visitInterpolation(Interpolation ast) {
    this.simple = false;
  }
  visitLiteralPrimitive(LiteralPrimitive ast) {}
  visitAccessMember(AccessMember ast) {}
  visitSafeAccessMember(SafeAccessMember ast) {
    this.simple = false;
  }
  visitMethodCall(MethodCall ast) {
    this.simple = false;
  }
  visitSafeMethodCall(SafeMethodCall ast) {
    this.simple = false;
  }
  visitFunctionCall(FunctionCall ast) {
    this.simple = false;
  }
  visitLiteralArray(LiteralArray ast) {
    this.visitAll(ast.expressions);
  }
  visitLiteralMap(LiteralMap ast) {
    this.visitAll(ast.values);
  }
  visitBinary(Binary ast) {
    this.simple = false;
  }
  visitPrefixNot(PrefixNot ast) {
    this.simple = false;
  }
  visitConditional(Conditional ast) {
    this.simple = false;
  }
  visitPipe(BindingPipe ast) {
    this.simple = false;
  }
  visitKeyedAccess(KeyedAccess ast) {
    this.simple = false;
  }
  List<dynamic> visitAll(List<dynamic> asts) {
    var res = ListWrapper.createFixedSize(asts.length);
    for (var i = 0; i < asts.length; ++i) {
      res[i] = asts[i].visit(this);
    }
    return res;
  }
  visitChain(Chain ast) {
    this.simple = false;
  }
  visitAssignment(Assignment ast) {
    this.simple = false;
  }
  visitIf(If ast) {
    this.simple = false;
  }
}
