# String Length Code
###################################################
# Description
#
# This assembly code roughly implements the
# following C algorithm to calculate the length of
# a string.
#
#   int count = 0;
#   char *str = “RISC-V is the bomb!!!”;
#
#   int main(){
#       while(*str){
#           count++;
#           str++;
#       }
#       print(count);
#   }
###################################################

# Data Section
.data
count:  .word 0
str:    .string "RISC-V Is the BOMB!!!"

# Code Section
.text

# Main Entry Point
# Program starts here at 0x00000000

main:
    # Initializations, All insns are encoded in 32b == 4B hence increment from 0x0..0 to 0x0..4
    la t0, count        # t0 points to count
    lw t1, 0(t0)        # t1 implements count
    la t2, str          # t2 points to *str

while:
    lb t3, 0(t2)        # Load *str into t3
    beqz t3, finish     # If *str==0, go to finish
    addi t1, t1, 1      # Count++
    addi t2, t2, 1      # Str++
    j while  # jump to while

finish:
    sw t1, 0(t0)        # Store t1 into count

    # print_int(count) env call 1
    mv a1, t1
    li a0, 1
    ecall

    # print_char('\n') - Env call 11
    li a1, '\n'
    li a0, 11
    ecall
    ecall

    # Exit Env call 10
    li a0, 10
    ecall