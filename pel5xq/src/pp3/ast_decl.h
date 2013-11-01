/* File: ast_decl.h
 * ----------------
 * In our parse tree, Decl nodes are used to represent and
 * manage declarations. There are 4 subclasses of the base class,
 * specialized for declarations of variables, functions, classes,
 * and interfaces.
 */

#ifndef _H_ast_decl
#define _H_ast_decl

#include "ast.h"
#include "list.h"
#include "utility.h"
#include "symboltable.h"

class Type;
class NamedType;
class Identifier;
class Stmt;
class SymbolTable;

class Decl : public Node 
{
  protected:
    Identifier *id;
  
  public:
    SymbolTable *symboltable;
    const char *GetName() {return id->GetName();}
    Decl(Identifier *name);
    virtual void BuildSymbolTable(SymbolTable *table) {}
    virtual void ValidateExtensions(SymbolTable *covered) {}
    virtual void ValidateInterfaces() {}
};

class VarDecl : public Decl 
{
  protected:
    Type *type;
    
  public:
    VarDecl(Identifier *name, Type *type);
    const char *GetPrintNameForNode() { return "VarDecl"; }
    Type *GetType() { return type; }
    void PrintChildren(int indentLevel);
    void BuildSymbolTable(SymbolTable *table);
    void ValidateExtensions(SymbolTable *covered) {}
    void ValidateInterfaces() {}
};

class ClassDecl : public Decl 
{
  protected:
    List<Decl*> *members;
    NamedType *extends;
    List<NamedType*> *implements;

  public:
    SymbolTable *bodytable;
    ClassDecl(Identifier *name, NamedType *extends, 
              List<NamedType*> *implements, List<Decl*> *members);
    const char *GetPrintNameForNode() { return "ClassDecl"; }
    void PrintChildren(int indentLevel);
    void BuildSymbolTable(SymbolTable *table);
    void ValidateExtensions(SymbolTable *covered);
    void ValidateInterfaces();
};

class InterfaceDecl : public Decl 
{
  protected:
    List<Decl*> *members;
    
  public:
    SymbolTable *bodytable;
    InterfaceDecl(Identifier *name, List<Decl*> *members);
    const char *GetPrintNameForNode() { return "InterfaceDecl"; }
    void PrintChildren(int indentLevel);
    void BuildSymbolTable(SymbolTable *table);
    void ValidateExtensions(SymbolTable *covered) {}
    void ValidateInterfaces() {}
};

class FnDecl : public Decl 
{
  protected:
    List<VarDecl*> *formals;
    Type *returnType;
    Stmt *body;
    
  public:
    SymbolTable *parameterstable;
    FnDecl(Identifier *name, Type *returnType, List<VarDecl*> *formals);
    void SetFunctionBody(Stmt *b);
    const char *GetPrintNameForNode() { return "FnDecl"; }
    List<VarDecl*> *GetFormals() { return formals; }
    Type *GetType() { return returnType; }
    void PrintChildren(int indentLevel);
    void BuildSymbolTable(SymbolTable *table);
    void ValidateExtensions(SymbolTable *covered) {}
    void ValidateInterfaces() {}
};

#endif
