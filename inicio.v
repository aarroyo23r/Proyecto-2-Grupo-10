`timescale 1ns / 1ps


module inicializacion(
    input wire clk,
    input wire Inicio1,
    output reg[7:0] data_mod,
    output reg [7:0] address
    );
localparam [11:0] limit = 12'd36; //tiempo en el que la dirección se mantiene
    reg [11:0] contador=0;
    reg reset;
    reg [3:0] c_dir=0;


    always @(posedge clk)
    begin
        if(Inicio1)
        begin
        contador<=contador + 1'b1;
        if(contador==limit)
        begin
            contador<=0;
            c_dir<=c_dir +1'b1;
            if(c_dir==4'b0001)
                begin
                c_dir<=0;
                end
        end
        end
        if(!Inicio1)begin
        contador<=0;
        c_dir<=0;
    end
    end



    always @(posedge clk)
    begin
    if(Inicio1)
    begin
    case(c_dir)
        4'b0000:
            begin
            address<=8'h02;
            data_mod<=8'h08;//Activa crono
            end
         4'b0001:
            begin
            address<=8'h02;
            data_mod<=8'h00;//Desactiva Crono
            end
         default:address<=8'hZZ;
    endcase
    end
    else
    address<=8'hZZ;
    end


endmodule
