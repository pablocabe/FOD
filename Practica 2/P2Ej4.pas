program P2Ej4;

const
    dF = 30;
    valorInvalido = 9999;

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

    vectorRegistros = array [subrango] of registroDetalle;


procedure crearArchivoMaestro (var archM: archivoMaestro); // se dispone


procedure crearArchivoDetalle (var archD: archivoDetalle); // se dispone


procedure crearArchivosDetalles (var vectorD: vectorDetalles);
var
    i: subrango;
begin
    for i := 1 to dF do
        crearArchivoDetalle(vectorD[i]); // se dispone
end;

// leer (vectorD[i], vectorR[i]);
procedure leer (var archD: archivoDetalle; var regD: registroDetalle);
begin
    if (not EOF(archD)) then
        read (archD, regD)
    else
        regD.codigo := valorInvalido; // asigno un valor de corte
end;


procedure buscarMinimo (var vectorD: vectorDetalles; var vectorR: vectorRegistros; var minimo: registroDetalle);
var
    i, pos: subrango;
begin
    minimo.codigo := valorInvalido; // asigno un valor de corte
    for i := 1 to dF do begin // recorro los 30 primeros registros de los detalles
        if (vectorR[i].codigo < minimo.codigo) then begin // si el código del detalle es menor al mínimo
            minimo := vectorR[i]; // asigno el detalle como mínimo
            pos := i; // guardo la posición del mínimo
        end;
    end;
    if (minimo.codigo <> valorInvalido) then // si encontré un mínimo
        leer (vectorD[pos], vectorR[pos]); // leo el siguiente registro del detalle
end;

{
A	6	8	12  EOF
B	2	3	5   EOF
C	1	7	9   EOF

vR
6
2
1
}


procedure informarArchivoTexto (var archM: archivoMaestro);
var
    archivoTexto: text;
    regM: registroMaestro;
var
    archivoTexto: text;
begin
    assign (archivoTexto, 'productos.txt');
    rewrite (archivoTexto);
    reset (archM);
    while (archM <> EOF) do begin
        read (archM, regM);
        if (regM.stockDisponible < regM.stockMinimo) then begin // está bien exportado?
            writeln (archivoTexto, 'Nombre: ', regM.nombre);
            writeln (archivoTexto, 'Descripción: ', regM.descripción);
            writeln (archivoTexto, 'Stock disponible: ', regM.stockDisponible);
            writeln (archivoTexto, 'Precio: ', regM.precio);
        end;
    end;
    close (archM); // por qué este close no va?
    close (archivoTexto);
end;


procedure actualizarArchivoMaestro (var archM: archivoMaestro; var vectorD: vectorDetalles);
var
    i: subrango;
    cantidad, auxiliar: integer;
    producto: registroMaestro;
    minimo: registroDetalle;
    regM: registroMaestro;
    vectorR: vectorRegistros;
begin
    reset (archM);
    for i := 1 to dF do begin
        reset (vectorD[i]); // abro los 30 archivos de detalle
        leer (vectorD[i], vectorR[i]); // leo el primer registro de cada detalle
    end;

    buscarMinimo (vectorD, vectorR, minimo); // busco el mínimo de los detalles
    while (minimo.codigo <> valorInvalido) do begin // mientras no llegue al final de los detalles
        auxiliar := minimo.codigo; // guardo el código del mínimo
        cantidad := 0; // inicializo la cantidad
        while (minimo.codigo <> valorInvalido) and (minimo.codigo = auxiliar) do begin// mientras no llegue al final y el código sea igual al mínimo
            cantidad := cantidad + minimo.cantVentas; // sumo la cantidad de ventas
            buscarMinimo (vectorD, vectorR, minimo); // busco el siguiente mínimo
        end;
        read (archM, regM); // leo el primer registro del maestro
        while (regM.codigo <> auxiliar) do  // mientras no llegue al final del maestro y el código sea distinto al mínimo
            read (archM, regM); // leo el siguiente registro del maestro
        regM.stockDisponible := regM.stockDisponible - cantidad; // actualizo el stock del maestro
        seek (archM, filePos (archM)-1); // posiciono el puntero en el registro a modificar
        write (archM, regM); // escribo el registro modificado
    end;

    informarArchivoTexto (archM); // informo en el archivo de texto
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
    crearArchivosDetalles(vectorD);
    actualizarArchivoMaestro(archM, vectorD);
end.

{
Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.

Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena.
Debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
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