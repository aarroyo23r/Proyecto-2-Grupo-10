`timescale 1ns / 1ps

module ImpresionDatos
    (
    input wire clk,
    input wire [6:0] SegundosU,SegundosD,minutosU,minutosD,horasU,horasD,
    fechaU,mesU,anoU,diaSemanaU, numeroSemanaU,fechaD,mesD,anoD,diaSemanaD,
    numeroSemanaD,
    input wire [9:0] pixelx, //posición pixel x actual
    input wire [9:0] pixely,//posición pixel y actual
    output wire [10:0] rom_addr,//Direccion en la memoria del dato
    output reg [1:0] font_size,// Tamaño de fuente
    output reg [3:0] color_addr, //Tres bits porque por ahora se van a manejar 15 colores
    output reg dp //Dice si va a haber un dato en pantalla
 );


//Parametros de posiciones en pantalla
//reloj



//Segundos
//Limites en el eje x
localparam IsegundosD=10'd342;
localparam DsegundosD=10'd349;
localparam IsegundosU=10'd350;
localparam DsegundosU=10'd357;
//Limites en el eje y
localparam ARsegundos=10'd240; //Solo 2 porque siempre van a estar a la par
localparam ABsegundos=10'd255;



//Minutos
//Limites en el eje x
localparam IminutosD=10'd319;
localparam DminutosD=10'd326;
localparam IminutosU=10'd327;
localparam DminutosU=10'd334;
//Limites en el eje y
localparam ARminutos=10'd240; //Solo 2 porque siempre van a estar a la par
localparam ABminutos=10'd255;

//horas
//Limites en el eje x
localparam IhorasD=10'd295;
localparam DhorasD=10'd302;
localparam IhorasU=10'd303;
localparam DhorasU=10'd310;
//Limites en el eje y
localparam ARhoras=10'd240; //Solo 2 porque siempre van a estar a la par
localparam ABhoras=10'd255;

//Fecha
//Limites en el eje x
localparam IfechaD=10'd300;
localparam DfechaD=10'd307;
localparam IfechaU=10'd310;
localparam DfechaU=10'd317;
//Limites en el eje y
localparam ARfecha=10'd3; //Solo 2 porque siempre van a estar a la par
localparam ABfecha=10'd19;

//Mes
//Limites en el eje x
localparam ImesD=10'd300;
localparam DmesD=10'd307;
localparam ImesU=10'd310;
localparam DmesU=10'd317;
//Limites en el eje y
localparam ARmes=10'd120; //Solo 2 porque siempre van a estar a la par
localparam ABmes=10'd135;


//Año
//Limites en el eje x
localparam IanoD=10'd599;
localparam DanoD=10'd606;
localparam IanoU=10'd607;
localparam DanoU=10'd614;
//Limites en el eje y
localparam ARano=10'd337; //Solo 2 porque siempre van a estar a la par
localparam ABano=10'd352;


//Dia de la semana
//Limites en el eje x
localparam IdiaD=10'd591;
localparam DdiaD=10'd598;
localparam IdiaU=10'd599;
localparam DdiaU=10'd606;
//Limites en el eje y
localparam ARdia=10'd353; //Solo 2 porque siempre van a estar a la par
localparam ABdia=10'd368;



//Numero de Semana
//Limites en el eje x
localparam IsemanaD=10'd62;
localparam DsemanaD=10'd69;
localparam IsemanaU=10'd70;
localparam DsemanaU=10'd77;
//Limites en el eje y
localparam ARsemana=10'd31; //Solo 2 porque siempre van a estar a la par
localparam ABsemana=10'd46;






 //variables internas de conexión

 reg [6:0] char_addr; //  bits mas significativos de dirreción de memoria, del caracter a imprimir
 wire [3:0] row_addr; //Cambio entre las filas de la memoria, bits menos significativos de pixel y,bit menos significativos de memoria




//body

//Sin escalar
assign row_addr= pixely[3:0]; //4 bits menos significatvos de y, para variar de filas en la memoria
//Escalado
//assign row_addr=pixely[4:1];

always @(posedge clk)//Se ejecuta cuando hay un cambio en pixel x o pixel y



//Impresion

 //Para el segundo mozaico x=7-14  y=0-15
   //Segundos
    if ((pixelx >= IsegundosD) && (pixelx<=DsegundosD) && (pixely >= ARsegundos) & (pixely<=ABsegundos))begin
        char_addr = SegundosD; //direccion de lo que se va a imprimir
        color_addr=4'd2;// Color de lo que se va a imprimir
        font_size=2'd1;//Tamaño de fuente
        dp=1'b1; end

    else if ((pixelx >= IsegundosU) && (pixelx<=DsegundosU) && (pixely >= ARsegundos) && (pixely<=ABsegundos))begin
        char_addr = SegundosU; //direccion de lo que se va a imprimir
        color_addr=4'd2;// Color de lo que se va a imprimir
        font_size=1;
        dp=1'b1;end//Tamaño de fuente

//Minutos
  else if ((pixelx >= IminutosD) && (pixelx<=DminutosD) && (pixely >= ARminutos) && (pixely<=ABminutos))begin
      char_addr = minutosD; //direccion de lo que se va a imprimir
      color_addr=4'd2;// Color de lo que se va a imprimir
      font_size=2'd1;
      dp=1'b1;end//Tamaño de fuente

  else if ((pixelx >= IminutosU) && (pixelx<=DminutosU) && (pixely >= ARminutos) && (pixely<=ABminutos))begin
      char_addr = minutosU; //direccion de lo que se va a imprimir
      color_addr=4'd2;// Color de lo que se va a imprimir
      font_size=2'd1;
      dp=1'b1;end//Tamaño de fuente

//Horas
 else if ((pixelx >= IhorasD) && (pixelx<=DhorasD) && (pixely >= ARhoras) && (pixely<=ABhoras))begin
    char_addr = horasD; //direccion de lo que se va a imprimir
    color_addr=4'd2;// Color de lo que se va a imprimir
    font_size=2'd1;
    dp=1'b1; end//Tamaño de fuente



    else if ((pixelx >= IhorasU) && (pixelx<=DhorasU) && (pixely >= ARhoras) && (pixely<=ABhoras))begin
        char_addr = horasU;//direccion de lo que se va a imprimir
        color_addr=4'd2;// Color de lo que se va a imprimir
        font_size=2'd1;
        dp=1'b1;end//Tamaño de fuente




//Rayas
 else if ((pixelx >= 10'd295) && (pixelx<=10'd357) && (pixely >= 10'd255) && (pixely<=10'd258))begin
    char_addr = 7'h0a; //direccion de lo que se va a imprimir
    color_addr=4'd2;// Color de lo que se va a imprimir
    font_size=2'd1;
    dp=1'b1; end//Tamaño de fuente
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++



        //Texto semana
        //S
        else if ((pixelx >= 10'd7) && (pixelx<=10'd14) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
            char_addr = 7'h53;//direccion de lo que se va a imprimir
            color_addr=4'd2;// Color de lo que se va a imprimir
            font_size=2'd1;
            dp=1'b1;end//Tamaño de fuente


            //E
            else if ((pixelx >= 10'd15) && (pixelx<=10'd23) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
                char_addr = 7'h45;//direccion de lo que se va a imprimir
                color_addr=4'd2;// Color de lo que se va a imprimir
                font_size=2'd1;
                dp=1'b1;end

                //M
          else if ((pixelx >= 10'd24) && (pixelx<=10'd31) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
                char_addr = 7'h4d;//direccion de lo que se va a imprimir
                color_addr=4'd2;// Color de lo que se va a imprimir
                font_size=2'd1;
                dp=1'b1;end

                //A
          else if ((pixelx >= 10'd32) && (pixelx<=10'd39) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
                char_addr = 7'h41;//direccion de lo que se va a imprimir
                color_addr=4'd2;// Color de lo que se va a imprimir
                font_size=2'd1;
                dp=1'b1;end


                //N
          else if ((pixelx >= 10'd40) && (pixelx<=10'd47) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
                char_addr = 7'h4e;//direccion de lo que se va a imprimir
                color_addr=4'd2;// Color de lo que se va a imprimir
                font_size=2'd1;
                dp=1'b1;end


                //A
          else if ((pixelx >= 10'd48) && (pixelx<=10'd54) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
                char_addr = 7'h41;//direccion de lo que se va a imprimir
                color_addr=4'd2;// Color de lo que se va a imprimir
                font_size=2'd1;
                dp=1'b1;end

//Semana
else if ((pixelx >= IsemanaU) && (pixelx<=DsemanaU) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
    char_addr = numeroSemanaU;//direccion de lo que se va a imprimir
    color_addr=4'd2;// Color de lo que se va a imprimir
    font_size=2'd1;
    dp=1'b1;end//Tamaño de fuente

    else if ((pixelx >= IsemanaD) && (pixelx<=DsemanaD) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
        char_addr = numeroSemanaD;//direccion de lo que se va a imprimir
        color_addr=4'd2;// Color de lo que se va a imprimir
        font_size=2'd1;
        dp=1'b1;end//Tamaño de fuente

//Dia
        else if ((pixelx >= IdiaD) && (pixelx<=DdiaD) && (pixely >= ARdia) && (pixely<=ABdia))begin
            char_addr = diaSemanaD;//direccion de lo que se va a imprimir
            color_addr=4'd2;// Color de lo que se va a imprimir
            font_size=2'd1;
            dp=1'b1;end//Tamaño de fuente

            else if ((pixelx >= IdiaU) && (pixelx<=DdiaU) && (pixely >= ARdia) && (pixely<=ABdia))begin
                char_addr = diaSemanaU;//direccion de lo que se va a imprimir
                color_addr=4'd2;// Color de lo que se va a imprimir
                font_size=2'd1;
                dp=1'b1;end//Tamaño de fuente


//Año 20

  else if ((pixelx >= 10'd591) && (pixelx<=10'd598) && (pixely >= ARano) && (pixely<=ABano))begin
  char_addr = 7'h30;//direccion de lo que se va a imprimir
  color_addr=4'd2;// Color de lo que se va a imprimir
    font_size=2'd1;
    dp=1'b1;end//Tamaño de fuente

else if ((pixelx >= 10'd583) && (pixelx<=10'd590) && (pixely >= ARano) && (pixely<=ABano))begin
  char_addr = 7'h32;//direccion de lo que se va a imprimir
  color_addr=4'd2;// Color de lo que se va a imprimir
  font_size=2'd1;
  dp=1'b1;end//Tamaño de fuente


    //Año
              else if ((pixelx >= IanoD) && (pixelx<=DanoD) && (pixely >= ARano) && (pixely<=ABano))begin
                char_addr = anoD;//direccion de lo que se va a imprimir
                color_addr=4'd2;// Color de lo que se va a imprimir
                  font_size=2'd1;
                  dp=1'b1;end//Tamaño de fuente

              else if ((pixelx >= IanoU) && (pixelx<=DanoU) && (pixely >= ARano) && (pixely<=ABano))begin
                char_addr = anoU;//direccion de lo que se va a imprimir
                color_addr=4'd2;// Color de lo que se va a imprimir
                font_size=2'd1;
                dp=1'b1;end//Tamaño de fuente

 else //Si no se cumple ninguna de estas impresiones se pone la pantalla en negro
 begin
 char_addr = 7'd0;
 dp=1'b0;
 dp=1'b1;end

assign rom_addr ={char_addr, row_addr}; //concatena direcciones de registros y filas


endmodule
