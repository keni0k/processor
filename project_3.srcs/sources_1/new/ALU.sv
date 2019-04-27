`timescale 1ns / 1ps

module ALU
    #(parameter ROM_WIDTH = 8, ROM_ADDR_BITS = 5) // ROM WIDTH - how bits we have in 1 addr?
    (
    input  logic                clk,
    input  logic [7:0]          instruction,
    input  reg [ROM_WIDTH-1:0]  data_in,
    input  int                  ip_in,
    output int                  ip_out
    );

typedef enum logic [3:0] { ADDI, SUBI, ADD, SUB, MUL, DIV,
                           LOAD, STORE,
                           AND, XOR, OR, 
                           BRANCH, JUMP_REG, JUMP, NONE } functcode;

logic [3:0] op = instruction[3:0];
logic [3:0] destAddr = instruction[8:4];
logic [3:0] firstAddr = instruction[13:9];
logic [3:0] secondAddr = instruction[23:14];

always_comb
    case (op)
        ADD:  data_in[destAddr] <= data_in[firstAddr] + data_in[secondAddr];
        SUB:  data_in[destAddr] <= data_in[firstAddr] - data_in[secondAddr];
        MUL:  data_in[destAddr] <= data_in[firstAddr] * data_in[secondAddr];
        DIV:  data_in[destAddr] <= data_in[firstAddr] / data_in[secondAddr];
        AND:  data_in[destAddr] <= data_in[firstAddr] & data_in[secondAddr];
        OR:   data_in[destAddr] <= data_in[firstAddr] & data_in[secondAddr];
        XOR:  data_in[destAddr] <= data_in[firstAddr] & data_in[secondAddr];
        ADDI: data_in[destAddr] <= data_in[firstAddr] + secondAddr;
        SUBI: data_in[destAddr] <= data_in[firstAddr] - secondAddr;
        //LOAD: acc <= 
        //STORE:
        //BRANCH:
        //JUMP:
    endcase
         
endmodule
