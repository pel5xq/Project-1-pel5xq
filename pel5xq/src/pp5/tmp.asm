	# standard Decaf preamble 
	  .text
	  .align 2
	  .globl main
  main:
	# BeginFunc 288
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 288	# decrement sp to make space for locals/temps
	# _tmp0 = 5
	  li $t2, 5		# load constant value 5 into $t2
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
	# _tmp10 = 5
	  li $t2, 5		# load constant value 5 into $t2
	  sw $t2, -56($fp)	# spill _tmp10 from $t2 to $fp-56
	# y = _tmp10
	  lw $t2, -56($fp)	# fill _tmp10 to $t2 from $fp-56
	  sw $t2, -12($fp)	# spill y from $t2 to $fp-12
	# _tmp11 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -60($fp)	# spill _tmp11 from $t2 to $fp-60
	# _tmp12 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -64($fp)	# spill _tmp12 from $t2 to $fp-64
	# _tmp13 = *(x + -4)
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t2, -4($t0) 	# load with offset
	  sw $t2, -68($fp)	# spill _tmp13 from $t2 to $fp-68
	# _tmp14 = _tmp11 < _tmp13
	  lw $t0, -60($fp)	# fill _tmp11 to $t0 from $fp-60
	  lw $t1, -68($fp)	# fill _tmp13 to $t1 from $fp-68
	  slt $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp14 from $t2 to $fp-72
	# _tmp15 = _tmp14 == _tmp12
	  lw $t0, -72($fp)	# fill _tmp14 to $t0 from $fp-72
	  lw $t1, -64($fp)	# fill _tmp12 to $t1 from $fp-64
	  seq $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp15 from $t2 to $fp-76
	# _tmp16 = _tmp11 < _tmp12
	  lw $t0, -60($fp)	# fill _tmp11 to $t0 from $fp-60
	  lw $t1, -64($fp)	# fill _tmp12 to $t1 from $fp-64
	  slt $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp16 from $t2 to $fp-80
	# _tmp17 = _tmp16 || _tmp15
	  lw $t0, -80($fp)	# fill _tmp16 to $t0 from $fp-80
	  lw $t1, -76($fp)	# fill _tmp15 to $t1 from $fp-76
	  or $t2, $t0, $t1	
	  sw $t2, -84($fp)	# spill _tmp17 from $t2 to $fp-84
	# IfZ _tmp17 Goto _L1
	  lw $t0, -84($fp)	# fill _tmp17 to $t0 from $fp-84
	  beqz $t0, _L1	# branch if _tmp17 is zero 
	# _tmp18 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string2: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string2	# load label
	  sw $t2, -88($fp)	# spill _tmp18 from $t2 to $fp-88
	# PushParam _tmp18
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -88($fp)	# fill _tmp18 to $t0 from $fp-88
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L1:
	# _tmp19 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -92($fp)	# spill _tmp19 from $t2 to $fp-92
	# _tmp20 = _tmp11 * _tmp19
	  lw $t0, -60($fp)	# fill _tmp11 to $t0 from $fp-60
	  lw $t1, -92($fp)	# fill _tmp19 to $t1 from $fp-92
	  mul $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp20 from $t2 to $fp-96
	# _tmp21 = x + _tmp20
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, -96($fp)	# fill _tmp20 to $t1 from $fp-96
	  add $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp21 from $t2 to $fp-100
	# _tmp22 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -104($fp)	# spill _tmp22 from $t2 to $fp-104
	# *(_tmp21) = _tmp22
	  lw $t0, -104($fp)	# fill _tmp22 to $t0 from $fp-104
	  lw $t2, -100($fp)	# fill _tmp21 to $t2 from $fp-100
	  sw $t0, 0($t2) 	# store with offset
	# PushParam y
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill y to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
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
	# PushParam _tmp34
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -152($fp)	# fill _tmp34 to $t0 from $fp-152
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp35 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -156($fp)	# spill _tmp35 from $t2 to $fp-156
	# _tmp36 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -160($fp)	# spill _tmp36 from $t2 to $fp-160
	# _tmp37 = *(x + -4)
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t2, -4($t0) 	# load with offset
	  sw $t2, -164($fp)	# spill _tmp37 from $t2 to $fp-164
	# _tmp38 = _tmp35 < _tmp37
	  lw $t0, -156($fp)	# fill _tmp35 to $t0 from $fp-156
	  lw $t1, -164($fp)	# fill _tmp37 to $t1 from $fp-164
	  slt $t2, $t0, $t1	
	  sw $t2, -168($fp)	# spill _tmp38 from $t2 to $fp-168
	# _tmp39 = _tmp38 == _tmp36
	  lw $t0, -168($fp)	# fill _tmp38 to $t0 from $fp-168
	  lw $t1, -160($fp)	# fill _tmp36 to $t1 from $fp-160
	  seq $t2, $t0, $t1	
	  sw $t2, -172($fp)	# spill _tmp39 from $t2 to $fp-172
	# _tmp40 = _tmp35 < _tmp36
	  lw $t0, -156($fp)	# fill _tmp35 to $t0 from $fp-156
	  lw $t1, -160($fp)	# fill _tmp36 to $t1 from $fp-160
	  slt $t2, $t0, $t1	
	  sw $t2, -176($fp)	# spill _tmp40 from $t2 to $fp-176
	# _tmp41 = _tmp40 || _tmp39
	  lw $t0, -176($fp)	# fill _tmp40 to $t0 from $fp-176
	  lw $t1, -172($fp)	# fill _tmp39 to $t1 from $fp-172
	  or $t2, $t0, $t1	
	  sw $t2, -180($fp)	# spill _tmp41 from $t2 to $fp-180
	# IfZ _tmp41 Goto _L3
	  lw $t0, -180($fp)	# fill _tmp41 to $t0 from $fp-180
	  beqz $t0, _L3	# branch if _tmp41 is zero 
	# _tmp42 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string4: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string4	# load label
	  sw $t2, -184($fp)	# spill _tmp42 from $t2 to $fp-184
	# PushParam _tmp42
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -184($fp)	# fill _tmp42 to $t0 from $fp-184
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L3:
	# _tmp43 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -188($fp)	# spill _tmp43 from $t2 to $fp-188
	# _tmp44 = _tmp35 * _tmp43
	  lw $t0, -156($fp)	# fill _tmp35 to $t0 from $fp-156
	  lw $t1, -188($fp)	# fill _tmp43 to $t1 from $fp-188
	  mul $t2, $t0, $t1	
	  sw $t2, -192($fp)	# spill _tmp44 from $t2 to $fp-192
	# _tmp45 = x + _tmp44
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, -192($fp)	# fill _tmp44 to $t1 from $fp-192
	  add $t2, $t0, $t1	
	  sw $t2, -196($fp)	# spill _tmp45 from $t2 to $fp-196
	# _tmp46 = *(_tmp45)
	  lw $t0, -196($fp)	# fill _tmp45 to $t0 from $fp-196
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -200($fp)	# spill _tmp46 from $t2 to $fp-200
	# y = _tmp46
	  lw $t2, -200($fp)	# fill _tmp46 to $t2 from $fp-200
	  sw $t2, -12($fp)	# spill y from $t2 to $fp-12
	# _tmp47 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -204($fp)	# spill _tmp47 from $t2 to $fp-204
	# _tmp48 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -208($fp)	# spill _tmp48 from $t2 to $fp-208
	# _tmp49 = *(x + -4)
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t2, -4($t0) 	# load with offset
	  sw $t2, -212($fp)	# spill _tmp49 from $t2 to $fp-212
	# _tmp50 = _tmp47 < _tmp49
	  lw $t0, -204($fp)	# fill _tmp47 to $t0 from $fp-204
	  lw $t1, -212($fp)	# fill _tmp49 to $t1 from $fp-212
	  slt $t2, $t0, $t1	
	  sw $t2, -216($fp)	# spill _tmp50 from $t2 to $fp-216
	# _tmp51 = _tmp50 == _tmp48
	  lw $t0, -216($fp)	# fill _tmp50 to $t0 from $fp-216
	  lw $t1, -208($fp)	# fill _tmp48 to $t1 from $fp-208
	  seq $t2, $t0, $t1	
	  sw $t2, -220($fp)	# spill _tmp51 from $t2 to $fp-220
	# _tmp52 = _tmp47 < _tmp48
	  lw $t0, -204($fp)	# fill _tmp47 to $t0 from $fp-204
	  lw $t1, -208($fp)	# fill _tmp48 to $t1 from $fp-208
	  slt $t2, $t0, $t1	
	  sw $t2, -224($fp)	# spill _tmp52 from $t2 to $fp-224
	# _tmp53 = _tmp52 || _tmp51
	  lw $t0, -224($fp)	# fill _tmp52 to $t0 from $fp-224
	  lw $t1, -220($fp)	# fill _tmp51 to $t1 from $fp-220
	  or $t2, $t0, $t1	
	  sw $t2, -228($fp)	# spill _tmp53 from $t2 to $fp-228
	# IfZ _tmp53 Goto _L4
	  lw $t0, -228($fp)	# fill _tmp53 to $t0 from $fp-228
	  beqz $t0, _L4	# branch if _tmp53 is zero 
	# _tmp54 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string5: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string5	# load label
	  sw $t2, -232($fp)	# spill _tmp54 from $t2 to $fp-232
	# PushParam _tmp54
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -232($fp)	# fill _tmp54 to $t0 from $fp-232
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L4:
	# _tmp55 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -236($fp)	# spill _tmp55 from $t2 to $fp-236
	# _tmp56 = _tmp47 * _tmp55
	  lw $t0, -204($fp)	# fill _tmp47 to $t0 from $fp-204
	  lw $t1, -236($fp)	# fill _tmp55 to $t1 from $fp-236
	  mul $t2, $t0, $t1	
	  sw $t2, -240($fp)	# spill _tmp56 from $t2 to $fp-240
	# _tmp57 = x + _tmp56
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, -240($fp)	# fill _tmp56 to $t1 from $fp-240
	  add $t2, $t0, $t1	
	  sw $t2, -244($fp)	# spill _tmp57 from $t2 to $fp-244
	# *(_tmp57) = y
	  lw $t0, -12($fp)	# fill y to $t0 from $fp-12
	  lw $t2, -244($fp)	# fill _tmp57 to $t2 from $fp-244
	  sw $t0, 0($t2) 	# store with offset
	# PushParam y
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill y to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp58 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -248($fp)	# spill _tmp58 from $t2 to $fp-248
	# _tmp59 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -252($fp)	# spill _tmp59 from $t2 to $fp-252
	# _tmp60 = *(x + -4)
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t2, -4($t0) 	# load with offset
	  sw $t2, -256($fp)	# spill _tmp60 from $t2 to $fp-256
	# _tmp61 = _tmp58 < _tmp60
	  lw $t0, -248($fp)	# fill _tmp58 to $t0 from $fp-248
	  lw $t1, -256($fp)	# fill _tmp60 to $t1 from $fp-256
	  slt $t2, $t0, $t1	
	  sw $t2, -260($fp)	# spill _tmp61 from $t2 to $fp-260
	# _tmp62 = _tmp61 == _tmp59
	  lw $t0, -260($fp)	# fill _tmp61 to $t0 from $fp-260
	  lw $t1, -252($fp)	# fill _tmp59 to $t1 from $fp-252
	  seq $t2, $t0, $t1	
	  sw $t2, -264($fp)	# spill _tmp62 from $t2 to $fp-264
	# _tmp63 = _tmp58 < _tmp59
	  lw $t0, -248($fp)	# fill _tmp58 to $t0 from $fp-248
	  lw $t1, -252($fp)	# fill _tmp59 to $t1 from $fp-252
	  slt $t2, $t0, $t1	
	  sw $t2, -268($fp)	# spill _tmp63 from $t2 to $fp-268
	# _tmp64 = _tmp63 || _tmp62
	  lw $t0, -268($fp)	# fill _tmp63 to $t0 from $fp-268
	  lw $t1, -264($fp)	# fill _tmp62 to $t1 from $fp-264
	  or $t2, $t0, $t1	
	  sw $t2, -272($fp)	# spill _tmp64 from $t2 to $fp-272
	# IfZ _tmp64 Goto _L5
	  lw $t0, -272($fp)	# fill _tmp64 to $t0 from $fp-272
	  beqz $t0, _L5	# branch if _tmp64 is zero 
	# _tmp65 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string6: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string6	# load label
	  sw $t2, -276($fp)	# spill _tmp65 from $t2 to $fp-276
	# PushParam _tmp65
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -276($fp)	# fill _tmp65 to $t0 from $fp-276
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L5:
	# _tmp66 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -280($fp)	# spill _tmp66 from $t2 to $fp-280
	# _tmp67 = _tmp58 * _tmp66
	  lw $t0, -248($fp)	# fill _tmp58 to $t0 from $fp-248
	  lw $t1, -280($fp)	# fill _tmp66 to $t1 from $fp-280
	  mul $t2, $t0, $t1	
	  sw $t2, -284($fp)	# spill _tmp67 from $t2 to $fp-284
	# _tmp68 = x + _tmp67
	  lw $t0, -8($fp)	# fill x to $t0 from $fp-8
	  lw $t1, -284($fp)	# fill _tmp67 to $t1 from $fp-284
	  add $t2, $t0, $t1	
	  sw $t2, -288($fp)	# spill _tmp68 from $t2 to $fp-288
	# _tmp69 = *(_tmp68)
	  lw $t0, -288($fp)	# fill _tmp68 to $t0 from $fp-288
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -292($fp)	# spill _tmp69 from $t2 to $fp-292
	# PushParam _tmp69
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -292($fp)	# fill _tmp69 to $t0 from $fp-292
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
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
