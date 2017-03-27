`timescale 1ns / 1ps

module Write(                             //Definicion entradas y salidas
    input wire clk,
    input wire IndicadorMaquina,  //Señal que indica acción que se esta realizando
    output wire ChipSelect1,Read1,Write1,AoD1, //Señales de entrada del RTC
    output wire [3:0] contador1
    );
       
reg [3:0] contador = 4'b0000;   //Contador general del modulo (10ns)
reg ChipSelect = 1'b1; //Valor inicial de ChipSelect
reg Read = 1'b1; //Valor fijo de Read
reg Write = 1'b1; //Valor inicial de señal Write
reg AoD = 1'b1; //Valor incial de señal AoD

reg [2:0] limitador = 0; //limitador para señal ChipSelecr
reg [2:0] limitador3 = 0; //limitador para señal write
reg [2:0] limitador4 = 0; //limitador para señal AoD

assign contador1 = contador; //Permite ver el progreso del contador
assign ChipSelect1 = ChipSelect;
assign Read1 = Read;
assign Write1= Write;
assign AoD1 = AoD;
always @(posedge clk)
          if (IndicadorMaquina)
             contador <= contador + 1'b1;          //Suma 1 cada 10 ns
                          
always @(posedge clk)                         
    if((contador ==4'b0101 | contador ==4'b1011) && limitador<=3'b011)begin
        ChipSelect <= ~ChipSelect;                      //genera señal de chip select  
        limitador = limitador + 2'b01;end
       
always @(posedge clk)
    if((contador ==4'b0110 | contador ==4'b1010) && limitador<=3'b011)begin
        Write <= ~Write;                                //genera señal de write  
        limitador3 = limitador3 + 2'b01;end
        
always @(posedge clk)                         
            if((contador ==4'b0101 | contador ==4'b1011) && limitador4<3'b010)begin
                AoD <= ~AoD;                            //genera señal AoD 
                limitador4 = limitador4 + 2'b01;end                          
endmodule