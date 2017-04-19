`timescale 1ns / 1ps

module TOP_tb();
   reg Reset,clk,Inicio,Escribir,ProgramarCrono;
   wire ChipSelect,Read,Write,AoD,bit_inicio; //Señales de control rtc

 TOP  uut(
           .clk(clk),.Reset(Reset),.ProgramarCrono(ProgramarCrono)
           ,.Escribir(Escribir),
           .ChipSelect(ChipSelect),.Read(Read),.Write(Write),.AoD(AoD), .bit_inicio1(bit_inicio)
);

 initial
 begin
 clk=1;
 Reset=0;
 //bit_inicio=0;
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
