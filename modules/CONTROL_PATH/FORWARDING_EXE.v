`include "defines.v"


module FORWARDING_EXE (CLK, SOURCE1_EXE, SOURCE2_EXE, SW_SOURCE_EXE, DESTINATION_MEM, DESTINATION_WB, 
                      WRITE_BACK_EN_MEM, WRITE_BACK_EN_WB, OPERAND1_SEL, OPERAND2_SEL, SW_OPERAND_SEL );

    input CLK;
    input [`REG_ADDR_LEN-1:0] SOURCE1_EXE, SOURCE2_EXE, SW_SOURCE_EXE;
    input [`REG_ADDR_LEN-1:0] DESTINATION_MEM, DESTINATION_WB;
    input WRITE_BACK_EN_MEM, WRITE_BACK_EN_WB;
    output reg [`FORW_SEL_LEN-1:0] OPERAND1_SEL, OPERAND2_SEL, SW_OPERAND_SEL;

    always @ (posedge CLK) begin
        // intializing sel signals to 0
        // they will change to enable forwarding if needed. 
        {OPERAND1_SEL, OPERAND2_SEL, SW_OPERAND_SEL} <= 0;

        // determining forward control signal for store value (SW_OPERAND)
        if (WRITE_BACK_EN_MEM && SW_SOURCE_EXE == DESTINATION_MEM) SW_OPERAND_SEL <= 2'd1;
        else if (WRITE_BACK_EN_WB && SW_SOURCE_EXE == DESTINATION_WB)  SW_OPERAND_SEL <= 2'd2;

        // determining forward control signal for ALU_OPERAND1
        if (WRITE_BACK_EN_MEM && SOURCE1_EXE == DESTINATION_MEM) OPERAND1_SEL <= 2'd1;
        else if (WRITE_BACK_EN_WB && SOURCE1_EXE == DESTINATION_WB) OPERAND1_SEL <= 2'd2;

        // determining forward control signal for ALU_OPERAND2
        if (WRITE_BACK_EN_MEM && SOURCE2_EXE == DESTINATION_MEM) OPERAND2_SEL <= 2'd1;
        else if (WRITE_BACK_EN_WB && SOURCE2_EXE == DESTINATION_WB) OPERAND2_SEL <= 2'd2;
    end
endmodule

