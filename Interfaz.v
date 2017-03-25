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
    input wire clk,pixel_x,pixel_y,reset,
    input wire inicioSecuencia,//Indica si se esta iniciando una secuencia de la transmision de datos
    input wire temporizador, // Indica si el temporizador esta activo
    input wire temporizadorFin,//Indica cuando finaliza el temporizador
    input [7:0] datoRTC,//Dato proveniente del RTC
    input [2:0] cursor,//Indica la posicion en la que se encuentra el cursor

    output [11:0] rgb,
    output hsync,vsync
    );

//_____________________________________________________________________
//Instanciaciones
//_____________________________________________________________________

//SincronizadorVGA
wire [9:0] pixelx, pixely;
wire video_on, tick25;
 
SincronizadorVGA SincronizadorVGA_unit(
          .clk(clk),.reset(reset),
          .hsync(hsync),.vsync(vsync),.video_on(video_on),.tick(tick25),
          .pixelx(pixelx),.pixely(pixely)
          );

//_____________________________________________________________________
//Declaracion de constantes
//_____________________________________________________________________


//Tick antes de refrescar la pantalla
reg tick=0;//Tick para guardar datos mientras se refresca la pantalla, para que al volver a imprimir los datos esten listos para ser leidos

//Modulo para pasar los Datos del RTC a codigo Ascii
reg [3:0]  tamContador=0;//Tamaño del contador de datos guardados
reg [3:0] contGuardados=0;//Cuenta los datos guardados
reg finalizoContar=0;//Indica cuando el contador finalizo su cuenta
reg [6:0] dirAsciiDatoU;//Contiene la direccion Ascii de las unidades del dato proveniente del RTC
reg [6:0] dirAsciiDatoD;//Contiene la direccion Ascii de las decenas del dato proveniente del RTC
reg [6:0] dirAsciiDatoSigU=0;//Registro para almacenar la siguiente direccion Ascii de las unidades del dato proveniente del RTC
reg [6:0] dirAsciiDatoSigD=0;//Registro para almacenar la siguiente direccion Ascii de las decenas del dato proveniente del RTC
reg w, r;//Habilitan el modo escritura o lectura de los registros respectivamente

//Registros con las direcciones de memoria
//Direcciones de los datos de RTC
//Reloj
reg [6:0] SegundosU=7'h30, minutosU=7'h30,horasU=7'h30, fechaU=7'h30,mesU=7'h30,anoU=7'h30,diaSemanaU=7'h30, numeroSemanaU=7'h30;//Inicio de registros unidades en 0
reg [6:0] SegundosUSig,minutosUSig,horasUSig,fechaUSig,mesUSig,anoUSig,diaSemanaUSig,numeroSemanaUSig;
reg [6:0] SegundosD=7'h30,minutosD=7'h30,horasD=7'h30,fechaD=7'h30,mesD=7'h30,anoD=7'h30,diaSemanaD=7'h30,numeroSemanaD=7'h30;//Inicio de registros decenas en 0
reg [6:0] SegundosDSig,minutosDSig,horasDSig,fechaDSig,mesDSig,anoDSig,diaSemanaDSig,numeroSemanaDSig;
//Temporizador
reg [6:0] SegundosUT=7'h30,minutosUT=7'h30,horasUT=7'h30;//Inicio de registros en 0
reg [6:0] SegundosUTSig,minutosUTSig,horasUTSig;
reg [6:0] SegundosDT=7'h30,minutosDT=7'h30,horasDT=7'h30;//Inicio de registros en 0
reg [6:0] SegundosDTSig,minutosDTSig,horasDTSig;
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
if (finalizoContar==0 & 639<=pixel_x>=799 & 479<pixel_y>524) //finalizoContar desactiva la señal cuando ya se guardaron todos los datos
begin
tick=1;
end
else
begin
tick=0;
end


//Modulo para pasar los Datos del RTC a codigo Ascii
always @(posedge clk)
if (temporizador) //Asigna el tamaño del contador de datos guardados dependiendo
begin             // de si el temporizador esta activo o no
tamContador=4'd13;// Y guarda las nuevas direcciones
dirAsciiDatoU<=dirAsciiDatoSigU;
dirAsciiDatoD<=dirAsciiDatoSigD;
end
else
begin
tamContador=4'd9;
dirAsciiDatoU<=dirAsciiDatoSigU;
dirAsciiDatoD<=dirAsciiDatoSigD;
end

always @(tick & inicioSecuencia)// Cada vez que se refresca la pantalla se guarda una secuencia de datos

if (contGuardados!=tamContador)
begin
r= 0;
w= 1; //Señal modo escritura
case(datoRTC)//Le asigna el valor Ascii del dato proveniente del RTC
        8'd0: dirAsciiDatoSigU = 7'h30;
        8'd0: dirAsciiDatoSigD = 7'h30;
        8'd1: dirAsciiDatoSigU = 7'h31;
        8'd1: dirAsciiDatoSigD = 7'h30;
        8'd2: dirAsciiDatoSigU = 7'h32;
        8'd2: dirAsciiDatoSigD = 7'h30;
        8'd3: dirAsciiDatoSigU = 7'h33;
        8'd3: dirAsciiDatoSigD = 7'h30;
        8'd4: dirAsciiDatoSigU = 7'h34;
        8'd4: dirAsciiDatoSigD = 7'h30;
        8'd5: dirAsciiDatoSigU = 7'h35;
        8'd5: dirAsciiDatoSigD = 7'h30;
        8'd6: dirAsciiDatoSigU = 7'h36;
        8'd6: dirAsciiDatoSigD = 7'h30;
        8'd7: dirAsciiDatoSigU = 7'h37;
        8'd7: dirAsciiDatoSigD = 7'h30;
        8'd8: dirAsciiDatoSigU = 7'h38;
        8'd8: dirAsciiDatoSigD = 7'h30;
        8'd9: dirAsciiDatoSigU = 7'h39;
        8'd9: dirAsciiDatoSigD = 7'h30;
        8'd10: dirAsciiDatoSigU = 7'h30;
        8'd10: dirAsciiDatoSigD = 7'h31;
        8'd11: dirAsciiDatoSigU = 7'h31;
        8'd11: dirAsciiDatoSigD = 7'h31;
        8'd12: dirAsciiDatoSigU = 7'h32;
        8'd12: dirAsciiDatoSigD = 7'h31;
        8'd13: dirAsciiDatoSigU = 7'h33;
        8'd13: dirAsciiDatoSigD = 7'h31;
        8'd14: dirAsciiDatoSigU = 7'h34;
        8'd14: dirAsciiDatoSigD = 7'h31;
        8'd15: dirAsciiDatoSigU = 7'h35;
        8'd15: dirAsciiDatoSigD = 7'h31;
        8'd16: dirAsciiDatoSigU = 7'h36;
        8'd16: dirAsciiDatoSigD = 7'h31;
        8'd17: dirAsciiDatoSigU = 7'h37;
        8'd17: dirAsciiDatoSigD = 7'h31;
        8'd18: dirAsciiDatoSigU = 7'h38;
        8'd18: dirAsciiDatoSigD = 7'h31;
        8'd19: dirAsciiDatoSigU = 7'h39;
        8'd19: dirAsciiDatoSigD = 7'h31;
        8'd20: dirAsciiDatoSigU = 7'h30;
        8'd20: dirAsciiDatoSigD = 7'h32;
        8'd21: dirAsciiDatoSigU = 7'h31;
        8'd21: dirAsciiDatoSigD = 7'h32;
        8'd22: dirAsciiDatoSigU = 7'h32;
        8'd22: dirAsciiDatoSigD = 7'h32;
        8'd23: dirAsciiDatoSigU = 7'h33;
        8'd23: dirAsciiDatoSigD = 7'h32;
        8'd24: dirAsciiDatoSigU = 7'h34;
        8'd24: dirAsciiDatoSigD = 7'h32;
        8'd25: dirAsciiDatoSigU = 7'h35;
        8'd25: dirAsciiDatoSigD = 7'h32;
        8'd26: dirAsciiDatoSigU = 7'h36;
        8'd26: dirAsciiDatoSigD = 7'h32;
        8'd27: dirAsciiDatoSigU = 7'h37;
        8'd27: dirAsciiDatoSigD = 7'h32;
        8'd28: dirAsciiDatoSigU = 7'h38;
        8'd28: dirAsciiDatoSigD = 7'h32;
        8'd29: dirAsciiDatoSigU = 7'h39;
        8'd29: dirAsciiDatoSigD = 7'h32;
        8'd30: dirAsciiDatoSigU = 7'h30;
        8'd30: dirAsciiDatoSigD = 7'h33;
        8'd31: dirAsciiDatoSigU = 7'h31;
        8'd31: dirAsciiDatoSigD = 7'h33;
        8'd32: dirAsciiDatoSigU = 7'h32;
        8'd32: dirAsciiDatoSigD = 7'h33;
        8'd33: dirAsciiDatoSigU = 7'h33;
        8'd33: dirAsciiDatoSigD = 7'h33;
        8'd34: dirAsciiDatoSigU = 7'h34;
        8'd34: dirAsciiDatoSigD = 7'h33;
        8'd35: dirAsciiDatoSigU = 7'h35;
        8'd35: dirAsciiDatoSigD = 7'h33;
        8'd36: dirAsciiDatoSigU = 7'h36;
        8'd36: dirAsciiDatoSigD = 7'h33;
        8'd37: dirAsciiDatoSigU = 7'h37;
        8'd37: dirAsciiDatoSigD = 7'h33;
        8'd38: dirAsciiDatoSigU = 7'h38;
        8'd38: dirAsciiDatoSigD = 7'h33;
        8'd39: dirAsciiDatoSigU = 7'h39;
        8'd39: dirAsciiDatoSigD = 7'h33;
        8'd40: dirAsciiDatoSigU = 7'h30;
        8'd40: dirAsciiDatoSigD = 7'h34;
        8'd41: dirAsciiDatoSigU = 7'h31;
        8'd41: dirAsciiDatoSigD = 7'h34;
        8'd42: dirAsciiDatoSigU = 7'h32;
        8'd42: dirAsciiDatoSigD = 7'h34;
        8'd43: dirAsciiDatoSigU = 7'h33;
        8'd43: dirAsciiDatoSigD = 7'h34;
        8'd44: dirAsciiDatoSigU = 7'h34;
        8'd44: dirAsciiDatoSigD = 7'h34;
        8'd45: dirAsciiDatoSigU = 7'h35;
        8'd45: dirAsciiDatoSigD = 7'h34;
        8'd46: dirAsciiDatoSigU = 7'h36;
        8'd46: dirAsciiDatoSigD = 7'h34;
        8'd47: dirAsciiDatoSigU = 7'h37;
        8'd47: dirAsciiDatoSigD = 7'h34;
        8'd48: dirAsciiDatoSigU = 7'h38;
        8'd48: dirAsciiDatoSigD = 7'h34;
        8'd49: dirAsciiDatoSigU = 7'h39;
        8'd49: dirAsciiDatoSigD = 7'h34;
        8'd50: dirAsciiDatoSigU = 7'h30;
        8'd50: dirAsciiDatoSigD = 7'h35;
        8'd51: dirAsciiDatoSigU = 7'h31;
        8'd51: dirAsciiDatoSigD = 7'h35;
        8'd52: dirAsciiDatoSigU = 7'h32;
        8'd52: dirAsciiDatoSigD = 7'h35;
        8'd53: dirAsciiDatoSigU = 7'h33;
        8'd53: dirAsciiDatoSigD = 7'h35;
        8'd54: dirAsciiDatoSigU = 7'h34;
        8'd54: dirAsciiDatoSigD = 7'h35;
        8'd55: dirAsciiDatoSigU = 7'h35;
        8'd55: dirAsciiDatoSigD = 7'h35;
        8'd56: dirAsciiDatoSigU = 7'h36;
        8'd56: dirAsciiDatoSigD = 7'h35;
        8'd57: dirAsciiDatoSigU = 7'h37;
        8'd57: dirAsciiDatoSigD = 7'h35;
        8'd58: dirAsciiDatoSigU = 7'h38;
        8'd58: dirAsciiDatoSigD = 7'h35;
        8'd59: dirAsciiDatoSigU = 7'h39;
        8'd59: dirAsciiDatoSigD = 7'h35;
        8'd60: dirAsciiDatoSigU = 7'h30;
        8'd60: dirAsciiDatoSigD = 7'h36;
 endcase
contGuardados=contGuardados+1;
end

else
begin
r=1;//Señal modo lectura
w= 0;
finalizoContar=1;
contGuardados=0;
end
//**********Ver reinicio de finalizoContar y contGuardados********


//Registros con las direcciones de memoria
//Logica Registros

always @(w==1 & r==0)//Cuando el modo escritura esta activo, escribe datos en los registros
//Reloj
if (w)
begin
 SegundosU<=SegundosUSig;
SegundosD<=SegundosDSig;
minutosU<=minutosUSig;
minutosD<=minutosDSig;
horasU<=horasUSig;
horasD<=horasDSig;
fechaU<=fechaUSig;
fechaD<=fechaDSig;
mesU<=mesUSig;
mesD<=mesDSig;
anoU<=anoUSig;
anoD<=anoDSig;
diaSemanaU<=diaSemanaUSig;
diaSemanaD<=diaSemanaDSig;
numeroSemanaU<=numeroSemanaUSig;
numeroSemanaD<=numeroSemanaDSig;
//Temporizador
SegundosUT<=SegundosUTSig;
SegundosDT<=SegundosDTSig;
minutosUT<=minutosUTSig;
minutosDT<=minutosDTSig;
horasUT<=horasUTSig;
horasDT<=horasDTSig;
end
else //Evitar latch
begin
 SegundosU<=SegundosU;
SegundosD<=SegundosD;
minutosU<=minutosU;
minutosD<=minutosD;
horasU<=horasU;
horasD<=horasD;
fechaU<=fechaU;
fechaD<=fechaD;
mesU<=mesU;
mesD<=mesD;
anoU<=anoU;
anoD<=anoD;
diaSemanaU<=diaSemanaU;
diaSemanaD<=diaSemanaD;
numeroSemanaU<=numeroSemanaU;
numeroSemanaD<=numeroSemanaD;
//Temporizador
SegundosUT<=SegundosUT;
SegundosDT<=SegundosDT;
minutosUT<=minutosUT;
minutosDT<=minutosDT;
horasUT<=horasUT;
horasDT<=horasDT;
end

//Logica para los registros que se estan escribiendo
always @*
case(contGuardados-1)//Case para Unidades //-1 porque el contador en su logica suma 1 apenas guarda la direccion
//Asigna las direcciones Ascii de los datos provenientes del RTC a los registros en los que se deben guardar
//Reloj
        4'd0: SegundosUSig = dirAsciiDatoU;
        4'd1: minutosUSig = dirAsciiDatoU;
        4'd2: horasUSig = dirAsciiDatoU;
        4'd3: fechaUSig = dirAsciiDatoU;
        4'd4: mesUSig = dirAsciiDatoU;
        4'd5: anoUSig = dirAsciiDatoU;
        4'd6: diaSemanaUSig = dirAsciiDatoU;
        4'd7: numeroSemanaUSig = dirAsciiDatoU;
//Temporizador
        4'd8: SegundosUTSig = dirAsciiDatoU;
        4'd9: minutosUTSig = dirAsciiDatoU;
        4'd10: horasUTSig = dirAsciiDatoU;
 endcase
//---------------------------------------------------------
always @*
 case(contGuardados-1)//Case para Decenas
 //Asigna las direcciones Ascii de los datos provenientes del RTC a los registros en los que se deben guardar
 //Reloj
         4'd0: SegundosDSig = dirAsciiDatoD;
         4'd1: minutosDSig = dirAsciiDatoD;
         4'd2: horasDSig = dirAsciiDatoD;
         4'd3: fechaDSig = dirAsciiDatoD;
         4'd4: mesDSig = dirAsciiDatoD;
         4'd5: anoDSig = dirAsciiDatoD;
         4'd6: diaSemanaDSig = dirAsciiDatoD;
         4'd7: numeroSemanaDSig = dirAsciiDatoD;
 //Temporizador
         4'd8: SegundosDTSig = dirAsciiDatoD;
         4'd9: minutosDTSig = dirAsciiDatoD;
         4'd10: horasDTSig = dirAsciiDatoD;
  endcase









endmodule
