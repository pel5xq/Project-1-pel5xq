/* File: ast_expr.h
 * ----------------
 * The Expr class and its subclasses are used to represent
 * expressions in the parse tree.  For each expression in the
 * language (add, call, New, etc.) there is a corresponding
 * node class for that construct. 
 */


#ifndef _H_ast_expr
#define _H_ast_expr

#include "ast.h"
#include "ast_stmt.h"
#include "list.h"
#include "symboltable.h"


class NamedType; // for new
class Type; // for NewArray


class Expr : public Stmt 
{
  public:
    //bool errorReported;

    Expr(yyltype loc) : Stmt(loc) {}// errorReported = false; }
    Expr() : Stmt() {}// errorReported = false; }
    virtual void BuildSymbolTable(SymbolTable *table) { symboltable = table; }
    virtual void Check(SymbolTable *rootscope) {}
    virtual const char * getTypeName() {return NULL;}
    static bool equalArrayDimensions(const char *t1, const char *t2);
    static const char * stripAway(const char *t1);
    //SymbolTable *symboltable;
};

/* This node type is used for those places where an expression is optional.
 * We could use a NULL pointer, but then it adds a lot of checking for
 * NULL. By using a valid, but no-op, node, we save that trouble */
class EmptyExpr : public Expr
{
  public:
    const char *GetPrintNameForNode() { return "Empty"; }
    void Check(SymbolTable *rootscope) {}
    const char * getTypeName() {return "none";}
    void BuildSymbolTable(SymbolTable *table) { symboltable = table; }
};

class IntConstant : public Expr 
{
  protected:
    int value;
  
  public:
    IntConstant(yyltype loc, int val);
    const char *GetPrintNameForNode() { return "IntConstant"; }
    void PrintChildren(int indentLevel);
    void Check(SymbolTable *rootscope) {}
    const char * getTypeName() {return "int";}
    void BuildSymbolTable(SymbolTable *table) { symboltable = table; }
};

class DoubleConstant : public Expr 
{
  protected:
    double value;
    
  public:
    DoubleConstant(yyltype loc, double val);
    const char *GetPrintNameForNode() { return "DoubleConstant"; }
    void PrintChildren(int indentLevel);
    void Check(SymbolTable *rootscope) {}
    const char * getTypeName() {return "double";}
    void BuildSymbolTable(SymbolTable *table) { symboltable = table; }
};

class BoolConstant : public Expr 
{
  protected:
    bool value;
    
  public:
    BoolConstant(yyltype loc, bool val);
    const char *GetPrintNameForNode() { return "BoolConstant"; }
    void PrintChildren(int indentLevel);
    void Check(SymbolTable *rootscope) {}
    const char * getTypeName() {return "boolean";}
    void BuildSymbolTable(SymbolTable *table) { symboltable = table; }
};

class StringConstant : public Expr 
{ 
  protected:
    char *value;
    
  public:
    StringConstant(yyltype loc, const char *val);
    const char *GetPrintNameForNode() { return "StringConstant"; }
    void PrintChildren(int indentLevel);
    void Check(SymbolTable *rootscope) {}
    const char * getTypeName() {return "string";}
    void BuildSymbolTable(SymbolTable *table) { symboltable = table; }
};

class NullConstant: public Expr 
{
  public: 
    NullConstant(yyltype loc) : Expr(loc) {}
    const char *GetPrintNameForNode() { return "NullConstant"; }
    void Check(SymbolTable *rootscope) {}
    const char * getTypeName() {return "null";}
    void BuildSymbolTable(SymbolTable *table) { symboltable = table; }
};

class Operator : public Node 
{
  protected:
    char tokenString[4];
    
  public:
    Operator(yyltype loc, const char *tok);
    const char *GetPrintNameForNode() { return "Operator"; }
    const char *GetTokenString() { return tokenString; }
    void PrintChildren(int indentLevel);
 };
 
class CompoundExpr : public Expr
{
  protected:
    Operator *op;
    Expr *left, *right; // left will be NULL if unary
    
  public:
    CompoundExpr(Expr *lhs, Operator *op, Expr *rhs); // for binary
    CompoundExpr(Operator *op, Expr *rhs);             // for unary
    void PrintChildren(int indentLevel);
    Expr * GetLeft() {return left;}
    Expr * GetRight() {return right;}
};

class ArithmeticExpr : public CompoundExpr 
{
  public:
    ArithmeticExpr(Expr *lhs, Operator *op, Expr *rhs) : CompoundExpr(lhs,op,rhs) {}
    ArithmeticExpr(Operator *op, Expr *rhs) : CompoundExpr(op,rhs) {}
    const char *GetPrintNameForNode() { return "ArithmeticExpr"; }
    void Check(SymbolTable *rootscope);
    const char * getTypeName();
    void BuildSymbolTable(SymbolTable *table);
};

class RelationalExpr : public CompoundExpr 
{
  public:
    RelationalExpr(Expr *lhs, Operator *op, Expr *rhs) : CompoundExpr(lhs,op,rhs) {}
    const char *GetPrintNameForNode() { return "RelationalExpr"; }
    void Check(SymbolTable *rootscope);
    const char * getTypeName();
    void BuildSymbolTable(SymbolTable *table);
};

class EqualityExpr : public CompoundExpr 
{
  public:
    EqualityExpr(Expr *lhs, Operator *op, Expr *rhs) : CompoundExpr(lhs,op,rhs) {}
    const char *GetPrintNameForNode() { return "EqualityExpr"; }
    void Check(SymbolTable *rootscope);
    const char * getTypeName();
    void BuildSymbolTable(SymbolTable *table);
};

class LogicalExpr : public CompoundExpr 
{
  public:
    LogicalExpr(Expr *lhs, Operator *op, Expr *rhs) : CompoundExpr(lhs,op,rhs) {}
    LogicalExpr(Operator *op, Expr *rhs) : CompoundExpr(op,rhs) {}
    const char *GetPrintNameForNode() { return "LogicalExpr"; }
    void Check(SymbolTable *rootscope);
    const char * getTypeName();
    void BuildSymbolTable(SymbolTable *table);
};

class AssignExpr : public CompoundExpr 
{
  public:
    AssignExpr(Expr *lhs, Operator *op, Expr *rhs) : CompoundExpr(lhs,op,rhs) {}
    const char *GetPrintNameForNode() { return "AssignExpr"; }
    void Check(SymbolTable *rootscope);
    const char * getTypeName();
    void BuildSymbolTable(SymbolTable *table);
};

class LValue : public Expr 
{
  public:
    LValue(yyltype loc) : Expr(loc) {}
};

class This : public Expr 
{
  public:
    const char *thisType;

    This(yyltype loc) : Expr(loc) {}
    const char *GetPrintNameForNode() { return "This"; }
    void Check(SymbolTable *rootscope);
    const char * getTypeName();
    void BuildSymbolTable(SymbolTable *table) { symboltable = table; }
};

class ArrayAccess : public LValue 
{
  protected:
    Expr *base, *subscript;
    
  public:
    ArrayAccess(yyltype loc, Expr *base, Expr *subscript);
    const char *GetPrintNameForNode() { return "ArrayAccess"; }
    void PrintChildren(int indentLevel);
    void Check(SymbolTable *rootscope);
    const char * getTypeName();
    void BuildSymbolTable(SymbolTable *table);
};

/* Note that field access is used both for qualified names
 * base.field and just field without qualification. We don't
 * know for sure whether there is an implicit "this." in
 * front until later on, so we use one node type for either
 * and sort it out later. */
class FieldAccess : public LValue 
{
  protected:
    Expr *base;	// will be NULL if no explicit base
    Identifier *field;
    
  public:
    const char *fieldType;

    FieldAccess(Expr *base, Identifier *field); //ok to pass NULL base
    const char *GetPrintNameForNode() { return "FieldAccess"; }
    void PrintChildren(int indentLevel);
    void Check(SymbolTable *rootscope);
    const char * getTypeName();
    void BuildSymbolTable(SymbolTable *table);
};

/* Like field access, call is used both for qualified base.field()
 * and unqualified field().  We won't figure out until later
 * whether we need implicit "this." so we use one node type for either
 * and sort it out later. */
class Call : public Expr 
{
  protected:
    Expr *base;	// will be NULL if no explicit base
    Identifier *field;
    List<Expr*> *actuals;
    
  public:
    const char *fieldType;

    Call(yyltype loc, Expr *base, Identifier *field, List<Expr*> *args);
    const char *GetPrintNameForNode() { return "Call"; }
    void PrintChildren(int indentLevel);
    void Check(SymbolTable *rootscope);
    const char * getTypeName();
    void BuildSymbolTable(SymbolTable *table);

};

class NewExpr : public Expr
{
  protected:
    NamedType *cType;
    
  public:
    NewExpr(yyltype loc, NamedType *clsType);
    const char *GetPrintNameForNode() { return "NewExpr"; }
    void PrintChildren(int indentLevel);
    void Check(SymbolTable *rootscope);
    const char * getTypeName();
    void BuildSymbolTable(SymbolTable *table) { symboltable = table; }
};

class NewArrayExpr : public Expr
{
  protected:
    Expr *size;
    Type *elemType;
    
  public:
    NewArrayExpr(yyltype loc, Expr *sizeExpr, Type *elemType);
    const char *GetPrintNameForNode() { return "NewArrayExpr"; }
    void PrintChildren(int indentLevel);
    void Check(SymbolTable *rootscope);
    const char * getTypeName();
    void BuildSymbolTable(SymbolTable *table);
};

class ReadIntegerExpr : public Expr
{
  public:
    ReadIntegerExpr(yyltype loc) : Expr(loc) {}
    const char *GetPrintNameForNode() { return "ReadIntegerExpr"; }
    void Check(SymbolTable *rootscope);
    const char * getTypeName() {return "int"; }
    void BuildSymbolTable(SymbolTable *table) { symboltable = table; }
};

class ReadLineExpr : public Expr
{
  public:
    ReadLineExpr(yyltype loc) : Expr (loc) {}
    const char *GetPrintNameForNode() { return "ReadLineExpr"; }
    void Check(SymbolTable *rootscope);
    const char * getTypeName() { return "string"; }
    void BuildSymbolTable(SymbolTable *table) { symboltable = table; }
};

class PostfixExpr : public Expr
{
   protected:
     LValue *lvalue;
     Operator *op;
  public: 
    PostfixExpr(LValue *lv, Operator *op);
    const char *GetPrintNameForNode() { return "PostfixExpr"; }
    void PrintChildren(int indentLevel);
    void Check(SymbolTable *rootscope);
    const char * getTypeName();
    void BuildSymbolTable(SymbolTable *table);
};
    
#endif
