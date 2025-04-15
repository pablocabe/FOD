program P2Ej11;

const
    maxCategoria = 15;    
    valorAlto = 9999;

type
    subrangoCategorias = 1 .. maxCategoria;

    vectorValores = array [subrangoCategorias] of real;

    registroEmpleado = record
        departamento: integer;
        division: integer;
        numeroEmpleado: integer;
        categoría: integer;
        cantHoras: integer;
    end;

    archivoEmpleados = file of registroEmpleado;


procedure cargarValoresHoras (var v: vectorValores);
var
    arch: Text;
    categoria: integer;
    valor: real;
begin
    assign (arch, 'valores.txt'); // Nombre del archivo de texto
    reset (arch);

    while (not EOF (arch)) do begin
        Readln(arch, categoria, valor);  // Lee una línea: categoría y valor
        if (categoria >= 1) and (categoria <= maxCategoria) then
            v[categoria] := valor;
    end;

    close (arch);
end;


procedure crearArchivoMaestro (var archM: archivoMaestro) // Se dispone


procedure leer (var archM: archivoMaestro; var regM: registroMaestro);
begin
    if (not EOF(archM)) then
        read (archM, regM)
    else
        regM.departamento := valorAlto; // Asigno un valor de corte
end;


{
{Otra forma de recorrer el archivo maestro
En vez del proceso leer: if (not EOF (archM))
                            read (archM, regM)
Y en el while principal en vez de (regM.departamento <> valorAlto) se utilizaría while (not EOF (archM))
}

procedure informarArchivoMaestro (var archM: archivoMaestro; var v: vectorValores);
var
    regM: registroEmpleado;
    departamentoActual, divisionActual: integer;
    totalHorasDepartamento, totalHorasDivision: integer;
    montoTotalDepartamento, montoTotalDivision: real;
begin
    reset (archM);
    leer (archM, regM);

    while (regM.departamento <> valorAlto) do begin
        departamentoActual := regM.departamento;
        totalHorasDepartamento := 0;
        montoTotalDepartamento := 0;
        writeln ('El departamento actual es: ', departamentoActual);
        while (departamentoActual = regM.departamento) do begin
            divisionActual := regM.division;
            totalHorasDivision := 0;
            montoTotalDivision := 0;
            writeln ('La division actual es: ', divisionActual);
            while (departamentoActual = regM.departamento) and (divisionActual = regM.division) do begin
                totalHorasDivision := totalHorasDivision + regM.cantHoras;
                montoTotalDivision := montoTotalDivision + (regM.cantHoras * v[regM.categoria]);
                writeln ('El numero de empleado es ', regM.numeroEmpleado, ' . Total de horas: ', 
                regM.cantHoras, '. Importe a cobrar: ', (regM.cantHoras * v[regM.categoria]:0:2));
                leer (archM, regM); // Se avanza en el archivo maestro
            end;
            totalHorasDepartamento := totalHorasDepartamento + totalHorasDivision;
            montoTotalDepartamento := montoTotalDepartamento + montoTotalDivision;
            writeln ('Total de horas en la division: ', totalHorasDivision);
            writeln ('Monto total en la division: ', montoTotalDivision);
        end;
        writeln ('Total de horas en el departamento: ', totalHorasDepartamento);
        writeln ('Monto total en el departamento: ', montoTotalDepartamento);
    end;

    close (archM);
end;


var
    v: vectorValores;
    archM: archivoEmpleados;
begin
    cargarValoresHoras (v);
    crearArchivoMaestro (archM); // Se dispone
    informarArchivoMaestro (archM, v);
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