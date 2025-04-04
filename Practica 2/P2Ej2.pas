program P2Ej2;

const
    valorInvalido = 9999;

type

    producto = record
        codigo: integer;
        nombre: string;
        precio: real;
        stockActual: integer;
        stockMinimo: integer;
    end;

    venta = record
        codigo: integer;
        cantVentas: integer;
    end;

    archivoMaestro = file of producto; // es el archivo donde figuran todos los productos comercializados

    archivoDetalle = file of venta; // es el archivo donde figuran las ventas diarias


procedure crearArchivoMaestro(var archM: archivoMaestro); // se dispone


procedure crearArchivoDetalle(var archD: archivoDetalle); // se dispone


procedure leer(var archD: archivoDetalle; var regD: venta);
begin
    if (not EOF(archD)) then
        read (archD, regD)
    else
        regD.codigo := valorInvalido; // asigno un valor de corte
end;


procedure actualizarArchivoMaestro (var archM: archivoMaestro; var archD: archivoDetalle);
var
    regM: producto;
    regD: venta;
begin
    reset (archM);
    reset (archD);
    leer (archD, regD);
    while (regD.codigo <> valorInvalido) do begin
        read (archM, regM);
        while (regD.codigo <> regM.codigo) do
            read (archM, regM);
        while (regD.codigo = regM.codigo) do begin
            regM.stockActual := regM.stockActual - regD.cantVentas;
            leer (archD, regD);
        end;
        seek (archM, filePos(archM)-1);
        write (archM, regM);
    end;
    writeln ('Archivo maestro actualizado');
    close(archM);
    close(archD);
end;


procedure listarProductosEspecificos (var archM: archivoMaestro);
var
    p: producto;
    archTexto: text;
begin
    reset (archM);
    assign (archTexto, 'stock_minimo.txt');
    rewrite (archTexto);
    while (not EOF (archM)) do begin
        read (archM, p);
        if (p.stockActual < p.stockMinimo) then begin
            with p do begin
                writeln (archTexto, codigo, ' ', nombre, ' ', precio:0:2, ' ', stockActual, ' ', stockMinimo);
            end;
        end;
    end;
    close (archM);
    close (archTexto);
end;


procedure abrirMenuPrincipal (var archM: archivoMaestro; var archD: archivoDetalle);
var
    opcion: integer;
begin
    writeln ('Menu principal de opciones');
    writeln ('0. Salir del menu y terminar la ejecucion del programa');
    writeln ('1. Crear archivo maestro');
    writeln ('2. Crear archivo detalle');
    writeln ('3. Actualizar el archivo maestro');
    writeln ('4. Listar productos especificos en un archivo de texto');
    readln (opcion);
    while (opcion <> 0) do begin
        case opcion of
            1: crearArchivoMaestro(archM); // se dispone
            2: crearArchivoDetalle(archD); // se dispone
            3: actualizarArchivoMaestro (archM, archD);
            4: listarProductosEspecificos (archM);
        else
            writeln ('Opcion inexistente');
        end;
        writeln ('0. Salir del menu y terminar la ejecucion del programa');
        writeln ('1. Crear archivo maestro');
        writeln ('2. Crear archivo detalle');
        writeln ('3. Actualizar el archivo maestro');
        writeln ('4. Listar productos especificos en un archivo de texto');
        readln (opcion);
    end;
end;


var
    archM: archivoMaestro;
    archD: archivoDetalle;
begin
    assign (archM, 'maestro');
    assign (archD, 'detalle');
    abrirMenuPrincipal (archM, archD);
end.

{
El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende.

Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo.

Diariamente se genera un archivo detalle donde se registran todas las ventas de productos realizadas.
De cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:

a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:

● Ambos archivos están ordenados por código de producto.

● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.

● El archivo detalle sólo contiene registros que están en el archivo maestro.

b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.
}