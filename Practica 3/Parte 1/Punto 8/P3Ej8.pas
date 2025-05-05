{
Se cuenta con un archivo con información de las diferentes distribuciones de linux 
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de 
versión  del  kernel,  cantidad  de  desarrolladores  y  descripción.  El  nombre  de  las 
distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas 
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida. 
Escriba  la  definición  de  las  estructuras  de  datos  necesarias  y  los  siguientes 
procedimientos:

a.  BuscarDistribucion:  módulo  que  recibe  por  parámetro  el  archivo,  un 
nombre de distribución y devuelve la posición dentro del archivo donde se 
encuentra  el registro correspondiente a la distribución dada (si existe) o 
devuelve -1 en caso de que no exista.

b.  AltaDistribucion: módulo que recibe como parámetro el archivo y el registro 
que contiene los datos de una nueva distribución, y se encarga de agregar 
la distribución al archivo reutilizando espacio disponible en caso de que 
exista. (El control de unicidad lo debe realizar utilizando el módulo anterior). 
En caso de que la distribución que se quiere agregar ya exista se debe 
informar “ya existe la distribución”. 

c.  BajaDistribucion:  módulo  que  recibe  como  parámetro  el  archivo  y  el 
nombre de una distribución, y se encarga de dar de baja lógicamente la 
distribución  dada.  Para  marcar una distribución como borrada se debe 
utilizar el campo cantidad de desarrolladores para mantener actualizada 
la lista invertida. Para verificar que la distribución a borrar exista debe utilizar 
el  módulo  BuscarDistribucion.  En  caso  de  no  existir  se  debe  informar 
“Distribución no existente”.
}

program P3Ej8;

type
    str30 = string[30];
    str100 = string[100];

    registroDistribucion = record
        nombre: str30;
        anio: integer;
        version: real;
        cantDesarrolladores: integer;
        descripcion: str100;
    end;

    archivoMaestro = file of registroDistribucion;


procedure leerDistribucion (var distribucion: registroDistribucion);
begin
    with distribucion do begin
        writeln ('Ingrese el nombre');
        readln (nombre);
        if (nombre <> 'fin') then begin
            writeln ('Ingrese el anio');
            readln (anio);
            writeln ('Ingrese la version');
            readln (version);
            writeln ('Ingrese la cantidad de desarrolladores');
            readln (cantDesarrolladores);
            writeln ('Ingrese la descripcion');
            readln (descripcion);
        end;
    end;
end;


procedure crearArchivoMaestro (var archM: archivoMaestro);
var
    d: registroDistribucion;
begin
    assign (archM, 'ArchivoMaestro');
    rewrite (archM);
    d.nombre:= '';
    d.cantDesarrolladores:= 0;
    d.anio:= 0;
    d.version:= 0;
    d.descripcion:= '';
    write (archM, d);
    leerDistribucion (d);
    while(d.nombre <> 'fin') do
        begin
            write (archM, d);
            leerDistribucion (d);
        end;
    close(archM);
end;


// Reset y close inncesarios, se perderia el puntero del archivo pasado
function buscarDistribucion (var archM: archivoMaestro; nombreAux: str30): integer;
var
    regM: registroDistribucion;
    posicion: integer;
begin
    posicion := -1;
    reset(archM);
    seek(archM, 1);  // Saltar el registro cabecera
    while (not EOF(archM)) and (posicion = -1) do begin
        read(archM, regM);
        if (regM.nombre = nombreAux) then
            posicion := filePos(archM) - 1;
    end;
    close(archM);
    buscarDistribucion := posicion;
end;


procedure altaDistribucion (var archM: archivoMaestro; distribucion: registroDistribucion);
var
    regM: registroDistribucion;
begin
    reset (archM);
    if ((buscarDistribucion (archM, distribucion.nombre)) = -1) then begin // Se puede agregar porque no existe
        read (archM, regM); // Se lee el registro cabecera
        if (regM.cantDesarrolladores = 0) then begin // Si no hay espacio disponible segun el registro cabecera
            seek (archM, fileSize (archM));
            write (archM, distribucion);
        end
        else begin
            seek (archM, regM.cantDesarrolladores * -1);
            read (archM, regM);
            seek (archM, filePos(archM)-1);
            write (archM, distribucion);
            seek (archM, 0);
            write (archM, regM);
        end;
    end else
        writeln('Ya existe la distribucion');
    close(archM);
end;


procedure bajaDistribucion (var archM: archivoMaestro; nombreAux: str30);
var
    regM, regCabecera: registroDistribucion;
    posicion: integer;
begin
    reset(archM);
    posicion := buscarDistribucion(archM, nombreAux);
    if (posicion <> -1) then begin
        seek (archM, 0);
        read (archM, regCabecera); // Lee el registro cabecera
        seek (archM, posicion);
        read (archM, regM); // Lee el registro a borrar
        // Apunto el campo cantDesarrolladores del registro borrado al anterior inicio de la lista
        regM.cantDesarrolladores := regCabecera.cantDesarrolladores;
        seek (archM, posicion);
        write (archM, regM); // Escribo el registro actualizado en su lugar
        regCabecera.cantDesarrolladores := posicion * -1;
        seek (archM, 0);
        write (archM, regCabecera)
    end else
        writeln ('Distribucion no existente');
    close (archM);
end;


procedure imprimirDistribucionesActivas (var archM: archivoMaestro);
var
    regM: registroDistribucion;
    pos: integer;
begin
    reset (archM);
    seek (archM, 1);
    pos := 1;
    writeln('Distribuciones activas:');
    while (not EOF (archM)) do begin
        read(archM, regM);
        if (regM.cantDesarrolladores > 0) then begin
            writeln('--- Posición ', pos, ' ---');
            writeln('Nombre: ', regM.nombre);
            writeln('Año: ', regM.anio);
            writeln('Versión: ', regM.version:0:2);
            writeln('Desarrolladores: ', regM.cantDesarrolladores);
            writeln('Descripción: ', regM.descripcion);
            writeln;
        end;
        pos := pos + 1;
    end;
    close (archM);
end;


var
    archM: archivoMaestro;
    nombreAux: str30;
    distribucion: registroDistribucion;
begin
    crearArchivoMaestro (archM);
    leerDistribucion (distribucion);
    altaDistribucion (archM, distribucion);
    writeln ('Ingrese el nombre de una distribucion a eliminar');
    readln (nombreAux);
    bajaDistribucion (archM, nombreAux);
    imprimirDistribucionesActivas (archM);
end.