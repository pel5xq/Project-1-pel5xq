/* File: ast_decl.cc
 * -----------------
 * Implementation of Decl node classes.
 */
#include "ast_decl.h"
#include "ast_type.h"
#include "ast_stmt.h"
#include "utility.h"
#include "symboltable.h"
#include "errors.h"
#include <string.h>
        
           
Decl::Decl(Identifier *n) : Node(*n->GetLocation()) {
    Assert(n != NULL);
    (id=n)->SetParent(this); 
}


VarDecl::VarDecl(Identifier *n, Type *t) : Decl(n) {
    Assert(n != NULL && t != NULL);
    (type=t)->SetParent(this);
}
  
void VarDecl::PrintChildren(int indentLevel) { 
   type->Print(indentLevel+1);
   id->Print(indentLevel+1);
}

ClassDecl::ClassDecl(Identifier *n, NamedType *ex, List<NamedType*> *imp, List<Decl*> *m) : Decl(n) {
    // extends can be NULL, impl & mem may be empty lists but cannot be NULL
    Assert(n != NULL && imp != NULL && m != NULL);     
    extends = ex;
    if (extends) extends->SetParent(this);
    (implements=imp)->SetParentAll(this);
    (members=m)->SetParentAll(this);
}

void ClassDecl::PrintChildren(int indentLevel) {
    id->Print(indentLevel+1);
    if (extends) extends->Print(indentLevel+1, "(extends) ");
    implements->PrintAll(indentLevel+1, "(implements) ");
    members->PrintAll(indentLevel+1);
}


InterfaceDecl::InterfaceDecl(Identifier *n, List<Decl*> *m) : Decl(n) {
    Assert(n != NULL && m != NULL);
    (members=m)->SetParentAll(this);
}

void InterfaceDecl::PrintChildren(int indentLevel) {
    id->Print(indentLevel+1);
    members->PrintAll(indentLevel+1);
}
	
FnDecl::FnDecl(Identifier *n, Type *r, List<VarDecl*> *d) : Decl(n) {
    Assert(n != NULL && r!= NULL && d != NULL);
    (returnType=r)->SetParent(this);
    (formals=d)->SetParentAll(this);
    body = NULL;
}

void FnDecl::SetFunctionBody(Stmt *b) { 
    (body=b)->SetParent(this);
}

void FnDecl::PrintChildren(int indentLevel) {
    returnType->Print(indentLevel+1, "(return type) ");
    id->Print(indentLevel+1);
    formals->PrintAll(indentLevel+1, "(formals) ");
    if (body) body->Print(indentLevel+1, "(body) ");
}

//-----------------------------

void VarDecl::BuildSymbolTable(SymbolTable *table) {
   symboltable = table;
   if (NULL != table->table->Lookup(GetName())) {
      //ReportError::Formatted(GetLocation(), "Declaration of '%s' here conflicts with declaration on line %d", GetName(), 
	//		table->table->Lookup(GetName())->GetLocation()->first_line);
   } //Deal with error by using the new declaration instead
   table->table->Enter(GetName(), this);
}

void ClassDecl::BuildSymbolTable(SymbolTable *table) {
   symboltable = table;
   if (NULL != table->table->Lookup(GetName())) {
      //ReportError::Formatted(GetLocation(), "Declaration of '%s' here conflicts with declaration on line %d", GetName(), 
	//		table->table->Lookup(GetName())->GetLocation()->first_line);
   } //Deal with error by using the new declaration instead
   table->table->Enter(GetName(), this);

   //Save extension/implementation for second pass
   
   bodytable = new SymbolTable(symboltable);
   int i = 0;
   for (;i<members->NumElements();i++) {
      members->Nth(i)->BuildSymbolTable(bodytable);
   }
}

void InterfaceDecl::BuildSymbolTable(SymbolTable *table) {
   symboltable = table;
   if (NULL != table->table->Lookup(GetName())) {
      //ReportError::Formatted(GetLocation(), "Declaration of '%s' here conflicts with declaration on line %d", GetName(), 
	//		table->table->Lookup(GetName())->GetLocation()->first_line);
   } //Deal with error by using the new declaration instead
   table->table->Enter(GetName(), this);

   bodytable = new SymbolTable(symboltable);
   int i = 0;
   for (;i<members->NumElements();i++) {
      members->Nth(i)->BuildSymbolTable(bodytable);
   }
}

void FnDecl::BuildSymbolTable(SymbolTable *table) {
   symboltable = table;

   if (NULL != table->table->Lookup(GetName())) {
      //ReportError::Formatted(GetLocation(), "Declaration of '%s' here conflicts with declaration on line %d", GetName(), 
	//		table->table->Lookup(GetName())->GetLocation()->first_line);
   } //Deal with error by accepting the new declaration instead
   table->table->Enter(GetName(), this);

   parameterstable = new SymbolTable(symboltable);
   int i = 0;
   for (;i<formals->NumElements();i++) {
      formals->Nth(i)->BuildSymbolTable(parameterstable);
   }

   if (body) body->BuildSymbolTable(parameterstable);
}

//-----------

void ClassDecl::ValidateInterfaces() {
   int i = 0;
   for(;i<implements->NumElements();i++) {
      const char *name = implements->Nth(i)->GetName();
      Decl* interface = symboltable->table->Lookup(name);
      if (NULL == interface) {
         //ReportError::Formatted(implements->Nth(i)->GetLocation(), "No declaration found for interface '%s'", name);
         continue;
      }
      InterfaceDecl *intdecl = dynamic_cast<InterfaceDecl *>(interface);
      if (NULL == intdecl) {
         //ReportError::Formatted(implements->Nth(i)->GetLocation(), "No declaration found for interface '%s'", name);
         continue;
      }
      if (intdecl->bodytable) {
        Iterator<Decl*> iter = intdecl->bodytable->table->GetIterator();
        Decl *decl;
        bool errStated = false;
        while ((decl = iter.GetNextValue()) != NULL) {
           Decl *classfn = bodytable->table->Lookup(decl->GetName());
           if (NULL == classfn) {
              //if (!errStated) ReportError::Formatted(implements->Nth(i)->GetLocation(), 
                //    "Class '%s' does not implement entire interface '%s'", 
		//GetName(), intdecl->GetName());
              //errStated = true;
              continue;
           } //If definition exists, check that it is a method and has right parameters 
           FnDecl *classfunct = dynamic_cast<FnDecl *>(classfn);
           if (NULL == classfunct) { //TODO Should the error be interface definition or conflicting declaration?
              //if (!errStated) ReportError::Formatted(implements->Nth(i)->GetLocation(), 
                //    "Class '%s' does not implement entire interface '%s'", 
		//GetName(), intdecl->GetName());
              //errStated = true;
              continue;
           }
           FnDecl *interfunct = dynamic_cast<FnDecl *>(decl); //From an interface, must br FnDecl
           if (classfunct->GetFormals()->NumElements() != interfunct->GetFormals()->NumElements()
		|| classfunct->GetType()->compare(interfunct->GetType()) != 0) {
              //ReportError::Formatted(classfunct->GetLocation(), "Method '%s' must match inherited type signature", 
		//interfunct->GetName());
              continue;
	   }
           int j = 0;
           bool mthderrStated = false;
           for (; j< classfunct->GetFormals()->NumElements(); j++) {
              if (classfunct->GetFormals()->Nth(j)->GetType()->compare(interfunct->GetFormals()->Nth(j)->GetType()) != 0) {
                 //if (!mthderrStated) ReportError::Formatted(classfunct->GetLocation(), 
		   //     "Method '%s' must match inherited type signature", interfunct->GetName());
                 //mthderrStated = true;
              }
           }
        }

      }
   }
}

void ClassDecl::ValidateExtensions(SymbolTable *covered) {
   if (covered->table->Lookup(GetName()) != NULL) return;
   bool doneAtThisLevel = false;
   ClassDecl *parentClass;
   if (extends == NULL) doneAtThisLevel = true;
   else {
      Decl *parentDecl = symboltable->table->Lookup(extends->GetName());
      if (NULL == parentDecl) {
         //ReportError::Formatted(extends->GetLocation(), "No declaration found for class '%s'", extends->GetName());
         doneAtThisLevel = true;
      }
      else {
         parentClass = dynamic_cast<ClassDecl *>(parentDecl);
         if (NULL == parentClass) {
            //ReportError::Formatted(extends->GetLocation(), "No declaration found for class '%s'", extends->GetName());
            doneAtThisLevel = true;
         }
      }
   }
   if (doneAtThisLevel) {
      covered->table->Enter(GetName(), this);
      return;
   }

   parentClass->ValidateExtensions(covered);

   //For each parent declaration, make sure that fndecls that match names match params/types
   // and vardecls that match are not overwritten. For no matches, add to body symbol table
   Iterator<Decl*> iter = parentClass->bodytable->table->GetIterator();
   Decl *decl;
   while ((decl = iter.GetNextValue()) != NULL) {
      VarDecl* vardecl = dynamic_cast<VarDecl *>(decl);
      if (vardecl) {
         if (NULL != bodytable->table->Lookup(vardecl->GetName())) {
            //ReportError::Formatted(bodytable->table->Lookup(vardecl->GetName())->GetLocation(), 
		//"Declaration of '%s' here conflicts with declaration on line %d", vardecl->GetName(), 
		//vardecl->GetLocation()->first_line);
         } //TODO decide if error should keep the parent or child definition (currently child)
         else {
            bodytable->table->Enter(vardecl->GetName(), vardecl);
         }
      }
      else {//Should only be a fndecl or vardecl
         FnDecl* fndecl = dynamic_cast<FnDecl *>(decl);
         if (fndecl) {
            Decl* localdecl = bodytable->table->Lookup(fndecl->GetName());
            if (localdecl) { //If local is var, error. If fn, match params
               VarDecl* varlocaldecl = dynamic_cast<VarDecl *>(localdecl);
               if (varlocaldecl) {
                  //ReportError::Formatted(varlocaldecl->GetLocation(), 
			//"Declaration of '%s' here conflicts with declaration on line %d", varlocaldecl->GetName(), 
			//fndecl->GetLocation()->first_line);
               } //TODO decide if error should keep the parent or child definition (currently child)
               else {
                  FnDecl* fnlocaldecl = dynamic_cast<FnDecl *>(localdecl);
                  if (fnlocaldecl) {
                     if (fnlocaldecl->GetFormals()->NumElements() != fndecl->GetFormals()->NumElements()
		            || fnlocaldecl->GetType()->compare(fndecl->GetType()) != 0) {
                        //ReportError::Formatted(fnlocaldecl->GetLocation(), "Method '%s' must match inherited type signature", 
		        //fndecl->GetName());
	             }
                     else {
                        int j = 0;
                        bool mthderrStated = false;
                        for (; j< fndecl->GetFormals()->NumElements(); j++) {
                           if (fndecl->GetFormals()->Nth(j)->GetType()->compare(fnlocaldecl->GetFormals()->Nth(j)->GetType()) != 0) {
                              //if (!mthderrStated) ReportError::Formatted(fnlocaldecl->GetLocation(), 
		        	//   "Method '%s' must match inherited type signature", fndecl->GetName());
                              //mthderrStated = true;
                           }
                        }
                     }
                  }
               } 
            }
            else {
               bodytable->table->Enter(fndecl->GetName(), fndecl);
            }
         }
      }
   }
   covered->table->Enter(GetName(), this);
}

void FnDecl::ValidateDeclarations() {
   Decl *isaDecl = symboltable->Find(returnType->GetCoreName());
   if (!returnType->isPrimitiveType() && NULL == isaDecl) {
      //ReportError::Formatted(returnType->GetLocation(), "No declaration found for type '%s'", returnType->GetCoreName());
   }
   else if (NULL != isaDecl) {
      ClassDecl *isaClass = dynamic_cast<ClassDecl *>(isaDecl);
      InterfaceDecl *isaInter = dynamic_cast<InterfaceDecl *>(isaDecl);
      if (!(isaClass || isaInter)) {
         //ReportError::Formatted(returnType->GetLocation(), "No declaration found for type '%s'", returnType->GetCoreName());
      }
   }

   if (formals) {
      int i = 0;
      for (; i < formals->NumElements(); i++) { 
         if (formals->Nth(i)) formals->Nth(i)->ValidateDeclarations();
      }
   }

   if (body) body->ValidateDeclarations();
}

void VarDecl::ValidateDeclarations() {
   Decl *isaDecl = symboltable->Find(type->GetCoreName());
   if (!type->isPrimitiveType() && NULL == isaDecl) {
      //ReportError::Formatted(type->GetCoreType()->GetLocation(), "No declaration found for type '%s'", type->GetCoreName());
   }
   else if (NULL != isaDecl) {
      ClassDecl *isaClass = dynamic_cast<ClassDecl *>(isaDecl);
      InterfaceDecl *isaInter = dynamic_cast<InterfaceDecl *>(isaDecl);
      if (!(isaClass || isaInter)) {
         //ReportError::Formatted(type->GetCoreType()->GetLocation(), "No declaration found for type '%s'", type->GetCoreName());
      }
   }
}

void ClassDecl::ValidateDeclarations() {
   if (members) {
      int i = 0;
      for (; i < members->NumElements(); i++)  {
         if (members->Nth(i)) members->Nth(i)->ValidateDeclarations(); 
      }
   }
}

void InterfaceDecl::ValidateDeclarations() {
   if (members) {
      int i = 0;
      for (; i < members->NumElements(); i++) {
         if (members->Nth(i)) members->Nth(i)->ValidateDeclarations();
      }
   }
}

void FnDecl::Check(SymbolTable *rootscope) {
   if (body) body->Check(rootscope);
}

void VarDecl::Check(SymbolTable *rootscope) {
   //Nothing to be done at this stage
}

void ClassDecl::Check(SymbolTable *rootscope) {
   if (members) {
      int i = 0;
      for (; i < members->NumElements(); i++)  {
         if (members->Nth(i)) members->Nth(i)->Check(rootscope); 
      }
   }
}

void InterfaceDecl::Check(SymbolTable *rootscope) {
   if (members) {
      int i = 0;
      for (; i < members->NumElements(); i++) {
         if (members->Nth(i)) members->Nth(i)->Check(rootscope);
      }
   }
}

int ClassDecl::isSubclassOf(const char *parentName) {
   if (strcmp(parentName, GetName()) == 0) return 1;
   if (implements) {
      int i = 0;
      for (; i < implements->NumElements(); i++) {
         Decl* parentDecl = symboltable->table->Lookup(implements->Nth(i)->GetName());
         if (parentDecl && parentDecl->isSubclassOf(parentName) == 1) return 1; 
      }
   }
   if (extends) {
      Decl *parentDecl = symboltable->table->Lookup(extends->GetName());
      if (parentDecl && parentDecl->isSubclassOf(parentName) == 1) return 1; 
   }
   return 0;
}

int InterfaceDecl::isSubclassOf(const char *parentName) {
   if (strcmp(parentName, GetName()) == 0) return 1;
   else return 0;
}

//----------------------------------------------------

void Decl::Emit(CodeGenerator *codegen) {
  Node::Emit(codegen);
}

void VarDecl::Emit(CodeGenerator *codegen) {
  Decl::Emit(codegen);
  if (symboltable->parent == NULL) { // Global scope
    codeLoc = new Location(gpRelative, codegen->OffsetToFirstGlobal + codegen->VarSize*codegen->currentGlobalOffset, id->GetName());
    codegen->currentGlobalOffset++;
  }
  else {
    codeLoc = new Location(fpRelative, codegen->OffsetToFirstLocal - codegen->VarSize*codegen->currentOffset, id->GetName());
    codegen->currentOffset++;
  }

}

void VarDecl::EmitFormal(CodeGenerator *codegen, int paramNumber) {
  Decl::Emit(codegen);
  codeLoc = new Location(fpRelative, codegen->OffsetToFirstParam + codegen->VarSize*paramNumber, id->GetName());
}

void VarDecl::EmitClass(CodeGenerator *codegen, int classOffset) {
  Decl::Emit(codegen);
  isAddress = true;
  classPlacement = classOffset*codegen->VarSize;
}

void ClassDecl::Emit(CodeGenerator *codegen) {
  Decl::Emit(codegen);
  // Reference to class object is a pointer to
  // the address containting the address of the vtable, then each of the vardecls
  // the vtable contains a list of all labels of class methods, first inherited then declared 
  // Class function declarations have the name of the class appended to the label (_class.function)
  // and have an implied "this" as a first parameter

  int varoffsetCounter = 1;
  if (extends) {
    ClassDecl *heirnode = this;
    while (heirnode->extends != NULL) {
      ClassDecl *parentclass = dynamic_cast<ClassDecl *>(symboltable->Find(heirnode->extends->GetName()));
      Assert(parentclass);
      for (int i = 0; i < parentclass->members->NumElements(); i++) {
        VarDecl *varmember = dynamic_cast<VarDecl *>(parentclass->members->Nth(i));
        if (varmember) varoffsetCounter++;
      }
      heirnode = parentclass;
    }
  }
  for (int i = 0; i < members->NumElements(); i++) {
    Decl *member = members->Nth(i);
    FnDecl *fnmember = dynamic_cast<FnDecl *>(member);
    VarDecl *varmember = dynamic_cast<VarDecl *>(member);
    Assert(fnmember || varmember);
    if (varmember) {
      varmember->EmitClass(codegen, varoffsetCounter);
      varoffsetCounter++;
    }
    else {
      fnmember->EmitClass(codegen, GetName());
    }
  }
  codegen->GenVTable(GetName(), getMethodLabels(codegen));
  newSize = varoffsetCounter * codegen->VarSize;
  printf("%s: %d %d\n", GetName(), varoffsetCounter, newSize);
}

List<const char *> *ClassDecl::getMethodLabels(CodeGenerator *codegen) {
  List<const char*> *list = new List<const char*>;
  //Add parent's labels first, always maintain same order
  //If label here overrides previous label, replace in order
  if (extends) { //Ignoring interfaces for pp5
    ClassDecl *parentclass = dynamic_cast<ClassDecl *>(symboltable->Find(extends->GetName()));
    Assert(parentclass);
    List<const char*> *parentList = parentclass->getMethodLabels(codegen);
    for (int j = 0; j < parentList->NumElements(); j++) list->Append(parentList->Nth(j));
  }
  for (int i = 0; i < members->NumElements(); i++) {
    FnDecl *fndecl = dynamic_cast<FnDecl *>(members->Nth(i));
    if (fndecl) {
      bool isOverride = false;
      const char *newlabel = codegen->LabelForNameWithPrefix(GetName(), fndecl->GetName());
      for (int k = 0; k < list->NumElements(); k++) {
         char *buff = new char[strlen(fndecl->GetName())];
         strncpy(buff, strchr(list->Nth(k), '.')+1, strlen(fndecl->GetName()));
         if (0 == strcmp(buff, fndecl->GetName())) {
           list->RemoveAt(k);
           list->InsertAt(newlabel, k);
           fndecl->vtableOffset = k;
           isOverride = true;
           //break here?
         }
      }
      if (!isOverride) {
        fndecl->vtableOffset = list->NumElements();
        list->Append(newlabel);
      }
    }
  }
  return list;
}

void InterfaceDecl::Emit(CodeGenerator *codegen) {
  Decl::Emit(codegen);
  //Not implemented for pp5
}

void FnDecl::Emit(CodeGenerator *codegen) {
  Decl::Emit(codegen);
  int tempoffset = codegen->currentOffset;
  codegen->currentOffset = 0;
  int tmpbefore = codegen->nextTempNum;
  
  codegen->GenLabel(codegen->LabelForName(GetName()));

  BeginFunc *bfunc = codegen->GenBeginFunc();
  if (formals) for (int i = 0; i < formals->NumElements(); i++) formals->Nth(i)->EmitFormal(codegen, i);
  if (body) body->Emit(codegen);
  int tmpafter = codegen->nextTempNum;
  int bodycount = 0;
  StmtBlock *bodyblock = dynamic_cast<StmtBlock *>(body);
  if (bodyblock) bodycount = bodyblock->GetNumVarDecls();
  bfunc->SetFrameSize(codegen->VarSize * (tmpafter - tmpbefore + bodycount));
  codegen->GenEndFunc();
  codegen->currentOffset = tempoffset;
}

void FnDecl::EmitClass(CodeGenerator *codegen, const char *classname) {
  Decl::Emit(codegen);
  int tempoffset = codegen->currentOffset;
  codegen->currentOffset = 0;
  int tmpbefore = codegen->nextTempNum;
  
  codegen->GenLabel(codegen->LabelForNameWithPrefix(classname, GetName()));

  BeginFunc *bfunc = codegen->GenBeginFunc();
  if (formals) for (int i = 0; i < formals->NumElements(); i++) formals->Nth(i)->EmitFormal(codegen, i);
  if (body) body->Emit(codegen);
  int tmpafter = codegen->nextTempNum;
  int bodycount = 0;
  StmtBlock *bodyblock = dynamic_cast<StmtBlock *>(body);
  if (bodyblock) bodycount = bodyblock->GetNumVarDecls();
  bfunc->SetFrameSize(codegen->VarSize * (tmpafter - tmpbefore + bodycount));
  codegen->GenEndFunc();
  codegen->currentOffset = tempoffset;
}
