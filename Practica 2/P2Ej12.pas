program P2Ej12;

const
    valorAlto = 9999;

type

    registroMaestro = record
        anio: integer;
        mes: integer;
        dia: integer;
        idUsuario: integer;
        tiempo: integer;
    end;

    archivoMaestro = file of registroMaestro;


procedure crearArchivoMaestro (var archM: archivoMaestro) // Se dispone


procedure leer (var archM: archivoMaestro; var regM: registroMaestro);
begin
    if (not EOF(archM)) then
        read (archM, regM)
    else
        regM.anio := valorAlto; // Asigno un valor de corte
end;


procedure informarArchivoMaestro (var archM: archivoMaestro; anioInforme: integer);
var
    regM: registroMaestro;
    diaActual, mesActual: integer;
    tiempoDia, tiempoMes, tiempoAnio: integer;
begin
    reset (archM);
    read (archM, regM);

    while (regM.anio < anioInforme) do begin
        leer (archM, regM);
    end;
    // Cuando salió lo encontró o es mayor (no existe)

    if (regM.anio = anioInforme) then begin
        writeln ('Anio: ', regM.anio);
        tiempoAnio := 0;
        while (anioInforme = regM.anio) do begin
            mesActual := regM.mes;
            tiempoMes := 0;
            writeln ('Mes: ', mesActual);
            while (anioInforme = regM.anio) and (mesActual = regM.mes) do begin
                diaActual := regM.dia;
                tiempoDia := 0;
                writeln ('Dia: ', diaActual);
                while (anioInforme = regM.anio) and (mesActual = regM.mes) and (diaActual = regM.dia) do begin
                    writeln ('ID Usuario: ', regM.idUsuario);
                    writeln ('Tiempo total de acceso del usuario: ', regM.tiempo);
                    tiempoDia := tiempoDia + regM.tiempo;
                    leer (archM, regM);
                end;
                writeln ('Tiempo total de acceso en el dia ', diaActual, ' mes ', mesActual, ': ', tiempoDia);
                tiempoMes := tiempoMes + tiempoDia;
            end;
            writeln ('Tiempo total de acceso en el mes ', mesActual, ': ', tiempoMes);
            tiempoAnio := tiempoAnio + tiempoMes;
        end;
        writeln ('Tiempo total de acceso en el anio ', anioInforme, ': ', tiempoAnio);
    end

    else
        writeln ('Anio no encontrado');

    close (archM);
end;


var
    archM: archivoMaestro;
    anioInforme: integer;
begin
    crearArchivoMaestro (archM); // Se dispone
    writeln ('Ingrese el anio del cual se realizara el informe de accesos');
    readln (anioInforme);
    informarArchivoMaestro (archM, anioInforme);
end.

{
La empresa de software ‘X’ posee un servidor web donde se encuentra alojado el sitio web
de la organización. En dicho servidor, se almacenan en un archivo todos los accesos que se
realizan al sitio. La información que se almacena en el archivo es la siguiente: año, mes, día,
idUsuario y tiempo de acceso al sitio de la organización. El archivo se encuentra ordenado
por los siguientes criterios: año, mes, día e idUsuario.

Se debe realizar un procedimiento que genere un informe en pantalla, para ello se indicará
el año calendario sobre el cual debe realizar el informe. El mismo debe respetar el formato
mostrado a continuación:

Impresion (ver PDF)

Se deberá tener en cuenta las siguientes aclaraciones:

● El año sobre el cual realizará el informe de accesos debe leerse desde el teclado.
● El año puede no existir en el archivo, en tal caso, debe informarse en pantalla “año
no encontrado”.
● Debe definir las estructuras de datos necesarias.
● El recorrido del archivo debe realizarse una única vez procesando sólo la información
necesaria.
}