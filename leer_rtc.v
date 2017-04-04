`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2017 15:12:48
// Design Name: 
// Module Name: leer_rtc
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


module leer_rtc(
    input wire enable,
    input wire reset,
    output wire RD,
    output wire WR,
    input wire clk,
    output  wire [7:0] dir_rd,
    output wire ready
    );


reg [1:0] next=2'b01, state=2'b01;
reg [8:0] clk_reg=0;
reg [7:0] dir_rd_reg=0;
reg ready_reg=0, RD_reg=0, WR_reg=0;


always @(posedge enable)begin
dir_rd_reg=0;
ready_reg=0;
RD_reg=0;end

always @(posedge clk)
    if(!enable)begin
    ready_reg=0;
    RD_reg=0;
    WR_reg=0;
end
else if (enable)
begin
    case (state)
        2'b00: begin dir_rd_reg=dir_rd_reg+1;
               ready_reg=0;
               next=2'b01;end 
        2'b01: begin ready_reg=0;
               if (RD_reg==0)begin
                 next=2'b10;
                end 
               end
        2'b10: begin RD_reg=0;
                if (dir_rd_reg==8'b00001010)begin
                 ready_reg=1;
                 dir_rd_reg=8'b00000001;
                 next=2'b01;end
               else begin
                 next=2'b00;
                 end  
               end 
    endcase 
end

always @(posedge clk or posedge reset)
    if(reset==1) state=1;
    else state=next;

always @(posedge clk)
if (enable & !reset)
if(state==1)begin
begin
    clk_reg = clk_reg+1;
    RD_reg=1;
    if (clk_reg==9'b100000001)begin
    RD_reg=0;
    clk_reg=0;end end
end

assign ready=ready_reg;
assign dir_rd=dir_rd_reg;
assign RD=RD_reg;
assign WR=WR_reg;

endmodule