`timescale 1ns / 1ps

module memory
    #(parameter ROM_WIDTH = 8, ROM_ADDR_BITS = 5, COUNT_OF_COMMANDS = 32, SIZE_OF_COMMAND = 3)
    (
        input logic                          clkMem,
        input logic                          clkALU,
        output logic [ROM_WIDTH:0]           rez [COUNT_OF_COMMANDS-1:0],
        output reg [ROM_WIDTH - 1:0]         output_data,
        output logic                         ready,
        output logic                         error,
        output logic                         exit
    );
    reg [ROM_WIDTH - 1:0]     mem_ram [(2 ** ROM_ADDR_BITS) - 1:0];
    reg [ROM_WIDTH - 1:0]     mem_ram_two [(2 ** ROM_ADDR_BITS) - 1:0];
    reg [ROM_WIDTH - 1:0]     cmd_rom [COUNT_OF_COMMANDS * SIZE_OF_COMMAND - 1:0];
    logic [23:0] instruction;
    logic instrPointer[COUNT_OF_COMMANDS - 1:0] = 
        {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1};
    typedef enum logic [8:0] { OVERFLOW = 9'b110000000, DEVIDE_BY_ZERO = 9'b110000001, 
                               MINUS = 9'b110000010, SUCCESS = 9'b110000011 } exitcode;
                               
    typedef enum logic [3:0] { INCIP_CODE = 4'b1000, JUMP_CODE = 4'b1001, STORE_CODE = 4'b1010 } code;
                           
    initial begin 
        exit = 0;
        error = 0;
        $readmemh("C:/\Programming/schemotechnika/project_3/mem.txt", mem_ram, 0, (2**ROM_ADDR_BITS) - 1);
        mem_ram_two = mem_ram;
        $readmemh("C:/Programming/schemotechnika/project_3/asm.bin", cmd_rom, 0, COUNT_OF_COMMANDS * SIZE_OF_COMMAND - 1);
        $display("\nHELLO! That is my bytecode:");
         for (int j = 0; j < COUNT_OF_COMMANDS; j++) begin
                instruction = {cmd_rom[SIZE_OF_COMMAND * j], 
                     cmd_rom[SIZE_OF_COMMAND * j + 1], 
                     cmd_rom[SIZE_OF_COMMAND * j + 2]};
                 if (instruction[0] == 0 || instruction[0] == 1)
                    $display("IP: %2d = %b", j, instruction);
                 rez[j] = 511;
        end;
        $display("\nSTART!\n");
    end;
    
    always @(posedge clkMem)
        for (int i = 0; i < COUNT_OF_COMMANDS; i++) begin
            if (rez[i] < 2 ** ROM_WIDTH) begin
                instruction = {cmd_rom[SIZE_OF_COMMAND * i], 
                               cmd_rom[SIZE_OF_COMMAND * i + 1], 
                               cmd_rom[SIZE_OF_COMMAND * i + 2]};
                $display ("IP: %2d, DEST: R%2d, RESULT: %d", i, instruction[19:15], rez[i][7:0]);
                mem_ram[instruction[19:15]] <= rez[i][7:0];
                mem_ram_two[instruction[19:15]] <= rez[i][7:0];
                instrPointer[i] = 0;
                instrPointer[i + 1] = 1;
            end else
            if (rez[i] != 511) begin
                instrPointer[i] = 0;
                if (rez[i] > 287 && rez[i] < 320) begin
                    $display("IP: %2d, JUMP TO: %2d", i, rez[i]-288);
                    instrPointer[rez[i]-288] = 1;
                end;
                if (rez[i] > 319 && rez[i] < 352) begin
                    $display("IP: %2d, STORE: R%2d", i, rez[i]-320);
                    instrPointer[i + 1] = 1;
                    output_data = mem_ram[rez[i]-320];
                    ready = 1;
                end;
                if (rez[i] == OVERFLOW || rez[i] == MINUS || rez[i] == SUCCESS) begin
                    if (rez[i] == SUCCESS)
                        $display("SUCCESS!");
                    else begin
                        error = 1; 
                        if (rez[i] == OVERFLOW)
                            $display("OVERFLOW!" );
                        else
                            $display("MINUS!");
                    end;
                    exit = 1;
                end;
                if (rez[i] == {INCIP_CODE, 5'b00000}) begin
                    $display("IP: %2d, JUMP TO %2d", i, i + 1);
                    instrPointer[i + 1] = 1;
                end;
            end;
            rez[i] = 511;
        end;
         
    always @(negedge clkMem) begin
        ready = 0;
        output_data = 0;
    end;
           
    generate
        for (genvar i = 0; i < COUNT_OF_COMMANDS; i++) begin: alu
             ALU ALU_0 ( .clk(clkALU), .instruction({cmd_rom[SIZE_OF_COMMAND * i], 
                         cmd_rom[SIZE_OF_COMMAND * i + 1], cmd_rom[SIZE_OF_COMMAND * i + 2]}), 
                         .data_in_first(mem_ram[cmd_rom[SIZE_OF_COMMAND * i + 1][6:2]]), 
                         .data_in_second(mem_ram[cmd_rom[SIZE_OF_COMMAND * i + 2][7:0]]), 
                         .rez(rez[i]), .IP_in(instrPointer[i]) );
        end;
    endgenerate;
endmodule
