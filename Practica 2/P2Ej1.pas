program P2Ej1;

const
    valorAlto = 9999;

type
    empleado = record
        codigo: integer;
        nombre: string;
        comision: real;
    end;

    archivoDetalle = file of empleado; // se dispone de un archivo con la informacion de los empleados

    archivoMaestro = file of empleado; // este archivo se genera con la informacion compactada


procedure crearArchivoDetalle(var archD: archivoDetalle); // se dispone


procedure leer(var archD: archivoDetalle; var regD: empleado);
begin
    if (not EOF(archD)) then
        read (archD, regD)
    else
        regD.codigo := valorAlto; // asigno un valor de corte
end;


procedure compactarArchivo(var archM: archivoMaestro; var archD: archivoDetalle);
var
    regM, regD, auxiliar: empleado;
    totalComision: real;
begin
    rewrite (archM); // creo el archivo maestro
    reset (archD); // abro el archivo detalle
    leer (archD, regD);
    while (regD.codigo <> valorAlto) do begin // mientras no llegue al final del archivo
        auxiliar := regD; // guardo el registro actual
        totalComision := 0;
        while (regD.codigo = auxiliar.codigo) do begin // mientras el codigo sea el mismo
            totalComision := totalComision + regD.comision;
            leer (archD, regD);
        end;
        regM.codigo := auxiliar.codigo;
        regM.nombre := auxiliar.nombre;
        regM.comision := totalComision; // guardo el total de comisiones
        write (archM, regM);
    end;
    close (archM);
    close (archD);    
end;


var
    archM: archivoMaestro;
    archD: archivoDetalle;
begin
    assign (archM, 'maestro');
    assign (archD, 'detalle');
    crearArchivoDetalle(archD); // se dispone
    compactarArchivo(archM, archD);
end.

{
Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.

Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.

NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.
}