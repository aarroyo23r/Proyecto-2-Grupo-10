`timescale 1ns / 1ps

module Protocolo_rtc(
    input wire clk, //Señal clk de 100Mhz
    input wire [7:0]address, //Dirección del dato
    input wire [7:0]DATA_WRITE, //Dato modificado +1 o -1
    input wire IndicadorMaquina, //Bit indicador de maquina general
    output wire ChipSelect,Read,Write,AoD, //Señales de control rtc
    inout  wire [7:0]DATA_ADDRESS, //Patillas bi-direccionales rtc
    output wire [7:0] data_vga,
    output wire [6:0] contador_todo
);
wire contador;
GeneradorFunciones Gd_tbunit(.clk(clk),.IndicadorMaquina(IndicadorMaquina),.ChipSelect(ChipSelect),.Read(Read),.Write(Write),.AoD(AoD),.contador(contador_todo),.contador2(contador));


reg [7:0]command = 8'b11110000;
reg [7:0]data_write;



//Función Write
assign DATA_ADDRESS =((AoD==0 && Write==0 && IndicadorMaquina==0 && contador_todo<8'd37)) ? address:8'bZZZZZZZZ;
assign DATA_ADDRESS =((AoD==1 && Write==0 && IndicadorMaquina==0 && contador_todo<8'd37))?data_write:8'bZZZZZZZZ;
assign DATA_ADDRESS =((AoD==0 && Write==0 && IndicadorMaquina==0 && contador_todo>8'd37))?command:8'bZZZZZZZZ;




//FUNCIÓN READ
assign DATA_ADDRESS =(!AoD && IndicadorMaquina && contador_todo <8'd37)? command:8'bZZZZZZZZ;
assign DATA_ADDRESS =(!AoD && IndicadorMaquina && contador_todo>8'd37)? address:8'bZZZZZZZZ;


assign data_vga= (contador_todo>=8'h3d && contador_todo<=8'h44 && IndicadorMaquina)? DATA_ADDRESS:8'hZZ;



endmodule
