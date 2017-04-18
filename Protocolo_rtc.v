`timescale 1ns / 1ps

module Protocolo_rtc( 
    input wire clk, //Señal clk de 100Mhz
    input wire bit_crono,
    input wire [7:0]address, //Dirección del dato
    input wire [7:0]DATA_WRITE, //Dato modificado +1 o -1
    input wire IndicadorMaquina, //Bit indicador de maquina general
    output wire ChipSelect,Read,Write,AoD, //Señales de control rtc
    inout  wire [7:0]DATA_ADDRESS, //Patillas bi-direccionales rtc 
    output reg [7:0] data_vga,
    output wire [7:0] contador2
);

wire [7:0]contador;
GeneradorFunciones Gd_tbunit(.clk(clk),.IndicadorMaquina(IndicadorMaquina),.ChipSelect1(ChipSelect),.Read1(Read),.Write1(Write),.AoD1(AoD),.contador1(contador));
reg [7:0]Dir_Dato;
reg [7:0]data_vga1;                                                                                                                                                
reg bitinicio;                                                                        
reg [7:0]command = 8'b11110000;
assign bit_inicio = bitinicio;
assign contador2 = contador;

//MULTIPLEXA ENTRE DATO MODIFICADO Y DATO PARA ENABLE DEL CRONOMETO
reg [7:0]data_write;
always@(posedge clk)begin
     if(bit_crono==1 && address==8'b00000000)begin
       data_write<=8'b00001000;
    end
    else
       data_write <= DATA_WRITE;
end

//Función Write
assign DATA_ADDRESS =((AoD==0 && Write==0 && IndicadorMaquina==0 && contador<8'b10100000)|(contador>8'b01010001 && contador<8'b01010011 && IndicadorMaquina==0)) ? address:8'bZZZZZZZZ;
assign DATA_ADDRESS =((AoD==1 && Write==0 && ChipSelect ==0 && IndicadorMaquina==0 && contador <8'b10100000)|(contador>8'b01100001 && contador<8'b01100100 && IndicadorMaquina==0)) ? data_write:8'bZZZZZZZZ;
assign DATA_ADDRESS =((AoD==0 && Write==0 && IndicadorMaquina==0 && contador>8'b10100000)|(contador>8'b11011101 && contador<8'b11011111 && IndicadorMaquina==0))? command:8'bZZZZZZZZ;

//FUNCIÓN READ
assign DATA_ADDRESS =((AoD==0 && Write==0 && IndicadorMaquina==1 && Read==1 && contador <8'b10100000)|(contador>8'b01010001 && contador<8'b01010011 && IndicadorMaquina==1))? command:8'bZZZZZZZZ;
assign DATA_ADDRESS =((AoD==0 && Write==0 && IndicadorMaquina==1 && Read==1 && contador >8'b10100000)|(contador>8'b11011101 && contador<8'b11011111 && IndicadorMaquina==1))? address:8'bZZZZZZZZ;


always@(posedge clk)
begin
    if(AoD==1 && IndicadorMaquina==1 && Read==0 && contador>8'b10100000)
    begin
    data_vga<=DATA_ADDRESS;
    end
    else
    data_vga<=8'hZZ;
end
endmodule
