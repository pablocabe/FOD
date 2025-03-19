program P2Ej2;

const
    valorAlto = -1;

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

    archivivoDetalle = file of materia;


procedure crearArchivoMaestro(var archM: archivoMaestro); // se dispone


procedure crearArchivoDetalle(var archD: archivivoDetalle); // se dispone


procedure leer(var archD: archivoDetalle; var regD: empleado);
begin
    if (not EOF(archD)) then
        read (archD, regD)
    else
        regD.codigo := valorAlto; // asigno un valor de corte
end;


procedure actualizarArchivoMaestro(var archM: archivoMaestro; var archD: archivivoDetalle);
var
    regM: alumno;
    regD: materia;
begin
    reset(archM);
    reset(archD);
    leer (archD, regD);
    while (regD.codigo <> valorAlto) do begin
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
  close(archM);
  close(archD);
end;


var
    archM: archivoMaestro;
    archD: archivivoDetalle;
begin
    assign (archM, 'maestro');
    assign (archD, 'detalle');
    crearArchivoMaestro(archM); // se dispone
    crearArchivoDetalle(archD); // se dispone
    actualizarArchivoMaestro(archM, archD);
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

}