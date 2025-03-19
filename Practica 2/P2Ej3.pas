program P2Ej3;

const
    valorInvalido = -1;

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


procedure actualizarArchivoMaestro (var archM: archivoMaestro; var archD: archivoDetalle);
var
    
begin
    
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
        writeln ('Menu principal de opciones');
        writeln ('0. Salir del menu y terminar la ejecucion del programa');
        writeln ('1. Actualizar el archivo maestro');
        writeln ('2. Listar en un archivo de texto');
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