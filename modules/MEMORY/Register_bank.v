`include "defines.v"

module Register_bank(CLK, RESET, WRITE_ENABLE, SOURCE_REG1, SOURCE_REG2, DESTINATION_REG, DATA_IN, DATA1_OUT_REG, DATA2_OUT_REG);

    input CLK, RESET, WRITE_ENABLE;
    input [`REG_ADDR_LEN-1:0] SOURCE_REG1, SOURCE_REG2, DESTINATION_REG;
    input [`WORD_LEN-1:0] DATA_IN;
    output reg [`WORD_LEN-1:0] DATA1_OUT_REG, DATA2_OUT_REG;
    reg [`WORD_LEN-1:0] REGISTER [0:`REG_BANK_SIZE-1];
    integer i;

    always @(negedge CLK) begin 
            
        if(RESET==1) begin 
            for ( i = 0; i<`REG_BANK_SIZE ; i=i+1 ) begin
                REGISTER[i] <= 0;
            end
        end
        else if(WRITE_ENABLE == 1) REGISTER[DESTINATION_REG] <= DATA_IN;
        DATA1_OUT_REG = (REGISTER[SOURCE_REG1]);
        DATA2_OUT_REG = (REGISTER[SOURCE_REG2]);
       
    end   
endmodule