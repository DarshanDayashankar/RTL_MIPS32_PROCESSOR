`include "defines.v"

module REGISTER (CLK, RESET, WRITE_EN, REG_IN, REG_OUT);
    input CLK, RESET, WRITE_EN;
    input [`WORD_LEN-1:0] REG_IN;
    output reg [`WORD_LEN-1:0] REG_OUT;

    always @(posedge CLK) begin
        if(RESET==1) REG_OUT <= 0;
        else if(WRITE_EN==1) REG_OUT <= REG_IN;
    end    
endmodule