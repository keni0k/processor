`timescale 1ns / 1ps

module memory
    #(parameter ROM_WIDTH = 8, ROM_ADDR_BITS = 8, COUNT_OF_COMMANDS = 9, SIZE_OF_COMMAND = 3)
    (
    input logic clk,
    input logic read_enb,
    input logic [ROM_ADDR_BITS/2-1:0] a,
    input logic [ROM_ADDR_BITS/2-1:0] b,
    output reg [ROM_WIDTH - 1:0] output_data
    );
    logic [ROM_ADDR_BITS - 1:0] address;
    reg [ROM_WIDTH - 1:0]     mem_ram [(2 ** ROM_ADDR_BITS) - 1:0];
    reg [ROM_WIDTH - 1:0]     cmd_rom [COUNT_OF_COMMANDS * SIZE_OF_COMMAND - 1:0];
    logic [23:0] instruction;

    initial begin 
        $readmemh("C:/schemo/project_3/mem.txt", mem_ram, 0, (2**ROM_ADDR_BITS) - 1);
        $readmemh("C:/schemo/project_3/asm.bin", cmd_rom, 0, COUNT_OF_COMMANDS * SIZE_OF_COMMAND - 1);
        $display("HELLO!");
         for (int j = 0; j < COUNT_OF_COMMANDS; j++) begin
                instruction = {cmd_rom[SIZE_OF_COMMAND * j], 
                     cmd_rom[SIZE_OF_COMMAND * j + 1], 
                     cmd_rom[SIZE_OF_COMMAND * j + 2]};
                 $display("%b", instruction);
        end;
        $display("GOOD BUY!");
    end;
    assign address = {a, b};
    always @(posedge clk)
        if (read_enb)
            output_data <= mem_ram[address];
            
//    genvar i;
//        generate
//            for (i = 0; i < COUNT_OF_COMMANDS; i++) begin:alu
//                 ALU ALU_0 (.clk(clk), .instruction({cmd_rom[SIZE_OF_COMMAND * i], 
//                     cmd_rom[SIZE_OF_COMMAND * i + 1], 
//                     cmd_rom[SIZE_OF_COMMAND * i + 2]}), .data_in(mem_rom));//, .ip_in(i));
//            end;
//        endgenerate;
endmodule
