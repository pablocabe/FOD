{
La editorial X, autora de diversos semanarios, posee un archivo maestro con la información
correspondiente a las diferentes emisiones de los mismos. De cada emisión se registra:
fecha, código de semanario, nombre del semanario, descripción, precio, total de ejemplares
y total de ejemplares vendidos.

Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
actualización del archivo maestro en función de las ventas registradas. Además deberá
informar fecha y semanario que tuvo más ventas y la misma información del semanario con
menos ventas.

Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
ventas de semanarios si no hay ejemplares para hacerlo.
}


// Me falta informar y cambiar tantas variables por 2 registrosDetalle
program P2Ej16;

const
    dF = 100;
    valorAlto = 9999;

type
    subrango = 1 .. dF;

    registroMaestro = record
        fecha: integer;
        codigoSemanario: integer;
        nombreSemanario: string;
        descripcion: string;
        precio: real;
        totalEjemplares: integer;
        totalEjemplaresVendidos: integer;
    end;

    registroDetalle = record
        fecha: integer;
        codigoSemanario: integer;
        cantEjemplaresVendidos: integer;
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


procedure leerDetalle (var archD: archivoDetalle; var regD: registroDetalle);
begin
    if (not EOF (archD)) then
        read (archD, regD)
    else
        regD.fecha := valorAlto;
end;


procedure buscarMinimo (var vectorD: vectorDetalles; var vectorR: vectorRegistros; var minimo: registroDetalle);
var
    i, pos: subrango;
begin
    minimo.fecha := valorAlto;
    minimo.codigoSemanario := valorAlto;
    for i := 1 to dF do begin
        if (vectorR[i].fecha < minimo.fecha) or 
        ((vectorR[i].fecha = minimo.fecha) and (vectorR[i].codigoSemanario < minimo.codigoSemanario)) then begin
            minimo := vectorR[i];
            pos := i;
        end;
    end;
    if (minimo.fecha <> valorAlto) then
        leerDetalle (vectorD[pos], vectorR[pos]);
end;


procedure actualizarArchivoMaestro (var archM: archivoMaestro; var vectorD: vectorDetalles);
var
    i: subrango;
    minimo: registroDetalle;
    vectorR: vectorRegistros;
    fechaMaxVentas, codigoMaxVentas, fechaMinVentas, codigoMinVentas, cantMax, cantMin: integer;
begin
    reset (archM);
    for i:= 1 to dF do begin
        reset (vectorD[i]);
        leerDetalle (vectorD[i], vectorR[i]);
    end;
    fechaMaxVentas := 0;
    fechaMinVentas := 0;
    codigoMaxVentas := 0;
    codigoMinVentas := 0;
    cantMax := 0;
    cantMin := 0;

    leerMaestro (archM, regM);
    buscarMinimo (vectorD, vectorR, minimo);
    while (minimo.fecha <> valorAlto) do begin

        while (minimo.fecha <> regM.fecha) do
            read (archM, regM);

        while (minimo.fecha = regM.fecha) do begin
            while (minimo.codigoSemanario <> regM.codigoSemanario) do
                read (archM, regM);

            while (minimo.fecha = regM.fecha) and (minimo.codigoSemanario = regM.codigoSemanario) do begin
                if (regM.totalEjemplares > minimo.cantEjemplaresVendidos) then begin
                    regM.totalEjemplaresVendidos := regM.totalEjemplaresVendidos + minimo.cantEjemplaresVendidos;
                    regM.totalEjemplares := regM.totalEjemplares - minimo.cantEjemplaresVendidos;
                end;
                buscarMinimo (vectorD, vectorR, minimo);
            end;

            if (regM.totalEjemplaresVendidos > cantMax) then begin
                fechaMaxVentas := regM.fecha;
                codigoMaxVentas := regM.codigoSemanario;
            end;

            if (regM.totalEjemplaresVendidos < cantMin) then begin
                fechaMinVentas := regM.fecha;
                codigoMinVentas := regM.codigoSemanario;
            end;

            seek (archM, filePos(archM)-1);
            write (archM, regM);
        end;

    end;

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