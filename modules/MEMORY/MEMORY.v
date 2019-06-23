`include "defines.v"

module MEMORY (CLK, RESET, WRITE_EN, READ_EN, ADDRESS, DATA_IN, DATA_OUT_REG);

parameter MEM_SIZE=0;
input CLK, READ_EN, RESET, WRITE_EN;
input [`WORD_LEN-1:0] ADDRESS, DATA_IN;
output reg [`WORD_LEN-1:0] DATA_OUT_REG;

integer i;
reg [`MEM_CELL_SIZE-1:0] MEM [0:MEM_SIZE-1];
wire[`WORD_LEN-1:0] base_address;

always @(posedge CLK) begin
    if( RESET == 1 ) for ( i=0; i<MEM_SIZE; i=i+1) begin
        MEM[i] <= 0;
    end
    else if (WRITE_EN==1) 
        {MEM[base_address], MEM[base_address+1],MEM[base_address+2],MEM[base_address+3]} <= DATA_IN;
    else if (READ_EN==1)    
    DATA_OUT_REG = {MEM[base_address], MEM[base_address+1],MEM[base_address+2],MEM[base_address+3]} ;

end
assign base_address = ((ADDRESS & 32'b11111111111111111111101111111111) >> 2) << 2;

endmodule 