`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.03.2017 23:28:17
// Design Name: 
// Module Name: camb_crono
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


module camb_crono(
    input wire clk,
    input wire enable,
    input wire [7:0] dir_in,
    output wire [7:0] dir_out,
    output wire camb_crono,
    output wire WR,
    output wire RD,
    output wire ready,
    input wire reset
    );
    
    reg [8:0] clkr=9'b000000000;
    reg [2:0] next, state;
    reg  [7:0] dir_out_reg=0;
    reg RD_reg=0, WR_reg=0, ready_reg=0, camb_crono_reg=0;
        
    always @(posedge enable)begin
        RD_reg<=0;
        WR_reg<=0;
        ready_reg=0;
        next<=3'b000;
        state=0;
        clkr=0;
        camb_crono_reg=1;
        end 
    
    always @(posedge clk)
    if(!enable)begin
        camb_crono_reg=0;
        ready_reg=0;
        RD_reg=0;
        WR_reg=0;
    end
    else if (enable)
    begin
        case (state)
            3'b000: begin 
                    if (dir_in==4 || dir_in==1 || dir_in==2 || dir_in==3) dir_out_reg=dir_in;
                    else dir_out_reg=1;
                   next=3'b001; end
            3'b001: begin
                   next=3'b010;
                   RD_reg=1; end
            3'b010: begin
                   if (RD_reg==0)begin
                     next=3'b011;end 
                   end 
            3'b011: begin
                   if (WR_reg==0)begin
                      ready_reg=1;
                      next=3'b100;
                      end 
                   end 
            3'b100: begin
                     ready_reg=1;
                     next=3'b000;
                   end
        endcase
    end
    
  always @(posedge clk or posedge reset)
        if(reset==1) state=0;
        else state=next;
    
    always @(posedge clk)begin
    if (enable & !reset)begin
    if (state==2)
    begin
        clkr = clkr+1;
        RD_reg=1;
        if (clkr==9'b100000001)begin
        RD_reg=0;
        WR_reg=1;
        clkr=0;end
    end 
    else if(state==3)
    begin
        clkr = clkr+1;
        WR_reg=1;
        if (clkr==9'b100000000)begin
        WR_reg=0;
        clkr=0;end
    end end
    end
 
 assign RD=RD_reg;
 assign WR=WR_reg;
 assign ready=ready_reg;
 assign dir_out=dir_out_reg;
 assign camb_crono=camb_crono_reg;
 
endmodule
