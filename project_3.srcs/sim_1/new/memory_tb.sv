`timescale 1ns / 1ps

module memory_tb 
    #(parameter ROM_WIDTH = 8, ROM_ADDR_BITS = 8)();
    
    logic clk;
    logic read_enb;
    logic [ROM_ADDR_BITS/2-1:0] a, b;
    reg [ROM_WIDTH-1:0] output_data;
    
    memory DUT(.clk(clk), .read_enb(read_enb), .a(a), .b(b), .output_data(output_data));
    
    always begin
        clk = 1'b1; #5;
        clk = 1'b0; #5;
    end;
    
    initial begin
        read_enb = 1;
        {a, b} = 0;
        repeat(255) begin
            {a, b}++; #10;
        end
        read_enb = 0;
        {a, b} = 0;
        repeat(20) begin
            {a, b}++; #10;
        end
        $finish;
    end;

endmodule