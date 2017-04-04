`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2017 05:52:45
// Design Name: 
// Module Name: Top_maquina_estados
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top_maquina_estados(
    input wire clk,
    input wire [7:0] dato_rtc,
    output wire [7:0] dir_out,
    output wire [7:0] dato,
    output wire RD_WR,
    input wire [3:0] switch,
    input wire [4:0] push,
    input wire crono_end,
    output wire ini_crono,
    output wire stop_crono,
    output wire ring,
    input wire reset
    );
wire [7:0] dir_out1, dir_out2, dir1, dir2; 
wire camb_crono,camb_hora, camb_fecha, reinicio, RD_WR1, RD_WR2, inistop_crono; 
wire [6:0] zero; 
   
    Control_lectura_escritura Control_lectura_escritura(
        .clk(clk),
        .reset(reset),
        .inistop_crono(inistop_crono),
        .switch(switch),
        .camb_hora1(camb_hora),
        .camb_fecha1(camb_fecha),
        .camb_crono1(camb_crono),
        .reinicio1(reinicio),
        .RD_WR(RD_WR1),
        .dir_in(dir1),
        .dir_out(dir2)
        );
        
       Control_direcciones_datos Control_direcciones_datos(
        .dir_in(dir2),
        .dir_out(dir1),
        .dir_rtc(dir_out1),
        .dato_rtc(dato_rtc),
        .dato(dato),
        .push(push[4:1]),
        .clk(clk),
        .camb_crono(camb_crono),
        .camb_hora(camb_hora),
        .camb_fecha(camb_fecha),
        .reinicio(reinicio),
        .reset(reset)
            );
            
       crono crono(
                .clk(clk),
                .WR_inistop(RD_WR2),
                .inistop({inistop_crono,stop_crono, ini_crono}),
                .dir(dir_out2),
                .ring(ring),
                .push(push[0]),
                .crono_end(crono_end),
                .reset(reset)
                );
        MUX MUX_dir(
            .clk(clk),
            .A(dir_out1),
            .B(dir_out2),
            .Y(dir_out),
            .sel(inistop_crono)
        );
        
        MUX MUX_rdwr(
            .clk(clk),
            .A({RD_WR1,7'b0000000}),
            .B({~RD_WR2,7'b0000000}),
            .Y({RD_WR, zero}),
            .sel(inistop_crono)
        );
endmodule
