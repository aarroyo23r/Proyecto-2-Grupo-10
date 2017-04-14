`timescale 1ns / 1ps
module MaquinaLectura(

    input wire clk,
    input wire RW,
    output reg [7:0] address
    ); 
localparam [11:0] limit = 12'h100; //tiempo en el que la dirección se mantiene             
reg [11:0] contador=0;  
reg reset;
reg [3:0] c_dir=0;
 

always @(posedge clk)
begin
    if(RW)
    begin
    contador<=contador + 1'b1;
    if(contador==limit)
    begin
        contador<=0;
        c_dir<=c_dir +1'b1;
        if(c_dir==4'b1010)
            begin
            c_dir<=0;
            end
    end
    end
    if(!RW)begin
    contador<=0;
    c_dir<=0;
end
end

always @(posedge clk)
begin
if(RW)
begin
case(c_dir)
    4'b0000:
        begin
        address<=8'h21;
        end
     4'b0001:
        begin
        address<=8'h22;
        end
     4'b0010:
        begin
        address<=8'h23;
        end
     4'b0011:
        begin
        address<=8'h24;
        end
     4'b0100:
        begin
        address<=8'h25;
        end
     4'b0101:
        begin
        address <=8'h26;
        end
     4'b0110:
        begin
        address<=8'h27;
        end
     4'b0111:
        begin
        address<=8'h28;
        end
     4'b1000:
        begin
        address<=8'h41;
        end
     4'b1001:
        begin
        address<=8'h42;
        end
     4'b1010:
        begin
        address<=8'h43;
        end        
     default:address <=8'hZZ;    
endcase
end
else
address<=8'hZZ;
end
        
endmodule
