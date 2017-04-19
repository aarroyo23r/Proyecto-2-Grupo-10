`timescale 1ns / 1ps

module TOP_tb();
   reg Reset,clk,Escribir,ProgramarCrono;
   reg push_izquierda,push_derecha,push_arriba,push_abajo;
   wire ChipSelect,Read,Write,AoD;//Señales de control rtc
   wire  [11:0] rgbO;

 TOP unit(
           .clk(clk),.Reset(Reset),.ProgramarCrono(ProgramarCrono)
           ,.Escribir(Escribir),
           .ChipSelect(ChipSelect),.Read(Read),.Write(Write),.AoD(AoD),
           .push_derecha(push_derecha),.push_izquierda(push_izquierda),
           .push_arriba(push_arriba),.push_abajo(push_abajo),.rgbO(rgbO));
 
 initial
 begin
 push_izquierda=0;
 push_derecha=0;
 push_arriba=0;
 push_abajo=0;
 clk=1;
 Reset=0;
 Escribir=0;
 ProgramarCrono=0;
 #10000;
 #40000;
 Escribir=1;
 #400000;
 Escribir=0;
 #40000;
 ProgramarCrono=1;
 #40000;
 ProgramarCrono=0;
 #40000;
 Reset=1;
 #40000;
 Reset=0;
 #40000;
Escribir=1;
 #40000;
 
 end
 

 always
 begin
clk=~clk; 
#5;
 end


 endmodule

