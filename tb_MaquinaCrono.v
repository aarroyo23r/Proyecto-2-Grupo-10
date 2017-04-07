`timescale 1ns / 1ps


module tb_MaquinaCrono();
   wire Reset,clk;
   wire ProgramarCrono,FinalizoCrono,InicioCrono;
   reg CronoActivo,Ring;

 Interfaz uut(
           .clk(clk),.reset(reset),.ProgramarCrono(ProgramarCrono)
           ,.FinalizoCrono(FinalizoCrono),.InicioCrono(InicioCrono)
           ,.CronoActivo(CronoActivo),.Ring(Ring)

           );

 initial begin
Reset=1;
#20

s0:

 S2
Reset==0;
FinalizoCrono ==0;
ProgramarCrono==0;
InicioCrono==1;
#50;

S1
Reset==0;
FinalizoCrono ==0;
ProgramarCrono==0;
InicioCrono==0;
#50;

S0
ProgramarCrono==1;
reset ==0;
#50;

reset=1;
#50;

FinalizoCrono==1;
reset=0;
#50;



s1:

S1
Reset==0;
FinalizoCrono ==0;
ProgramarCrono==0;
InicioCrono==0;
#50;

S2
Reset==0;
FinalizoCrono ==0;
ProgramarCrono==0;
InicioCrono==1;
#50;

S3
Reset==0;
FinalizoCrono ==1;
ProgramarCrono==0;
#50;

S0
Reset==1;
Reset==0;
FinalizoCrono ==0;
ProgramarCrono==1;
InicioCrono==0;
#50;

s2:

S2
Reset==0;
FinalizoCrono ==0;
ProgramarCrono==0;
InicioCrono==1;
#50;

S3
Reset==0;
FinalizoCrono ==1;
ProgramarCrono==0;
#50;

S0
Reset==1;
#50;
Reset==0;
FinalizoCrono ==0;
ProgramarCrono==1;
InicioCrono==0;
#50;

S1
Reset==0;
FinalizoCrono ==0;
ProgramarCrono==0;
InicioCrono==0;
#50;


s3:

S0
reset==1;
#50;
Reset==0;
FinalizoCrono ==0;
#50;

Reset==0;
FinalizoCrono ==0;
ProgramarCrono==1;
InicioCrono==0;
#50;
 end

 always
 begin
clk=~clk;
#5;
 end


 endmodule
