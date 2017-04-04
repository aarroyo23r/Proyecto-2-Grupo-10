`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2017 17:56:50
// Design Name: 
// Module Name: Sumador_posicion
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


module Sumador_posicion(
    input wire [7:0] dir_in,
    output wire [7:0] dir_out,
    input wire [1:0] push,
    input wire clk,
    input wire enable,
    input wire camb_crono,
    input wire camb_hora,
    input wire camb_fecha,
    input wire reset
    );
reg [7:0] dir_out_reg, dir_out_temp;
reg [1:0] state, next;

assign dir_out=dir_out_reg;

always @(posedge enable)begin
    dir_out_temp=0;
    next=0;end

    

always @(posedge clk)
if(enable)begin
case(state)
    2'b00:begin dir_out_temp=dir_in;
            if(push==2'b00)
            next=2'b10;
            else next=2'b01;end
    2'b01:begin 
           if (push==2'b01)begin dir_out_temp=dir_out_temp-1;
           end 
           else if (push==2'b10) begin dir_out_temp=dir_out_temp+1;end
           next=2'b10;end 
    2'b10:begin
            if(camb_crono)begin
                if(dir_out_temp!=1 & dir_out_temp!=2 & dir_out_temp!=3 & dir_out_temp!=4)
                    dir_out_temp=1;
               end
            else if(camb_hora)begin
                   if(dir_out_temp!=5 & dir_out_temp!=6 & dir_out_temp!=7)
                       dir_out_temp=5;
            end
            else if(camb_fecha)begin
                   if(dir_out_temp!=8 & dir_out_temp!=9 & dir_out_temp!=10)
                       dir_out_temp=8;
            end 
            next=2'b11;   
          end
    2'b11: begin
           next=2'b00;
           dir_out_reg=dir_out_temp;end
    endcase
end
    
always @(posedge clk or posedge reset)
    if(reset==1) state=0;
    else state=next;
    
            
endmodule
