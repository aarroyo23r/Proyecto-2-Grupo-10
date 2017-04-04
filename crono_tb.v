`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2017 22:43:45
// Design Name: 
// Module Name: crono_tb
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


module crono_tb(

    );
    reg clk;
    wire WR_inistop;
    wire [2:0] inistop;
    wire [7:0] dir;
    wire ring;
    reg push;
    reg crono_end;
    reg reset;    

crono crono(
        .clk(clk),
        .WR_inistop(WR_inistop),
        .inistop(inistop),
        .dir(dir),
        .ring(ring),
        .push(push),
        .crono_end(crono_end),
        .reset(reset)
        );
        
initial
begin
clk=0;
crono_end=0;
push=0;
reset=1;
#10 reset=0;
end

always
begin
#10 push=1;
#25000 push=0; crono_end=1;
#10 crono_end=0;
#1000 push=1;
end

 always 
begin
   #5 clk = ~clk;
end

endmodule
