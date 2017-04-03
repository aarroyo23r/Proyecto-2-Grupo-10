`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2017 10:55:18
// Design Name: 
// Module Name: ROM_addr
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


module ROM_addr(
    input wire clk,
    input wire [7:0] dir,
    output wire [7:0] dir_rtc
    );

reg [7:0] dir_rtc_reg;
assign dir_rtc=dir_rtc_reg;

always @(posedge clk)
case(dir)
    8'b00000000: dir_rtc_reg=8'h00;
    8'b00000001: dir_rtc_reg=8'h64;
    8'b00000010: dir_rtc_reg=8'h65;
    8'b00000011: dir_rtc_reg=8'h66;
    8'b00000100: dir_rtc_reg=8'h67;        
    8'b00000101: dir_rtc_reg=8'h33;    
    8'b00000110: dir_rtc_reg=8'h34;
    8'b00000111: dir_rtc_reg=8'h35;
    8'b00001000: dir_rtc_reg=8'h36;
    8'b00001001: dir_rtc_reg=8'h37;
    8'b00001010: dir_rtc_reg=8'h38;  
    endcase                  
endmodule
