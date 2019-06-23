`include "defines.v"

module ALU(CLK, OPERAND1, OPERAND2, OPERATOR, ALU_OUT);

    input CLK;
    input [`WORD_LEN-1:0] OPERAND1, OPERAND2;
    input [`OPERATOR_LEN-1:0] OPERATOR;
    output reg [`WORD_LEN-1:0] ALU_OUT;

    always @(posedge CLK) begin
        case (OPERATOR)
            `OPERATOR_ADD : ALU_OUT <= OPERAND1 + OPERAND2;
            `OPERATOR_SUB : ALU_OUT <= OPERAND1 - OPERAND2;
            `OPERATOR_AND : ALU_OUT <= OPERAND1 & OPERAND2;
            `OPERATOR_OR  : ALU_OUT <= OPERAND1 | OPERAND2;
            `OPERATOR_NOR : ALU_OUT <= ~(OPERAND1 | OPERAND2);
            `OPERATOR_XOR : ALU_OUT <= OPERAND1 ^ OPERAND2;
            `OPERATOR_SLA : ALU_OUT <= OPERAND1 << OPERAND2;
            `OPERATOR_SLL : ALU_OUT <= OPERAND1 <<< OPERAND2;
            `OPERATOR_SRA : ALU_OUT <= OPERAND1 >> OPERAND2;
            `OPERATOR_SRL : ALU_OUT <= OPERAND1 >>> OPERAND2;
            `OPERATOR_NOP : ALU_OUT <= 0;
            default : ALU_OUT <= 0;
        endcase    
    end

endmodule
