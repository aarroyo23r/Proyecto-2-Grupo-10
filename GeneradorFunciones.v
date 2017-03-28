`timescale 1ns / 1ps

module GeneradorFunciones(     //Definicion entradas y salidas
    input wire clk,  //variable que reinicia los contadores, se reinicia con un 1
    input wire IndicadorMaquina,  //Señal que indica acción que se esta realizando // En cero ejecuta señales Write y en 1 señales read
    output wire ChipSelect1,Read1,Write1,AoD1, //Señales de entrada del RTC
    output wire [3:0] contador1
    );
       
reg [3:0] contador = 4'b0000;   //Contador general del modulo (10ns)
reg ChipSelect = 1'b1; //Valor inicial de ChipSelect
reg Read = 1'b1; //Valor inicial de ChipSelect
reg Write = 1'b1; //Valor inicial de señal Write
reg AoD = 1'b1; //Valor incial de señal AoD
reg [2:0] limitador = 0; //limitador para señal ChipSelecr
reg [2:0] limitador2 = 0; //limitador para señal Read
reg [2:0] limitador3 = 0; //limitador para señal write
reg [2:0] limitador4 = 0; //limitador para señal AoD
reg reset=0;
reg [7:0] contador2 = 0;


assign contador1 = contador; //Permite ver el progreso del contador
assign ChipSelect1 = ChipSelect; //Asigna registros a variables de salida
assign Read1 = Read;
assign Write1= Write;
assign AoD1 = AoD;

always @(posedge clk)begin
        if(contador2%140==0)
        reset=~reset;end
           
always @(posedge clk)begin
          if(reset==1)begin  //Condición de Reset
          contador=0;
          contador2 <=contador2+1;end
          else
          contador <= contador + 1'b1;          //Suma 1 cada 10 ns //Este es el contador general para todo el modulo                          
          contador2 <= contador2 + 1;end
          
                                                   
always @(posedge clk)
    if(reset==1)        //Condición de Reset
    limitador=0;
    else                   
    if((contador ==4'b0101 | contador ==4'b1011) && limitador<=3'b011)begin
        ChipSelect <= ~ChipSelect;                      //genera señal de chip select  
        limitador = limitador + 2'b01;end                
        
                
always @(posedge clk)
    if(reset==1)        //Condición de Reset
    limitador2=0;
    else 
    if((contador == 4'b0110| contador ==4'b1010) && limitador>3'b010 && limitador2<=3'b001)begin
        Read <= ~Read                     ;            //genera señal de read
        limitador2 = limitador2 + 2'b01;end

       
always @(posedge clk)
    if(reset==1)        //Condición de Reset
    limitador3=0;
    else 
    if (IndicadorMaquina)begin
    if((contador ==4'b0110 | contador ==4'b1010) && limitador3<=3'b001)begin
        Write <= ~Write;                                //genera señal de write  //FUNCION READ
        limitador3 = limitador3 + 2'b01;end;end
    else
    if(IndicadorMaquina==0)begin
     if((contador ==4'b0110 | contador ==4'b1010) && limitador<=3'b011)begin
        Write <= ~Write;                                //genera señal de write  //FUNCIÓN WRITE
         limitador3 = limitador3 + 2'b01;end;end
        
       
always @(posedge clk)
    if(reset==1)        //Condición de Reset
    limitador4=0;
    else                          
       if((contador ==4'b0101 | contador ==4'b1011) && limitador4<3'b010)begin
       AoD <= ~AoD;                            //genera señal AoD 
       limitador4 = limitador4 + 2'b01;end                          
endmodule