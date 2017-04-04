`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.04.2017 12:50:38
// Design Name: 
// Module Name: Control_direcciones_datos_tb
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


module Control_direcciones_datos_tb(

    );
    
    
reg [7:0] dir_in;
wire [7:0] dir_out;
wire [7:0] dir_rtc;
reg [7:0] dato_rtc;
wire [7:0] dato;
reg [3:0] push;
reg clk, camb_crono, camb_hora, camb_fecha, reinicio, reset;

Control_direcciones_datos Control_direcciones_datos(
    .dir_in(dir_in),
    .dir_out(dir_out),
    .dir_rtc(dir_rtc),
    .dato_rtc(dato_rtc),
    .dato(dato),
    .push(push),
    .clk(clk),
    .camb_crono(camb_crono),
    .camb_hora(camb_hora),
    .camb_fecha(camb_fecha),
    .reinicio(reinicio),
    .reset(reset)
    );
    
initial
    begin
    clk=0;
    reset=1;
    camb_crono=0;
    camb_hora=0;
    camb_fecha=0;
    reinicio=0;
    dir_in=0;
    push=0;
    dato_rtc=0;
    #10 reset=0;
 end
 
 always
 begin
 #10 camb_crono=1;
 #10 dir_in=1;
 #2560 dato_rtc=8'b01010101;
 #10push=4'b0010;
 #2560 dato_rtc=8'b01010111;
 #10push=4'b1000;
  #10 camb_crono=0;
  camb_hora=1;
 #10 dir_in=5;
 #2560 dato_rtc=8'b01010101;
 #10push=4'b0010;
 #2560 dato_rtc=8'b01010111;
 #10push=4'b1000;
  #10 camb_hora=0; 
  camb_fecha=1;
 #10 dir_in=8;
 #2560 dato_rtc=8'b01010101;
 #10push=4'b0010;
 #2560 dato_rtc=8'b01010111;
 #10push=4'b1000;
  #10 camb_fecha=0; 
  reinicio=1;
 #10 dir_in=1;
 #2560 dato_rtc=8'b01010101;
 #10push=4'b0010;
 #2560 dato_rtc=8'b01010111;
 #10push=4'b1000;
 reinicio=0;
 end
 
 
       always 
begin
   #5 clk = ~clk;
end

endmodule
