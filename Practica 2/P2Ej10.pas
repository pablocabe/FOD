program P2Ej10;

const
    valorAlto = 9999;

type
    registroMaestro = record
        codigoProvincia: integer;
        codigoLocalidad: integer;
        numeroMesa: integer;
        totalVotosMesa: integer;
    end;

    archivoMaestro = file of registroMaestro;


procedure crearArchivoMaestro (var archM: archivoMaestro) // Se dispone


procedure leer (var archM: archivoMaestro; var regM: registroMaestro);
begin
    if (not EOF(archM)) then
        read (archM, regM)
    else
        regM.codigoProvincia := valorAlto; // Asigno un valor de corte
end;


procedure informarArchivoMaestro (var archM: archivoMaestro);
var
    regM: registroMaestro;
    totalVotos: integer;
    totalVotosProvincia: integer;
    totalVotosLocalidad: integer;
    provinciaActual: integer;
    localidadActual: integer;
begin
    reset (archM);
    leer (archM, regM);
    totalVotos := 0;

    while (regM.codigoProvincia <> valorAlto) do begin
        provinciaActual := regM.codigoProvincia;
        writeln ('Codigo de provincia: ', provinciaActual);
        totalVotosProvincia := 0;
        while (provinciaActual = regM.codigoProvincia) do begin
            localidadActual := regM.codigoLocalidad;
            writeln ('Codigo de localidad: ', localidadActual);
            totalVotosLocalidad := 0;
            while (provinciaActual = regM.codigoProvincia) and (localidadActual = regM.codigoLocalidad) do begin
                totalVotos := totalVotos + regM.totalVotosMesa;
                totalVotosProvincia := totalVotosProvincia + regM.totalVotosMesa;
                totalVotosLocalidad := totalVotosLocalidad + regM.totalVotosMesa;
                leer (archM, regM);
            end;
            writeln ('Total de votos Localidad: ', totalVotosLocalidad);
        end;
        writeln ('Total de votos Provincia: ', totalVotosProvincia);
    end;
    
    writeln ('Total de votos: ', totalVotos);
    close (archM);
end;


var
    archM: archivoMaestro;
begin
    crearArchivoMaestro (archM); // Se dispone
    informarArchivoMaestro (archM);
end.

{
Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:

Código de Provincia
Código de Localidad Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia: ____

Código de Provincia
Código de Localidad Total de Votos
................................ ......................
Total de Votos Provincia: ___
…………………………………………………………..

Total General de Votos: ____

NOTA: La información está ordenada por código de provincia y código de localidad
}