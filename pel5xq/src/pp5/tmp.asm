	# standard Decaf preamble 
	  .text
	  .align 2
	  .globl main
  _Cow.Init:
	# BeginFunc 0
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	# *(this + 8) = w
	  lw $t0, 8($fp)	# fill w to $t0 from $fp+8
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 8($t2) 	# store with offset
	# *(this + 4) = h
	  lw $t0, 12($fp)	# fill h to $t0 from $fp+12
	  lw $t2, 4($fp)	# fill this to $t2 from $fp+4
	  sw $t0, 4($t2) 	# store with offset
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
	# _tmp0 = *(this + 4)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -8($fp)	# spill _tmp0 from $t2 to $fp-8
	# PushParam _tmp0
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill _tmp0 to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp1 = " "
	  .data			# create string constant marked with label
	  _string1: .asciiz " "
	  .text
	  la $t2, _string1	# load label
	  sw $t2, -12($fp)	# spill _tmp1 from $t2 to $fp-12
	# PushParam _tmp1
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp1 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	  jal _PrintString   	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp2 = *(this + 8)
	  lw $t0, 4($fp)	# fill this to $t0 from $fp+4
	  lw $t2, 8($t0) 	# load with offset
	  sw $t2, -16($fp)	# spill _tmp2 from $t2 to $fp-16
	# PushParam _tmp2
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -16($fp)	# fill _tmp2 to $t0 from $fp-16
	  sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	  jal _PrintInt      	# jump to function
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp3 = "\n"
	  .data			# create string constant marked with label
	  _string2: .asciiz "\n"
	  .text
	  la $t2, _string2	# load label
	  sw $t2, -20($fp)	# spill _tmp3 from $t2 to $fp-20
	# PushParam _tmp3
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -20($fp)	# fill _tmp3 to $t0 from $fp-20
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
	  .word _Cow.Init
	  .word _Cow.Moo
	  .text
  main:
	# BeginFunc 40
	  subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	  sw $fp, 8($sp)	# save fp
	  sw $ra, 4($sp)	# save ra
	  addiu $fp, $sp, 8	# set up new fp
	  subu $sp, $sp, 40	# decrement sp to make space for locals/temps
	# _tmp4 = 12
	  li $t2, 12		# load constant value 12 into $t2
	  sw $t2, -12($fp)	# spill _tmp4 from $t2 to $fp-12
	# PushParam _tmp4
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -12($fp)	# fill _tmp4 to $t0 from $fp-12
	  sw $t0, 4($sp)	# copy param value to stack
	# _tmp5 = LCall _Alloc
	  jal _Alloc         	# jump to function
	  move $t2, $v0		# copy function return value from $v0
	  sw $t2, -16($fp)	# spill _tmp5 from $t2 to $fp-16
	# PopParams 4
	  add $sp, $sp, 4	# pop params off stack
	# _tmp6 = Cow
	  la $t2, Cow	# load label
	  sw $t2, -20($fp)	# spill _tmp6 from $t2 to $fp-20
	# *(_tmp5) = _tmp6
	  lw $t0, -20($fp)	# fill _tmp6 to $t0 from $fp-20
	  lw $t2, -16($fp)	# fill _tmp5 to $t2 from $fp-16
	  sw $t0, 0($t2) 	# store with offset
	# betsy = _tmp5
	  lw $t2, -16($fp)	# fill _tmp5 to $t2 from $fp-16
	  sw $t2, -8($fp)	# spill betsy from $t2 to $fp-8
	# _tmp7 = 100
	  li $t2, 100		# load constant value 100 into $t2
	  sw $t2, -24($fp)	# spill _tmp7 from $t2 to $fp-24
	# _tmp8 = 122
	  li $t2, 122		# load constant value 122 into $t2
	  sw $t2, -28($fp)	# spill _tmp8 from $t2 to $fp-28
	# _tmp9 = *(betsy)
	  lw $t0, -8($fp)	# fill betsy to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -32($fp)	# spill _tmp9 from $t2 to $fp-32
	# _tmp10 = *(_tmp9)
	  lw $t0, -32($fp)	# fill _tmp9 to $t0 from $fp-32
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -36($fp)	# spill _tmp10 from $t2 to $fp-36
	# PushParam _tmp8
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -28($fp)	# fill _tmp8 to $t0 from $fp-28
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam _tmp7
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -24($fp)	# fill _tmp7 to $t0 from $fp-24
	  sw $t0, 4($sp)	# copy param value to stack
	# PushParam betsy
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill betsy to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp10
	  lw $t0, -36($fp)	# fill _tmp10 to $t0 from $fp-36
	  jalr $t0            	# jump to function
	# PopParams 12
	  add $sp, $sp, 12	# pop params off stack
	# _tmp11 = *(betsy)
	  lw $t0, -8($fp)	# fill betsy to $t0 from $fp-8
	  lw $t2, 0($t0) 	# load with offset
	  sw $t2, -40($fp)	# spill _tmp11 from $t2 to $fp-40
	# _tmp12 = *(_tmp11 + 4)
	  lw $t0, -40($fp)	# fill _tmp11 to $t0 from $fp-40
	  lw $t2, 4($t0) 	# load with offset
	  sw $t2, -44($fp)	# spill _tmp12 from $t2 to $fp-44
	# PushParam betsy
	  subu $sp, $sp, 4	# decrement sp to make space for param
	  lw $t0, -8($fp)	# fill betsy to $t0 from $fp-8
	  sw $t0, 4($sp)	# copy param value to stack
	# ACall _tmp12
	  lw $t0, -44($fp)	# fill _tmp12 to $t0 from $fp-44
	  jalr $t0            	# jump to function
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

