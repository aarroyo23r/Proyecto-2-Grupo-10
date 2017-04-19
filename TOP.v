`timescale 1ns / 1ps
module TOP(
    input wire push_izquierda,
    input wire push_derecha,
    input wire push_arriba,  //Push Buttons (Para escribir)
    input wire push_abajo,
    input wire Reset,Escribir,
    input wire clk,ProgramarCrono,
    input wire push_centro, //Push para cronometro
    inout wire [7:0] DATA_ADDRESS, //variable inout hacia y desde rtc
    output wire ChipSelect,Read,Write,AoD, //Señales de control rtc
    output wire hsync,vsync,
    output wire  [11:0] rgbO,
    output wire video_on


    );
 wire bit_inicio1; //Bit de inicio hacia controlador vga

wire RW;//Variables OUTPUT MaquinaGeneral, indica cuales señales generar
wire Crono; //Variable OUTPUT MaquinaGeneral, activa o desactiva el modulo del cronometrp
wire Per_read; //Variable OUTPUT MaquinaGeneral, activa modulo de lectura permanente MaquinaLectura

reg [15:0] contador3=0;
reg Inicio1=1'b1; //Señal Incio que solo posee valor 1 al iniciar el sistema

always@(posedge clk)
begin
contador3<=contador3 + 1'b1;
if(contador3==16'h0200 && Inicio1)  //Se le asigna el valor correspondiente  a Inicio
    begin
    Inicio1<=1'b0;
    end
end

//MODULO MAQUINA GENERAL
MaquinaGeneral General_unit(.clk(clk), .Reset(Reset), .Inicio1(Inicio1), .Escribir(Escribir),
                            .ProgramarCrono(ProgramarCrono),.RW(RW),.Crono(Crono),.Per_read(Per_read));
reg PER_READ;
always@(posedge clk)
begin
    PER_READ<=Per_read;
end


//Maquina de Lectura Permanante
wire [7:0]ADDRESS_read;  //direccion hacia rtc cuando esta en lectura
wire reset3; //va a activar el modulo que activa el modulo reset


MaquinaLectura Lectura_unit(.clk(clk),.RW(RW),.address(ADDRESS_read),.Per_read(PER_READ),.reset2(reset3));

wire [7:0]ADDRESS_reset;
wire [7:0]data_reset;
reset reset_unit(.clk(clk),.reset2(reset3),.address(ADDRESS_reset),.data(data_reset));



wire [7:0]data_mod; //datos_modificados
wire [7:0]ADDRESS_write;


wire [7:0]segundos;
wire [7:0]minutos;
wire [7:0]horas;
wire [7:0]date;
wire [7:0]num_semana;
wire [7:0]mes;
wire [7:0]ano;
wire [7:0]dia_sem;

//reg [7:0]segundos,minutos,horas,date,num_semana,mes,ano,dia_sem;

MaquinaEscritura Escritura_unit(.clk(clk),.RW(RW),.Crono(Crono),.Inicio(Inicio1),.Reset(Reset),.push_arriba(push_arriba),
                                .push_abajo(push_abajo),.push_izquierda(push_izquierda),.push_derecha(push_derecha),.address(ADDRESS_write),
                                .data_mod(data_mod),.reset2(reset3),.segundos(segundos),.minutos(minutos),.horas(horas),.date(date),
                                .num_semana(num_semana),.mes(mes),.ano(ano),.dia_sem(dia_sem),.Per_read(Per_read),.Escribir(Escribir)); //falta ingresar datos
wire [7:0]address;
reg [7:0] address2;

//assign address=(Escribir | reset3)? ADDRESS_write:ADDRESS_read;

always@(posedge clk)
begin
    if(Escribir|(reset3 |!RW))
        begin
        address2<=ADDRESS_write;
        if(Reset)
            begin
            address2<=ADDRESS_reset;
            end
        end
        else
        begin
        address2<=ADDRESS_read;
        end
 end


wire [7:0] data_vga; //datos hacia controlador_vga
wire [7:0]contador2;
wire [7:0]data_intermedia;
reg [7:0] data_mod2;

always@(posedge clk)
    begin
    if(Reset)
       begin
       data_mod2<=data_reset;
       end
       else
       data_mod2<=data_mod;
    end
                            
Protocolo_rtc Proto_unit(.clk(clk),.bit_crono(Crono),.address(address2),.DATA_WRITE(data_mod2),.IndicadorMaquina(RW),
                         .ChipSelect(ChipSelect),.Read(Read),.Write(Write),.AoD(AoD),.DATA_ADDRESS(DATA_ADDRESS),
                         .data_vga(data_intermedia),.contador2(contador2));

//REGISTROS PARA ENTREGAR DATA A CONTROLADOR VGA
reg [7:0] data_vga_entrada;
reg [7:0] contador;
reg READ;
always@(posedge clk)
begin
    data_vga_entrada<=data_intermedia;
    contador<=contador2;
    READ<=Read;
end

wire [3:0] contador_datos1;
wire [7:0] data_out; //datos hacia controlador vga


Registros Register_unit(.clk(clk),.bit_inicio1(bit_inicio1),.data_vga(data_vga_entrada),.contador(contador2),
                        .data_vga_final(data_out),.Read(READ),.contador_datos1(contador_datos1),.datos0(segundos),
                        .datos1(minutos),.datos2(horas),.datos3(date),.datos4(mes),.datos5(ano),.datos6(dia_sem),.datos7(num_semana));
reg [7:0] data_out1;

always@(posedge clk)
begin
    data_out1<=data_out;
end

Interfaz Interfaz_unit(.clk(clk),.reset(Reset),.rgbO(rgbO),.resetSync(Reset),.inicioSecuencia(bit_inicio1),.ring(),.datoRTC(data_out1),.hsync(hsync),.vsync(vsync),.video_on(video_on));    
    
endmodule