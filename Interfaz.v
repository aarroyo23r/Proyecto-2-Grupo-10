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
    input wire clk,reset,
    input wire inicioSecuencia,//Indica si se esta iniciando una secuencia de la transmision de datos
    input wire temporizador, // Indica si el temporizador esta activo
    input wire temporizadorFin,//Indica cuando finaliza el temporizador
    input wire [7:0] datoRTC,//Dato proveniente del RTC
    input wire [2:0] cursor,//Indica la posicion en la que se encuentra el cursor

    output reg  [11:0] rgb,
    output hsync,vsync,
    output reg font_bit,
    output wire video_on

    //output reg  [6:0] SegundosU, minutosU, horasU, fechaU,mesU,anoU,diaSemanaU, numeroSemanaU,
    //output  reg [6:0] SegundosDSig,minutosDSig,horasDSig,fechaDSig,mesDSig,anoDSig,diaSemanaDSig,numeroSemanaDSig
    //output wire [9:0] pixely
    );

//_____________________________________________________________________
//Instanciaciones
//_____________________________________________________________________

//SincronizadorVGA
wire [9:0] pixelx, pixely;

SincronizadorVGA SincronizadorVGA_unit(
          .clk(clk),.reset(reset),
          .hsync(hsync),.vsync(vsync),.video_on(video_on),
          .pixelx(pixelx),.pixely(pixely)
          );

//_____________________________________________________________________
//Declaracion de constantes
//_____________________________________________________________________


//Tick antes de refrescar la pantalla
reg tick=0;//Tick para guardar datos mientras se refresca la pantalla, para que al volver a imprimir los datos esten listos para ser leidos

//Modulo para pasar los Datos del RTC a codigo Ascii
reg [3:0]  tamContador;//Tamaño del contador de datos guardados
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
reg [6:0] SegundosU, minutosU,horasU, fechaU,mesU,anoU,diaSemanaU, numeroSemanaU;
reg [6:0] SegundosUSig,minutosUSig,horasUSig,fechaUSig,mesUSig,anoUSig,diaSemanaUSig,numeroSemanaUSig;
reg [6:0] SegundosD,minutosD,horasD,fechaD,mesD,anoD,diaSemanaD,numeroSemanaD;
reg [6:0] SegundosDSig,minutosDSig,horasDSig,fechaDSig,mesDSig,anoDSig,diaSemanaDSig,numeroSemanaDSig;
//Temporizador
reg [6:0] SegundosUT,minutosUT,horasUT;//Inicio de registros en 0
reg [6:0] SegundosUTSig,minutosUTSig,horasUTSig;
reg [6:0] SegundosDT,minutosDT,horasDT;//Inicio de registros en 0
reg [6:0] SegundosDTSig,minutosDTSig,horasDTSig;
//Direcciones Datos extra


//Selector de Registros
wire [10:0] rom_addr;//Almacena la direccion de memoria completa
//reg [3:0] row_addr;//Cambio entre las filas de la memoria, bits menos significativos de pixel y,bit menos significativos de memoria
//wire [6:0] char_addr; //  bits mas significativos de dirreción de memoria, del caracter a imprimir
wire [7:0] font_word; // datos de memoria
wire [3:0] color_addr; //Tres bits porque por ahora se van a manejar 15 colores



//Tamaño de fuentes
wire [1:0] font_size;// Tamaño de fuente
/*
reg [2:0] f8;//Tamaño de la fuente de 8 bits en el eje x
reg [3:0] f16;//Tamaño de la fuente de 16 bits en el eje x
reg [4:0] f32;//Tamaño de la fuente de 32 bits en el eje x
*/

//Mux recorrido columnas Memoria
//wire font_bit;//Bit que determina si un pixel de la pantalla esta activo o no
wire dp;


//Color
reg [11:0] color;
//Cursor ***************


//Salida VGA***********
//reg [11:0] rgb;


//*******************************************************************************************
//_____________________________________________________________________
//Cuerpo
//_____________________________________________________________________

//Tick antes de refrescar la pantalla
always @(posedge clk)//Se activa la señal tick cuando la pantalla comienza a refrescarse
if (finalizoContar==0 & pixely>=10'd480) //finalizoContar desactiva la señal cuando ya se guardaron todos los datos
begin
tick=1;
end
else
begin
tick=0;
end//Probado


//Modulo para pasar los Datos del RTC a codigo Ascii
always @(posedge clk)
if (temporizador) //Asigna el tamaño del contador de datos guardados dependiendo
begin             // de si el temporizador esta activo o no
tamContador=4'd14;// Y guarda las nuevas direcciones
dirAsciiDatoU<=dirAsciiDatoSigU;
dirAsciiDatoD<=dirAsciiDatoSigD;
end
else
begin
tamContador=4'd11;
dirAsciiDatoU<=dirAsciiDatoSigU;
dirAsciiDatoD<=dirAsciiDatoSigD;
end


always @(posedge clk)// Cada vez que se refresca la pantalla se guarda una secuencia de datos

if ((contGuardados!=tamContador) & tick==1 & inicioSecuencia==1 )
begin
r= 0;
w= 1; //Señal modo escritura
case(datoRTC)//Le asigna el valor Ascii del dato proveniente del RTC Unidades

         8'd0: dirAsciiDatoSigU = 7'h30;
         8'd1: dirAsciiDatoSigU = 7'h31;
         8'd2: dirAsciiDatoSigU = 7'h32;
         8'd3: dirAsciiDatoSigU = 7'h33;
         8'd4: dirAsciiDatoSigU = 7'h34;
         8'd5: dirAsciiDatoSigU = 7'h35;
         8'd6: dirAsciiDatoSigU = 7'h36;
         8'd7: dirAsciiDatoSigU = 7'h37;
         8'd8: dirAsciiDatoSigU = 7'h38;
         8'd9: dirAsciiDatoSigU = 7'h39;
         8'd10: dirAsciiDatoSigU = 7'h30;
         8'd11: dirAsciiDatoSigU = 7'h31;
         8'd12: dirAsciiDatoSigU = 7'h32;
         8'd13: dirAsciiDatoSigU = 7'h33;
         8'd14: dirAsciiDatoSigU = 7'h34;
         8'd15: dirAsciiDatoSigU = 7'h35;
         8'd16: dirAsciiDatoSigU = 7'h36;
         8'd17: dirAsciiDatoSigU = 7'h37;
         8'd18: dirAsciiDatoSigU = 7'h38;
         8'd19: dirAsciiDatoSigU = 7'h39;
         8'd20: dirAsciiDatoSigU = 7'h30;
         8'd21: dirAsciiDatoSigU = 7'h31;
         8'd22: dirAsciiDatoSigU = 7'h32;
         8'd23: dirAsciiDatoSigU = 7'h33;
         8'd24: dirAsciiDatoSigU = 7'h34;
         8'd25: dirAsciiDatoSigU = 7'h35;
         8'd26: dirAsciiDatoSigU = 7'h36;
         8'd27: dirAsciiDatoSigU = 7'h37;
         8'd28: dirAsciiDatoSigU = 7'h38;
         8'd29: dirAsciiDatoSigU = 7'h39;
         8'd30: dirAsciiDatoSigU = 7'h30;
         8'd31: dirAsciiDatoSigU = 7'h31;
         8'd32: dirAsciiDatoSigU = 7'h32;
         8'd33: dirAsciiDatoSigU = 7'h33;
         8'd34: dirAsciiDatoSigU = 7'h34;
         8'd35: dirAsciiDatoSigU = 7'h35;
         8'd36: dirAsciiDatoSigU = 7'h36;
         8'd37: dirAsciiDatoSigU = 7'h37;
         8'd38: dirAsciiDatoSigU = 7'h38;
         8'd39: dirAsciiDatoSigU = 7'h39;
         8'd40: dirAsciiDatoSigU = 7'h30;
         8'd41: dirAsciiDatoSigU = 7'h31;
         8'd42: dirAsciiDatoSigU = 7'h32;
         8'd43: dirAsciiDatoSigU = 7'h33;
         8'd44: dirAsciiDatoSigU = 7'h34;
         8'd45: dirAsciiDatoSigU = 7'h35;
         8'd46: dirAsciiDatoSigU = 7'h36;
         8'd47: dirAsciiDatoSigU = 7'h37;
         8'd48: dirAsciiDatoSigU = 7'h38;
         8'd49: dirAsciiDatoSigU = 7'h39;
         8'd50: dirAsciiDatoSigU = 7'h30;
         8'd51: dirAsciiDatoSigU = 7'h31;
         8'd52: dirAsciiDatoSigU = 7'h32;
         8'd53: dirAsciiDatoSigU = 7'h33;
         8'd54: dirAsciiDatoSigU = 7'h34;
         8'd55: dirAsciiDatoSigU = 7'h35;
         8'd56: dirAsciiDatoSigU = 7'h36;
         8'd57: dirAsciiDatoSigU = 7'h37;
         8'd58: dirAsciiDatoSigU = 7'h38;
         8'd59: dirAsciiDatoSigU = 7'h39;
         8'd60: dirAsciiDatoSigU = 7'h30;
  endcase

 case(datoRTC)//Le asigna el valor Ascii del dato proveniente del RTC Decenas

         8'd0: dirAsciiDatoSigD = 7'h30;
         8'd1: dirAsciiDatoSigD = 7'h30;
         8'd2: dirAsciiDatoSigD = 7'h30;
         8'd3: dirAsciiDatoSigD = 7'h30;
         8'd4: dirAsciiDatoSigD = 7'h30;
         8'd5: dirAsciiDatoSigD = 7'h30;
         8'd6: dirAsciiDatoSigD = 7'h30;
         8'd7: dirAsciiDatoSigD = 7'h30;
         8'd8: dirAsciiDatoSigD = 7'h30;
         8'd9: dirAsciiDatoSigD = 7'h30;
         8'd10: dirAsciiDatoSigD = 7'h31;
         8'd11: dirAsciiDatoSigD = 7'h31;
         8'd12: dirAsciiDatoSigD = 7'h31;
         8'd13: dirAsciiDatoSigD = 7'h31;
         8'd14: dirAsciiDatoSigD = 7'h31;
         8'd15: dirAsciiDatoSigD = 7'h31;
         8'd16: dirAsciiDatoSigD = 7'h31;
         8'd17: dirAsciiDatoSigD = 7'h31;
         8'd18: dirAsciiDatoSigD = 7'h31;
         8'd19: dirAsciiDatoSigD = 7'h31;
         8'd20: dirAsciiDatoSigD = 7'h32;
         8'd21: dirAsciiDatoSigD = 7'h32;
         8'd22: dirAsciiDatoSigD = 7'h32;
         8'd23: dirAsciiDatoSigD = 7'h32;
         8'd24: dirAsciiDatoSigD = 7'h32;
         8'd25: dirAsciiDatoSigD = 7'h32;
         8'd26: dirAsciiDatoSigD = 7'h32;
         8'd27: dirAsciiDatoSigD = 7'h32;
         8'd28: dirAsciiDatoSigD = 7'h32;
         8'd29: dirAsciiDatoSigD = 7'h32;
         8'd30: dirAsciiDatoSigD = 7'h33;
         8'd31: dirAsciiDatoSigD = 7'h33;
         8'd32: dirAsciiDatoSigD = 7'h33;
         8'd33: dirAsciiDatoSigD = 7'h33;
         8'd34: dirAsciiDatoSigD = 7'h33;
         8'd35: dirAsciiDatoSigD = 7'h33;
         8'd36: dirAsciiDatoSigD = 7'h33;
         8'd37: dirAsciiDatoSigD = 7'h33;
         8'd38: dirAsciiDatoSigD = 7'h33;
         8'd39: dirAsciiDatoSigD = 7'h33;
         8'd40: dirAsciiDatoSigD = 7'h34;
         8'd41: dirAsciiDatoSigD = 7'h34;
         8'd42: dirAsciiDatoSigD = 7'h34;
         8'd43: dirAsciiDatoSigD = 7'h34;
         8'd44: dirAsciiDatoSigD = 7'h34;
         8'd45: dirAsciiDatoSigD = 7'h34;
         8'd46: dirAsciiDatoSigD = 7'h34;
         8'd47: dirAsciiDatoSigD = 7'h34;
         8'd48: dirAsciiDatoSigD = 7'h34;
         8'd49: dirAsciiDatoSigD = 7'h34;
         8'd50: dirAsciiDatoSigD = 7'h35;
         8'd51: dirAsciiDatoSigD = 7'h35;
         8'd52: dirAsciiDatoSigD = 7'h35;
         8'd53: dirAsciiDatoSigD = 7'h35;
         8'd54: dirAsciiDatoSigD = 7'h35;
         8'd55: dirAsciiDatoSigD = 7'h35;
         8'd56: dirAsciiDatoSigD = 7'h35;
         8'd57: dirAsciiDatoSigD = 7'h35;
         8'd58: dirAsciiDatoSigD = 7'h35;
         8'd59: dirAsciiDatoSigD = 7'h35;
         8'd60: dirAsciiDatoSigD = 7'h36;
  endcase

contGuardados=contGuardados+1;
end
else
begin
r=1;//Señal modo lectura
w= 0;
if (contGuardados==tamContador)//Para que finalizoContar se active unicamente  cuando esto es cierto
begin
finalizoContar=1;
contGuardados=0;
end
else
begin
finalizoContar=0;
end


end

//**********Ver reinicio de finalizoContar y contGuardados********


//Registros con las direcciones de memoria
//Logica Registros



//Logica para los registros que se estan escribiendo


/*
always @(posedge clk)
case(contGuardados)//Case para Unidades //-1 porque el contador en su logica suma 1 apenas guarda la direccion
//Asigna las direcciones Ascii de los datos provenientes del RTC a los registros en los que se deben guardar
//Reloj
        4'd1: SegundosUSig = dirAsciiDatoU;
        4'd2: minutosUSig = dirAsciiDatoU;
        4'd3: horasUSig = dirAsciiDatoU;
        4'd4: fechaUSig = dirAsciiDatoU;
        4'd5: mesUSig = dirAsciiDatoU;
        4'd6: anoUSig = dirAsciiDatoU;
        4'd7: diaSemanaUSig = dirAsciiDatoU;
        4'd8: numeroSemanaUSig = dirAsciiDatoU;
//Temporizador
        4'd9: SegundosUTSig = dirAsciiDatoU;
        4'd10: minutosUTSig = dirAsciiDatoU;
        4'd11: horasUTSig = dirAsciiDatoU;
 endcase
//---------------------------------------------------------
always @(posedge clk)
 case(contGuardados)//Case para Decenas
 //Asigna las direcciones Ascii de los datos provenientes del RTC a los registros en los que se deben guardar
 //Reloj
         4'd1: SegundosDSig = dirAsciiDatoD;
         4'd2: minutosDSig = dirAsciiDatoD;
         4'd3: horasDSig = dirAsciiDatoD;
         4'd4: fechaDSig = dirAsciiDatoD;
         4'd5: mesDSig = dirAsciiDatoD;
         4'd6 : anoDSig = dirAsciiDatoD;
         4'd7: diaSemanaDSig = dirAsciiDatoD;
         4'd8: numeroSemanaDSig = dirAsciiDatoD;
 //Temporizador
         4'd9: SegundosDTSig = dirAsciiDatoD;
         4'd10: minutosDTSig = dirAsciiDatoD;
         4'd11: horasDTSig = dirAsciiDatoD;

  endcase
*/


//Guarda los datos decodificados en registros intermedios
always @(posedge clk)
//reloj
if (contGuardados==4'd4)begin //Se empieza en el contador 4 porque antes de esto es un retardo que se utiliza para generar la direccion que se va a guardar en estos registros
SegundosUSig = dirAsciiDatoU;
SegundosDSig = dirAsciiDatoD;end

else if (contGuardados==4'd5)begin
minutosUSig = dirAsciiDatoU;
minutosDSig = dirAsciiDatoD;end

else if (contGuardados==4'd6)begin
horasUSig = dirAsciiDatoU;
horasDSig = dirAsciiDatoD;end

else if (contGuardados==4'd7)begin
fechaUSig = dirAsciiDatoU;
fechaDSig = dirAsciiDatoD;end

else if (contGuardados==4'd8)begin
mesUSig = dirAsciiDatoU;
mesDSig = dirAsciiDatoD;end

else if (contGuardados==4'd9)begin
anoUSig = dirAsciiDatoU;
anoDSig = dirAsciiDatoD;end

else if (contGuardados==4'd10)begin
diaSemanaUSig = dirAsciiDatoU;
diaSemanaDSig = dirAsciiDatoD;end

else if (contGuardados==4'd11)begin
numeroSemanaUSig = dirAsciiDatoU;
numeroSemanaDSig = dirAsciiDatoD;end

//Temporizador
else if (contGuardados==4'd12)begin
SegundosUTSig = dirAsciiDatoU;
SegundosDTSig = dirAsciiDatoD;end

else if (contGuardados==4'd13)begin
minutosUTSig = dirAsciiDatoU;
minutosDTSig = dirAsciiDatoD;end

else if (contGuardados==4'd14)begin
horasUTSig = dirAsciiDatoU;
horasDTSig = dirAsciiDatoD;end






//Registros Datos principales

always @(posedge clk)//Cuando el modo escritura esta activo escribe datos en los registros y si no los mantiene para ser leidos
//Reloj
if (w==1 & r==0)
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
else //Evitar warning latch
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

//____________________________________________________________________________________________________
//____________________________________________________________________________________________________
//Sección  Lectura


//Selector de registros
//Impresion de datos

ImpresionDatos ImpresionDatos_unit
    (
    .clk(clk),.pixelx(pixelx),.pixely(pixely),.rom_addr(rom_addr),
    .font_size(font_size),.color_addr(color_addr),
    .SegundosU(SegundosU),.SegundosD(SegundosD),.minutosU(minutosU)
    ,.minutosD(minutosD),.horasU(horasU),.horasD(horasD),.dp(dp)
    ,.fechaU(fechaU),.mesU(mesU),.anoU(anoU),.diaSemanaU(diaSemanaU),
     .numeroSemanaU(numeroSemanaU),.fechaD(fechaD),.mesD(mesD),.anoD(anoD),.diaSemanaD(diaSemanaD),
     .numeroSemanaD(numeroSemanaD)
    );


//Memoria Ascii
Font_rom Font_memory_unit
     (
          .dir(rom_addr),
          .clk(clk),
          .data(font_word)
     );

/*
//Tamaño de fuentes y Mux recorrido de columnas Memoria
assign f8=pixel_x[2:0];
assign f16=pixel_x[3:0];
assign f32=pixel_x[4:0];

always @(posedge clk)

if (font_size==2'd0)begin
font_bit =font_word [f8];end

else if (font_size==2'd1)begin
font_bit =font_word [f16];end

else begin
font_bit =font_word [f32];end
*/

wire[2:0]  bit_addr;

assign bit_addr= pixelx[2:0];//Para poder ver la direccion de recorrido del Mux columnas

//Mux columnas
always @(posedge clk)
if (dp)begin
 font_bit =font_word [~(bit_addr)]; //Recorre las columnas de los datos extraidos de la memoria
 end


//Rom colores
//Almacena las combinaciones de colores posibles

always @(posedge clk)

case (color_addr) // combinación de colores seleccionados de acuerdo al switch, solo se puede seleccionar un siwtch a la vez
//         r      g    b
//color = 0000  0000  0000

4'd0: color = 12'b000100010001;
4'd1: color = 12'hFFF;
4'd2: color = 12'hFFF;
4'd3: color = 12'b000100010001;
4'd4: color = 12'b000100010001;
4'd5: color = 12'b000100010001;
4'd6: color = 12'b000100010001;
4'd7: color = 12'b000100010001;
4'd8: color = 12'b000100010001;
4'd9: color = 12'b000100010001;
4'd10: color = 12'b000100010001;
4'd11: color = 12'b000100010001;
4'd12: color = 12'b000100010001;
4'd13: color = 12'b000100010001;
4'd14: color = 12'b000100010001;
4'd15: color = 12'b000100010001;
endcase



//Salida VGA

always @(posedge clk) //operación se realiza con cada pulso de reloj
    if (font_bit==1 & video_on==1 & dp==1)  //se encienden los LEDs solo si el bit se encuentra en 1 en memoria
        rgb=color;
 else
    rgb <= 0;


assign rgbO=rgb;

endmodule
