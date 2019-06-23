`include "defines.v"


module IF_STAGE (CLK, RESET, BRANCH_TAKEN, BRANCH_OFFSET, FREEZE, PC, INSTRUCTION);

    input CLK, RESET, BRANCH_TAKEN, FREEZE;
    input [`WORD_LEN-1:0] BRANCH_OFFSET;
    output [`WORD_LEN-1:0] PC, INSTRUCTION;

    wire [`WORD_LEN-1:0] adder_in1, adder_out, branch_offset_X_4;

    MUX #(.LENGTH(`WORD_LEN)) adder_input (
        .MUX2_IN1(32'd4),
        .MUX2_IN2(branch_offset_X_4),
        .MUX2_SEL(BRANCH_TAKEN),
        .MUX2_OUT(adder_in1)
    );

    ADDER add_PC (
        .ADD_IN1(adder_in1),
        .ADD_IN2(PC),
        .ADD_OUT(adder_out)
    );

    REGISTER PC_register(
        .CLK(CLK),
        .RESET(RESET),
        .WRITE_EN(~FREEZE),
        .REG_IN(adder_out),
        .REG_OUT(PC)
    );

    INSTRUCTION_MEMORY instructions (
        .RESET(RESET),
        .ADDRESS(PC),
        .INSTRUCTION(INSTRUCTION)
    );

    assign branch_offset_X_4 = BRANCH_OFFSET << 4;

endmodule