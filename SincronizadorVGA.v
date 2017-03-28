`timescale 10ns / 1ps 

module SincronizadorVGA(
  input wire clk,reset,
  output wire hsync,vsync,video_on,
  output wire [9:0] pixelx,pixely
  );

  //Declaracion de constantes
  //Parametros VGA 640*480

localparam HD=10'd640; // Area horizontal de la pantalla en la que se puede escribir
localparam HF=10'd48;//Porch frontal horizontal
localparam HB=10'd16;//Porch trasero horizontal
localparam HR=10'd96;//Retraso horizontal

localparam VD=10'd480;//Area vertical de la pantalla en la que se puede escribir
localparam VF=10'd10;//Porch frontal vertical
localparam VB=10'd33;//Porch trasero vertical
localparam VR=10'd2;//Retraso vertical

//Contador mod 4 para generar el clock de 25Mhz
reg [1:0] mod4_reg=2'b00; //Registro para almacenar la cuenta

//Contadores de sincronizacion, eje x y eje y
reg [9:0] hcount_reg=10'h0,hcount_next;//Registros para almacenar y aumentar la cuenta
reg [9:0] vcount_reg=10'h0,vcount_next;//Registros para almacenar y aumentar la cuenta

//Buffers de salida
reg vsync_reg=0,hsync_reg=0;
wire vsync_next,hsync_next;

//Señales de estado
wire h_end,v_end;//Señales para establecer el tick que genera el clock de 25Mhz y determinar si los contadores de sincronizacion finalizaron su cuenta
reg pixel_tick=0;

//Cuerpo
//Escritura de datos en los Registros
always @(posedge clk,posedge reset)
if (reset)//Si hay una señal en alto de reset, pone todas las señales del modulo en 0
begin
//mod4_reg<=2'b00;
vcount_reg<=0;
hcount_reg<=0;
vsync_reg<=1'b0;
hsync_reg<=1'b0;
end

else//Si no, le asigna datos a los registros
begin
//mod4_reg<=mod4_next;
vcount_reg<=vcount_next;
hcount_reg<=hcount_next;
vsync_reg<=vsync_next;
hsync_reg<=hsync_next;
end

//Contador mod 4
always @(posedge clk)
if (mod4_reg== 2'b11)//Cuando el contador llega a 4 genera una señal de tick y se reinicia
begin
pixel_tick=0;
mod4_reg=2'b00;
end

else//Si el contador no llega a ese valor sigue contando
begin
if (mod4_reg== 2'b10)
begin
pixel_tick=~pixel_tick; //Se cambio el tick al ciclo 3 del contador porque los pixeles cambian un pulso despues, asi se logra que cambien entre pixeles cada 4 ciclos de reloj (25Mhz) y no cada 5
mod4_reg=mod4_reg+1;
end
else
begin
pixel_tick=0;
mod4_reg=mod4_reg+1;
end
end



//Señales de estado
//Fin del contador horizontal (799)
assign h_end=(hcount_reg==(HD+HF+HB+HR-1));//h_end es verdadero solamente si el contador llego a 799
//Fin del contador vertical (524)
assign v_end=(vcount_reg==(VD+VF+VB+VR-1));//v_end es verdadero solamente si el contador llego a 524

//Logica de siguiente estado contador eje x (mod 800)
always @*
if (pixel_tick)//Señal de 25Mhz
if (h_end) //Si la señal h_end es verdadera el contador se reinicia
hcount_next=0;
else
hcount_next=hcount_reg+1;//si nó, aumenta el contador en 1
else
hcount_next=hcount_reg;// Si no hay una señal de reloj se mantiene en el mismo estado

//Logica de estado siguiente contador eje y (mod 525)
always @*
if (pixel_tick & h_end)// Si el clock de 25Mhz esta en alto y el contador horizontal llego a su limite
if (v_end) //Si el contador del eje y tambien llego a su limite se reinicia
vcount_next=0;
else
vcount_next=vcount_reg+1;//Si nó, aumenta en uno el contador vertical
else
vcount_next=vcount_reg; //Si nó se cumple la primera condicion, se mantiene en el mismo estado

//Señales de sincronizacion vertical y horizontal con buffers para evitar glitch
//Señal hsync_next activa entre los pixeles 656 y 751
assign hsync_next=~(hcount_reg>=(HD+HB) && hcount_reg<=(HD+HB+HR-1));

//El codigo original producia una señal vsync_next activa entre 513 y 515
//Señal vsync_next activa entre los pixeles 490 Y 491
assign vsync_next=~(vcount_reg>=(VD+VB-23) && vcount_reg<=(VD+VB+VR-1-23));

//Video On/Off
assign video_on=(hcount_reg<HD) && (vcount_reg<VD);//Pone la señal video_on en alto solo cuando los contadores vertical y horizontal se encuentran en las zonas de la pantalla donde se puede escribir

//Salidas
assign hsync=hsync_reg;
assign vsync=vsync_reg;
assign pixelx=hcount_reg;
assign pixely=vcount_reg;



endmodule
