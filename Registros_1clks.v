`timescale 1ns / 1ps
module Registros(
    input wire clk,bit_inicio1,
    input wire [7:0] data_vga,
    input wire [7:0] contador,
    output wire [7:0] data_vga_final,
    input wire Read,
    output wire [3:0] contador_datos1 
    );

reg[3:0]contador_datos=8'b00000000;
reg [7:0]data_write;
reg [7:0]data_0;reg [7:0]data_1;reg [7:0]data_2;
reg [7:0]data_3;reg [7:0]data_4;reg [7:0]data_5;reg [7:0]data_6;
reg [7:0]data_7;reg [7:0]data_8;reg [7:0]data_9;reg [7:0]data_10;
reg[3:0]contador_clks=8'b00000000;           //contador para manda el dato a 1 clk por segundo
reg data_pre_vga=8'b00000000;
reg [3:0] contador_unico=4'b0000;

assign contador_datos1 = contador_datos;

always @(posedge clk)begin
    if(Read==0)begin
    
    end
end

always @(posedge clk)begin
   if(Read==0 && contador==8'b11101100)begin
   contador_datos <= contador_datos + 1'b1;
   if(contador_datos==4'b1011)begin                //contador indica cuando han pasado los 11 datos
        contador_datos<=4'b0000;
   end
   end
end

always@(posedge clk)begin

    if(contador_datos==4'b0001 && Read == 0 && contador>8'b10011000)begin
        data_0<=8'h1;
    end
    if(contador_datos==4'b0010  && Read ==0 && contador>8'b10011000)begin
        data_1<=8'h2;
    end
    if(contador_datos==4'b0011 && Read == 0 && contador>8'b10011000 )begin
        data_2<=8'h3;
    end
    if(contador_datos==4'b0100 && Read ==0 && contador>8'b10011000)begin
        data_3<=8'h4;
    end
    if(contador_datos==4'b0101 && Read ==0 && contador>8'b10011000)begin
        data_4<=8'h5;
    end
    if(contador_datos==4'b0110  && Read ==0 && contador>8'b10011000)begin
         data_5<=8'h6;
    end
    if(contador_datos==4'b0111 && Read ==0 && contador>8'b10011000)begin
         data_6<=8'h7;
    end
    if(contador_datos==4'b1000 && Read ==0 && contador>8'b10011000)begin
         data_7<=8'h8;
    end
    if(contador_datos==4'b1001 && Read ==0 && contador>8'b10011000)begin
         data_8<=8'h9;
    end
    if(contador_datos==4'b1010 && Read ==0 && contador>8'b10011000)begin
         data_9<=8'h10;     
    end
    if(contador_datos==4'b1011 && Read ==0 && contador>8'b10011000)begin
         data_10<=8'h11;
    end
    else begin
    end
end



always @(posedge clk)begin
    contador_clks<=contador_clks +1'b1;
    if(contador_clks==4'b1100)begin
        contador_clks<=4'b0000;
    end
end
assign data_vga_final = (contador_clks==4'b0001)? data_0 :8'bZZZZZZZZ;
assign data_vga_final = (contador_clks==4'b0010)? data_1 :8'bZZZZZZZZ;
assign data_vga_final = (contador_clks==4'b0011)? data_2 :8'bZZZZZZZZ;
assign data_vga_final = (contador_clks==4'b0100)? data_3 :8'bZZZZZZZZ;
assign data_vga_final = (contador_clks==4'b0101)? data_4:8'bZZZZZZZZ;
assign data_vga_final = (contador_clks==4'b0110)? data_5:8'bZZZZZZZZ;
assign data_vga_final = (contador_clks==4'b0111)? data_6:8'bZZZZZZZZ;
assign data_vga_final = (contador_clks==4'b1000)? data_7 :8'bZZZZZZZZ;
assign data_vga_final = (contador_clks==4'b1001)? data_8:8'bZZZZZZZZ;
assign data_vga_final = (contador_clks==4'b1010)? data_9:8'bZZZZZZZZ;
assign data_vga_final = (contador_clks==4'b1011)? data_10:8'bZZZZZZZZ;

//assign data_vga_final = (contador_clks==4'b0001)? 4'b0001 :8'bZZZZZZZZ;
//assign data_vga_final = (contador_clks==4'b0010)? 4'b0010 :8'bZZZZZZZZ;
//assign data_vga_final = (contador_clks==4'b0011)? 4'b0011 :8'bZZZZZZZZ;
//assign data_vga_final = (contador_clks==4'b0100)? 4'b0100 :8'bZZZZZZZZ;
//assign data_vga_final = (contador_clks==4'b0101)? 4'b0101:8'bZZZZZZZZ;
//assign data_vga_final = (contador_clks==4'b0110)? 4'b0110:8'bZZZZZZZZ;
//assign data_vga_final = (contador_clks==4'b0111)? 4'b0111:8'bZZZZZZZZ;
//assign data_vga_final = (contador_clks==4'b1000)? 4'b1000 :8'bZZZZZZZZ;
//assign data_vga_final = (contador_clks==4'b1001)? 4'b1001:8'bZZZZZZZZ;
//assign data_vga_final = (contador_clks==4'b1010)? 4'b1010:8'bZZZZZZZZ;
//assign data_vga_final = (contador_clks==4'b1011)? 4'b1011:8'bZZZZZZZZ;

assign data_vga_final = (contador_clks==4'b0000)? 4'b0000:8'bZZZZZZZZ;


assign bit_inicio1 =(contador_clks==4'b1100)? 1'b0: 1'b1;


endmodule