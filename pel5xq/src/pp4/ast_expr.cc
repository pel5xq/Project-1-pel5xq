/* File: ast_expr.cc
 * -----------------
 * Implementation of expression node classes.
 */
#include "ast_expr.h"
#include "ast_type.h"
#include "ast_decl.h"
#include <string.h>
#include "errors.h"

IntConstant::IntConstant(yyltype loc, int val) : Expr(loc) {
    value = val;
}
void IntConstant::PrintChildren(int indentLevel) { 
    printf("%d", value);
}

DoubleConstant::DoubleConstant(yyltype loc, double val) : Expr(loc) {
    value = val;
}
void DoubleConstant::PrintChildren(int indentLevel) { 
    printf("%g", value);
}

BoolConstant::BoolConstant(yyltype loc, bool val) : Expr(loc) {
    value = val;
}
void BoolConstant::PrintChildren(int indentLevel) { 
    printf("%s", value ? "true" : "false");
}

StringConstant::StringConstant(yyltype loc, const char *val) : Expr(loc) {
    Assert(val != NULL);
    value = strdup(val);
}
void StringConstant::PrintChildren(int indentLevel) { 
    printf("%s",value);
}

Operator::Operator(yyltype loc, const char *tok) : Node(loc) {
    Assert(tok != NULL);
    strncpy(tokenString, tok, sizeof(tokenString));
}

void Operator::PrintChildren(int indentLevel) {
    printf("%s",tokenString);
}

CompoundExpr::CompoundExpr(Expr *l, Operator *o, Expr *r) 
  : Expr(Join(l->GetLocation(), r->GetLocation())) {
    Assert(l != NULL && o != NULL && r != NULL);
    (op=o)->SetParent(this);
    (left=l)->SetParent(this); 
    (right=r)->SetParent(this);
}

CompoundExpr::CompoundExpr(Operator *o, Expr *r) 
  : Expr(Join(o->GetLocation(), r->GetLocation())) {
    Assert(o != NULL && r != NULL);
    left = NULL; 
    (op=o)->SetParent(this);
    (right=r)->SetParent(this);
}

void CompoundExpr::PrintChildren(int indentLevel) {
   if (left) left->Print(indentLevel+1);
   op->Print(indentLevel+1);
   right->Print(indentLevel+1);
}
   
  
ArrayAccess::ArrayAccess(yyltype loc, Expr *b, Expr *s) : LValue(loc) {
    (base=b)->SetParent(this); 
    (subscript=s)->SetParent(this);
}

void ArrayAccess::PrintChildren(int indentLevel) {
    base->Print(indentLevel+1);
    subscript->Print(indentLevel+1, "(subscript) ");
  }
     
FieldAccess::FieldAccess(Expr *b, Identifier *f) 
  : LValue(b? Join(b->GetLocation(), f->GetLocation()) : *f->GetLocation()) {
    Assert(f != NULL); // b can be be NULL (just means no explicit base)
    base = b; 
    if (base) base->SetParent(this); 
    (field=f)->SetParent(this);
}


  void FieldAccess::PrintChildren(int indentLevel) {
    if (base) base->Print(indentLevel+1);
    field->Print(indentLevel+1);
  }

Call::Call(yyltype loc, Expr *b, Identifier *f, List<Expr*> *a) : Expr(loc)  {
    Assert(f != NULL && a != NULL); // b can be be NULL (just means no explicit base)
    base = b;
    if (base) base->SetParent(this);
    (field=f)->SetParent(this);
    (actuals=a)->SetParentAll(this);
}

 void Call::PrintChildren(int indentLevel) {
    if (base) base->Print(indentLevel+1);
    field->Print(indentLevel+1);
    actuals->PrintAll(indentLevel+1, "(actuals) ");
  }
 

NewExpr::NewExpr(yyltype loc, NamedType *c) : Expr(loc) { 
  Assert(c != NULL);
  (cType=c)->SetParent(this);
}

void NewExpr::PrintChildren(int indentLevel) {	
    cType->Print(indentLevel+1);
}

NewArrayExpr::NewArrayExpr(yyltype loc, Expr *sz, Type *et) : Expr(loc) {
    Assert(sz != NULL && et != NULL);
    (size=sz)->SetParent(this); 
    (elemType=et)->SetParent(this);
}

void NewArrayExpr::PrintChildren(int indentLevel) {
    size->Print(indentLevel+1);
    elemType->Print(indentLevel+1);
}

PostfixExpr::PostfixExpr(LValue *lv, Operator *o) : Expr(Join(lv->GetLocation(), o->GetLocation())) {
    Assert(lv != NULL && o != NULL);
    (lvalue=lv)->SetParent(this);
    (op=o)->SetParent(this);
}

void PostfixExpr::PrintChildren(int indentLevel) {
    lvalue->Print(indentLevel+1);
    op->Print(indentLevel+1);
}

//----------

void ArithmeticExpr::BuildSymbolTable(SymbolTable *table) { 
   symboltable = table;
   if(GetLeft()) GetLeft()->BuildSymbolTable(symboltable); 
   if(GetRight()) GetRight()->BuildSymbolTable(symboltable); 
}

void RelationalExpr::BuildSymbolTable(SymbolTable *table) { 
   symboltable = table;
   if(GetLeft()) GetLeft()->BuildSymbolTable(symboltable); 
   if(GetRight()) GetRight()->BuildSymbolTable(symboltable); 
}

void EqualityExpr::BuildSymbolTable(SymbolTable *table) { 
   symboltable = table;
   if(GetLeft()) GetLeft()->BuildSymbolTable(symboltable); 
   if(GetRight()) GetRight()->BuildSymbolTable(symboltable); 
}

void LogicalExpr::BuildSymbolTable(SymbolTable *table) { 
   symboltable = table;
   if(GetLeft()) GetLeft()->BuildSymbolTable(symboltable); 
   if(GetRight()) GetRight()->BuildSymbolTable(symboltable); 
}

void AssignExpr::BuildSymbolTable(SymbolTable *table) { 
   symboltable = table;
   if(GetLeft()) GetLeft()->BuildSymbolTable(symboltable); 
   if(GetRight()) GetRight()->BuildSymbolTable(symboltable); 
}

void ArrayAccess::BuildSymbolTable(SymbolTable *table) { 
   symboltable = table;
   if(base) base->BuildSymbolTable(symboltable); 
   if(subscript) subscript->BuildSymbolTable(symboltable); 
}

void FieldAccess::BuildSymbolTable(SymbolTable *table) { 
   symboltable = table;
   if(base) base->BuildSymbolTable(symboltable);  
}

void Call::BuildSymbolTable(SymbolTable *table) { 
   symboltable = table;
   if(base) base->BuildSymbolTable(symboltable); 

   int i = 0;
   for(; i < actuals->NumElements(); i++) actuals->Nth(i)->BuildSymbolTable(symboltable); 
}

void NewArrayExpr::BuildSymbolTable(SymbolTable *table) { 
   symboltable = table;
   if(size) size->BuildSymbolTable(symboltable); 
}

void PostfixExpr::BuildSymbolTable(SymbolTable *table) { 
   symboltable = table;
   if(lvalue) lvalue->BuildSymbolTable(symboltable); 
}

//----------

void ArithmeticExpr::Check(SymbolTable *rootscope) {

}

void RelationalExpr::Check(SymbolTable *rootscope) {

}

void EqualityExpr::Check(SymbolTable *rootscope) {

}

void LogicalExpr::Check(SymbolTable *rootscope) {

}

void AssignExpr::Check(SymbolTable *rootscope) {

}

void This::Check(SymbolTable *rootscope) {
   bool isFromClass = false;
   Node *parentNode = this;
   while (NULL != (parentNode = parentNode->GetParent())) {
       ClassDecl *parentDecl = dynamic_cast<ClassDecl *>(parentNode);
       if (NULL != parentDecl) {
          thisType = parentDecl->GetName();
          isFromClass = true;
          break;
       }
   }
   if (!isFromClass) {
      ReportError::Formatted(GetLocation(), "'this' is only valid within class scope");
      thisType = "error";
   }
}

void ArrayAccess::Check(SymbolTable *rootscope) {
   //Ignoring arrays for 4620
}

void FieldAccess::Check(SymbolTable *rootscope) {
   if (base) {
      base->Check(rootscope);
      const char *name = base->getTypeName();
      //if (NULL == name) printf("NULL\n");
      //else printf("%s\n", name);
      if(name == NULL) {
         //first call is a field access if == null?
         //Should this case even be reached?
         //FieldAccess *basefa = dynamic_cast<FieldAccess *>(base);         
         printf("Unexpected null type name in field access\n");
         /*ClassDecl *baseclass = dynamic_cast<ClassDecl *>(rootscope->table->Lookup(name));
         if (baseclass) {
         ... if want to bring this case back*/
         fieldType = "error";

      }
      else {
         if (strcmp(name, "error") == 0) {
            //to mask subsequent errors
            fieldType = "error";
         }
         else if(strncmp(name, "int", 3) == 0
           || strncmp(name, "double", 6) == 0
           || strncmp(name, "bool", 4) == 0
           || strncmp(name, "string", 6) == 0
           || strncmp(name, "void", 4) == 0
           || strcmp(name, "null") == 0) {
            ReportError::Formatted(field->GetLocation(), "%s has no such field '%s'", name, field->GetName());
            fieldType = "error";
         }
         else {
            //Check if array of classes instead of class
            if (NULL != strchr(name, '[')) {
               ReportError::Formatted(field->GetLocation(), "%s has no such field '%s'", name, field->GetName());
               fieldType = "error";
            }
            else {
               ClassDecl *baseclass = dynamic_cast<ClassDecl *>(rootscope->table->Lookup(name));
               if (baseclass) {
                  Decl* fielddecl = baseclass->bodytable->table->Lookup(field->GetName());
                  if (fielddecl) {
                     VarDecl *fieldvd = dynamic_cast<VarDecl *>(fielddecl);
                     if (fieldvd) {
                        fieldType = fieldvd->GetType()->GetFullName();
                     
                        bool isFromClass = false;
                        Node *parentNode = this;
                        while (NULL != (parentNode = parentNode->GetParent())) {
                           ClassDecl *parentDecl = dynamic_cast<ClassDecl *>(parentNode);
                            if (NULL != parentDecl) {
                              isFromClass = true;
                              break;
                           }
                        }
                        if (!isFromClass) {
                            ReportError::Formatted(GetLocation(), "%s field '%s' only accessible within class scope", 
                              name, field->GetName());
                            fieldType = "error"; //Mask here?
                        }
                     }
                     else {
                        FnDecl *fieldfd = dynamic_cast<FnDecl *>(fielddecl);
                        if (fieldfd) {
                           printf("Its a function?\n");
                           fieldType = fieldfd->GetType()->GetFullName();
                        }
                        else {
                           printf("Unexpected non fn/var decl %s in class %s\n", field->GetName(), name);
                           fieldType = "error";
                        }
                     }
                  }
                  else {
                     ReportError::Formatted(field->GetLocation(), "%s has no such field '%s'", name, field->GetName());
                     fieldType = "error";
                  }
               }
               else {
                  InterfaceDecl *baseint = dynamic_cast<InterfaceDecl *>(rootscope->table->Lookup(name));
                  if (baseint) { //can only be fndcl at this point

                     Decl* fielddecl = baseint->bodytable->table->Lookup(field->GetName());
                     if (fielddecl) {
                        FnDecl *fieldfd = dynamic_cast<FnDecl *>(fielddecl);
                        if (fieldfd) {
                           printf("Its a function?\n");
                           fieldType = fieldfd->GetType()->GetFullName();
                        }
                        else {
                           printf("Unexpected non fn decl %s in interface %s\n", field->GetName(), name);
                           fieldType = "error";
                        }
                     }
                     else {
                        ReportError::Formatted(field->GetLocation(), "%s has no such field '%s'", name, field->GetName());
                        fieldType = "error";
                     }

                  }
                  else {
                     printf("Unexpected nonexistent class/interface (from call) %s\n", name);
                     fieldType = "error";
                  }
               }
            }
         }
      }
   }
   else {
      Decl* fielddecl = symboltable->Find(field->GetName()); 
      if (fielddecl) {

         VarDecl *fieldvd = dynamic_cast<VarDecl *>(fielddecl);
         if (fieldvd) {
            fieldType = fieldvd->GetType()->GetFullName();            
         }
         else {
            FnDecl *fieldfd = dynamic_cast<FnDecl *>(fielddecl);
            if (fieldfd) {
               printf("Its a function?\n");
               fieldType = fieldfd->GetType()->GetFullName();
            }
            else {
               printf("Unexpected non fn/var decl %s\n", field->GetName());
               fieldType = "error";
            }
         }
         
      }
      else {
         ReportError::Formatted(field->GetLocation(), "No declaration found for variable '%s'", field->GetName());
         fieldType = "error";
      }
   }
}

void Call::Check(SymbolTable *rootscope) {
   //Deal with base/field as above
   FnDecl *actualFD = NULL;
   if (base) {
      base->Check(rootscope);
      const char *name = base->getTypeName();
      //if (NULL == name) printf("NULL\n");
      //else printf("%s\n", name);
      if(name == NULL) {
         //Should this case even be reached?
         //FieldAccess *basefa = dynamic_cast<FieldAccess *>(base);         
         printf("Unexpected null type name in call\n");
         /*ClassDecl *baseclass = dynamic_cast<ClassDecl *>(rootscope->table->Lookup(name));
         if (baseclass) {
         ... if want to bring this case back*/
         fieldType = "error";

      }
      else {
         if (strcmp(name, "error") == 0) {
            //to mask subsequent errors
            fieldType = "error";
         }
         else if(strncmp(name, "int", 3) == 0
           || strncmp(name, "double", 6) == 0
           || strncmp(name, "bool", 4) == 0
           || strncmp(name, "string", 6) == 0
           || strncmp(name, "void", 4) == 0
           || strcmp(name, "null") == 0) {
            ReportError::Formatted(field->GetLocation(), "%s has no such field '%s'", name, field->GetName());
            fieldType = "error";
           //For 4620, ignoring array length case here
         }
         else {
            //Check if array of classes instead of class
            if (NULL != strchr(name, '[')) {
               ReportError::Formatted(field->GetLocation(), "%s has no such field '%s'", name, field->GetName());
               fieldType = "error";
            }
            else {
               ClassDecl *baseclass = dynamic_cast<ClassDecl *>(rootscope->table->Lookup(name));
               if (baseclass) {
                  Decl* fielddecl = baseclass->bodytable->table->Lookup(field->GetName());
                  if (fielddecl) {
                     VarDecl *fieldvd = dynamic_cast<VarDecl *>(fielddecl);
                     if (fieldvd) {
                        printf("Its a variable?\n");
                        fieldType = fieldvd->GetType()->GetFullName();
                     
                        bool isFromClass = false;
                        Node *parentNode = this;
                        while (NULL != (parentNode = parentNode->GetParent())) {
                           ClassDecl *parentDecl = dynamic_cast<ClassDecl *>(parentNode);
                            if (NULL != parentDecl) {
                              isFromClass = true;
                              break;
                           }
                        }
                        if (!isFromClass) {
                            ReportError::Formatted(GetLocation(), "%s field '%s' only accessible within class scope", 
                              name, field->GetName());
                            fieldType = "error"; //Mask here?
                        }
                     }
                     else {
                        FnDecl *fieldfd = dynamic_cast<FnDecl *>(fielddecl);
                        if (fieldfd) {
                           fieldType = fieldfd->GetType()->GetFullName();
                           actualFD = fieldfd;
                        }
                        else {
                           printf("Unexpected non fn/var decl %s in class %s\n", field->GetName(), name);
                           fieldType = "error";
                        }
                     }
                  }
                  else {
                     ReportError::Formatted(field->GetLocation(), "%s has no such field '%s'", name, field->GetName());
                     fieldType = "error";
                  }
               }
               else {
                  InterfaceDecl *baseint = dynamic_cast<InterfaceDecl *>(rootscope->table->Lookup(name));
                  if (baseint) { //can only be fndcl at this point

                     Decl* fielddecl = baseint->bodytable->table->Lookup(field->GetName());
                     if (fielddecl) {
                        FnDecl *fieldfd = dynamic_cast<FnDecl *>(fielddecl);
                        if (fieldfd) {
                           fieldType = fieldfd->GetType()->GetFullName();
                           actualFD = fieldfd;
                        }
                        else {
                           printf("Unexpected non fn decl %s in interface %s\n", field->GetName(), name);
                           fieldType = "error";
                        }
                     }
                     else {
                        ReportError::Formatted(field->GetLocation(), "%s has no such field '%s'", name, field->GetName());
                        fieldType = "error";
                     }

                  }
                  else {
                     printf("Unexpected nonexistent class/interface (from call) %s\n", name);
                     fieldType = "error";
                  }
               }
            }
         }
      }
   }
   else {
      Decl* fielddecl = symboltable->Find(field->GetName()); 
      if (fielddecl) {

         VarDecl *fieldvd = dynamic_cast<VarDecl *>(fielddecl);
         if (fieldvd) {
            printf("Its a variable?\n");
            fieldType = fieldvd->GetType()->GetFullName();            
         }
         else {
            FnDecl *fieldfd = dynamic_cast<FnDecl *>(fielddecl);
            if (fieldfd) {
               fieldType = fieldfd->GetType()->GetFullName();
               actualFD = fieldfd;
            }
            else {
               printf("Unexpected non fn/var decl %s\n", field->GetName());
               fieldType = "error";
            }
         }
         
      }
      else {
         ReportError::Formatted(field->GetLocation(), "No declaration found for function '%s'", field->GetName());
         fieldType = "error";
      }
   }

   //Deal with actuals
   if (actualFD) {
      if (!actuals) printf("Unexpected NULL actuals\n");
      if (actualFD->GetFormals()->NumElements() != actuals->NumElements()) {
         ReportError::Formatted(field->GetLocation(), "Function '%s' expects %d arguments but %d given", 
	    actualFD->GetName(), actualFD->GetFormals()->NumElements(), actuals->NumElements());
      }
      else {
         int i = 0;
         for (; i < actuals->NumElements(); i++) {
            Expr *actual = actuals->Nth(i);
            actual->Check(rootscope);
            if( actualFD->GetFormals()->Nth(i)->GetType()->comparePolymorph(actual->getTypeName(), rootscope) != 0) {
               ReportError::Formatted(actual->GetLocation(), "Incompatible argument %d: %s given, %s expected", 
	          i+1, actual->getTypeName(), actualFD->GetFormals()->Nth(i)->GetType()->GetFullName());
            }
         }
      }
   }
}

void NewExpr::Check(SymbolTable *rootscope) {

}

void NewArrayExpr::Check(SymbolTable *rootscope) {
   //Ignoring arrays for 4620
}

void ReadIntegerExpr::Check(SymbolTable *rootscope) {

}

void ReadLineExpr::Check(SymbolTable *rootscope) {

}

void PostfixExpr::Check(SymbolTable *rootscope) {

}

//------------------------------------
//For all the getTypeName methods,
//Assume already checked and return
//the anticipated or leftmost type

const char* ArithmeticExpr::getTypeName() {
   return left->getTypeName();
}

const char* RelationalExpr::getTypeName() {
   return "boolean";
}

const char* EqualityExpr::getTypeName() {
   return "boolean";
}

const char* LogicalExpr::getTypeName() {
   return "boolean";
}

const char* AssignExpr::getTypeName() {
   return left->getTypeName();
}

const char* This::getTypeName() {
   return thisType;
}

const char* ArrayAccess::getTypeName() {
   return base->getTypeName(); //Ignoring arrays for 4620
}

const char* FieldAccess::getTypeName() {
   return fieldType;
}

const char* Call::getTypeName() {
   return fieldType;
}

const char* NewExpr::getTypeName() {
   return NULL;
}

const char* NewArrayExpr::getTypeName() {
   return NULL;
}

const char* PostfixExpr::getTypeName() {
   return NULL;
}

