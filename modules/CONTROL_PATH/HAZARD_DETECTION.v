`include "defines.v"

module HAZARD_DETECTION (FORWARD_EN, IS_IMMEDIATE, SW_OR_BNE, SOURCE1_ID, SOURCE2_ID, 
                        DESTINATION_EXE,WRITE_BACK_EN_EXE, DESTINATION_MEM, WRITE_BACK_EN_MEM, 
                        MEM_READ_EN_EXE, BRANCH_COMMAND, HAZARD_DETECTED);
    input [`REG_ADDR_LEN-1:0] SOURCE1_ID, SOURCE2_ID;
    input [`REG_ADDR_LEN-1:0] DESTINATION_EXE, DESTINATION_MEM;
    input [1:0] BRANCH_COMMAND;
    input FORWARD_EN, WRITE_BACK_EN_MEM, WRITE_BACK_EN_EXE, IS_IMMEDIATE, SW_OR_BNE, MEM_READ_EN_EXE;
    output HAZARD_DETECTED;

    wire  source2_is_valid, EXE_has_hazard, MEM_has_hazard, hazard, instruction_is_branch;

    assign source2_is_valid = (~IS_IMMEDIATE) || SW_OR_BNE;

    assign EXE_has_hazard = WRITE_BACK_EN_EXE && (SOURCE1_ID == DESTINATION_EXE || (source2_is_valid && SOURCE2_ID == DESTINATION_EXE));
    assign MEM_has_hazard = WRITE_BACK_EN_MEM && (SOURCE1_ID == DESTINATION_MEM || (source2_is_valid && SOURCE2_ID == DESTINATION_MEM));

    assign hazard = (EXE_has_hazard || MEM_has_hazard);
    assign instruction_is_branch = (BRANCH_COMMAND == `COND_BEZ || BRANCH_COMMAND == `COND_BNE);

    assign HAZARD_DETECTED = ~FORWARD_EN ? hazard : (instruction_is_branch && hazard) || (MEM_READ_EN_EXE && MEM_has_hazard);
                            
endmodule                        
