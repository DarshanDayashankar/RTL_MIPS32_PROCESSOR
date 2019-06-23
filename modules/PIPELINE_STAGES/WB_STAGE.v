`include "defines.v"

module WB_STAGE (MEM_READ_EN, MEM_DATA, ALU_RESULT, WB_RESULT);

    input MEM_READ_EN;
    input [`WORD_LEN-1:0] MEM_DATA, ALU_RESULT;
    output [`WORD_LEN-1:0] WB_RESULT;

    assign WB_RESULT = (MEM_READ_EN) ? MEM_DATA : ALU_RESULT;

endmodule