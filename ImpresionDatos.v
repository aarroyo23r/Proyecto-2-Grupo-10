`timescale 1ns / 1ps



module ImpresionDatos
    (
    input wire clk,
    input wire instrucciones,
    input wire [6:0] SegundosU,SegundosD,minutosU,minutosD,horasU,horasD,
    fechaU,mesU,anoU,diaSemanaU, numeroSemanaU,fechaD,mesD,anoD,diaSemanaD,
    numeroSemanaD,
    input wire [6:0] SegundosUT,minutosUT,horasUT,
    input wire [6:0] SegundosDT,minutosDT,horasDT,

    input wire [9:0] pixelx, //posición pixel x actual
    input wire [9:0] pixely,//posición pixel y actual
    output wire [10:0] rom_addr,//Direccion en la memoria del dato
    output wire [17:0] rom_addrGraficos,
    output wire [1:0] font_sizeo,// Tamaño de fuente
    output wire [2:0] color_addro, //Tres bits porque por ahora se van a manejar 15 colores
    output wire dpo,//Dice si va a haber un dato en pantalla
    output wire memInto,//Quitar
    output wire graficosO
 );


//Parametros de posiciones en pantalla
//reloj


reg dp=1'd0;
reg memInt=0;
reg [2:0] color_addr;
reg [1:0] font_size;
//wire [10:0] rom_addr;
//wire [15:0] rom_addrGraficosO,

//Variables para usar la memoria de Graficos
reg graficos;
reg [5:0] contadorx;
wire [9:0] contadory;
reg [9:0] contadorycambio=7'h0;


assign dpo=dp;
assign memInto=memInt;
assign color_addro=color_addr;
assign font_sizeo=font_size;



//assign contadorx=(pixelx[5:0] + 6'd5) ;//Los contadores son mayores que el tamaño del numero por lo que hay que tomarlo en
assign contadory= pixely - 10'd197;//Cuenta a la hora de imprimir

reg [1:0] zero=2'h0;

//Parametros para indicar la posicion en pantalla

//Parametros Textos
localparam  cambioMozaico = 10'd8;
localparam  alturaMozaico=10'd16;

//Semana
localparam textoSemana=10'd288;

//Cronometro
localparam textoCronometro= 10'd24 ;

//Dia
localparam textoDia=10'd559;

//Instrucciones
localparam textoInstrucciones=10'd24;
localparam ARInstrucciones=10'd96;
localparam ABInstrucciones=10'd112;

//Posicion Instrucciones
localparam posicionInstrucciones=10'd240;
localparam posicionPush1=10'd376;
localparam posicionPush2=10'd512;

//Parametros Cronometro

localparam cronoHoras=10'd104;
localparam cronoMinutos=10'd128;
localparam cronoSegundos=10'd152;


//Parametros Reloj
//Segundos
//Limites en el eje x
localparam IsegundosD=10'd459;
localparam DsegundosD=10'd523;
localparam IsegundosU=10'd524;
localparam DsegundosU=10'd587;
//Limites en el eje y
localparam ARsegundos=10'd197; //Solo 2 porque siempre van a estar a la par
localparam ABsegundos=10'd296;



//Minutos
//Limites en el eje x
localparam IminutosD=10'd260;
localparam DminutosD=10'd323;
localparam IminutosU=10'd324;
localparam DminutosU=10'd388;
//Limites en el eje y
localparam ARminutos=10'd197; //Solo 2 porque siempre van a estar a la par
localparam ABminutos=10'd295;

//horas
//Limites en el eje x
localparam IhorasD=10'd58;
localparam DhorasD=10'd122;//Tiene que ser mas grande para dejar el espacion en medio
localparam IhorasU=10'd123;
localparam DhorasU=10'd182;
//Limites en el eje y
localparam ARhoras=10'd197; //Solo 2 porque siempre van a estar a la par
localparam ABhoras=10'd296;

//Fecha
//Limites en el eje x
localparam IfechaD=10'd576;
localparam DfechaD=10'd583;
localparam IfechaU=10'd585;
localparam DfechaU=10'd591;
//Limites en el eje y
localparam ARfecha=10'd450; //Solo 2 porque siempre van a estar a la par
localparam ABfecha=10'd461;


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
localparam IdiaD=10'd591;
localparam DdiaD=10'd598;
localparam IdiaU=10'd599;
localparam DdiaU=10'd606;
//Limites en el eje y
localparam ARdia=10'd434; //Solo 2 porque siempre van a estar a la par
localparam ABdia=10'd446;



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

//Logica para impresion centrada de los numeros Grandes

always @(posedge clk)

 if (pixelx< 10'd212) begin
contadorx<=(pixelx[5:0] + 6'd5);
end

else if (pixelx< 10'd412) begin
contadorx<=(pixelx[5:0] - 6'd4);
end

else if (pixelx< 10'd640) begin
contadorx<=(pixelx[5:0] - 6'd12);
end

else begin
contadorx<=(pixelx[5:0] + 6'd5); //Evitar warning
end


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
        memInt<=1'd1;
        graficos<=1'd1;
        dp<=1'd1; end

    else if ((pixelx >= IsegundosU) && (pixelx<=DsegundosU) && (pixely >= ARsegundos) && (pixely<=ABsegundos))begin
        char_addr <= SegundosU; //direccion de lo que se va a imprimir
        color_addr<=4'd2;// Color de lo que se va a imprimir
        font_size<=1;
        memInt<=1'd1;
        graficos<=1'd1;
        dp<=1'd1;end//Tamaño de fuente

//Minutos
  else if ((pixelx >= IminutosD) && (pixelx<=DminutosD) && (pixely >= ARminutos) && (pixely<=ABminutos))begin
      char_addr <= minutosD; //direccion de lo que se va a imprimir
      color_addr<=4'd2;// Color de lo que se va a imprimir
      font_size<=2'd1;
      memInt<=1'd1;
      graficos<=1'd1;
      dp<=1'd1;end//Tamaño de fuente

  else if ((pixelx >= IminutosU) && (pixelx<=DminutosU) && (pixely >= ARminutos) && (pixely<=ABminutos))begin
      char_addr <= minutosU; //direccion de lo que se va a imprimir
      color_addr<=4'd2;// Color de lo que se va a imprimir
      font_size<=2'd1;
      memInt<=1'd1;
      graficos<=1'd1;
      dp<=1'd1;end//Tamaño de fuente

//Horas
 else if ((pixelx >= IhorasD) && (pixelx<=DhorasD) && (pixely >= ARhoras) && (pixely<=ABhoras))begin
    char_addr <= horasD; //direccion de lo que se va a imprimir
    color_addr<=4'd2;// Color de lo que se va a imprimir
    font_size<=2'd1;
    memInt<=1'd1;
    graficos<=1'd1;
    dp<=1'd1; end//Tamaño de fuente



    else if ((pixelx >= IhorasU) && (pixelx<=DhorasU) && (pixely >= ARhoras) && (pixely<=ABhoras))begin
        char_addr <= horasU;//direccion de lo que se va a imprimir
        color_addr<=4'd2;// Color de lo que se va a imprimir
        font_size<=2'd0;
        memInt<=1'd1;
        graficos<=1'd1;
        dp<=1'd1;end//Tamaño de fuente



///////////Cronometro
//Horas Crono
 else if ((pixelx >= cronoHoras) && (pixelx<cronoHoras+cambioMozaico) && (pixely >= ARmes) & (pixely<=ABmes))begin
     char_addr <= horasDT; //direccion de lo que se va a imprimir
     color_addr<=4'd2;// Color de lo que se va a imprimir
     font_size<=2'd1;//Tamaño de fuente
     memInt<=1'd0;
     graficos<=1'd0;
     dp<=1'd1; end

 else if ((pixelx >= cronoHoras+cambioMozaico) && (pixelx<cronoHoras+ 2*cambioMozaico) && (pixely >= ARmes) && (pixely<=ABmes))begin
     char_addr <= horasUT; //direccion de lo que se va a imprimir
     color_addr<=4'd2;// Color de lo que se va a imprimir
     font_size<=1;
     memInt<=1'd0;
     graficos<=1'd0;
     dp<=1'd1;end//Tamaño de fuente

//Minutos Crono
else if ((pixelx >= cronoMinutos) && (pixelx<cronoMinutos+cambioMozaico) && (pixely >= ARmes) && (pixely<=ABmes))begin
   char_addr <= minutosDT; //direccion de lo que se va a imprimir
   color_addr<=4'd2;// Color de lo que se va a imprimir
   font_size<=2'd1;
   memInt<=1'd0;
   graficos<=1'd0;
   dp<=1'd1;end//Tamaño de fuente

else if ((pixelx >= cronoMinutos+cambioMozaico ) && (pixelx<cronoMinutos+ 2*cambioMozaico) && (pixely >= ARmes) && (pixely<=ABmes))begin
   char_addr <= minutosUT; //direccion de lo que se va a imprimir
   color_addr<=4'd2;// Color de lo que se va a imprimir
   font_size<=2'd1;
   memInt<=1'd0;
   graficos<=1'd0;
   dp<=1'd1;end//Tamaño de fuente

//Segundos crono
else if ((pixelx >= cronoSegundos ) && (pixelx<cronoSegundos+cambioMozaico) && (pixely >= ARmes) && (pixely<=ABmes))begin
 char_addr <= SegundosDT; //direccion de lo que se va a imprimir
 color_addr<=4'd2;// Color de lo que se va a imprimir
 font_size<=2'd1;
 memInt<=1'd0;
 graficos<=1'd0;
 dp<=1'd1; end//Tamaño de fuente



 else if ((pixelx >= cronoSegundos+cambioMozaico ) && (pixelx<cronoSegundos+ 2*cambioMozaico) && (pixely >= ARmes) && (pixely<=ABmes))begin
     char_addr <= SegundosUT;//direccion de lo que se va a imprimir
     color_addr<=4'd2;// Color de lo que se va a imprimir
     font_size<=2'd1;
     memInt<=1'd0;
     graficos<=1'd0;
     dp<=1'd1;end//Tamaño de fuente

    /////////////////////////////---------------------------------------------
    /////////////////////-------------


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
        else if ((pixelx >= textoSemana) && (pixelx<textoSemana+cambioMozaico) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
            char_addr <= 7'h53;//direccion de lo que se va a imprimir
            color_addr<=4'd2;// Color de lo que se va a imprimir
            font_size<=2'd1;
            graficos<=1'd0;
            memInt<=1'd0;
            dp<=1'd1;end//Tamaño de fuente


            //E
            else if ((pixelx >= textoSemana+cambioMozaico) && (pixelx<textoSemana+ 2*cambioMozaico) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
                char_addr <= 7'h45;//direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color de lo que se va a imprimir
                font_size<=2'd1;
                graficos<=1'd0;
                memInt<=1'd0;
                dp<=1'd1;end

                //M
          else if ((pixelx >= textoSemana+ 2*cambioMozaico) && (pixelx< textoSemana+ 3*cambioMozaico) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
                char_addr <= 7'h4d;//direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color de lo que se va a imprimir
                font_size<=2'd1;
                graficos<=1'd0;
                memInt<=1'd0;
                dp<=1'd1;end

                //A
          else if ((pixelx >= textoSemana+ 3*cambioMozaico) && (pixelx< textoSemana+ 4*cambioMozaico) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
                char_addr <= 7'h41;//direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color de lo que se va a imprimir
                font_size<=2'd1;
                graficos<=1'd0;
                memInt<=1'd0;
                dp<=1'd1;end


                //N
          else if ((pixelx >= textoSemana+ 4*cambioMozaico ) && (pixelx< textoSemana+ 5*cambioMozaico) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
                char_addr <= 7'h4e;//direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color de lo que se va a imprimir
                font_size<=2'd1;
                graficos<=1'd0;
                memInt<=1'd0;
                dp<=1'd1;end


                //A
          else if ((pixelx >=textoSemana+ 5*cambioMozaico) && (pixelx< textoSemana+ 6*cambioMozaico) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
                char_addr <= 7'h41;//direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color de lo que se va a imprimir
                font_size<=2'd1;
                graficos<=1'd0;
                memInt<=1'd0;
                dp<=1'd1;end



                //Texto Cronometro
                //C
                else if ((pixelx >= textoCronometro) && (pixelx<textoCronometro+cambioMozaico) && (pixely >= ARano) && (pixely<=ABano))begin
                    char_addr <= 7'h43;//direccion de lo que se va a imprimir
                    color_addr<=4'd2;// Color de lo que se va a imprimir
                    font_size<=2'd1;
                    graficos<=1'd0;
                    memInt<=1'd0;
                    dp<=1'd1;end//Tamaño de fuente


                    //R
                    else if ((pixelx >= textoCronometro+cambioMozaico) && (pixelx<textoCronometro+ 2*cambioMozaico) && (pixely >= ARano) && (pixely<=ABano))begin
                        char_addr <= 7'h52;//direccion de lo que se va a imprimir
                        color_addr<=4'd2;// Color de lo que se va a imprimir
                        font_size<=2'd1;
                        graficos<=1'd0;
                        memInt<=1'd0;
                        dp<=1'd1;end

                        //o
                  else if ((pixelx >= textoCronometro+ 2*cambioMozaico) && (pixelx< textoCronometro+ 3*cambioMozaico) && (pixely >= ARano) && (pixely<=ABano))begin
                        char_addr <= 7'h4f;//direccion de lo que se va a imprimir
                        color_addr<=4'd2;// Color de lo que se va a imprimir
                        font_size<=2'd1;
                        graficos<=1'd0;
                        memInt<=1'd0;
                        dp<=1'd1;end

                        //N
                  else if ((pixelx >= textoCronometro+ 3*cambioMozaico) && (pixelx< textoCronometro+ 4*cambioMozaico) && (pixely >= ARano) && (pixely<=ABano))begin
                        char_addr <= 7'h4e;//direccion de lo que se va a imprimir
                        color_addr<=4'd2;// Color de lo que se va a imprimir
                        font_size<=2'd1;
                        graficos<=1'd0;
                        memInt<=1'd0;
                        dp<=1'd1;end


                        //o
                  else if ((pixelx >= textoCronometro+ 4*cambioMozaico ) && (pixelx< textoCronometro+ 5*cambioMozaico) && (pixely >= ARano) && (pixely<=ABano))begin
                        char_addr <= 7'h4f;//direccion de lo que se va a imprimir
                        color_addr<=4'd2;// Color de lo que se va a imprimir
                        font_size<=2'd1;
                        graficos<=1'd0;
                        memInt<=1'd0;
                        dp<=1'd1;end


                        //m
                  else if ((pixelx >=textoCronometro+ 5*cambioMozaico) && (pixelx< textoCronometro+ 6*cambioMozaico) && (pixely >= ARano) && (pixely<=ABano))begin
                        char_addr <= 7'h4d;//direccion de lo que se va a imprimir
                        color_addr<=4'd2;// Color de lo que se va a imprimir
                        font_size<=2'd1;
                        graficos<=1'd0;
                        memInt<=1'd0;
                        dp<=1'd1;end

                        //e
                  else if ((pixelx >=textoCronometro+ 6*cambioMozaico) && (pixelx< textoCronometro+ 7*cambioMozaico) && (pixely >= ARano) && (pixely<=ABano))begin
                        char_addr <= 7'h45;//direccion de lo que se va a imprimir
                        color_addr<=4'd2;// Color de lo que se va a imprimir
                        font_size<=2'd1;
                        graficos<=1'd0;
                        memInt<=1'd0;
                        dp<=1'd1;end

                        //t
                  else if ((pixelx >=textoCronometro+ 7*cambioMozaico) && (pixelx< textoCronometro+ 8*cambioMozaico) && (pixely >= ARano) && (pixely<=ABano))begin
                        char_addr <= 7'h54;//direccion de lo que se va a imprimir
                        color_addr<=4'd2;// Color de lo que se va a imprimir
                        font_size<=2'd1;
                        graficos<=1'd0;
                        memInt<=1'd0;
                        dp<=1'd1;end

                        //r
                  else if ((pixelx >=textoCronometro+ 8*cambioMozaico) && (pixelx< textoCronometro+ 9*cambioMozaico) && (pixely >= ARano) && (pixely<=ABano))begin
                        char_addr <= 7'h52;//direccion de lo que se va a imprimir
                        color_addr<=4'd2;// Color de lo que se va a imprimir
                        font_size<=2'd1;
                        graficos<=1'd0;
                        memInt<=1'd0;
                        dp<=1'd1;end

                        //o
                  else if ((pixelx >=textoCronometro+ 9*cambioMozaico) && (pixelx< textoCronometro+ 10*cambioMozaico) && (pixely >= ARano) && (pixely<=ABano))begin
                        char_addr <= 7'h4f;//direccion de lo que se va a imprimir
                        color_addr<=4'd2;// Color de lo que se va a imprimir
                        font_size<=2'd1;
                        graficos<=1'd0;
                        memInt<=1'd0;
                        dp<=1'd1;end



                        //Texto dia


                        //D
                        else if ((pixelx >= textoDia) && (pixelx<textoDia+cambioMozaico) && (pixely >= ARdia) && (pixely<=ABdia))begin
                            char_addr <= 7'h44;//direccion de lo que se va a imprimir
                            color_addr<=4'd2;// Color de lo que se va a imprimir
                            font_size<=2'd1;
                            graficos<=1'd0;
                            memInt<=1'd0;
                            dp<=1'd1;end//Tamaño de fuente


                            //I
                            else if ((pixelx >= textoDia+cambioMozaico) && (pixelx<textoDia+ 2*cambioMozaico) && (pixely >= ARdia) && (pixely<=ABdia))begin
                                char_addr <= 7'h49;//direccion de lo que se va a imprimir
                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                font_size<=2'd1;
                                graficos<=1'd0;
                                memInt<=1'd0;
                                dp<=1'd1;end

                                //A
                          else if ((pixelx >= textoDia+ 2*cambioMozaico) && (pixelx< textoDia+ 3*cambioMozaico) && (pixely >= ARdia) && (pixely<=ABdia))begin
                                char_addr <= 7'h41;//direccion de lo que se va a imprimir
                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                font_size<=2'd1;
                                graficos<=1'd0;
                                memInt<=1'd0;
                                dp<=1'd1;end




                                //Texto Instrucciones
                                //S
                                else if ((pixelx >= textoInstrucciones) && (pixelx<textoInstrucciones+cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                    char_addr <= 7'h53;//direccion de lo que se va a imprimir
                                    color_addr<=4'd2;// Color de lo que se va a imprimir
                                    font_size<=2'd1;
                                    graficos<=1'd0;
                                    memInt<=1'd0;
                                    dp<=1'd1;end//Tamaño de fuente


                                    //W
                                    else if ((pixelx >= textoInstrucciones+cambioMozaico) && (pixelx<textoInstrucciones+ 2*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                        char_addr <= 7'h57;//direccion de lo que se va a imprimir
                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                        font_size<=2'd1;
                                        graficos<=1'd0;
                                        memInt<=1'd0;
                                        dp<=1'd1;end

                                        //3
                                  else if ((pixelx >= textoInstrucciones+ 2*cambioMozaico) && (pixelx< textoInstrucciones+ 3*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                        char_addr <= 7'h33;//direccion de lo que se va a imprimir
                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                        font_size<=2'd1;
                                        graficos<=1'd0;
                                        memInt<=1'd0;
                                        dp<=1'd1;end

                                        //ESPACIO
                                  else if ((pixelx >= textoInstrucciones+ 3*cambioMozaico) && (pixelx< textoInstrucciones+ 4*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                        char_addr <= 7'h00;//direccion de lo que se va a imprimir
                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                        font_size<=2'd1;
                                        graficos<=1'd0;
                                        memInt<=1'd0;
                                        dp<=1'd1;end

                                        //I
                                  else if ((pixelx >= textoInstrucciones+ 4*cambioMozaico) && (pixelx< textoInstrucciones+ 5*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                        char_addr <= 7'h49;//direccion de lo que se va a imprimir
                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                        font_size<=2'd1;
                                        graficos<=1'd0;
                                        memInt<=1'd0;
                                        dp<=1'd1;end


                                        //N
                                  else if ((pixelx >= textoInstrucciones+ 5*cambioMozaico ) && (pixelx< textoInstrucciones+ 6*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                        char_addr <= 7'h4e;//direccion de lo que se va a imprimir
                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                        font_size<=2'd1;
                                        graficos<=1'd0;
                                        memInt<=1'd0;
                                        dp<=1'd1;end


                                        //T
                                  else if ((pixelx >=textoInstrucciones+ 6*cambioMozaico) && (pixelx< textoInstrucciones+ 7*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                        char_addr <= 7'h54;//direccion de lo que se va a imprimir
                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                        font_size<=2'd1;
                                        graficos<=1'd0;
                                        memInt<=1'd0;
                                        dp<=1'd1;end

                                        //R
                                  else if ((pixelx >=textoInstrucciones+ 7*cambioMozaico) && (pixelx< textoInstrucciones+ 8*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                        char_addr <= 7'h52;//direccion de lo que se va a imprimir
                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                        font_size<=2'd1;
                                        graficos<=1'd0;
                                        memInt<=1'd0;
                                        dp<=1'd1;end

                                        //U
                                  else if ((pixelx >=textoInstrucciones+ 8*cambioMozaico) && (pixelx< textoInstrucciones+ 9*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                        char_addr <= 7'h55;//direccion de lo que se va a imprimir
                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                        font_size<=2'd1;
                                        graficos<=1'd0;
                                        memInt<=1'd0;
                                        dp<=1'd1;end

                                        //C
                                  else if ((pixelx >=textoInstrucciones+ 9*cambioMozaico) && (pixelx< textoInstrucciones+ 10*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                        char_addr <= 7'h43;//direccion de lo que se va a imprimir
                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                        font_size<=2'd1;
                                        graficos<=1'd0;
                                        memInt<=1'd0;
                                        dp<=1'd1;end

                                        //C
                                  else if ((pixelx >=textoInstrucciones+ 10*cambioMozaico) && (pixelx< textoInstrucciones+ 11*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                        char_addr <= 7'h43;//direccion de lo que se va a imprimir
                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                        font_size<=2'd1;
                                        graficos<=1'd0;
                                        memInt<=1'd0;
                                        dp<=1'd1;end


                                        //I
                                  else if ((pixelx >=textoInstrucciones+ 11*cambioMozaico) && (pixelx< textoInstrucciones+ 12*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                        char_addr <= 7'h49;//direccion de lo que se va a imprimir
                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                        font_size<=2'd1;
                                        graficos<=1'd0;
                                        memInt<=1'd0;
                                        dp<=1'd1;end



                                        //O
                                  else if ((pixelx >=textoInstrucciones+ 12*cambioMozaico) && (pixelx< textoInstrucciones+ 13*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                        char_addr <= 7'h4f;//direccion de lo que se va a imprimir
                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                        font_size<=2'd1;
                                        graficos<=1'd0;
                                        memInt<=1'd0;
                                        dp<=1'd1;end


                                        //N
                                  else if ((pixelx >=textoInstrucciones+ 13*cambioMozaico) && (pixelx< textoInstrucciones+ 14*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                        char_addr <= 7'h4e;//direccion de lo que se va a imprimir
                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                        font_size<=2'd1;
                                        graficos<=1'd0;
                                        memInt<=1'd0;
                                        dp<=1'd1;end



                                        //E
                                  else if ((pixelx >=textoInstrucciones+ 14*cambioMozaico) && (pixelx< textoInstrucciones+ 15*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                        char_addr <= 7'h45;//direccion de lo que se va a imprimir
                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                        font_size<=2'd1;
                                        graficos<=1'd0;
                                        memInt<=1'd0;
                                        dp<=1'd1;end


                                        //S
                                  else if ((pixelx >=textoInstrucciones+ 15*cambioMozaico) && (pixelx< textoInstrucciones+ 16*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                        char_addr <= 7'h53;//direccion de lo que se va a imprimir
                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                        font_size<=2'd1;
                                        graficos<=1'd0;
                                        memInt<=1'd0;
                                        dp<=1'd1;end



                                        ////Las Instrucciones

                                          ////RESET
                                                //S
                                                else if ((instrucciones==1) && (pixelx >= posicionInstrucciones) && (pixelx<posicionInstrucciones+cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                    char_addr <= 7'h53;//direccion de lo que se va a imprimir
                                                    color_addr<=4'd2;// Color de lo que se va a imprimir
                                                    font_size<=2'd1;
                                                    graficos<=1'd0;
                                                    memInt<=1'd0;
                                                    dp<=1'd1;end//Tamaño de fuente


                                                    //W
                                                    else if ((instrucciones==1) && (pixelx >= posicionInstrucciones+cambioMozaico) && (pixelx<posicionInstrucciones+ 2*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                        char_addr <= 7'h57;//direccion de lo que se va a imprimir
                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                        font_size<=2'd1;
                                                        graficos<=1'd0;
                                                        memInt<=1'd0;
                                                        dp<=1'd1;end

                                                        //0
                                                  else if ((instrucciones==1) && (pixelx >= posicionInstrucciones+ 2*cambioMozaico) && (pixelx< posicionInstrucciones+ 3*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                        char_addr <= 7'h30;//direccion de lo que se va a imprimir
                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                        font_size<=2'd1;
                                                        graficos<=1'd0;
                                                        memInt<=1'd0;
                                                        dp<=1'd1;end

                                                        //ESPACIO
                                                  else if ((instrucciones==1) && (pixelx >= posicionInstrucciones+ 3*cambioMozaico) && (pixelx< posicionInstrucciones+ 4*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                        char_addr <= 7'h00;//direccion de lo que se va a imprimir
                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                        font_size<=2'd1;
                                                        graficos<=1'd0;
                                                        memInt<=1'd0;
                                                        dp<=1'd1;end

                                                        //R
                                                  else if ((instrucciones==1) && (pixelx >= posicionInstrucciones+ 4*cambioMozaico) && (pixelx< posicionInstrucciones+ 5*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                        char_addr <= 7'h52;//direccion de lo que se va a imprimir
                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                        font_size<=2'd1;
                                                        graficos<=1'd0;
                                                        memInt<=1'd0;
                                                        dp<=1'd1;end


                                                        //E
                                                  else if ((instrucciones==1) && (pixelx >= posicionInstrucciones+ 5*cambioMozaico ) && (pixelx< posicionInstrucciones+ 6*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                        char_addr <= 7'h45;//direccion de lo que se va a imprimir
                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                        font_size<=2'd1;
                                                        graficos<=1'd0;
                                                        memInt<=1'd0;
                                                        dp<=1'd1;end


                                                        //S
                                                  else if ((instrucciones==1) && (pixelx >=posicionInstrucciones+ 6*cambioMozaico) && (pixelx< posicionInstrucciones+ 7*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                        char_addr <= 7'h53;//direccion de lo que se va a imprimir
                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                        font_size<=2'd1;
                                                        graficos<=1'd0;
                                                        memInt<=1'd0;
                                                        dp<=1'd1;end

                                                        //E
                                                  else if ((instrucciones==1) && (pixelx >=posicionInstrucciones+ 7*cambioMozaico) && (pixelx< posicionInstrucciones+ 8*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                        char_addr <= 7'h45;//direccion de lo que se va a imprimir
                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                        font_size<=2'd1;
                                                        graficos<=1'd0;
                                                        memInt<=1'd0;
                                                        dp<=1'd1;end

                                                        //T
                                                  else if ((instrucciones==1) && (pixelx >=posicionInstrucciones+ 8*cambioMozaico) && (pixelx< posicionInstrucciones+ 9*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                        char_addr <= 7'h54;//direccion de lo que se va a imprimir
                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                        font_size<=2'd1;
                                                        graficos<=1'd0;
                                                        memInt<=1'd0;
                                                        dp<=1'd1;end



                                                        ///////////
                                                        ///////////

                                                        //ESCRIBIR

                                                        //S
                                                        else if ((instrucciones==1) && (pixelx >= posicionInstrucciones) && (pixelx<posicionInstrucciones+cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                            char_addr <= 7'h53;//direccion de lo que se va a imprimir
                                                            color_addr<=4'd2;// Color de lo que se va a imprimir
                                                            font_size<=2'd1;
                                                            graficos<=1'd0;
                                                            memInt<=1'd0;
                                                            dp<=1'd1;end//Tamaño de fuente


                                                            //W
                                                            else if ((instrucciones==1) && (pixelx >= posicionInstrucciones+cambioMozaico) && (pixelx<posicionInstrucciones+ 2*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                char_addr <= 7'h57;//direccion de lo que se va a imprimir
                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                font_size<=2'd1;
                                                                graficos<=1'd0;
                                                                memInt<=1'd0;
                                                                dp<=1'd1;end

                                                                //1
                                                          else if ((instrucciones==1) && (pixelx >= posicionInstrucciones+ 2*cambioMozaico) && (pixelx< posicionInstrucciones+ 3*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                char_addr <= 7'h31;//direccion de lo que se va a imprimir
                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                font_size<=2'd1;
                                                                graficos<=1'd0;
                                                                memInt<=1'd0;
                                                                dp<=1'd1;end

                                                                //ESPACIO
                                                          else if ((instrucciones==1) && (pixelx >= posicionInstrucciones+ 3*cambioMozaico) && (pixelx< posicionInstrucciones+ 4*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                char_addr <= 7'h00;//direccion de lo que se va a imprimir
                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                font_size<=2'd1;
                                                                graficos<=1'd0;
                                                                memInt<=1'd0;
                                                                dp<=1'd1;end

                                                                //E
                                                          else if ((instrucciones==1) && (pixelx >= posicionInstrucciones+ 4*cambioMozaico) && (pixelx< posicionInstrucciones+ 5*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                char_addr <= 7'h45;//direccion de lo que se va a imprimir
                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                font_size<=2'd1;
                                                                graficos<=1'd0;
                                                                memInt<=1'd0;
                                                                dp<=1'd1;end


                                                                //S
                                                          else if ((instrucciones==1) && (pixelx >= posicionInstrucciones+ 5*cambioMozaico ) && (pixelx< posicionInstrucciones+ 6*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                char_addr <= 7'h53;//direccion de lo que se va a imprimir
                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                font_size<=2'd1;
                                                                graficos<=1'd0;
                                                                memInt<=1'd0;
                                                                dp<=1'd1;end


                                                                //C
                                                          else if ((instrucciones==1) && (pixelx >=posicionInstrucciones+ 6*cambioMozaico) && (pixelx< posicionInstrucciones+ 7*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                char_addr <= 7'h43;//direccion de lo que se va a imprimir
                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                font_size<=2'd1;
                                                                graficos<=1'd0;
                                                                memInt<=1'd0;
                                                                dp<=1'd1;end

                                                                //R
                                                          else if ((instrucciones==1) && (pixelx >=posicionInstrucciones+ 7*cambioMozaico) && (pixelx< posicionInstrucciones+ 8*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                char_addr <= 7'h52;//direccion de lo que se va a imprimir
                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                font_size<=2'd1;
                                                                graficos<=1'd0;
                                                                memInt<=1'd0;
                                                                dp<=1'd1;end

                                                                //I
                                                          else if ((instrucciones==1) && (pixelx >=posicionInstrucciones+ 8*cambioMozaico) && (pixelx< posicionInstrucciones+ 9*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                char_addr <= 7'h49;//direccion de lo que se va a imprimir
                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                font_size<=2'd1;
                                                                graficos<=1'd0;
                                                                memInt<=1'd0;
                                                                dp<=1'd1;end

                                                                //B
                                                          else if ((instrucciones==1) && (pixelx >=posicionInstrucciones+ 9*cambioMozaico) && (pixelx< posicionInstrucciones+ 10*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                char_addr <= 7'h42;//direccion de lo que se va a imprimir
                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                font_size<=2'd1;
                                                                graficos<=1'd0;
                                                                memInt<=1'd0;
                                                                dp<=1'd1;end

                                                                //I
                                                          else if ((instrucciones==1) && (pixelx >=posicionInstrucciones+ 10*cambioMozaico) && (pixelx< posicionInstrucciones+ 11*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                char_addr <= 7'h49;//direccion de lo que se va a imprimir
                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                font_size<=2'd1;
                                                                graficos<=1'd0;
                                                                memInt<=1'd0;
                                                                dp<=1'd1;end

                                                                //R
                                                          else if ((instrucciones==1) && (pixelx >=posicionInstrucciones+ 11*cambioMozaico) && (pixelx< posicionInstrucciones+ 12*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                char_addr <= 7'h52;//direccion de lo que se va a imprimir
                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                font_size<=2'd1;
                                                                graficos<=1'd0;
                                                                memInt<=1'd0;
                                                                dp<=1'd1;end


                                                                //PROGRAMAR CRONOMETRO

                                                                //S
                                                                else if ((instrucciones==1) && (pixelx >= posicionInstrucciones) && (pixelx<posicionInstrucciones+cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                    char_addr <= 7'h53;//direccion de lo que se va a imprimir
                                                                    color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                    font_size<=2'd1;
                                                                    graficos<=1'd0;
                                                                    memInt<=1'd0;
                                                                    dp<=1'd1;end//Tamaño de fuente


                                                                    //W
                                                                    else if ((instrucciones==1) && (pixelx >= posicionInstrucciones+cambioMozaico) && (pixelx<posicionInstrucciones+ 2*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                        char_addr <= 7'h57;//direccion de lo que se va a imprimir
                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                        font_size<=2'd1;
                                                                        graficos<=1'd0;
                                                                        memInt<=1'd0;
                                                                        dp<=1'd1;end

                                                                        //2
                                                                  else if ((instrucciones==1) && (pixelx >= posicionInstrucciones+ 2*cambioMozaico) && (pixelx< posicionInstrucciones+ 3*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                        char_addr <= 7'h32;//direccion de lo que se va a imprimir
                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                        font_size<=2'd1;
                                                                        graficos<=1'd0;
                                                                        memInt<=1'd0;
                                                                        dp<=1'd1;end

                                                                        //ESPACIO
                                                                  else if ((instrucciones==1) && (pixelx >= posicionInstrucciones+ 3*cambioMozaico) && (pixelx< posicionInstrucciones+ 4*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                        char_addr <= 7'h00;//direccion de lo que se va a imprimir
                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                        font_size<=2'd1;
                                                                        graficos<=1'd0;
                                                                        memInt<=1'd0;
                                                                        dp<=1'd1;end

                                                                        //P
                                                                  else if ((instrucciones==1) && (pixelx >= posicionInstrucciones+ 4*cambioMozaico) && (pixelx< posicionInstrucciones+ 5*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                        char_addr <= 7'h50;//direccion de lo que se va a imprimir
                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                        font_size<=2'd1;
                                                                        graficos<=1'd0;
                                                                        memInt<=1'd0;
                                                                        dp<=1'd1;end


                                                                        //R
                                                                  else if ((instrucciones==1) && (pixelx >= posicionInstrucciones+ 5*cambioMozaico ) && (pixelx< posicionInstrucciones+ 6*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                        char_addr <= 7'h52;//direccion de lo que se va a imprimir
                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                        font_size<=2'd1;
                                                                        graficos<=1'd0;
                                                                        memInt<=1'd0;
                                                                        dp<=1'd1;end


                                                                        //ESPACIO
                                                                  else if ((instrucciones==1) && (pixelx >=posicionInstrucciones+ 6*cambioMozaico) && (pixelx< posicionInstrucciones+ 7*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                        char_addr <= 7'h00;//direccion de lo que se va a imprimir
                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                        font_size<=2'd1;
                                                                        graficos<=1'd0;
                                                                        memInt<=1'd0;
                                                                        dp<=1'd1;end

                                                                        //C
                                                                  else if ((instrucciones==1) && (pixelx >=posicionInstrucciones+ 7*cambioMozaico) && (pixelx< posicionInstrucciones+ 8*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                        char_addr <= 7'h43;//direccion de lo que se va a imprimir
                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                        font_size<=2'd1;
                                                                        graficos<=1'd0;
                                                                        memInt<=1'd0;
                                                                        dp<=1'd1;end

                                                                        //R
                                                                  else if ((instrucciones==1) && (pixelx >=posicionInstrucciones+ 8*cambioMozaico) && (pixelx< posicionInstrucciones+ 9*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                        char_addr <= 7'h52;//direccion de lo que se va a imprimir
                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                        font_size<=2'd1;
                                                                        graficos<=1'd0;
                                                                        memInt<=1'd0;
                                                                        dp<=1'd1;end

                                                                        //O
                                                                  else if ((instrucciones==1) && (pixelx >=posicionInstrucciones+ 9*cambioMozaico) && (pixelx< posicionInstrucciones+ 10*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                        char_addr <= 7'h4f;//direccion de lo que se va a imprimir
                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                        font_size<=2'd1;
                                                                        graficos<=1'd0;
                                                                        memInt<=1'd0;
                                                                        dp<=1'd1;end

                                                                        //N
                                                                  else if ((instrucciones==1) && (pixelx >=posicionInstrucciones+ 10*cambioMozaico) && (pixelx< posicionInstrucciones+ 11*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                        char_addr <= 7'h4e;//direccion de lo que se va a imprimir
                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                        font_size<=2'd1;
                                                                        graficos<=1'd0;
                                                                        memInt<=1'd0;
                                                                        dp<=1'd1;end

                                                                        //O
                                                                  else if ((instrucciones==1) && (pixelx >=posicionInstrucciones+ 11*cambioMozaico) && (pixelx< posicionInstrucciones+ 12*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                        char_addr <= 7'h4f;//direccion de lo que se va a imprimir
                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                        font_size<=2'd1;
                                                                        graficos<=1'd0;
                                                                        memInt<=1'd0;
                                                                        dp<=1'd1;end


                                                                            //Primer grupo de PUSH
                                                                                                ////BT ARRIBA
                                                                                                      //B
                                                                                                      else if ((instrucciones==1) && (pixelx >= posicionPush1) && (pixelx<posicionPush1+cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                          char_addr <= 7'h42;//direccion de lo que se va a imprimir
                                                                                                          color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                          font_size<=2'd1;
                                                                                                          graficos<=1'd0;
                                                                                                          memInt<=1'd0;
                                                                                                          dp<=1'd1;end//Tamaño de fuente


                                                                                                          //T
                                                                                                          else if ((instrucciones==1) && (pixelx >= posicionPush1+cambioMozaico) && (pixelx<posicionPush1+ 2*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                              char_addr <= 7'h54;//direccion de lo que se va a imprimir
                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                              font_size<=2'd1;
                                                                                                              graficos<=1'd0;
                                                                                                              memInt<=1'd0;
                                                                                                              dp<=1'd1;end

                                                                                                              //ARRIBA
                                                                                                        else if ((instrucciones==1) && (pixelx >= posicionPush1+ 2*cambioMozaico) && (pixelx< posicionPush1+ 3*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                              char_addr <= 7'h1e;//direccion de lo que se va a imprimir
                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                              font_size<=2'd1;
                                                                                                              graficos<=1'd0;
                                                                                                              memInt<=1'd0;
                                                                                                              dp<=1'd1;end

                                                                                                              //ESPACIO
                                                                                                        else if ((instrucciones==1) && (pixelx >= posicionPush1+ 3*cambioMozaico) && (pixelx< posicionPush1+ 4*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                              char_addr <= 7'h00;//direccion de lo que se va a imprimir
                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                              font_size<=2'd1;
                                                                                                              graficos<=1'd0;
                                                                                                              memInt<=1'd0;
                                                                                                              dp<=1'd1;end

                                                                                                              //S
                                                                                                        else if ((instrucciones==1) && (pixelx >= posicionPush1+ 4*cambioMozaico) && (pixelx< posicionPush1+ 5*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                              char_addr <= 7'h53;//direccion de lo que se va a imprimir
                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                              font_size<=2'd1;
                                                                                                              graficos<=1'd0;
                                                                                                              memInt<=1'd0;
                                                                                                              dp<=1'd1;end


                                                                                                              //U
                                                                                                        else if ((instrucciones==1) && (pixelx >= posicionPush1+ 5*cambioMozaico ) && (pixelx< posicionPush1+ 6*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                              char_addr <= 7'h55;//direccion de lo que se va a imprimir
                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                              font_size<=2'd1;
                                                                                                              graficos<=1'd0;
                                                                                                              memInt<=1'd0;
                                                                                                              dp<=1'd1;end


                                                                                                              //M
                                                                                                        else if ((instrucciones==1) && (pixelx >=posicionPush1+ 6*cambioMozaico) && (pixelx< posicionPush1+ 7*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                              char_addr <= 7'h4d;//direccion de lo que se va a imprimir
                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                              font_size<=2'd1;
                                                                                                              graficos<=1'd0;
                                                                                                              memInt<=1'd0;
                                                                                                              dp<=1'd1;end

                                                                                                              //A
                                                                                                        else if ((instrucciones==1) && (pixelx >=posicionPush1+ 7*cambioMozaico) && (pixelx< posicionPush1+ 8*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                              char_addr <= 7'h41;//direccion de lo que se va a imprimir
                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                              font_size<=2'd1;
                                                                                                              graficos<=1'd0;
                                                                                                              memInt<=1'd0;
                                                                                                              dp<=1'd1;end

                                                                                                              //ESPACIO
                                                                                                        else if ((instrucciones==1) && (pixelx >=posicionPush1+ 8*cambioMozaico) && (pixelx< posicionPush1+ 9*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                              char_addr <= 7'h00;//direccion de lo que se va a imprimir
                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                              font_size<=2'd1;
                                                                                                              graficos<=1'd0;
                                                                                                              memInt<=1'd0;
                                                                                                              dp<=1'd1;end

                                                                                                              //1
                                                                                                        else if ((instrucciones==1) && (pixelx >=posicionPush1+ 9*cambioMozaico) && (pixelx< posicionPush1+ 10*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                              char_addr <= 7'h31;//direccion de lo que se va a imprimir
                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                              font_size<=2'd1;
                                                                                                              graficos<=1'd0;
                                                                                                              memInt<=1'd0;
                                                                                                              dp<=1'd1;end



                                                                                                              ///////////
                                                                                                              ///////////

                                                                                                              //ESCRIBIR

                                                                                                              //B
                                                                                                              else if ((instrucciones==1) && (pixelx >= posicionPush1) && (pixelx<posicionPush1+cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                  char_addr <= 7'h42;//direccion de lo que se va a imprimir
                                                                                                                  color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                  font_size<=2'd1;
                                                                                                                  graficos<=1'd0;
                                                                                                                  memInt<=1'd0;
                                                                                                                  dp<=1'd1;end//Tamaño de fuente


                                                                                                                  //T
                                                                                                                  else if ((instrucciones==1) && (pixelx >= posicionPush1+cambioMozaico) && (pixelx<posicionPush1+ 2*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                      char_addr <= 7'h54;//direccion de lo que se va a imprimir
                                                                                                                      color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                      font_size<=2'd1;
                                                                                                                      graficos<=1'd0;
                                                                                                                      memInt<=1'd0;
                                                                                                                      dp<=1'd1;end

                                                                                                                      //ABAJO
                                                                                                                else if ((instrucciones==1) && (pixelx >= posicionPush1+ 2*cambioMozaico) && (pixelx< posicionPush1+ 3*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                      char_addr <= 7'h1f;//direccion de lo que se va a imprimir
                                                                                                                      color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                      font_size<=2'd1;
                                                                                                                      graficos<=1'd0;
                                                                                                                      memInt<=1'd0;
                                                                                                                      dp<=1'd1;end

                                                                                                                      //ESPACIO
                                                                                                                else if ((instrucciones==1) && (pixelx >= posicionPush1+ 3*cambioMozaico) && (pixelx< posicionPush1+ 4*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                      char_addr <= 7'h00;//direccion de lo que se va a imprimir
                                                                                                                      color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                      font_size<=2'd1;
                                                                                                                      graficos<=1'd0;
                                                                                                                      memInt<=1'd0;
                                                                                                                      dp<=1'd1;end

                                                                                                                      //R
                                                                                                                else if ((instrucciones==1) && (pixelx >= posicionPush1+ 4*cambioMozaico) && (pixelx< posicionPush1+ 5*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                      char_addr <= 7'h52;//direccion de lo que se va a imprimir
                                                                                                                      color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                      font_size<=2'd1;
                                                                                                                      graficos<=1'd0;
                                                                                                                      memInt<=1'd0;
                                                                                                                      dp<=1'd1;end


                                                                                                                      //E
                                                                                                                else if ((instrucciones==1) && (pixelx >= posicionPush1+ 5*cambioMozaico ) && (pixelx< posicionPush1+ 6*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                      char_addr <= 7'h45;//direccion de lo que se va a imprimir
                                                                                                                      color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                      font_size<=2'd1;
                                                                                                                      graficos<=1'd0;
                                                                                                                      memInt<=1'd0;
                                                                                                                      dp<=1'd1;end


                                                                                                                      //S
                                                                                                                else if ((instrucciones==1) && (pixelx >=posicionPush1+ 6*cambioMozaico) && (pixelx< posicionPush1+ 7*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                      char_addr <= 7'h53;//direccion de lo que se va a imprimir
                                                                                                                      color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                      font_size<=2'd1;
                                                                                                                      graficos<=1'd0;
                                                                                                                      memInt<=1'd0;
                                                                                                                      dp<=1'd1;end

                                                                                                                      //T
                                                                                                                else if ((instrucciones==1) && (pixelx >=posicionPush1+ 7*cambioMozaico) && (pixelx< posicionPush1+ 8*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                      char_addr <= 7'h54;//direccion de lo que se va a imprimir
                                                                                                                      color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                      font_size<=2'd1;
                                                                                                                      graficos<=1'd0;
                                                                                                                      memInt<=1'd0;
                                                                                                                      dp<=1'd1;end

                                                                                                                      //A
                                                                                                                else if ((instrucciones==1) && (pixelx >=posicionPush1+ 8*cambioMozaico) && (pixelx< posicionPush1+ 9*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                      char_addr <= 7'h41;//direccion de lo que se va a imprimir
                                                                                                                      color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                      font_size<=2'd1;
                                                                                                                      graficos<=1'd0;
                                                                                                                      memInt<=1'd0;
                                                                                                                      dp<=1'd1;end

                                                                                                                      //ESPACIO
                                                                                                                else if ((instrucciones==1) && (pixelx >=posicionPush1+ 9*cambioMozaico) && (pixelx< posicionPush1+ 10*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                      char_addr <= 7'h00;//direccion de lo que se va a imprimir
                                                                                                                      color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                      font_size<=2'd1;
                                                                                                                      graficos<=1'd0;
                                                                                                                      memInt<=1'd0;
                                                                                                                      dp<=1'd1;end

                                                                                                                      //1
                                                                                                                else if ((instrucciones==1) && (pixelx >=posicionPush1+ 10*cambioMozaico) && (pixelx< posicionPush1+ 11*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                      char_addr <= 7'h31;//direccion de lo que se va a imprimir
                                                                                                                      color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                      font_size<=2'd1;
                                                                                                                      graficos<=1'd0;
                                                                                                                      memInt<=1'd0;
                                                                                                                      dp<=1'd1;end




                                                                                                                      //IZQUIERDA

                                                                                                                      //B
                                                                                                                      else if ((instrucciones==1) && (pixelx >= posicionPush1) && (pixelx<posicionPush1+cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                                                                          char_addr <= 7'h42;//direccion de lo que se va a imprimir
                                                                                                                          color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                          font_size<=2'd1;
                                                                                                                          graficos<=1'd0;
                                                                                                                          memInt<=1'd0;
                                                                                                                          dp<=1'd1;end//Tamaño de fuente


                                                                                                                          //T
                                                                                                                          else if ((instrucciones==1) && (pixelx >= posicionPush1+cambioMozaico) && (pixelx<posicionPush1+ 2*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                                                                              char_addr <= 7'h54;//direccion de lo que se va a imprimir
                                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                              font_size<=2'd1;
                                                                                                                              graficos<=1'd0;
                                                                                                                              memInt<=1'd0;
                                                                                                                              dp<=1'd1;end

                                                                                                                              //IZQUIERDA
                                                                                                                        else if ((instrucciones==1) && (pixelx >= posicionPush1+ 2*cambioMozaico) && (pixelx< posicionPush1+ 3*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                                                                              char_addr <= 7'h3c;//direccion de lo que se va a imprimir
                                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                              font_size<=2'd1;
                                                                                                                              graficos<=1'd0;
                                                                                                                              memInt<=1'd0;
                                                                                                                              dp<=1'd1;end

                                                                                                                              //ESPACIO
                                                                                                                        else if ((instrucciones==1) && (pixelx >= posicionPush1+ 3*cambioMozaico) && (pixelx< posicionPush1+ 4*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                                                                              char_addr <= 7'h00;//direccion de lo que se va a imprimir
                                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                              font_size<=2'd1;
                                                                                                                              graficos<=1'd0;
                                                                                                                              memInt<=1'd0;
                                                                                                                              dp<=1'd1;end

                                                                                                                              //I
                                                                                                                        else if ((instrucciones==1) && (pixelx >= posicionPush1+ 4*cambioMozaico) && (pixelx< posicionPush1+ 5*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                                                                              char_addr <= 7'h49;//direccion de lo que se va a imprimir
                                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                              font_size<=2'd1;
                                                                                                                              graficos<=1'd0;
                                                                                                                              memInt<=1'd0;
                                                                                                                              dp<=1'd1;end


                                                                                                                              //Z
                                                                                                                        else if ((instrucciones==1) && (pixelx >= posicionPush1+ 5*cambioMozaico ) && (pixelx< posicionPush1+ 6*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                                                                              char_addr <= 7'h5a;//direccion de lo que se va a imprimir
                                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                              font_size<=2'd1;
                                                                                                                              graficos<=1'd0;
                                                                                                                              memInt<=1'd0;
                                                                                                                              dp<=1'd1;end


                                                                                                                              //Q
                                                                                                                        else if ((instrucciones==1) && (pixelx >=posicionPush1+ 6*cambioMozaico) && (pixelx< posicionPush1+ 7*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                                                                              char_addr <= 7'h51;//direccion de lo que se va a imprimir
                                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                              font_size<=2'd1;
                                                                                                                              graficos<=1'd0;
                                                                                                                              memInt<=1'd0;
                                                                                                                              dp<=1'd1;end

                                                                                                                              //U
                                                                                                                        else if ((instrucciones==1) && (pixelx >=posicionPush1+ 7*cambioMozaico) && (pixelx< posicionPush1+ 8*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                                                                              char_addr <= 7'h55;//direccion de lo que se va a imprimir
                                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                              font_size<=2'd1;
                                                                                                                              graficos<=1'd0;
                                                                                                                              memInt<=1'd0;
                                                                                                                              dp<=1'd1;end

                                                                                                                              //I
                                                                                                                        else if ((instrucciones==1) && (pixelx >=posicionPush1+ 8*cambioMozaico) && (pixelx< posicionPush1+ 9*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                                                                              char_addr <= 7'h49;//direccion de lo que se va a imprimir
                                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                              font_size<=2'd1;
                                                                                                                              graficos<=1'd0;
                                                                                                                              memInt<=1'd0;
                                                                                                                              dp<=1'd1;end

                                                                                                                              //E
                                                                                                                        else if ((instrucciones==1) && (pixelx >=posicionPush1+ 9*cambioMozaico) && (pixelx< posicionPush1+ 10*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                                                                              char_addr <= 7'h45;//direccion de lo que se va a imprimir
                                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                              font_size<=2'd1;
                                                                                                                              graficos<=1'd0;
                                                                                                                              memInt<=1'd0;
                                                                                                                              dp<=1'd1;end

                                                                                                                              //R
                                                                                                                        else if ((instrucciones==1) && (pixelx >=posicionPush1+ 10*cambioMozaico) && (pixelx< posicionPush1+ 11*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                                                                              char_addr <= 7'h52;//direccion de lo que se va a imprimir
                                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                              font_size<=2'd1;
                                                                                                                              graficos<=1'd0;
                                                                                                                              memInt<=1'd0;
                                                                                                                              dp<=1'd1;end

                                                                                                                              //D
                                                                                                                        else if ((instrucciones==1) && (pixelx >=posicionPush1+ 11*cambioMozaico) && (pixelx< posicionPush1+ 12*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                                                                              char_addr <= 7'h44;//direccion de lo que se va a imprimir
                                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                              font_size<=2'd1;
                                                                                                                              graficos<=1'd0;
                                                                                                                              memInt<=1'd0;
                                                                                                                              dp<=1'd1;end
                                                                                                                              //A
                                                                                                                        else if ((instrucciones==1) && (pixelx >=posicionPush1+ 12*cambioMozaico) && (pixelx< posicionPush1+ 13*cambioMozaico) && (pixely >= ARInstrucciones+alturaMozaico) && (pixely<=ABInstrucciones+alturaMozaico))begin
                                                                                                                              char_addr <= 7'h41;//direccion de lo que se va a imprimir
                                                                                                                              color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                              font_size<=2'd1;
                                                                                                                              graficos<=1'd0;
                                                                                                                              memInt<=1'd0;
                                                                                                                              dp<=1'd1;end




                                                                                                                              //Segundo grupo de PUSH
                                                                                                                                                  ////BT DERECHA
                                                                                                                                                        //B
                                                                                                                                                        else if ((instrucciones==1) && (pixelx >= posicionPush2) && (pixelx<posicionPush2+cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                                                                            char_addr <= 7'h42;//direccion de lo que se va a imprimir
                                                                                                                                                            color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                            font_size<=2'd1;
                                                                                                                                                            graficos<=1'd0;
                                                                                                                                                            memInt<=1'd0;
                                                                                                                                                            dp<=1'd1;end//Tamaño de fuente


                                                                                                                                                            //T
                                                                                                                                                            else if ((instrucciones==1) && (pixelx >= posicionPush2+cambioMozaico) && (pixelx<posicionPush2+ 2*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                                                                                char_addr <= 7'h54;//direccion de lo que se va a imprimir
                                                                                                                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                font_size<=2'd1;
                                                                                                                                                                graficos<=1'd0;
                                                                                                                                                                memInt<=1'd0;
                                                                                                                                                                dp<=1'd1;end

                                                                                                                                                                //DERECHA
                                                                                                                                                          else if ((instrucciones==1) && (pixelx >= posicionPush2+ 2*cambioMozaico) && (pixelx< posicionPush2+ 3*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                                                                                char_addr <= 7'h3e;//direccion de lo que se va a imprimir
                                                                                                                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                font_size<=2'd1;
                                                                                                                                                                graficos<=1'd0;
                                                                                                                                                                memInt<=1'd0;
                                                                                                                                                                dp<=1'd1;end

                                                                                                                                                                //ESPACIO
                                                                                                                                                          else if ((instrucciones==1) && (pixelx >= posicionPush2+ 3*cambioMozaico) && (pixelx< posicionPush2+ 4*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                                                                                char_addr <= 7'h00;//direccion de lo que se va a imprimir
                                                                                                                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                font_size<=2'd1;
                                                                                                                                                                graficos<=1'd0;
                                                                                                                                                                memInt<=1'd0;
                                                                                                                                                                dp<=1'd1;end

                                                                                                                                                                //D
                                                                                                                                                          else if ((instrucciones==1) && (pixelx >= posicionPush2+ 4*cambioMozaico) && (pixelx< posicionPush2+ 5*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                                                                                char_addr <= 7'h44;//direccion de lo que se va a imprimir
                                                                                                                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                font_size<=2'd1;
                                                                                                                                                                graficos<=1'd0;
                                                                                                                                                                memInt<=1'd0;
                                                                                                                                                                dp<=1'd1;end


                                                                                                                                                                //E
                                                                                                                                                          else if ((instrucciones==1) && (pixelx >= posicionPush2+ 5*cambioMozaico ) && (pixelx< posicionPush2+ 6*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                                                                                char_addr <= 7'h45;//direccion de lo que se va a imprimir
                                                                                                                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                font_size<=2'd1;
                                                                                                                                                                graficos<=1'd0;
                                                                                                                                                                memInt<=1'd0;
                                                                                                                                                                dp<=1'd1;end


                                                                                                                                                                //R
                                                                                                                                                          else if ((instrucciones==1) && (pixelx >=posicionPush2+ 6*cambioMozaico) && (pixelx< posicionPush2+ 7*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                                                                                char_addr <= 7'h52;//direccion de lo que se va a imprimir
                                                                                                                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                font_size<=2'd1;
                                                                                                                                                                graficos<=1'd0;
                                                                                                                                                                memInt<=1'd0;
                                                                                                                                                                dp<=1'd1;end

                                                                                                                                                                //E
                                                                                                                                                          else if ((instrucciones==1) && (pixelx >=posicionPush2+ 7*cambioMozaico) && (pixelx< posicionPush2+ 8*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                                                                                char_addr <= 7'h45;//direccion de lo que se va a imprimir
                                                                                                                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                font_size<=2'd1;
                                                                                                                                                                graficos<=1'd0;
                                                                                                                                                                memInt<=1'd0;
                                                                                                                                                                dp<=1'd1;end

                                                                                                                                                                //C
                                                                                                                                                          else if ((instrucciones==1) && (pixelx >=posicionPush2+ 8*cambioMozaico) && (pixelx< posicionPush2+ 9*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                                                                                char_addr <= 7'h43;//direccion de lo que se va a imprimir
                                                                                                                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                font_size<=2'd1;
                                                                                                                                                                graficos<=1'd0;
                                                                                                                                                                memInt<=1'd0;
                                                                                                                                                                dp<=1'd1;end

                                                                                                                                                                //H
                                                                                                                                                          else if ((instrucciones==1) && (pixelx >=posicionPush2+ 9*cambioMozaico) && (pixelx< posicionPush2+ 10*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                                                                                char_addr <= 7'h48;//direccion de lo que se va a imprimir
                                                                                                                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                font_size<=2'd1;
                                                                                                                                                                graficos<=1'd0;
                                                                                                                                                                memInt<=1'd0;
                                                                                                                                                                dp<=1'd1;end


                                                                                                                                                                //A
                                                                                                                                                          else if ((instrucciones==1) && (pixelx >=posicionPush2+ 10*cambioMozaico) && (pixelx< posicionPush2+ 11*cambioMozaico) && (pixely >= ARInstrucciones-alturaMozaico) && (pixely<=ABInstrucciones-alturaMozaico))begin
                                                                                                                                                                char_addr <= 7'h41;//direccion de lo que se va a imprimir
                                                                                                                                                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                font_size<=2'd1;
                                                                                                                                                                graficos<=1'd0;
                                                                                                                                                                memInt<=1'd0;
                                                                                                                                                                dp<=1'd1;end



                                                                                                                                                                ///////////
                                                                                                                                                                ///////////

                                                                                                                                                                //ACTIVAR CRONO

                                                                                                                                                                //B
                                                                                                                                                                else if ((instrucciones==1) && (pixelx >= posicionPush2) && (pixelx<posicionPush2+cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                                                                    char_addr <= 7'h42;//direccion de lo que se va a imprimir
                                                                                                                                                                    color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                    font_size<=2'd1;
                                                                                                                                                                    graficos<=1'd0;
                                                                                                                                                                    memInt<=1'd0;
                                                                                                                                                                    dp<=1'd1;end//Tamaño de fuente


                                                                                                                                                                    //T
                                                                                                                                                                    else if ((instrucciones==1) && (pixelx >= posicionPush2+cambioMozaico) && (pixelx<posicionPush2+ 2*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                                                                        char_addr <= 7'h54;//direccion de lo que se va a imprimir
                                                                                                                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                        font_size<=2'd1;
                                                                                                                                                                        graficos<=1'd0;
                                                                                                                                                                        memInt<=1'd0;
                                                                                                                                                                        dp<=1'd1;end

                                                                                                                                                                        //CENTRO
                                                                                                                                                                  else if ((instrucciones==1) && (pixelx >= posicionPush2+ 2*cambioMozaico) && (pixelx< posicionPush2+ 3*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                                                                        char_addr <= 7'h09;//direccion de lo que se va a imprimir
                                                                                                                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                        font_size<=2'd1;
                                                                                                                                                                        graficos<=1'd0;

                                                                                                                                                                        memInt<=1'd0;
                                                                                                                                                                        dp<=1'd1;end

                                                                                                                                                                        //ESPACIO
                                                                                                                                                                  else if ((instrucciones==1) && (pixelx >= posicionPush2+ 3*cambioMozaico) && (pixelx< posicionPush2+ 4*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                                                                        char_addr <= 7'h00;//direccion de lo que se va a imprimir
                                                                                                                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                        font_size<=2'd1;
                                                                                                                                                                        graficos<=1'd0;
                                                                                                                                                                        memInt<=1'd0;
                                                                                                                                                                        dp<=1'd1;end

                                                                                                                                                                        //A
                                                                                                                                                                  else if ((instrucciones==1) && (pixelx >= posicionPush2+ 4*cambioMozaico) && (pixelx< posicionPush2+ 5*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                                                                        char_addr <= 7'h41;//direccion de lo que se va a imprimir
                                                                                                                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                        font_size<=2'd1;
                                                                                                                                                                        graficos<=1'd0;
                                                                                                                                                                        memInt<=1'd0;
                                                                                                                                                                        dp<=1'd1;end


                                                                                                                                                                        //C
                                                                                                                                                                  else if ((instrucciones==1) && (pixelx >= posicionPush2+ 5*cambioMozaico ) && (pixelx< posicionPush2+ 6*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                                                                        char_addr <= 7'h43;//direccion de lo que se va a imprimir
                                                                                                                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                        font_size<=2'd1;
                                                                                                                                                                        graficos<=1'd0;
                                                                                                                                                                        memInt<=1'd0;
                                                                                                                                                                        dp<=1'd1;end


                                                                                                                                                                        //T
                                                                                                                                                                  else if ((instrucciones==1) && (pixelx >=posicionPush2+ 6*cambioMozaico) && (pixelx< posicionPush2+ 7*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                                                                        char_addr <= 7'h54;//direccion de lo que se va a imprimir
                                                                                                                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                        font_size<=2'd1;
                                                                                                                                                                        graficos<=1'd0;
                                                                                                                                                                        memInt<=1'd0;
                                                                                                                                                                        dp<=1'd1;end

                                                                                                                                                                        //ESPACIO
                                                                                                                                                                  else if ((instrucciones==1) && (pixelx >=posicionPush2+ 7*cambioMozaico) && (pixelx< posicionPush2+ 8*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                                                                        char_addr <= 7'h00;//direccion de lo que se va a imprimir
                                                                                                                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                        font_size<=2'd1;
                                                                                                                                                                        graficos<=1'd0;
                                                                                                                                                                        memInt<=1'd0;
                                                                                                                                                                        dp<=1'd1;end

                                                                                                                                                                        //C
                                                                                                                                                                  else if ((instrucciones==1) && (pixelx >=posicionPush2+ 8*cambioMozaico) && (pixelx< posicionPush2+ 9*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                                                                        char_addr <= 7'h43;//direccion de lo que se va a imprimir
                                                                                                                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                        font_size<=2'd1;
                                                                                                                                                                        graficos<=1'd0;
                                                                                                                                                                        memInt<=1'd0;
                                                                                                                                                                        dp<=1'd1;end

                                                                                                                                                                        //R
                                                                                                                                                                  else if ((instrucciones==1) && (pixelx >=posicionPush2+ 9*cambioMozaico) && (pixelx< posicionPush2+ 10*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                                                                        char_addr <= 7'h52;//direccion de lo que se va a imprimir
                                                                                                                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                        font_size<=2'd1;
                                                                                                                                                                        graficos<=1'd0;
                                                                                                                                                                        memInt<=1'd0;
                                                                                                                                                                        dp<=1'd1;end

                                                                                                                                                                        //O
                                                                                                                                                                  else if ((instrucciones==1) && (pixelx >=posicionPush2+ 10*cambioMozaico) && (pixelx< posicionPush2+ 11*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                                                                        char_addr <= 7'h4f;//direccion de lo que se va a imprimir
                                                                                                                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                        font_size<=2'd1;
                                                                                                                                                                        graficos<=1'd0;
                                                                                                                                                                        memInt<=1'd0;
                                                                                                                                                                        dp<=1'd1;end

                                                                                                                                                                        //N
                                                                                                                                                                  else if ((instrucciones==1) && (pixelx >=posicionPush2+ 11*cambioMozaico) && (pixelx< posicionPush2+ 12*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                                                                        char_addr <= 7'h4e;//direccion de lo que se va a imprimir
                                                                                                                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                        font_size<=2'd1;
                                                                                                                                                                        graficos<=1'd0;
                                                                                                                                                                        memInt<=1'd0;
                                                                                                                                                                        dp<=1'd1;end

                                                                                                                                                                        //O
                                                                                                                                                                  else if ((instrucciones==1) && (pixelx >=posicionPush2+ 12*cambioMozaico) && (pixelx< posicionPush2+ 13*cambioMozaico) && (pixely >= ARInstrucciones) && (pixely<=ABInstrucciones))begin
                                                                                                                                                                        char_addr <= 7'h4f;//direccion de lo que se va a imprimir
                                                                                                                                                                        color_addr<=4'd2;// Color de lo que se va a imprimir
                                                                                                                                                                        font_size<=2'd1;
                                                                                                                                                                        graficos<=1'd0;
                                                                                                                                                                        memInt<=1'd0;
                                                                                                                                                                        dp<=1'd1;end





//Semana
else if ((pixelx >= IsemanaU) && (pixelx<=DsemanaU) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
    char_addr <= numeroSemanaU;//direccion de lo que se va a imprimir
    color_addr<=4'd2;// Color de lo que se va a imprimir
    font_size<=2'd1;
    graficos<=1'd0;
    memInt<=1'd0;
    dp<=1'd1;end//Tamaño de fuente

    else if ((pixelx >= IsemanaD) && (pixelx<=DsemanaD) && (pixely >= ARsemana) && (pixely<=ABsemana))begin
        char_addr <= numeroSemanaD;//direccion de lo que se va a imprimir
        color_addr<=4'd2;// Color de lo que se va a imprimir
        font_size<=2'd1;
        graficos<=1'd0;
        memInt<=1'd0;
        dp<=1'd1;end//Tamaño de fuente


//**************************************************************************************************
//Dia

        else if ((pixelx >= IdiaD) && (pixelx<=DdiaD) && (pixely >= ARdia) && (pixely<=ABdia))begin
            char_addr <= diaSemanaD;//direccion de lo que se va a imprimir
            color_addr<=4'd2;// Color de lo que se va a imprimir
            font_size<=2'd1;
            graficos<=1'd0;
            memInt<=1'd0;
            dp<=1'd1;end//Tamaño de fuente

            else if ((pixelx >= IdiaU) && (pixelx<=DdiaU) && (pixely >= ARdia) && (pixely<=ABdia))begin
                char_addr <= diaSemanaU;//direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color de lo que se va a imprimir
                font_size<=2'd1;
                graficos<=1'd0;
                memInt<=1'd0;
                dp<=1'd1;end//Tamaño de fuente

//*****************************************************************************************************




                //Fecha
                        else if ((pixelx >= IfechaD) && (pixelx<=DfechaD) && (pixely >= ARfecha) && (pixely<=ABfecha))begin
                            char_addr <= fechaD;//direccion de lo que se va a imprimir
                            color_addr<=4'd2;// Color de lo que se va a imprimir
                            font_size<=2'd1;
                            graficos<=1'd0;
                            memInt<=1'd0;
                            dp<=1'd1;end//Tamaño de fuente

                            else if ((pixelx >= IfechaU) && (pixelx<=DfechaU) && (pixely >= ARfecha) && (pixely<=ABfecha))begin
                                char_addr <= fechaU;//direccion de lo que se va a imprimir
                                color_addr<=4'd2;// Color de lo que se va a imprimir
                                font_size<=2'd1;
                                graficos<=1'd0;
                                memInt<=1'd0;
                                dp<=1'd1;end//Tamaño de fuente





//Año 20

  else if ((pixelx >= 10'd591) && (pixelx<=10'd598) && (pixely >= ARano) && (pixely<=ABano))begin
  char_addr <= 7'h30;//direccion de lo que se va a imprimir
  color_addr<=4'd2;// Color de lo que se va a imprimir
    font_size<=2'd1;
    graficos<=1'd0;
    memInt<=1'd0;
    dp<=1'd1;end//Tamaño de fuente

else if ((pixelx >= 10'd583) && (pixelx<=10'd590) && (pixely >= ARano) && (pixely<=ABano))begin
  char_addr <= 7'h32;//direccion de lo que se va a imprimir
  color_addr<=4'd2;// Color de lo que se va a imprimir
  font_size<=2'd1;
  graficos<=1'd0;
  memInt<=1'd0;
  dp<=1'd1;end//Tamaño de fuente


    //Año
              else if ((pixelx >= IanoD) && (pixelx<=DanoD) && (pixely >= ARano) && (pixely<=ABano))begin
                char_addr <= anoD;//direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color de lo que se va a imprimir
                  font_size<=2'd1;
                  graficos<=1'd0;
                  memInt<=1'd0;
                  dp=1'd1;end//Tamaño de fuente

              else if ((pixelx >= IanoU) && (pixelx<=DanoU) && (pixely >= ARano) && (pixely<=ABano))begin
                char_addr <= anoU;//direccion de lo que se va a imprimir
                color_addr<=4'd2;// Color de lo que se va a imprimir
                font_size<=2'd1;
                graficos<=1'd0;
                memInt<=1'd0;
                dp<=1'd1;end//Tamaño de fuente


                //Año
                          else if ((pixelx >= ImesD) && (pixelx<=DmesD) && (pixely >= ARmes) && (pixely<=ABmes))begin
                            char_addr <=mesD;//direccion de lo que se va a imprimir
                            color_addr<=4'd2;// Color de lo que se va a imprimir
                              font_size<=2'd1;
                              graficos<=1'd0;
                              memInt<=1'd0;
                              dp<=1'd1;end//Tamaño de fuente

                          else if ((pixelx >= ImesU) && (pixelx<=DmesU) && (pixely >= ARmes) && (pixely<=ABmes))begin
                            char_addr <= mesU;//direccion de lo que se va a imprimir
                            color_addr<=4'd2;// Color de lo que se va a imprimir
                            font_size<=2'd1;
                            graficos<=1'd0;
                            memInt<=1'd0;
                            dp<=1'd1;end//Tamaño de fuente

 else //Fondo de Pamtalla
begin

if ((pixely >= 10'd0) && (pixely<=10'd140))begin
char_addr = 7'h0a; //direccion de lo que se va a imprimir
color_addr=4'd0;// Color de lo que se va a imprimir
font_size=2'd1;
graficos<=1'd0;
memInt=1'd0;
dp=1'd1; end//Tamaño de fuente



else if ((pixely >= 10'd141) && (pixely<=10'd151))begin
char_addr = 7'h0a; //direccion de lo que se va a imprimir
color_addr=4'd1;// Color de lo que se va a imprimir
font_size=2'd1;
graficos<=1'd0;
memInt=1'd0;
dp=1'd1; end//Tamaño de fuente


//Cuadros
else if ((pixely >= 10'd152) && (pixely<=10'd338))begin


//Curva superior
if ((pixelx <=32) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd1;graficos<=1'd0;memInt=1'd1;end
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
else if ((pixelx >609) && (pixely == 152)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
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
else if ((pixelx >611) && (pixely == 153)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
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
else if ((pixelx >611) && (pixely == 154)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
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
else if ((pixelx >612) && (pixely == 155)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
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
else if ((pixelx >613) && (pixely == 156)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
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
else if ((pixelx >613) && (pixely == 157)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
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
else if ((pixelx >613) && (pixely == 158)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end

//Parte constante
else if ((pixelx <=28) && (pixely >= 159) && (pixely <= 244))begin
dp=1'd1;color_addr=3'd1;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=29) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd5;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=212) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd3;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=213) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd5;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=228) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd1;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=229) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd5;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=412) && (pixely >= 159 ) && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd3;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=413) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd5;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=428) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd1;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=429) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd5;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=612) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd3;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=613) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd5;graficos<=1'd0;memInt=1'd1;end
else if ((pixelx <=800) && (pixely >= 159)  && (pixely <= 244)) begin
dp=1'd1;color_addr=3'd1;graficos<=1'd0;memInt=1'd1;end

//Raya Negra
else if (pixely >= 244  && (pixely <= 247)) begin
dp=1'd1;color_addr=3'd1;graficos<=1'd0;memInt=1'd1;end


//Segunda parte constante

else if  ((pixelx <=28) && (pixely >= 248) && (pixely <= 333))begin
dp=1'd1;color_addr=3'd1;graficos<=1'd0;memInt=1'd1;end
else if ( (pixelx <=29) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd5;graficos<=1'd0;memInt=1'd1;end
else if ( (pixelx <=212) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd3;graficos<=1'd0;memInt=1'd1;end
else if ( (pixelx <=213) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd5;graficos<=1'd0;memInt=1'd1;end
else if ( (pixelx <=228) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd1;graficos<=1'd0;memInt=1'd1;end
else if ( (pixelx <=229) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd5;graficos<=1'd0;memInt=1'd1;end
else if ( (pixelx <=412) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd3;graficos<=1'd0;memInt=1'd1;end
else if ( (pixelx <=413) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd5;graficos<=1'd0;memInt=1'd1;end
else if ( (pixelx <=428) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd1;graficos<=1'd0;memInt=1'd1;end
else if ( (pixelx <=429) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd5;graficos<=1'd0;memInt=1'd1;end
else if ( (pixelx <612) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd3;graficos<=1'd0;memInt=1'd1;end
else if ( (pixelx <=613) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd5;graficos<=1'd0;memInt=1'd1;end
else if ( (pixelx <=800) && (pixely >= 248) && (pixely <= 333)) begin
dp=1'd1;color_addr=3'd1;graficos<=1'd0;memInt=1'd1;end


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
else if ((pixelx >613) && (pixely == 332)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
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
else if ((pixelx >612) && (pixely == 333)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
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
else if ((pixelx >611) && (pixely == 334)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
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
else if ((pixelx >611) && (pixely == 335)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
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
else if ((pixelx >609) && (pixely == 336)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
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
else if ((pixelx >608) && (pixely == 337)) begin
dp=1'd1;color_addr=3'd1;memInt=1'd1;end
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
graficos<=1'd0;
memInt<=1'd1;
dp<=1'd1; end//Tamaño de fuente



else if ((pixely >= 10'd349) && (pixely<=10'd351))begin
char_addr <= 7'h0a; //direccion de lo que se va a imprimir
color_addr<=4'd0;// Color de lo que se va a imprimir
font_size<=2'd1;
graficos<=1'd0;
memInt<=1'd1;
dp<=1'd1; end//Tamaño de fuente



else if ((pixely >= 10'd352) && (pixely<=10'd353))begin
char_addr <= 7'h0a; //direccion de lo que se va a imprimir
color_addr<=4'd1;// Color de lo que se va a imprimir
font_size<=2'd1;
graficos<=1'd0;
memInt<=1;
dp<=1'd1; end//Tamaño de fuente


else if ((pixely >= 10'd354) && (pixely<=10'd472))begin
char_addr <= 7'h0a; //direccion de lo que se va a imprimir
color_addr<=4'd0;// Color de lo que se va a imprimir
font_size<=2'd1;
graficos<=1'd0;
memInt<=1;
dp<=1'd1; end//Tamaño de fuente


//Linea Blanca ring
else if ((pixely >= 10'd473) && (pixely<= 10'd480))begin
char_addr <= 7'h0a; //direccion de lo que se va a imprimir
color_addr<=4'd2;// Color de lo que se va a imprimir
font_size<=2'd1;
graficos<=1'd0;
memInt<=1;
dp<=1'd1; end//Tamaño de fuente


else begin
char_addr <= 7'h0a; //direccion de lo que se va a imprimir
color_addr<=4'd0;// Color de lo que se va a imprimir
font_size<=2'd1;
graficos<=1'd0;
dp<=1'd1; end//Tamaño de fuente


end



//Modulo decodificador para poder usar las memorias de fuente y graficos
/*
always (posedge clk)

if (graficos)begin//Solo se activa cuando se va a usar la memoria de graficos

//Logica reinicio de los contadores lectura memoria

  if (contadorx==6'h3a )begin//Imprime una fila
      contadorx<=6'h0;

      if (contadory==12'h65 |  contadory==12'hca | contadory==12'h12f | contadory==12'h194 | contadory==12'h1f8 | contadory==12'h25d | contadory==12'h2c2 | contadory==12'h327 | contadory==12'h38c |contadory==12'h3f2 )begin //Impresion de toda una letra
          contadory<=6'h0;
      end

      else begin
          contadory<=contadory;
      end

  end

  else begin
      contadorx<=contadorx;
  end

end

//Logica aumento contadores lectura memoria y asignacion de direccion de grafico

else begin

  if (char_addr== 7'h30) begin
    contadory<=7'd0;
  end






contadorx<=contadorx+1

  end




end


*/

always @*

//Logica reinicio de los contadores lectura memoria

  if (char_addr== 7'h30) begin
    contadorycambio=contadory;
  end

  else if (char_addr== 7'h31) begin
    contadorycambio=contadory+10'd101;
  end

  else if (char_addr== 7'h32) begin
    contadorycambio=contadory+10'd203;
  end

  else if (char_addr== 7'h33) begin
    contadorycambio=contadory+10'd304;
  end

  else if (char_addr== 7'h34) begin
    contadorycambio=contadory+10'd405;
  end

  else if (char_addr== 7'h35) begin
    contadorycambio=contadory+10'd505;
  end

  else if (char_addr== 7'h36) begin
    contadorycambio=contadory+10'd606;
  end

  else if (char_addr== 7'h37) begin
    contadorycambio=contadory+10'd707;
  end

  else if (char_addr== 7'h38) begin
    contadorycambio=contadory+10'd808;
  end

  else if (char_addr== 7'h39) begin
    contadorycambio=contadory+10'd910;
  end

  else begin
    contadorycambio=contadory; //Evitar warning latch
  end



//Logica direccion de memoria


assign rom_addrGraficos = {contadorx, zero, contadorycambio}; //Direccion Memoria graficos
assign rom_addr = {char_addr, row_addr}; //concatena direcciones de registros y filas




assign graficosO=graficos;
//assign rom_addrO=rom_addr;


endmodule
