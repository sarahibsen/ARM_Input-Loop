@ File: Arm program Quiz
@ Author: Sarah A Ibsen
@ Email: sai0002@uah.edu
@ Class: CS 413-01 Spring 2024
@ Purpose: To get us used to using ARM assembly.
@ we need to:
@		provide a welcome and instruction message
@		prompt the user to enter an int between 0 and 10
@		verify proper input value, reject any invalid inputs
@		Print "Hello World" the number of times the user entered
@		Each hello world should be on a separate line
@		Code is to exit once the require message is printed
@
@ Use these commands to assemble, link, run, and debug
@ the program.
@ as -o program1.o program1.s
@ gcc -o program1 program1.o
@ ./program1 ;echo $?
@ gdb --args ./program1

@ included a min and max so when the user inputs something
@ greater than 10 or less than 0, triggers the error message
.equ min, 0  @ Updated minimum value
.equ max, 10
.equ readerror, 0 

.global main

main:
    ldr r0, =welcomeMessage
    bl printf          @ Print welcome message

input_prompt:
    ldr r0, =instructionMessage
    bl printf          @ Print instruction message

    ldr r0, =numInputPattern  @ Setup the reg to read in one number
    ldr r1, =intInput         @ Load r1 with the address of intInput
    bl scanf                  @ Call scanf to get user input
    cmp r0, #readerror        @ Compare the return value to 0
    beq done	              @ If less than 1, branch to clear_buffer

    ldr r1, =intInput         @ Reload the register again
    ldr r2, [r1]              @ Load the input value into r2


    cmp r2, #min              @ Ensure input is within the valid range
    blt invalid_input
    cmp r2, #max 
    bgt invalid_input
 
    ldr r5, [r1]  @ loading reg 5 with the value of the input 
    mov r6, #0	@ the counter
    b print_loop

	
print_loop:
	cmp r6, r5 @compare and check if equal to r2
	beq done
	ldr r0, =hello_message
	bl printf
	adds r6, r6, #1
	b print_loop

invalid_input:
    ldr r0, =invalidInputMessage
    bl printf
    b input_prompt            @ Loop back to prompt for input

done:
    mov r7, #0x01
    svc 0                     @ Exit the program

.data

.balign 4
welcomeMessage: .asciz "Welcome to the program!\n"
.balign 4
instructionMessage: .asciz "Please enter an integer between 0 and 10: \n"
.balign 4
numInputPattern: .asciz "%d"
.balign 4
hello_message: .asciz "Hello World.\n"
.balign 4
intInput: .word 0 	@ location used to store the user input
.balign 4
invalidInputMessage: .asciz "Invalid input. Please enter a number between 0 and 10.\n"
.balign 4
strInputPattern: .asciz "%*s" 	@used to clear the input buffer for invalid input

.global printf
.global scanf
