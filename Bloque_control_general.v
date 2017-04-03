`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.03.2017 08:05:14
// Design Name: 
// Module Name: Bloque_control_general
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


module Bloque_control_general(
    input wire clk,
    input wire reset,
    input wire [3:0] switch,
    input wire inistop_crono,
    output wire [5:0] enable,
    input wire ready
    );
    
reg [2:0] next=0, state;
reg [5:0] enable_reg=0;

assign enable=enable_reg;

always @(posedge inistop_crono)begin
    enable_reg=0;
    state=1;
    next=1;
end

always @(posedge clk)begin
if(!inistop_crono)begin
case(state)
    3'b000: begin
                if (ready==1)next=3'b001;
                else next=3'b000;
             end
    3'b001: next=3'b010;
    3'b0010: begin
             if(ready==1)begin
             if (switch==0)
                next=3'b001;
             else if (switch==1)next=3'b011;
             else if (switch==4'b0010)next=3'b100;
             else if (switch==4'b0100)next=3'b101;
             else if (switch==4'b1000)next=3'b110;
             end end
    3'b011: if (ready==1) next=3'b111;
    3'b100: if (ready==1) next=3'b111;
    3'b101: if (ready==1) next=3'b111;
    3'b110: if (ready==1) next=3'b111;
    3'b111: begin
                if(ready)begin
                if (switch==0)next=3'b001;
                else next=3'b010; end
            end
endcase end end

always @(posedge clk or posedge reset)begin
    if(reset==1) state=0;
    else state=next;
 end

always @(state)

    if(state==4'b0000)begin
        enable_reg=6'b100000;
        end
    else if (state==4'b0001)begin
        enable_reg=6'b010000;
        end    
    else if (state==4'b0010)begin
        enable_reg=6'b010000;
        end 
    else if (state==4'b0011)begin
        enable_reg=6'b001000;
        end 
    else if (state==4'b0100)begin
        enable_reg=6'b000100;
        end 
    else if (state==4'b0101)begin
        enable_reg=6'b000010;
        end 
    else if (state==4'b0110)begin
        enable_reg=6'b000001;        
        end 
    else if (state==4'b0111)begin
        enable_reg=6'b010000;
        end 

endmodule
