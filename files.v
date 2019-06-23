//BASIC
`include "modules/BASIC/MUX.v"
`include "modules/BASIC/ADDER.v"
`include "modules/BASIC/REGISTER.v"
`include "modules/BASIC/SIGN_EXTENDER.v"
`include "modules/BASIC/MUX3.v"
`include "modules/BASIC/ALU.v"
//MEMORY
`include "modules/MEMORY/INSTRUCTION_MEMORY.v"
`include "modules/MEMORY/MEMORY.v"
`include "modules/MEMORY/Register_bank.v"
//CONTROL PATH
`include "modules/CONTROL_PATH/CONDITION_CHECKER.v"
`include "modules/CONTROL_PATH/CONTROLLER.v"
`include "modules/CONTROL_PATH/HAZARD_DETECTION.v"
`include "modules/CONTROL_PATH/FORWARDING_EXE.v"
//PIPELINE STAGES
`include "modules/PIPELINE_STAGES/IF_STAGE.v"
`include "modules/PIPELINE_STAGES/ID_STAGE.v"
`include "modules/PIPELINE_STAGES/EXE_STAGE.v"
`include "modules/PIPELINE_STAGES/MEM_STAGE.v"
`include "modules/PIPELINE_STAGES/WB_STAGE.v"
//PIPELINE REGISTERS
`include "modules/PIPELINE_REGISTERS/IF_PIPE_ID.v"
`include "modules/PIPELINE_REGISTERS/ID_PIPE_EXE.v"
`include "modules/PIPELINE_REGISTERS/EXE_PIPE_MEM.v"
`include "modules/PIPELINE_REGISTERS/MEM_PIPE_WB.v"