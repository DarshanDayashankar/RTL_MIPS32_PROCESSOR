`include "defines.v"

module MUX_tb;

    reg [`WORD_LEN-1:0] MUX_IN1, MUX_IN2, MUX_IN3;
    reg [1:0] MUX_SEL;
    wire [`WORD_LEN-1:0] MUX_OUT, MUX_OUT3;
    
    MUX #(`WORD_LEN) uut(MUX_IN1, MUX_IN2, MUX_SEL[0], MUX_OUT);
    MUX3 #(`WORD_LEN) uut2(MUX_IN1, MUX_IN2, MUX_IN3, MUX_SEL, MUX_OUT3);
    

    initial begin
        $monitor("MUX_OUT=%d MUX_OUT3=%d", MUX_OUT, MUX_OUT3);
        #11
        MUX_IN1 = 30;
        MUX_IN2 = 10;
        MUX_IN3 = 20;
        MUX_SEL = 0;
        #11 MUX_SEL = 1;
        #11 MUX_SEL = 2;
        #11 $finish;
    end
    
    
    initial begin
		$dumpfile ("tb.vcd");
		$dumpvars (0, MUX_tb);
	end	

endmodule