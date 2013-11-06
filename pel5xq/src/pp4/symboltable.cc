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

Decl* SymbolTable::Find(const char *key) {
	Decl* value = table->Lookup(key);
	if (value) return value;
	else if (parent) return parent->Find(key);	
	else return NULL;
}


