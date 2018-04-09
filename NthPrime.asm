#------- Data Segment ----------
.data
# Define the string messages and the primes array
mesg1:		.asciiz "Please enter an integer number(range: 1~100, enter 0 to end the program):"
mesg2:		.asciiz "-th prime is:"
mesg3: 		.asciiz "Sorry, input range should be 1~100.\n"
newline:	.asciiz "\n"

primes: 	.word 0:100
	
#------- Text Segment ----------
.text 
.globl main
main:
	# Put 2 as the 1st element in primes array
	addi	$t1, $zero, 2
	la	$t2, primes
	sw	$t1, 0($t2) 
	
ask_input:
	# Print starting message to ask input
	la 	$a0 mesg1						
	li 	$v0 4
	syscall					

	# $s0 stores the input integer
	li 	$v0, 5
	syscall	
	addi 	$s0, $v0, 0					

	# if input integer is 0, then end the program
	beq 	$s0, $zero, endmain
	
	# if input integer is larger than 100, then ask another input
	addi	$t1, $zero, 101
	slt 	$t2, $s0, $t1
	bne	$t2, $zero, start
	la 	$a0 mesg3						
	li 	$v0 4
	syscall	
	j	ask_input
		
start:	  
	# Otherwise, call nth_prime procedure to calculate n-th prime, $a0=n
	addi 	$a0, $s0, 0
	jal 	FindNthPrime	# FindNthPrime is what you should implement	  
	# $t0 stores the calculated n-th prime   
	addi 	$t0, $v0, 0  

	# Print result message and result of n-th prime
	addi 	$a0, $s0, 0
	li 	$v0, 1
	syscall	 
	la 	$a0, mesg2 
	li 	$v0, 4
	syscall				
	addi 	$a0, $t0, 0
	li 	$v0, 1
	syscall				
	la 	$a0, newline
	li 	$v0, 4
	syscall	

	# Another loop 
	j 	ask_input

# Terminate the program
endmain:
	li    	$v0, 10     	
	syscall 

# Implement function FindNthPrime
# What FindNthPrime should do: calculate n-th prime, $a0=n, return n-th prime in $v0	
FindNthPrime:
# TODO below 
	bnez $s1, search # skip init s1 if set already
	# init s1 = num of current found primes
	addi $s1, $zero, 1 # "2"
	sle $t0, $a0, $s1
	bnez $t0, found # skip search if found already
	search:
		addi $t0, $s1, -1
		sll $t0, $t0, 2
		lw $t0, primes($t0)
		addi $t0, $t0, 1 # t0 = j = primes[cnt-1]+1
		jLoop:
			slt $t1, $s1, $a0 # t1 = cnt < num
			beqz $t1, found # end loop if false
			addi $sp, $sp, -4
			sw $a0, 0($sp)
			addi $sp, $sp, -4
			sw $t0, 0($sp)
			addi $sp, $sp, -4
			sw $ra, 0($sp)
			addi $a0, $t0, 0
			jal is_prime
			lw $ra, 0($sp)
			addi $sp, $sp, 4
			lw $t0, 0($sp)
			addi $sp, $sp ,4
			lw $a0, 0($sp)
			addi $sp, $sp ,4
			beqz $v0, jLoopEnd # skip storing j if not prime
			# store j in prime array
			sll $t1, $s1, 2 # t1 = cnt * 4
			sw $t0, primes($t1)
			addi $s1, $s1, 1 # cnt += 1
		jLoopEnd:
			addi $t0, $t0, 1 # j += 1
			j jLoop
	found:
		addi $t0, $a0, -1
		sll $t0, $t0, 2 # $t0 = (n-1) * 4
		lw $v0, primes($t0) # $t0 = nth prime
		addi $s1, $zero, 0 # reset s1 to 0
		jr $ra
# TODO above


# Implement function is_prime, which would be used in FindNthPrime function
# What is_prime should do: Given a value in $a0, check whether it is a prime
# if $a0 is prime, then return $v0=1, otherwise, return $v0=0
is_prime:
# TODO below
	addi $t0, $zero, 2 # $t0 = i = 2
	div $t1, $a0, 2
	addi $t1, $t1, 1 # $t1 = num / 2 + 1
	iLoop:
		sle $t2, $t0, $t1 # $t2 = i < num / 2 + 1
		beqz $t2, isPrimeEnd # jump if false
		addi $a1, $a0, 0 # set $a1 = $a0 = num
		addi $a2, $t0, 0 # set $s2 = $t0 = i
		addi $sp, $sp, -4
		sw $ra, 0($sp) # push $ra to stash
		jal Remainder
		lw $ra, 0($sp)
		addi $sp, $sp, 4 # pop $ra from stash
		beqz $v1, isNotPrime # remainder = 0, return false
	iLoopEnd:
		addi $t0, $t0, 1 # i = i + 1
		j iLoop
	isNotPrime:
		addi $v0, $zero, 0 # return false
		jr $ra
	isPrimeEnd:
		addi $v0, $zero, 1 # return true
		jr $ra
# TODO above



# Given value in $a1 and $a2, this function calculate the remainder of $a1 / $a2
# return remainder($a1 % $a2) in $v1  
Remainder: 
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	div	$a1, $a2
	mfhi	$v1
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
