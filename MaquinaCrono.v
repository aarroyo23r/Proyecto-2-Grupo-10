`timescale 1ns / 1ps

module MaquinaCrono(
    input wire Reset,clk,
    input wire ProgramarCrono,FinalizoCrono,InicioCrono,
    output reg CronoActivo,Ring,
    );
 //declaracion de estados
localparam[1:0] s0 = 2'b00, //Estado Programar Cronometro
                s1 = 2'b01, //Estado Cronometro Inactivo
                s2 = 2'b10, //Estado Cronometro Activo
                s3 = 2'b11; //Estado Finalizo Cronometro
localparam [11:0] limit = 12'h100;
 //señales de estado
 reg[1:0]s_actual,s_next;
 reg [11:0] contador=0;
//registro de estados
always @(posedge clk,posedge Reset)begin//Logica de reset y estado siguiente
    if(Reset)begin
        s_actual <=s0
    end
    else
        s_actual <=s_next;
end

always @(posedge clk)
    begin
    contador=contador+1'b1;
    if (contador==limit)            //Contador necesario para la duración de las señales
        begin
        contador <=0; //Reinicia el contador
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
end
endmodule
