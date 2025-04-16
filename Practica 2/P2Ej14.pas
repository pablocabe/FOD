{
Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus
próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la
cantidad de asientos disponibles. 

La empresa recibe todos los días dos archivos detalles para actualizar el archivo maestro. 
En dichos archivos se tiene destino, fecha, hora de salida y cantidad de asientos comprados.
Se sabe que los archivos están ordenados por destino más fecha y hora de salida, 
y que en los detalles pueden venir 0, 1 ó más registros por cada uno del maestro.

Se pide realizar los módulos necesarios para:

a. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
sin asiento disponible.

b. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
tengan menos de una cantidad específica de asientos disponibles. La misma debe
ser ingresada por teclado.

NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.
}

program P2Ej14;

const
    valorAltoString = 'ZZZ';
    valorAltoInteger = 9999;

type
    registroMaestro = record
        destino: string;
        fecha: integer;
        horarioSalida: integer;
        cantAsientosDisponibles: integer;
    end;

    registroDetalle = record
        destino: string;
        fecha: integer;
        horarioSalida: integer;
        cantAsientosComprados: integer;
    end;

    archivoMaestro = file of registroMaestro;

    archivoDetalle = file of registroDetalle;


procedure crearArchivoMaestro (var archM: archivoMaestro) // Se dispone


procedure crearArchivoDetalle (var archD: archivoDetalle) // Se dispone


procedure leerDetalle (var archD: archivoDetalle; var regD: registroDetalle);
begin
    if (not EOF(archD)) then
        read (archD, regD)
    else
        regD.destino := valorAltoString; // Asigno un valor de corte
end;


procedure actualizarArchivoMaestro (var archM: archivoMaestro; var archD1: archivoDetalle; var archD2: archivoDetalle);
var
    regM: registroMaestro;
    regD1, regD2, minimo: registroDetalle;
    archivoTexto: Text;
    cantEspecificaAsientos: integer;
begin
    reset (archM);
    reset (archD1);
    reset (archD2);
    assign(archivoTexto, 'vuelosConPocosAsientos.txt');
    rewrite(archivoTexto);
    writeln ('Ingrese una cantidad limite de asientos disponibles para el listado de vuelos');
    readln (cantEspecificaAsientos);
    leerDetalle (archD1, regD1);
    leerDetalle (archD2, regD2);
    buscarMinimo (archD1, archD2, regD1, regD2, minimo);

    while (minimo.destino <> valorAltoString) do begin
        read (archM, regM);
        while (regM.destino <> minimo.destino) do begin
            read (archM, regM);
            while (regM.destino <> minimo.destino) and (regM.horarioSalida <> minimo.horarioSalida) do begin
                read (archM, regM);
                while (regM.destino <> minimo.destino) and (regM.fecha <> minimo.fecha) and (regM.horarioSalida <> minimo.horarioSalida) do begin
                    read (archM, regM);
                end;
                while (regM.destino = minimo.destino) and (regM.fecha = minimo.fecha) and (regM.horarioSalida = minimo.horarioSalida) do begin
                    regM.asientosDisponibles := regM.asientosDisponibles - regD.asientosComprados;
                    buscarMinimo (archD1, archD2, regD1, regD2, minimo);
                end;
                if (regM.asientosDisponibles < cantEspecificaAsientos) then begin
                    writeln (archivoTexto, regM.destino, ' ', regM.fecha, ' ', regM.hora);
                end;
                seek (archM, filePos(archM)-1);
                write (archM, regM);
            end;
        end;
    end;

    close (archM);
    close (archD1);
    close (archD2);
    close (archivoTexto);
end;


var
    archM: archivoMaestro;
    archD1: archivoDetalle;
    archD2: archivoDetalle;
begin
    crearArchivoMaestro (archM); // Se dispone
    crearArchivoDetalle (archD1); // Se dispone
    crearArchivoDetalle (archD2); // Se dispone
    actualizarArchivoMaestro (archM, archD1, archD2);
end.
