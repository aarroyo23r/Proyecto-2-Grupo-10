`timescale 1ns / 1ps
module MaquinaEscritura(
    input wire Inicio,Reset,Crono,Escribir,
    input wire clk,Per_read,
    input wire RW,
    input wire push_arriba,push_abajo,push_izquierda,push_derecha,
    input wire [7:0]segundos,minutos,horas,date,num_semana,mes,ano,dia_sem,
    output reg [7:0] address,
    output reg reset2,
    output reg [7:0] minutosSal, segundosSal,horasSal,dateSal,
    output reg [7:0]data_mod
    );
reg [32:0]contador=0;
reg[3:0]c_dir=0;
localparam [3:0] s0 = 4'h1, 
                 s1 = 4'h2, //segundos
                 s2 = 4'h3, //minutos
                 s3 = 4'h4, //horas
                 s4 = 4'h5, //date
                 s5 = 4'h6, //mes
                 s6 = 4'h7, //año
                 s7 = 4'h8, //día de semana
                 s8 = 4'h9, //#de semana
                 sY = 4'h1; //estado 12/24hrs

reg [3:0] s_next=s1;reg [3:0] s_actual;
reg push_ar, push_ab, push_i, push_d; //salida del detector de flancos
reg push_ar1, push_ab1, push_i1, push_d1; //salida del detector de flancos
reg ar,ab,iz,de;//Pulsos
reg escribir3;reg escribir4; reg es;

always @ (posedge clk) begin
if (!Reset && Escribir) begin
push_ar<=push_arriba;
push_ar1<=push_ar;

escribir3<=Escribir;
escribir4<=escribir3;

push_ab<=push_abajo;
push_ab1<=push_ab;

push_d<=push_derecha;
push_d1<=push_d;

push_i<=push_izquierda;
push_i1<=push_i;
end

if (push_ar && !push_ar1) begin
ar<=1;end

else if (push_ab && !push_ab1) begin
ab<=1;end

else if (push_d && !push_d1) begin
de<=1;end

else if (push_i && !push_i1) begin
iz<=1;end

else if(escribir3 && !escribir4)begin
es<=1;end

else begin
es<=0;
ar<=0;
ab<=0;
iz<=0;
de<=0;
end
end


always @(posedge clk,posedge Reset)begin//Logica de Reset y estado siguiente
    if(Reset)begin
        s_actual <=s0;
    end
    else
        s_actual <=s_next;
end


reg suma;reg resta;reg[4:0] registro; 

reg [7:0]segundosReg;reg [7:0]minutosReg;reg[7:0]horasReg;reg [7:0]dateReg;
reg[7:0]minutosReg1,segundosReg1,horasReg1,dateReg1;




always@(posedge clk)
   begin
   if(!Escribir)begin
   minutosReg1<=minutos;
   segundosReg1<=segundos;
   horasReg1<=horas;
   dateReg1<=date;
   end
   minutosReg1<=minutosReg1;
   horasReg1<=horasReg1;
   segundosReg1<=segundosReg1;
   dateReg1<=dateReg1;
   end



always @(posedge clk) begin
//sumador
if(suma && !resta) begin
if(registro==0)begin
   segundosReg1<=segundosReg1;
   minutosReg1<=minutosReg1;
   horasReg1<=horasReg1;
   dateReg1<=dateReg1;
end
else if (registro==5'd1)begin
segundosReg1<=segundosReg1 + 1;
end

else if (registro==5'd2)begin
minutosReg1<=minutosReg1 + 1;
end

 else if(registro==5'd3)begin
horasReg1<=horasReg1+1;
end

 else if(registro==5'd4)begin
 dateReg1<=dateReg1+1;
 end
 
else begin
minutosReg1<=minutosReg1;
segundosReg1<=segundosReg1;
horasReg1<=horasReg1;
dateReg1<=dateReg1;
end
end


//Restador
else if(!suma && resta) begin
if(registro==5'd0)begin
    segundosReg1<=segundosReg1;
    minutosReg1<=minutosReg1;
    horasReg1<=horasReg1;
    dateReg1<=dateReg1;
end
else if (registro==5'd1)begin
segundosReg1<=segundosReg1 - 8'd1;
end

 else if (registro==5'd2)begin
minutosReg1<=minutosReg1 - 8'd1;
end

 else if(registro==5'd3)begin
horasReg1<=horasReg1-8'd1;
end

else if(registro ==5'h4)begin
dateReg1<=dateReg1-8'd1;
end

else begin
minutosReg1<=minutosReg1;
segundosReg1<=segundosReg1;
horasReg1<=horasReg1;
dateReg1<=dateReg1;
end

end

else begin
minutosReg1<=minutosReg1;
segundosReg1<=segundosReg1;
horasReg1<=horasReg1;
dateReg1<=dateReg1;
end
end

// fin de sumador y restador
//CONTADOR PARA DURACIÓN DE ESTADO DE INICIALIZACIÓN
reg [11:0] contador2=0;
reg activa=0;
always @(posedge clk)
begin
if(!Inicio && !Reset)
begin
    contador2<=contador2 +1'b1;
    activa<=0;
end
if(contador2==12'h04a)
begin
    activa<=1;
end
end


//Maquina programar hora
always @ (posedge clk)  begin
s_next=s_actual; //siguiente estado default el actual
minutosReg1<=minutosReg1;
segundosReg1<=segundosReg1;
horasReg1<=horasReg1;
dateReg1<=dateReg1;
case (s_actual)
    s1: begin //segundos
        if(!Reset && Escribir && !ar && !ab && !iz && !de)begin
            reset2<=1'b0;
            registro<=5'd0;
            address<=8'h21;
            suma<=0;
            resta<=0;
            s_next<=s1;
            end
        if((ar) && !Reset && Escribir)begin
            reset2<=1'b0;
            registro<=5'd1;
            address<=8'h21;
            suma<=1;
            resta<=0;
             //segundosReg<=segundosReg + 8'd1;
             s_next<=s1;
             end
         if((ab) && !Reset && Escribir)begin
            reset2<=1'b0;
             registro<=5'd1;
             address<=8'h21;
             resta<=1;
             suma<=0;
             //segundosReg<=segundosReg - 8'd1;
             s_next<=s1;
             end

             if( (iz) && !Reset && Escribir)begin
                 reset2<=1'b0;
                 registro<=5'd0;
                 address<=8'h22;
                 suma<=0;
                 resta<=0;
                  //segundosReg<=segundosReg;
                  s_next<=s2;
                  end
              if((de) && !Reset && Escribir)
                  begin
                  reset2<=1'b0;
                  registro<=5'd0;
                  address<=8'h21;
                  suma<=0;
                  resta<=0;
                  //segundosReg<=segundosReg;
                  s_next<=s1;
                  end
                  if(Reset) //Estado
                      begin
                      reset2<=1'b0;
                      registro<=5'd0;
                      address<=8'h21;
                      suma<=0;
                      resta<=0;
                      s_next<=s1;
                       end
        end
        
        
    s2: begin //horas
    if(!Reset && Escribir && !ar && !ab && !iz && !de)
        begin
        reset2<=1'b0;
        registro<=5'd0;
        address<=8'h22;
        suma<=0;
        resta<=0;
        //minutosReg<=minutosReg;
        s_next<=s_actual;
        end
    if( (ar) && !Reset && Escribir)
        begin
        reset2<=1'b0;
        registro<=5'd2;
        address<=8'h22;
        suma<=1;
        resta<=0;
         //minutosReg<=minutosReg + 8'd1;
         s_next<=s_actual;
         end
     if((ab) && !Reset && Escribir)
         begin
         reset2<=1'b0;
         registro<=5'd2;
         address<=8'h22;
         suma<=0;
         resta<=1;
         //minutosReg<=minutosReg - 8'd1;
         s_next<=s_actual;
         end

         if( (iz) && !Reset && Escribir)
             begin
             reset2<=1'b0;
             registro<=5'd0;
             address<=8'h23;
             suma<=0;
             resta<=0;
              //minutosReg<=minutosReg;
              s_next<=s3;
              end
          if((de) && !Reset && Escribir)
              begin
              reset2<=1'b0;
              registro<=5'd0;
              address<=8'h21;
              suma<=0;
              resta<=0;
              //minutosReg<=minutosReg;
              s_next<=s1;
              end

              if( Reset) //Estado
                  begin
                  reset2<=1'b0;
                  registro<=5'd0;
                  address<=8'h21;
                  suma<=0;
                  resta<=0;
                  s_next<=s1;
                  end
     end
    s3: begin //Minutos
         if(!Reset && Escribir && !ar && !ab && !iz && !de)
             begin
             reset2<=1'b0;
             registro<=5'd0;
             address<=8'h23;
             suma<=0;
             resta<=0;
             //minutosReg<=minutosReg;
             s_next<=s_actual;
             end
         if( (ar) && !Reset && Escribir)
             begin
             reset2<=1'b0;
             registro<=5'd3;
             address<=8'h23;
             suma<=1;
             resta<=0;
              //minutosReg<=minutosReg + 8'd1;
              s_next<=s_actual;
              end
          if((ab) && !Reset && Escribir)
              begin
              reset2<=1'b0;
              registro<=5'd3;
              address<=8'h23;
              suma<=0;
              resta<=1;
              //minutosReg<=minutosReg - 8'd1;
              s_next<=s_actual;
              end
     
              if( (iz) && !Reset && Escribir)
                  begin
                  reset2<=1'b0;
                  registro<=5'd0;
                  address<=8'h24;
                  suma<=0;
                  resta<=0;
                   //minutosReg<=minutosReg;
                   s_next=s4;
                   end
               if((de) && !Reset && Escribir)
                   begin
                   reset2<=1'b0;
                   registro<=5'd0;
                   address<=8'h22;
                   suma<=0;
                   resta<=0;
                   //minutosReg<=minutosReg;
                   s_next<=s2;
                   end
     
                   if( Reset) //Estado
                       begin
                       reset2<=1'b0;
                       registro<=5'd0;
                       address<=8'h21;
                       suma<=0;
                       resta<=0;
                       s_next<=s1;
                       end
          end 
     s4: begin //Minutos
                   if(!Reset && Escribir && !ar && !ab && !iz && !de)
                       begin
                       reset2<=1'b0;
                       registro<=5'd0;
                       address<=8'h24;
                       suma<=0;
                       resta<=0;
                       //minutosReg<=minutosReg;
                       s_next<=s_actual;
                       end
                   if( (ar) && !Reset && Escribir)
                       begin
                       reset2<=1'b0;
                       registro<=5'h4;
                       address<=8'h24;
                       suma<=1;
                       resta<=0;
                        //minutosReg<=minutosReg + 8'd1;
                        s_next<=s_actual;
                        end
                    if((ab) && !Reset && Escribir)
                        begin
                        reset2<=1'b0;
                        registro<=5'h4;
                        address<=8'h24;
                        suma<=0;
                        resta<=1;
                        //minutosReg<=minutosReg - 8'd1;
                        s_next<=s_actual;
                        end
               
                        if( (iz) && !Reset && Escribir)
                            begin
                            reset2<=1'b0;
                            registro<=5'd0;
                            address<=8'h24;
                            suma<=0;
                            resta<=0;
                             //minutosReg<=minutosReg;
                             s_next=s4;
                             end
                         if((de) && !Reset && Escribir)
                             begin
                             reset2<=1'b0;
                             registro<=5'd0;
                             address<=8'h23;
                             suma<=0;
                             resta<=0;
                             //minutosReg<=minutosReg;
                             s_next<=s3;
                             end
               
                             if( Reset) //Estado
                                 begin
                                 reset2<=1'b0;
                                 registro<=5'd0;
                                 address<=8'h21;
                                 suma<=0;
                                 resta<=0;
                                 s_next<=s1;
                                 end
                    end 
endcase
end


always@*
begin
minutosSal=minutosReg1;
segundosSal=segundosReg1;
horasSal=horasReg1;
dateSal=dateReg1;
end

always@*
begin
  if(address==8'h21)begin
    data_mod<=segundosReg1;
    end
  else if(address==8'h22)begin
    data_mod<=minutosReg1;
    end
  else if(address==8'h23)begin
    data_mod<=horasReg1;
    end
  else if(address==8'h24)begin
    data_mod<=dateReg1;
    end
end

endmodule
