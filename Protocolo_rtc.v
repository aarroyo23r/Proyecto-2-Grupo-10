`timescale 1ns / 1ps

module Protocolo_rtc( 
    input wire clk, //Señal clk de 100Mhz
    input wire [7:0]address, //Dirección donde se modifique un dato
    input wire [7:0]DATA_WRITE, //Dato modificado +1 o -1
    input wire IndicadorMaquina, //Bit indicador de maquina general
    output wire ChipSelect,Read,Write,AoD, //Señales de control rtc
    inout  wire [7:0]DATA_ADDRESS, //Patillas bi-direccionales rtc
    output wire bit_inicio, //Bit que indica inicio de escritura
    output wire [7:0] data_vga
);

wire [7:0]contador;
GeneradorFunciones Gd_tbunit(.clk(clk),.IndicadorMaquina(IndicadorMaquina),.ChipSelect1(ChipSelect),.Read1(Read),.Write1(Write),.AoD1(AoD),.contador1(contador));


reg [7:0]Dir_Dato;
reg [7:0]data_vga1;                                                                                                                                                
reg bitinicio;                                                                        
reg [7:0]command = 8'b11110000;
assign bit_inicio = bitinicio;
assign data_vga =data_vga1;

//Función Write
assign DATA_ADDRESS =((AoD==0 && IndicadorMaquina==0 && contador<8'b10100000)|(contador>8'b01010001 && contador<8'b01010011 && IndicadorMaquina==0)) ? address:8'bZZZZZZZZ;
assign DATA_ADDRESS =((AoD==1 && ChipSelect ==0 && IndicadorMaquina==0 && contador <8'b10100000)|(contador>8'b01100001 && contador<8'b01100100 && IndicadorMaquina==0)) ? DATA_WRITE:8'bZZZZZZZZ;
assign DATA_ADDRESS =((AoD==0 && IndicadorMaquina==0 && contador>8'b10100000)|(contador>8'b11011101 && contador<8'b11011111 && IndicadorMaquina==0))? command:8'bZZZZZZZZ;

//FUNCIÓN READ
assign DATA_ADDRESS =((AoD==0 && IndicadorMaquina==1 && Read==1 && contador <8'b10100000)|(contador>8'b01010001 && contador<8'b01010011 && IndicadorMaquina==1))? command:8'bZZZZZZZZ;
assign DATA_ADDRESS =((AoD==0 && IndicadorMaquina==1 && Read==1 && contador >8'b10100000)|(contador>8'b11011101 && contador<8'b11011111 && IndicadorMaquina==1))? address:8'bZZZZZZZZ;

always @(posedge clk)begin //FUNCIOÓN READ
if(AoD==1 && IndicadorMaquina==1 && Read==0 && contador>8'b10100000)begin //LEE DATO DEL RTC
        data_vga1 <= DATA_ADDRESS;
        end
else
data_vga1<=8'b00000000;
end


always @(posedge clk)begin //Compara para generar bit de inicio de lectura
    if(address==8'b00100001 && IndicadorMaquina==1)
        bitinicio<=1;
      else
        bitinicio<=0;
  end
endmodule
