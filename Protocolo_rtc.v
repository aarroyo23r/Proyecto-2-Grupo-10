`timescale 1ns / 1ps

module Protocolo_rtc( 
    input wire clk, //Señal clk de 100Mhz
    input wire [7:0]address, //Dirección donde se modifique un dato
    input wire [7:0]DATA_WRITE, //Dato modificado +1 o -1
    input wire IndicadorMaquina, //Bit indicador de maquina general
    output wire ChipSelect,Read,Write,AoD, //Señales de control rtc
    inout  wire [7:0]DATA_ADDRESS, //Patillas bi-direccionales rtc
    output wire bit_inicio, //Bit que indica inicio de escritura
    output wire [7:0] data_vga, //datos al controlador de la vga
    output wire [7:0] entra_rtc
);

wire [7:0]contador;
GeneradorFunciones Gd_tbunit(.clk(clk),.IndicadorMaquina(IndicadorMaquina),.ChipSelect1(ChipSelect),.Read1(Read),.Write1(Write),.AoD1(AoD),.contador1(contador));

wire[7:0]DATA_WRITE1;
reg [7:0]Dir_Dato;
reg [7:0]data_vga1;
reg bitinicio;
reg [7:0]command = 8'b11110000;

assign DATA_ADDRESS =~Write ? Dir_Dato:8'bZ;
assign bit_inicio = bitinicio;
assign data_vga =data_vga1;
assign DATA_WRITE1 = DATA_WRITE;
assign entra_rtc =DATA_ADDRESS;


always @(posedge clk)begin //FUNCION WRITE
if(AoD==0 && IndicadorMaquina==0 && Write && contador<8'b10100000)begin     //LEE LA DIRECCIÓN a modificar
    Dir_Dato <= address;  //en la primera etapa describe la dirrección a modificar
     end //Pasa la dirección a las patillas AD0-7
if(AoD==1 && IndicadorMaquina==0 && Write==0 && contador <8'b10100000)begin //LEE LOS DATOS PARA ESCRIBIR EN EL RTC
    Dir_Dato <= DATA_WRITE;      //Lee asigna los datos a modificar o las direcciones a la patilla bi-direccional
end  
if(AoD==0 && IndicadorMaquina==0 && contador>8'b10100000) begin
     Dir_Dato <=command;
end
else
Dir_Dato<=8'bZ;
end


always @(posedge clk)begin //FUNCIOÓN READ
if(AoD==0 && IndicadorMaquina==1 && Read==1 && contador <8'b10100000)begin  //LEE LA DIRECCIÓN  
    Dir_Dato <= command;        //en la primera etapa de la función escribe en el rtc la dirección del command
    end    //le suma 1 al contador para solo hacer esto en la primera etapa
if(AoD==0 && IndicadorMaquina==1 && Read==1 && contador >8'b10100000)begin
        Dir_Dato <= address;        //en la segunda etapa de la función escribe la dirección de RAM a leer
        end
if(AoD==1 && IndicadorMaquina==1 && Read==0 && contador>8'b10100000)begin //LEE DATO DEL RTC
        data_vga1 <= DATA_ADDRESS;
        end
else
Dir_Dato <= 8'bZ;
data_vga1<=8'bZ;
end


always @(posedge clk)begin //Compara para generar bit de inicio de lectura
    if(address==8'b00100001 && IndicadorMaquina==1)
        bitinicio<=1;
      else
        bitinicio<=0;
  end
endmodule
