`timescale 1ns / 1ps
module Registros(
    input wire clk,

    input wire IndicadorMaquina,
    input wire [7:0] contador,
    input wire Write,AoD,

    input wire Read,


    input wire [6:0] contador_todo,
    input wire [7:0] data_vga,
    input wire [7:0]address,
    output wire [7:0] datos0,
    output wire [7:0] datos1,
    output wire [7:0] datos2,
    output wire [7:0] datos3,
    output wire [7:0] datos4,
    output wire [7:0] datos5,
    output wire [7:0] datos6,
    output wire [7:0] datos7,
    output wire [7:0] datos8,
    output wire [7:0] datos9,
    output wire [7:0] datos10
    );

reg [7:0]data_0;reg [7:0]data_1;reg [7:0]data_2;
reg [7:0]data_3;reg [7:0]data_4;reg [7:0]data_5;reg [7:0]data_6;
reg [7:0]data_7;reg [7:0]data_8;reg [7:0]data_9;reg [7:0]data_10;

//reg [7:0] address_reg;

assign datos0=data_0; assign datos1=data_1;assign datos2=data_2;assign datos3=data_3;assign datos4=data_4;
assign datos5=data_5;assign datos6=data_6;assign datos7=data_7;assign datos8=data_8;assign datos9=data_9;
assign datos10=data_10;




always@(posedge clk)begin
    //address_reg<=address;

    if(address==8'h22 && !AoD)begin
      data_0<=data_vga;
       //data_0<=1;

    end
    else if(address==8'h23 && !AoD)begin
        data_1<=data_vga;
        //data_1<=2;

    end
    else if(address==8'h24 && !AoD)begin
            data_2<=data_vga;
            //data_1<=2;

        end
    else if(address==8'h25 && !AoD )begin
                data_3<=data_vga;
                //data_1<=2;

            end
    else if(address==8'h26 && !AoD)begin
                    data_4<=data_vga;
                    //data_1<=2;

                end
    else if(address==8'h27 && !AoD)begin
                        data_5<=data_vga;
                        //data_1<=2;

                    end
    else if(address==8'h28 && !AoD)begin
                            data_6<=data_vga;
                            //data_1<=2;

                        end
    else if(address==8'h41 &&!AoD)begin
                                data_7<=data_vga;
                                //data_1<=2;

                            end

    //Cronometro
    else if(address==8'h42 && !AoD)begin
                                    data_8<=data_vga;
                                    //data_1<=2;

                                end
    else if(address==8'h43 && !AoD)begin
                                        data_9<=data_vga;
                                        //data_1<=2;

                                    end
    else if(address==8'h21 &&  !AoD)begin
                                            data_10<=data_vga;
                                            //data_1<=2;

                                        end

    else begin
          data_0<=data_0;
          data_1<=data_1;
          data_2<=data_2;
          data_3<=data_3;
          data_4<=data_4;
          data_5<=data_5;
          data_6<=data_6;
          data_7<=data_7;
          data_8<=data_8;
          data_9<=data_9;
          data_10<=data_10;

    end

end




endmodule
