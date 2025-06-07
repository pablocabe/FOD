{
Se desea modelar la información de una ONG dedicada a la asistencia de personas con
carencias habitacionales. La ONG cuenta con un archivo maestro conteniendo información
como se indica a continuación: Código pcia, nombre provincia, código de localidad, nombre
de localidad, #viviendas sin luz, #viviendas sin gas, #viviendas de chapa, #viviendas sin
agua, # viviendas sin sanitarios.

Mensualmente reciben detalles de las diferentes provincias indicando avances en las obras
de ayuda en la edificación y equipamientos de viviendas en cada provincia. La información
de los detalles es la siguiente: Código pcia, código localidad, #viviendas con luz, #viviendas
construidas, #viviendas con agua, #viviendas con gas, #entrega sanitarios.

Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
provincia y código de localidad.

Para la actualización del archivo maestro, se debe proceder de la siguiente manera:

● Al valor de viviendas sin luz se le resta el valor recibido en el detalle.

● Idem para viviendas sin agua, sin gas y sin sanitarios.

● A las viviendas de chapa se le resta el valor recibido de viviendas construidas

La misma combinación de provincia y localidad aparecen a lo sumo una única vez.

Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades sin viviendas de
chapa (las localidades pueden o no haber sido actualizadas).
}

program P2Ej15;

const
    dF = 10;
    valorAlto = 9999;

type
    subrango = 1 .. dF;

    registroMaestro = record
        codigoProvincia: integer;
        nombreProvincia: string;
        codigoLocalidad: integer;
        nombreLocalidad: string;
        cantViviendasSinLuz: integer;
        cantViviendasSinGas: integer;
        cantViviendasChapa: integer;
        cantViviendasSinAgua: integer;
        cantViviendasSinSanitarios: integer;
    end;

    registroDetalle = record
        codigoProvincia: integer;
        codigoLocalidad: integer;
        cantViviendasConLuz: integer;
        cantViviendasConstruidas: integer;
        cantViviendasConAgua: integer;
        cantViviendasConGas: integer;
        cantEntregaSanitarios: integer;
    end;

    archivoMaestro = file of registroMaestro;

    archivoDetalle = file of registroDetalle;

    vectorDetalles = array [subrango] of archivoDetalle;

    vectorRegistros = array [subrango] of registroDetalle;


procedure crearArchivoMaestro (var archM: archivoMaestro) // Se dispone


procedure crearArchivoDetalle (var archD: archivoDetalle) // Se dispone


procedure crearArchivosDetalles (var vectorD: vectorDetalles);
var
    i: subrango;
begin
    for i := 1 to dF do begin
        crearArchivoDetalle(vectorD[i]); // Se dispone
    end;
end;


procedure leerMaestro (var archM: archivoMaestro; var regM: registroMaestro);
begin
    if (not EOF (archM)) then
        read (archM, regM)
    else
        regM.codigoProvincia := valorAlto;
end;


procedure leerDetalle (var archD: archivoDetalle; var regD: registroDetalle);
begin
    if (not EOF (archD)) then
        read (archD, regD)
    else
        regD.codigoProvincia := valorAlto;
end;


procedure buscarMinimo (var vectorD: vectorDetalles; var vectorR: vectorRegistros; var minimo: registroDetalle);
var
    i, pos: subrango;
begin
    minimo.codigoProvincia := valorAlto;
    for i := 1 to dF do begin
        if (vectorR[i].codigoProvincia < minimo.codigoProvincia) or 
        ((vectorR[i].codigoProvincia = minimo.codigoProvincia) and (vectorR[i].codigoLocalidad < minimo.codigoLocalidad)) then begin
            minimo := vectorR[i];
            pos := i;
        end;
    end;
    if (minimo.codigoProvincia <> valorAlto) then
        leerDetalle (vectorD[pos], vectorR[pos]);
end;


procedure actualizarArchivoMaestro (var archM: archivoMaestro; var vectorD: vectorDetalles);
var
    i: subrango;
    cantLocalidadesSinChapa: integer;
    regM: registroMaestro;
    minimo: registroDetalle;
    vectorR: vectorRegistros;
begin
    reset (archM);
    for i := 1 to dF do begin
        reset (vectorD[i]);
        leerDetalle (vectorD[i], vectorR[i]);
    end;
    cantLocalidadesSinChapa := 0;

    leerMaestro (archM, regM);
    buscarMinimo (vectorD, vectorR, minimo);
    while (regM.codigoProvincia <> valorAlto) do begin
        // La misma combinación de provincia y localidad aparece a lo sumo una única vez en archivos maestro y detalle
        if (minimo.codigoProvincia <> valorAlto) then begin
            if (regM.codigoProvincia = minimo.codigoProvincia) and (regM.codigoLocalidad = minimo.codigoLocalidad) then begin
                regM.cantViviendasSinLuz := regM.cantViviendasSinLuz - minimo.cantViviendasConLuz;
                regM.cantViviendasSinAgua := regM.cantViviendasSinAgua - minimo.cantViviendasConAgua;
                regM.cantViviendasSinGas := regM.cantViviendasSinGas - minimo.cantViviendasConGas;
                regM.cantViviendasSinSanitarios := regM.cantViviendasSinSanitarios - minimo.cantEntregaSanitarios;
                regM.cantViviendasChapa := regM.cantViviendasChapa - minimo.cantViviendasConstruidas;
                // Solo escribe en el archivo maestro si actualiza los datos
                seek (archM, filePos(archM)-1);
                write (archM, regM);
                // Solo avanza en los detalles si actualiza el maestro, sino significa que aún no encontró la posición a actualizar
                buscarMinimo (vectorD, vectorR, minimo);
            end;
        end;
        // Contamos las localidades sin viviendas de chapa, independientemente de si fueron actualizadas o no
        if (regM.cantViviendasChapa = 0) then 
            cantLocalidadesSinChapa := cantLocalidadesSinChapa + 1;
        leerMaestro (archM, regM);
    end;

    writeln ('La cantidad de localidades sin viviendas de chapa es: ', cantLocalidadesSinChapa);
    close (archM);
    for i:= 1 to dF do
        close (vectorD[i]);
end;

var
    archM: archivoMaestro;
    vectorD: vectorDetalles;
begin
    crearArchivoMaestro (archM); // Se dispone
    crearArchivosDetalles (vectorD);
    actualizarArchivoMaestro (archM, vectorD);
end.