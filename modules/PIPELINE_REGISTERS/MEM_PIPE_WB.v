`include "defines.v"

module MEM_PIPE_WB (CLK, RESET, WB_EN_IN, MEM_READ_EN_IN, ALU_RESULT_IN, MEM_READ_OPERAND_IN,
                    DESTINATION_IN, WB_EN_OUT_REG, MEM_READ_EN_OUT_REG, ALU_RESULT_OUT_REG, 
                    MEM_READ_OPERAND_OUT_REG, DESTINATION_OUT_REG);

    input CLK, RESET;
    input WB_EN_IN, MEM_READ_EN_IN;
    input [`REG_ADDR_LEN-1:0] DESTINATION_IN;
    input [`WORD_LEN-1:0] ALU_RESULT_IN, MEM_READ_OPERAND_IN;

    output reg WB_EN_OUT_REG, MEM_READ_EN_OUT_REG;
    output reg [`REG_ADDR_LEN-1:0] DESTINATION_OUT_REG;
    output reg [`WORD_LEN-1:0] ALU_RESULT_OUT_REG, MEM_READ_OPERAND_OUT_REG;

    always @ (posedge CLK) begin 
        if (RESET) begin 
            {WB_EN_OUT_REG, MEM_READ_EN_OUT_REG, DESTINATION_OUT_REG, ALU_RESULT_OUT_REG,
            MEM_READ_OPERAND_OUT_REG} <= 0;
        end
        else begin 
            WB_EN_OUT_REG <= WB_EN_IN;
            MEM_READ_EN_OUT_REG <= MEM_READ_EN_IN;
            DESTINATION_OUT_REG <= DESTINATION_IN;
            ALU_RESULT_OUT_REG <= ALU_RESULT_IN;
            MEM_READ_OPERAND_OUT_REG <= MEM_READ_OPERAND_IN;
        end
    end

endmodule                    