`include "defines.v"

module Register_bank_tb;

    reg CLK, RESET, WRITE_ENABLE;
    reg [`REG_ADDR_LEN-1:0] SOURCE_REG1, SOURCE_REG2, DESTINATION_REG;
    reg [`WORD_LEN-1:0] DATA_IN;
    wire [`WORD_LEN-1:0] DATA1_OUT_REG, DATA2_OUT_REG;
    integer k;
    Register_bank uut(CLK, RESET, WRITE_ENABLE, SOURCE_REG1, SOURCE_REG2, DESTINATION_REG, DATA_IN, DATA1_OUT_REG, DATA2_OUT_REG);

    initial begin
        CLK = 0;
        RESET = 0;
        WRITE_ENABLE = 0;
        $monitor ("DATA1_OUT_REG=%d DATA2_OUT_REG=%d ", DATA1_OUT_REG, DATA2_OUT_REG);
        #11
        WRITE_ENABLE = 1;
        for (k = 0 ; k<32  ;k=k+1 ) begin
            #11  DESTINATION_REG = k; 
            DATA_IN = k;
        end
        #11
        WRITE_ENABLE = 0;

        for (k = 0 ; k<32  ;k=k+1 ) begin
            #11  SOURCE_REG1 = k;
        end

        for (k = 0 ; k<32  ;k=k+1 ) begin
            #11  SOURCE_REG2 = k;
        end

        for (k = 0 ; k<32  ;k=k+1 ) begin
            #11  SOURCE_REG1 = k;
            SOURCE_REG2 = k;
        end


    end   
    
    always #5 CLK = ~CLK;

    initial
		begin
			$dumpfile ("tb.vcd");
			$dumpvars (0, Register_bank_tb);
			#3000 $finish;
		end	
endmodule        