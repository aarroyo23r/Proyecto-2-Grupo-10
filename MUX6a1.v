`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2017 16:30:22
// Design Name: 
// Module Name: MUX6a1
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


module MUX6a1(
    input clk,
    input [7:0] A,
    input [7:0] B,
    input [7:0] C,
    input [7:0] D,
    input [7:0] E,
    input [7:0] F,
    output [7:0] Y,
    input [5:0] sel
    );
reg [7:0] Y_reg;
        assign Y=Y_reg;
        
        always @(posedge clk)
        case(sel)
            6'b000000: Y_reg=0;
            6'b100000: Y_reg=A;
            6'b010000: Y_reg=B;
            6'b001000: Y_reg=C;
            6'b000100: Y_reg=D;
            6'b000010: Y_reg=E;
            6'b000001: Y_reg=F;
        endcase
endmodule
