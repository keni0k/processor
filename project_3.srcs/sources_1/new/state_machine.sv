`timescale 1ns / 1ps

module state_machine(
    input logic         clk,
    input logic         reset,
    input logic [5:0]   op,
    output logic        memwrite,
    output logic        regwrite,
    output logic        regdst,
    output logic        alusrca,
    output logic [1:0]  alusrcb,
    output logic [1:0]  aluop
    );
    typedef enum logic [2:0] {S_RESET = 4'b0000,
                          S_FETCH,
                          S_DECODE,
                          S_MEMADR} statetype;
    statetype state, nextstate;
    
    
endmodule
