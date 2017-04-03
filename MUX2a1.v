`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2017 16:01:50
// Design Name: 
// Module Name: MUX2a1
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


module MUX2a1(
    input clk,
    input [3:0] A,
    output [3:0] Y,
    input sel,
    input [3:0] B
    );
    
reg [3:0] Y_reg;
    assign Y=Y_reg;
    
    always @(posedge clk)
    case(sel)
        0: Y_reg=A;
        1: Y_reg=B;
    endcase
    
endmodule
