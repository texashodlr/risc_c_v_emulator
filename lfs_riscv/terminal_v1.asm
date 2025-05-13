# All this code does is ask the users name in the console
# Then responds with a message using that name, ezpz

# Data Section -> Going str8 to volatile memory
.data
prompt:     .string     "Hey, what's your name?\n"
response:   .string     "\nIt's good to meet you "
name:       .string     "                        "

# Code Section (Place this section of code in the relevant section of program memory
.text

# Main entry point
# Program starts here at address 0x00000000
# RISC-V ISA always starts execution at addr 0
main:
    # Init
    la t0, name     #t0 points to the name string

    # print_string(prompt) - Env call 4
    la a1, prompt
    li a0, 4
    ecall

    # Call read_str subroutine
    jal read_str

    # print_string (response) env call4
    la a1, response
    li a0, 4
    ecall

    la a1, name
    li a0, 4
    ecall

    # print_char(a0) env call1
    li a1, '!'
    li a0, 11
    ecall

    li a1, '\n'
    ecall
    ecall

    # Exit env call 10
    li a0, 10
    ecall
# read_str subroutine
# Read input string from the console, this input is a line of text terminated
# with the enter keystroke

read_str: 
    # Initializations
    li a5, 1 # a5 holds the comparison for branching

    # Enable console input env call 0x130
    li a0, 0x130
    ecall

read_char:
    # Read a character from console inpuit env call to 0x131
    li a0, 0x131
    ecall
    # Read the result of the env call in a0
    beq a0, a5, read_char   #If still waiting for input keep polling
    beq a0, zero, finish    #If buffer is empty go to finish

    # Handle incoming character
    sb a1, 0(t0)            # Append input char to name string
    addi t0, t0, 1          # Increment the name string pointer

    # Iterate to get the next character
    j read_char  # jump to read_char

finish:
    # Subroutine epilogue
    sb zero, 0(t0)      # Append the null terminator to name string
    jr ra               # Return to caller

# Initiall ecall to 0x130 -> Console input enabled -> .data directive informs the assembler that the code
# is to be placed in data section of volatile memory
# read_char marks the beginning of a loop where all chars from the input
# are taken in with the 0x131 ecall
# inside the loop the result of the env call is examined
# in register a0 to decide whether to keep polling end the loop or take another char