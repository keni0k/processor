`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2019 22:22:30
// Design Name: 
// Module Name: controller
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


module controller(
    input logic         clk,
    input logic         reset,
    input logic [5:0]   funct,
    input logic [5:0]   op,
    output logic        memwrite,
    output logic        iord,
    output logic [1:0]  pcsrc,
    output logic [1:0]  alusrcb,
    output logic [2:0]  alucontrol);
    
endmodule
