`include "defines.v"

module CONTROLLER (CLK, OP_CODE, BRANCH_EN, OPERATOR, BRANCH_COMMAND, IS_IMMEDIATE, SW_OR_BNE, 
                  WRITE_BACK_EN, MEM_READ_EN, MEM_WRITE_EN, HAZARD_DETECTED);

    input CLK, HAZARD_DETECTED;
    input [`OP_CODE_LEN-1:0] OP_CODE;
    output reg BRANCH_EN;
    output reg [`OPERATOR_LEN-1:0] OPERATOR;
    output reg [1:0] BRANCH_COMMAND;
    output reg IS_IMMEDIATE, SW_OR_BNE, WRITE_BACK_EN, MEM_READ_EN, MEM_WRITE_EN;

    always @ ( negedge CLK ) begin
        if (HAZARD_DETECTED == 0) begin
            {BRANCH_EN, OPERATOR, BRANCH_COMMAND, IS_IMMEDIATE, SW_OR_BNE, WRITE_BACK_EN, MEM_READ_EN, MEM_WRITE_EN} <= 0;

            case (OP_CODE)
                // R-TYPE OPERATIONS
                `OP_ADD: begin 
                    OPERATOR <= `OPERATOR_ADD; 
                    WRITE_BACK_EN <= 1; 
                end
                `OP_SUB: begin
                    OPERATOR <= `OPERATOR_SUB;
                    WRITE_BACK_EN <= 1;    
                end
                `OP_AND: begin
                    OPERATOR <= `OPERATOR_AND;
                    WRITE_BACK_EN <= 1;
                end
                `OP_OR: begin
                    OPERATOR <= `OPERATOR_OR;
                    WRITE_BACK_EN <= 1;
                end
                `OP_NOR: begin
                    OPERATOR <= `OPERATOR_NOR;
                    WRITE_BACK_EN <= 1;
                end
                `OP_XOR: begin
                    OPERATOR <= `OPERATOR_XOR;
                    WRITE_BACK_EN <= 1;
                end
                `OP_SLA: begin
                    OPERATOR <= `OPERATOR_SLA;
                    WRITE_BACK_EN <= 1;
                end
                `OP_SLL: begin
                    OPERATOR <= `OPERATOR_SLL;
                    WRITE_BACK_EN <= 1;
                end
                `OP_SRA: begin
                    OPERATOR <= `OPERATOR_SRA;
                    WRITE_BACK_EN <= 1;
                end
                `OP_SRL: begin
                    OPERATOR <= `OPERATOR_SRL;
                    WRITE_BACK_EN <= 1;
                end

                // I-TYPE OPERATIONS
                `OP_ADDI: begin
                    OPERATOR <= `OPERATOR_ADD;
                    WRITE_BACK_EN <= 1;
                    IS_IMMEDIATE <= 1;
                end
                `OP_SUBI: begin
                    OPERATOR <= `OPERATOR_SUB;
                    WRITE_BACK_EN <= 1;
                    IS_IMMEDIATE <= 1;
                end

                //MEMORY OPERATIONS

                `OP_LW: begin
                    OPERATOR <= `OPERATOR_ADD;
                    WRITE_BACK_EN <= 1;
                    IS_IMMEDIATE <= 1;
                    SW_OR_BNE <= 1;
                    MEM_READ_EN <= 1; 
                end
                `OP_SW: begin
                    OPERATOR <= `OPERATOR_ADD;
                    IS_IMMEDIATE <= 1;
                    MEM_WRITE_EN <= 1;
                    SW_OR_BNE <= 1;
                end

                //BRANCH OPERATIONS

                `OP_BEZ: begin
                    OPERATOR <= `OPERATOR_NOP;
                    IS_IMMEDIATE <= 1;
                    BRANCH_COMMAND <= `COND_BEZ;
                    BRANCH_EN <= 1;
                end
                `OP_BNE: begin
                    OPERATOR <= `OPERATOR_NOP;
                    IS_IMMEDIATE <= 1;
                    BRANCH_COMMAND <= `COND_BNE;
                    BRANCH_EN <= 1;
                    SW_OR_BNE <= 1;
                end
                `OP_JMP: begin
                    OPERATOR <= `OPERATOR_NOP;
                    IS_IMMEDIATE <= 1;
                    BRANCH_COMMAND <= `COND_JUMP;
                    BRANCH_EN <= 1; 
                end

                default: {BRANCH_EN, OPERATOR, BRANCH_COMMAND, IS_IMMEDIATE,
                         SW_OR_BNE, WRITE_BACK_EN, MEM_READ_EN, MEM_WRITE_EN} <= 0; 
            endcase
        end
        else if (HAZARD_DETECTED == 1) begin
            {OPERATOR, WRITE_BACK_EN, MEM_WRITE_EN} <= 0;
        end
    end

endmodule                  