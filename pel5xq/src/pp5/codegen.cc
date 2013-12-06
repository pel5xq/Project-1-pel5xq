/* File: codegen.cc
 * ----------------
 * Implementation for the CodeGenerator class. The methods don't do anything
 * too fancy, mostly just create objects of the various Tac instruction
 * classes and append them to the list.
 */

#include "codegen.h"
#include <string.h>
#include "tac.h"
#include "mips.h"
#include "errors.h"

Location* CodeGenerator::ThisPtr= new Location(fpRelative, 4, "this");
  
CodeGenerator::CodeGenerator()
{
}

char *CodeGenerator::NewLabel()
{
  static int nextLabelNum = 0;
  char temp[10];
  sprintf(temp, "_L%d", nextLabelNum++);
  return strdup(temp);
}

const char *CodeGenerator::LabelForName(const char* name) {
  if (0 == strcmp(name, "main")) return name;
  char *temp = new char[strlen(name)+1];
  sprintf(temp, "_%s", name);
  return temp;
}

const char *CodeGenerator::LabelForNameWithPrefix(const char* prefix, const char* name) {
  if (0 == strcmp(name, "main")) return name;
  char *temp = new char[strlen(name)+strlen(prefix)+3];//Is +2 unsafe or is +3 one char too many?
  sprintf(temp, "_%s.%s", prefix, name);
  return temp;
}

Location *CodeGenerator::GenNewExpr(int byteSize, const char *className) {
  Location *classptr = GenBuiltInCall(Alloc, GenLoadConstant(byteSize));
  GenStore(classptr, GenLoadLabel(className), 0);
  return classptr;
}

Location *CodeGenerator::GenTempVar()
{
  //static int nextTempNum;
  char temp[10];
  Location *result = NULL;
  sprintf(temp, "_tmp%d", nextTempNum++);
  /* pp5: need to create variable in proper location
     in stack frame for use as temporary. Until you
     do that, the assert below will always fail to remind
     you this needs to be implemented  */

  result = new Location(fpRelative, OffsetToFirstLocal - VarSize*currentOffset, temp);

  currentOffset++;

  Assert(result != NULL);
  return result;
}
 
Location *CodeGenerator::GenLoadConstant(int value)
{
  Location *result = GenTempVar();
  code.push_back(new LoadConstant(result, value));
  return result;
}

Location *CodeGenerator::GenLoadConstant(const char *s)
{
  Location *result = GenTempVar();
  code.push_back(new LoadStringConstant(result, s));
  return result;
} 

Location *CodeGenerator::GenLoadLabel(const char *label)
{
  Location *result = GenTempVar();
  code.push_back(new LoadLabel(result, label));
  return result;
} 


void CodeGenerator::GenAssign(Location *dst, Location *src)
{
  code.push_back(new Assign(dst, src));
}


Location *CodeGenerator::GenLoad(Location *ref, int offset)
{
  Location *result = GenTempVar();
  code.push_back(new Load(result, ref, offset));
  return result;
}

void CodeGenerator::GenStore(Location *dst,Location *src, int offset)
{
  code.push_back(new Store(dst, src, offset));
}


Location *CodeGenerator::GenBinaryOp(const char *opName, Location *op1,
						     Location *op2)
{
  Location *result = GenTempVar();
  code.push_back(new BinaryOp(BinaryOp::OpCodeForName(opName), result, op1, op2));
  return result;
}


void CodeGenerator::GenLabel(const char *label)
{
  code.push_back(new Label(label));
}

void CodeGenerator::GenIfZ(Location *test, const char *label)
{
  code.push_back(new IfZ(test, label));
}

void CodeGenerator::GenGoto(const char *label)
{
  code.push_back(new Goto(label));
}

void CodeGenerator::GenReturn(Location *val)
{
  code.push_back(new Return(val));
}


BeginFunc *CodeGenerator::GenBeginFunc()
{
  BeginFunc *result = new BeginFunc;
  code.push_back(result);
  return result;
}

void CodeGenerator::GenEndFunc()
{
  code.push_back(new EndFunc());
}

void CodeGenerator::GenPushParam(Location *param)
{
  code.push_back(new PushParam(param));
}

void CodeGenerator::GenPopParams(int numBytesOfParams)
{
  Assert(numBytesOfParams >= 0 && numBytesOfParams % VarSize == 0); // sanity check
  if (numBytesOfParams > 0)
    code.push_back(new PopParams(numBytesOfParams));
}

Location *CodeGenerator::GenLCall(const char *label, bool fnHasReturnValue)
{
  Location *result = fnHasReturnValue ? GenTempVar() : NULL;
  code.push_back(new LCall(label, result));
  return result;
}

Location *CodeGenerator::GenACall(Location *fnAddr, bool fnHasReturnValue)
{
  Location *result = fnHasReturnValue ? GenTempVar() : NULL;
  code.push_back(new ACall(fnAddr, result));
  return result;
}
 
 
static struct _builtin {
  const char *label;
  int numArgs;
  bool hasReturn;
} builtins[] =
 {{"_Alloc", 1, true},
  {"_ReadLine", 0, true},
  {"_ReadInteger", 0, true},
  {"_StringEqual", 2, true},
  {"_PrintInt", 1, false},
  {"_PrintString", 1, false},
  {"_PrintBool", 1, false},
  {"_Halt", 0, false}};

Location *CodeGenerator::GenBuiltInCall(BuiltIn bn,Location *arg1, Location *arg2)
{
  Assert(bn >= 0 && bn < NumBuiltIns);
  struct _builtin *b = &builtins[bn];
  Location *result = NULL;

  if (b->hasReturn) result = GenTempVar();
                // verify appropriate number of non-NULL arguments given
  Assert((b->numArgs == 0 && !arg1 && !arg2)
	|| (b->numArgs == 1 && arg1 && !arg2)
	|| (b->numArgs == 2 && arg1 && arg2));
  if (arg2) code.push_back(new PushParam(arg2));
  if (arg1) code.push_back(new PushParam(arg1));
  code.push_back(new LCall(b->label, result));
  GenPopParams(VarSize*b->numArgs);
  return result;
}


void CodeGenerator::GenVTable(const char *className, List<const char *> *methodLabels)
{
  code.push_back(new VTable(className, methodLabels));
}

Location *CodeGenerator::GenNewArrayCall(Location *arraySize) {
   char *checklabel = NewLabel();
   //if size <= 0 (< 1), runtime error
   GenIfZ(GenBinaryOp("<", arraySize, GenLoadConstant(1)), checklabel);
   GenBuiltInCall(PrintString, GenLoadConstant(err_arr_bad_size));
   GenBuiltInCall(Halt);
   GenLabel(checklabel);
   Location *varsizeloc = GenLoadConstant(VarSize);
   //Allocate array
   Location *allocatedArray = GenBuiltInCall(Alloc, GenBinaryOp("*", varsizeloc, GenBinaryOp("+", GenLoadConstant(1), arraySize)));
   //set first member as array length
   GenStore(allocatedArray, arraySize, 0);
   //return address of allocation + 4
   return GenBinaryOp("+", varsizeloc, allocatedArray);
}

Location *CodeGenerator::GenArraySubscriptCall(Location *arrayAddr, Location *arrayIndex) {
   Location *zeroconst = GenLoadConstant(0);
   char *checklabel = NewLabel();
   //if 0 < index || !(index < size), runtime error
   GenIfZ(GenBinaryOp("||", GenBinaryOp("<", arrayIndex, zeroconst), 
      GenBinaryOp("==", GenBinaryOp("<", arrayIndex, GenLoad(arrayAddr, -4)), zeroconst)), checklabel);
   GenBuiltInCall(PrintString, GenLoadConstant(err_arr_out_of_bounds));
   GenBuiltInCall(Halt);
   GenLabel(checklabel);
   //return 4*index + arrayAddr
   return GenBinaryOp("+", arrayAddr, GenBinaryOp("*", arrayIndex, GenLoadConstant(VarSize)) );
}


void CodeGenerator::DoFinalCodeGen()
{
  if (IsDebugOn("tac")) { // if debug don't translate to mips, just print Tac
    std::list<Instruction*>::iterator p;
    for (p= code.begin(); p != code.end(); ++p) {
      (*p)->Print();
    }
   }  else {
     Mips mips;
     mips.EmitPreamble();

    std::list<Instruction*>::iterator p;
    for (p= code.begin(); p != code.end(); ++p) {
      (*p)->Emit(&mips);
    }
  }
}


