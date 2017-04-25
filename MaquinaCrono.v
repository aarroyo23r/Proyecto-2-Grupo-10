`timescale 1ns / 1ps

module MaquinaCrono(
    input wire Reset,clk,
    input wire ProgramarCrono,PushInicioCrono,
    input wire [7:0] horas,minutos,segundos,
    input wire arriba,abajo,izquierda,derecha,
    output reg CronoActivo,Ring,
    output reg [7:0] Cursor,
    output reg[7:0] data_crono,
    output reg[7:0] address,
    output wire [7:0] horasSal,minutosSal,segundosSal
    );



    //MaquinaCrono


 //declaracion de estados
localparam[1:0] s0 = 2'b00, //Estado Programar Cronometro
                s1 = 2'b01, //Estado Cronometro Inactivo
                s2 = 2'b10, //Estado Cronometro Activo
                s3 = 2'b11; //Estado Finalizo Cronometro

//localparam [11:0] limit = 12'h100;
 //señales de estado
 reg[1:0]s_actual,s_next=s0;
  reg[1:0]s_actualcrono,s_sig=ss;

 //reg [11:0] contador=0;

reg FinalizoCrono;
//registro de estados

//Detector de flancos
reg PushCentro_d1;
reg PushCentro_d2;
reg InicioCrono=0;

reg arribaReg1,abajoReg1,izquierdaReg1,derechaReg1;//Registros para detector de flancos
reg arribaReg2,abajoReg2,izquierdaReg2,derechaReg2;
reg ar,ab,iz,de;//Pulsos



//Programar el Cronometro
reg [7:0] horasReg=0,minutosReg=0,segundosReg=0;


always @ (posedge clk) begin

if (!Reset) begin
/*
PushCentro_d1<=PushInicioCrono;
PushCentro_d2<=PushCentro_d1;
*/
arribaReg1<=arriba;
arribaReg2<=arribaReg1;

abajoReg1<=abajo;
abajoReg2<=abajoReg1;

izquierdaReg1<=izquierda;
izquierdaReg2<=izquierdaReg1;

derechaReg1<=derecha;
derechaReg2<=derechaReg1;
end

/*
if (PushCentro_d1 && !PushCentro_d2) begin
InicioCrono<=~InicioCrono; //Enciende o apaga el cronometro
end

else begin
InicioCrono<=InicioCrono;
end
*/

if (arribaReg1 && !arribaReg2) begin
ar<=1;end

else if (abajoReg1 && !abajoReg2) begin
ab<=1;end

else if (izquierdaReg1 && !izquierdaReg2) begin
iz<=1;end

else if (derechaReg1 && !derechaReg2) begin
de<=1;end

else begin
ar<=0;
ab<=0;
iz<=0;
de<=0;

end

end


always @(posedge clk) begin
 if (horas==horasSal && minutos==minutosSal && segundos==segundosSal && horas!=8'h00 && minutos!=8'h00 && segundos!=8'h00) begin
FinalizoCrono<=1;
end

else begin
FinalizoCrono<=0;
end

end


always @(posedge clk,posedge Reset)begin//Logica de Reset y estado siguiente
    if(Reset)begin
        s_actual <=s0;
        s_actualcrono <=ss;
    end
    else
        s_actual <=s_next;
        s_actualcrono <=s_sig;
end

/*
always @(posedge clk)
    begin

    contador=contador+1'b1;
    if (contador==limit)            //Contador necesario para la duración de las señales
        begin
        contador <=0; //Reinicia el contador
        end
    end
*/

reg [3:0] unidadesSegundos,unidadesMinutos,unidadesHoras;
reg [3:0] decenasSegundos,decenasMinutos,decenasHoras;


//Sumador y restador

always @(posedge clk) begin

//sumador
if(suma && !resta) begin
/*
unidadesSegundos<=segundosReg[3:0];
unidadesMinutos<=minutosReg[3:0];
unidadesHoras<=horasReg[3:0];
*/

if (registro==2'd1)begin


if (segundosReg<=8'h59) begin

if (segundosReg[3:0]==4'h9) begin
segundosReg<=segundosReg+7;
end

else begin
segundosReg<=segundosReg+1;
end
end

else begin

segundosReg<=segundosReg;
end

end


else if (registro==2'd2)begin

if (minutosReg<=8'h59) begin

if (minutosReg[3:0]==4'h9) begin
minutosReg<=minutosReg+7;
end

else begin
minutosReg<=minutosReg+1;
end
end

else begin
minutosReg<=minutosReg;
end

end



else if (registro==2'd3)begin

if (horasReg<=8'h23)begin

if (horasReg[3:0]==4'h9) begin
horasReg<=horasReg+7;
end

else begin
horasReg<=horasReg+1;
end

end

else begin
horasReg<=horasReg;
end
end


else begin
horasReg<=horasReg;
minutosReg<=minutosReg;
segundosReg<=segundosReg;
end

end


//Restador
else if(!suma && resta) begin
/*
decenasHoras<=horasReg[7:4];
decenasMinutos<=minutosReg[7:4];
decenasSegundos<=segundosReg[7:4];

*/
if (registro==2'd1)begin

if (segundosReg>8'h00) begin

if (segundosReg==8'h10 |segundosReg==8'h20 |segundosReg==8'h30 |segundosReg==8'h40 |segundosReg==8'h50 |segundosReg==8'h60) begin
segundosReg<=segundosReg-7;
end

else begin
segundosReg<=segundosReg-1;
end

end

else begin
segundosReg<=segundosReg;

end
end


else if (registro==2'd2)begin

if (minutosReg>8'h00)begin

if (minutosReg==8'h10 |minutosReg==8'h20 |minutosReg==8'h30 |minutosReg==8'h40 |minutosReg==8'h50 |minutosReg==8'h60) begin
minutosReg<=minutosReg-7;
end

else begin
minutosReg<=minutosReg-1;
end
end

else begin
minutosReg<=minutosReg;
end
end


else if (registro==2'd3)begin

if (horasReg>8'h00)begin

if (horasReg==8'h10 |horasReg==8'h20 |horasReg==8'h30 |horasReg==8'h40 |horasReg==8'h50 |horasReg==8'h60) begin
horasReg<=horasReg-7;
end

else begin
horasReg<=horasReg-1;
end
end

else begin
horasReg<=horasReg;

end
end


else begin
horasReg<=horasReg;
minutosReg<=minutosReg;
segundosReg<=segundosReg;
end

end

else begin
horasReg<=horasReg;
minutosReg<=minutosReg;
segundosReg<=segundosReg;
end


end




always @(posedge clk)
begin
/*
if(contador==limit)
begin*/
    //s_next<=s_actual; //siguiente estado default el actual
    //CronoActivo <= 1'b0; //Default crono apagado
    case (s_actual)
        s0: begin //Estado Programar Cronometro
            if(Reset==0 && FinalizoCrono ==0  && PushInicioCrono==1)
                begin
                 CronoActivo <=1'b1;  //Para protocolo read
                 Ring <=1'b0;
                s_next<=s2;
                end
            if(Reset==0 && FinalizoCrono ==0 && PushInicioCrono==0)
                begin
                 CronoActivo <=1'b0;  //Para protocolo read
                 Ring <=1'b0;
                 s_next<=s1;
                 end
             if( Reset)
                 begin
                 CronoActivo <=1'b0;  //Para protocolo read
                 Ring <=1'b0;
                 s_next<=s_actual;
                 end
             if ((FinalizoCrono==1 && Reset==0))
                  begin
                  CronoActivo <=1'b0;  //Para protocolo read
                  Ring <=1'b1;
                  s_next<=s3;
             end


            end
        s1: begin
            if(Reset==0 && FinalizoCrono ==0 && PushInicioCrono==0)
                begin
                CronoActivo <=1'b0;  //Para protocolo read
                Ring <=1'b0;
                s_next<=s_actual;
                end
             if(Reset==0 && FinalizoCrono ==0 && PushInicioCrono==1)
                begin
                CronoActivo <=1'b1;  //Para protocolo read
                Ring <=1'b0;
                s_next<=s2;
                end
             if(Reset==0 && FinalizoCrono ==1)
                begin
                CronoActivo <=1'b0;  //Para protocolo read
                Ring <=1'b1;
                s_next<=s3;
                end
             if(Reset==1 )
                begin
                CronoActivo <=1'b0;  //Para protocolo read
                Ring <=1'b0;
                s_next<=s0;
                end

            end
       s2:begin
            if(Reset==0 && FinalizoCrono ==0  && PushInicioCrono==1)
                begin
                CronoActivo <=1'b1;  //Para protocolo read
                Ring <=1'b0;
                s_next<=s_actual;
                end
            if(Reset==0 && FinalizoCrono ==1 )
                begin
                CronoActivo <=1'b0;  //Para protocolo read
                Ring <=1'b1;
                s_next<=s3;
                end

            if(Reset==1 )
                begin
                CronoActivo <=1'b0;  //Para protocolo read
                Ring <=1'b0;
                s_next<=s0;
                end

            if(Reset==0 && FinalizoCrono ==0  && PushInicioCrono==0)
                begin
                CronoActivo <=1'b0;  //Para protocolo read
                Ring <=1'b0;
                s_next<=s1;
                end

end
        s3: begin
            if(Reset==1 | (Reset==0 && FinalizoCrono ==0  && InicioCrono==0))
                begin
                CronoActivo <=1'b0;  //Para protocolo read
                Ring <=1'b0;
                s_next<=s0;
                end
                if(Reset==0)
                    begin
                    CronoActivo <=1'b0;  //Para protocolo read
                    Ring <=1'b1;
                    s_next<=s_actual;
                    end

                end
          default: s_next<=s0;
    endcase
end










localparam [3:0] ss = 4'h0, //inicialización
                 sm = 4'h1, //segundos
                 sh = 4'h2, //minutos
                 sc = 4'h3;//Crono corriendo



reg [1:0] registro;
reg suma;
reg resta;

always @ (posedge clk)  begin

//s_sig=s_actualcrono; //siguiente estado default el actual

horasReg<=horasReg;
minutosReg<=minutosReg;
segundosReg<=segundosReg;
case (s_actualcrono)
    ss: begin //segundos
        if(!Reset && !PushInicioCrono && !FinalizoCrono  && ProgramarCrono && !ar && !ab && !iz && !de)
            begin
            registro<=2'd0;
            Cursor<=8'h41;
            suma<=0;
            resta<=0;
            //segundosReg<=segundosReg;
            s_sig<=s_actualcrono;
            end
        if( (ar) && !Reset && !PushInicioCrono && !FinalizoCrono && ProgramarCrono)
            begin
            registro<=2'd1;
            Cursor<=8'h41;
            suma<=1;
            resta<=0;
             //segundosReg<=segundosReg + 8'd1;
             s_sig<=s_actualcrono;
             end
         if((ab) && !Reset && !PushInicioCrono && !FinalizoCrono && ProgramarCrono)
             begin
             registro<=2'd1;
             Cursor<=8'h41;
             resta<=1;
             suma<=0;
             //segundosReg<=segundosReg - 8'd1;
             s_sig<=s_actualcrono;
             end

             if( (iz) && !Reset && !PushInicioCrono && !FinalizoCrono && ProgramarCrono)
                 begin
                 registro<=2'd0;
                 Cursor<=8'h42;
                 suma<=0;
                 resta<=0;
                  //segundosReg<=segundosReg;
                  s_sig<=sm;
                  end
              if((de) && !Reset && !PushInicioCrono && !FinalizoCrono && ProgramarCrono)
                  begin
                  registro<=2'd0;
                  Cursor<=8'h41;
                  suma<=0;
                  resta<=0;
                  //segundosReg<=segundosReg;
                  s_sig<=s_actualcrono;
                  end
                  if( Reset) //Estado
                      begin
                      registro<=2'd0;
                      Cursor<=8'h41;
                      suma<=0;
                      resta<=0;
                      s_sig<=ss;
                       end

                       if(!ProgramarCrono | PushInicioCrono)
                           begin
                           registro<=2'd0;
                           Cursor<=8'h00;
                           suma<=0;
                           resta<=0;
                           s_sig<=sc;
                           end



        end
    sm: begin //Minutos
    if(!Reset && !PushInicioCrono && !FinalizoCrono  && ProgramarCrono && !ar && !ab && !iz && !de)
        begin
        registro<=2'd0;
        Cursor<=8'h42;
        suma<=0;
        resta<=0;
        //minutosReg<=minutosReg;
        s_sig<=s_actualcrono;
        end
    if( (ar) && !Reset && !PushInicioCrono && !FinalizoCrono && ProgramarCrono)
        begin
        registro<=2'd2;
        Cursor<=8'h42;
        suma<=1;
        resta<=0;
         //minutosReg<=minutosReg + 8'd1;
         s_sig<=s_actualcrono;
         end
     if((ab) && !Reset && !PushInicioCrono && !FinalizoCrono && ProgramarCrono)
         begin
         registro<=2'd2;
         Cursor<=8'h42;
         suma<=0;
         resta<=1;
         //minutosReg<=minutosReg - 8'd1;
         s_sig<=s_actualcrono;
         end

         if( (iz) && !Reset && !PushInicioCrono && !FinalizoCrono && ProgramarCrono)
             begin
             registro<=2'd0;
             Cursor<=8'h43;
             suma<=0;
             resta<=0;
              //minutosReg<=minutosReg;
              s_sig<=sh;
              end
          if((de) && !Reset && !PushInicioCrono && !FinalizoCrono && ProgramarCrono)
              begin
              registro<=2'd0;
              Cursor<=8'h41;
              suma<=0;
              resta<=0;
              //minutosReg<=minutosReg;
              s_sig<=ss;
              end

              if( Reset) //Estado
                  begin
                  registro<=2'd0;
                  Cursor<=8'h41;
                  suma<=0;
                  resta<=0;
                  s_sig<=ss;
                   end


                   if(!ProgramarCrono  | PushInicioCrono)
                       begin
                       registro<=2'd0;
                       Cursor<=8'h00;
                       suma<=0;
                       resta<=0;
                       s_sig<=sc;
                       end
            end
   sc: begin//Correr
   if((!ProgramarCrono | PushInicioCrono)  && !Reset)
       begin
       registro<=2'd0;
       Cursor<=8'h00;
       suma<=0;
       resta<=0;
       s_sig<=s_actualcrono;
       end
   if( Reset | ProgramarCrono) //Estado
       begin
       registro<=2'd0;
       Cursor<=8'h00;
       suma<=0;
       resta<=0;
       s_sig<=ss;
        end

end

             sh:begin
             if(!Reset && !PushInicioCrono && !FinalizoCrono && !ar && !ab && !iz && !de )
                 begin
                 registro<=2'd0;
                 Cursor<=8'h43;
                 suma<=0;
                 resta<=0;
                 //horasReg<=horasReg;
                 s_sig<=s_actualcrono;
                 end
             if( (ar) && !Reset && !PushInicioCrono && !FinalizoCrono)
                 begin
                 registro<=2'd3;
                 Cursor<=8'h43;
                 suma<=1;
                 resta<=0;
                  //horasReg<=horasReg + 8'd1;
                  s_sig<=s_actualcrono;
                  end
              if((ab) && !Reset && !PushInicioCrono && !FinalizoCrono)
                  begin
                  registro<=2'd3;
                  Cursor<=8'h43;
                  suma<=0;
                  resta<=1;
                  //horasReg<=horasReg - 8'd1;
                  s_sig<=s_actualcrono;
                  end

                  if( (iz) && !Reset && !PushInicioCrono && !FinalizoCrono)
                      begin
                      registro<=2'd0;
                      Cursor<=8'h42;
                      suma<=0;
                      resta<=0;
                       //horasReg<=horasReg;
                       s_sig<=s_actualcrono;
                       end
                   if((de) && !Reset && !PushInicioCrono && !FinalizoCrono)
                       begin
                       registro<=2'd0;
                       Cursor<=8'h43;
                       suma<=0;
                       resta<=0;
                       //horasReg<=horasReg;
                       s_sig<=sm;
                       end

                       if( Reset) //Estado
                           begin
                           registro<=2'd0;
                           Cursor<=8'h41;
                           suma<=0;
                           resta<=0;
                           s_sig<=ss;
                            end

                            if(!ProgramarCrono | PushInicioCrono)
                                begin
                                registro<=2'd0;
                                Cursor<=8'h00;
                                s_sig<=sc;
                                suma<=0;
                                resta<=0;
                                end

                                end
endcase

end




localparam [11:0] limit = 12'd3380; //tiempo en el que la dirección se mantiene
    reg [11:0] contador=0;
    reg c_dir=1;





    always @(posedge clk)
    begin
        if( CronoActivo)
        begin
        contador<=contador + 1'b1;
        address<=8'h00;
        data_crono<=8'h08;
        if(contador==limit)
        begin
            //contador<=0;
            address<=8'h01;
            data_crono<=8'h01;
        end

        if(!CronoActivo)
        begin
        contador<=contador + 1'b1;

        address<=8'h00;
        data_crono<=8'h00;

        if(contador==limit)
        begin
            //contador<=0;
            address<=8'h01;
            data_crono<=8'h01;
        end

        if(Reset | FinalizoCrono)
            begin
            address<=8'h00;
            data_crono<=8'h00;
            contador<=0;
            end

        end
    end
end

/*
//Activar Cronometro RTC

    always @(posedge clk)
    begin
    if( ProgramarCrono && CronoActivo)
    begin
    if (!c_dir)
            begin
            address<=8'h00;
            data_crono<=8'h08;
            end
    else
            begin
            address<=8'h00;
            data_crono<=8'h80;
            end
    end

    else if (ProgramarCrono && !CronoActivo) begin
    if (!c_dir)
            begin
            address<=8'h00;
            data_crono<=8'h00;
            end
    else
            begin
            address<=8'h00;
            data_crono<=8'h80;
            end
    end
else begin
            address<=8'h00;
            data_crono<=8'h80;
end

end
*/
assign horasSal=horasReg;
assign minutosSal=minutosReg;
assign segundosSal=segundosReg;


endmodule
