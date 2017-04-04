`timescale 1ns / 1ps
module Registros(
    input wire clk,bit_inicio1,
    input wire [7:0] data_vga,
    input wire [7:0] contador,
    output wire [7:0] data_vga_final,
    input wire Read    
    );

reg[3:0]contador_datos=8'b00000000;
reg [7:0]data_write;
reg [7:0]data_0;reg [7:0]data_1;reg [7:0]data_2;
reg [7:0]data_3;reg [7:0]data_4;reg [7:0]data_5;reg [7:0]data_6;
reg [7:0]data_7;reg [7:0]data_8;reg [7:0]data_9;reg [7:0]data_10;
reg[3:0]contador_clks=8'b00000000;   //contador para manda el dato a 1 clk por segundo
reg data_pre_vga=8'b00000000;
reg [3:0] contador_unico=4'b0000;


always @(posedge clk)begin
    if(Read==0)begin
    
    end
end

always @(posedge clk)begin
   if(Read==0 && contador==8'b10100011)begin
   contador_datos <= contador_datos + 1'b1;
   if(contador_datos==4'b1011)begin          //contador indica cuando han pasado los 11 datos
        contador_datos<=4'b0000;
   end
   end
end

always@(posedge clk)begin
    if(contador_datos==4'b0001)begin
        data_0<=data_vga;
    end
    if(contador_datos==4'b0010)begin
        data_1<=data_vga;
    end
    if(contador_datos==4'b0011)begin
        data_2<=data_vga;
    end
    if(contador_datos==4'b0100)begin
        data_3<=data_vga;
    end
    if(contador_datos==4'b0101)begin
        data_4<=data_vga;
    end
    if(contador_datos==4'b0110)begin
         data_5<=data_vga;
    end
    if(contador_datos==4'b0111)begin
         data_6<=data_vga;
    end
    if(contador_datos==4'b1000)begin
         data_7<=data_vga;
    end
    if(contador_datos==4'b1001)begin
         data_8<=data_vga;
    end
    if(contador_datos==4'b1010)begin
         data_9<=data_vga;     
    end
    if(contador_datos==4'b1011)begin
         data_10<=data_vga;
    end
    else begin
    end
end

always @(posedge clk)begin
    contador_clks<=contador_clks +1'b1;
    if(contador_clks==4'b1011)begin
        contador_clks<=4'b0000;
    end
end
assign data_vga_final = (contador_clks==4'b0001)? data_0 :8'bZZZZZZZZ;
assign data_vga_final = (contador_clks==4'b0010)? data_1 :8'bZZZZZZZZ;
assign data_vga_final = (contador_clks==4'b0011)? data_2 :8'bZZZZZZZZ;
assign data_vga_final = (contador_clks==4'b0100)? data_3 :8'bZZZZZZZZ;
assign data_vga_final = (contador_clks==4'b0101)? data_4 :8'bZZZZZZZZ;
assign data_vga_final = (contador_clks==4'b0110)? data_5 :8'bZZZZZZZZ;
assign data_vga_final = (contador_clks==4'b0111)? data_6 :8'bZZZZZZZZ;
assign data_vga_final = (contador_clks==4'b1000)? data_7 :8'bZZZZZZZZ;
assign data_vga_final = (contador_clks==4'b1001)? data_8 :8'bZZZZZZZZ;
assign data_vga_final = (contador_clks==4'b1010)? data_9 :8'bZZZZZZZZ;
assign data_vga_final = (contador_clks==4'b1011)? data_10 :8'bZZZZZZZZ;

assign bit_inicio1 =(contador_clks==4'b0001)? 1'b1: 1'b0;


endmodule