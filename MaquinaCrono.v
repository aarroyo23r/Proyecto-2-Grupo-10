`timescale 1ns / 1ps

module MaquinaCrono(
    input wire Reset,clk,
    input wire ProgramarCrono,FinalizoCrono,PushInicioCrono,
    //input wire [7:0] horas,minutos,segundos,
    input wire arriba,abajo,izquierda,derecha,
    output reg CronoActivo,Ring,
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
 reg[1:0]s_actual,s_next;
  reg[1:0]s_actualcrono,s_sig;

 reg [11:0] contador=0;
//registro de estados

//Detector de flancos
reg PushCentro_d1;
reg PushCentro_d2;
reg InicioCrono=0;

reg arribaReg1,abajoReg1,izquierdaReg1,derechaReg1;//Registros para detector de flancos
reg arribaReg2,abajoReg2,izquierdaReg2,derechaReg2;
reg ar,ab,iz,de;//Pulsos

always @ (posedge clk)
PushCentro_d1<=PushInicioCrono;
PushCentro_d2<=PushCentro_d1;

arribaReg1<=arriba;
arribaReg2<=arribaReg1;

abajoReg1<=abajo;
abajoReg2<=abajoReg1;

izquierdaReg1<=izquierda;
izquierdaReg2<=izquierdaReg1;

derechaReg1<=derecha;
derechaReg2<=derechaReg1;


if (PushCentro_d1 && !PushCentro_d2) begin
InicioCrono<=~InicioCrono; //Enciende o apaga el cronometro
end

else begin
InicioCrono<=InicioCrono;
end

if (arribaReg1 && !arribaReg2) begin
ar<=1;end

else if (abajoReg1 && !abajoReg2) begin
ar<=1;end

else if (izquierdaReg1 && !izquierdaReg2) begin
ar<=1;end

else if (derechaReg1 && !derechaReg2) begin
ar<=1;end

else begin
ar<=0;
ab<=0;
iz<=0;
de<=0;

end




always @(posedge clk,posedge Reset)begin//Logica de reset y estado siguiente
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
    /*
    contador=contador+1'b1;
    if (contador==limit)            //Contador necesario para la duración de las señales
        begin
        contador <=0; //Reinicia el contador
        end
    end
*/

always @(posedge clk)
begin
/*
if(contador==limit)
begin*/
    s_next<=s_actual; //siguiente estado default el actual
    Crono <= 1'b0; //Default crono apagado
    case (s_actual)
        s0: begin //Estado Programar Cronometro
            if(Reset==0 && FinalizoCrono ==0 && ProgramarCrono==0 && InicioCrono==1)
                begin
                 CronoActivo <=1'b1;  //Para protocolo read
                 Ring <=1'b0;
                s_next<=s2;
                end
            if(Reset==0 && FinalizoCrono ==0 && ProgramarCrono==0 && InicioCrono==0)
                begin
                 CronoActivo <=1'b0;  //Para protocolo read
                 Ring <=1'b0;
                 s_next<=s1;
                 end
             if((ProgramarCrono==1 && reset ==0)| reset=1 | (FinalizoCrono==1 && reset=0))
                 begin
                 CronoActivo <=1'b0;  //Para protocolo read
                 Ring <=1'b0;
                 s_next<=s_actual;
                 end


            end
        s1: begin
            if(Reset==0 && FinalizoCrono ==0 && ProgramarCrono==0 && InicioCrono==0)
                begin
                CronoActivo <=1'b0;  //Para protocolo read
                Ring <=1'b0;
                s_next<=s_actual;
                end
             if(Reset==0 && FinalizoCrono ==0 && ProgramarCrono==0 && InicioCrono==1)
                begin
                CronoActivo <=1'b1;  //Para protocolo read
                Ring <=1'b0;
                s_next<=s2;
                end
             if(Reset==0 && FinalizoCrono ==1 && ProgramarCrono==0)
                begin
                CronoActivo <=1'b0;  //Para protocolo read
                Ring <=1'b1;
                s_next<=s3;
                end
             if(Reset==1  | (Reset==0 && FinalizoCrono ==0 && ProgramarCrono==1 && InicioCrono==0))
                begin
                CronoActivo <=1'b0;  //Para protocolo read
                Ring <=1'b0;
                s_next<=s0;
                end

            end
       s2:begin
            if(Reset==0 && FinalizoCrono ==0 && ProgramarCrono==0 && InicioCrono==1)
                begin
                CronoActivo <=1'b1;  //Para protocolo read
                Ring <=1'b0;
                s_next<=s_actual;
                end
            if(Reset==0 && FinalizoCrono ==1 && ProgramarCrono==0)
                begin
                CronoActivo <=1'b0;  //Para protocolo read
                Ring <=1'b1;
                s_next<=s3;
                end

            if(Reset==1  | (Reset==0 && FinalizoCrono ==0 && ProgramarCrono==1 && InicioCrono==0))
                begin
                CronoActivo <=1'b0;  //Para protocolo read
                Ring <=1'b0;
                s_next<=s0;
                end

            if(Reset==0 && FinalizoCrono ==0 && ProgramarCrono==0 && InicioCrono==0)
                begin
                CronoActivo <=1'b0;  //Para protocolo read
                Ring <=1'b0;
                s_next<=s1;
                end


        s3:begin
            if(reset==1 | (Reset==0 && FinalizoCrono ==0) | (Reset==0 && FinalizoCrono ==0 && ProgramarCrono==1 && InicioCrono==0))
                begin
                CronoActivo <=1'b1;  //Para protocolo read
                Ring <=1'b0;
                s_next<=s0;
                end



          end
          default: s_next<=s0;
    endcase
end







//Programar el Cronometro
reg horasReg=0,minutosReg=0,segundosReg=0;


localparam [3:0] ss = 4'h0, //inicialización
                 sm = 4'h1, //segundos
                 sh = 4'h2, //minutos
                 sC = 4'h3,//Crono corriendo



always @(posedge clk)

s_sig=s_actualcrono; //siguiente estado default el actual
horasReg=horasReg;
minutosReg=minutosReg;
segundosReg=segundosReg;

case (s_actualcrono)
    ss: begin //segundos
        if(!Reset && !PushInicioCrono && !FinalizoCrono  && ProgramarCrono)
            begin
            segundosReg=segundosReg;
            s_next<=s_actualcrono;
            end
        if( (ar) && !Reset && !PushInicioCrono && !FinalizoCrono && ProgramarCrono)
            begin
             segundosReg=segundosReg + 8'd1;
             s_next<=s_actualcrono;
             end
         if((ab) && !Reset && !PushInicioCrono && !FinalizoCrono && ProgramarCrono)
             begin
             segundosReg=segundosReg - 8'd1;
             s_next<=s_actualcrono;
             end

             if( (iz) && !Reset && !PushInicioCrono && !FinalizoCrono && ProgramarCrono)
                 begin
                  segundosReg=segundosReg;
                  s_next<=sm;
                  end
              if((de) && !Reset && !PushInicioCrono && !FinalizoCrono && ProgramarCrono)
                  begin
                  segundosReg=segundosReg;
                  s_next<=s_actualcrono;
                  end
                  if( Reset) //Estado
                      begin
                      horasReg=8'd0;
                      minutosReg=8'd0;
                      segundosReg=8'd0;
                      s_next<=ss;
                       end

                       if(!ProgramarCrono)
                           begin
                           horasReg=horasReg;
                           minutosReg=minutosReg;
                           segundosReg=segundosReg;
                           s_next<=sc;
                           end



        end
    sm: begin //Minutos
    if(!Reset && !PushInicioCrono && !FinalizoCrono  && ProgramarCrono)
        begin
        minutosReg=minutosReg;
        s_next<=s_actualcrono;
        end
    if( (ar) && !Reset && !PushInicioCrono && !FinalizoCrono && ProgramarCrono)
        begin
         minutosReg=minutosReg + 8'd1;
         s_next<=s_actualcrono;
         end
     if((ab) && !Reset && !PushInicioCrono && !FinalizoCrono && ProgramarCrono)
         begin
         minutosReg=minutosReg - 8'd1;
         s_next<=s_actualcrono;
         end

         if( (iz) && !Reset && !PushInicioCrono && !FinalizoCrono && ProgramarCrono)
             begin
              minutosReg=minutosReg;
              s_next<=sh;
              end
          if((de) && !Reset && !PushInicioCrono && !FinalizoCrono && ProgramarCrono)
              begin
              minutosReg=minutosReg;
              s_next<=ss;
              end

              if( Reset) //Estado
                  begin
                  horasReg=8'd0;
                  minutosReg=8'd0;
                  segundosReg=8'd0;
                  s_next<=ss;
                   end


                   if(!ProgramarCrono)
                       begin
                       horasReg=horasReg;
                       minutosReg=minutosReg;
                       segundosReg=segundosReg;
                       s_next<=sc;
                       end
   sc:begin//Correr
   if(!ProgramarCrono && !Reset)
       begin
       horasReg=horasReg;
       minutosReg=minutosReg;
       segundosReg=segundosReg;
       s_next<=s_actualcrono;
       end
   if( Reset) //Estado
       begin
       horasReg=8'd0;
       minutosReg=8'd0;
       segundosReg=8'd0;
       s_next<=ss;
        end


             sh:begin
             if(!Reset && !PushInicioCrono && !FinalizoCrono  )
                 begin
                 horasReg=horasReg;
                 s_next<=s_actualcrono;
                 end
             if( (ar) && !Reset && !PushInicioCrono && !FinalizoCrono)
                 begin
                  horasReg=horasReg + 8'd1;
                  s_next<=s_actualcrono;
                  end
              if((ab) && !Reset && !PushInicioCrono && !FinalizoCrono)
                  begin
                  horasReg=horasReg - 8'd1;
                  s_next<=s_actualcrono;
                  end

                  if( (iz) && !Reset && !PushInicioCrono && !FinalizoCrono)
                      begin
                       horasReg=horasReg;
                       s_next<=sm;
                       end
                   if((de) && !Reset && !PushInicioCrono && !FinalizoCrono)
                       begin
                       horasReg=horasReg;
                       s_next<=s_actualcrono;
                       end

                       if( Reset) //Estado
                           begin
                           horasReg=8'd0;
                           minutosReg=8'd0;
                           segundosReg=8'd0;
                           s_next<=ss;
                            end

                            if(!ProgramarCrono)
                                begin
                                horasReg=horasReg;
                                minutosReg=minutosReg;
                                segundosReg=segundosReg;
                                s_next<=sc;
                                end
endcase

assign horasSal=horasReg;
assign minutosSal=minutosReg;
assign segundosSal=segundosReg;


endmodule
