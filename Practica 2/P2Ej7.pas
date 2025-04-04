program P2Ej7;

const
    valorInvalido = 9999;

type

    alumno = record
        codigo: integer;
        apellido: string;
        nombre: string;
        cantMateriasAprobadas: integer;
        cantMateriasConFinal: integer;
    end;

    materia = record
        codigo: integer;
        aproboCursada: boolean;
        aproboFinal: boolean;
    end;

    archivoMaestro = file of alumno;

    archivoDetalle = file of materia;


procedure crearArchivoMaestro(var archM: archivoMaestro); // se dispone


procedure crearArchivoDetalle(var archD: archivoDetalle); // se dispone


procedure leer(var archD: archivoDetalle; var regD: materia);
begin
    if (not EOF(archD)) then
        read (archD, regD)
    else
        regD.codigo := valorInvalido; // asigno un valor de corte
end;


procedure actualizarArchivoMaestro(var archM: archivoMaestro; var archD: archivoDetalle);
var
    regM: alumno;
    regD: materia;
begin
    reset(archM);
    reset(archD);
    leer (archD, regD);
    while (regD.codigo <> valorInvalido) do begin
        read (archM, regM);
        while (regD.codigo <> regM.codigo) do
            read (archM, regM);
        while (regD.codigo = regM.codigo) do begin
            if (regD.aproboFinal) then begin
                regM.cantMateriasConFinal := regM.cantMateriasConFinal + 1;
                regM.cantMateriasAprobadas := regM.cantMateriasAprobadas - 1;
            end
            else if (regD.aproboCursada) then
                regM.cantMateriasAprobadas := regM.cantMateriasAprobadas + 1;
            leer (archD, regD);
        end;
        seek (archM, filePos(archM)-1);
        write (archM, regM);
    end;
  writeln ('Archivo maestro actualizado');
  close(archM);
  close(archD);
end;


procedure exportarTexto (var archM: archivoMaestro);
var
    regM: alumno;
    archTexto: text;
    nombreArchivo: string;
begin
    writeln ('Ingrese el nombre del archivo de texto');
    readln (nombreArchivo);
    assign (archTexto, nombreArchivo);
    rewrite (archTexto);
    reset (archM);
    while (not EOF (archM)) do begin
        read (archM, regM);
        if (regM.cantMateriasConFinal > regM.cantMateriasAprobadas) then begin
            with regM do begin
                // writeln (archTexto, 'Codigo=', codigo,' Apellido=', apellido ,'Nombre=', nombre, 'MateriasConFinal=', cantMateriasConFinal, ' MateriasSinFinal=', cantMateriasAprobadas);
                writeln (archTexto, codigo, ' ', apellido, ' ', nombre, ' ', cantMateriasConFinal, ' ', cantMateriasAprobadas);
            end;
        end;

    end;
    writeln ('Archivo exportado');
    close (archTexto);
    close (archM);
end;


procedure abrirMenuPrincipal (var archM: archivoMaestro; var archD: archivoDetalle);
var
    opcion: integer;
begin
    writeln ('Menu principal de opciones');
    writeln ('0. Salir del menu y terminar la ejecucion del programa');
    writeln ('1. Actualizar el archivo maestro');
    writeln ('2. Listar en un archivo de texto');
    readln (opcion);
    while (opcion <> 0) do begin
        case opcion of
            1: actualizarArchivoMaestro (archM, archD);
            2: exportarTexto (archM);
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
    crearArchivoMaestro(archM); // se dispone
    crearArchivoDetalle(archD); // se dispone
    abrirMenuPrincipal (archM, archD);
end.

{
Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).

Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:

a. Actualizar el archivo maestro de la siguiente manera:

i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado,
y se decrementa en uno la cantidad de materias sin final aprobado.

ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.

b. Listar en un archivo de texto aquellos alumnos que tengan más materias con finales
aprobados que materias sin finales aprobados. Teniendo en cuenta que este listado
es un reporte de salida (no se usa con fines de carga), debe informar todos los
campos de cada alumno en una sola línea del archivo de texto.

NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.


Se dispone de un archivo maestro con información de los alumnos de la Facultad de
Informática. Cada registro del archivo maestro contiene: código de alumno, apellido, nombre,
cantidad de cursadas aprobadas y cantidad de materias con final aprobado. El archivo
maestro está ordenado por código de alumno.
Además, se tienen dos archivos detalle con información sobre el desempeño académico de
los alumnos: un archivo de cursadas y un archivo de exámenes finales. El archivo de
cursadas contiene información sobre las materias cursadas por los alumnos. Cada registro
incluye: código de alumno, código de materia, año de cursada y resultado (solo interesa si la
cursada fue aprobada o desaprobada). Por su parte, el archivo de exámenes finales
contiene información sobre los exámenes finales rendidos. Cada registro incluye: código de
alumno, código de materia, fecha del examen y nota obtenida. Ambos archivos detalle
están ordenados por código de alumno y código de materia, y pueden contener 0, 1 o
más registros por alumno en el archivo maestro. Un alumno podría cursar una materia
muchas veces, así como también podría rendir el final de una materia en múltiples
ocasiones.
Se debe desarrollar un programa que actualice el archivo maestro, ajustando la cantidad
de cursadas aprobadas y la cantidad de materias con final aprobado, utilizando la
información de los archivos detalle. Las reglas de actualización son las siguientes:
● Si un alumno aprueba una cursada, se incrementa en uno la cantidad de cursadas
aprobadas.
● Si un alumno aprueba un examen final (nota >= 4), se incrementa en uno la cantidad
de materias con final aprobado.
Notas:
● Los archivos deben procesarse en un único recorrido.
● No es necesario comprobar que no haya inconsistencias en la información de los
archivos detalles. Esto es, no puede suceder que un alumno apruebe más de una
vez la cursada de una misma materia (a lo sumo la aprueba una vez), algo similar
ocurre con los exámenes finales.
}