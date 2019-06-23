`include "MIPS_PROCESSOR.v"
`timescale 1ns/1ns


module MIPS_PROCESSOR_tb ();

    reg CLK, RESET, FORWARDING_EN;

    MIPS_PROCESSOR uut (CLK, RESET, FORWARDING_EN);

    initial begin 
        CLK = 1;
        repeat(5000) #50 CLK=~CLK;
    end

    initial begin 
        RESET =1;
        FORWARDING_EN =1;
        #105
        RESET = 0;
    end

    initial begin
        $dumpfile ("mips.vcd");
        $dumpvars (0, MIPS_PROCESSOR_tb);
        #5000 $finish;
    end

endmodule