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
#include "errors.h"
 

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
     symboltable = table;

     body->BuildSymbolTable(symboltable);
     if (elseBody) elseBody->BuildSymbolTable(symboltable);

     if (test) test->BuildSymbolTable(symboltable);
}

void WhileStmt::BuildSymbolTable(SymbolTable *table) {
     symboltable = table;

     body->BuildSymbolTable(symboltable);

     if (test) test->BuildSymbolTable(symboltable);
}

void ForStmt::BuildSymbolTable(SymbolTable *table) {
     symboltable = table;

     body->BuildSymbolTable(symboltable);

     if (test) test->BuildSymbolTable(symboltable);
     if (init) init->BuildSymbolTable(symboltable);
     if (step) step->BuildSymbolTable(symboltable);
}

void ReturnStmt::BuildSymbolTable(SymbolTable *table) {
     symboltable = table;

     if (expr) expr->BuildSymbolTable(symboltable);
}

void PrintStmt::BuildSymbolTable(SymbolTable *table) {
     symboltable = table;

     int i = 0;
     for (; i < args->NumElements(); i++) args->Nth(i)->BuildSymbolTable(table);
}

void Case::BuildSymbolTable(SymbolTable *table) {
     symboltable = table;

     int i = 0;
     for (; i < stmts->NumElements(); i++) stmts->Nth(i)->BuildSymbolTable(table);
}

void SwitchStmt::BuildSymbolTable(SymbolTable *table) {
     symboltable = table;

     if (expr) expr->BuildSymbolTable(symboltable);

     int i = 0;
     for (; i < cases->NumElements(); i++) cases->Nth(i)->BuildSymbolTable(table);
}

//----------------

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

void Case::ValidateDeclarations() {
     int i = 0;
     for (; i < stmts->NumElements(); i++) stmts->Nth(i)->ValidateDeclarations();
}

void SwitchStmt::ValidateDeclarations() {
     int i = 0;
     for (; i < cases->NumElements(); i++) cases->Nth(i)->ValidateDeclarations();
}

//----------------------

void StmtBlock::Check(SymbolTable *rootscope) {
   if (stmts) {
      int i = 0;
      for (; i < stmts->NumElements(); i++) {
         stmts->Nth(i)->Check(rootscope);
      }
   }
}

void ForStmt::Check(SymbolTable *rootscope) {
   test->Check(rootscope);
   if (strcmp(test->getTypeName(), "bool") != 0) {
      ReportError::Formatted(test->GetLocation(), "Test expression must have boolean type");
   }
   
   if (init) init->Check(rootscope);
   if (step) step->Check(rootscope);

   if (body) body->Check(rootscope);
}

void WhileStmt::Check(SymbolTable *rootscope) {
   test->Check(rootscope);
   if (strcmp(test->getTypeName(), "bool") != 0) {
      ReportError::Formatted(test->GetLocation(), "Test expression must have boolean type");
   }
   
   if (body) body->Check(rootscope);
}

void IfStmt::Check(SymbolTable *rootscope) {
   test->Check(rootscope);
   if (strcmp(test->getTypeName(), "bool") != 0) {
      ReportError::Formatted(test->GetLocation(), "Test expression must have boolean type");
   }
   
   if (body) body->Check(rootscope);
   if (elseBody) elseBody->Check(rootscope);
}

void BreakStmt::Check(SymbolTable *rootscope) {
   bool isFromLoop = false;
   Node *parentNode = this;
   while (NULL != (parentNode = parentNode->GetParent())) {
       WhileStmt *parentWStmt = dynamic_cast<WhileStmt *>(parentNode);
       ForStmt *parentFStmt = dynamic_cast<ForStmt *>(parentNode);
       SwitchStmt *parentSStmt = dynamic_cast<SwitchStmt *>(parentNode);
       if (NULL != parentWStmt || NULL != parentFStmt || NULL != parentSStmt) { //added switch too
          isFromLoop = true;
          break;
       }
   }
   if (!isFromLoop) {
      ReportError::Formatted(GetLocation(), "break is only allowed inside a loop");
   }
}

void ReturnStmt::Check(SymbolTable *rootscope) {
   expr->Check(rootscope);
   
   const char* rtype = expr->getTypeName();
   const char* ltype = "error";

   Node *parentNode = this;
   while (NULL != (parentNode = parentNode->GetParent())) {
       FnDecl *parentDecl = dynamic_cast<FnDecl *>(parentNode);
       if (NULL != parentDecl) {
          ltype = parentDecl->GetType()->GetFullName();
          break;
       }
   }

   if (strcmp(ltype, "error") == 0 || strcmp(rtype, "error") == 0) {} //Mask error
   else if(strncmp(ltype, "int", 3) == 0
      || strncmp(ltype, "double", 6) == 0
      || strncmp(ltype, "bool", 4) == 0
      || strncmp(ltype, "string", 6) == 0
      || strcmp(ltype, "void") == 0

      || strncmp(rtype, "int", 3) == 0
      || strncmp(rtype, "double", 6) == 0
      || strncmp(rtype, "bool", 4) == 0
      || strncmp(rtype, "string", 6) == 0
      || strcmp(rtype, "void") == 0) {

      if (strcmp(ltype, rtype) != 0) {
         if (strcmp(rtype, "void") == 0) {
            ReportError::Formatted(GetLocation(), "Incompatible return: %s given, %s expected", rtype, ltype);
         }
         else {
            ReportError::Formatted(expr->GetLocation(), "Incompatible return: %s given, %s expected", rtype, ltype);
         }
      }

   }
   else {
      //Need to change to remove array subtyping polymorphism?

      //Deal with possible different numbers of [][]
      //assuming return null for object[][] not valid
      if (!Expr::equalArrayDimensions(ltype, rtype)) {
         ReportError::Formatted(expr->GetLocation(), "Incompatible return: %s given, %s expected", rtype, ltype);
      }
      else {
         const char *coreLType = Expr::stripAway(ltype);
         const char *coreRType = Expr::stripAway(rtype);
         
         if (strcmp(coreLType, coreRType) == 0
             //|| strcmp(coreLType, "null") == 0
             || strcmp(coreRType, "null") == 0) {
            //Do nothing
         }
         else {
            //Decl* lDecl = rootscope->table->Lookup(coreLType);
            Decl* rDecl = rootscope->table->Lookup(coreRType);
            if (rDecl) {//lDecl && 
               if (!(rDecl->isSubclassOf(coreLType) == 1)) {//lDecl->isSubclassOf(coreRType) == 1 || 
                  ReportError::Formatted(expr->GetLocation(), "Incompatible return: %s given, %s expected", rtype, ltype);
               }
            }
            else {
               //printf("Unexpected null class definition (%s or %s)\n", coreLType, coreRType);
               //Keep quiet, will have found earlier
            }
         }
      }
   }

}

void PrintStmt::Check(SymbolTable *rootscope) {
   int i = 0;
   for (; i < args->NumElements(); i++) {
      args->Nth(i)->Check(rootscope);
      const char * name = args->Nth(i)->getTypeName();
      if (strcmp(name, "error") == 0) {} //Mask
      else if(!(strcmp(name, "int") == 0
           || strcmp(name, "bool") == 0
           || strcmp(name, "string") == 0)) {
         ReportError::Formatted(args->Nth(i)->GetLocation(), 
            "Incompatible argument %d: %s given, int/bool/string expected", i+1, name);
      }
   }
}

void Case::Check(SymbolTable *rootscope) {
int i = 0;
   for (; i < stmts->NumElements(); i++) {
      stmts->Nth(i)->Check(rootscope);
   } //No other checks specified in literature?
}

void SwitchStmt::Check(SymbolTable *rootscope) {
   expr->Check(rootscope);

   if (strcmp(expr->getTypeName(), "int") != 0) {
      ReportError::Formatted(expr->GetLocation(), "Switch expression must have int type");
   }

   int i = 0;
   for (; i < cases->NumElements(); i++) {
      cases->Nth(i)->Check(rootscope);
   }
}
