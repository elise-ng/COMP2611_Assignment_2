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

	

			
						
												
# TODO above


# Implement function is_prime, which would be used in FindNthPrime function
# What is_prime should do: Given a value in $a0, check whether it is a prime
# if $a0 is prime, then return $v0=1, otherwise, return $v0=0
is_prime:
# TODO below
	
	
	
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
