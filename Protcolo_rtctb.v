`timescale 1ns / 1ps
module Protocolo_rtctb();
    wire ChipSelect,Write,Read,AoD;
    reg clk,IndicadorMaquina;
    reg [7:0] address;
    reg [7:0] DATA_WRITE;
    wire [7:0] in_out;
    reg camb_fecha,camb_hora,camb_crono;
    wire [7:0] data_vga;
    
Protocolo_rtc protcolo_tbunit(.clk(clk),.address(address),.DATA_WRITE(DATA_WRITE),.IndicadorMaquina(IndicadorMaquina)
                             ,.ChipSelect(ChipSelect),.Write(Write),.Read(Read),.AoD(AoD),.DATA_ADDRESS(in_out)
                             ,.data_vga(data_vga),.camb_hora(camb_hora),.camb_fecha(camb_fecha),.camb_crono(camb_crono));
                             
initial
    begin
    clk=0;
    IndicadorMaquina =1'b1;
    address=8'b00001010;
    DATA_WRITE=8'b00001111;
    camb_hora =1'b0;
    camb_fecha=1'b0;
    camb_crono=1'b0;
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