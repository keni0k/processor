`timescale 1ns / 1ps

module ALU
    #(parameter ROM_WIDTH = 8, ROM_ADDR_BITS = 5)
    (
        input  logic                 clk,
        input  logic [23:0]          instruction,
        input  reg [ROM_WIDTH-1:0]   data_in_first,
        input  reg [ROM_WIDTH-1:0]   data_in_second,
        input  logic                 IP_in,
        output logic [ROM_WIDTH:0]   rez
    );

typedef enum logic [3:0] { ADDI, SUBI, ADD, SUB, MUL, DIV,
                           LOAD, STORE,
                           AND, XOR, OR, 
                           BRANCH, JUMP, NONE } functcode;
                          
typedef enum logic [8:0] { OVERFLOW = 9'b100000000, DEVIDE_BY_ZERO = 9'b101000000, 
                           MINUS = 9'b100100000,
                           MOVE_X = 9'b110000000, MOVE_Z = 9'b111000000 } errorcode;

logic [3:0] op;
logic [4:0] destAddr;
logic [4:0] firstAddr;
logic [9:0] secondAddr;
logic [7:0] sum;
logic cout;
assign op = instruction[23:20];
assign destAddr = instruction[19:15];
assign firstAddr = instruction[14:10];
assign secondAddr = instruction[9:0];

adder_8 adder(.a(data_in_first), .b(data_in_second), .cin(0), .sum(sum),.cout(cout));

always @(posedge clk) begin
    if (IP_in) begin
        case (op)
            ADD:  rez <= cout ? OVERFLOW : sum;
            SUB:  rez <= data_in_first >= data_in_second ? 
                         data_in_first - data_in_second : MINUS;
            MUL:  rez <= data_in_first * data_in_second;
            DIV:  rez <= data_in_first / data_in_second;
            AND:  rez <= data_in_first & data_in_second;
            OR:   rez <= data_in_first | data_in_second;
            XOR:  rez <= data_in_first ^ data_in_second;
            ADDI: rez <= data_in_first + secondAddr; // adder
            SUBI: rez <= data_in_first - secondAddr;
            LOAD: 
                begin
//                    rez <= instruction[6:0] ? OVEWFLOW : instruction[14:7];
                    rez <= instruction[14:7];
                end
//            STORE:
//            BRANCH:
            JUMP: rez <= {4'b1110, destAddr};
            NONE: rez <= 511;
            default: rez <= 511;
        endcase
    end;
end; 

endmodule
