`include "defines.v"


module EXE_STAGE (CLK, ALU_OPERATOR, OPERAND1_SEL, OPERAND2_SEL,SW_OPERAND_SEL, OPERAND1, OPERAND2, 
                ALU_RESULT_MEM, RESULT_WB, SW_OPERAND_IN, ALU_RESULT, SW_OPERAND_OUT);

    input CLK;
    input [`FORW_SEL_LEN-1:0] OPERAND1_SEL, OPERAND2_SEL, SW_OPERAND_SEL;
    input [`OPERATOR_LEN-1:0] ALU_OPERATOR;
    input [`WORD_LEN-1:0] OPERAND1, OPERAND2, ALU_RESULT_MEM, RESULT_WB, SW_OPERAND_IN;
    output [`WORD_LEN-1:0] ALU_RESULT, SW_OPERAND_OUT;

    wire [`WORD_LEN-1:0] alu_operand1, alu_operand2;

    MUX3 #(.LENGTH(`WORD_LEN)) mux_operand1 (
        .MUX3_IN1(OPERAND1),
        .MUX3_IN2(ALU_RESULT_MEM),
        .MUX3_IN3(RESULT_WB),
        .MUX3_SEL(OPERAND1_SEL),
        .MUX3_OUT(alu_operand1)
    );

    MUX3 #(.LENGTH(`WORD_LEN)) mux_operand2 (
        .MUX3_IN1(OPERAND2),
        .MUX3_IN2(ALU_RESULT_MEM),
        .MUX3_IN3(RESULT_WB),
        .MUX3_SEL(OPERAND2_SEL),
        .MUX3_OUT(alu_operand2)
    );

    MUX3 #(.LENGTH(`WORD_LEN)) mux_SW_operand (
        .MUX3_IN1(SW_OPERAND_IN),
        .MUX3_IN2(ALU_RESULT_MEM),
        .MUX3_IN3(RESULT_WB),
        .MUX3_SEL(SW_OPERAND_SEL),
        .MUX3_OUT(SW_OPERAND_OUT)
    );

    ALU alu (
        .CLK(CLK),
        .OPERAND1(alu_operand1),
        .OPERAND2(alu_operand2),
        .OPERATOR(ALU_OPERATOR),
        .ALU_OUT(ALU_RESULT)
    );    

endmodule