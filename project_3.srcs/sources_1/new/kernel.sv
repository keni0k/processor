`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2019 14:51:42
// Design Name: 
// Module Name: kernel
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module kernel
    #(parameter ROM_WIDTH = 8, ROM_ADDR_BITS = 8)
    (
    input  logic                        clk,
    input  logic                        reset,
    input  logic [ROM_WIDTH-1:0]        i_ReadData,
    output logic                        readyToWrite,
    output logic [ROM_WIDTH-1:0]        writeData,
    output logic [ROM_ADDR_BITS-1:0]    address
    );
    
    controller controller_0 (.clk( clk ), .reset(reset), .funct(funct ), .op(op));
    
endmodule
