`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2017 19:25:24
// Design Name: 
// Module Name: MUX
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


module MUX(
    input wire clk,
    input wire [7:0] A,
    input wire [7:0] B,
    output wire [7:0] Y,
    input wire sel
    );
reg [7:0] Y_reg;
assign Y=Y_reg;

always @(posedge clk)
case(sel)
    0: Y_reg=A;
    1: Y_reg=B;
endcase
endmodule
