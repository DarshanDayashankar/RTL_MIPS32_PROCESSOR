`include "defines.v"

module EXE_PIPE_MEM (CLK, RESET, WB_EN_IN, MEM_READ_EN_IN, MEM_WRITE_EN_IN, PC_IN, ALU_RESULT_IN, 
                    SW_OPERAND_IN, DESTINATION_IN, WB_EN_OUT_REG, MEM_READ_EN_OUT_REG, MEM_WRITE_EN_OUT_REG,
                    PC_OUT_REG, ALU_RESULT_OUT_REG, SW_OPERAND_OUT_REG, DESTINATION_OUT_REG);

    input CLK, RESET;
    input WB_EN_IN, MEM_READ_EN_IN, MEM_WRITE_EN_IN;
    input [`REG_ADDR_LEN-1:0] DESTINATION_IN;
    input [`WORD_LEN-1:0] PC_IN, ALU_RESULT_IN, SW_OPERAND_IN;

    output reg WB_EN_OUT_REG, MEM_READ_EN_OUT_REG, MEM_WRITE_EN_OUT_REG;
    output reg [`REG_ADDR_LEN-1:0] DESTINATION_OUT_REG;
    output reg [`WORD_LEN-1:0] PC_OUT_REG, ALU_RESULT_OUT_REG, SW_OPERAND_OUT_REG;

    always @ (posedge CLK) begin 
        if (RESET) begin 
            {WB_EN_OUT_REG, MEM_READ_EN_OUT_REG, MEM_WRITE_EN_OUT_REG, PC_OUT_REG, ALU_RESULT_OUT_REG, SW_OPERAND_OUT_REG,
            DESTINATION_OUT_REG} <= 0;
        end
        else begin 
            WB_EN_OUT_REG <= WB_EN_IN;
            MEM_READ_EN_OUT_REG <= MEM_READ_EN_IN;
            MEM_WRITE_EN_OUT_REG <= MEM_WRITE_EN_IN;
            PC_OUT_REG <= PC_IN;
            ALU_RESULT_OUT_REG <= ALU_RESULT_IN;
            SW_OPERAND_OUT_REG <= SW_OPERAND_IN;
            DESTINATION_OUT_REG <= DESTINATION_IN;
        end
    end

endmodule                    