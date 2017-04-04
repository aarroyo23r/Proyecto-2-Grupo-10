`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.04.2017 17:26:44
// Design Name: 
// Module Name: Control_direcciones_datos
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


module Control_direcciones_datos(
input wire [7:0] dir_in,
output wire [7:0] dir_out,
output wire [7:0] dir_rtc,
input wire [7:0] dato_rtc,
output wire [7:0] dato,
input wire [3:0] push,
input wire clk,
input wire camb_crono,
input wire camb_hora,
input wire camb_fecha,
input wire reinicio,
input wire reset
    );

wire [7:0] dir, dato_temp;
//wire [3:0]push_db;

 
Sumador_posicion Sumador_posicion(
    .dir_in(dir_in),
    .dir_out(dir),
    .push(push[1:0]),
    .clk(clk),
    .enable(camb_crono | camb_hora | camb_fecha),
    .camb_crono(camb_crono),
    .camb_hora(camb_hora),
    .camb_fecha(camb_fecha),
    .reset(reset)
);

MUX Selec_dir(
    .clk(clk),
    .A(dir_in),
    .B(dir),
    .Y(dir_out),
    .sel(camb_crono | camb_hora | camb_fecha)
);

ROM_addr ROM_addr(
    .clk(clk),
    .dir(dir_out),
    .dir_rtc(dir_rtc)
);

Sumador_dato Sumador_dato(
    .dato_rtc(dato_rtc),
    .dato(dato_temp),
    .push(push[3:2]),
    .clk(clk),
    .enable(camb_crono | camb_hora | camb_fecha)    
);

MUX Selec_dato(
    .clk(clk),
    .A(dato_temp),
    .B(8'b00000000),
    .Y(dato),
    .sel(reinicio)
);

/*
Debouncer DB1(
    .clk(clk),
	.signalInput(push[0]),
	.signalOutput(push_db[0]),
	.reset(!camb_crono & !camb_fecha & !camb_hora)
);

Debouncer DB2(
    .clk(clk),
	.signalInput(push[1]),
	.signalOutput(push_db[1]),
	.reset(!camb_crono & !camb_fecha & !camb_hora)
);

Debouncer DB3(
    .clk(clk),
	.signalInput(push[2]),
	.signalOutput(push_db[2]),
	.reset(!camb_crono & !camb_fecha & !camb_hora)
);

Debouncer DB4(
    .clk(clk),
	.signalInput(push[3]),
	.signalOutput(push_db[3]),
	.reset(!camb_crono & !camb_fecha & !camb_hora)
);*/
endmodule