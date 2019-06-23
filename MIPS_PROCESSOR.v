`include "defines.v"
`include "files.v"

module MIPS_PROCESSOR (CLK, RESET, FORWARD_EN);

    input CLK, RESET, FORWARD_EN;
    wire clock;
    assign clock = CLK;
    wire [`WORD_LEN-1:0] PC_IF, PC_ID, PC_EXE, PC_MEM;
    wire [`WORD_LEN-1:0] instruction_IF, insruction_ID;
    wire [`WORD_LEN-1:0] register1_ID, register2_ID, SW_operand_EXE, SW_operand_EXE_PIPE_MEM, SW_operand_MEM;
    wire [`WORD_LEN-1:0] operand1_ID, operand1_EXE;
    wire [`WORD_LEN-1:0] operand2_ID, operand2_EXE;
    wire [`WORD_LEN-1:0] ALU_result_EXE, ALU_result_MEM, ALU_result_WB;
    wire [`WORD_LEN-1:0] dataMEM_out_MEM, dataMEM_out_WB;
    wire [`WORD_LEN-1:0] WB_result;
    wire [`REG_ADDR_LEN-1:0] destination_EXE, destination_MEM, destination_WB;
    wire [`REG_ADDR_LEN-1:0] source1_ID, source2_reg_bank_ID, source2_forward_ID, source2_forward_EXE, source1_forward_EXE;
    wire [`OPERATOR_LEN-1:0] operator_ID, operator_EXE;
    wire [`FORW_SEL_LEN-1:0] operand1_sel, operand2_sel, SW_operand_sel;
    wire [1:0] branch_command;
    wire branch_taken_ID, IF_flush, branch_taken_EXE;
    wire MEM_read_enable_ID, MEM_read_enable_EXE, MEM_read_enable_MEM, MEM_read_enable_WB;
    wire MEM_write_enbale_ID, MEM_write_enable_EXE, MEM_write_enable_MEM;
    wire write_back_enable_ID, write_back_enable_MEM, write_back_enable_EXE, write_back_enable_WB;
    wire hazard_detected, is_immediate, SW_or_BNE;

    Register_bank reg_bank (
        //INPUTS
        .CLK(clock),
        .RESET(RESET),
        .WRITE_ENABLE(write_back_enable_WB),
        .SOURCE_REG1(source1_ID),
        .SOURCE_REG2(source2_reg_bank_ID),
        .DESTINATION_REG(destination_WB),
        .DATA_IN(WB_result),
        //OUTPUTS
        .DATA1_OUT_REG(register1_ID),
        .DATA2_OUT_REG(register2_ID)
    );

    HAZARD_DETECTION hazard_detection_unit(
        //INPUTS
        .FORWARD_EN(FORWARD_EN),
        .IS_IMMEDIATE(is_immediate),
        .SW_OR_BNE(SW_or_BNE),
        .SOURCE1_ID(source1_ID),
        .SOURCE2_ID(source2_reg_bank_ID),
        .DESTINATION_EXE(destination_EXE),
        .WRITE_BACK_EN_EXE(write_back_enable_EXE),
        .DESTINATION_MEM(destination_MEM),
        .WRITE_BACK_EN_MEM(write_back_enable_MEM),
        .MEM_READ_EN_EXE(MEM_read_enable_EXE),
        //OUTPUTS
        .BRANCH_COMMAND(branch_command),
        .HAZARD_DETECTED(hazard_detected)
    );

    FORWARDING_EXE forwarding_EXE(
        //INPUTS
        .CLK(clock),
        .SOURCE1_EXE(source1_forward_EXE),
        .SOURCE2_EXE(source2_forward_EXE),
        .SW_SOURCE_EXE(destination_EXE),
        .DESTINATION_MEM(destination_MEM),
        .DESTINATION_WB(destination_WB),
        .WRITE_BACK_EN_MEM(write_back_enable_MEM),
        .WRITE_BACK_EN_WB(write_back_enable_WB),
        //OUTPUTS
        .OPERAND1_SEL(operand1_sel),
        .OPERAND2_SEL(operand2_sel),
        .SW_OPERAND_SEL(SW_operand_sel)
    );


	//###########################
	//##### PIPLINE STAGES ######
	//###########################

    IF_STAGE if_stage_unit (
        //INPUTS
        .CLK(clock),
        .RESET(RESET),
        .BRANCH_TAKEN(branch_taken_ID),
        .BRANCH_OFFSET(operand2_ID),
        .FREEZE(hazard_detected),
        //OUTPUTS
        .PC(PC_IF),
        .INSTRUCTION(instruction_IF)
    );

    ID_STAGE id_stage_unit (
        //INPUTS
        .CLK(clock),
        .RESET(RESET),
        .HAZARD_DETECTED_IN(hazard_detected),
        .INSTRUCTION(insruction_ID),
        .REGISTER1(register1_ID),
        .REGISTER2(register2_ID),
        // OUTPUTS
        .SOURCE1(source1_ID),
        .SOURCE2_REG_BANK(source2_reg_bank_ID),
        .SOURCE2_FORWARD(source2_forward_ID),
        .OPERAND1(operand1_ID),
        .OPERAND2(operand2_ID),
        .BRANCH_TAKEN(branch_taken_ID),
        .ALU_OPERATOR(operator_ID),
        .MEMORY_READ_EN(MEM_read_enable_ID),
        .MEMORY_WRITE_EN(MEM_write_enbale_ID),
        .WRITE_BACK_EN(write_back_enable_ID),
        .IS_IMMEDIATE_OUT(is_immediate),
        .SW_OR_BNE_OUT(SW_or_BNE),
        .BRANCH_COMMAND(branch_command)
    );

    EXE_STAGE exe_stage_unit (
        //INPUTS
        .CLK(clock),
        .ALU_OPERATOR(operator_EXE),
        .OPERAND1_SEL(operand1_sel),
        .OPERAND2_SEL(operand2_sel),
        .SW_OPERAND_SEL(SW_operand_sel),
        .OPERAND1(operand1_EXE),
        .OPERAND2(operand2_EXE),
        .ALU_RESULT_MEM(ALU_result_MEM),
        .RESULT_WB(WB_result),
        .SW_OPERAND_IN(SW_operand_EXE),
        // OUTPUTS
        .ALU_RESULT(ALU_result_EXE),
        .SW_OPERAND_OUT(SW_operand_EXE_PIPE_MEM)
    );

    MEM_STAGE mem_stage_unit (
        // INPUTS
        .CLK(clock),
        .RESET(RESET),
        .MEM_READ_EN(MEM_read_enable_MEM),
        .MEM_WRITE_EN(MEM_write_enable_MEM),
        .ALU_RESULT(ALU_result_MEM),
        .SW_OPERAND(SW_operand_MEM),
        // OUTPUTS
        .DATA_MEMORY_OUT(dataMEM_out_MEM)
    );

    WB_STAGE wb_stage_unit (
        //INPUTS
        .MEM_READ_EN(MEM_read_enable_WB),
        .MEM_DATA(dataMEM_out_WB),
        .ALU_RESULT(ALU_result_WB),
        // OUTPUTS
        .WB_RESULT(WB_result)
    );

    //############################
	//#### PIPLINE REGISTERS #####
	//############################

    IF_PIPE_ID if_pipe_id_register (
        //INPUTS
        .CLK(clock),
        .RESET(RESET),
        .FLUSH(IF_flush),
        .FREEZE(hazard_detected),
        .PC_IN(PC_IF),
        .INSTRUCTION_IN(instruction_IF),
        //OUTPUTS
        .PC_OUT_REG(PC_ID),
        .INSTRUCTION_OUT_REG(insruction_ID)
    );

    ID_PIPE_EXE id_pipe_exe_register (
        //INPUTS
        .CLK(clock),
        .RESET(RESET),
        .REGISTER2_IN(register2_ID),
        .DESTINATION_IN(insruction_ID[25:21]),
        .OPERAND1_IN(operand1_ID),
        .OPERAND2_IN(operand2_ID),
        .PC_IN(PC_ID),
        .OPERATOR_IN(operator_ID),
        .MEM_READ_EN_IN(MEM_read_enable_ID),
        .MEM_WRITE_EN_IN(MEM_write_enbale_ID),
        .WB_EN_IN(write_back_enable_ID),
        .BRANCH_TAKEN_IN(branch_taken_ID),
        .SOURCE1_IN(source1_ID),
        .SOURCE2_IN(source2_forward_ID),
        //OUTPUTS
        .DESTINATION_OUT_REG(destination_EXE),
        .SW_OPERAND_OUT_REG(SW_operand_EXE),
        .OPERAND1_OUT_REG(operand1_EXE),
        .OPERAND2_OUT_REG(operand2_EXE),
        .PC_OUT_REG(PC_EXE),
        .OPERATOR_OUT_REG(operator_EXE),
        .MEM_READ_EN_OUT_REG(MEM_read_enable_EXE),
        .MEM_WRITE_EN_OUT_REG(MEM_write_enable_EXE),
        .WB_EN_OUT_REG(write_back_enable_EXE),
        .BRANCH_TAKEN_OUT_REG(branch_taken_EXE),
        .SOURCE1_OUT_REG(source1_forward_EXE),
        .SOURCE2_OUT_REG(source2_forward_EXE)

    );

    EXE_PIPE_MEM exe_pipe_mem_register (
        //INPUTS
        .CLK(clock),
        .RESET(RESET),
        .WB_EN_IN(write_back_enable_EXE),
        .MEM_READ_EN_IN(MEM_read_enable_EXE),
        .MEM_WRITE_EN_IN(MEM_write_enable_EXE),
        .PC_IN(PC_EXE),
        .ALU_RESULT_IN(ALU_result_EXE),
        .SW_OPERAND_IN(SW_operand_EXE_PIPE_MEM),
        .DESTINATION_IN(destination_EXE),
        //OUTPUTS
        .WB_EN_OUT_REG(write_back_enable_MEM),
        .MEM_READ_EN_OUT_REG(MEM_read_enable_MEM),
        .MEM_WRITE_EN_OUT_REG(MEM_write_enable_MEM),
        .PC_OUT_REG(PC_MEM),
        .ALU_RESULT_OUT_REG(ALU_result_MEM),
        .SW_OPERAND_OUT_REG(SW_operand_MEM),
        .DESTINATION_OUT_REG(destination_MEM)
    );

    MEM_PIPE_WB mem_pipe_wb_register (
        //INPUTS
        .CLK(clock),
        .RESET(RESET),
        .WB_EN_IN(write_back_enable_MEM),
        .MEM_READ_EN_IN(MEM_read_enable_MEM),
        .ALU_RESULT_IN(ALU_result_MEM),
        .MEM_READ_OPERAND_IN(dataMEM_out_MEM),
        .DESTINATION_IN(destination_MEM),
        //OUTPUTS
        .WB_EN_OUT_REG(write_back_enable_WB),
        .MEM_READ_EN_OUT_REG(MEM_read_enable_WB),
        .ALU_RESULT_OUT_REG(ALU_result_WB),
        .MEM_READ_OPERAND_OUT_REG(dataMEM_out_WB),
        .DESTINATION_OUT_REG(destination_WB)
    );

endmodule