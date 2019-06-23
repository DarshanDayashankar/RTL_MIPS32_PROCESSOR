`include "defines.v"

module MUX3 (MUX3_IN1, MUX3_IN2, MUX3_IN3, MUX3_SEL, MUX3_OUT);
    
    parameter LENGTH = 0;
    input [1:0] MUX3_SEL;
    input [LENGTH-1:0] MUX3_IN1, MUX3_IN2, MUX3_IN3;
    output [LENGTH-1:0] MUX3_OUT;
    wire mux_out;
    assign MUX3_OUT = (MUX3_SEL[1] == 0) ? ((MUX3_SEL == 0) ? MUX3_IN1 : MUX3_IN2) : MUX3_IN3;

endmodule