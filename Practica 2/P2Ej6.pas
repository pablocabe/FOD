program P2Ej6;

const
    dF = 10;
    valorAlto = 9999;

type
    subrango = 1 .. dF;

    registroMaestro = record
        codigoLocalidad: integer;
        nombreLocalidad: string;
        codigoCepa: integer;
        cantCasosActivos: integer;
        cantCasosNuevos: integer;
        cantCasosRecuperados: integer;
        cantCasosFallecidos: integer;
    end;

    registroDetalle = record
        codigoLocalidad: integer;
        codigoCepa: integer;
        cantCasosActivos: integer;
        cantCasosNuevos: integer;
        cantCasosRecuperados: integer;
        cantCasosFallecidos: integer;
    end;

    archivoMaestro = file of registroMaestro;

    archivoDetalle = file of registroDetalle;

    vectorDetalles = array [subrango] of archivoDetalle;

    vectorRegistros = array [subrango] of registroDetalle;


procedure crearArchivoMaestro (var archM: archivoMaestro); // se dispone


procedure crearArchivoDetalle (var archD: archivoDetalle) // se dispone


procedure crearArchivosDetalles (var vectorD: vectorDetalles);
var
    i: subrango;
begin
    for i := 1 to dF do begin
        crearArchivoDetalle(vectorD[i]); // se dispone
    end;
end;


// leer (vectorD[i], vectorR[i]);
procedure leer (var archD: archivoDetalle; var regD: registroDetalle);
begin
    if (not EOF(archD)) then
        read (archD, regD)
    else
        regD.codigoLocalidad := valorAlto; // asigno un valor de corte
end;


procedure buscarMinimo (var vectorD: vectorDetalles; var vectorR: vectorRegistros; var minimo: registroDetalle);
var
    i, pos: subrango;
begin
    minimo.codigoLocalidad := valorAlto;
    minimo.codigoCepa := valorAlto;
    for i := 1 to dF do begin
        if (vectorR[i].codigoLocalidad < minimo.codigoLocalidad) or 
        ((vectorR[i].codigoLocalidad = minimo.codigoLocalidad) and (vectorR[i].codigoCepa < minimo.codigoCepa)) then begin
            minimo := vectorR[i];
            pos := i;
        end;
    end;
    if (minimo.codigoLocalidad <> valorAlto) then
        leer (vectorD[pos], vectorR[pos]);
end;


// No cumple esta parte: las localidades pueden o no haber sido actualizadas
procedure actualizarArchivoMaestro (var archM: archivoMaestro; var vectorD: vectorDetalles);
var
    i: subrango;
    cantLocalidades: integer;
    cantTotalPositivos: integer;
    minimo: registroDetalle;
    vectorR: vectorRegistros;
begin
    reset (archM);
    for i := 1 to dF do begin
        reset (vectorD[i]);
        leer (vectorD[i], vectorR[i]);
    end;
    cantLocalidades := 0;

    buscarMinimo (vectorD, vectorR, minimo);
    while (minimo.codigoLocalidad <> valorAlto) do begin
        cantTotalPositivos := 0; // reiniciar
        read (archM, regM);
        while (minimo.codigoLocalidad <> regM.codigoLocalidad) do
            read (archM, regM);
        while (minimo.codigoLocalidad = regM.codigoLocalidad) do begin
            while (minimo.codigoCepa <> regM.codigoCepa) do
                read (archM, regM);
            while (minimo.codigoLocalidad = regM.codigoLocalidad) and (minimo.codigoCepa = regm.codigoCepa) do begin
                regM.cantCasosFallecidos := regM.cantCasosFallecidos + minimo.cantCasosFallecidos;
                regM.cantCasosRecuperados := regM.cantCasosRecuperados + minimo.cantCasosRecuperados;
                regM.cantCasosActivos := minimo.cantCasosActivos;
                regM.cantCasosNuevos := minimo.cantCasosNuevos;
                // Acumular los casos activos en la localidad
                cantTotalPositivos := cantTotalPositivos + minimo.cantCasosActivos;
                buscarMinimo (vectorD, vectorR, minimo);
            end;
            seek (archM, filePos(archM)-1);
            write (archM, regM);
        end;
        if (cantTotalPositivos > 50) then
            cantLocalidades := cantLocalidades + 1;
    end;

    writeln ('La cantidad de localidades con mas de 50 casos activos es: ', cantLocalidades);
    close (archM);
    for i := 1 to dF do
        close (vectorD[i]);
end;


var
    archM: archivoMaestro;
    vectorD: vectorDetalles;
begin
    crearArchivoMaestro (archM); // se dispone
    crearArchivosDetalles (vectorD);
    actualizarArchivoMaestro (archM, vectorD);
end.

{
Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de Buenos Aires.

Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.

El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos.

Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.

Para la actualización se debe proceder de la siguiente manera:

1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.

2. Idem anterior para los recuperados.

3. Los casos activos se actualizan con el valor recibido en el detalle.

4. Idem anterior para los casos nuevos hallados.

Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).
}