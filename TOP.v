`timescale 1ns / 1ps
module TOP(
    input wire push_izquierda,
    input wire push_derecha,
    input wire push_arriba,
    input wire push_abajo,
    input wire Reset1,Escribir,
    input wire reset2,clk,ProgramarCrono,
    input wire push_centro,Inicio1,
    input wire [7:0] data_in,
    inout wire [7:0] DATA_ADDRESS,
    output reg [7:0] data_out,
    output wire ChipSelect,Read,Write,AoD //Señales de control rtc

    );
wire RW; //Variable OUTPUT MaquinaGeneral
wire Crono; //Variable OUTPUT MaquinaGeneral
wire Per_read; //Variable OUTPUT MaquinaGeneral

//MODULO MAQUINA GENERAL
MaquinaGeneral General_unit(.clk(clk), .Reset(Reset1), .Inicio1(Inicio1), .Escribir(Escribir),
                            .ProgramarCrono(ProgramarCrono),.RW(RW),.Crono(Crono),.Per_read(Per_read));


reg [7:0]address;  //direccion hacia rtc
reg [7:0]data_mod; //datos_modificados
wire [7:0] data_vga; //datos hacia controlador_vga
                            
Protocolo_rtc Proto_unit(.clk(clk),.bit_crono(Crono),.address(address),.DATA_WRITE(data_mod),.IndicadorMaquina(RW),
                         .ChipSelect(ChipSelect),.Read(Read),.Write(Write),.AoD(AoD),.DATA_ADDRESS(DATA_ADDRESS),
                         .data_vga(data_vga));

    
endmodule
