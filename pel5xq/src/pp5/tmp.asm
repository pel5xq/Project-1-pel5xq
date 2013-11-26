	# standard Decaf preamble 
	  .text
	  .align 2
	  .globl main
  main:
	# BeginFunc 220
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 220	# decrement sp to make space for locals/temps
	# _tmp0 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -16($fp)	# spill _tmp0 from $t2 to $fp-16
	# _tmp1 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -20($fp)	# spill _tmp1 from $t2 to $fp-20
	# _tmp2 = _tmp0 < _tmp1
	  lw $t0, -16($fp)	# fill _tmp0 to $t0 from $fp-16
	  lw $t1, -20($fp)	# fill _tmp1 to $t1 from $fp-20
	  slt $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp2 from $t2 to $fp-24
	# IfZ _tmp2 Goto _L0
	  lw $t0, -24($fp)	# fill _tmp2 to $t0 from $fp-24
	  beqz $t0, _L0	# branch if _tmp2 is zero 
	# _tmp3 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string1: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string1	# load label
	  sw $t2, -28($fp)	# spill _tmp3 from $t2 to $fp-28
	# PushParam _tmp3
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -28($fp)	# fill _tmp3 to $t0 from $fp-28
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L0:
	# _tmp4 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -32($fp)	# spill _tmp4 from $t2 to $fp-32
	# _tmp5 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -36($fp)	# spill _tmp5 from $t2 to $fp-36
	# _tmp6 = _tmp5 + _tmp0
	  lw $t0, -36($fp)	# fill _tmp5 to $t0 from $fp-36
	  lw $t1, -16($fp)	# fill _tmp0 to $t1 from $fp-16
	  add $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp6 from $t2 to $fp-40
	# _tmp7 = _tmp4 * _tmp6
	  lw $t0, -32($fp)	# fill _tmp4 to $t0 from $fp-32
	  lw $t1, -40($fp)	# fill _tmp6 to $t1 from $fp-40
	  mul $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp7 from $t2 to $fp-44
	# PushParam _tmp7
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -44($fp)	# fill _tmp7 to $t0 from $fp-44
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp8 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -48($fp)	# spill _tmp8 from $t2 to $fp-48
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp8) = _tmp0
	  lw $t0, -16($fp)	# fill _tmp0 to $t0 from $fp-16
	  lw $t2, -48($fp)	# fill _tmp8 to $t2 from $fp-48
	  sw $t0, 0($t2) 	# store with offset
	# _tmp9 = _tmp4 + _tmp8
	  lw $t0, -32($fp)	# fill _tmp4 to $t0 from $fp-32
	  lw $t1, -48($fp)	# fill _tmp8 to $t1 from $fp-48
	  add $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp9 from $t2 to $fp-52
	# x = _tmp9
	  lw $t2, -52($fp)	# fill _tmp9 to $t2 from $fp-52
	  sw $t2, -8($fp)	# spill x from $t2 to $fp-8
	# _tmp10 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -56($fp)	# spill _tmp10 from $t2 to $fp-56
	# _tmp11 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -60($fp)	# spill _tmp11 from $t2 to $fp-60
	# _tmp12 = *(x + -4)
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t2, -4($t0) 	# load with offset
	  sw $t2, -64($fp)	# spill _tmp12 from $t2 to $fp-64
	# _tmp13 = _tmp10 < _tmp12
	  lw $t0, -56($fp)	# fill _tmp10 to $t0 from $fp-56
	  lw $t1, -64($fp)	# fill _tmp12 to $t1 from $fp-64
	  slt $t2, $t0, $t1	
	  sw $t2, -68($fp)	# spill _tmp13 from $t2 to $fp-68
	# _tmp14 = _tmp13 == _tmp11
	  lw $t0, -68($fp)	# fill _tmp13 to $t0 from $fp-68
	  lw $t1, -60($fp)	# fill _tmp11 to $t1 from $fp-60
	  seq $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp14 from $t2 to $fp-72
	# _tmp15 = _tmp10 < _tmp11
	  lw $t0, -56($fp)	# fill _tmp10 to $t0 from $fp-56
	  lw $t1, -60($fp)	# fill _tmp11 to $t1 from $fp-60
	  slt $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp15 from $t2 to $fp-76
	# _tmp16 = _tmp15 || _tmp14
	  lw $t0, -76($fp)	# fill _tmp15 to $t0 from $fp-76
	  lw $t1, -72($fp)	# fill _tmp14 to $t1 from $fp-72
	  or $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp16 from $t2 to $fp-80
	# IfZ _tmp16 Goto _L1
	  lw $t0, -80($fp)	# fill _tmp16 to $t0 from $fp-80
	  beqz $t0, _L1	# branch if _tmp16 is zero 
	# _tmp17 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string2: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string2	# load label
	  sw $t2, -84($fp)	# spill _tmp17 from $t2 to $fp-84
	# PushParam _tmp17
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -84($fp)	# fill _tmp17 to $t0 from $fp-84
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L1:
	# _tmp18 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -88($fp)	# spill _tmp18 from $t2 to $fp-88
	# _tmp19 = _tmp10 * _tmp18
	  lw $t0, -56($fp)	# fill _tmp10 to $t0 from $fp-56
	  lw $t1, -88($fp)	# fill _tmp18 to $t1 from $fp-88
	  mul $t2, $t0, $t1	
	  sw $t2, -92($fp)	# spill _tmp19 from $t2 to $fp-92
	# _tmp20 = x + _tmp19
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, -92($fp)	# fill _tmp19 to $t1 from $fp-92
	  add $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp20 from $t2 to $fp-96
	# _tmp21 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -100($fp)	# spill _tmp21 from $t2 to $fp-100
	# *(_tmp20) = _tmp21
	  lw $t0, -100($fp)	# fill _tmp21 to $t0 from $fp-100
	  lw $t2, -96($fp)	# fill _tmp20 to $t2 from $fp-96
	  sw $t0, 0($t2) 	# store with offset
	# _tmp22 = 3
	  li $t2, 3		# load constant value 3 into $t2
	  sw $t2, -104($fp)	# spill _tmp22 from $t2 to $fp-104
	# y = _tmp22
	  lw $t2, -104($fp)	# fill _tmp22 to $t2 from $fp-104
	  sw $t2, -12($fp)	# spill y from $t2 to $fp-12
	# _tmp23 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -108($fp)	# spill _tmp23 from $t2 to $fp-108
	# _tmp24 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -112($fp)	# spill _tmp24 from $t2 to $fp-112
	# _tmp25 = *(x + -4)
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t2, -4($t0) 	# load with offset
	  sw $t2, -116($fp)	# spill _tmp25 from $t2 to $fp-116
	# _tmp26 = _tmp23 < _tmp25
	  lw $t0, -108($fp)	# fill _tmp23 to $t0 from $fp-108
	  lw $t1, -116($fp)	# fill _tmp25 to $t1 from $fp-116
	  slt $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp26 from $t2 to $fp-120
	# _tmp27 = _tmp26 == _tmp24
	  lw $t0, -120($fp)	# fill _tmp26 to $t0 from $fp-120
	  lw $t1, -112($fp)	# fill _tmp24 to $t1 from $fp-112
	  seq $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp27 from $t2 to $fp-124
	# _tmp28 = _tmp23 < _tmp24
	  lw $t0, -108($fp)	# fill _tmp23 to $t0 from $fp-108
	  lw $t1, -112($fp)	# fill _tmp24 to $t1 from $fp-112
	  slt $t2, $t0, $t1	
	  sw $t2, -128($fp)	# spill _tmp28 from $t2 to $fp-128
	# _tmp29 = _tmp28 || _tmp27
	  lw $t0, -128($fp)	# fill _tmp28 to $t0 from $fp-128
	  lw $t1, -124($fp)	# fill _tmp27 to $t1 from $fp-124
	  or $t2, $t0, $t1	
	  sw $t2, -132($fp)	# spill _tmp29 from $t2 to $fp-132
	# IfZ _tmp29 Goto _L2
	  lw $t0, -132($fp)	# fill _tmp29 to $t0 from $fp-132
	  beqz $t0, _L2	# branch if _tmp29 is zero 
	# _tmp30 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string3: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string3	# load label
	  sw $t2, -136($fp)	# spill _tmp30 from $t2 to $fp-136
	# PushParam _tmp30
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -136($fp)	# fill _tmp30 to $t0 from $fp-136
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L2:
	# _tmp31 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -140($fp)	# spill _tmp31 from $t2 to $fp-140
	# _tmp32 = _tmp23 * _tmp31
	  lw $t0, -108($fp)	# fill _tmp23 to $t0 from $fp-108
	  lw $t1, -140($fp)	# fill _tmp31 to $t1 from $fp-140
	  mul $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp32 from $t2 to $fp-144
	# _tmp33 = x + _tmp32
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, -144($fp)	# fill _tmp32 to $t1 from $fp-144
	  add $t2, $t0, $t1	
	  sw $t2, -148($fp)	# spill _tmp33 from $t2 to $fp-148
	# _tmp34 = *(_tmp33)
	  lw $t0, -148($fp)	# fill _tmp33 to $t0 from $fp-148
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -152($fp)	# spill _tmp34 from $t2 to $fp-152
	# _tmp35 = _tmp34 < y
	  lw $t0, -152($fp)	# fill _tmp34 to $t0 from $fp-152
	  lw $t1, -12($fp)	# fill y to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -156($fp)	# spill _tmp35 from $t2 to $fp-156
	# IfZ _tmp35 Goto _L3
	  lw $t0, -156($fp)	# fill _tmp35 to $t0 from $fp-156
	  beqz $t0, _L3	# branch if _tmp35 is zero 
	# _tmp36 = "Inside If\n"
	  .data			# create string constant marked with label
	  _string4: .asciiz "Inside If\n"
	  .text
	  la $t2, _string4	# load label
	  sw $t2, -160($fp)	# spill _tmp36 from $t2 to $fp-160
	# PushParam _tmp36
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -160($fp)	# fill _tmp36 to $t0 from $fp-160
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L4
	  b _L4		# unconditional branch
  _L3:
	# _tmp37 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -164($fp)	# spill _tmp37 from $t2 to $fp-164
	# _tmp38 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -168($fp)	# spill _tmp38 from $t2 to $fp-168
	# _tmp39 = *(x + -4)
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t2, -4($t0) 	# load with offset
	  sw $t2, -172($fp)	# spill _tmp39 from $t2 to $fp-172
	# _tmp40 = _tmp37 < _tmp39
	  lw $t0, -164($fp)	# fill _tmp37 to $t0 from $fp-164
	  lw $t1, -172($fp)	# fill _tmp39 to $t1 from $fp-172
	  slt $t2, $t0, $t1	
	  sw $t2, -176($fp)	# spill _tmp40 from $t2 to $fp-176
	# _tmp41 = _tmp40 == _tmp38
	  lw $t0, -176($fp)	# fill _tmp40 to $t0 from $fp-176
	  lw $t1, -168($fp)	# fill _tmp38 to $t1 from $fp-168
	  seq $t2, $t0, $t1	
	  sw $t2, -180($fp)	# spill _tmp41 from $t2 to $fp-180
	# _tmp42 = _tmp37 < _tmp38
	  lw $t0, -164($fp)	# fill _tmp37 to $t0 from $fp-164
	  lw $t1, -168($fp)	# fill _tmp38 to $t1 from $fp-168
	  slt $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp42 from $t2 to $fp-184
	# _tmp43 = _tmp42 || _tmp41
	  lw $t0, -184($fp)	# fill _tmp42 to $t0 from $fp-184
	  lw $t1, -180($fp)	# fill _tmp41 to $t1 from $fp-180
	  or $t2, $t0, $t1	
	  sw $t2, -188($fp)	# spill _tmp43 from $t2 to $fp-188
	# IfZ _tmp43 Goto _L5
	  lw $t0, -188($fp)	# fill _tmp43 to $t0 from $fp-188
	  beqz $t0, _L5	# branch if _tmp43 is zero 
	# _tmp44 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string5: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string5	# load label
	  sw $t2, -192($fp)	# spill _tmp44 from $t2 to $fp-192
	# PushParam _tmp44
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -192($fp)	# fill _tmp44 to $t0 from $fp-192
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L5:
	# _tmp45 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -196($fp)	# spill _tmp45 from $t2 to $fp-196
	# _tmp46 = _tmp37 * _tmp45
	  lw $t0, -164($fp)	# fill _tmp37 to $t0 from $fp-164
	  lw $t1, -196($fp)	# fill _tmp45 to $t1 from $fp-196
	  mul $t2, $t0, $t1	
	  sw $t2, -200($fp)	# spill _tmp46 from $t2 to $fp-200
	# _tmp47 = x + _tmp46
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, -200($fp)	# fill _tmp46 to $t1 from $fp-200
	  add $t2, $t0, $t1	
	  sw $t2, -204($fp)	# spill _tmp47 from $t2 to $fp-204
	# _tmp48 = *(_tmp47)
	  lw $t0, -204($fp)	# fill _tmp47 to $t0 from $fp-204
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -208($fp)	# spill _tmp48 from $t2 to $fp-208
	# _tmp49 = _tmp48 == y
	  lw $t0, -208($fp)	# fill _tmp48 to $t0 from $fp-208
	  lw $t1, -12($fp)	# fill y to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -212($fp)	# spill _tmp49 from $t2 to $fp-212
	# IfZ _tmp49 Goto _L6
	  lw $t0, -212($fp)	# fill _tmp49 to $t0 from $fp-212
	  beqz $t0, _L6	# branch if _tmp49 is zero 
	# _tmp50 = "Inside Else If\n"
	  .data			# create string constant marked with label
	  _string6: .asciiz "Inside Else If\n"
	  .text
	  la $t2, _string6	# load label
	  sw $t2, -216($fp)	# spill _tmp50 from $t2 to $fp-216
	# PushParam _tmp50
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -216($fp)	# fill _tmp50 to $t0 from $fp-216
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# Goto _L7
	  b _L7		# unconditional branch
  _L6:
	# _tmp51 = "Inside Else\n"
	  .data			# create string constant marked with label
	  _string7: .asciiz "Inside Else\n"
	  .text
	  la $t2, _string7	# load label
	  sw $t2, -220($fp)	# spill _tmp51 from $t2 to $fp-220
	# PushParam _tmp51
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -220($fp)	# fill _tmp51 to $t0 from $fp-220
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
  _L7:
  _L4:
	# _tmp52 = "After If\n"
	  .data			# create string constant marked with label
	  _string8: .asciiz "After If\n"
	  .text
	  la $t2, _string8	# load label
	  sw $t2, -224($fp)	# spill _tmp52 from $t2 to $fp-224
	# PushParam _tmp52
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -224($fp)	# fill _tmp52 to $t0 from $fp-224
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
	addi $t3, 1
	addi $t0, 1
	addi $t1, 1
	bne $t3,$t4,bloop3
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
	li $a1, 40
	la $a0, SPACE
	li $v0, 8
	syscall

	la $t1, SPACE
bloop4: 
	lb $t5, ($t1) 
	beqz $t5, eloop4	
	addi $t1, 1
	b bloop4
eloop4:
	addi $t1,-1
	li $t6,0
        sb $t6, ($t1)

	la $v0, SPACE
	move $sp, $fp         # pop callee frame off stack
	lw $ra, -4($fp)       # restore saved ra
	lw $fp, 0($fp)        # restore saved fp
	jr $ra
	

	.data
TRUE:.asciiz "true"
FALSE:.asciiz "false"
SPACE:.asciiz "Making Space For Inputed Values Is Fun."
