// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
// Date        : Sun Apr 28 10:51:54 2019
// Host        : DESKTOP-U4LH81I running 64-bit major release  (build 9200)
// Command     : write_verilog -mode funcsim -nolib -force -file
//               C:/Programming/schemotechnika/project_3/project_3.sim/sim_1/impl/func/xsim/memory_tb_func_impl.v
// Design      : kernel
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a12ticsg325-1L
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* ECO_CHECKSUM = "a49f590f" *) (* ROM_ADDR_BITS = "8" *) (* ROM_WIDTH = "8" *) 
(* NotValidForBitStream *)
module kernel
   (clk,
    reset,
    readData,
    readyToWrite,
    writeData);
  input clk;
  input reset;
  input [7:0]readData;
  output readyToWrite;
  output [7:0]writeData;

  wire readyToWrite;
  wire [7:0]writeData;

  OBUFT readyToWrite_OBUF_inst
       (.I(1'b0),
        .O(readyToWrite),
        .T(1'b1));
  OBUFT \writeData_OBUF[0]_inst 
       (.I(1'b0),
        .O(writeData[0]),
        .T(1'b1));
  OBUFT \writeData_OBUF[1]_inst 
       (.I(1'b0),
        .O(writeData[1]),
        .T(1'b1));
  OBUFT \writeData_OBUF[2]_inst 
       (.I(1'b0),
        .O(writeData[2]),
        .T(1'b1));
  OBUFT \writeData_OBUF[3]_inst 
       (.I(1'b0),
        .O(writeData[3]),
        .T(1'b1));
  OBUFT \writeData_OBUF[4]_inst 
       (.I(1'b0),
        .O(writeData[4]),
        .T(1'b1));
  OBUFT \writeData_OBUF[5]_inst 
       (.I(1'b0),
        .O(writeData[5]),
        .T(1'b1));
  OBUFT \writeData_OBUF[6]_inst 
       (.I(1'b0),
        .O(writeData[6]),
        .T(1'b1));
  OBUFT \writeData_OBUF[7]_inst 
       (.I(1'b0),
        .O(writeData[7]),
        .T(1'b1));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
