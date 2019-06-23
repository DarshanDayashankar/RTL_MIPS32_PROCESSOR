`include "defines.v"

module SIGN_EXTENDER (IN, OUT);
    
    input [15:0] IN;
    output [`WORD_LEN-1:0] OUT;

    assign OUT = (IN[15] == 1) ? {16'b1111_1111_1111_1111, IN} 
                               : {16'b0000_0000_0000_0000, IN};
endmodule