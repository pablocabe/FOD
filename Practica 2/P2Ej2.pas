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


procedure actualizarArchivoMaestro(var archM: archivoMaestro; var archD: archivivoDetalle);
var
    codAlumnoMaestro:integer;
    codAlumnoDetalle:integer;
    regM: alumno;
    regD: materia;
begin
  reset(archM);
  reset(archD);
  read(archM, regM);
  read(archD, regD);
  while (not EOF(archM)) and (not EOF(archD)) do begin
    codAlumnoMaestro := regM.codigo;
    codAlumnoDetalle := regD.codigo;
    if (codAlumnoMaestro = codAlumnoDetalle) then begin
      if (regD.aproboFinal) then begin
        regM.cantMateriasConFinal := regM.cantMateriasConFinal + 1;
        regM.cantMateriasAprobadas := regM.cantMateriasAprobadas - 1;
      end;
      if (regD.aproboCursada) then begin
        regM.cantMateriasAprobadas := regM.cantMateriasAprobadas + 1;
      end;
      seek(archM, filePos(archM) - 1);
      write(archM, regM);
      read(archM, regM);
      read(archD, regD);
    end
    else if (codAlumnoMaestro < codAlumnoDetalle) then begin
      read(archM, regM);
    end
    else begin
      read(archD, regD);
    end;
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