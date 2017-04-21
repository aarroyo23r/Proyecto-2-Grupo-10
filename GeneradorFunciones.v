`timescale 1ns / 1ps

module GeneradorFunciones(     //Definicion entradas y salidas
    input wire clk,  //variable que reinicia los contadores, se reinicia con un 1
    input wire IndicadorMaquina,  //Señal que indica acción que se esta realizando // En cero ejecuta señales Write y en 1 señales read
    output reg ChipSelect,Read,Write,AoD, //Señales de entrada del RTC
    output reg [6:0] contador2,contador
    );
       


assign contador1=contador2;           
always @(posedge clk)
   begin
      contador2<=contador2 +6'd1; //contador para general señal
      if(contador2==6'd37)
        begin
        contador2<=6'd01;
        end
   end
   
   
   always @(posedge clk)
      begin
         contador<=contador +6'd1; //contador para modulo cuenta el doble del anterior
         if(contador==8'h4a)
           begin
           contador<=8'h01;
           end
      end



always @(posedge clk)
begin
  if(IndicadorMaquina)
    begin
    if((contador2>=6'd01 && contador2<=6'd8)|(contador2>=6'd20 && contador2<=6'd27))
        begin
        ChipSelect<=0;
        end
        else begin
        ChipSelect<=1;
        end
    if((contador2>=6'd01 && contador2<=6'd8))
        begin
        AoD<=0;
        end
        else begin
        AoD<=1;
        end
     if((contador2>=6'd02 && contador2<=6'd7))
        begin
        Write<=0;
        end
        else begin
        Write<=1;
        end
     if((contador2>=6'd21 && contador2<=6'd26))
        begin
        Read<=0;
        end
        else begin
        Read<=1;
        end            
    end
    else
    begin
    if((contador2>=6'd01 && contador2<=6'd8)|(contador2>=6'd20 && contador2<=6'd27))
        begin
        ChipSelect<=0;
        end
        else begin
        ChipSelect<=1;
        end
    if((contador2>=6'd01 && contador2<=6'd8))
        begin
        AoD<=0;
        end
        else begin
        AoD<=1;
        end
    if((contador2>=6'd02 && contador2<=6'd7)|(contador2>=6'd21 && contador2<=6'd26))
        begin
        Write<=0;
        end
        else begin
        Write<=1;
        end
     if((contador2>=6'd21 && contador2<=6'd26))
        begin
        Read<=1;
        end
        else begin
        Read<=1;
        end            
    end
end   
endmodule
