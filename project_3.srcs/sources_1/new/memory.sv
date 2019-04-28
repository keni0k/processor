`timescale 1ns / 1ps

module memory
    #(parameter ROM_WIDTH = 8, ROM_ADDR_BITS = 5, COUNT_OF_COMMANDS = 32, SIZE_OF_COMMAND = 3)
    (
    input logic                          clkMem,
    input logic                          clkALU,
    input logic                          read_enb,
    input logic                          write_enb,
    input logic [ROM_ADDR_BITS-1:0]      address,
    output logic [ROM_WIDTH:0]           rez [COUNT_OF_COMMANDS-1:0],
    output reg [ROM_WIDTH - 1:0]         output_data
    );
    reg [ROM_WIDTH - 1:0]     mem_ram [(2 ** ROM_ADDR_BITS) - 1:0];
    reg [ROM_WIDTH - 1:0]     mem_ram_two [(2 ** ROM_ADDR_BITS) - 1:0];
    reg [ROM_WIDTH - 1:0]     cmd_rom [COUNT_OF_COMMANDS * SIZE_OF_COMMAND - 1:0];
    logic [23:0] instruction;
    logic instrPointer[COUNT_OF_COMMANDS:0] = 
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1};
    typedef enum logic [8:0] { OVERFLOW = 9'b100000000, DEVIDE_BY_ZERO = 9'b101000000, 
                               MINUS = 9'b100100000, 
                               MOVE_X = 9'b110000000, MOVE_Z = 9'b111000000 } errorcode;
                           
    initial begin 
        $readmemh("C:/\Programming/schemotechnika/project_3/mem.txt", mem_ram, 0, (2**ROM_ADDR_BITS) - 1);
        mem_ram_two = mem_ram;
        $readmemh("C:/Programming/schemotechnika/project_3/asm.bin", cmd_rom, 0, COUNT_OF_COMMANDS * SIZE_OF_COMMAND - 1);
        $display("HELLO!");
         for (int j = 0; j < COUNT_OF_COMMANDS; j++) begin
                instruction = {cmd_rom[SIZE_OF_COMMAND * j], 
                     cmd_rom[SIZE_OF_COMMAND * j + 1], 
                     cmd_rom[SIZE_OF_COMMAND * j + 2]};
                 $display("%b", instruction);
                 rez[j] = 511;
        end;
        $display("GOOD BUY!");
    end;
    
    always @(posedge clkMem)
        if (write_enb) begin
            for (int i = 0; i < COUNT_OF_COMMANDS; i++) begin
                if (rez[i] < 2 ** ROM_WIDTH) begin
                    instruction = {cmd_rom[SIZE_OF_COMMAND * i], 
                                   cmd_rom[SIZE_OF_COMMAND * i + 1], 
                                   cmd_rom[SIZE_OF_COMMAND * i + 2]};
                    $display ("DEST: R%d, RESULT: %d", instruction[19:15], rez[i][7:0]);
                    mem_ram[instruction[19:15]] <= rez[i][7:0];
                    mem_ram_two[instruction[19:15]] <= rez[i][7:0];
                    rez[i] <= 511;
                    instrPointer[i] = 0;
                    instrPointer[i + 1] = 1;
                end else
                if (rez[i] != 511) begin
                    if (rez[i] > 448) begin
                        $display("JUMP TO: %d", rez[i]-448);
                        instrPointer[i] = 0;
                        instrPointer[rez[i]-448] = 1;
                        rez[i] <= 511;
                    end;
                    if (rez[i] == OVERFLOW)
                        $display("OVERFLOW!");
                    if (rez[i] == MINUS)
                        $display("MINUS!");
                end;
            end;
         end;
    always @(negedge clkMem)
        if (read_enb) begin
            output_data <= mem_ram[address];
        end;
           
    genvar i;
    generate
        for (i = 0; i < COUNT_OF_COMMANDS; i++) begin: alu
             ALU ALU_0 ( .clk(clkALU), .instruction({cmd_rom[SIZE_OF_COMMAND * i], 
                         cmd_rom[SIZE_OF_COMMAND * i + 1], cmd_rom[SIZE_OF_COMMAND * i + 2]}), 
                         .data_in_first(mem_ram[cmd_rom[SIZE_OF_COMMAND * i + 1][6:2]]), 
                         .data_in_second(mem_ram[cmd_rom[SIZE_OF_COMMAND * i + 2][7:0]]), 
                         .rez(rez[i]), .IP_in(instrPointer[i]) );
        end;
    endgenerate;
endmodule
