`timescale 1ns / 1ps

module GeneradorFunciones(     //Definicion entradas y salidas
    input wire clk,  //variable que reinicia los contadores, se reinicia con un 1
    input wire IndicadorMaquina,  //Señal que indica acción que se esta realizando // En cero ejecuta señales Write y en 1 señales read
    output wire ChipSelect1,Read1,Write,AoD1, //Señales de entrada del RTC
    output wire [7:0] contador1
    );
       
reg [4:0] contador = 4'b00000;   //Contador general del modulo (10ns)
reg ChipSelect,Read,AoD;
reg [2:0] limitador = 0; //limitador para señal ChipSelecr
reg [2:0] limitador2 = 0; //limitador para señal Read
reg [2:0] limitador3 = 0; //limitador para señal write
reg [2:0] limitador4 = 0; //limitador para señal AoD
reg reset=0;
reg [7:0] contador2 = 0;


assign contador1 = contador2; //Permite ver el progreso del contador
assign ChipSelect1 =ChipSelect;
assign Read1=Read;
assign AoD1= AoD; 

always @(posedge clk)
        begin
        if((contador2>=8'h00 && contador2<=8'h47)| (contador2>=8'h88 && contador2<=8'hd3))
        begin
        reset<=1;end
        else 
        begin
        reset<=0;end
        end
           
always @(posedge clk)begin
          if(reset==1)begin  //Condición de Reset
          contador=0;
          contador2 <=contador2+1;end
          else
          contador <= contador + 1'b1;          //Suma 1 cada 10 ns //Este es el contador general para todo el modulo                          
          contador2 <= contador2 + 1;end
          
                                                   
always @(posedge clk)     
begin
    ChipSelect<=1;             
    if(!reset)
    begin
    if((contador >=5'b00000 & contador<=5'b00111) )begin
        ChipSelect <= 0;end
        else
        begin
        ChipSelect<=1;
        end
     end
     else begin
     ChipSelect<=1;
     end
end



reg Write1;
reg Write2;
reg [3:0]conta=0;     

assign Write = (IndicadorMaquina)?Write1:Write2;

          
always @(posedge clk)     
begin
 Write1<=1;             
 if(!reset && IndicadorMaquina)
    begin
     if(!ChipSelect && Read)
        begin
        conta=conta+1;
        if(conta>1 && conta<7)
        begin
        Write1<=0;
        end
        end
    end
  if(reset && IndicadorMaquina)
    begin
    conta<=0;
    end
end   
   
   
        
                


       
always @(posedge clk)     
        begin 
        //para funcion write
        if(!IndicadorMaquina &&!reset)
        begin
        
            if((contador >=5'b00001 & contador<=5'b00110) )begin
                Write2 <= 0;end
                else
                
            
             begin
             Write2<=1;
             end
        end
          //para funcion read
          Read<=1;
          if(IndicadorMaquina && !reset)
          begin
          if(contador>5'b00001 & contador<=5'b00110 && AoD)begin
                Read<=0;end
                else
                begin
                Read<=1;
                end
         
          end
            

end
        
        
       
         
        reg conta2=0;
       
always @(posedge clk)     
         begin 
         AoD<=1;            
             if(!reset)
             begin
             if((contador >=5'b00000 & contador<=5'b00111) && limitador4 <8 && !conta2 )begin
                limitador4<=limitador4 + 1;
                 AoD <= 0;
                 end
                 else
                 begin
                 conta2<=1;
                 AoD<=1;
                 end
              end
              else begin
              AoD<=1;
              conta2<=0;
              end
          end   
         
 endmodule
