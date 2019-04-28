`timescale 1ns / 1ps

module memory_tb 
    #(parameter ROM_WIDTH = 8, ROM_ADDR_BITS = 5, COUNT_OF_COMMANDS = 32)();
    
    logic clkMem, clkALU;
    logic read_enb;
    logic write_enb;
    logic [ROM_ADDR_BITS-1:0] address;
    reg [ROM_WIDTH-1:0] output_data;
    logic [8:0] rez [COUNT_OF_COMMANDS-1:0];
    
    memory DUT(.clkMem(clkMem), .clkALU(clkALU), .read_enb(read_enb), .write_enb(write_enb), .address(address), .output_data(output_data), .rez(rez));
    
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
        read_enb = 1;
        write_enb = 1;
        address = 0;#20;
        repeat(31) begin
            address++; #20;
        end;
        address = 0; #20;
        repeat(31) begin
            address++; #20;
        end
        $finish;
    end;

endmodule