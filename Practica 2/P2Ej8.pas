program P2Ej8;

const
    dF = 16;
    valorAlto = 9999;

type
    subrango = 1 .. dF;

    registroMaestro = record
        codigo: integer;
        nombre: string;
        cantHabitantes: integer;
        cantTotalKilos: integer;
    end;

    registroDetalle = record
        codigo: integer;
        cantKilos: integer;
    end;

    archivoMaestro = file of registroMaestro;

    archivoDetalle = file of registroDetalle;

    vectorDetalles = array [subrango] of archivoDetalle;

    vectorRegistros = array [subrango] of registroDetalle;


procedure crearArchivoMaestro (var archM: archivoMaestro); // se dispone


procedure crearArchivoDetalle (var archD: archivoDetalle); // se dispone


procedure crearArchivosDetalle (var vectorD: vectorDetalles);
var
    i: subrango;
begin
    for i := 1 to dF do begin
        crearArchivoDetalle(vectorD[i]); // se dispone
    end;
end;

// La constante valorAlto = 9999 se usa como un valor de corte artificial para los registros detalle. Su único propósito es:
// Marcar cuándo ya no hay más datos en un archivo detalle, para que buscarMinimo lo ignore en las siguientes iteraciones.

// leer (vectorD[i], vectorR[i]);
procedure leer (var archD: archivoDetalle; var regD: registroDetalle);
begin
    if (not EOF(archD)) then
        read (archD, regD)
    else
        regD.codigo := valorAlto; // asigno un valor de corte
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
        leer (vectorD[pos], vectorR[pos]);
end;


procedure actualizarArchivoMaestro (var archM: archivoMaestro; var vectorD: vectorDetalles);
var
    i: subrango;
    regM: registroMaestro; // Es el que siempre se actualiza y revisa si cumple o no las condiciones de impresión
    regD: registroDetalle; // Es el minimo
    vectorR: vectorRegistros; // Contiene el mínimo de cada archivo detalle
    actualizado: boolean;
begin
    reset (archM);
    for i := 1 to dF do begin
        reset (vectorD[i]);
        leer (vectorD[i], vectorR[i]);
    end;

    buscarMinimo (vectorD, vectorR, regD); // Se toma el primer mínimo
    while (not EOF (archM)) do begin // La condición de corte principal es el final del archivo maestro
        read (archM, regM);
        actualizado := false; // La segunda condición de corte es el valor de cortr del vector de registros

        // En un momento los 16 registros del vectorRegistros van a quedar con el valorAlto,
        // lo cual indica que ya no queda nada por actualizar, por lo que este while no se va a cumplir más
        while (regM.codigo = regD.codigo) do begin
            regM.cantTotalKilos := regM.cantTotalKilos + regD.cantKilos;
            actualizado := true;
            buscarMinimo (vectorD, vectorR, regD);
        end;
        // Podría usar un acumulador auxiliar
        if (actualizado) then begin // Si se cumple, fue actualizado el registro maestro
            seek (archM, filePos (archM)-1);
            write (archM, regM);
        end;
        // Si no fue actualizado, se deja el registro maestro tal cual está y se avanza al siguiente
        if (regM.cantTotalKilos > 10000) then begin // Una vez actualizada -o no- la información de la provincia, se revisa si cumple las condiciones
            writeln ('La provincia ', regM.nombre, ' con codigo ', regM.codigo, ' supera los 10.000 kilos de yerba consumida');
            writeln ('Promedio de yerba consumida por habitante: ', regM.cantTotalKilos / regM.cantHabitantes :0:2);
        end;
    end;

    close (archM);
    for i := 1 to dF do begin
        close (vectorD[i]);
    end;
end;


var
    archM: archivoMaestro;
    vectorD: vectorDetalles;
begin
    crearArchivoMaestro (archM); // se dispone
    crearArchivosDetalle (vectorD);
    actualizarArchivoMaestro (archM, vectorD);
end.


{
Se quiere optimizar la gestión del consumo de yerba mate en distintas provincias de
Argentina. Para ello, se cuenta con un archivo maestro que contiene la siguiente
información: código de provincia, nombre de la provincia, cantidad de habitantes y cantidad
total de kilos de yerba consumidos históricamente.

Cada mes, se reciben 16 archivos de relevamiento con información sobre el consumo de
yerba en los distintos puntos del país. Cada archivo contiene: código de provincia y cantidad
de kilos de yerba consumidos en ese relevamiento. Un archivo de relevamiento puede
contener información de una o varias provincias, y una misma provincia puede aparecer
cero, una o más veces en distintos archivos de relevamiento.

Tanto el archivo maestro como los archivos de relevamiento están ordenados por código de
provincia.

Se desea realizar un programa que actualice el archivo maestro en base a la nueva
información de consumo de yerba. Además, se debe informar en pantalla aquellas
provincias (código y nombre) donde la cantidad total de yerba consumida supere los 10.000
kilos históricamente, junto con el promedio consumido de yerba por habitante. Es importante
tener en cuenta tanto las provincias actualizadas como las que no fueron actualizadas.

Nota: cada archivo debe recorrerse una única vez.
}