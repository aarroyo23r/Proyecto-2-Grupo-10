`timescale 1ns / 1ps
module generador_tb();
    wire ChipSelect1,Write1,Read1,AoD1;
    reg clk,IndicadorMaquina;

    
GeneradorFunciones Gd_tbunit(.clk(clk),.IndicadorMaquina(IndicadorMaquina),.ChipSelect1(ChipSelect1),.Read1(Read1),.Write1(Write1),.AoD1(AoD1));
initial 
    begin
    clk = 0;
    IndicadorMaquina = 1'b1;
    end   
    always
    begin
        #5 clk = ~clk;
    end
    always
    begin
           #2560 IndicadorMaquina =~IndicadorMaquina;
    end
endmodule




