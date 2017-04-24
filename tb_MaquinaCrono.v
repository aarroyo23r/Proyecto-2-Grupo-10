module tb_MaquinaCrono();

   reg Reset,clk;
   reg ProgramarCrono,PushInicioCrono;
    //input wire [7:0] horas,minutos,segundos,
    reg arriba,abajo,izquierda,derecha;
    wire CronoActivo,Ring;
    wire [7:0] horasSal,minutosSal,segundosSal;

    always
    begin
   clk=~clk;
   #5;
    end


   MaquinaCrono uut(
        .Reset(Reset),.clk(clk),
        .ProgramarCrono(ProgramarCrono),.PushInicioCrono(PushInicioCrono),
        .arriba(arriba),.abajo(abajo),.izquierda(izquierda),.derecha(derecha),
        .CronoActivo(CronoActivo),.Ring(Ring),
        .horasSal(horasSal),.minutosSal(minutosSal),.segundosSal(segundosSal)
        ,.horas(horas),.minutos(minutos),.segundos(segundos)
        );


initial begin
Reset=0;
clk=0;
ProgramarCrono=0;
PushInicioCrono=0;
arriba=0;
abajo=0;
izquierda=0;
derecha=0;

#100;

ProgramarCrono=1;
#40;

arriba=1;
#30;
arriba=0;
#20;


arriba=1;
#30;
arriba=0;
#20;


arriba=1;
#30;
arriba=0;
#20;


arriba=1;
#30;
arriba=0;
#20;


arriba=1;
#30;
arriba=0;
#20;


abajo=1;
#30;

izquierda=1;
#30;
izquierda=0;
#20;

izquierda=1;//Pasa a minutos
#30;

arriba=1;
#30;

ProgramarCrono=0;
PushInicioCrono=1;
#70;

$finish;

end

endmodule
