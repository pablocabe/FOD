{
Una empresa dedicada a la venta de golosinas posee un archivo que contiene información
sobre los productos que tiene a la venta. De cada producto se registran los siguientes datos:
código de producto, nombre comercial, precio de venta, stock actual y stock mínimo.
La empresa cuenta con 20 sucursales. Diariamente, se recibe un archivo detalle de cada una de
las 20 sucursales de la empresa que indica las ventas diarias efectuadas por cada sucursal. De
cada venta se registra código de producto y cantidad vendida. Se debe realizar un
procedimiento que actualice el stock en el archivo maestro con la información disponible en los
archivos detalles y que además informe en un archivo de texto aquellos productos cuyo monto
total vendido en el día supere los $10.000. En el archivo de texto a exportar, por cada producto
incluido, se deben informar todos sus datos. Los datos de un producto se deben organizar en el
archivo de texto para facilitar el uso eventual del mismo como un archivo de carga.
El objetivo del ejercicio es escribir el procedimiento solicitado, junto con las estructuras de datos
y módulos usados en el mismo.

Notas:
• Todos los archivos se encuentran ordenados por código de producto.
• En un archivo detalles pueden haber 0, 1 o N registros de un producto determinado.
• Cada archivo detalle solo contiene productos que seguro existen en el archivo maestro.
• Los archivos se deben recorrer una sola vez. En el mismo recorrido, se debe realizar la
actualización del archivo maestro con los archivos detalles, así como la generación del
archivo de texto solicitado.
}

program parcial3;

const
    dF = 20;
    valorAlto = 9999;

type
    subrango = 1 .. dF;

    registroMaestro = record
        codigo: integer;
        nombre: string;
        precio: real;
        stockActual: integer;
        stockMinimo: integer;
    end;

    registroDetalle = record
        codigo: integer;
        cantVentas: integer;
    end;

    archivoMaestro = file of registroMaestro; // Ordenado por codigo de producto

    archivoDetalle = file of registroDetalle; // Ordenado por codigo de producto

    vectorDetalles = array [subrango] of archivoDetalle;

    vectorRegistros = array [subrango] of registroDetalle;


procedure crearArchivoMaestro (var archM: archivoMaestro);
var
    nombre: string;
    cargaText: text;
    regM: registroMaestro;
begin
    writeln ('Ingrese el nombre del archivo maestro');
    readln (nombre);
    assign (archM, nombre);
    rewrite (archM);
    assign(cargaText, 'productos.txt');
    reset (cargaText);

    while (not EOF (cargaText)) do begin
        readln (cargaText, regM.codigo, regM.precio, regM.stockActual, regM.stockMinimo, regM.nombre);
        write (archM, regM);
    end;
    writeln ('Archivo binario maestro creado');
    close (archM);
    close (cargaText);
end;


procedure crearArchivoDetalle (var archD: archivoDetalle);
var
    nombre: string;
    cargaText: Text;
    regD: registroDetalle;
begin
    writeln ('Ingrese la ruta del detalle');
    readln (nombre);
    assign (cargaText, nombre);
    reset (cargaText);
    writeln ('Ingrese el nombre del archivo detalle');
    readln (nombre);
    assign (archD, nombre);
    rewrite (archD);
    while (not EOF (cargaText)) do begin
        readln (cargaText, regD.codigo, regD.cantVentas);
        write (archD, regD);
    end;
    writeln ('Archivo binario detalle creado');
    close (archD);
    close (cargaText);
end;


procedure crearArchivosDetalle (var vectorD: vectorDetalles);
var
    i: subrango;
begin
    for i := 1 to dF do begin
        crearArchivoDetalle (vectorD[i]);
    end;
end;


procedure leerDetalle (var archD: archivoDetalle; var regD: registroDetalle);
begin
    if (not EOF (archD)) then
        read (archD, regD)
    else
        regD.codigo := valorAlto;
end;


procedure buscarMinimo (var vectorD: vectorDetalles; var vectorR: vectorRegistros; var minimo: registroDetalle);
var
    i, pos: subrango;
begin
    minimo.codigo := valorAlto;
    for i := 1 to dF do begin
        if (vectorR[i].codigo < minimo.codigo) then begin
            minimo := vectorR[i];
            pos := i;
        end;
    end;
    if (minimo.codigo <> valorAlto) then
        leerDetalle (vectorD[pos], vectorR[pos]);
end;


procedure actualizarArchivoMaestro (var archM: archivoMaestro; var vectorD: vectorDetalles; var informeTXT: text);
var
    i: subrango;
    regM: registroMaestro;
    minimo: registroDetalle;
    vectorR: vectorRegistros;
    cantVentasDia: integer;
begin
    assign (informeTXT, 'informe.txt');
    rewrite (informeTXT);
    reset (archM);
    for i := 1 to dF do begin
        reset (vectorD[i]);
        leerDetalle (vectorD[i], vectorR[i]);
    end;

    buscarMinimo (vectorD, vectorR, minimo);
    while (minimo.codigo <> valorAlto) do begin // Mientras queden registros por actualizar
        read (archM, regM);
        cantVentasDia := 0;
        while (minimo.codigo <> regM.codigo) do // Mientras no se encuentre el primer registro para actualizar
            read (archM, regM);
        while (minimo.codigo = regM.codigo) do begin // Mientras se siga actualizando el mismo registro
            cantVentasDia := cantVentasDia + minimo.cantVentas;
            buscarMinimo (vectorD, vectorR, minimo);
        end;
        regM.stockActual := regM.stockActual - cantVentasDia;
        if (cantVentasDia * regM.precio > 10000) then
            writeln (informeTXT, regM.codigo, ' ', regM.precio, ' ', regM.stockActual, ' ', regM.stockMinimo, ' ', regM.nombre);
        seek (archM, filePos(archM)-1);
        write (archM, regM);
    end;

    close (archM);
    close (informeTXT);
    for i := 1 to dF do
        close (vectorD[i]);
end;


var
    archM: archivoMaestro;
    vectorD: vectorDetalles;
    informeTXT: text;
begin
    crearArchivoMaestro (archM);
    crearArchivosDetalle (vectorD);
    actualizarArchivoMaestro (archM, vectorD, informeTXT);
end.