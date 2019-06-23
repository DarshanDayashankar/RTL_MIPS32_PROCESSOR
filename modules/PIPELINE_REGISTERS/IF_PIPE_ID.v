`include "defines.v"

module IF_PIPE_ID(CLK, RESET, FLUSH, FREEZE, PC_IN, INSTRUCTION_IN, PC_OUT_REG, INSTRUCTION_OUT_REG);
    input CLK, RESET, FLUSH, FREEZE;
    input [`WORD_LEN-1:0] PC_IN, INSTRUCTION_IN;
    output reg [`WORD_LEN-1:0] PC_OUT_REG, INSTRUCTION_OUT_REG;

    always @ (posedge CLK) begin 
        if (RESET) begin 
            PC_OUT_REG <= 0;
            INSTRUCTION_OUT_REG <= 0;
        end
        else begin 
            if (~FREEZE) begin 
                if (FLUSH) begin 
                    INSTRUCTION_OUT_REG <= 0;
                    PC_OUT_REG <= 0;
                end
                else begin 
                    INSTRUCTION_OUT_REG <= INSTRUCTION_IN;
                    PC_OUT_REG <= PC_IN;
                end
            end
        end
    end
endmodule