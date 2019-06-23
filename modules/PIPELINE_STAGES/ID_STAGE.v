`include "defines.v"


module ID_STAGE (CLK, RESET, HAZARD_DETECTED_IN,INSTRUCTION, REGISTER1, REGISTER2,
                IS_IMMEDIATE_OUT, SW_OR_BNE_OUT, SOURCE1, SOURCE2_REG_BANK,
                SOURCE2_FORWARD, OPERAND1, OPERAND2, BRANCH_TAKEN, ALU_OPERATOR, MEMORY_READ_EN,
                MEMORY_WRITE_EN, WRITE_BACK_EN, BRANCH_COMMAND);

    input CLK, RESET, HAZARD_DETECTED_IN;
    input [`WORD_LEN-1:0] INSTRUCTION, REGISTER1, REGISTER2;
    output [1:0] BRANCH_COMMAND;
    output BRANCH_TAKEN, MEMORY_READ_EN, MEMORY_WRITE_EN, WRITE_BACK_EN, IS_IMMEDIATE_OUT, SW_OR_BNE_OUT;
    output [`OPERATOR_LEN-1:0] ALU_OPERATOR;
    output [`REG_ADDR_LEN-1:0] SOURCE1, SOURCE2_REG_BANK, SOURCE2_FORWARD;
    output [`WORD_LEN-1:0] OPERAND1, OPERAND2;

    wire  control_unit_2_and, condition_2_and;
    wire [1:0] control_unit_2_condition;
    wire is_immediate, SW_or_BNE;
    wire [`WORD_LEN-1:0] sign_extended_2_mux;

    CONTROLLER controller(
        //INPUTS
        .CLK(CLK),
        .OP_CODE(INSTRUCTION[31:26]),
        .BRANCH_EN(control_unit_2_and),
        //OUTPUTS
        .OPERATOR(ALU_OPERATOR),
        .BRANCH_COMMAND(control_unit_2_condition),
        .IS_IMMEDIATE(is_immediate),
        .SW_OR_BNE(SW_or_BNE),
        .WRITE_BACK_EN(WRITE_BACK_EN),
        .MEM_READ_EN(MEMORY_READ_EN),
        .MEM_WRITE_EN(MEMORY_WRITE_EN),
        .HAZARD_DETECTED(HAZARD_DETECTED_IN)
    );

    MUX #(.LENGTH(`REG_ADDR_LEN)) mux_source2 (
        .MUX2_IN1(INSTRUCTION[15:11]),
        .MUX2_IN2(INSTRUCTION[25:21]),
        .MUX2_SEL(SW_or_BNE),
        .MUX2_OUT(SOURCE2_REG_BANK)
    );  

    MUX #(.LENGTH(`WORD_LEN)) mux_OPERAND2 (
        .MUX2_IN1(REGISTER2),
        .MUX2_IN2(sign_extended_2_mux),
        .MUX2_SEL(is_immediate),
        .MUX2_OUT(OPERAND2)
    );

    MUX #(.LENGTH(`REG_ADDR_LEN)) mux_source2_forward (
        .MUX2_IN1(INSTRUCTION[15:11]),
        .MUX2_IN2(5'd0),
        .MUX2_SEL(is_immediate),
        .MUX2_OUT(SOURCE2_FORWARD)
    );

    SIGN_EXTENDER sign_extender(
        .IN(INSTRUCTION[15:0]),
        .OUT(sign_extended_2_mux)
    );

    CONDITION_CHECKER condition_checker (
        .CLK(CLk),
        .REGISTER1(REGISTER1),
        .REGISTER2(REGISTER2),
        .CONTROLLER_BRANCH_COMMAND(control_unit_2_condition),
        .BRANCH_CONDITION(condition_2_and)
    );

    assign BRANCH_TAKEN = control_unit_2_and && condition_2_and;
    assign OPERAND1 = REGISTER1;
    assign SOURCE1 = INSTRUCTION[20:16];
    assign IS_IMMEDIATE_OUT = is_immediate;
    assign SW_OR_BNE_OUT = SW_or_BNE;
    assign BRANCH_COMMAND = control_unit_2_condition;
        
endmodule