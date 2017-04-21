`timescale 1ns / 1ps

module MaquinaGeneral(
    input wire Reset,clk,
    input wire Inicio1,Escribir,
    input wire ProgramarCrono,
    output reg RW,
    output reg Crono,
    output reg Per_read
    );
 wire Inicio;
 reg [1:0]estado;
 assign Inicio = Inicio1;
 //declaracion de estados
localparam[1:0] s0 = 2'b00, //Estado Escribir
                s1 = 2'b01, //Estado Leer
                s2 = 2'b10; //Estado Programar Crono    
localparam [7:0] limit = 8'h4a;            
 //señales de estado
 reg[1:0]s_actual=s0;
 reg [1:0]s_next; 
 reg [11:0] contador=0;
//registro de estados
always @(posedge clk,posedge Reset)begin
    if(Reset)begin
        s_actual <=s0;
    end
    else
        s_actual <=s_next;
end

always@(posedge clk)
begin
    estado<=s_actual;
end

reg activa=0;
always @(posedge clk)
    begin
    contador=contador+1'b1;
    activa<=0;
    if (contador==limit)            //Contador necesario para la duración de las señales
        begin
        contador<=0;
        activa<=1;
        end
    end
    
    
    
always@(posedge clk)
begin
if(!Reset && !Inicio && !ProgramarCrono && !Escribir)
begin
Per_read<=1;
end
else begin
Per_read<=0;
end
end    
  
  
  
  
    
always @(posedge activa)
begin
    s_next=s_actual; //siguiente estado default el actual
    case (s_actual)
        s0: begin //Estado Escribir
            if(Reset==0 && Inicio ==0 && ProgramarCrono==0 && Escribir==0 )
                begin
                RW=1'b1;  //Para protocolo read
                Crono =1'b0;
                s_next=s1;

                end
            if((Reset==0 && Inicio==1)|(Reset==1)|(Reset==0 && Inicio==0 && Escribir==1 && ProgramarCrono==1)|(Reset==0 && Inicio==0 && Escribir==1 && ProgramarCrono==0))
                begin
               
                RW = 1'b0; //Para protocolo write
                Crono =1'b0;
                s_next=s_actual;

                end
            if(!Reset && !Inicio && !Escribir && ProgramarCrono )
       
                begin
                RW=1'b1; //para protocolo read
                Crono =1'b0;
                s_next =s1;
 
                end

            if(!Reset && !Inicio && Escribir && !ProgramarCrono)
            
                begin
                Crono=1'b0;
                RW=1'b1;
                s_next=s1;
                end
            end
            
        s1: begin
              if(!Reset && !Inicio && !ProgramarCrono && !Escribir)
                begin
                 RW =1'b1; //Para protocolo read
                 Crono =1'b0;
                 s_next =s_actual;
              end
              if(!Reset && !Inicio && !Escribir && ProgramarCrono)
                begin
                 RW =1'b0; //Para protocolo Write //DIFERENTE AL DIAGRAMA
                 Crono =1'b1;
                 s_next = s2;
                end
               
              if((Reset)|(!Reset && Inicio)|(!Reset && !Inicio && Escribir && !ProgramarCrono))
                begin
                RW = 1'b0; //Para protocolo Write 
                Crono =1'b0;
                s_next = s0;
                end
            end
       s2:begin
            if(Reset |(!Reset && Inicio))
                begin
                RW =1'b0; //Para protocolo Write
                Crono =1'b0;
                s_next =s0;
                end
             if((!Reset && !Inicio && !Escribir && !ProgramarCrono)|(!Reset && !Inicio && Escribir && ProgramarCrono))
                begin
                RW =1'b1; //Para protocolo READ
                Crono =1'b0;
                s_next = s1;
                end
             if(!Reset && !Inicio && !Escribir && ProgramarCrono)
                begin
                RW= 1'b1;
                Crono =1'b1;
                s_next = s1;
                end
          end
          default: s_next<=s0;                    
    endcase
end
endmodule
