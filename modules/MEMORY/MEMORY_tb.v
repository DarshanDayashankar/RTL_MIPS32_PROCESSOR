`include "defines.v"

module MEMORY_tb;

    reg CLK, RESET, WRITE_EN, READ_EN;
    reg [`WORD_LEN-1:0] ADDRESS, DATA_IN;
    wire [`WORD_LEN-1:0] DATA_OUT_REG;

    integer i;

    MEMORY #(.MEM_SIZE(`DATA_MEM_SIZE)) uut(CLK, RESET, WRITE_EN, READ_EN, ADDRESS, DATA_IN, DATA_OUT_REG);

    always #5 CLK=~CLK;
    initial begin
       CLK = 0;
       RESET = 0;
       WRITE_EN = 0;
       READ_EN = 0;
       #6 WRITE_EN = 1; 
       for (i =0 ;i<1024 ; i=i+1 ) begin
           #11 DATA_IN=i;
           ADDRESS=i;
       end
       #11 WRITE_EN = 0;
       READ_EN = 1;
       for (i = 0 ;i<1024 ;i=i+1 ) begin
           #11 ADDRESS= i;
       end
        #11 READ_EN =1;
        RESET=1;
        #11 RESET =0;
         READ_EN = 1;
       for (i = 0 ;i<1024 ;i=i+1 ) begin
           #11 ADDRESS= i;
       end
        #11 READ_EN =1; 
    end

    initial begin
        $monitor("DATA_OUT=%d", DATA_OUT_REG);
		$dumpfile ("tb.vcd");
		$dumpvars (0, MEMORY_tb);
		#30000 $finish;
	end	

endmodule