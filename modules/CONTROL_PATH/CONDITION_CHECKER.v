`include "defines.v"

module CONDITION_CHECKER (CLK, REGISTER1, REGISTER2, CONTROLLER_BRANCH_COMMAND, BRANCH_CONDITION);
    input CLK;
    input [`WORD_LEN-1:0] REGISTER1, REGISTER2;
    input [1:0] CONTROLLER_BRANCH_COMMAND;
    output reg BRANCH_CONDITION;

    always @ ( posedge CLK ) begin
        case (CONTROLLER_BRANCH_COMMAND)
            `COND_JUMP: BRANCH_CONDITION <= 1;
            `COND_BEZ: BRANCH_CONDITION <= (REGISTER1 == 0) ? 1 : 0;
            `COND_BNE: BRANCH_CONDITION <= (REGISTER1 != REGISTER2) ? 1 : 0;
            default: BRANCH_CONDITION <= 0; 
        endcase
    end
endmodule