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


procedure informarArchivoMaestro (var archM: archivoMaestro);
var
    totalVotos: integer;
    totalVotosProvincia: integer;
    totalVotosLocalidad: integer;
    provinciaActual: integer;
    localidadActual: integer;
begin
    reset (archM);
    leer (archM, regM);

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

NOTA: La información está ordenada por código de provincia y código de localidad
}