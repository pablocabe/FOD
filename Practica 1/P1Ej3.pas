program P1Ej3;

type
    empleado = record
        numero: integer;
        apellido: string;
        nombre: string;
        edad: integer;
        dni: string;
    end;

    archivoEmpleados = file of empleado;


procedure leerEmpleado (var emp: empleado);
begin
    with emp do begin
        writeln ('Ingrese el apellido del empleado');
        readln (apellido);
        if (apellido <> 'fin') then begin
            writeln ('Ingrese el numero del empleado');
            readln (numero);
            writeln ('Ingrese el nombre del empleado');
            readln (nombre);
            writeln ('Ingrese la edad del empleado');
            readln (edad);
            writeln ('Ingrese el DNI del empleado');
            readln (dni);
        end;
    end;
end;


procedure crearArchivo (var archEmpleados: archivoEmpleados);
var
    emp: empleado;
    nombreArchivo: string;
begin
    writeln ('Ingrese el nombre del archivo');
    readln (nombreArchivo);
    assign (archEmpleados, nombreArchivo);
    rewrite (archEmpleados);
    leerEmpleado (emp);
    while (emp.apellido <> 'fin') do begin
        write (archEmpleados, emp);
        leerEmpleado (emp);
    end;
    close (archEmpleados);
end;


procedure listarEmpleadosPorNombreOApellido (var archEmpleados: archivoEmpleados);
var
    emp: empleado;
    nombre: string;
    apellido: string;
begin
    reset (archEmpleados);
    writeln ('Ingrese el nombre o apellido del empleado a buscar');
    readln (nombre);
    while (not EOF (archEmpleados)) do begin
        read (archEmpleados, emp);
        if (emp.nombre = nombre) or (emp.apellido = nombre) then
            writeln ('Numero: ', emp.numero, ' Apellido: ', emp.apellido, ' Nombre: ', emp.nombre, ' Edad: ', emp.edad, ' DNI: ', emp.dni);
    end;
    close (archEmpleados);
end;


procedure listarEmpleados (var archEmpleados: archivoEmpleados);
var
    emp: empleado;
begin
    reset (archEmpleados);
    while (not EOF (archEmpleados)) do begin
        read (archEmpleados, emp);
        writeln ('Numero: ', emp.numero, ' Apellido: ', emp.apellido, ' Nombre: ', emp.nombre, ' Edad: ', emp.edad, ' DNI: ', emp.dni);
    end;
    close (archEmpleados);
end;


procedure listarEmpleadosMayoresA70 (var archEmpleados: archivoEmpleados);
var
    emp: empleado;
begin
    reset (archEmpleados);
    while (not EOF (archEmpleados)) do begin
        read (archEmpleados, emp);
        if (emp.edad > 70) then
            writeln ('Numero: ', emp.numero, ' Apellido: ', emp.apellido, ' Nombre: ', emp.nombre, ' Edad: ', emp.edad, ' DNI: ', emp.dni);
    end;
    close (archEmpleados);
end;


procedure abrirMenuPrincipal (var archEmpleados: archivoEmpleados);
var
    opcion: integer;
begin
    writeln('Menu principal de opciones');
    writeln('Opcion 0: Salir del menu y terminar la ejecucion del programa');
    writeln('Opcion 1: Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado');
    writeln('Opcion 2: Listar en pantalla los empleados de a uno por linea');
    writeln('Opcion 3: Listar en pantalla los empleados mayores a 70 anios, proximos a jubilarse');
    readln (opcion);
    while (opcion <> 0) do begin
        case opcion of
            1: listarEmpleadosPorNombreOApellido (archEmpleados);
            2: listarEmpleados (archEmpleados);
            3: listarEmpleadosMayoresA70 (archEmpleados);
        else
            writeln ('Opcion inexistente');
        end;
        writeln ('Menu principal de opciones');
        writeln('Opcion 0: Salir del menu y terminar la ejecucion del programa');
        writeln('Opcion 1: Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado');
        writeln('Opcion 2: Listar en pantalla los empleados de a uno por linea');
        writeln('Opcion 3: Listar en pantalla los empleados mayores a 70 anios, proximos a jubilarse');
        readln (opcion);
    end;
end;


var
    nombreArchivo: string;
    archEmpleados: archivoEmpleados
begin
    crearArchivo (archEmpleados);
    abrirMenuPrincipal (archEmpleados);
end.

{
Realizar un programa que presente un menú con opciones para:

a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.

b. Abrir el archivo anteriormente generado y

i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado, el cual se proporciona desde el teclado.

ii. Listar en pantalla los empleados de a uno por línea.

iii. Listar en pantalla los empleados mayores de 70 años, próximos a jubilarse.

NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.
}