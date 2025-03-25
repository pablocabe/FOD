program P2Ej5;

const
    dF = 30;
    valorInvalido = -1;

type
    subrango = 1 .. dF;

    registroMaestro = record
        codigo: integer;
        nombre: string;
        descripción: string;
        stockDisponible: integer;
        stockMinimo: integer;
        precio: real;
    end;

    registroDetalle = record
        codigo: integer;
        cantVentas: integer
    end;

    archivoMaestro = file of registroMaestro;

    archivoDetalle = file of registroDetalle;

    vectorDetalles = array [subrango] of archivoDetalle;

    vectorRegistros = array [subrango] of registroDetalle; // no entiendo para qué es necesario


procedure crearArchivoMaestro (var archM: archivoMaestro); // se dispone


procedure crearArchivoDetalle (var archD: archivoDetalle); // se dispone


procedure crearArchivosDetalles (var vectorD: vectorDetalles);
var
    i: subrango;
begin
    for i := 1 to dF do
        crearArchivoDetalle(vectorD[i]); // se dispone
end;


procedure leer (var archD: archivoDetalle; var regD: registroDetalle);
begin
    if (not EOF(archD)) then
        read (archD, regD)
    else
        regD.codigo := valorInvalido; // asigno un valor de corte
end;


procedure buscarMinimo (var vectorD: vectorDetalles; var vectorR: vectorRegistros; var minimo: registroDetalle);
begin
    
end;


procedure actualizarArchivoMaestro (var archM: archivoMaestro; var vectorD: vectorDetalles);
var
    i: subrango;
    producto: registroMaestro;
    minimo: registroDetalle;
    vectorR: vectorRegistros;
begin
    reset (archM);
    for i := 1 to dF do begin
        reset (vectorD[i]);
        leer (vectorD[i], vectorR[i]);
    end;
    buscarMinimo (vectorD, vectorR, minimo);

    close (archM);
    for i := 1 to dF do begin
        close (vectorD[i]);
    end;
end;


var
    archM: archivoMaestro;
    vectorD: vectorDetalles;
begin
    assign (archM, 'maestro');
    crearArchivoMaestro(archM); // se dispone
    crearArchivosDetalles(vectorD); // se dispone
    actualizarArchivoMaestro(archM, vectorD);
end.

{
Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.

Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida.

Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).

Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.
}