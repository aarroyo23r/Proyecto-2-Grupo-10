`timescale 1ns / 1ps
module Registros(
    input wire clk,
    output wire bit_inicio1,
    input wire [7:0] data_vga,
    input wire IndicadorMaquina,
    input wire [7:0] contador,
    input wire [7:0]address,
    input wire Read,
    output wire [3:0] contador_datos1, 
    output wire [7:0] datos0,
    output wire [7:0] datos1,
    output wire [7:0] datos2,
    output wire [7:0] datos3,
    output wire [7:0] datos4,
    output wire [7:0] datos5,
    output wire [7:0] datos6,
    output wire [7:0] datos7,
    output wire [7:0] datos8,
    output wire [7:0] datos9,
    output wire [7:0] datos10
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
assign datos0=data_0; assign datos1=data_1;assign datos2=data_2;assign datos3=data_3;assign datos4=data_4;
assign datos5=data_5;assign datos6=data_6;assign datos7=data_7;assign datos8=data_8;assign datos9=data_9;
assign datos10=data_10;

reg [7:0]contador2;
always @(negedge Read)
begin
   if(contador>8'd37 && IndicadorMaquina)
   begin
   contador_datos = contador_datos + 1'b1;
   if(contador_datos==4'b1011)begin                //contador indica cuando han pasado los 11 datos
        contador_datos<=4'b0000;
   end
end
   
end

always@(posedge clk)begin

    if(contador>=8'h18 && contador<=8'h1e && contador_datos==4'd1)begin
      data_0<=data_vga;
       //data_0<=1;

    end
    if(contador>=8'h18 && contador<=8'h1e  && contador_datos==4'd2)begin
        data_1<=data_vga;
        //data_1<=2;

    end
    if(contador_datos==4'd3 && contador>=8'h18 && contador<=8'h1e)begin
            data_2<=data_vga;
            //data_1<=2;
    
        end
    if(contador_datos==4'd4 && contador>=8'h18 && contador<=8'h1e)begin
                data_3<=data_vga;
                //data_1<=2;
        
            end
    if(contador_datos==4'd5 && contador>=8'h18 && contador<=8'h1e)begin
                    data_4<=data_vga;
                    //data_1<=2;
            
                end
    if(contador_datos==4'd6 && contador>=8'h18 && contador<=8'h1e)begin
                        data_5<=data_vga;
                        //data_1<=2;
                
                    end
    if(contador_datos ==4'd7 && contador>=8'h18 && contador<=8'h1e)begin
                            data_6<=data_vga;
                            //data_1<=2;
                    
                        end
    if(contador_datos==4'd8 && contador>=8'h18 && contador<=8'h1e)begin
                                data_7<=data_vga;
                                //data_1<=2;
                        
                            end
    if(contador_datos==4'd9 && contador>=8'h18 && contador<=8'h1e)begin
                                    data_8<=data_vga;
                                    //data_1<=2;
                            
                                end
    if(contador_datos == 4'd10&& contador>=8'h18 && contador<=8'h1e)begin
                                        data_9<=data_vga;
                                        //data_1<=2;
                                
                                    end
    if(contador_datos==4'd11 && contador>=8'h18 && contador<=8'h1e)begin
                                            data_10<=data_vga;
                                            //data_1<=2;
                                    
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

//assign data_vga_final = (contador_clks==4'b0000)? 4'b0000:8'bZZZZZZZZ;


assign bit_inicio1 =(contador_clks==4'b1100)? 1'b0: 1'b1;
