`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.04.2017 08:03:52
// Design Name: 
// Module Name: Control_lectura_escritura
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


module Control_lectura_escritura(
    input wire clk,
    input wire reset,
    input wire inistop_crono,
    input wire [3:0] switch,
    output wire camb_hora1,
    output wire camb_fecha1,
    output wire camb_crono1,
    output wire reinicio1,
    output wire RD_WR,
    input wire [7:0] dir_in,
    output wire [7:0] dir_out
    );

wire [5:0] enable, RD_t, WR_t, ready_t;
wire ready, RD, WR, reinicio2, reset1;
wire [7:0] dir_out1, dir_out2, dir_out3, dir_out4, dir_out5, dir_out6;
wire [4:0]zero;

assign RD_WR= 1'b1 & !WR;

Bloque_control_general Control_enable(
        .clk(clk),
        .reset(reset),
        .switch(switch),
        .inistop_crono(inistop_crono),
        .enable(enable),
        .ready(ready)
        );
    
 iniciar iniciar(
        .clk(clk),
        .enable(enable[5]),
        .dir(dir_out1),
        .reset(reset1),
        .WR(WR_t[0]),
        .RD(RD_t[0]),
        .ready(ready_t[0])
        );
    
    leer_rtc leer_rtc(
        .enable(enable[4]),
        .reset(reset),
        .RD(RD_t[1]),
        .WR(WR_t[1]),
        .clk(clk),
        .dir_rd(dir_out2),
        .ready(ready_t[1])
        );
        
    camb_crono camb_crono(
        .clk(clk),
        .enable(enable[3]),
        .dir_in(dir_in),
        .dir_out(dir_out3),
        .camb_crono(camb_crono1),
        .WR(WR_t[2]),
        .RD(RD_t[2]),
        .ready(ready_t[2]),
        .reset(reset)
        );  
        
    camb_hora camb_hora(
            .clk(clk),
            .enable(enable[2]),
            .dir_in(dir_in),
            .dir_out(dir_out4),
            .camb_hora(camb_hora1),
            .WR(WR_t[3]),
            .RD(RD_t[3]),
            .ready(ready_t[3]),
            .reset(reset)
            ); 
    camb_fecha camb_fecha(
            .clk(clk),
            .enable(enable[1]),
            .dir_in(dir_in),
            .dir_out(dir_out5),
            .camb_fecha(camb_fecha1),
            .WR(WR_t[4]),
            .RD(RD_t[4]),
            .ready(ready_t[4]),
            .reset(reset)
            ); 
    Reiniciar_crono Reiniciar_crono(
            .clk(clk),
            .enable(enable[0]),
            .dir_out(dir_out6),
            .reinicio(reinicio2),
            .WR(WR_t[5]),
            .RD(RD_t[5]),
            .ready(ready_t[5]),
            .reset(reset)
            );
               
 MUX MUX(
    .clk(clk),
    .A(reinicio2),
    .B(reset1),
    .Y(reinicio1),
    .sel(enable[5])
 );  
 
 MUX6a1 MUX6a1(
    .clk(clk),
    .A({5'b00000,RD_t[0], WR_t[0], ready_t[0]}),
    .B({5'b00000,RD_t[1], WR_t[1], ready_t[1]}),
    .C({5'b00000,RD_t[2], WR_t[2], ready_t[2]}),
    .D({5'b00000,RD_t[3], WR_t[3], ready_t[3]}),
    .E({5'b00000,RD_t[4], WR_t[4], ready_t[4]}),
    .F({5'b00000,RD_t[5], WR_t[5], ready_t[5]}),
    .Y({zero,RD, WR, ready}),
    .sel(enable)
 );  
 
 MUX6a1 MUXdir_out(
    .clk(clk),
    .A(dir_out1),
    .B(dir_out2),
    .C(dir_out3),
    .D(dir_out4),
    .E(dir_out5),
    .F(dir_out6),
    .Y(dir_out),
    .sel(enable)
 );       
    
endmodule
