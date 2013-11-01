#include "symboltable.h"
#include "hashtable.h"
#include "ast.h"
#include "ast_decl.h"
#include <string.h>

SymbolTable::SymbolTable() {
	table = new Hashtable<Decl*>();
	parent = NULL;
}

SymbolTable::SymbolTable(SymbolTable *other) {
	table = new Hashtable<Decl*>();
	parent = other;
}


