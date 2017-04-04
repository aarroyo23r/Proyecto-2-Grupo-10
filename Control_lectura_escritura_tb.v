`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2017 09:31:46
// Design Name: 
// Module Name: Control_lectura_escritura_tb
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


module Control_lectura_escritura_tb(

    );
    
 reg clk;
 reg reset;
 reg inistop_crono;
 reg [3:0] switch;
 wire camb_hora1;
 wire camb_fecha1;
 wire camb_crono1;
 wire reinicio1;
 wire RD_WR;
 reg [7:0] dir_in;
 wire [7:0] dir_out;
 
 
 Control_lectura_escritura Control_lectura_escritura(
     .clk(clk),
     .reset(reset),
     .inistop_crono(inistop_crono),
     .switch(switch),
     .camb_hora1(camb_hora1),
     .camb_fecha1(camb_fecha1),
     .camb_crono1(camb_crono1),
     .reinicio1(reinicio1),
     .RD_WR(RD_WR),
     .dir_in(dir_in),
     .dir_out(dir_out)
     );
     
initial
begin
clk=0;
reset=1;
inistop_crono=0;
#10 reset=0;
end
     
     
     always begin
     dir_in=0;
     #51000 switch=1;
     #51200 dir_in=1;
     #51200 dir_in=2;
     #51200 dir_in=3;
     #51200 dir_in=4;
     #51200 dir_in=5; 
     #10 switch=0;
     #10 inistop_crono=1;
     #2560 inistop_crono=0;
     #51000 switch=2;
     #51200 dir_in=5;
     #51200 dir_in=6;
     #51200 dir_in=7;
     #51200 dir_in=8; 
     #10 switch=0;
     #10 inistop_crono=1;
     #2560 inistop_crono=0;
     #51000 switch=4;
     #51200 dir_in=8;
     #51200 dir_in=9;
     #51200 dir_in=10;
     #51200 dir_in=11; 
     #10 switch=0;
     #10 inistop_crono=1;
     #2560 inistop_crono=0;
     #51000 switch=8;
     #51000 switch=0;
     #10 inistop_crono=1;
     #2560 inistop_crono=0;    
     end
     
     
      always 
     begin
        #5 clk = ~clk;
     end
     
endmodule
