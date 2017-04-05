`timescale 1ns / 1ps

module MaquinaGeneral(
    input wire Reset,clk,
    input wire Inicio,Escribir,
    input wire ProgramarCrono,
    output reg RW,
    output reg Crono
    );
 //declaracion de estados
localparam[1:0] s0 = 2'b00, //Estado Escribir
                s1 = 2'b01, //Estado Leer
                s2 = 2'b10; //Estado Programar Crono    
localparam [11:0] limit = 12'h100;            
 //señales de estado
 reg[1:0]s_actual,s_next; 
 reg [11:0] contador=0;
//registro de estados
always @(posedge clk,posedge Reset)begin
    if(Reset)begin
        s_actual <=s0;
    end
    else
        s_actual <=s_next;
end

always @(posedge clk)
    begin
    contador=contador+1'b1;
    if (contador==limit)            //Contador necesario para la duración de las señales
        begin
        contador <=0;
        end
    end

always @(posedge clk)
begin
if(contador==limit)
begin
    s_next<=s_actual; //siguiente estado default el actual
    RW <=1'b1;  //salida default de leer
    Crono <= 1'b0; //salida default de leer
    case (s_actual)
        s0: begin //Estado Escribir
            if(Reset==0 && Inicio ==0 && ProgramarCrono==0 && Escribir==0)
                begin
                 RW <=1'b1;  //Para protocolo read
                 Crono <=1'b0;
                s_next<=s1;
                end
            if((Reset==0 && Inicio==1)|(Reset==1)|(Reset==0 && Inicio==0 && Escribir==1 && ProgramarCrono==1)|(Reset==0 && Inicio==0 && Escribir==1 && ProgramarCrono==0))
                begin
                 RW <= 1'b0; //Para protocolo write
                 Crono <=1'b0;
                s_next<=s_actual;
                end
            if(!Reset && !Inicio && !Escribir && ProgramarCrono)
                begin
                 RW<=1'b1; //para protocolo read
                 Crono <=1'b0;
                 s_next <=s1;
                end
            end
        s1: begin
              if(!Reset && !Inicio && !ProgramarCrono && !Escribir)
                begin
                 RW <=1'b1; //Para protocolo read
                 Crono <=1'b0;
                 s_next <=s_actual;
              end
              if(!Reset && !Inicio && !Escribir && ProgramarCrono)
                begin
                 RW <=1'b0; //Para protocolo Write //DIFERENTE AL DIAGRAMA
                 Crono <=1'b1;
                 s_next <= s2;
                end
              if((Reset)|(!Reset && Inicio)|(!Reset && !Inicio && Escribir && !ProgramarCrono))
                begin
                RW <= 1'b0; //Para protocolo Write 
                Crono <=1'b0;
                s_next <= s0;
                end
            end
       s2:begin
            if(Reset |(!Reset && Inicio))
                begin
                RW <=1'b0; //Para protocolo Write
                Crono <=1'b0;
                s_next <=s0;
                end
             if((!Reset && !Inicio && !Escribir && !ProgramarCrono)|(!Reset && !Inicio && Escribir && ProgramarCrono))
                begin
                RW <=1'b1; //Para protocolo READ
                Crono <=1'b0;
                s_next <= s1;
                end
             if(!Reset && !Inicio && !Escribir && ProgramarCrono)
                begin
                RW<= 1'b1;
                Crono <=1'b1;
                s_next <= s1;
                end
          end
          default: s_next<=s0;                    
    endcase
end
end   
endmodule
