/* File: ast_type.cc
 * -----------------
 * Implementation of type node classes.
 */
#include "ast_type.h"
#include "ast_decl.h"
#include <string.h>

 
/* Class constants
 * ---------------
 * These are public constants for the built-in base types (int, double, etc.)
 * They can be accessed with the syntax Type::intType. This allows you to
 * directly access them and share the built-in types where needed rather that
 * creates lots of copies.
 */ 

Type *Type::intType    = new Type("int");
Type *Type::doubleType = new Type("double");
Type *Type::voidType   = new Type("void");
Type *Type::boolType   = new Type("bool");
Type *Type::nullType   = new Type("null");
Type *Type::stringType = new Type("string");
Type *Type::errorType  = new Type("error"); 

Type::Type(const char *n) {
    Assert(n);
    typeName = strdup(n);
}

void Type::PrintChildren(int indentLevel) {
    printf("%s", typeName);
}

bool Type::isPrimitiveType() {
   return (strcmp(GetCoreName(), "int") == 0
           || strcmp(GetCoreName(), "double") == 0
           || strcmp(GetCoreName(), "bool") == 0
           || strcmp(GetCoreName(), "string") == 0
           || strcmp(GetCoreName(), "void") == 0);
}

const char* Type::GetFullName() {
   if (NULL == typeName) {
      NamedType *nat1 = dynamic_cast<NamedType *>(this);
      if (NULL == nat1) {
         ArrayType *art1 = dynamic_cast<ArrayType *>(this);
            if (NULL == art1) {
		//Unexpected
                return NULL;
            }
            else {
               const char *typeval = art1->GetElemType()->GetFullName();
               char *retVal = new char[strlen(typeval)+2]; 
               memcpy(retVal, typeval, strlen(typeval));
               strcat(retVal, "[]");
               return retVal;
            }
      }
      else return nat1->GetName();
   }
   else return typeName;
}

const char* Type::GetCoreName() {
   if (NULL == typeName) {
      NamedType *nat1 = dynamic_cast<NamedType *>(this);
      if (NULL == nat1) {
         ArrayType *art1 = dynamic_cast<ArrayType *>(this);
            if (NULL == art1) {
		//Unexpected
                return NULL;
            }
            else {
               return art1->GetElemType()->GetCoreName();
            }
      }
      else return nat1->GetName();
   }
   else return typeName;
}

int Type::compare(Type *other) { //Handle when typeName is NULL (Named, Array)
   int type1, type2; //-1 = ArrayType, 0 = Type, 1 = NamedType
   NamedType *nat1;
   NamedType *nat2;
   ArrayType *art1;
   ArrayType *art2;

   if (NULL == typeName) {
      nat1 = dynamic_cast<NamedType *>(this);
      if (NULL == nat1) {
         art1 = dynamic_cast<ArrayType *>(this);
            if (NULL == art1) {
		printf("Unexpected case, assuming unequal\n");
                return -1;
            }
            else type1 = -1;
      }
      else type1 = 1;
   }
   else type1 = 0;

   if (NULL == other->typeName) {
      nat2 = dynamic_cast<NamedType *>(other);
      if (NULL == nat2) {
         art2 = dynamic_cast<ArrayType *>(other);
            if (NULL == art2) {
		printf("Unexpected case, assuming unequal\n");
                return -1;
            }
            else type2 = -1;
      }
      else type2 = 1;
   }
   else type2 = 0;
   if (type1 != type2) {
      return -1;
   }
   if (type1 == 0) {
      return strcmp(typeName, other->typeName);
   }
   if (type1 == -1) {
      return art1->GetElemType()->compare(art2->GetElemType());
   }
   if (type1 == 1) {
      return strcmp(nat1->GetName(), nat2->GetName());
   }
   return -1; //Shouldn't be reached
}
	
NamedType::NamedType(Identifier *i) : Type(*i->GetLocation()) {
    Assert(i != NULL);
    (id=i)->SetParent(this);
} 

void NamedType::PrintChildren(int indentLevel) {
    id->Print(indentLevel+1);
}

ArrayType::ArrayType(yyltype loc, Type *et) : Type(loc) {
    Assert(et != NULL);
    (elemType=et)->SetParent(this);
}
void ArrayType::PrintChildren(int indentLevel) {
    elemType->Print(indentLevel+1);
}


