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
    output wire [1:0] font_sizeo,// Tamaño de fuente
    output wire [2:0] color_addro, //Tres bits porque por ahora se van a manejar 15 colores
    output wire dpo,//Dice si va a haber un dato en pantalla
    output wire memInto//Quitar
 );


//Parametros de posiciones en pantalla
//reloj


reg dp=1'd0;
reg memInt;
reg [2:0] color_addr;
reg [1:0] font_size;


assign dpo=dp;
assign memInto=memInt;
assign color_addro=color_addr;
assign font_sizeo=font_size;



//Segundos
//Limites en el eje x
localparam IsegundosD=10'd343;
localparam DsegundosD=10'd351;
localparam IsegundosU=10'd352;
localparam DsegundosU=10'd359;
//Limites en el eje y
localparam ARsegundos=10'd242; //Solo 2 porque siempre van a estar a la par
localparam ABsegundos=10'd257;



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
localparam IfechaD=10'd591;
localparam DfechaD=10'd598;
localparam IfechaU=10'd599;
localparam DfechaU=10'd606;
//Limites en el eje y
localparam ARfecha=10'd434; //Solo 2 porque siempre van a estar a la par
localparam ABfecha=10'd446;

//Mes
//Limites en el eje x
localparam ImesD=10'd607;
localparam DmesD=10'd614;
localparam ImesU=10'd615;
localparam DmesU=10'd622;
//Limites en el eje y
localparam ARmes=10'd450; //Solo 2 porque siempre van a estar a la par
localparam ABmes=10'd461;


//Año
//Limites en el eje x
localparam IanoD=10'd599;
localparam DanoD=10'd606;
localparam IanoU=10'd607;
localparam DanoU=10'd614;
//Limites en el eje y
localparam ARano=10'd418; //Solo 2 porque siempre van a estar a la par
localparam ABano=10'd428;


//Dia de la semana
//Limites en el eje x
localparam IdiaD=10'd575;
localparam DdiaD=10'd582;
localparam IdiaU=10'd583;
localparam DdiaU=10'd590;
//Limites en el eje y
localparam ARdia=10'd450; //Solo 2 porque siempre van a estar a la par
localparam ABdia=10'd461;



//Numero de Semana
//Limites en el eje x
localparam IsemanaD=10'd343;
localparam DsemanaD=10'd350;
localparam IsemanaU=10'd351;
localparam DsemanaU=10'd358;
//Limites en el eje y
localparam ARsemana=10'd16; //Solo 2 porque siempre van a estar a la par
localparam ABsemana=10'd29;






 //variables internas de conexión

 reg [6:0] char_addr; //  bits mas significativos de dirreción de memoria, del caracter a imprimir
 reg [3:0] row_addr; //Cambio entre las filas de la memoria, bits menos significativos de pixel y,bit menos significativos de memoria




//body
//Direccion de fila
always @(posedge clk)

if (font_size==2'd1)begin
row_addr<= pixely[3:0];end

else if (font_size==2'd0)begin
row_addr<= pixely[4:1];end

else if (font_size==2'd2)begin
row_addr<= pixely[5:2];end

else begin
row_addr<= pixely[3:0];end


//Sin escalar
//assign row_addr= pixely[3:0]; //4 bits menos significatvos de y, para variar de filas en la memoria
//Escalado
//assign row_addr=pixely[4:1];

always @(posedge clk)//Se ejecuta cuando hay un cambio en pixel x o pixel y



//Impresion

 //Para el segundo mozaico x=7-14  y=0-15
   //Segundos
    if ((pixelx >= IsegundosD) && (pixelx<=DsegundosD) && (pixely >= ARsegundos) & (pixely<=ABsegundos))begin
        char_addr <= SegundosD; //direccion de lo que se va a imprimir
        color_addr<=4'd2;// Color de lo que se va a imprimir
        font_size<=2'd1;//Tamaño de fuente
        memInt<=1'd0;
        dp<=1'd1; end

    else if ((pixelx >= IsegundosU) && (pixelx<=DsegundosU) && (pixely >= ARsegundos) && (pixely<=ABsegundos))begin
        char_addr <= SegundosU; //direccion de lo que se va a imprimir
        color_addr<=4'd2;// Color de lo que se va a imprimir
        font_size<=1;
        memInt<=1'd0;
        dp<=1'd1;end//Tamaño de fuente

//Minutos
  else if ((pixelx >= IminutosD) && (pixelx<=DminutosD) && (pixely >= ARminutos) && (pixely<=ABminutos))begin
      char_addr <= minutosD; //direccion de lo que se va a imprimir
      color_addr<=4'd2;// Color de lo que se va a imprimir
      font_size<=2'd1;
      memInt<=1'd0;
      dp<=1'd1;end//Tamaño de fuente

  else if ((pixelx >= IminutosU) && (pixelx<=DminutosU) && (pixely >= ARminutos) && (pixely<=ABminutos))begin
      char_addr <= minutosU; //direccion de lo que se va a imprimir
      color_addr<=4'd2;// Color de lo que se va a imprimir
      font_size<=2'd1;
      memInt<=1'd0;
      dp<=1'd1;end//Tamaño de fuente

//Horas
 else if ((pixelx >= IhorasD) && (pixelx<=DhorasD) && (pixely >= ARhoras) && (pixely<=ABhoras))begin
    char_addr <= horasD; //direccion de lo que se va a imprimir
    color_addr<=4'd2;// Color de lo que se va a imprimir
    font_size<=2'd1;
    memInt<=1'd0;
    dp<=1'd1; end//Tamaño de fuente



    else if ((pixelx >= IhorasU) && (pixelx<=DhorasU) && (pixely >= ARhoras) && (pixely<=ABhoras))begin
        char_addr <= horasU;//direccion de lo que se va a imprimir
        color_addr<=4'd2;// Color de lo que se va a imprimir
        font_size<=2'd1;
        memInt<=1'd0;
        dp<=1'd1;end//Tamaño de fuente




/*
        //Rayas Amarillas
         else if ((pixelx >= 10'd0) && (pixelx<=10'd640) && (pixely >= 10'd459) && (pixely<=10'd469))begin
            char_addr = 7'h0a; //direccion de lo que se va a imprimir
            color_addr=4'd3;// Color de lo que se va a imprimir
            font_size=2'd1;
            dp=1'b1; end//Tamaño de fuente

            //Rayas rojas
             else if ((pixelx >= 10'd0) && (pixelx<=10'd640) && (pixely >= 10'd448) && (pixely<=10'd458))begin
                char_addr = 7'h0a; //direccion de lo que se va a imprimir
                color_addr=4'd4;// Color de lo que se va a imprimir
                font_size=2'd1;
                dp=1'b1; end//Tamaño de fuente*/
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++



        //Texto semana
        //S
        else if ((pixelx >= 10'd287) && (pixelx<=10'd294) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
            char_addr <= 7'h53;//direccion de lo que se va a imprimir
            color_addr<=4'd2;// Color de lo que se va a imprimir
            font_size<=2'd1;
            memInt<=1'd0;
            dp<=1'd1;end//Tamaño de fuente


            //E
            else if ((pixelx >= 10'd295) && (pixelx<=10'd302) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
                char_addr <= 7'h45;//direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color de lo que se va a imprimir
                font_size<=2'd1;
                memInt<=1'd0;
                dp<=1'd1;end

                //M
          else if ((pixelx >= 10'd303) && (pixelx<=10'd310) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
                char_addr <= 7'h4d;//direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color de lo que se va a imprimir
                font_size<=2'd1;
                memInt<=1'd0;
                dp<=1'd1;end

                //A
          else if ((pixelx >= 10'd311) && (pixelx<=10'd319) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
                char_addr <= 7'h41;//direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color de lo que se va a imprimir
                font_size<=2'd1;
                memInt<=1'd0;
                dp<=1'd1;end


                //N
          else if ((pixelx >= 10'd320) && (pixelx<=10'd327) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
                char_addr <= 7'h4e;//direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color de lo que se va a imprimir
                font_size<=2'd1;
                memInt<=1'd0;
                dp<=1'd1;end


                //A
          else if ((pixelx >= 10'd328) && (pixelx<=10'd334) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
                char_addr <= 7'h41;//direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color de lo que se va a imprimir
                font_size<=2'd1;
                memInt<=1'd0;
                dp<=1'd1;end

//Semana
else if ((pixelx >= IsemanaU) && (pixelx<=DsemanaU) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
    char_addr <= numeroSemanaU;//direccion de lo que se va a imprimir
    color_addr<=4'd2;// Color de lo que se va a imprimir
    font_size<=2'd1;
    memInt<=1'd0;
    dp<=1'd1;end//Tamaño de fuente

    else if ((pixelx >= IsemanaD) && (pixelx<=DsemanaD) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
        char_addr <= numeroSemanaD;//direccion de lo que se va a imprimir
        color_addr<=4'd2;// Color de lo que se va a imprimir
        font_size<=2'd1;
        memInt<=1'd0;
        dp<=1'd1;end//Tamaño de fuente


//Dia
        else if ((pixelx >= IdiaD) && (pixelx<=DdiaD) && (pixely >= ARdia) && (pixely<=ABdia))begin
            char_addr <= diaSemanaD;//direccion de lo que se va a imprimir
            color_addr<=4'd2;// Color de lo que se va a imprimir
            font_size<=2'd1;
            memInt<=1'd0;
            dp<=1'd1;end//Tamaño de fuente

            else if ((pixelx >= IdiaU) && (pixelx<=DdiaU) && (pixely >= ARdia) && (pixely<=ABdia))begin
                char_addr <= diaSemanaU;//direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color de lo que se va a imprimir
                font_size<=2'd1;
                memInt<=1'd0;
                dp<=1'd1;end//Tamaño de fuente


                //Fecha
                        else if ((pixelx >= IfechaD) && (pixelx<=DfechaD) && (pixely >= ARfecha) && (pixely<=ABfecha))begin
                            char_addr <= fechaD;//direccion de lo que se va a imprimir
                            color_addr<=4'd2;// Color de lo que se va a imprimir
                            font_size<=2'd1;
                            memInt<=1'd0;
                            dp<=1'd1;end//Tamaño de fuente

                            else if ((pixelx >= IfechaU) && (pixelx<=DfechaU) && (pixely >= ARfecha) && (pixely<=ABfecha))begin
                                char_addr <= fechaU;//direccion de lo que se va a imprimir
                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                font_size<=2'd1;
                                memInt<=1'd0;
                                dp<=1'd1;end//Tamaño de fuente





//Año 20

  else if ((pixelx >= 10'd591) && (pixelx<=10'd598) && (pixely >= ARano) && (pixely<=ABano))begin
  char_addr <= 7'h30;//direccion de lo que se va a imprimir
  color_addr<=4'd2;// Color de lo que se va a imprimir
    font_size<=2'd2;
    memInt<=1'd0;
    dp<=1'd1;end//Tamaño de fuente

else if ((pixelx >= 10'd583) && (pixelx<=10'd590) && (pixely >= ARano) && (pixely<=ABano))begin
  char_addr <= 7'h32;//direccion de lo que se va a imprimir
  color_addr<=4'd2;// Color de lo que se va a imprimir
  font_size<=2'd1;
  memInt<=1'd0;
  dp<=1'd1;end//Tamaño de fuente


    //Año
              else if ((pixelx >= IanoD) && (pixelx<=DanoD) && (pixely >= ARano) && (pixely<=ABano))begin
                char_addr <= anoD;//direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color de lo que se va a imprimir
                  font_size<=2'd1;
                  memInt<=1'd0;
                  dp=1'd1;end//Tamaño de fuente

              else if ((pixelx >= IanoU) && (pixelx<=DanoU) && (pixely >= ARano) && (pixely<=ABano))begin
                char_addr <= anoU;//direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color de lo que se va a imprimir
                font_size<=2'd1;
                memInt<=1'd0;
                dp<=1'd1;end//Tamaño de fuente


                //Año
                          else if ((pixelx >= ImesD) && (pixelx<=DmesD) && (pixely >= ARmes) && (pixely<=ABmes))begin
                            char_addr <=mesD;//direccion de lo que se va a imprimir
                            color_addr<=4'd2;// Color de lo que se va a imprimir
                              font_size<=2'd1;
                              memInt<=1'd0;
                              dp<=1'd1;end//Tamaño de fuente

                          else if ((pixelx >= ImesU) && (pixelx<=DmesU) && (pixely >= ARmes) && (pixely<=ABmes))begin
                            char_addr <= mesU;//direccion de lo que se va a imprimir
                            color_addr<=4'd2;// Color de lo que se va a imprimir
                            font_size<=2'd1;
                            memInt<=1'd0;
                            dp<=1'd1;end//Tamaño de fuente

 else //Fondo de Pamtalla
begin

if ((pixely >= 10'd0) && (pixely<=10'd140))begin
char_addr = 7'h0a; //direccion de lo que se va a imprimir
color_addr=4'd0;// Color de lo que se va a imprimir
font_size=2'd1;
memInt=1'd1;
dp=1'd1; end//Tamaño de fuente



else if ((pixely >= 10'd141) && (pixely<=10'd151))begin
char_addr = 7'h0a; //direccion de lo que se va a imprimir
color_addr=4'd1;// Color de lo que se va a imprimir
font_size=2'd1;
memInt=1'd1;
dp=1'd1; end//Tamaño de fuente


//Cuadros
else if ((pixely >= 10'd152) && (pixely<=10'd338))begin


//Curva superior
if ((pixelx <=32) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=33) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=34) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=36) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=205) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=207) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=208) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=209) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=232) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=233) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=234) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=236) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=405) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=407) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=408) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=409) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=432) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=433) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=434) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=436) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=605) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=607) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=608) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=609) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=30) && (pixely == 153)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=31) && (pixely == 153)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=33) && (pixely == 153)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=208) && (pixely == 153)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=210) && (pixely == 153)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=211) && (pixely == 153)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=230) && (pixely == 153)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=231) && (pixely == 153)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=233) && (pixely == 153)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=408) && (pixely == 153)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=410) && (pixely == 153)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=411) && (pixely == 153)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=430) && (pixely == 153)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=431) && (pixely == 153)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=433) && (pixely == 153)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=608) && (pixely == 153)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=610) && (pixely == 153)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=611) && (pixely == 153)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=30) && (pixely == 154)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=32) && (pixely == 154)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=209) && (pixely == 154)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=211) && (pixely == 154)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=230) && (pixely == 154)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=232) && (pixely == 154)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=409) && (pixely == 154)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=411) && (pixely == 154)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=430) && (pixely == 154)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=432) && (pixely == 154)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=609) && (pixely == 154)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=611) && (pixely == 154)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=29) && (pixely == 155)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=30) && (pixely == 155)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=31) && (pixely == 155)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=210) && (pixely == 155)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=211) && (pixely == 155)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=212) && (pixely == 155)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=229) && (pixely == 155)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=230) && (pixely == 155)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=231) && (pixely == 155)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=410) && (pixely == 155)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=411) && (pixely == 155)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=412) && (pixely == 155)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=429) && (pixely == 155)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=430) && (pixely == 155)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=431) && (pixely == 155)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=610) && (pixely == 155)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=611) && (pixely == 155)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=612) && (pixely == 155)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=28) && (pixely == 156)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=29) && (pixely == 156)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=30) && (pixely == 156)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=211) && (pixely == 156)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=212) && (pixely == 156)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=213) && (pixely == 156)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=228) && (pixely == 156)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=229) && (pixely == 156)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=230) && (pixely == 156)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=411) && (pixely == 156)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=412) && (pixely == 156)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=413) && (pixely == 156)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=428) && (pixely == 156)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=429) && (pixely == 156)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=430) && (pixely == 156)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=611) && (pixely == 156)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=612) && (pixely == 156)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=613) && (pixely == 156)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=28) && (pixely == 157)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=29) && (pixely == 157)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=30) && (pixely == 157)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=211) && (pixely == 157)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=212) && (pixely == 157)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=213) && (pixely == 157)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=228) && (pixely == 157)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=229) && (pixely == 157)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=230) && (pixely == 157)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=411) && (pixely == 157)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=412) && (pixely == 157)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=413) && (pixely == 157)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=428) && (pixely == 157)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=429) && (pixely == 157)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=430) && (pixely == 157)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=611) && (pixely == 157)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=612) && (pixely == 157)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=613) && (pixely == 157)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=28) && (pixely == 158)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=30) && (pixely == 158)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=211) && (pixely == 158)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=213) && (pixely == 158)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=228) && (pixely == 158)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=230) && (pixely == 158)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=411) && (pixely == 158)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=413) && (pixely == 158)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=428) && (pixely == 158)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=430) && (pixely == 158)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=611) && (pixely == 158)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=613) && (pixely == 158)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end

//Parte constante
else if ((pixelx <=28) && (pixely >= 159) && (pixely <= 244))begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=29) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=212) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=213) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=228) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=229) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=412) && (pixely >= 159 ) && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=413) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=428) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=429) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=612) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=613) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=800) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end

//Raya Negra
else if (pixely >= 244  && (pixely <= 247)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end


//Segunda parte constante

else if  ((pixelx <=28) && (pixely >= 248) && (pixely <= 333))begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ( (pixelx <=29) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ( (pixelx <=212) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ( (pixelx <=213) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ( (pixelx <=228) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ( (pixelx <=229) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ( (pixelx <=412) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ( (pixelx <=413) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ( (pixelx <=428) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ( (pixelx <=429) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ( (pixelx <612) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ( (pixelx <=613) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ( (pixelx <=800) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end


//Curva inferior
else if ((pixelx <=28) && (pixely == 332)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=29) && (pixely == 332)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=30) && (pixely == 332)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=211) && (pixely == 332)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=212) && (pixely == 332)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=213) && (pixely == 332)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=228) && (pixely == 332)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=229) && (pixely == 332)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=230) && (pixely == 332)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=411) && (pixely == 332)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=412) && (pixely == 332)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=413) && (pixely == 332)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=428) && (pixely == 332)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=429) && (pixely == 332)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=430) && (pixely == 332)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=611) && (pixely == 332)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=612) && (pixely == 332)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=613) && (pixely == 332)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=29) && (pixely == 333)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=30) && (pixely == 333)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=31) && (pixely == 333)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=210) && (pixely == 333)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=211) && (pixely == 333)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=212) && (pixely == 333)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=229) && (pixely == 333)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=230) && (pixely == 333)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=231) && (pixely == 333)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=410) && (pixely == 333)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=411) && (pixely == 333)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=412) && (pixely == 333)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=429) && (pixely == 333)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=430) && (pixely == 333)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=431) && (pixely == 333)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=610) && (pixely == 333)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=611) && (pixely == 333)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=612) && (pixely == 333)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=30) && (pixely == 334)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=32) && (pixely == 334)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=209) && (pixely == 334)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=211) && (pixely == 334)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=230) && (pixely == 334)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=232) && (pixely == 334)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=409) && (pixely == 334)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=411) && (pixely == 334)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=430) && (pixely == 334)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=432) && (pixely == 334)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=609) && (pixely == 334)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=611) && (pixely == 334)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=30) && (pixely == 335)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=31) && (pixely == 335)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=33) && (pixely == 335)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=208) && (pixely == 335)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=210) && (pixely == 335)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=211) && (pixely == 335)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=230) && (pixely == 335)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=231) && (pixely == 335)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=233) && (pixely == 335)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=408) && (pixely == 335)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=410) && (pixely == 335)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=411) && (pixely == 335)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=430) && (pixely == 335)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=431) && (pixely == 335)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=433) && (pixely == 335)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=608) && (pixely == 335)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=610) && (pixely == 335)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=611) && (pixely == 335)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=32) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=33) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=34) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=36) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=205) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=207) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=208) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=209) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=232) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=233) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=234) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=236) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=405) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=407) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=408) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=409) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=432) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=433) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=434) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=436) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=605) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=607) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=608) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=609) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=33) && (pixely == 337)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=35) && (pixely == 337)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=36) && (pixely == 337)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=205) && (pixely == 337)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=206) && (pixely == 337)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=208) && (pixely == 337)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=233) && (pixely == 337)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=235) && (pixely == 337)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=236) && (pixely == 337)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=405) && (pixely == 337)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=406) && (pixely == 337)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=408) && (pixely == 337)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=433) && (pixely == 337)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
else if ((pixelx <=435) && (pixely == 337)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if ((pixelx <=436) && (pixely == 337)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=605) && (pixely == 337)) begin
dp=1'd1;color_addr=3'd5;memInt=1'd1;end
else if ((pixelx <=606) && (pixely == 337)) begin
dp=1'd1;color_addr=3'd4;memInt=1'd1;end
else if ((pixelx <=608) && (pixely == 337)) begin
dp=1'd1;color_addr=3'd3;memInt=1'd1;end
else if (pixely == 338) begin
dp=1;color_addr=3'd1;memInt=1;end
else begin
dp=dp;color_addr=color_addr;memInt=memInt;end


end//Tamaño de fuente

//-----------------------------------------------------------

else if ((pixely >= 10'd339) && (pixely<=10'd348))begin
char_addr <= 7'h0a; //direccion de lo que se va a imprimir
color_addr<=4'd1;// Color de lo que se va a imprimir
font_size<=2'd1;
memInt<=1'd1;
dp<=1'd1; end//Tamaño de fuente



else if ((pixely >= 10'd349) && (pixely<=10'd351))begin
char_addr <= 7'h0a; //direccion de lo que se va a imprimir
color_addr<=4'd0;// Color de lo que se va a imprimir
font_size<=2'd1;
memInt<=1'd1;
dp<=1'd1; end//Tamaño de fuente



else if ((pixely >= 10'd352) && (pixely<=10'd353))begin
char_addr <= 7'h0a; //direccion de lo que se va a imprimir
color_addr<=4'd1;// Color de lo que se va a imprimir
font_size<=2'd1;
memInt<=1;
dp<=1'd1; end//Tamaño de fuente


else if ((pixely >= 10'd354) && (pixely<=10'd472))begin
char_addr <= 7'h0a; //direccion de lo que se va a imprimir
color_addr<=4'd0;// Color de lo que se va a imprimir
font_size<=2'd1;
memInt<=1;
dp<=1'd1; end//Tamaño de fuente



else if ((pixely >= 10'd473) && (pixely<= 10'd480))begin
char_addr <= 7'h0a; //direccion de lo que se va a imprimir
color_addr<=4'd2;// Color de lo que se va a imprimir
font_size<=2'd1;
memInt<=1;
dp<=1'd1; end//Tamaño de fuente


else begin
char_addr <= 7'h0a; //direccion de lo que se va a imprimir
color_addr<=4'd0;// Color de lo que se va a imprimir
font_size<=2'd1;
dp<=1'd1; end//Tamaño de fuente


end







assign rom_addr = {char_addr, row_addr}; //concatena direcciones de registros y filas


endmodule
