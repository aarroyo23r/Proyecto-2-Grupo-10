`timescale 1ns / 1ps

module Protocolo_rtc( 
    input wire clk, //Señal clk de 100Mhz
    input wire [7:0]address, //Dirección donde se modifique un dato
    input wire [7:0]DATA_WRITE, //Dato modificado +1 o -1
    input wire IndicadorMaquina, //Bit indicador de maquina general
    output wire ChipSelect,Read,Write,AoD, //Señales de control rtc
    inout  wire [7:0]DATA_ADDRESS, //Patillas bi-direccionales rtc
    output wire bit_inicio, //Bit que indica inicio de escritura
    output wire [7:0] data_vga //datos al controlador de la vga
);

GeneradorFunciones Gd_tbunit(.clk(clk),.IndicadorMaquina(IndicadorMaquina),.ChipSelect1(ChipSelect),.Read1(Read),.Write1(Write),.AoD1(AoD));

reg [7:0]Dir_Dato;
reg [7:0]in_out;
reg [7:0]data_vga1;
reg bitinicio;
assign DATA_ADDRESS = in_out;
assign data_vga = data_vga1;

always @(posedge clk)begin //FUNCION WRITE
if(AoD==0 && IndicadorMaquina==0)begin     //LEE LA DIRECCIÓN a modificar
    Dir_Dato <= address;
    in_out <= Dir_Dato; end //Pasa la dirección a las patillas AD0-7
else
if(AoD==1 && IndicadorMaquina==0) begin //LEE LOS DATOS PARA ESCRIBIR EN EL RTC
    Dir_Dato <= DATA_WRITE;    
    in_out <= Dir_Dato;end    //Lee asigna los datos a modificar o las direcciones a la patilla bi-direccional
end

always @(posedge clk)begin //FUNCIOÓN READ
if(AoD==0 && IndicadorMaquina==1 && Read==1)begin  //LEE LA DIRECCIÓN  a leer
    Dir_Dato <= address;
    in_out <= Dir_Dato;end    //Pasa la dirección a las patillas AD0-7
else
if(AoD==1 && IndicadorMaquina==1 && Read==0)begin //LEE DATO DEL RTC
        data_vga1 <= in_out;end      //Asigna el valor de las patillas a la variable
end

always @(posedge clk)begin //Compara para generar bit de inicio de lectura
    if(address==8'b00100001 && IndicadorMaquina==1)
        bitinicio<=1;
      else
        bitinicio<=0;
  end
endmodule
