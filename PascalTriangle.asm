#------- Data Segment ----------
.data

mesg: .asciiz "Please enter the row number(range:1~9) of Pascal Triangle(enter 0 to end the program):"
newline: .asciiz "\n"
space: .asciiz " "
doublespace: .asciiz "  "

#------- Text Segment ----------
.text 
.globl main
main:

	# Print starting message to ask for row number input
	la 	$a0 mesg						
	li 	$v0 4
	syscall					

	# $t0 stores number of lines to print
	li 	$v0, 5
	syscall					
	addi 	$t0, $v0, 0			

	# if input integer is 0, then end the program
	beq 	$t0, $zero, endprogram

	addi 	$t1, $zero, 0			# i = 0
	addi 	$t2, $zero, 0			# j = 0
        
        # $t4 indicates whether row number is smaller than 6 (2-digit number appears from row 6)
	slti 	$t4, $t0, 6	
			
LWhile:
	beq 	$t1, $t0, main
	sub 	$t3, $t0, $t1
	addi 	$t3, $t3, -1
	j 	Spacesfor
	
Spacesfor:	 
	beq 	$t3, $t2, endSpaces		# j = lines-1-i
	
	beq 	$t4, $zero, DoubleSpace	
	
	li 	$v0, 4				# print space
	la 	$a0, space
	syscall
	j 	NextSpaceLoop
	
	DoubleSpace:
	li 	$v0, 4				# print double space
	la 	$a0, doublespace
	syscall
	
	NextSpaceLoop:
	addi 	$t2, $t2, 1			# j++
	j 	Spacesfor
endSpaces:
	addi 	$t2, $zero, 0
	j 	Pascalfor
	
Pascalfor:
	bgt 	$t2, $t1, endpfor
	
	addi 	$a0, $t1, 0			# $a0 = i
	addi 	$a1, $t2, 0			# $a1 = j
	
	jal 	pascal		# pascal function is what you should implement	
	
	beq 	$t4, $zero, RowNumNotSmallerThanSix
	
	# print int
	addi 	$a0, $v0, 0
	li 	$v0, 1
	syscall				
	
	# print a space
	li 	$v0, 4
	la 	$a0, space
	syscall				
	
	j NextPascalLoop
	
RowNumNotSmallerThanSix:
	addi 	$t5, $v0, 0			# move result to $t5
	
	slti 	$t6, $t5, 10
	beq 	$t6, $zero, PrintNum 
	li 	$v0, 4
	la 	$a0, space
	syscall					# print a space
	
PrintNum:
	addi 	$a0, $t5, 0			# move result to $a0
	li 	$v0, 1
	syscall					# print int
	
	li 	$v0, 4
	la 	$a0, doublespace
	syscall					# print double space
	
NextPascalLoop:
	addi 	$t2, $t2, 1			# j++
	j Pascalfor
		
endpfor:
	li 	$v0, 4				# print new line
	la 	$a0, newline
	syscall
	
	addi 	$t1, $t1, 1			# i++
	addi 	$t2, $zero, 0
	
	j 	LWhile
	
endprogram:
	addi     $v0, $zero, 10     		# System call code 10 for exit
	syscall 


# Implement pascal function
# What pascal function should do: given row number $a0, column number $a1, calculate C(row, col)
# C(row,col) = C(row-1, col-1) + C(row-1, col)
# return C(row col) in $v0					
pascal:
# TODO below
	# stop case: col = 0
	beqz $a1, returnOne
	
	# stop case: row = col
	beq $a0, $a1, returnOne

	# stash t0, t1
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	
	# divide
	addi $sp, $sp, -4
	sw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $a1, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $a0, $a0, -1 # a0 = row - 1
	addi $a1, $a1, -1 # a1 = col - 1
	jal pascal
	addi $t0, $v0, 0 # save t0 = C(row-1, col-1)
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $a1, 0($sp)
	addi $sp, $sp, 4
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $a0, $a0, -1 # a0 = row - 1; a1 = col, no change
	jal pascal
	addi $t1, $v0, 0 # save t1 = C(row-1, col)
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	
	# conquer
	add $v0, $t0, $t1
	
	# revert t0,t1
	lw $t1, 0($sp)
	addi $sp, $sp, 4
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
	returnOne:
		addi $v0, $zero, 1
		jr $ra
# TODO above
