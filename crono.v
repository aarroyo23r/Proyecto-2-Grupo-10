`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2017 23:52:53
// Design Name: 
// Module Name: crono
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


module crono(
    input wire clk,
    output wire WR_inistop,
    output wire [2:0] inistop,
    output wire [7:0] dir,
    output wire ring,
    input wire push,
    input wire crono_end,
    input wire reset
    );
    
reg [2:0] next=0, state;
reg [8:0] clkr=0;
reg WR_inistop_reg=0, ring_reg;
reg [2:0] inistop_reg;
reg [7:0] dir_reg=0;

assign WR_inistop=WR_inistop_reg;
assign ring=ring_reg;
assign inistop=inistop_reg;
assign dir=dir_reg;

always @(clk)
case(state)
    3'b000:begin
        ring_reg=0;
        inistop_reg=0;
        if(push==0) next=0;
        else next=3'b001; 
    end
    3'b001: begin
            inistop_reg=3'b101;
            dir_reg=0;
            ring_reg=0;
            if(WR_inistop_reg==0) next=3'b010;
    end
    3'b010: begin
            ring_reg=0;
            inistop_reg=0;
            if(crono_end==0) next=3'b010;
            else next=3'b011;
    end
    3'b011: begin
            inistop_reg=3'b110;
            dir_reg=0;
            ring_reg=0;
            if(WR_inistop_reg==0) next=3'b100;
    end
    3'b100: begin
            ring_reg=1;
            inistop_reg=0;
            if(push==0) next=3'b100;
            else next=3'b000;
    end
endcase

always @(posedge clk)begin
    if(reset) state=0;
    else state=next;end

always @(posedge clk)
if(state==1 | state==3)begin
begin
    clkr = clkr+1;
    WR_inistop_reg=1;
    if (clkr==9'b100000001)
        begin
        WR_inistop_reg=0;
        inistop_reg=0;
        clkr=0;end 
end end

endmodule
