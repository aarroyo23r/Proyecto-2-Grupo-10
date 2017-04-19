`timescale 1ns / 1ps

module MaquinaEscritura(
    input wire Inicio,Reset,
    input wire clk,
    input wire RW,crono,
    input wire push_arriba,push_abajo,push_izquierda,push_derecha,
    input wire [7:0]segundos,minutos,horas,dia,date,semana,mes,ano,
    output reg [7:0] address,
    output reg [7:0] data_mod,
    output reg reset2
    );
reg [32:0]contador=32'h00000000;
reg[3:0]c_dir=0;
localparam [11:0] limit = 12'h100;            
localparam [3:0] s0 = 4'h0, //inicialización
                 s1 = 4'h1, //segundos 
                 s2 = 4'h2, //minutos
                 s3 = 4'h3, //horas
                 s4 = 4'h4, //día
                 s5 = 4'h5, //mes
                 s6 = 4'h6, //año
                 s7 = 4'h7, //día de semana
                 s8 = 4'h8; //#de semana
           

reg [3:0] s_next=s0; 
reg [3:0] s_actual;
reg push_ar=0, push_ab=0, push_i=0, push_d=0; //salida del detector de flancos

//MAQUINA ESCRITURA Y INICIALIZACIOÓN
//registro de estados
always @(posedge clk,posedge Reset)begin
    if(Reset | Inicio)begin
        s_actual <=s0;
    end
    else
        s_actual <=s_next;
end

//DETECTOR DE FLANCOS
always@(posedge clk)
begin   
  if(push_arriba |push_abajo | push_izquierda | push_derecha)
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
        push_ar=1'b1;
        end
     if(push_abajo)
        begin
        push_ab=1'b1;
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
   else
   if((contador>limit) && (push_arriba |push_abajo | push_izquierda | push_derecha))
   begin
    contador<=contador +1'b1;
    push_d<=0;
    push_i<=0;
    push_ab<=0;
    push_ar<=0;
   end
end
//fin de detector de flancos

///maquina de estados de escritura

always @*
begin
s_next<=s_actual; //siguiente estado default el actual
address <=8'h00;  //salida default de leer
data_mod <= 8'h00; //salida default de leer
        case(s_actual)
        default: s_next<=s1;  //estado inicialización
        s0 : begin
             if((Inicio|Reset) && !RW)
                begin
                    reset2<=1'b1;
                    s_next<=s0;
                    address<=8'h02;
                    data_mod<=8'h10;
                end
              if(!Inicio && !Reset && !RW)
                 begin
                    reset2<=1'b1;
                    address<=8'h02;
                    data_mod<=8'h00;
                    s_next<=s1;
                 end
              end
        s1: begin           //estado escritura de segundos
            if((Inicio|Reset) && !RW)
                begin
                    reset2<=1'b1;
                    s_next<=s0;
                    address <= 8'h02;
                    data_mod<= 8'h10;
                end 
            if(!Inicio && !Reset && !RW)  
                begin
                    reset2<=1'b0;
                    address <=8'h21;
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
                            address<=8'h43;
                            end
                         if(!push_d && !push_i)
                            begin
                            s_next<=s_actual;
                            end                        
                end
            
            end
         s2: begin
                       if((Inicio|Reset) && !RW)
                           begin
                               reset2<=1'b1;
                               s_next<=s0;
                               address <= 8'h02;
                               data_mod<= 8'h10;
                           end 
                       if(!Inicio && !Reset && !RW)  
                           begin
                               reset2<=1'b0;
                               address <=8'h22;
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
                       if((Inicio|Reset) && !RW)
                        begin
                        reset2<=1'b1;
                        s_next<=s0;
                        address <= 8'h02;
                        data_mod<= 8'h10;
                        end 
                        
                       if(!Inicio && !Reset && !RW)  
                         begin
                          reset2<=1'b0;
                          address <=8'h23;
                          
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
                        if((Inicio|Reset) && !RW)
                           begin
                           reset2<=1'b1;
                           s_next<=s0;
                           address <= 8'h02;
                           data_mod<= 8'h10;
                           end 
                           if(!Inicio && !Reset && !RW)  
                              begin
                              reset2<=1'b0;
                              address <=8'h24;
                                if(push_ar && !push_ab)
                                  begin
                                  data_mod<= dia +1'b1;  ///le sumo +1 a dia
                                  end
                                if(!push_ar && push_ab)
                                   begin
                                   data_mod<=dia - 1'b1;    ///le resto -1 a dia
                                   end
                                if(!push_ab &&!push_ar)
                                   begin
                                   data_mod<=dia;     //dejo el dato igual dia
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
             if((Inicio|Reset) && !RW)
             begin
             reset2<=1'b1;
             s_next<=s0;
             address <= 8'h02;
             data_mod<= 8'h10;
             end 
             if(!Inicio && !Reset && !RW)  
                begin
                reset2<=1'b0;
                address <=8'h25;
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
                    if((Inicio|Reset) && !RW)
                    begin
                    reset2<=1'b1;
                    s_next<=s0;
                    address <= 8'h02;
                    data_mod<= 8'h10;
                    end 
                        if(!Inicio && !Reset && !RW)  
                                  begin
                                  reset2<=1'b0;
                                  address <=8'h26;
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
               if((Inicio|Reset) && !RW)
                   begin
                   reset2<=1'b1;
                   s_next<=s0;
                   address <= 8'h02;
                   data_mod<= 8'h10;
                   end 
               if(!Inicio && !Reset && !RW)  
                   begin
                   reset2<=1'b0;
                   address <=8'h27;
                        if(push_ar && !push_ab)
                             begin
                             data_mod<= semana +1'b1;  ///le sumo +1 a día de la semana
                             end
                        if(!push_ar && push_ab)
                             begin
                             data_mod<=semana - 1'b1;    ///le resto -1 a dia de la semana
                             end
                         if(!push_ab &&!push_ar)
                             begin
                             data_mod<=semana;     //dejo el dato igual a dia de la semana
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
               if((Inicio|Reset) && !RW)
                 begin
                 reset2<=1'b1;
                 s_next<=s0;
                 address <= 8'h02;
                 data_mod<= 8'h10;
                 end 
               if(!Inicio && !Reset && !RW)  
                 begin
                 reset2<=1'b0;
                 address <=8'h28;
               if(push_ar && !push_ab)
                 begin
                 data_mod<= semana +1'b1;  ///le sumo +1 a día de la semana
                 end
               if(!push_ar && push_ab)
                 begin
                 data_mod<=semana - 1'b1;    ///le resto -1 a dia de la semana
                 end
               if(!push_ab &&!push_ar)
                 begin
                 data_mod<=semana;     //dejo el dato igual a dia de la semana
                 end
               if(push_d && !push_i) 
                  begin
                  s_next<=s1;
                  address<=8'h21;
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
