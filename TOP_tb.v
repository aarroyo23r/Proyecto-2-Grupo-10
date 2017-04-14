`timescale 1ns / 1ps

module TOP_tb();
   reg Reset,clk,Inicio,Escribir,ProgramarCrono;
   wire ChipSelect,Read,Write,AoD; //Señales de control rtc

 TOP unit(
           .clk(clk),.Reset1(Reset),.ProgramarCrono(ProgramarCrono)
           ,.Escribir(Escribir),.Inicio1(Inicio),
           .ChipSelect(ChipSelect),.Read(Read),.Write(Write),.AoD(AoD));
 
 initial
 begin
 clk=1;
 Reset=0;
 Inicio=1;
 Escribir=0;
 ProgramarCrono=0;
 #10000;
 Inicio=0;
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

