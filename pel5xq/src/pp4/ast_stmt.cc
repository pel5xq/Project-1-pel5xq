/* File: ast_stmt.cc
 * -----------------
 * Implementation of statement node classes.
 */
#include "ast_stmt.h"
#include "ast_type.h"
#include "ast_decl.h"
#include "ast_expr.h"
#include "symboltable.h"
#include "list.h"
#include <string>
 

Program::Program(List<Decl*> *d) {
    Assert(d != NULL);
    (decls=d)->SetParentAll(this);
}

void Program::PrintChildren(int indentLevel) {
    decls->PrintAll(indentLevel+1);
    printf("\n");
}

StmtBlock::StmtBlock(List<VarDecl*> *d, List<Stmt*> *s) {
    Assert(d != NULL && s != NULL);
    (decls=d)->SetParentAll(this);
    (stmts=s)->SetParentAll(this);
}

void StmtBlock::PrintChildren(int indentLevel) {
    decls->PrintAll(indentLevel+1);
    stmts->PrintAll(indentLevel+1);
}

ConditionalStmt::ConditionalStmt(Expr *t, Stmt *b) { 
    Assert(t != NULL && b != NULL);
    (test=t)->SetParent(this); 
    (body=b)->SetParent(this);
}

ForStmt::ForStmt(Expr *i, Expr *t, Expr *s, Stmt *b): LoopStmt(t, b) { 
    Assert(i != NULL && t != NULL && s != NULL && b != NULL);
    (init=i)->SetParent(this);
    (step=s)->SetParent(this);
}

void ForStmt::PrintChildren(int indentLevel) {
    init->Print(indentLevel+1, "(init) ");
    test->Print(indentLevel+1, "(test) ");
    step->Print(indentLevel+1, "(step) ");
    body->Print(indentLevel+1, "(body) ");
}

void WhileStmt::PrintChildren(int indentLevel) {
    test->Print(indentLevel+1, "(test) ");
    body->Print(indentLevel+1, "(body) ");
}

IfStmt::IfStmt(Expr *t, Stmt *tb, Stmt *eb): ConditionalStmt(t, tb) { 
    Assert(t != NULL && tb != NULL); // else can be NULL
    elseBody = eb;
    if (elseBody) elseBody->SetParent(this);
}

void IfStmt::PrintChildren(int indentLevel) {
    test->Print(indentLevel+1, "(test) ");
    body->Print(indentLevel+1, "(then) ");
    if (elseBody) elseBody->Print(indentLevel+1, "(else) ");
}


ReturnStmt::ReturnStmt(yyltype loc, Expr *e) : Stmt(loc) { 
    Assert(e != NULL);
    (expr=e)->SetParent(this);
}

void ReturnStmt::PrintChildren(int indentLevel) {
    expr->Print(indentLevel+1);
}
  
PrintStmt::PrintStmt(List<Expr*> *a) {    
    Assert(a != NULL);
    (args=a)->SetParentAll(this);
}

void PrintStmt::PrintChildren(int indentLevel) {
    args->PrintAll(indentLevel+1, "(args) ");
}

Case::Case(IntConstant *v, List<Stmt*> *s) {
    Assert(s != NULL);
    value = v;
    if (value) value->SetParent(this);
    (stmts=s)->SetParentAll(this);
}

void Case::PrintChildren(int indentLevel) {
    if (value) value->Print(indentLevel+1);
    stmts->PrintAll(indentLevel+1);
}

SwitchStmt::SwitchStmt(Expr *e, List<Case*> *c) {
    Assert(e != NULL && c != NULL);
    (expr=e)->SetParent(this);
    (cases=c)->SetParentAll(this);
}
      
void SwitchStmt::PrintChildren(int indentLevel) {
    expr->Print(indentLevel+1);
    cases->PrintAll(indentLevel+1);
}

void Program::ValidateClassHierarchy() {
   Iterator<Decl*> iter = symboltable->table->GetIterator();
   Decl *decl;
   //Just to hold what classes have been checked, not a symbol table
   SymbolTable *coveredClasses = new SymbolTable(); 
   while ((decl = iter.GetNextValue()) != NULL) {
      decl->ValidateExtensions(coveredClasses);
   }

   iter = symboltable->table->GetIterator();
   while ((decl = iter.GetNextValue()) != NULL) {
      decl->ValidateInterfaces();
   }
}

void Program::ValidateDeclarations() {
   Iterator<Decl*> iter = symboltable->table->GetIterator();
   Decl *decl;
   while ((decl = iter.GetNextValue()) != NULL) {
      decl->ValidateDeclarations();
   }
}

void Program::ValidateProgram() {
   ValidateDeclarations();

   Iterator<Decl*> iter = symboltable->table->GetIterator();
   Decl *decl;
   while ((decl = iter.GetNextValue()) != NULL) {
      decl->Check(symboltable);
   }
}

void Program::BuildSymbolTable(SymbolTable *table){
     symboltable = table;
     for (int i = 0; i < decls->NumElements(); i++) {
          decls->Nth(i)->BuildSymbolTable(symboltable);
     }
} 
 
void StmtBlock::BuildSymbolTable(SymbolTable *table) {
     symboltable = new SymbolTable(table);
     int i = 0;
     for (;i<decls->NumElements();i++) {
          decls->Nth(i)->BuildSymbolTable(symboltable);
     }
     for (i=0;i<stmts->NumElements();i++) {
          stmts->Nth(i)->BuildSymbolTable(symboltable);
     }
}

void IfStmt::BuildSymbolTable(SymbolTable *table) {
     body->BuildSymbolTable(symboltable);
     if (elseBody) elseBody->BuildSymbolTable(symboltable);
}

void WhileStmt::BuildSymbolTable(SymbolTable *table) {
     body->BuildSymbolTable(symboltable);
}

void ForStmt::BuildSymbolTable(SymbolTable *table) {
     body->BuildSymbolTable(symboltable);
}



void StmtBlock::ValidateDeclarations() {
     int i = 0;
     if (decls) {
        for (;i<decls->NumElements();i++) {
             if (decls->Nth(i)) decls->Nth(i)->ValidateDeclarations();
        }
     }
     if (stmts) {
        for (i=0;i<stmts->NumElements();i++) {
             if (stmts->Nth(i)) stmts->Nth(i)->ValidateDeclarations();
        }
     }
}

void IfStmt::ValidateDeclarations() {
     if (body) body->ValidateDeclarations();
     if (elseBody) elseBody->ValidateDeclarations();
}

void WhileStmt::ValidateDeclarations() {
     if (body) body->ValidateDeclarations();
}

void ForStmt::ValidateDeclarations() {
     if (body) body->ValidateDeclarations();
}

void StmtBlock::Check(SymbolTable *rootscope) {
   if (stmts) {
      int i = 0;
      for (; i < stmts->NumElements(); i++) {
         stmts->Nth(i)->Check(rootscope);
      }
   }
}

void ForStmt::Check(SymbolTable *rootscope) {

}

void WhileStmt::Check(SymbolTable *rootscope) {

}

void IfStmt::Check(SymbolTable *rootscope) {

}

void BreakStmt::Check(SymbolTable *rootscope) {

}

void ReturnStmt::Check(SymbolTable *rootscope) {

}

void PrintStmt::Check(SymbolTable *rootscope) {

}

void SwitchStmt::Check(SymbolTable *rootscope) {

}
