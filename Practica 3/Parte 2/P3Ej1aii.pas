{
El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran
todos los productos que comercializa. De cada producto se maneja la siguiente
información: código de producto, nombre comercial, precio de venta, stock actual y
stock mínimo. Diariamente se genera un archivo detalle donde se registran todas las
ventas de productos realizadas. De cada venta se registran: código de producto y
cantidad de unidades vendidas. Resuelve los siguientes puntos:

a. Se pide realizar un procedimiento que actualice el archivo maestro con el
archivo detalle, teniendo en cuenta que:

ii. Cada registro del maestro puede ser actualizado por 0, 1 ó más registros
del archivo detalle.
}

program P3Ej1aii;

type

    registroMaestro = record
        codigo: integer;
        nombre: string;
        precio: real;
        stockActual: integer;
        stockMinimo: integer;
    end;

    registroDetalle = record
        codigo: integer;
        ventas: integer;
    end;

    archivoMaestro = file of registroMaestro;

    archivoDetalle = file of registroDetalle;


procedure crearArchivoMaestro (var archM: archivoMaestro) // Se dispone


procedure crearArchivoDetalle (var archD: archivoDetalle) // Se dispone


procedure actualizarArchivoMaestro (var archM: archivoMaestro; var archD: archivoDetalle);
var
    regM: registroMaestro;
    regD: registroDetalle;
begin
    reset (archM);
    reset (archD);

    while (not EOF (archD)) do begin
        read (archD, regD);
        seek (archM, 0);
        read (archM, regM);
        while (regD.codigo <> regM.codigo) do begin // Nunca va a llegar a EOF porque existen todos los elementos en ambos archivos
            read (archM, regM);
        end;
        regM.stockActual := regM.stockActual - regD.ventas;
        seek (archM, filePos(archM)-1);
        write (archM, regM);
    end;

    close (archM);
    close (archD);
end;

var
    archM: archivoMaestro;
    archD: archivoDetalle;
begin
    crearArchivoMaestro (archM); // Se dispone
    crearArchivoDetalle (archD); // Se dispone
    actualizarArchivoMaestro (archM, archD);
end.