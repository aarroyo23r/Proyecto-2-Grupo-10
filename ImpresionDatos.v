`timescale 1ns / 1ps

module ImpresionDatos
    (
    input wire clk,
    input wire [9:0] pixelx, //posición pixel actual
    input wire [9:0] pixely,
    output wire [10:0] rom_addr,
    output wire [1:0] font_size,// Tamaño de fuente
    output wire [3:0] color_addr //Tres bits porque por ahora se van a manejar 15 colores
 );

 //variables internas de conexió

 wire [6:0] char_addr; //  bits mas significativos de dirreción de memoria
 wire [3:0] row_addr; // bit menos significativos de memoria, para variar filas




//body
assign row_addr= pixely[3:0]; //4 bits menos significatvos de y

always @(pixelx or pixely)
    
    if ((pixelx < 10'b0000010111) && (pixelx>10'b0000001111))begin
        char_addr = SegundosU;end
        color_addr=4'd2;
        font_size=1; end
        
    else if ((pixelx < 10'b0000001111) && (pixelx>10'b0000000111))begin
         char_addr = SegundosD;end
         
  else  if (pixelx < 10'b0000000111)begin
         char_addr = minutosU;end
         
   else if ((pixelx > 10'b0000010110) | (pixely>5'b0000001111))begin
         char_addr = minutosD;end
 end
 
 else 
 begin
 char_addr = minutosD;end
 end

assign rom_addr ={char_addr, row_addr}; //concatena direcciones de registros y filas


endmodule 
