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
                           BRANCH, JUMP, EXIT, MOD } functcode;
                          
typedef enum logic [8:0] { OVERFLOW = 9'b110000000, DEVIDE_BY_ZERO = 9'b110000001, 
                           MINUS = 9'b110000010, SUCCESS = 9'b110000011 } exitcode;
                           
typedef enum logic [3:0] { INCIP_CODE = 4'b1000, JUMP_CODE = 4'b1001, STORE_CODE = 4'b1010 } code;

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

adder_8 adder(.a(data_in_first), .b(data_in_second), .cin(1'b0), .sum(sum),.cout(cout));

always @(posedge clk) begin
    if (IP_in) begin
        case (op)
            ADD:  rez <= cout ? OVERFLOW : sum;
            SUB:  rez <= data_in_first >= data_in_second ? 
                         data_in_first - data_in_second : MINUS;
            MUL:  rez <= data_in_first * data_in_second > 255 ? OVERFLOW : data_in_first * data_in_second;
            DIV:  rez <= data_in_first / data_in_second;
            MOD:  rez <= data_in_first % data_in_second;
            AND:  rez <= data_in_first & data_in_second;
            OR:   rez <= data_in_first | data_in_second;
            XOR:  rez <= data_in_first ^ data_in_second;
            ADDI: rez <= data_in_first + secondAddr; // adder
            SUBI: rez <= data_in_first - secondAddr;
            LOAD: rez <= instruction[14:7]; // <= 255
            STORE: rez <= {STORE_CODE, destAddr};
            BRANCH: rez <= data_in_first == data_in_second ? {JUMP_CODE, destAddr} : {INCIP_CODE, 5'b00000};
            JUMP: rez <= {JUMP_CODE, destAddr};
            EXIT: rez <= SUCCESS;
            default: rez <= 511;
        endcase
    end;
end; 

endmodule
