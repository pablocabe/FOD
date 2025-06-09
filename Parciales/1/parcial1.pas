{
Se desea automatizar el manejo de información referente a los casos positivos de dengue para la Provincia de Buenos Aires.
Para esto se cuenta con un archivo maestro que contiene la siguiente información:
código de municipio, nombre municipio y cantidad de casos positivos.
Dicho archivo está ordenado por código de municipio.

Todos los meses se reciben 30 archivos que contienen la siguiente información:
código de municipio y cantidad de casos positivos. El orden de cada archivo detalle es por código de municipio.
En cada archivo puede venir información de cualquier municipio, un municipio puede aparecer cero una o más veces en un cada archivo.

Realice el sistema completo que permita la actualización de la información del archivo maestro
a partir de los archivos detalle recaudando la cantidad de casos positivos e informando por pantalla
aquellos municipios (código y nombre) donde la cantidad total de casos positivos es mayor a 15.

Nota: cada archivo debe recorrerse una única vez.
Nota 1: Los nombres de los archivos deben pedirse por teclado. Se puede suponer que los nombres ingresados corresponden a archivos existentes.
Nota 2: El informe debe incluir cualquier municipio que cumpla la condición, independientemente de si se actualiza o no.
Nota 3: Todos los registros existentes en los detalles, existen si o si en el archivo maestro.
}

program parcial1;

const
    dF = 30;
    valorAlto = 9999;

type
    subrango = 1 .. dF;

    registroMaestro = record
        codigo: integer;
        nombre: string;
        cantCasosPositivos: integer;
    end;

    registroDetalle = record
        codigo: integer;
        cantCasosPositivos: integer;
    end;

    archivoMaestro = file of registroMaestro; // Ordenado por código de municipio

    archivoDetalle = file of registroDetalle; // Ordenado por código de municipio

    vectorDetalles = array [subrango] of archivoDetalle;

    vectorRegistros = array [subrango] of registroDetalle;


procedure inicializarArchivos (var archM: archivoMaestro; var vectorD: vectorDetalles);
var
    i: subrango;
    nombreArchivo: string;
begin
    writeln ('Ingrese el nombre del archivo maestro');
    readln (nombreArchivo);
    assign (archM, nombreArchivo);
    for i := 1 to dF do begin
        writeln ('Ingrese el nombre del archivo detalle N° ', i);
        readln (nombreArchivo);
        assign (vectorD[i], nombreArchivo);
    end;
end;


procedure leerMaestro (var archM: archivoMaestro; var regM: registroMaestro);
begin
    if (not EOF (archM)) then
        read (archM, regM)
    else
        regM.codigo := valorAlto;
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


procedure actualizarArchivoMaestro (var archM: archivoMaestro; var vectorD: vectorDetalles);
var
    i: subrango;
    regM: registroMaestro;
    minimo: registroDetalle;
    vectorR: vectorRegistros;
begin
    reset (archM);
    for i := 1 to dF do begin
        reset (vectorD[i]);
        leerDetalle (vectorD[i], vectorR[i]);
    end;

    leerMaestro (archM, regM);
    buscarMinimo (vectorD, vectorR, minimo);

    while (regM.codigo <> valorAlto) do begin // Mientras no termine de recorrer el archivo Maestro
        while (regM.codigo = minimo.codigo) do begin // Mientras sean iguales sigo sumando
            regM.cantCasosPositivos := regM.cantCasosPositivos + minimo.cantCasosPositivos;
            buscarMinimo (vectorD, vectorR, minimo);
        end;
        if (regM.cantCasosPositivos > 15) then
            writeln ('El municipio ', regM.nombre, ' con codigo ', regM.codigo, ' cuenta con mas de 15 casos positivos');
        seek (archM, filePos(archM)-1);
        write (archM, regM);
        leerMaestro (archM, regM);
    end;

    close (archM);
    for i := 1 to dF do
        close (vectorD[i]);
end;

var
    archM: archivoMaestro;
    vectorD: vectorDetalles;
begin
    inicializarArchivos (archM, vectorD);
    actualizarArchivoMaestro (archM, vectorD);
end.