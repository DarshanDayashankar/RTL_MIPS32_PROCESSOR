`include "defines.v"

module MUX (MUX2_IN1, MUX2_IN2, MUX2_SEL, MUX2_OUT);
    
    parameter LENGTH = 0;
    input MUX2_SEL;
    input [LENGTH-1:0] MUX2_IN1, MUX2_IN2;
    output [LENGTH-1:0] MUX2_OUT;

    assign MUX2_OUT = (MUX2_SEL == 0) ? MUX2_IN1 : MUX2_IN2;

endmodule