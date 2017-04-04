`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2017 17:56:50
// Design Name: 
// Module Name: Sumador_dato
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


module Sumador_dato(
    input wire [7:0] dato_rtc,
    output wire [7:0] dato,
    input wire [1:0] push,
    input wire clk,
    input wire enable,
    input wire reset
    );
    
reg [7:0] dato_reg=0, dato_temp=0;
reg [1:0] state, next;

assign dato=dato_reg;

always @(posedge enable)begin
    next=0;
    dato_temp=0;end

    
always @(posedge clk)
if(enable) begin
    case(state)
        2'b00:begin dato_temp=dato_rtc;
                if(push==2'b00)
                next=2'b10;
                else next=2'b01;end
        2'b01:begin if (push==2'b01)dato_temp=dato_temp-1;
               else if (push==2'b10) begin dato_temp=dato_temp+1;end
               next=2'b10;end 
        2'b10: begin
                next=2'b00;
                dato_reg=dato_temp;end
        endcase
end

always @(posedge clk or posedge reset)
    if(reset==1) state=0;
    else state=next;

endmodule
