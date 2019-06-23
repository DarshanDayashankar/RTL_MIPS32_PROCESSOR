`include "defines.v"

module ADDER (ADD_IN1, ADD_IN2, ADD_OUT);
    input [`WORD_LEN-1:0] ADD_IN1, ADD_IN2;
    output [`WORD_LEN-1:0] ADD_OUT;

    assign ADD_OUT = ADD_IN1 + ADD_IN2;

endmodule