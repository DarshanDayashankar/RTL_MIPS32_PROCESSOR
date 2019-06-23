`include "defines.v"

module ALU_tb;

    reg CLK;
    reg [`WORD_LEN-1:0] OPERAND1, OPERAND2;
    reg [`OPERATOR_LEN-1:0] OPERATOR;
    wire [`WORD_LEN-1:0] ALU_OUT;
    
    ALU uut(CLK, OPERAND1, OPERAND2, OPERATOR, ALU_OUT);
    

    initial begin
        CLK=0;
        $monitor("ALU_OUT=%d", ALU_OUT);
        #11
        OPERAND1 = 30;
        OPERAND2 = 10;
        OPERATOR = `OPERATOR_ADD;
        #11 OPERATOR = `OPERATOR_AND;
        #11 OPERATOR = `OPERATOR_NOR;
        #11 OPERATOR = `OPERATOR_OR;
        #11 OPERATOR = `OPERATOR_XOR;
        #11 OPERATOR = `OPERATOR_SUB;
        #11 OPERATOR = `OPERATOR_SLA;
        #11 OPERATOR = `OPERATOR_SRA;
        #11 OPERATOR = `OPERATOR_SLL;
        #11 OPERATOR = `OPERATOR_SRL;
        #11 $finish;
    end
    
    always #5 CLK=~CLK;
    
    initial begin
		$dumpfile ("tb.vcd");
		$dumpvars (0, ALU_tb);
	end	

endmodule