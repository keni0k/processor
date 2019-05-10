`timescale 1ns / 1ps

module memory_tb 
    #(parameter ROM_WIDTH = 8, ROM_ADDR_BITS = 5, COUNT_OF_COMMANDS = 32)();
    
    logic clkMem, clkALU;
    reg [ROM_WIDTH-1:0] output_data;
    logic [8:0] rez [COUNT_OF_COMMANDS-1:0];
    logic ready, exit, error;
    
    memory DUT(.clkMem(clkMem), .clkALU(clkALU), .output_data(output_data), .rez(rez), 
               .ready(ready),   .exit(exit),     .error(error));
    
    always begin
        clkMem = 1'b0; 
        #5;
        clkALU = 1'b0;
        #5;
        clkMem = 1'b1; 
        #5;
        clkALU = 1'b1;
        #5;
    end;
    
    initial begin
        clkALU = 1'b1;
        while (!exit)
            #10;
        $finish;
    end;

endmodule