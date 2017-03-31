`timescale 1ns / 1ps


module tb_Interfaz();
     reg clk,reset;
     wire hsync,vsync;
     reg inicioSecuencia,temporizador;
     reg temporizadorFin;//Indica cuando finaliza el temporizador
     reg [7:0] datoRTC;//Dato proveniente del RTC
     reg [2:0] cursor;//Indica la posicion en la que se encuentra el cursor
     wire [11:0] rgb;
     wire font_bit;

     reg [9:0] pixelx_tb,pixely_tb;
     integer i,j;
     integer file;

 Interfaz uut(
           .clk(clk),.reset(reset),.inicioSecuencia(inicioSecuencia),
           .temporizador(temporizador),.temporizadorFin(temporizadorFin),
           .datoRTC(datoRTC),.cursor(cursor),.rgb(rgb),.hsync(hsync),
           .vsync(vsync),.font_bit(font_bit),.video_on(video_on)

           );

//155 u carga 8 datos
 initial begin
 clk=0;

 file= $fopen ( "Pantalla.txt", "w");   // Abre el archivo donde vamos a escribir
 reset=0;
 temporizador=0;
 pixelx_tb=10'd0;
  pixely_tb=10'd0;
 temporizadorFin=0;
 cursor=0;


 //#16000000; // Duración de una impresión de pantalla
#200; //Tiempo extra

/*
//Carga de datos en 0
inicioSecuencia=0;
datoRTC=8'd0;
#16000000; // Duración de una impresión de pantalla
#200; //Tiempo extra


//Lectura de datos en 0
inicioSecuencia=0;
datoRTC=8'd2;// se cambia para comprobar que no varien los datos guardados aunque lleguen otros datos
 //Llegada de los datos
*/

#15360025 //Espera para que venga el tick
inicioSecuencia=8'd1;
#10;
//Cambio de datos
datoRTC=8'd24;//Segundos
 #10;//Duración del primer dato


 datoRTC=8'd4;//Minutos
 #10;

 datoRTC=8'd3;//Horas
 #10;

 datoRTC=8'd23;
 #10;

 datoRTC=8'd12;
 #10;

 datoRTC=8'd21;
 #10;

 datoRTC=8'd5;
 #10;

 datoRTC=8'd6;
 #10;
#30;//retardo inicio secuencia
 inicioSecuencia=0;

 reset=1;
 #10
 reset=0;
 #10


 if (!file) begin
                               $display("Error: File,Pantalla.txt could not be opened.\nExiting Simulation.");

                                   end

 for (j=0; j<525; j=j+1) begin
       for (i=0; i<800; i=i+1) begin
          #40;//Tiempo que dura en cambiar un pixel
           pixelx_tb = pixelx_tb + 10'd1;
           if(video_on)begin
          $display   (file, "bit = %h", rgb);
          $fwrite   (file, "%h",  rgb);
          end
          end

       if (pixelx_tb==10'd800) begin 
          pixelx_tb= 10'd0;
          pixely_tb=pixely_tb+10'd1;
          $fwrite   (file,"\n");
          end

end

 // Se vuelve a hacer otro ciclo completo de impresión
// #16000000;


 if (pixely_tb == 10'd525)begin
$fclose(file);
$finish;
end

else begin
 #200; //Tiempo extra
 end

 end

 always
 begin
clk=~clk;
#5;
 end



 endmodule
