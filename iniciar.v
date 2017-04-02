`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2017 10:08:04
// Design Name: 
// Module Name: iniciar
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


module iniciar(
    input wire clk,
   input wire enable,
   output wire [7:0] dir,
   output wire reset,
   output wire WR,
   output wire ready
   );


reg [9:0] clkr=9'b00000000;
reg [1:0] next, state;
reg [7:0] dir_reg;
reg reset_reg, WR_reg, ready_reg;


always @(posedge enable)begin
   next=1;
   dir_reg=8'b00000000;
   ready_reg=0;
   WR_reg=0;
   reset_reg=0;end 

always @(posedge clk)
if (enable)
begin
   case (state)
       2'b00: begin dir_reg=dir_reg+1;
              next=2'b01; end
       2'b01: begin
              reset_reg=1;
              if (WR_reg==0)begin
                next=2'b10;end 
              end 
       2'b10: begin if (dir_reg==8'b00001010)begin
                ready_reg=1;
                dir_reg=0;end
              else begin
                next=2'b00;end
              end
   endcase
end

always @(posedge clk)
   if(enable) state=next;

always @(posedge clk)
if (enable)
if(state==1)begin
begin
   clkr = clkr+1;
   WR_reg=1;
   if (clkr==9'b100000001)
       begin
       reset_reg=0;
       WR_reg=0;
       clkr=0;end end
end 


 assign WR=WR_reg;
 assign reset=reset_reg;
 assign dir=dir_reg;
 assign ready=ready_reg;

   
endmodule
