	# standard Decaf preamble 
	  .text
	  .align 2
	  .globl main
  _ReadArray:
	# BeginFunc 132
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 132	# decrement sp to make space for locals/temps
	# _tmp0 = "How many scores? "
	  .data			# create string constant marked with label
	  _string1: .asciiz "How many scores? "
	  .text
	  la $t2, _string1	# load label
	  sw $t2, -24($fp)	# spill _tmp0 from $t2 to $fp-24
	# PushParam _tmp0
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -24($fp)	# fill _tmp0 to $t0 from $fp-24
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp1 = LCall _ReadInteger
	  jal _ReadInteger   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -28($fp)	# spill _tmp1 from $t2 to $fp-28
	# numScores = _tmp1
	  lw $t2, -28($fp)	# fill _tmp1 to $t2 from $fp-28
	  sw $t2, -20($fp)	# spill numScores from $t2 to $fp-20
	# _tmp2 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -32($fp)	# spill _tmp2 from $t2 to $fp-32
	# _tmp3 = numScores < _tmp2
	  lw $t0, -20($fp)	# fill numScores to $t0 from $fp-20
	  lw $t1, -32($fp)	# fill _tmp2 to $t1 from $fp-32
	  slt $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp3 from $t2 to $fp-36
	# IfZ _tmp3 Goto _L0
	  lw $t0, -36($fp)	# fill _tmp3 to $t0 from $fp-36
	  beqz $t0, _L0	# branch if _tmp3 is zero 
	# _tmp4 = "Decaf runtime error: Array size is <= 0\n"
	  .data			# create string constant marked with label
	  _string2: .asciiz "Decaf runtime error: Array size is <= 0\n"
	  .text
	  la $t2, _string2	# load label
	  sw $t2, -40($fp)	# spill _tmp4 from $t2 to $fp-40
	# PushParam _tmp4
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -40($fp)	# fill _tmp4 to $t0 from $fp-40
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L0:
	# _tmp5 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -44($fp)	# spill _tmp5 from $t2 to $fp-44
	# _tmp6 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -48($fp)	# spill _tmp6 from $t2 to $fp-48
	# _tmp7 = _tmp6 + numScores
	  lw $t0, -48($fp)	# fill _tmp6 to $t0 from $fp-48
	  lw $t1, -20($fp)	# fill numScores to $t1 from $fp-20
	  add $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp7 from $t2 to $fp-52
	# _tmp8 = _tmp5 * _tmp7
	  lw $t0, -44($fp)	# fill _tmp5 to $t0 from $fp-44
	  lw $t1, -52($fp)	# fill _tmp7 to $t1 from $fp-52
	  mul $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp8 from $t2 to $fp-56
	# PushParam _tmp8
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -56($fp)	# fill _tmp8 to $t0 from $fp-56
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp9 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -60($fp)	# spill _tmp9 from $t2 to $fp-60
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# *(_tmp9) = numScores
	  lw $t0, -20($fp)	# fill numScores to $t0 from $fp-20
	  lw $t2, -60($fp)	# fill _tmp9 to $t2 from $fp-60
	  sw $t0, 0($t2) 	# store with offset
	# _tmp10 = _tmp5 + _tmp9
	  lw $t0, -44($fp)	# fill _tmp5 to $t0 from $fp-44
	  lw $t1, -60($fp)	# fill _tmp9 to $t1 from $fp-60
	  add $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp10 from $t2 to $fp-64
	# arr = _tmp10
	  lw $t2, -64($fp)	# fill _tmp10 to $t2 from $fp-64
	  sw $t2, -16($fp)	# spill arr from $t2 to $fp-16
	# _tmp11 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -68($fp)	# spill _tmp11 from $t2 to $fp-68
	# i = _tmp11
	  lw $t2, -68($fp)	# fill _tmp11 to $t2 from $fp-68
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L1:
	# _tmp12 = *(arr + -4)
	  lw $t0, -16($fp)	# fill arr to $t0 from $fp-16
	  lw $t2, -4($t0) 	# load with offset
	  sw $t2, -72($fp)	# spill _tmp12 from $t2 to $fp-72
	# _tmp13 = i < _tmp12
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -72($fp)	# fill _tmp12 to $t1 from $fp-72
	  slt $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp13 from $t2 to $fp-76
	# IfZ _tmp13 Goto _L2
	  lw $t0, -76($fp)	# fill _tmp13 to $t0 from $fp-76
	  beqz $t0, _L2	# branch if _tmp13 is zero 
	# _tmp14 = "Enter next number: "
	  .data			# create string constant marked with label
	  _string3: .asciiz "Enter next number: "
	  .text
	  la $t2, _string3	# load label
	  sw $t2, -80($fp)	# spill _tmp14 from $t2 to $fp-80
	# PushParam _tmp14
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -80($fp)	# fill _tmp14 to $t0 from $fp-80
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp15 = LCall _ReadInteger
	  jal _ReadInteger   	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -84($fp)	# spill _tmp15 from $t2 to $fp-84
	# num = _tmp15
	  lw $t2, -84($fp)	# fill _tmp15 to $t2 from $fp-84
	  sw $t2, -12($fp)	# spill num from $t2 to $fp-12
	# _tmp16 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -88($fp)	# spill _tmp16 from $t2 to $fp-88
	# _tmp17 = *(arr + -4)
	  lw $t0, -16($fp)	# fill arr to $t0 from $fp-16
	  lw $t2, -4($t0) 	# load with offset
	  sw $t2, -92($fp)	# spill _tmp17 from $t2 to $fp-92
	# _tmp18 = i < _tmp17
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -92($fp)	# fill _tmp17 to $t1 from $fp-92
	  slt $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp18 from $t2 to $fp-96
	# _tmp19 = _tmp18 == _tmp16
	  lw $t0, -96($fp)	# fill _tmp18 to $t0 from $fp-96
	  lw $t1, -88($fp)	# fill _tmp16 to $t1 from $fp-88
	  seq $t2, $t0, $t1	
	  sw $t2, -100($fp)	# spill _tmp19 from $t2 to $fp-100
	# _tmp20 = i < _tmp16
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -88($fp)	# fill _tmp16 to $t1 from $fp-88
	  slt $t2, $t0, $t1	
	  sw $t2, -104($fp)	# spill _tmp20 from $t2 to $fp-104
	# _tmp21 = _tmp20 || _tmp19
	  lw $t0, -104($fp)	# fill _tmp20 to $t0 from $fp-104
	  lw $t1, -100($fp)	# fill _tmp19 to $t1 from $fp-100
	  or $t2, $t0, $t1	
	  sw $t2, -108($fp)	# spill _tmp21 from $t2 to $fp-108
	# IfZ _tmp21 Goto _L3
	  lw $t0, -108($fp)	# fill _tmp21 to $t0 from $fp-108
	  beqz $t0, _L3	# branch if _tmp21 is zero 
	# _tmp22 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string4: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string4	# load label
	  sw $t2, -112($fp)	# spill _tmp22 from $t2 to $fp-112
	# PushParam _tmp22
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -112($fp)	# fill _tmp22 to $t0 from $fp-112
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L3:
	# _tmp23 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -116($fp)	# spill _tmp23 from $t2 to $fp-116
	# _tmp24 = i * _tmp23
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -116($fp)	# fill _tmp23 to $t1 from $fp-116
	  mul $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp24 from $t2 to $fp-120
	# _tmp25 = arr + _tmp24
	  lw $t0, -16($fp)	# fill arr to $t0 from $fp-16
	  lw $t1, -120($fp)	# fill _tmp24 to $t1 from $fp-120
	  add $t2, $t0, $t1	
	  sw $t2, -124($fp)	# spill _tmp25 from $t2 to $fp-124
	# *(_tmp25) = num
	  lw $t0, -12($fp)	# fill num to $t0 from $fp-12
	  lw $t2, -124($fp)	# fill _tmp25 to $t2 from $fp-124
	  sw $t0, 0($t2) 	# store with offset
	# _tmp26 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -128($fp)	# spill _tmp26 from $t2 to $fp-128
	# _tmp27 = i + _tmp26
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -128($fp)	# fill _tmp26 to $t1 from $fp-128
	  add $t2, $t0, $t1	
	  sw $t2, -132($fp)	# spill _tmp27 from $t2 to $fp-132
	# i = _tmp27
	  lw $t2, -132($fp)	# fill _tmp27 to $t2 from $fp-132
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L1
	  b _L1		# unconditional branch
  _L2:
	# _tmp28 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -136($fp)	# spill _tmp28 from $t2 to $fp-136
	# Return arr
	  lw $t2, -16($fp)	# fill arr to $t2 from $fp-16
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
  _Sort:
	# BeginFunc 308
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 308	# decrement sp to make space for locals/temps
	# _tmp29 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -20($fp)	# spill _tmp29 from $t2 to $fp-20
	# i = _tmp29
	  lw $t2, -20($fp)	# fill _tmp29 to $t2 from $fp-20
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
  _L4:
	# _tmp30 = *(arr + -4)
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t2, -4($t0) 	# load with offset
	  sw $t2, -24($fp)	# spill _tmp30 from $t2 to $fp-24
	# _tmp31 = i < _tmp30
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -24($fp)	# fill _tmp30 to $t1 from $fp-24
	  slt $t2, $t0, $t1	
	  sw $t2, -28($fp)	# spill _tmp31 from $t2 to $fp-28
	# IfZ _tmp31 Goto _L5
	  lw $t0, -28($fp)	# fill _tmp31 to $t0 from $fp-28
	  beqz $t0, _L5	# branch if _tmp31 is zero 
	# _tmp32 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -32($fp)	# spill _tmp32 from $t2 to $fp-32
	# _tmp33 = i - _tmp32
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -32($fp)	# fill _tmp32 to $t1 from $fp-32
	  sub $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp33 from $t2 to $fp-36
	# j = _tmp33
	  lw $t2, -36($fp)	# fill _tmp33 to $t2 from $fp-36
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
	# _tmp34 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -40($fp)	# spill _tmp34 from $t2 to $fp-40
	# _tmp35 = *(arr + -4)
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t2, -4($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp35 from $t2 to $fp-44
	# _tmp36 = i < _tmp35
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -44($fp)	# fill _tmp35 to $t1 from $fp-44
	  slt $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp36 from $t2 to $fp-48
	# _tmp37 = _tmp36 == _tmp34
	  lw $t0, -48($fp)	# fill _tmp36 to $t0 from $fp-48
	  lw $t1, -40($fp)	# fill _tmp34 to $t1 from $fp-40
	  seq $t2, $t0, $t1	
	  sw $t2, -52($fp)	# spill _tmp37 from $t2 to $fp-52
	# _tmp38 = i < _tmp34
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -40($fp)	# fill _tmp34 to $t1 from $fp-40
	  slt $t2, $t0, $t1	
	  sw $t2, -56($fp)	# spill _tmp38 from $t2 to $fp-56
	# _tmp39 = _tmp38 || _tmp37
	  lw $t0, -56($fp)	# fill _tmp38 to $t0 from $fp-56
	  lw $t1, -52($fp)	# fill _tmp37 to $t1 from $fp-52
	  or $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp39 from $t2 to $fp-60
	# IfZ _tmp39 Goto _L6
	  lw $t0, -60($fp)	# fill _tmp39 to $t0 from $fp-60
	  beqz $t0, _L6	# branch if _tmp39 is zero 
	# _tmp40 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string5: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string5	# load label
	  sw $t2, -64($fp)	# spill _tmp40 from $t2 to $fp-64
	# PushParam _tmp40
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -64($fp)	# fill _tmp40 to $t0 from $fp-64
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L6:
	# _tmp41 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -68($fp)	# spill _tmp41 from $t2 to $fp-68
	# _tmp42 = i * _tmp41
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -68($fp)	# fill _tmp41 to $t1 from $fp-68
	  mul $t2, $t0, $t1	
	  sw $t2, -72($fp)	# spill _tmp42 from $t2 to $fp-72
	# _tmp43 = arr + _tmp42
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t1, -72($fp)	# fill _tmp42 to $t1 from $fp-72
	  add $t2, $t0, $t1	
	  sw $t2, -76($fp)	# spill _tmp43 from $t2 to $fp-76
	# _tmp44 = *(_tmp43)
	  lw $t0, -76($fp)	# fill _tmp43 to $t0 from $fp-76
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -80($fp)	# spill _tmp44 from $t2 to $fp-80
	# val = _tmp44
	  lw $t2, -80($fp)	# fill _tmp44 to $t2 from $fp-80
	  sw $t2, -16($fp)	# spill val from $t2 to $fp-16
  _L7:
	# _tmp45 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -84($fp)	# spill _tmp45 from $t2 to $fp-84
	# _tmp46 = _tmp45 == j
	  lw $t0, -84($fp)	# fill _tmp45 to $t0 from $fp-84
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  seq $t2, $t0, $t1	
	  sw $t2, -88($fp)	# spill _tmp46 from $t2 to $fp-88
	# _tmp47 = _tmp45 < j
	  lw $t0, -84($fp)	# fill _tmp45 to $t0 from $fp-84
	  lw $t1, -12($fp)	# fill j to $t1 from $fp-12
	  slt $t2, $t0, $t1	
	  sw $t2, -92($fp)	# spill _tmp47 from $t2 to $fp-92
	# _tmp48 = _tmp47 || _tmp46
	  lw $t0, -92($fp)	# fill _tmp47 to $t0 from $fp-92
	  lw $t1, -88($fp)	# fill _tmp46 to $t1 from $fp-88
	  or $t2, $t0, $t1	
	  sw $t2, -96($fp)	# spill _tmp48 from $t2 to $fp-96
	# IfZ _tmp48 Goto _L8
	  lw $t0, -96($fp)	# fill _tmp48 to $t0 from $fp-96
	  beqz $t0, _L8	# branch if _tmp48 is zero 
	# _tmp49 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -100($fp)	# spill _tmp49 from $t2 to $fp-100
	# _tmp50 = *(arr + -4)
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t2, -4($t0) 	# load with offset
	  sw $t2, -104($fp)	# spill _tmp50 from $t2 to $fp-104
	# _tmp51 = j < _tmp50
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -104($fp)	# fill _tmp50 to $t1 from $fp-104
	  slt $t2, $t0, $t1	
	  sw $t2, -108($fp)	# spill _tmp51 from $t2 to $fp-108
	# _tmp52 = _tmp51 == _tmp49
	  lw $t0, -108($fp)	# fill _tmp51 to $t0 from $fp-108
	  lw $t1, -100($fp)	# fill _tmp49 to $t1 from $fp-100
	  seq $t2, $t0, $t1	
	  sw $t2, -112($fp)	# spill _tmp52 from $t2 to $fp-112
	# _tmp53 = j < _tmp49
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -100($fp)	# fill _tmp49 to $t1 from $fp-100
	  slt $t2, $t0, $t1	
	  sw $t2, -116($fp)	# spill _tmp53 from $t2 to $fp-116
	# _tmp54 = _tmp53 || _tmp52
	  lw $t0, -116($fp)	# fill _tmp53 to $t0 from $fp-116
	  lw $t1, -112($fp)	# fill _tmp52 to $t1 from $fp-112
	  or $t2, $t0, $t1	
	  sw $t2, -120($fp)	# spill _tmp54 from $t2 to $fp-120
	# IfZ _tmp54 Goto _L9
	  lw $t0, -120($fp)	# fill _tmp54 to $t0 from $fp-120
	  beqz $t0, _L9	# branch if _tmp54 is zero 
	# _tmp55 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string6: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string6	# load label
	  sw $t2, -124($fp)	# spill _tmp55 from $t2 to $fp-124
	# PushParam _tmp55
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -124($fp)	# fill _tmp55 to $t0 from $fp-124
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L9:
	# _tmp56 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -128($fp)	# spill _tmp56 from $t2 to $fp-128
	# _tmp57 = j * _tmp56
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -128($fp)	# fill _tmp56 to $t1 from $fp-128
	  mul $t2, $t0, $t1	
	  sw $t2, -132($fp)	# spill _tmp57 from $t2 to $fp-132
	# _tmp58 = arr + _tmp57
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t1, -132($fp)	# fill _tmp57 to $t1 from $fp-132
	  add $t2, $t0, $t1	
	  sw $t2, -136($fp)	# spill _tmp58 from $t2 to $fp-136
	# _tmp59 = *(_tmp58)
	  lw $t0, -136($fp)	# fill _tmp58 to $t0 from $fp-136
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -140($fp)	# spill _tmp59 from $t2 to $fp-140
	# _tmp60 = _tmp59 == val
	  lw $t0, -140($fp)	# fill _tmp59 to $t0 from $fp-140
	  lw $t1, -16($fp)	# fill val to $t1 from $fp-16
	  seq $t2, $t0, $t1	
	  sw $t2, -144($fp)	# spill _tmp60 from $t2 to $fp-144
	# _tmp61 = *(_tmp58)
	  lw $t0, -136($fp)	# fill _tmp58 to $t0 from $fp-136
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -148($fp)	# spill _tmp61 from $t2 to $fp-148
	# _tmp62 = _tmp61 < val
	  lw $t0, -148($fp)	# fill _tmp61 to $t0 from $fp-148
	  lw $t1, -16($fp)	# fill val to $t1 from $fp-16
	  slt $t2, $t0, $t1	
	  sw $t2, -152($fp)	# spill _tmp62 from $t2 to $fp-152
	# _tmp63 = _tmp62 || _tmp60
	  lw $t0, -152($fp)	# fill _tmp62 to $t0 from $fp-152
	  lw $t1, -144($fp)	# fill _tmp60 to $t1 from $fp-144
	  or $t2, $t0, $t1	
	  sw $t2, -156($fp)	# spill _tmp63 from $t2 to $fp-156
	# IfZ _tmp63 Goto _L10
	  lw $t0, -156($fp)	# fill _tmp63 to $t0 from $fp-156
	  beqz $t0, _L10	# branch if _tmp63 is zero 
	# Goto _L8
	  b _L8		# unconditional branch
  _L10:
	# _tmp64 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -160($fp)	# spill _tmp64 from $t2 to $fp-160
	# _tmp65 = j + _tmp64
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -160($fp)	# fill _tmp64 to $t1 from $fp-160
	  add $t2, $t0, $t1	
	  sw $t2, -164($fp)	# spill _tmp65 from $t2 to $fp-164
	# _tmp66 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -168($fp)	# spill _tmp66 from $t2 to $fp-168
	# _tmp67 = *(arr + -4)
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t2, -4($t0) 	# load with offset
	  sw $t2, -172($fp)	# spill _tmp67 from $t2 to $fp-172
	# _tmp68 = _tmp65 < _tmp67
	  lw $t0, -164($fp)	# fill _tmp65 to $t0 from $fp-164
	  lw $t1, -172($fp)	# fill _tmp67 to $t1 from $fp-172
	  slt $t2, $t0, $t1	
	  sw $t2, -176($fp)	# spill _tmp68 from $t2 to $fp-176
	# _tmp69 = _tmp68 == _tmp66
	  lw $t0, -176($fp)	# fill _tmp68 to $t0 from $fp-176
	  lw $t1, -168($fp)	# fill _tmp66 to $t1 from $fp-168
	  seq $t2, $t0, $t1	
	  sw $t2, -180($fp)	# spill _tmp69 from $t2 to $fp-180
	# _tmp70 = _tmp65 < _tmp66
	  lw $t0, -164($fp)	# fill _tmp65 to $t0 from $fp-164
	  lw $t1, -168($fp)	# fill _tmp66 to $t1 from $fp-168
	  slt $t2, $t0, $t1	
	  sw $t2, -184($fp)	# spill _tmp70 from $t2 to $fp-184
	# _tmp71 = _tmp70 || _tmp69
	  lw $t0, -184($fp)	# fill _tmp70 to $t0 from $fp-184
	  lw $t1, -180($fp)	# fill _tmp69 to $t1 from $fp-180
	  or $t2, $t0, $t1	
	  sw $t2, -188($fp)	# spill _tmp71 from $t2 to $fp-188
	# IfZ _tmp71 Goto _L11
	  lw $t0, -188($fp)	# fill _tmp71 to $t0 from $fp-188
	  beqz $t0, _L11	# branch if _tmp71 is zero 
	# _tmp72 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string7: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string7	# load label
	  sw $t2, -192($fp)	# spill _tmp72 from $t2 to $fp-192
	# PushParam _tmp72
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -192($fp)	# fill _tmp72 to $t0 from $fp-192
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L11:
	# _tmp73 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -196($fp)	# spill _tmp73 from $t2 to $fp-196
	# _tmp74 = _tmp65 * _tmp73
	  lw $t0, -164($fp)	# fill _tmp65 to $t0 from $fp-164
	  lw $t1, -196($fp)	# fill _tmp73 to $t1 from $fp-196
	  mul $t2, $t0, $t1	
	  sw $t2, -200($fp)	# spill _tmp74 from $t2 to $fp-200
	# _tmp75 = arr + _tmp74
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t1, -200($fp)	# fill _tmp74 to $t1 from $fp-200
	  add $t2, $t0, $t1	
	  sw $t2, -204($fp)	# spill _tmp75 from $t2 to $fp-204
	# _tmp76 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -208($fp)	# spill _tmp76 from $t2 to $fp-208
	# _tmp77 = *(arr + -4)
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t2, -4($t0) 	# load with offset
	  sw $t2, -212($fp)	# spill _tmp77 from $t2 to $fp-212
	# _tmp78 = j < _tmp77
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -212($fp)	# fill _tmp77 to $t1 from $fp-212
	  slt $t2, $t0, $t1	
	  sw $t2, -216($fp)	# spill _tmp78 from $t2 to $fp-216
	# _tmp79 = _tmp78 == _tmp76
	  lw $t0, -216($fp)	# fill _tmp78 to $t0 from $fp-216
	  lw $t1, -208($fp)	# fill _tmp76 to $t1 from $fp-208
	  seq $t2, $t0, $t1	
	  sw $t2, -220($fp)	# spill _tmp79 from $t2 to $fp-220
	# _tmp80 = j < _tmp76
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -208($fp)	# fill _tmp76 to $t1 from $fp-208
	  slt $t2, $t0, $t1	
	  sw $t2, -224($fp)	# spill _tmp80 from $t2 to $fp-224
	# _tmp81 = _tmp80 || _tmp79
	  lw $t0, -224($fp)	# fill _tmp80 to $t0 from $fp-224
	  lw $t1, -220($fp)	# fill _tmp79 to $t1 from $fp-220
	  or $t2, $t0, $t1	
	  sw $t2, -228($fp)	# spill _tmp81 from $t2 to $fp-228
	# IfZ _tmp81 Goto _L12
	  lw $t0, -228($fp)	# fill _tmp81 to $t0 from $fp-228
	  beqz $t0, _L12	# branch if _tmp81 is zero 
	# _tmp82 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string8: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string8	# load label
	  sw $t2, -232($fp)	# spill _tmp82 from $t2 to $fp-232
	# PushParam _tmp82
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -232($fp)	# fill _tmp82 to $t0 from $fp-232
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L12:
	# _tmp83 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -236($fp)	# spill _tmp83 from $t2 to $fp-236
	# _tmp84 = j * _tmp83
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -236($fp)	# fill _tmp83 to $t1 from $fp-236
	  mul $t2, $t0, $t1	
	  sw $t2, -240($fp)	# spill _tmp84 from $t2 to $fp-240
	# _tmp85 = arr + _tmp84
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t1, -240($fp)	# fill _tmp84 to $t1 from $fp-240
	  add $t2, $t0, $t1	
	  sw $t2, -244($fp)	# spill _tmp85 from $t2 to $fp-244
	# _tmp86 = *(_tmp85)
	  lw $t0, -244($fp)	# fill _tmp85 to $t0 from $fp-244
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -248($fp)	# spill _tmp86 from $t2 to $fp-248
	# *(_tmp75) = _tmp86
	  lw $t0, -248($fp)	# fill _tmp86 to $t0 from $fp-248
	  lw $t2, -204($fp)	# fill _tmp75 to $t2 from $fp-204
	  sw $t0, 0($t2) 	# store with offset
	# _tmp87 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -252($fp)	# spill _tmp87 from $t2 to $fp-252
	# _tmp88 = j - _tmp87
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -252($fp)	# fill _tmp87 to $t1 from $fp-252
	  sub $t2, $t0, $t1	
	  sw $t2, -256($fp)	# spill _tmp88 from $t2 to $fp-256
	# j = _tmp88
	  lw $t2, -256($fp)	# fill _tmp88 to $t2 from $fp-256
	  sw $t2, -12($fp)	# spill j from $t2 to $fp-12
	# Goto _L7
	  b _L7		# unconditional branch
  _L8:
	# _tmp89 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -260($fp)	# spill _tmp89 from $t2 to $fp-260
	# _tmp90 = j + _tmp89
	  lw $t0, -12($fp)	# fill j to $t0 from $fp-12
	  lw $t1, -260($fp)	# fill _tmp89 to $t1 from $fp-260
	  add $t2, $t0, $t1	
	  sw $t2, -264($fp)	# spill _tmp90 from $t2 to $fp-264
	# _tmp91 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -268($fp)	# spill _tmp91 from $t2 to $fp-268
	# _tmp92 = *(arr + -4)
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t2, -4($t0) 	# load with offset
	  sw $t2, -272($fp)	# spill _tmp92 from $t2 to $fp-272
	# _tmp93 = _tmp90 < _tmp92
	  lw $t0, -264($fp)	# fill _tmp90 to $t0 from $fp-264
	  lw $t1, -272($fp)	# fill _tmp92 to $t1 from $fp-272
	  slt $t2, $t0, $t1	
	  sw $t2, -276($fp)	# spill _tmp93 from $t2 to $fp-276
	# _tmp94 = _tmp93 == _tmp91
	  lw $t0, -276($fp)	# fill _tmp93 to $t0 from $fp-276
	  lw $t1, -268($fp)	# fill _tmp91 to $t1 from $fp-268
	  seq $t2, $t0, $t1	
	  sw $t2, -280($fp)	# spill _tmp94 from $t2 to $fp-280
	# _tmp95 = _tmp90 < _tmp91
	  lw $t0, -264($fp)	# fill _tmp90 to $t0 from $fp-264
	  lw $t1, -268($fp)	# fill _tmp91 to $t1 from $fp-268
	  slt $t2, $t0, $t1	
	  sw $t2, -284($fp)	# spill _tmp95 from $t2 to $fp-284
	# _tmp96 = _tmp95 || _tmp94
	  lw $t0, -284($fp)	# fill _tmp95 to $t0 from $fp-284
	  lw $t1, -280($fp)	# fill _tmp94 to $t1 from $fp-280
	  or $t2, $t0, $t1	
	  sw $t2, -288($fp)	# spill _tmp96 from $t2 to $fp-288
	# IfZ _tmp96 Goto _L13
	  lw $t0, -288($fp)	# fill _tmp96 to $t0 from $fp-288
	  beqz $t0, _L13	# branch if _tmp96 is zero 
	# _tmp97 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string9: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string9	# load label
	  sw $t2, -292($fp)	# spill _tmp97 from $t2 to $fp-292
	# PushParam _tmp97
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -292($fp)	# fill _tmp97 to $t0 from $fp-292
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L13:
	# _tmp98 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -296($fp)	# spill _tmp98 from $t2 to $fp-296
	# _tmp99 = _tmp90 * _tmp98
	  lw $t0, -264($fp)	# fill _tmp90 to $t0 from $fp-264
	  lw $t1, -296($fp)	# fill _tmp98 to $t1 from $fp-296
	  mul $t2, $t0, $t1	
	  sw $t2, -300($fp)	# spill _tmp99 from $t2 to $fp-300
	# _tmp100 = arr + _tmp99
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t1, -300($fp)	# fill _tmp99 to $t1 from $fp-300
	  add $t2, $t0, $t1	
	  sw $t2, -304($fp)	# spill _tmp100 from $t2 to $fp-304
	# *(_tmp100) = val
	  lw $t0, -16($fp)	# fill val to $t0 from $fp-16
	  lw $t2, -304($fp)	# fill _tmp100 to $t2 from $fp-304
	  sw $t0, 0($t2) 	# store with offset
	# _tmp101 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -308($fp)	# spill _tmp101 from $t2 to $fp-308
	# _tmp102 = i + _tmp101
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -308($fp)	# fill _tmp101 to $t1 from $fp-308
	  add $t2, $t0, $t1	
	  sw $t2, -312($fp)	# spill _tmp102 from $t2 to $fp-312
	# i = _tmp102
	  lw $t2, -312($fp)	# fill _tmp102 to $t2 from $fp-312
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L4
	  b _L4		# unconditional branch
  _L5:
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	  move $sp, $fp		# pop callee frame off stack
	  lw $ra, -4($fp)	# restore saved ra
	  lw $fp, 0($fp)	# restore saved fp
	  jr $ra		# return from function
  _PrintArray:
	# BeginFunc 80
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 80	# decrement sp to make space for locals/temps
	# _tmp103 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -12($fp)	# spill _tmp103 from $t2 to $fp-12
	# i = _tmp103
	  lw $t2, -12($fp)	# fill _tmp103 to $t2 from $fp-12
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# _tmp104 = "Sorted results: "
	  .data			# create string constant marked with label
	  _string10: .asciiz "Sorted results: "
	  .text
	  la $t2, _string10	# load label
	  sw $t2, -16($fp)	# spill _tmp104 from $t2 to $fp-16
	# PushParam _tmp104
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp104 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
  _L14:
	# _tmp105 = *(arr + -4)
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t2, -4($t0) 	# load with offset
	  sw $t2, -20($fp)	# spill _tmp105 from $t2 to $fp-20
	# _tmp106 = i < _tmp105
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -20($fp)	# fill _tmp105 to $t1 from $fp-20
	  slt $t2, $t0, $t1	
	  sw $t2, -24($fp)	# spill _tmp106 from $t2 to $fp-24
	# IfZ _tmp106 Goto _L15
	  lw $t0, -24($fp)	# fill _tmp106 to $t0 from $fp-24
	  beqz $t0, _L15	# branch if _tmp106 is zero 
	# _tmp107 = 0
	  li $t2, 0		# load constant value 0 into $t2
	  sw $t2, -28($fp)	# spill _tmp107 from $t2 to $fp-28
	# _tmp108 = *(arr + -4)
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t2, -4($t0) 	# load with offset
	  sw $t2, -32($fp)	# spill _tmp108 from $t2 to $fp-32
	# _tmp109 = i < _tmp108
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -32($fp)	# fill _tmp108 to $t1 from $fp-32
	  slt $t2, $t0, $t1	
	  sw $t2, -36($fp)	# spill _tmp109 from $t2 to $fp-36
	# _tmp110 = _tmp109 == _tmp107
	  lw $t0, -36($fp)	# fill _tmp109 to $t0 from $fp-36
	  lw $t1, -28($fp)	# fill _tmp107 to $t1 from $fp-28
	  seq $t2, $t0, $t1	
	  sw $t2, -40($fp)	# spill _tmp110 from $t2 to $fp-40
	# _tmp111 = i < _tmp107
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -28($fp)	# fill _tmp107 to $t1 from $fp-28
	  slt $t2, $t0, $t1	
	  sw $t2, -44($fp)	# spill _tmp111 from $t2 to $fp-44
	# _tmp112 = _tmp111 || _tmp110
	  lw $t0, -44($fp)	# fill _tmp111 to $t0 from $fp-44
	  lw $t1, -40($fp)	# fill _tmp110 to $t1 from $fp-40
	  or $t2, $t0, $t1	
	  sw $t2, -48($fp)	# spill _tmp112 from $t2 to $fp-48
	# IfZ _tmp112 Goto _L16
	  lw $t0, -48($fp)	# fill _tmp112 to $t0 from $fp-48
	  beqz $t0, _L16	# branch if _tmp112 is zero 
	# _tmp113 = "Decaf runtime error: Array subscript out of bound..."
	  .data			# create string constant marked with label
	  _string11: .asciiz "Decaf runtime error: Array subscript out of bounds\n"
	  .text
	  la $t2, _string11	# load label
	  sw $t2, -52($fp)	# spill _tmp113 from $t2 to $fp-52
	# PushParam _tmp113
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -52($fp)	# fill _tmp113 to $t0 from $fp-52
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# LCall _Halt
	  jal _Halt          	# jump to function
  _L16:
	# _tmp114 = 4
	  li $t2, 4		# load constant value 4 into $t2
	  sw $t2, -56($fp)	# spill _tmp114 from $t2 to $fp-56
	# _tmp115 = i * _tmp114
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -56($fp)	# fill _tmp114 to $t1 from $fp-56
	  mul $t2, $t0, $t1	
	  sw $t2, -60($fp)	# spill _tmp115 from $t2 to $fp-60
	# _tmp116 = arr + _tmp115
	  lw $t0, 4($fp)	# fill arr to $t0 from $fp+4
	  lw $t1, -60($fp)	# fill _tmp115 to $t1 from $fp-60
	  add $t2, $t0, $t1	
	  sw $t2, -64($fp)	# spill _tmp116 from $t2 to $fp-64
	# _tmp117 = *(_tmp116)
	  lw $t0, -64($fp)	# fill _tmp116 to $t0 from $fp-64
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -68($fp)	# spill _tmp117 from $t2 to $fp-68
	# PushParam _tmp117
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -68($fp)	# fill _tmp117 to $t0 from $fp-68
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp118 = " "
	  .data			# create string constant marked with label
	  _string12: .asciiz " "
	  .text
	  la $t2, _string12	# load label
	  sw $t2, -72($fp)	# spill _tmp118 from $t2 to $fp-72
	# PushParam _tmp118
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -72($fp)	# fill _tmp118 to $t0 from $fp-72
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp119 = 1
	  li $t2, 1		# load constant value 1 into $t2
	  sw $t2, -76($fp)	# spill _tmp119 from $t2 to $fp-76
	# _tmp120 = i + _tmp119
	  lw $t0, -8($fp)	# fill i to $t0 from $fp-8
	  lw $t1, -76($fp)	# fill _tmp119 to $t1 from $fp-76
	  add $t2, $t0, $t1	
	  sw $t2, -80($fp)	# spill _tmp120 from $t2 to $fp-80
	# i = _tmp120
	  lw $t2, -80($fp)	# fill _tmp120 to $t2 from $fp-80
	  sw $t2, -8($fp)	# spill i from $t2 to $fp-8
	# Goto _L14
	  b _L14		# unconditional branch
  _L15:
	# _tmp121 = "\n"
	  .data			# create string constant marked with label
	  _string13: .asciiz "\n"
	  .text
	  la $t2, _string13	# load label
	  sw $t2, -84($fp)	# spill _tmp121 from $t2 to $fp-84
	# PushParam _tmp121
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -84($fp)	# fill _tmp121 to $t0 from $fp-84
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
  main:
	# BeginFunc 16
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 16	# decrement sp to make space for locals/temps
	# _tmp122 = "\nThis program will read in a bunch of numbers an..."
	  .data			# create string constant marked with label
	  _string14: .asciiz "\nThis program will read in a bunch of numbers and print them\n"
	  .text
	  la $t2, _string14	# load label
	  sw $t2, -12($fp)	# spill _tmp122 from $t2 to $fp-12
	# PushParam _tmp122
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp122 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp123 = "back out in sorted order.\n\n"
	  .data			# create string constant marked with label
	  _string15: .asciiz "back out in sorted order.\n\n"
	  .text
	  la $t2, _string15	# load label
	  sw $t2, -16($fp)	# spill _tmp123 from $t2 to $fp-16
	# PushParam _tmp123
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp123 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp124 = LCall _ReadArray
	  jal _ReadArray     	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -20($fp)	# spill _tmp124 from $t2 to $fp-20
	# arr = _tmp124
	  lw $t2, -20($fp)	# fill _tmp124 to $t2 from $fp-20
	  sw $t2, -8($fp)	# spill arr from $t2 to $fp-8
	# PushParam arr
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill arr to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _Sort
	  jal _Sort          	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# PushParam arr
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill arr to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintArray
	  jal _PrintArray    	# jump to function
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

