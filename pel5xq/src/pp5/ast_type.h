/* File: ast_type.h
 * ----------------
 * In our parse tree, Type nodes are used to represent and
 * store type information. The base Type class is used
 * for built-in types, the NamedType for classes and interfaces,
 * and the ArrayType for arrays of other types.  
 */
 
#ifndef _H_ast_type
#define _H_ast_type

#include "ast.h"
#include "list.h"
#include "symboltable.h"
#include "codegen.h"


class Type : public Node 
{
  protected:
    char *typeName;

  public :
    static Type *intType, *doubleType, *boolType, *voidType,
                *nullType, *stringType, *errorType;

    Type(yyltype loc) : Node(loc) {}
    Type(const char *str);
    
    const char *GetPrintNameForNode() { return "Type"; }
    void PrintChildren(int indentLevel);
    const char *GetFullName();
    const char *GetCoreName();
    bool isPrimitiveType();
    Type* GetCoreType();
    virtual int compare(Type *other);
    virtual int comparePolymorph(Type *other, SymbolTable *rootscope);
    virtual int comparePolymorph(const char *other, SymbolTable *rootscope);
    virtual void Emit(CodeGenerator *codegen) {}
};

class NamedType : public Type 
{
  protected:
    Identifier *id;
    
  public:
    NamedType(Identifier *i);
    
    const char *GetPrintNameForNode() { return "NamedType"; }
    const char *GetName() { return id->GetName(); }
    void PrintChildren(int indentLevel);
    void Emit(CodeGenerator *codegen) {}
};

class ArrayType : public Type 
{
  protected:
    Type *elemType;

  public:
    ArrayType(yyltype loc, Type *elemType);
    
    const char *GetPrintNameForNode() { return "ArrayType"; }
    Type *GetElemType() { return elemType; }
    void PrintChildren(int indentLevel);
    void Emit(CodeGenerator *codegen) {}
};

 
#endif
