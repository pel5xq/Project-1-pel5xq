	# standard Decaf preamble 
	  .text
	  .align 2
	  .globl main
  _Animal.numLegs:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp0 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -8($fp)	# spill _tmp0 from $t2 to $fp-8
	# Return _tmp0
	  lw $t2, -8($fp)	# fill _tmp0 to $t2 from $fp-8
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  _Animal.numLegsOf:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# Return c
	  lw $t2, 8($fp)	# fill c to $t2 from $fp+8
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# VTable for class Animal
	  .data
	  .align 2
	  Animal:		# label for class Animal vtable
	  .word _Animal.numLegs
	  .word _Animal.numLegsOf
	  .text
  _Cow.getSelf:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# Return this
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  _Cow.getFather:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp1 = *(this + 16)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp1 from $t2 to $fp-8
	# Return _tmp1
	  lw $t2, -8($fp)	# fill _tmp1 to $t2 from $fp-8
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  _Cow.Init:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# *(this + 12) = w
	  lw $t0, 8($fp)	# fill w to $t0 from $fp+8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 12($t2) 	# store with offset
	# *(this + 8) = h
	  lw $t0, 12($fp)	# fill h to $t0 from $fp+12
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# *(this + 16) = f
	  lw $t0, 16($fp)	# fill f to $t0 from $fp+16
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 16($t2) 	# store with offset
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  _Cow.numLegs:
	# BeginFunc 4
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 4	# decrement sp to make space for locals/temps
	# _tmp2 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -8($fp)	# spill _tmp2 from $t2 to $fp-8
	# Return _tmp2
	  lw $t2, -8($fp)	# fill _tmp2 to $t2 from $fp-8
	  move $v0, $t2		# assign return value into $v0
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  _Cow.Moo:
	# BeginFunc 16
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 16	# decrement sp to make space for locals/temps
	# _tmp3 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp3 from $t2 to $fp-8
	# PushParam _tmp3
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill _tmp3 to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp4 = " "
	  .data			# create string constant marked with label
	  _string1: .asciiz " "
	  .text
	  la $t2, _string1	# load label
	  sw $t2, -12($fp)	# spill _tmp4 from $t2 to $fp-12
	# PushParam _tmp4
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp4 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp5 = *(this + 12)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 12($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp5 from $t2 to $fp-16
	# PushParam _tmp5
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp5 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp6 = "\n"
	  .data			# create string constant marked with label
	  _string2: .asciiz "\n"
	  .text
	  la $t2, _string2	# load label
	  sw $t2, -20($fp)	# spill _tmp6 from $t2 to $fp-20
	# PushParam _tmp6
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill _tmp6 to $t0 from $fp-20
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
	# VTable for class Cow
	  .data
	  .align 2
	  Cow:		# label for class Cow vtable
	  .word _Cow.numLegs
	  .word _Animal.numLegsOf
	  .word _Cow.getSelf
	  .word _Cow.getFather
	  .word _Cow.Init
	  .word _Cow.Moo
	  .text
  main:
	# BeginFunc 204
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 204	# decrement sp to make space for locals/temps
	# _tmp7 = 20
	  li $t2, 20		# load constant value 20 into $t2
	  sw $t2, -20($fp)	# spill _tmp7 from $t2 to $fp-20
	# PushParam _tmp7
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill _tmp7 to $t0 from $fp-20
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp8 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -24($fp)	# spill _tmp8 from $t2 to $fp-24
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp9 = Cow
	  la $t2, Cow	# load label
	  sw $t2, -28($fp)	# spill _tmp9 from $t2 to $fp-28
	# *(_tmp8) = _tmp9
	  lw $t0, -28($fp)	# fill _tmp9 to $t0 from $fp-28
	  lw $t2, -24($fp)	# fill _tmp8 to $t2 from $fp-24
	  sw $t0, 0($t2) 	# store with offset
	# betsy = _tmp8
	  lw $t2, -24($fp)	# fill _tmp8 to $t2 from $fp-24
	  sw $t2, -8($fp)	# spill betsy from $t2 to $fp-8
	# _tmp10 = 8
	  li $t2, 8		# load constant value 8 into $t2
	  sw $t2, -32($fp)	# spill _tmp10 from $t2 to $fp-32
	# PushParam _tmp10
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -32($fp)	# fill _tmp10 to $t0 from $fp-32
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp11 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -36($fp)	# spill _tmp11 from $t2 to $fp-36
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp12 = Animal
	  la $t2, Animal	# load label
	  sw $t2, -40($fp)	# spill _tmp12 from $t2 to $fp-40
	# *(_tmp11) = _tmp12
	  lw $t0, -40($fp)	# fill _tmp12 to $t0 from $fp-40
	  lw $t2, -36($fp)	# fill _tmp11 to $t2 from $fp-36
	  sw $t0, 0($t2) 	# store with offset
	# mal = _tmp11
	  lw $t2, -36($fp)	# fill _tmp11 to $t2 from $fp-36
	  sw $t2, -12($fp)	# spill mal from $t2 to $fp-12
	# _tmp13 = 5
	  li $t2, 5		# load constant value 5 into $t2
	  sw $t2, -44($fp)	# spill _tmp13 from $t2 to $fp-44
	# _tmp14 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -48($fp)	# spill _tmp14 from $t2 to $fp-48
	# _tmp15 = _tmp13 < _tmp14
	  lw $t0, -44($fp)	# fill _tmp13 to $t0 from $fp-44
	  lw $t1, -48($fp)	# fill _tmp14 to $t1 from $fp-48
	  slt $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp15 from $t2 to $fp-52
	# IfZ _tmp15 Goto _L0
	  lw $t0, -52($fp)	# fill _tmp15 to $t0 from $fp-52
	  beqz $t0, _L0	# branch if _tmp15 is zero 
	# _tmp16 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string3: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string3	# load label
	  sw $t2, -56($fp)	# spill _tmp16 from $t2 to $fp-56
	# PushParam _tmp16
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -56($fp)	# fill _tmp16 to $t0 from $fp-56
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L0:
	# _tmp17 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -60($fp)	# spill _tmp17 from $t2 to $fp-60
	# _tmp18 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -64($fp)	# spill _tmp18 from $t2 to $fp-64
	# _tmp19 = _tmp18 + _tmp13
	  lw $t0, -64($fp)	# fill _tmp18 to $t0 from $fp-64
	  lw $t1, -44($fp)	# fill _tmp13 to $t1 from $fp-44
	  add $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp19 from $t2 to $fp-68
	# _tmp20 = _tmp17 * _tmp19
	  lw $t0, -60($fp)	# fill _tmp17 to $t0 from $fp-60
	  lw $t1, -68($fp)	# fill _tmp19 to $t1 from $fp-68
	  mul $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp20 from $t2 to $fp-72
	# PushParam _tmp20
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -72($fp)	# fill _tmp20 to $t0 from $fp-72
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp21 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -76($fp)	# spill _tmp21 from $t2 to $fp-76
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp21) = _tmp13
	  lw $t0, -44($fp)	# fill _tmp13 to $t0 from $fp-44
	  lw $t2, -76($fp)	# fill _tmp21 to $t2 from $fp-76
	  sw $t0, 0($t2) 	# store with offset
	# _tmp22 = _tmp17 + _tmp21
	  lw $t0, -60($fp)	# fill _tmp17 to $t0 from $fp-60
	  lw $t1, -76($fp)	# fill _tmp21 to $t1 from $fp-76
	  add $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp22 from $t2 to $fp-80
	# x = _tmp22
	  lw $t2, -80($fp)	# fill _tmp22 to $t2 from $fp-80
	  sw $t2, -16($fp)	# spill x from $t2 to $fp-16
	# _tmp23 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -84($fp)	# spill _tmp23 from $t2 to $fp-84
	# _tmp24 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -88($fp)	# spill _tmp24 from $t2 to $fp-88
	# _tmp25 = *(x + -4)
	  lw $t0, -16($fp)	# fill x to $t0 from $fp-16
	  lw $t2, -4($t0) 	# load with offset
	  sw $t2, -92($fp)	# spill _tmp25 from $t2 to $fp-92
	# _tmp26 = _tmp23 < _tmp25
	  lw $t0, -84($fp)	# fill _tmp23 to $t0 from $fp-84
	  lw $t1, -92($fp)	# fill _tmp25 to $t1 from $fp-92
	  slt $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp26 from $t2 to $fp-96
	# _tmp27 = _tmp26 == _tmp24
	  lw $t0, -96($fp)	# fill _tmp26 to $t0 from $fp-96
	  lw $t1, -88($fp)	# fill _tmp24 to $t1 from $fp-88
	  seq $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp27 from $t2 to $fp-100
	# _tmp28 = _tmp23 < _tmp24
	  lw $t0, -84($fp)	# fill _tmp23 to $t0 from $fp-84
	  lw $t1, -88($fp)	# fill _tmp24 to $t1 from $fp-88
	  slt $t2, $t0, $t1	
	  sw $t2, -104($fp)	# spill _tmp28 from $t2 to $fp-104
	# _tmp29 = _tmp28 || _tmp27
	  lw $t0, -104($fp)	# fill _tmp28 to $t0 from $fp-104
	  lw $t1, -100($fp)	# fill _tmp27 to $t1 from $fp-100
	  or $t2, $t0, $t1	
	  sw $t2, -108($fp)	# spill _tmp29 from $t2 to $fp-108
	# IfZ _tmp29 Goto _L1
	  lw $t0, -108($fp)	# fill _tmp29 to $t0 from $fp-108
	  beqz $t0, _L1	# branch if _tmp29 is zero 
	# _tmp30 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string4: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string4	# load label
	  sw $t2, -112($fp)	# spill _tmp30 from $t2 to $fp-112
	# PushParam _tmp30
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -112($fp)	# fill _tmp30 to $t0 from $fp-112
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L1:
	# _tmp31 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -116($fp)	# spill _tmp31 from $t2 to $fp-116
	# _tmp32 = _tmp23 * _tmp31
	  lw $t0, -84($fp)	# fill _tmp23 to $t0 from $fp-84
	  lw $t1, -116($fp)	# fill _tmp31 to $t1 from $fp-116
	  mul $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp32 from $t2 to $fp-120
	# _tmp33 = x + _tmp32
	  lw $t0, -16($fp)	# fill x to $t0 from $fp-16
	  lw $t1, -120($fp)	# fill _tmp32 to $t1 from $fp-120
	  add $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp33 from $t2 to $fp-124
	# _tmp34 = 5
	  li $t2, 5		# load constant value 5 into $t2
	  sw $t2, -128($fp)	# spill _tmp34 from $t2 to $fp-128
	# *(_tmp33) = _tmp34
	  lw $t0, -128($fp)	# fill _tmp34 to $t0 from $fp-128
	  lw $t2, -124($fp)	# fill _tmp33 to $t2 from $fp-124
	  sw $t0, 0($t2) 	# store with offset
	# _tmp35 = 100
	  li $t2, 100		# load constant value 100 into $t2
	  sw $t2, -132($fp)	# spill _tmp35 from $t2 to $fp-132
	# _tmp36 = 122
	  li $t2, 122		# load constant value 122 into $t2
	  sw $t2, -136($fp)	# spill _tmp36 from $t2 to $fp-136
	# _tmp37 = *(betsy)
	  lw $t0, -8($fp)	# fill betsy to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -140($fp)	# spill _tmp37 from $t2 to $fp-140
	# _tmp38 = *(_tmp37 + 16)
	  lw $t0, -140($fp)	# fill _tmp37 to $t0 from $fp-140
	  lw $t2, 16($t0) 	# load with offset
	  sw $t2, -144($fp)	# spill _tmp38 from $t2 to $fp-144
	# PushParam mal
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill mal to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp36
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -136($fp)	# fill _tmp36 to $t0 from $fp-136
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp35
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -132($fp)	# fill _tmp35 to $t0 from $fp-132
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam betsy
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill betsy to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp38
	  lw $t0, -144($fp)	# fill _tmp38 to $t0 from $fp-144
	  jalr $t0            	# jump to function
	# PopParams 16
	  add $sp, $sp, 16	# pop params off stack
	# _tmp39 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -148($fp)	# spill _tmp39 from $t2 to $fp-148
	# _tmp40 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -152($fp)	# spill _tmp40 from $t2 to $fp-152
	# _tmp41 = *(x + -4)
	  lw $t0, -16($fp)	# fill x to $t0 from $fp-16
	  lw $t2, -4($t0) 	# load with offset
	  sw $t2, -156($fp)	# spill _tmp41 from $t2 to $fp-156
	# _tmp42 = _tmp39 < _tmp41
	  lw $t0, -148($fp)	# fill _tmp39 to $t0 from $fp-148
	  lw $t1, -156($fp)	# fill _tmp41 to $t1 from $fp-156
	  slt $t2, $t0, $t1	
	  sw $t2, -160($fp)	# spill _tmp42 from $t2 to $fp-160
	# _tmp43 = _tmp42 == _tmp40
	  lw $t0, -160($fp)	# fill _tmp42 to $t0 from $fp-160
	  lw $t1, -152($fp)	# fill _tmp40 to $t1 from $fp-152
	  seq $t2, $t0, $t1	
	  sw $t2, -164($fp)	# spill _tmp43 from $t2 to $fp-164
	# _tmp44 = _tmp39 < _tmp40
	  lw $t0, -148($fp)	# fill _tmp39 to $t0 from $fp-148
	  lw $t1, -152($fp)	# fill _tmp40 to $t1 from $fp-152
	  slt $t2, $t0, $t1	
	  sw $t2, -168($fp)	# spill _tmp44 from $t2 to $fp-168
	# _tmp45 = _tmp44 || _tmp43
	  lw $t0, -168($fp)	# fill _tmp44 to $t0 from $fp-168
	  lw $t1, -164($fp)	# fill _tmp43 to $t1 from $fp-164
	  or $t2, $t0, $t1	
	  sw $t2, -172($fp)	# spill _tmp45 from $t2 to $fp-172
	# IfZ _tmp45 Goto _L2
	  lw $t0, -172($fp)	# fill _tmp45 to $t0 from $fp-172
	  beqz $t0, _L2	# branch if _tmp45 is zero 
	# _tmp46 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string5: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string5	# load label
	  sw $t2, -176($fp)	# spill _tmp46 from $t2 to $fp-176
	# PushParam _tmp46
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -176($fp)	# fill _tmp46 to $t0 from $fp-176
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L2:
	# _tmp47 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -180($fp)	# spill _tmp47 from $t2 to $fp-180
	# _tmp48 = _tmp39 * _tmp47
	  lw $t0, -148($fp)	# fill _tmp39 to $t0 from $fp-148
	  lw $t1, -180($fp)	# fill _tmp47 to $t1 from $fp-180
	  mul $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp48 from $t2 to $fp-184
	# _tmp49 = x + _tmp48
	  lw $t0, -16($fp)	# fill x to $t0 from $fp-16
	  lw $t1, -184($fp)	# fill _tmp48 to $t1 from $fp-184
	  add $t2, $t0, $t1	
	  sw $t2, -188($fp)	# spill _tmp49 from $t2 to $fp-188
	# _tmp50 = *(betsy)
	  lw $t0, -8($fp)	# fill betsy to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -192($fp)	# spill _tmp50 from $t2 to $fp-192
	# _tmp51 = *(_tmp50 + 4)
	  lw $t0, -192($fp)	# fill _tmp50 to $t0 from $fp-192
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -196($fp)	# spill _tmp51 from $t2 to $fp-196
	# _tmp52 = *(_tmp49)
	  lw $t0, -188($fp)	# fill _tmp49 to $t0 from $fp-188
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -200($fp)	# spill _tmp52 from $t2 to $fp-200
	# PushParam _tmp52
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -200($fp)	# fill _tmp52 to $t0 from $fp-200
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam betsy
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill betsy to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp53 = ACall _tmp51
	  lw $t0, -196($fp)	# fill _tmp51 to $t0 from $fp-196
	  jalr $t0            	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -204($fp)	# spill _tmp53 from $t2 to $fp-204
	# PopParams 8
	  add $sp, $sp, 8	# pop params off stack
	# PushParam _tmp53
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -204($fp)	# fill _tmp53 to $t0 from $fp-204
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp54 = "\n"
	  .data			# create string constant marked with label
	  _string6: .asciiz "\n"
	  .text
	  la $t2, _string6	# load label
	  sw $t2, -208($fp)	# spill _tmp54 from $t2 to $fp-208
	# PushParam _tmp54
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -208($fp)	# fill _tmp54 to $t0 from $fp-208
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
_PrintInt:
        subu $sp, $sp, 8
        sw $fp, 8($sp)
        sw $ra, 4($sp)
        addiu $fp, $sp, 8
        li   $v0, 1
        lw   $a0, 4($fp)
        syscall
        move $sp, $fp
        lw $ra, -4($fp)
        lw $fp, 0($fp)
        jr $ra
                                
_PrintString:
        subu $sp, $sp, 8
        sw $fp, 8($sp)
        sw $ra, 4($sp)
        addiu $fp, $sp, 8
        li   $v0, 4
        lw $a0, 4($fp)
        syscall
        move $sp, $fp
        lw $ra, -4($fp)
        lw $fp, 0($fp)
        jr $ra
        
_PrintBool:
	subu $sp, $sp, 8
	sw $fp, 8($sp)
	sw $ra, 4($sp)
        addiu $fp, $sp, 8
	lw $t1, 4($fp)
	blez $t1, fbr
	li   $v0, 4		# system call for print_str
	la   $a0, TRUE		# address of str to print
	syscall			
	b end
fbr:	li   $v0, 4		# system call for print_str
	la   $a0, FALSE		# address of str to print
	syscall				
end:	move $sp, $fp
	lw $ra, -4($fp)
	lw $fp, 0($fp)
	jr $ra

_Alloc:
        subu $sp, $sp, 8
        sw $fp, 8($sp)
        sw $ra, 4($sp)
        addiu $fp, $sp, 8
        li   $v0, 9
        lw $a0, 4($fp)
	syscall
        move $sp, $fp
        lw $ra, -4($fp)
        lw $fp, 0($fp) 
        jr $ra


_StringEqual:
	subu $sp, $sp, 8      # decrement sp to make space to save ra, fp
	sw $fp, 8($sp)        # save fp
	sw $ra, 4($sp)        # save ra
	addiu $fp, $sp, 8     # set up new fp
	subu $sp, $sp, 4      # decrement sp to make space for locals/temps

	li $v0,0

	#Determine length string 1
	lw $t0, 4($fp)       
	li $t3,0
bloop1: 
	lb $t5, ($t0) 
	beqz $t5, eloop1	
	addi $t0, 1
	addi $t3, 1
	b bloop1
eloop1:
	
	#Determine length string 2
	lw $t1, 8($fp)
	li $t4,0
bloop2: 
	lb $t5, ($t1) 
	beqz $t5, eloop2	
	addi $t1, 1
	addi $t4, 1
	b bloop2
eloop2:
	bne $t3,$t4,end1       #Check String Lengths Same

	lw $t0, 4($fp)	
	lw $t1, 8($fp)
	li $t3, 0     		
bloop3:	
	lb $t5, ($t0) 
	lb $t6, ($t1) 
	bne $t5, $t6, end1
	beqz $t5, eloop3       # if zero, then we hit the end of both strings
	addi $t3, 1
	addi $t0, 1
	addi $t1, 1
	#bne $t3,$t4,bloop3
	b bloop3
eloop3:	li $v0,1

end1:	move $sp, $fp         # pop callee frame off stack
	lw $ra, -4($fp)       # restore saved ra
	lw $fp, 0($fp)        # restore saved fp
	jr $ra                # return from function

_Halt:
        li $v0, 10
        syscall

_ReadInteger:
	subu $sp, $sp, 8      # decrement sp to make space to save ra, fp
	sw $fp, 8($sp)        # save fp
	sw $ra, 4($sp)        # save ra
	addiu $fp, $sp, 8     # set up new fp
	subu $sp, $sp, 4      # decrement sp to make space for locals/temps
	li $v0, 5
	syscall
	move $sp, $fp         # pop callee frame off stack
	lw $ra, -4($fp)       # restore saved ra
	lw $fp, 0($fp)        # restore saved fp
	jr $ra
        

_ReadLine:
	subu $sp, $sp, 8      # decrement sp to make space to save ra, fp
	sw $fp, 8($sp)        # save fp
	sw $ra, 4($sp)        # save ra
	addiu $fp, $sp, 8     # set up new fp
	subu $sp, $sp, 4      # decrement sp to make space for locals/temps
	# allocate space to store memory
	li $a0, 128           # request 128 bytes
	li $v0, 9	      # syscall "sbrk" for memory allocation
	syscall               # do the system call
	# read in the new line
	li $a1, 128	      # size of the buffer
	#la $a0, SPACE        
	move $a0, $v0	      # location of the buffer	
	li $v0, 8 
	syscall

	#la $t1, SPACE  
	move $t1, $a0
bloop4: 
	lb $t5, ($t1) 
	beqz $t5, eloop4	
	addi $t1, 1
	b bloop4
eloop4:
	addi $t1,-1
	li $t6,0
	sb $t6, ($t1)

	#la $v0, SPACE
	move $v0, $a0	      # save buffer location to v0 as return value	
	move $sp, $fp         # pop callee frame off stack
	lw $ra, -4($fp)       # restore saved ra
	lw $fp, 0($fp)        # restore saved fp
	jr $ra
	

	.data
TRUE:.asciiz "true"
FALSE:.asciiz "false"
SPACE:.asciiz "Making Space For Inputed Values Is Fun."
SPACE2:.asciiz "AAA.\n"

