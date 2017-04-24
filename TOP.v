`timescale 1ns / 1ps
module TOP(
    input wire push_izquierda,
    input wire push_derecha,
    input wire push_arriba,  //Push Buttons (Para escribir)
    input wire push_abajo,
    input wire Reset,Escribir,ResetCrono,
    input wire clk,ProgramarCrono,
    input wire instrucciones, //Muestra o esconde las instrucciones
    input wire push_centro, //Push para cronometro
    inout wire [7:0] DATA_ADDRESS, //variable inout hacia y desde rtc
    output wire ChipSelect,Read,Write,AoD, //Señales de control rtc
    output wire hsync,vsync,
    output wire  [11:0] rgbO,
    output wire bit_inicio1,
    output wire video_on


    );
 //wire bit_inicio1; //Bit de inicio hacia controlador vga

wire RW;//Variables OUTPUT MaquinaGeneral, indica cuales señales generar
wire Crono; //Variable OUTPUT MaquinaGeneral, activa o desactiva el modulo del cronometrp
wire Per_read; //Variable OUTPUT MaquinaGeneral, activa modulo de lectura permanente MaquinaLectura


reg [15:0] contador3=0;
reg Inicio1=1'b1; //Señal Incio que solo posee valor 1 al iniciar el sistema

always@(posedge clk)
begin
contador3<=contador3 + 1'b1;
if(contador3==16'd110 && Inicio1)  //Se le asigna el valor correspondiente  a Inicio
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
wire [7:0]date; //para escritura de entrada
wire [7:0]num_semana;
wire[7:0]mes;
wire [7:0]ano;
wire [7:0]dia_sem;

wire [7:0]datos8;
wire [7:0]datos9;
wire [7:0]datos10;




//reg [7:0]segundos,minutos,horas,date,num_semana,mes,ano,dia_sem;
wire [7:0]contador2;

MaquinaEscritura Escritura_unit(.clk(clk),.RW(RW),.Inicio(Inicio1),.Reset(Reset),.push_arriba(push_arriba),
                                .push_abajo(push_abajo),.push_izquierda(push_izquierda),.push_derecha(push_derecha),.address(ADDRESS_write),
                                .data_mod(data_mod),.reset2(reset3),.segundos(segundos),.minutos(minutos),.horas(horas),.date(date),
                                .num_semana(num_semana),.mes(mes),.ano(ano),.dia_sem(dia_sem),.Escribir(Escribir),.Per_read(Per_read));
wire [7:0]address;
reg [7:0] address2;
wire [7:0] data_inicio;
wire [7:0] address_inicio;

inicializacion inicio(.clk(clk),.Inicio1(Inicio1),.address(address_inicio),.data_mod(data_inicio));

//assign address=(Escribir | reset3)? ADDRESS_write:ADDRESS_read;
reg [7:0] data_mod2;

always@(posedge clk)
begin
    if(Inicio1)
    begin
    address2<=address_inicio;
    end

    if (IniciaCronometro)begin
      address2<=address_crono;
    end
    if((Escribir|(reset3 |!RW)) && (!Inicio1))
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
wire [7:0] data_intermedia;

always@(posedge clk)
    begin
    if(Reset)
       begin
       data_mod2<=data_reset;
       end
    if((!RW |Escribir |reset3)& !Inicio1)
        begin
       data_mod2<=data_mod;
        end
    if(Inicio1)
        begin
        data_mod2<=data_inicio;
        end
    end




Protocolo_rtc Proto_unit(.clk(clk),.address(address2),.DATA_WRITE(data_mod2),.IndicadorMaquina(RW),
                         .ChipSelect(ChipSelect),.Read(Read),.Write(Write),.AoD(AoD),.DATA_ADDRESS(DATA_ADDRESS),
                         .data_vga(data_intermedia),.contador_todo(contador2) );

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


Registros Register_unit(.clk(clk),.data_vga(data_vga_entrada),.contador(contador2),
                        .Read(READ),.datos0(segundos),
                        .datos1(minutos),.datos2(horas),.datos3(date),.datos4(mes),.datos5(ano),.datos6(dia_sem),.datos7(num_semana),
                        .datos8(datos8),.datos9(datos9),.datos10(datos10),.IndicadorMaquina(RW),.address(DATA_ADDRESS),.Write(Write),.AoD(AoD)
                        );
//reg [7:0] data_out1;
//reg [7:0]segundos2; //para escritura de salida

wire CronoActivo,Ring;
wire  horasSal,minutosSal,segundosSal;

wire address_crono;
wire data_crono;
wire IniciaCronometro;

MaquinaCrono MaquinaCrono_unit(
    .Reset(ResetCrono),.clk(clk),
    .ProgramarCrono(ProgramarCrono),.PushInicioCrono(push_centro),
    .horas(datos10),.minutos(datos9),.segundos(datos8),
    .arriba(push_arriba),.abajo(push_abajo),.izquierda(push_izquierda),.derecha(push_derecha),
    .CronoActivo(CronoActivo),.Ring(Ring),
    .horasSal(horasSal),.minutosSal(minutosSal),.segundosSal(segundosSal),.Cursor(Cursor)
    ,.address(address_crono),.data_mod(data_crono),.IniciaCronometro(IniciaCronometro)
    );


//Mux datos Cronometro y cursor
reg horaCrono,minutosCrono,segundosCrono;
wire [7:0] Cursor;
reg [7:0] CursorTop;

always @*
if (ProgramarCrono && !CronoActivo) begin
horaCrono=horasSal;
minutosCrono=minutosSal;
segundosCrono=segundosSal;
CursorTop=Cursor;
end

else begin
horaCrono=datos8;
minutosCrono=datos9;
segundosCrono=datos10;
CursorTop=address2;
end







Interfaz Interfaz_unit(.clk(clk),.reset(Reset),.rgbO(rgbO),.resetSync(Reset),.inicioSecuencia(bit_inicio1),.datoRTC(data_out),.hsync(hsync),.vsync(vsync),.video_on(video_on),
                 .datos0(segundos),.datos1(minutos),.datos2(horas),.datos3(date),.datos4(mes),.datos5(ano),.datos6(dia_sem),.datos7(num_semana),
                     .datos8(segundosCrono),.datos9(minutosCrono),.datos10(horaCrono),.instrucciones(instrucciones),.Escribir(Escribir),.cursor(Cursor),.ProgramarCrono(ProgramarCrono)
                     );

endmodule
