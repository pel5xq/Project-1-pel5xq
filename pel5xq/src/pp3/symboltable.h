#ifndef _H_symboltable
#define _H_symboltable

#include "hashtable.h"
#include "ast.h"
#include "ast_decl.h"
#include <string.h>

class Decl;

class SymbolTable {
  public: 
     Hashtable<Decl*> *table;
     SymbolTable *parent;
     SymbolTable();
     SymbolTable(SymbolTable *other); //instantiates with parent
};

#endif
