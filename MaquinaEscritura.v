`timescale 1ns / 1ps

module MaquinaEscritura(
    input wire Inicio,Reset,
    input wire clk,
    input wire RW,
    input wire push_arriba,push_abajo,push_izquierda,push_derecha,
    input wire [7:0]segundos,minutos,horas,date,num_semana,mes,ano,dia_sem,
    output reg [7:0] address,
    output reg [7:0] data_mod,
    output reg reset2,activador
    );
reg [32:0]contador=32'h00000000;
reg[3:0]c_dir=0;
localparam [11:0] limit = 12'h100;            
localparam [3:0] s0 = 4'h0, //inicialización
                 s1 = 4'h2, //segundos 
                 s2 = 4'h3, //minutos
                 s3 = 4'h4, //horas
                 s4 = 4'h5, //date
                 s5 = 4'h6, //mes
                 s6 = 4'h7, //año
                 s7 = 4'h8, //día de semana
                 s8 = 4'h9, //#de semana
                 sY = 4'h1; //estado 12/24hrs

reg [3:0] s_next=sY; 
reg [3:0] s_actual;
reg push_ar=0, push_ab=0, push_i=0, push_d=0; //salida del detector de flancos

//detector de pulsos formato




//MAQUINA ESCRITURA Y INICIALIZACIOÓN
//registro de estados
always @(posedge clk)begin
    if(Inicio)begin
        s_actual <=s0;
    end
    else
        s_actual <=s_next;
end

//DETECTOR DE FLANCOS
always@(posedge clk)
begin   
  if((push_arriba |push_abajo | push_izquierda | push_derecha))
  begin
  contador<=contador+1'b1;
  end
  if(!push_arriba && !push_abajo && !push_izquierda && !push_derecha)
  begin
  contador<=32'h00000000;
  end
end


always@(posedge clk)
begin
   if(contador<limit) 
   begin
    if(push_arriba)
        begin
        push_ar<=1'b1;
        end
     if(push_abajo)
        begin
        push_ab<=1'b1;
        end
     if(push_izquierda)
        begin
        push_i<=1'b1;
        end
     if(push_derecha)
        begin
        push_d<=1'b1;
        end 
   end
   if((contador>limit) && (push_arriba |push_abajo | push_izquierda | push_derecha))
   begin
    push_d<=0;
    push_i<=0;
    push_ab<=0;
    push_ar<=0;
   end
end
//fin de detector de flancos

//CONTADOR PARA DURACIÓN DE ESTADO DE INICIALIZACIÓN
reg [11:0] contador2=0;
reg activa=0;
always @(posedge clk)                 
begin
if(!Inicio && !Reset)
begin
    contador2<=contador2 +1'b1;
    activa<=0;
end
if(contador2==12'h300)
begin
    activa<=1;
end
end

//CONTADOR PARA RESET
reg [11:0] contador3=0;
reg activa2=0;
always @(posedge clk)                 
begin
if(Reset)
begin
    contador3<=contador3 +1'b1;
    activa2<=0;
end
if(contador3==12'h800)
begin
    activa2<=1;
end
end



///maquina de estados de escritura

always @*
begin
s_next<=s_actual; //siguiente estado default el actual
address <=8'h00;  //salida default de leer
data_mod <= data_mod; //salida default de leer
activador<=0;
        case(s_actual)
        s0 : begin
             if((Inicio|Reset))
                begin
                    reset2<=1'b1;
                    s_next<=s0; 
                    address<=8'h02;
                    data_mod<=8'h10;
                    end
                 if(!Inicio && !Reset)
                   begin
                    address<=8'h02;
                    data_mod<=8'h00;
                    if(activa)   
                    begin
                    s_next<=sY;
                    end
                    end       
                end
        sY : begin  // varía formato 24 o 12 hrs
             reset2<=1'b0;
             address<=8'h00;
             if(push_ar && !push_ab)
             begin
                data_mod<= 8'h10;
             end
        
             if(push_d && !push_i)
             begin
                s_next<=s1;
             end
             if(!push_d && push_i)
             begin
                s_next<=s8;
             end
             if(!push_d && !push_i)
             begin
                s_next<=sY;
             end
          end
             
             
        s1: begin           //estado escritura de segundos
            if((Reset) && !RW)
                begin
                    reset2<=1'b1;
                    address<= 8'h00;
                    data_mod<= 8'h00;
                    if(activa2)
                    begin
                    s_next<=sY;
                    end
                end 
            if(!Inicio && !Reset && !RW)  
                begin
                    reset2<=1'b0;
                    address<=8'h21;
                        if(push_ar && !push_ab)
                            begin
                            data_mod<= segundos +1'b1;  ///le sumo +1 a segundos
                            end
                        if(!push_ar && push_ab)
                            begin
                            data_mod<=segundos - 1'b1;    ///le resto -1 a segundos
                            end
                        if(!push_ab &&!push_ar)
                            begin
                            data_mod<=segundos;  //dejo el dato igual
                            end
                        if(push_d && !push_i) 
                            begin
                            s_next<=s2;
                            address<=8'h22;
                            end
                        if(!push_d && push_i)
                            begin
                            s_next<=s8;
                            address<=8'h28;
                            end
                         if(!push_d && !push_i)
                            begin
                            s_next<=s_actual;
                            end                        
                end
            
            end
         s2: begin
                       if((Reset) && !RW)
                           begin
                               reset2<=1'b1;
                               address<= 8'h00;
                               data_mod<= 8'h00;
                               if(activa2)
                               begin
                               s_next<=sY;
                               end
                           end 
                       if(!Inicio && !Reset && !RW)  
                           begin
                               reset2<=1'b0;
                               address<=8'h22;
                                   if(push_ar && !push_ab)
                                       begin
                                       data_mod<= minutos +1'b1;  ///le sumo +1 a minutos
                                       end
                                   if(!push_ar && push_ab)
                                       begin
                                       data_mod<=minutos - 1'b1;    ///le resto -1 a minutos
                                       end
                                   if(!push_ab &&!push_ar)
                                       begin
                                       data_mod<=minutos;  //dejo el dato igual
                                       end
                                   if(push_d && !push_i) 
                                       begin
                                       s_next<=s3;
                                       address<=8'h23;
                                       end
                                   if(!push_d && push_i)
                                       begin
                                       s_next<=s1;
                                       address<=8'h21;
                                       end
                                    if(!push_d && !push_i)
                                       begin
                                       s_next<=s_actual;
                                       end                        
                           end
                       
                       end   
          s3:begin
                       if((Reset) && !RW)
                        begin
                        reset2<=1'b1;
                        address <= 8'h00;
                        data_mod<= 8'h00;
                        if(activa2)
                        begin
                        s_next<=sY;
                        end
                        end 
                        
                       if(!Inicio && !Reset && !RW)  
                         begin
                          reset2<=1'b0;
                          address<=8'h23;
                                if(push_ar && !push_ab)
                                   begin
                                   data_mod<= horas +1'b1;  ///le sumo +1 a horas
                                   end
                                if(!push_ar && push_ab)
                                   begin
                                   data_mod<=horas - 1'b1;    ///le resto -1 a horas
                                   end
                                if(!push_ab &&!push_ar)
                                    begin
                                    data_mod<=horas;  //dejo el dato horas
                                    end
                                if(push_d && !push_i) 
                                     begin
                                     s_next<=s4;
                                     address<=8'h24;
                                     end
                                if(!push_d && push_i)
                                     begin
                                     s_next<=s2;
                                     address<=8'h22;
                                     end
                                if(!push_d && !push_i)
                                     begin
                                     s_next<=s_actual;
                                     end                        
                          end
                                              
                 end  
        s4:begin
                        if((Reset) && !RW)
                           begin
                           reset2<=1'b1;
                           address <= 8'h00;
                           data_mod<= 8'h00;
                           if(activa2)
                           begin
                           s_next<=sY;
                           end
                           end 
                           if(!Inicio && !Reset && !RW)  
                              begin
                              reset2<=1'b0;
                              address<=8'h24;
                                if(push_ar && !push_ab)
                                  begin
                                  data_mod<= date +1'b1;  ///le sumo +1 a dia
                                  end
                                if(!push_ar && push_ab)
                                   begin
                                   data_mod<=date - 1'b1;    ///le resto -1 a dia
                                   end
                                if(!push_ab &&!push_ar)
                                   begin
                                   data_mod<=date;     //dejo el dato igual dia
                                   end
                                if(push_d && !push_i) 
                                   begin
                                   s_next<=s5;
                                   address<=8'h25;
                                   end
                                if(!push_d && push_i)
                                    begin
                                    s_next<=s3;
                                    address<=8'h23;
                                    end
                                 if(!push_d && !push_i)
                                     begin
                                     s_next<=s_actual;
                                      end                        
                              end
            end
         s5:begin
             if((Reset) && !RW)
             begin
             reset2<=1'b1;
             address <= 8'h00;
             data_mod<= 8'h00;
             if(activa2)
             begin
             s_next<=sY;
             end
             end 
             if(!Inicio && !Reset && !RW)  
                begin
                reset2<=1'b0;
                address<=8'h25;
                  if(push_ar && !push_ab)
                     begin
                     data_mod<= mes +1'b1;  ///le sumo +1 a mes
                     end
                  if(!push_ar && push_ab)
                     begin
                     data_mod<=mes- 1'b1;    ///le resto -1 a mes
                      end
                  if(!push_ab &&!push_ar)
                     begin
                     data_mod<=mes;     //dejo el dato igual mes
                     end
                     if(push_d && !push_i) 
                     begin
                     s_next<=s6;
                     address<=8'h26;
                     end
                  if(!push_d && push_i)
                     begin
                     s_next<=s4;
                     address<=8'h24;
                     end
                   if(!push_d && !push_i)
                     begin
                     s_next<=s_actual;
                     end                        
            end
    end
        s6:begin
                    if((Reset) && !RW)
                    begin
                    reset2<=1'b1;
                    address<= 8'h00;
                    data_mod<= 8'h00;
                    if(activa2)
                    begin
                    s_next<=sY;
                    end
                    end 
                        if(!Inicio && !Reset && !RW)  
                                  begin
                                  reset2<=1'b0;
                                  address<=8'h26;
                                    if(push_ar && !push_ab)
                                      begin
                                      data_mod<= ano +1'b1;  ///le sumo +1 a año
                                      end
                                    if(!push_ar && push_ab)
                                       begin
                                       data_mod<=ano - 1'b1;    ///le resto -1 a año
                                       end
                                    if(!push_ab &&!push_ar)
                                       begin
                                       data_mod<=ano;     //dejo el dato igual año
                                       end
                                    if(push_d && !push_i) 
                                       begin
                                       s_next<=s7;
                                       address<=8'h27;
                                       end
                                    if(!push_d && push_i)
                                        begin
                                        s_next<=s5;
                                        address<=8'h25;
                                        end
                                     if(!push_d && !push_i)
                                         begin
                                         s_next<=s_actual;
                                          end                        
                                  end
                end    
  s7:begin
               if((Reset) && !RW)
                   begin
                   reset2<=1'b1;
                   address <= 8'h00;
                   data_mod<= 8'h00;
                   if(activa2)
                   begin
                   s_next<=sY;
                   end
                   end 
               if(!Inicio && !Reset && !RW)  
                   begin
                   reset2<=1'b0;
                   address <=8'h27;
                        if(push_ar && !push_ab)
                             begin
                             data_mod<= dia_sem +1'b1;  ///le sumo +1 a día de la semana
                             end
                        if(!push_ar && push_ab)
                             begin
                             data_mod<=dia_sem - 1'b1;    ///le resto -1 a dia de la semana
                             end
                         if(!push_ab &&!push_ar)
                             begin
                             data_mod<=dia_sem;     //dejo el dato igual a dia de la semana
                             end
                         if(push_d && !push_i) 
                             begin
                             s_next<=s8;
                             address<=8'h28;
                             end
                         if(!push_d && push_i)
                             begin
                             s_next<=s6;
                             address<=8'h26;
                             end
                         if(!push_d && !push_i)
                             begin
                             s_next<=s_actual;
                             end                        
                   end
            end
            
            
      s8:begin
               if((Reset) && !RW)
                 begin
                 reset2<=1'b1;
                 address<= 8'h00;
                 data_mod<= 8'h00;
                 if(activa2)
                 begin
                 s_next<=sY;
                 end
                 end 
                 
                 
               if(!Inicio && !Reset && !RW)  
                 begin
                 reset2<=1'b0;
                 address<=8'h28;
               if(push_ar && !push_ab)
                 begin
                 data_mod<= num_semana +1'b1;  ///le sumo +1 a día de la semana
                 end
               if(!push_ar && push_ab)
                 begin
                 data_mod<=num_semana - 1'b1;    ///le resto -1 a dia de la semana
                 end
               if(!push_ab &&!push_ar)
                 begin
                 data_mod<=num_semana;     //dejo el dato igual a dia de la semana
                 end
               if(push_d && !push_i) 
                  begin
                  s_next<=s1;
                  address<=8'h00;
                   end
                if(!push_d && push_i)
                  begin
                    s_next<=s7;
                    address<=8'h27;
                    end
                if(!push_d && !push_i)
                    begin
                    s_next<=s_actual;
                    end                        
            end
                      
    end
     
  endcase
end
endmodule
