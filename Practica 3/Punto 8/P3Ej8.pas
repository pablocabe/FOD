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

    registroDistribucion = record
        nombre: string; // El nombre de las distribuciones no puede repetirse
        anio: integer;
        version: real;
        cantDesarrolladores: integer;
        descripcion: string;        
    end;

    archivoMaestro = file of registroDistribucion;


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


function buscarDistribucion (var archM: archivoMaestro; nombreAux: string): integer;
var
    regM: registroDistribucion;
    posicion: integer;
    existe: boolean;
begin
    reset (archM);
    existe := false;
    posicion := -1;
    while (not EOF (archM)) and (not existe) do begin
        read (archM, regM);
        if (regM.nombre = nombreAux) then begin
            posicion := filePos(archM) - 1;
            existe := true;
        end;
    end;
    buscarDistribucion := posicion;
    close (archM);
end;


procedure altaDistribucion (var archM: archivoMaestro, distribucion: registroDistribucion);
var
    regM: registroDistribucion;
    posicion: integer;
begin
    reset (archM);
    posicion := buscarDistribucion (archM, distribucion.nombre);
    if (posicion <> -1) then begin // Se puede agregar
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
    end
    else // No se puede agregar
        writeln ('Ya existe la distribucion');
    close (archM);
end;

{
c.  BajaDistribucion:  módulo  que  recibe  como  parámetro  el  archivo  y  el 
nombre de una distribución, y se encarga de dar de baja lógicamente la 
distribución  dada.  Para  marcar una distribución como borrada se debe 
utilizar el campo cantidad de desarrolladores para mantener actualizada 
la lista invertida. Para verificar que la distribución a borrar exista debe utilizar 
el  módulo  BuscarDistribucion.  En  caso  de  no  existir  se  debe  informar 
“Distribución no existente”.
}

procedure bajaDistribucion (var archM: archivoMaestro; nombreAux: string);
var
    regM: registroDistribucion;
    posicion: integer;
begin
    reset (archM);
    posicion := buscarDistribucion (archM, nombreAux);
    if (posicion <> -1) then begin
        
    end
    else
        writeln ('Distribucion no existente');
    close (archM);
end;


var
    archM: archivoMaestro;
    nombreAux: string;
    distribucion: registroDistribucion;
begin
    crearArchivoMaestro (archM);
    leerDistribucion (distribucion);
    altaDistribucion (archM, distribucion);
    writeln ('Ingrese el nombre de una distribucion a eliminar');
    readln (nombreAux);
    bajaDistribucion (archM, nombreAux);
end.