`include "defines.v"


module MEM_STAGE (CLK, RESET, MEM_READ_EN, MEM_WRITE_EN, ALU_RESULT, SW_OPERAND, DATA_MEMORY_OUT);

    input CLK, RESET, MEM_READ_EN, MEM_WRITE_EN;
    input [`WORD_LEN-1:0] ALU_RESULT, SW_OPERAND;
    output [`WORD_LEN-1:0] DATA_MEMORY_OUT;

    MEMORY #(.MEM_SIZE(`DATA_MEM_SIZE)) data_memory (
        .CLK(CLK),
        .RESET(RESET),
        .WRITE_EN(MEM_WRITE_EN),
        .READ_EN(MEM_READ_EN),
        .ADDRESS(ALU_RESULT),
        .DATA_IN(SW_OPERAND),
        .DATA_OUT_REG(DATA_MEMORY_OUT)
    );

endmodule