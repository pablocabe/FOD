{
Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario.

Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
prendas que quedarán obsoletas.

Deberá implementar un procedimiento que reciba ambos archivos y realice la baja lógica de las prendas, 
para ello deberá modificar el stock de la prenda correspondiente a valor negativo.

Adicionalmente, deberá implementar otro procedimiento que se encargue de
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta.

Para ello se deberá utilizar una estructura
auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas.

Al finalizar este proceso de compactación
del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
original.
}

program P3Ej6;

const
    valorAlto = 9999;

type
    registroMaestro = record
        codigoPrenda: integer;
        descripción: string;
        colores: string;
        tipoPrenda: string;
        stock: integer; // Para el borrado logico
        precio: real;
    end;

    registroDetalle = record
        codigoPrenda: integer;
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
        read (archM, regM);
        while (regM.codigoPrenda <> regD.codigoPrenda) do
            read (archM, regM);
        seek (archM, filePos (archM)-1);
        regM.stock := regM.stock * -1;
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