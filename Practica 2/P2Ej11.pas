program P2Ej11;

const
    
    valorAlto = 9999;

type

    registroEmpleado = record;
        departamento: integer;
        division: integer;
        numeroEmpleado: integer;
        categoría: integer;
        cantHoras: integer;
    end;

    archivoEmpleados = file of registroEmpleado;


procedure crearArchivoMaestro (var archM: archivoMaestro) // Se dispone


procedure informarArchivoMaestro (var archM: archivoMaestro);
var

begin
    
end;


var
    archM: archivoEmpleados;
begin
    crearArchivoMaestro (archM) // Se dispone
    informarArchivoMaestro (archM);
end.

{
Se tiene información en un archivo de las horas extras realizadas por los empleados de una
empresa en un mes. Para cada empleado se tiene la siguiente información: departamento,
división, número de empleado, categoría y cantidad de horas extras realizadas por el
empleado.

Se sabe que el archivo se encuentra ordenado por departamento, luego por
división y, por último, por número de empleado.

Presentar en pantalla un listado con el siguiente formato:

Departamento
División
Número de Empleado Total de Hs. Importe a cobrar
...... .......... .........
...... .......... .........
Total de horas división: ____
Monto total por división: ____
División
.................
Total horas departamento: ____
Monto total departamento: ____

Para obtener el valor de la hora se debe cargar un arreglo desde un archivo de texto al
iniciar el programa con el valor de la hora extra para cada categoría. La categoría varía
de 1 a 15. En el archivo de texto debe haber una línea para cada categoría con el número
de categoría y el valor de la hora, pero el arreglo debe ser de valores de horas, con la
posición del valor coincidente con el número de categoría.
}