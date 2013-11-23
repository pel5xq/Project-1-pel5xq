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
   if (left) { 
      left->Check(rootscope);
      right->Check(rootscope);
      const char* ltype = left->getTypeName();
      const char* rtype = right->getTypeName();
      if (strcmp(ltype, "error") == 0 || strcmp(rtype, "error") == 0) {} //Mask error
      else if (strcmp(ltype, rtype) != 0
          || !(strcmp(ltype, "int") == 0 || strcmp(ltype, "double") == 0)) {
         //ReportError::Formatted(op->GetLocation(), "Incompatible operands: %s %s %s", ltype, op->GetTokenString(), rtype);
      }
   }
   else { //Unary
      right->Check(rootscope);
      const char* rtype = right->getTypeName();
      if (strcmp(rtype, "error") == 0) {} //Mask error
      else if (!(strcmp(rtype, "int") == 0 
            || strcmp(rtype, "double") == 0)) {
         //ReportError::Formatted(op->GetLocation(), "Incompatible operand: %s %s", op->GetTokenString(), rtype);
      }
   }
}

void RelationalExpr::Check(SymbolTable *rootscope) {
   left->Check(rootscope);
   right->Check(rootscope);
   const char* ltype = left->getTypeName();
   const char* rtype = right->getTypeName();
   if (strcmp(ltype, "error") == 0 || strcmp(rtype, "error") == 0) {} //Mask error
   else if (strcmp(ltype, rtype) != 0
       || !(strcmp(ltype, "int") == 0 || strcmp(ltype, "double") == 0)) {
      //ReportError::Formatted(op->GetLocation(), "Incompatible operands: %s %s %s", ltype, op->GetTokenString(), rtype);
   }
}

bool Expr::equalArrayDimensions(const char *t1, const char *t2) {
   if (NULL == strchr(t1, '[') && NULL == strchr(t2, '[')) return true;
   if (!( NULL != strchr(t1, '[') && NULL != strchr(t2, '[') ) ) return false;
   /*char* new1 = new char[strlen(t1)-2];
   memcpy(new1, t1, strlen(t1)-3);
   new1[strlen(t1)-3] = '\0';
   char* new2 = new char[strlen(t2)-2];
   memcpy(new2, t2, strlen(t2)-3);
   new2[strlen(t2)-3] = '\0';*/

   int newlength = strrchr(t1, '[')-t1;
   char * new1 = new char[newlength+1];
   memcpy(new1, t1, newlength);
   new1[newlength] = '\0';
   int newlength2 = strrchr(t2, '[')-t2;
   char * new2 = new char[newlength2+1];
   memcpy(new2, t2, newlength2);
   new2[newlength2] = '\0';

   return equalArrayDimensions(new1, new2);
}

const char * Expr::stripAway(const char *t1) {
   if (NULL == strchr(t1, '[')) return t1;

   int newlength = strrchr(t1, '[')-t1;
   char * new1 = new char[newlength+1];
   memcpy(new1, t1, newlength);
   new1[newlength] = '\0';

   //char* new1 = new char[strlen(t1)-2];
   //memcpy(new1, t1, strlen(t1)-3);
   //new1[strlen(t1)-3] = '\0';
   return stripAway(new1);
}

void EqualityExpr::Check(SymbolTable *rootscope) {
   left->Check(rootscope);
   right->Check(rootscope);
   const char* ltype = left->getTypeName();
   const char* rtype = right->getTypeName();
   if (strcmp(ltype, "error") == 0 || strcmp(rtype, "error") == 0) {} //Mask error
   else if(strncmp(ltype, "int", 3) == 0
      || strncmp(ltype, "double", 6) == 0
      || strncmp(ltype, "bool", 4) == 0
      || strncmp(ltype, "string", 6) == 0
      || strncmp(ltype, "void", 4) == 0

      || strncmp(rtype, "int", 3) == 0
      || strncmp(rtype, "double", 6) == 0
      || strncmp(rtype, "bool", 4) == 0
      || strncmp(rtype, "string", 6) == 0
      || strncmp(rtype, "void", 4) == 0) {

      if (strcmp(ltype, rtype) != 0) {
         //ReportError::Formatted(op->GetLocation(), "Incompatible operands: %s %s %s", ltype, op->GetTokenString(), rtype);
      }

   }
   else {
      //Need to change to remove array subtyping polymorphism?

      //Deal with possible different numbers of [][]
      //assuming null == object[][] not valid
      if (!equalArrayDimensions(ltype, rtype)) {
         //ReportError::Formatted(op->GetLocation(), "Incompatible operands: %s %s %s", ltype, op->GetTokenString(), rtype);
      }
      else {
         const char *coreLType = stripAway(ltype);
         const char *coreRType = stripAway(rtype);
         
         if (strcmp(coreLType, coreRType) == 0
             || strcmp(coreLType, "null") == 0
             || strcmp(coreRType, "null") == 0) {
            //Do nothing
         }
         else {
           Decl* lDecl = rootscope->table->Lookup(coreLType);
           Decl* rDecl = rootscope->table->Lookup(coreRType);
	   if (lDecl && rDecl) {
              if (!(lDecl->isSubclassOf(coreRType) == 1 || rDecl->isSubclassOf(coreLType) == 1)) {
                 //ReportError::Formatted(op->GetLocation(), "Incompatible operands: %s %s %s", ltype, op->GetTokenString(), rtype);
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

void LogicalExpr::Check(SymbolTable *rootscope) {
   if (left) { 
      left->Check(rootscope);
      right->Check(rootscope);
      const char* ltype = left->getTypeName();
      const char* rtype = right->getTypeName();
      if (strcmp(ltype, "error") == 0 || strcmp(rtype, "error") == 0) {} //Mask error
      else if (strcmp(ltype, rtype) != 0
          || !(strcmp(ltype, "bool") == 0)) {
         //ReportError::Formatted(op->GetLocation(), "Incompatible operands: %s %s %s", ltype, op->GetTokenString(), rtype);
      }
   }
   else { //Unary
      right->Check(rootscope);
      const char* rtype = right->getTypeName();
      if (strcmp(rtype, "error") == 0) {} //Mask error
      else if (!(strcmp(rtype, "bool") == 0)) {
         //ReportError::Formatted(op->GetLocation(), "Incompatible operand: %s %s", op->GetTokenString(), rtype);
      }
   }
}

void AssignExpr::Check(SymbolTable *rootscope) {
   //Ignoring problems with array access types for 4620?
   left->Check(rootscope);
   right->Check(rootscope);
   const char* ltype = left->getTypeName();
   const char* rtype = right->getTypeName();

   if (strcmp(ltype, "error") == 0 || strcmp(rtype, "error") == 0) {} //Mask error
   else if(strncmp(ltype, "int", 3) == 0
      || strncmp(ltype, "double", 6) == 0
      || strncmp(ltype, "bool", 4) == 0
      || strncmp(ltype, "string", 6) == 0
      || strncmp(ltype, "void", 4) == 0

      || strncmp(rtype, "int", 3) == 0
      || strncmp(rtype, "double", 6) == 0
      || strncmp(rtype, "bool", 4) == 0
      || strncmp(rtype, "string", 6) == 0
      || strncmp(rtype, "void", 4) == 0) {

      if (strcmp(ltype, rtype) != 0) {
         //ReportError::Formatted(op->GetLocation(), "Incompatible operands: %s %s %s", ltype, op->GetTokenString(), rtype);
      }

   }
   else {
      //Need to change to remove array subtyping polymorphism?

      //Deal with possible different numbers of [][]
      //assuming null == object[][] not valid
      if (!equalArrayDimensions(ltype, rtype)) {
         //ReportError::Formatted(op->GetLocation(), "Incompatible operands: %s %s %s", ltype, op->GetTokenString(), rtype);
      }
      else {
         const char *coreLType = stripAway(ltype);
         const char *coreRType = stripAway(rtype);
         
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
                 //ReportError::Formatted(op->GetLocation(), "Incompatible operands: %s %s %s", ltype, op->GetTokenString(), rtype);
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
      //ReportError::Formatted(GetLocation(), "'this' is only valid within class scope");
      thisType = "error";
   }
}

void ArrayAccess::Check(SymbolTable *rootscope) {
   if (base) {
      base->Check(rootscope);
      if (NULL == strchr(base->getTypeName(), '[')) {
         //ReportError::Formatted(base->GetLocation(), "[] can only be applied to arrays");
      }
   }
   if (subscript) {
      subscript->Check(rootscope);
      if (strcmp(subscript->getTypeName(), "int") != 0) {
         //ReportError::Formatted(subscript->GetLocation(), "Array subscript must be an integer");
      }
   }
   //and if subscript was integer
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
         //printf("Unexpected null type name in field access\n");
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
            //ReportError::Formatted(field->GetLocation(), "%s has no such field '%s'", name, field->GetName());
            fieldType = "error";
         }
         else {
            //Check if array of classes instead of class
            if (NULL != strchr(name, '[')) {
               //ReportError::Formatted(field->GetLocation(), "%s has no such field '%s'", name, field->GetName());
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
                            //ReportError::Formatted(GetLocation(), "%s field '%s' only accessible within class scope", 
                              //name, field->GetName());
                            fieldType = "error"; //Mask here?
                        }
                     }
                     else {
                        FnDecl *fieldfd = dynamic_cast<FnDecl *>(fielddecl);
                        if (fieldfd) {
                           //Should be a variable
                           //printf("Its a function?\n");
                           //fieldType = fieldfd->GetType()->GetFullName();
                           //ReportError::Formatted(field->GetLocation(), "No declaration found for variable '%s'", field->GetName());
                           fieldType = "error";
                        }
                        else {
                           //printf("Unexpected non fn/var decl %s in class %s\n", field->GetName(), name);
                           fieldType = "error";
                        }
                     }
                  }
                  else {
                     //ReportError::Formatted(field->GetLocation(), "%s has no such field '%s'", name, field->GetName());
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
                           //It should be a variable
                           //printf("Its a function?\n");
                           //fieldType = fieldfd->GetType()->GetFullName();
                           //ReportError::Formatted(field->GetLocation(), "No declaration found for variable '%s'", field->GetName());
                           fieldType = "error";
                        }
                        else {
                           //printf("Unexpected non fn decl %s in interface %s\n", field->GetName(), name);
                           fieldType = "error";
                        }
                     }
                     else {
                        //ReportError::Formatted(field->GetLocation(), "%s has no such field '%s'", name, field->GetName());
                        fieldType = "error";
                     }

                  }
                  else {
                     //printf("Unexpected nonexistent class/interface (from call) %s\n", name);
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
               //Should be a variable
               //printf("Its a function?\n");
               //fieldType = fieldfd->GetType()->GetFullName();
               //ReportError::Formatted(field->GetLocation(), "No declaration found for variable '%s'", field->GetName());
               fieldType = "error";
            }
            else {
               //printf("Unexpected non fn/var decl %s\n", field->GetName());
               fieldType = "error";
            }
         }
         
      }
      else {
         //ReportError::Formatted(field->GetLocation(), "No declaration found for variable '%s'", field->GetName());
         fieldType = "error";
      }
   }
}

void Call::Check(SymbolTable *rootscope) {
   //Check actuals first
   int z = 0;
   for (; z < actuals->NumElements(); z++) {
      actuals->Nth(z)->Check(rootscope);
   }

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
         //printf("Unexpected null type name in call\n");
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
         else if (NULL != strchr(name, '[') && strcmp(field->GetName(), "length") == 0) {
            fieldType = "int";
         }
         else if(strncmp(name, "int", 3) == 0
           || strncmp(name, "double", 6) == 0
           || strncmp(name, "bool", 4) == 0
           || strncmp(name, "string", 6) == 0
           || strncmp(name, "void", 4) == 0
           || strcmp(name, "null") == 0) {
           
               //ReportError::Formatted(field->GetLocation(), "%s has no such field '%s'", name, field->GetName());
               fieldType = "error"; 
            
         }
         else {
            //Check if array of classes instead of class
            if (NULL != strchr(name, '[') ) {//&& !strcmp(field->GetName(), "length")) {
               //ReportError::Formatted(field->GetLocation(), "%s has no such field '%s'", name, field->GetName());
               fieldType = "error";
            }
            else {
               ClassDecl *baseclass = dynamic_cast<ClassDecl *>(rootscope->table->Lookup(name));
               if (baseclass) {
                  Decl* fielddecl = baseclass->bodytable->table->Lookup(field->GetName());
                  if (fielddecl) {
                     VarDecl *fieldvd = dynamic_cast<VarDecl *>(fielddecl);
                     if (fieldvd) {
                        //Should be a function
                        //printf("Its a variable?\n");
                        //fieldType = fieldvd->GetType()->GetFullName();

                        //ReportError::Formatted(field->GetLocation(), "No declaration found for function '%s'", field->GetName());
                        fieldType = "error"; 
                     
                        /*bool isFromClass = false;
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
                        }*/
                     }
                     else {
                        FnDecl *fieldfd = dynamic_cast<FnDecl *>(fielddecl);
                        if (fieldfd) {
                           fieldType = fieldfd->GetType()->GetFullName();
                           actualFD = fieldfd;
                        }
                        else {
                           //printf("Unexpected non fn/var decl %s in class %s\n", field->GetName(), name);
                           fieldType = "error";
                        }
                     }
                  }
                  else {
                     //ReportError::Formatted(field->GetLocation(), "%s has no such field '%s'", name, field->GetName());
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
                           //printf("Unexpected non fn decl %s in interface %s\n", field->GetName(), name);
                           fieldType = "error";
                        }
                     }
                     else {
                        //ReportError::Formatted(field->GetLocation(), "%s has no such field '%s'", name, field->GetName());
                        fieldType = "error";
                     }

                  }
                  else {
                     //printf("Unexpected nonexistent class/interface (from call) %s\n", name);
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
            //Should be a function
            //printf("Its a variable?\n");
            //fieldType = fieldvd->GetType()->GetFullName(); 
            //ReportError::Formatted(field->GetLocation(), "No declaration found for function '%s'", field->GetName());
            fieldType = "error";           
         }
         else {
            FnDecl *fieldfd = dynamic_cast<FnDecl *>(fielddecl);
            if (fieldfd) {
               fieldType = fieldfd->GetType()->GetFullName();
               actualFD = fieldfd;
            }
            else {
               //printf("Unexpected non fn/var decl %s\n", field->GetName());
               fieldType = "error";
            }
         }
         
      }
      else {
         //ReportError::Formatted(field->GetLocation(), "No declaration found for function '%s'", field->GetName());
         fieldType = "error";
      }
   }

   //Deal with actuals
   if (actualFD) {
      if (!actuals) ;//printf("Unexpected NULL actuals\n");
      if (actualFD->GetFormals()->NumElements() != actuals->NumElements()) {
         //ReportError::Formatted(field->GetLocation(), "Function '%s' expects %d arguments but %d given", 
	   // actualFD->GetName(), actualFD->GetFormals()->NumElements(), actuals->NumElements());
      }
      else {
         int i = 0;
         for (; i < actuals->NumElements(); i++) {
            Expr *actual = actuals->Nth(i);
            //actual->Check(rootscope); // Checked first instead
            if( actualFD->GetFormals()->Nth(i)->GetType()->comparePolymorph(actual->getTypeName(), rootscope) != 0) {
               //ReportError::Formatted(actual->GetLocation(), "Incompatible argument %d: %s given, %s expected", 
	         // i+1, actual->getTypeName(), actualFD->GetFormals()->Nth(i)->GetType()->GetFullName());
            }
         }
      }
   }
}

void NewExpr::Check(SymbolTable *rootscope) {
   //only class is valid here
   //ignoring case New(object[]) -- not even valid syntax?
   ClassDecl* newclass = dynamic_cast<ClassDecl *>(rootscope->table->Lookup(cType->GetFullName()));
   if (NULL == newclass) {
      //ReportError::Formatted(cType->GetLocation(), "No declaration found for class '%s'", cType->GetFullName());
   }
}

void NewArrayExpr::Check(SymbolTable *rootscope) {
   if (size) size->Check(rootscope);
   
   if (strcmp(size->getTypeName(), "int") != 0) {
      //ReportError::Formatted(size->GetLocation(), "Size for NewArray must be an integer");
   }

   Decl *newdecl = rootscope->table->Lookup(elemType->GetCoreName());
   const char * name = elemType->GetFullName();
   ClassDecl* newclass = dynamic_cast<ClassDecl *>(newdecl);
   InterfaceDecl* newinter = dynamic_cast<InterfaceDecl *>(newdecl);
   if (! (NULL != newclass || NULL != newinter || 
           strncmp(name, "int", 3) == 0
           || strncmp(name, "double", 6) == 0
           || strncmp(name, "bool", 4) == 0
           || strncmp(name, "string", 6) == 0)) {
      //ReportError::Formatted(elemType->GetLocation(), "No declaration found for type '%s'", elemType->GetFullName());
   }
}

void ReadIntegerExpr::Check(SymbolTable *rootscope) {
   //Nothing needed?
}

void ReadLineExpr::Check(SymbolTable *rootscope) {
   //Nothing needed?
}

void PostfixExpr::Check(SymbolTable *rootscope) {
   //assuming only works on int or double
   if (lvalue) lvalue->Check(rootscope);
   const char* ltype = lvalue->getTypeName();
   if (strcmp(ltype, "error") == 0) {} //Mask error
   else if (!(strcmp(ltype, "int") == 0 || strcmp(ltype, "double") == 0)) {
      //ReportError::Formatted(op->GetLocation(), "Incompatible operand: %s %s", ltype, op->GetTokenString());
   }
}

//------------------------------------
//For all the getTypeName methods,
//Assume already checked and return
//the anticipated type

const char* ArithmeticExpr::getTypeName() {
   return right->getTypeName();
}

const char* RelationalExpr::getTypeName() {
   return "bool";
}

const char* EqualityExpr::getTypeName() {
   return "bool";
}

const char* LogicalExpr::getTypeName() {
   return "bool";
}

const char* AssignExpr::getTypeName() {
   return left->getTypeName();
}

const char* This::getTypeName() {
   return thisType;
}

const char* ArrayAccess::getTypeName() {
   if (NULL == strchr(base->getTypeName(), '[')) {
      return "error";
   }
   const char * other = base->getTypeName();
   int newlength = strrchr(other, '[')-other;
   char * coreOtherName = new char[newlength+1];
   memcpy(coreOtherName, other, newlength);
   coreOtherName[newlength] = '\0';
   return coreOtherName;
}

const char* FieldAccess::getTypeName() {
   return fieldType;
}

const char* Call::getTypeName() {
   return fieldType;
}

const char* NewExpr::getTypeName() {
   return cType->GetFullName();
}

const char* NewArrayExpr::getTypeName() {
   const char *typeval = elemType->GetFullName(); 
   char *retVal = new char[strlen(typeval)+3]; 
   memcpy(retVal, typeval, strlen(typeval));
   retVal[strlen(typeval)] = '[';
   retVal[strlen(typeval)+1] = ']';
   retVal[strlen(typeval)+2] = '\0';
   return retVal;
}

const char* PostfixExpr::getTypeName() {
   return lvalue->getTypeName();
}

//----------------------------------------

void Expr::Emit(CodeGenerator *codegen) {
   Stmt::Emit(codegen);
}

void EmptyExpr::Emit(CodeGenerator *codegen) {
   Expr::Emit(codegen);
}

void IntConstant::Emit(CodeGenerator *codegen) {
   Expr::Emit(codegen);
   codeLoc = codegen->GenLoadConstant(value);
}

void DoubleConstant::Emit(CodeGenerator *codegen) {
   Expr::Emit(codegen);
   //codeLoc = codegen->GenLoadConstant(value);
   //Not implemented in pp5
}

void BoolConstant::Emit(CodeGenerator *codegen) {
   Expr::Emit(codegen);
   if (value) codeLoc = codegen->GenLoadConstant(1);
   else codeLoc = codegen->GenLoadConstant(0);
}

void StringConstant::Emit(CodeGenerator *codegen) {
   Expr::Emit(codegen);
   codeLoc = codegen->GenLoadConstant(value);
}

void NullConstant::Emit(CodeGenerator *codegen) {
   Expr::Emit(codegen);
   codeLoc = codegen->GenLoadConstant(0);
}

void Operator::Emit(CodeGenerator *codegen) {
   Node::Emit(codegen);
}

void CompoundExpr::Emit(CodeGenerator *codegen) {
   Expr::Emit(codegen);
   if (left) left->Emit(codegen);
   if (right) right->Emit(codegen);
}

void ArithmeticExpr::Emit(CodeGenerator *codegen) {
   CompoundExpr::Emit(codegen);
}

void RelationalExpr::Emit(CodeGenerator *codegen) {
   CompoundExpr::Emit(codegen);
}

void EqualityExpr::Emit(CodeGenerator *codegen) {
   CompoundExpr::Emit(codegen);
}

void LogicalExpr::Emit(CodeGenerator *codegen) {
   CompoundExpr::Emit(codegen);
}

void AssignExpr::Emit(CodeGenerator *codegen) {
   CompoundExpr::Emit(codegen);
   Assert(left->codeLoc != NULL);
   Assert(right->codeLoc != NULL);
   codegen->GenAssign(left->codeLoc, right->codeLoc);
}

void LValue::Emit(CodeGenerator *codegen) {
   Expr::Emit(codegen);
}

void This::Emit(CodeGenerator *codegen) {
   Expr::Emit(codegen);
}

void ArrayAccess::Emit(CodeGenerator *codegen) {
   LValue::Emit(codegen);
}

void FieldAccess::Emit(CodeGenerator *codegen) {
   LValue::Emit(codegen);
   if (base) {
      
   }
   else {
      //Lookup what has already been declared in scope
      codeLoc = symboltable->Find(field->GetName())->codeLoc;
   }
}

void Call::Emit(CodeGenerator *codegen) { //make sure to handle array.length()
   Expr::Emit(codegen);
}

void NewExpr::Emit(CodeGenerator *codegen) {
   Expr::Emit(codegen);
}

void NewArrayExpr::Emit(CodeGenerator *codegen) {
   Expr::Emit(codegen);
}

void ReadIntegerExpr::Emit(CodeGenerator *codegen) {
   Expr::Emit(codegen);
}

void ReadLineExpr::Emit(CodeGenerator *codegen) {
   Expr::Emit(codegen);
}

void PostfixExpr::Emit(CodeGenerator *codegen) {
   Expr::Emit(codegen);
}
