/* File: ast_stmt.h
 * ----------------
 * The Stmt class and its subclasses are used to represent
 * statements in the parse tree.  For each statment in the
 * language (for, if, return, etc.) there is a corresponding
 * node class for that construct. 
 */


#ifndef _H_ast_stmt
#define _H_ast_stmt

#include "list.h"
#include "ast.h"
#include "symboltable.h"

class Decl;
class VarDecl;
class Expr;
  
class Program : public Node
{
  protected:
     List<Decl*> *decls;
     
  public:
     SymbolTable *symboltable;

     Program(List<Decl*> *declList);
     const char *GetPrintNameForNode() { return "Program"; }
     void PrintChildren(int indentLevel);
     void BuildSymbolTable(SymbolTable *table);
     void ValidateClassHierarchy();
     void ValidateDeclarations();
     void ValidateProgram();
};

class Stmt : public Node
{
  public:
     SymbolTable *symboltable;

     Stmt() : Node() {}
     Stmt(yyltype loc) : Node(loc) {}
     virtual void BuildSymbolTable(SymbolTable *table) {}
     virtual void ValidateDeclarations() {}
     virtual void Check(SymbolTable *rootscope) {}
};

class StmtBlock : public Stmt 
{
  protected:
    List<VarDecl*> *decls;
    List<Stmt*> *stmts;
    
  public:
    StmtBlock(List<VarDecl*> *variableDeclarations, List<Stmt*> *statements);
    const char *GetPrintNameForNode() { return "StmtBlock"; }
    void PrintChildren(int indentLevel);
    void BuildSymbolTable(SymbolTable *table);
    void ValidateDeclarations();
    void Check(SymbolTable *rootscope);
};

  
class ConditionalStmt : public Stmt
{
  protected:
    Expr *test;
    Stmt *body;
  
  public:
    ConditionalStmt(Expr *testExpr, Stmt *body);
    void BuildSymbolTable(SymbolTable *table) {}
    void ValidateDeclarations() {}
    void Check(SymbolTable *rootscope) {}
};

class LoopStmt : public ConditionalStmt 
{
  public:
    LoopStmt(Expr *testExpr, Stmt *body)
            : ConditionalStmt(testExpr, body) {}
};

class ForStmt : public LoopStmt 
{
  protected:
    Expr *init, *step;
  
  public:
    ForStmt(Expr *init, Expr *test, Expr *step, Stmt *body);
    const char *GetPrintNameForNode() { return "ForStmt"; }
    void PrintChildren(int indentLevel);
    void BuildSymbolTable(SymbolTable *table);
    void ValidateDeclarations();
    void Check(SymbolTable *rootscope);
};

class WhileStmt : public LoopStmt 
{
  public:
    WhileStmt(Expr *test, Stmt *body) : LoopStmt(test, body) {}
    const char *GetPrintNameForNode() { return "WhileStmt"; }
    void PrintChildren(int indentLevel);
    void BuildSymbolTable(SymbolTable *table);
    void ValidateDeclarations();
    void Check(SymbolTable *rootscope);
};

class IfStmt : public ConditionalStmt 
{
  protected:
    Stmt *elseBody;
  
  public:
    IfStmt(Expr *test, Stmt *thenBody, Stmt *elseBody);
    const char *GetPrintNameForNode() { return "IfStmt"; }
    void PrintChildren(int indentLevel);
    void BuildSymbolTable(SymbolTable *table);
    void ValidateDeclarations();
    void Check(SymbolTable *rootscope);
};

class BreakStmt : public Stmt 
{
  public:
    BreakStmt(yyltype loc) : Stmt(loc) {}
    const char *GetPrintNameForNode() { return "BreakStmt"; }
    void BuildSymbolTable(SymbolTable *table) {}
    void ValidateDeclarations() {}
    void Check(SymbolTable *rootscope);
};

class ReturnStmt : public Stmt  
{
  protected:
    Expr *expr;
  
  public:
    ReturnStmt(yyltype loc, Expr *expr);
    const char *GetPrintNameForNode() { return "ReturnStmt"; }
    void PrintChildren(int indentLevel);
    void BuildSymbolTable(SymbolTable *table) {}
    void ValidateDeclarations() {}
    void Check(SymbolTable *rootscope);
};

class PrintStmt : public Stmt
{
  protected:
    List<Expr*> *args;
    
  public:
    PrintStmt(List<Expr*> *arguments);
    const char *GetPrintNameForNode() { return "PrintStmt"; }
    void PrintChildren(int indentLevel);
    void BuildSymbolTable(SymbolTable *table) {}
    void ValidateDeclarations() {}
    void Check(SymbolTable *rootscope);
};


class IntConstant;

class Case : public Node
{
  protected:
    IntConstant *value;
    List<Stmt*> *stmts;
    
  public:
    Case(IntConstant *v, List<Stmt*> *stmts);
    const char *GetPrintNameForNode() { return value ? "Case" :"Default"; }
    void PrintChildren(int indentLevel);
};

class SwitchStmt : public Stmt
{
  protected:
    Expr *expr;
    List<Case*> *cases;
    
  public:
    SwitchStmt(Expr *e, List<Case*> *cases);
    const char *GetPrintNameForNode() { return "SwitchStmt"; }
    void PrintChildren(int indentLevel);
    void BuildSymbolTable(SymbolTable *table) {}
    void ValidateDeclarations() {}
    void Check(SymbolTable *rootscope);
};

#endif
