/* File: ast_type.cc
 * -----------------
 * Implementation of type node classes.
 */
#include "ast_type.h"
#include "ast_decl.h"
#include <string.h>
#include "symboltable.h"

 
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

Type* Type::GetCoreType() {
   if (NULL == typeName) {
      NamedType *nat1 = dynamic_cast<NamedType *>(this);
      if (NULL == nat1) {
         ArrayType *art1 = dynamic_cast<ArrayType *>(this);
            if (NULL == art1) {
		//Unexpected
                return NULL;
            }
            else {
               return art1->GetElemType()->GetCoreType();
            }
      }
      else return this;
   }
   else return this;
}

int Type::compare(Type *other) {
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

int Type::comparePolymorph(Type *other, SymbolTable *rootscope) { //other must be usage (i.e. can be subclass)
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
      //need to remove array subtyping polymorphism?
      return art1->GetElemType()->comparePolymorph(art2->GetElemType(), rootscope);
      //return strcmp(art1->GetFullName(), art2->GetFullName());
   }
   if (type1 == 1) {
      if (strcmp(nat1->GetName(), nat2->GetName()) == 0) return 0;
      else {
        if (strcmp(nat2->GetName(), "null")==0) return 0; //Valid to use null for object
        Decl* childDecl = rootscope->table->Lookup(nat2->GetName());
	if (childDecl) return (childDecl->isSubclassOf(nat1->GetName()) - 1);//turn 1/0 into 0/-1
        else {
           //printf("Unexpected null class definition %s\n", nat2->GetName());
           //Keep quiet, will have found earlier
           return -1;
        }
      }
   }
   return -1; //Shouldn't be reached
}

int Type::comparePolymorph(const char *other, SymbolTable *rootscope) { //other must be usage (i.e. can be subclass)
   int type1, type2; //-1 = ArrayType, 0 = Type, 1 = NamedType
   NamedType *nat1;
   ArrayType *art1;
   char *coreOtherName;

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

   if (NULL != strchr(other, '[')) {
      //Array
      //Need to only pop one [] off, to make comparing a[] to a[][] work
      type2 = -1;
      //coreOtherName = new char[strlen(other)-2];
      //memcpy(coreOtherName, other, strlen(other)-3);
      //coreOtherName[strlen(other)-3] = '\0';
      int newlength = strrchr(other, '[')-other;
      coreOtherName = new char[newlength+1];
      memcpy(coreOtherName, other, newlength);
      coreOtherName[newlength] = '\0';
   }
   else {
      //coreOtherName = other;
      if(strcmp(other, "int") == 0
           || strcmp(other, "double") == 0
           || strcmp(other, "bool") == 0
           || strcmp(other, "string") == 0
           || strcmp(other, "void") == 0
           ) {//|| strcmp(other, "null") == 0
         //Primitive
         type2 = 0;
      }
      else {
         //Named
         type2 = 1;
      }
   }


   if (type1 != type2) {
      return -1;
   }
   if (type1 == 0) {
      return strcmp(typeName, other);
   }
   if (type1 == -1) {
      //need to remove array subtyping polymorphism?
      return art1->GetElemType()->comparePolymorph(coreOtherName, rootscope);
      //printf("%s %s\n", art1->GetFullName(), other);
      //return strcmp(art1->GetFullName(), other);
   }
   if (type1 == 1) {
      if (strcmp(nat1->GetName(), other) == 0) return 0;
      else {
        if (strcmp(other, "null")==0) return 0; //Valid to use null for object
        Decl* childDecl = rootscope->table->Lookup(other);
	if (childDecl) return (childDecl->isSubclassOf(nat1->GetName()) - 1);//turn 1/0 into 0/-1
        else {
           //printf("Unexpected null class definition %s\n", other);
           //Keep quiet, will have found earlier
           return -1;
        }
      }
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


