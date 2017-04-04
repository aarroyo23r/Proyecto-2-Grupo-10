`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2017 06:43:31
// Design Name: 
// Module Name: Top_maquinas_tb
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


module Top_maquinas_tb(

    );
    
    reg clk;
    reg [7:0] dato_rtc;
    wire [7:0] dir_out;
    wire [7:0] dato;
    wire RD_WR;
    reg [3:0] switch;
    reg [4:0] push;
    reg crono_end;
    wire ini_crono;
    wire stop_crono;
    wire ring;
    reg reset;
    
    
    Top_maquina_estados Top_maquina_estados(
        .clk(clk),
        .dato_rtc(dato_rtc),
        .dir_out(dir_out),
        .dato(dato),
        .RD_WR(RD_WR),
        .switch(switch),
        .push(push),
        .crono_end(crono_end),
        .ini_crono(ini_crono),
        .stop_crono(stop_crono),
        .ring(ring),
        .reset(reset)
        );
        
        initial
        begin
        clk=0;
        reset=1;
        switch=0;
        push=0;
        dato_rtc=0;
        crono_end=0;
        #10 reset=0;
        end
        
        always
        begin
        #51000 switch=1;
        #10 push=4;
        #10000 push=2;
        #10000 push=16;
        #10000 push=8;
        #10000 push=1;
        #10 switch=0;
        #10 push=0;
        #10 push=1;
        #5100 push =0;
        #10 crono_end=1;
        #10 crono_end=0;
        end
        
        always
        begin
        #5 clk=~clk;
        end
endmodule
