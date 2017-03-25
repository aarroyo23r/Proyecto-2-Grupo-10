`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:Andrés Arroyo Romero
//
// Create Date: 03/24/2017 11:48:12 PM
// Design Name:
// Module Name: Interfaz
// Project Name:RTC
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module Interfaz( //Definicion entradas y salidas
    input wire clk,
    input wire temporizador, // Indica si el temporizador esta activo
    input wire temporizadorFin,//Indica cuando finaliza el temporizador
    input [7:0] datoRTC,//Dato proveniente del RTC
    input pixel_x,
    input pixel_y,
    input [2:0] cursor//Indica la posicion en la que se encuentra el cursor
    );

//_____________________________________________________________________
//Declaracion de constantes
//_____________________________________________________________________

//Tick antes de refrescar la pantalla
wire tick=0;//Tick para guardar datos mientras se refresca la pantalla, para que al volver a imprimir los datos esten listos para ser leidos

//Modulo para pasar los Datos del RTC a codigo Ascii
localparam tamContador;//Tamaño del contador de datos guardados
reg [3:0] contGuardados=0;//Cuenta los datos guardados
reg [10:0] dirAsciiDato;//Contiene la direccion Ascii del dato proveniente del RTC
wire w;//Habilita el modo escritura de los registros
wire r;//Habilita el modo lectura de los registros

//Registros con las direcciones de memoria
//Direcciones de los datos de RTC
//Reloj
reg [6:0] centesimas;
reg [6:0] Segundos;
reg [6:0] minutos;
reg [6:0] horas;
reg [6:0] fecha;
reg [6:0] mes;
reg [6:0] año;
reg [6:0] diaSemana;
reg [6:0] numeroSemana;
//Temporizador
reg [6:0] centesimasT;
reg [6:0] segundosT;
reg [6:0] minutosT;
reg [6:0] horasT;
//Direcciones Datos extra



//Selector de Direcciones
reg [10:0] dirMemoria;//Almacena la direccion de memoria
reg [3:0] filaMemoria;//Cambio entre las filas de la memoria




//Mux recorrido columnas Memoria
wire fbit;//Bit que determina si un pixel de la pantalla esta activo o no



//Cursor ***************


//Salida VGA***********



//*******************************************************************************************
//_____________________________________________________________________
//Cuerpo
//_____________________________________________________________________

//Tick antes de refrescar la pantalla
always @(posedge clk)//Se activa la señal tick cuando la pantalla comienza a refrescarse
if (pixel_x==639 & pixel_y==479)
begin
tick=1;
end
else if (pixel_x==0 & pixel_y==0)
begin
tick=0;
end
else
begin
tick=0;
end


//Modulo para pasar los Datos del RTC a codigo Ascii
always @(posedge clk)
if (temporizador) //Asigna el tamaño del contador de datos guardados dependiendo
begin             // de si el temporizador esta activo o no
assign tamContador=13;
end
else
begin
assign tamContador=9;
end

if (contGuardados!=tamContador)
begin
//*****************************continuar********


contGuardados=contGuardados+1;
end



//Modulo para pasar los Datos del RTC a codigo Ascii












endmodule
