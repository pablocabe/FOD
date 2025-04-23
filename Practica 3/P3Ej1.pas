{
Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados.
}

program P3Ej1;

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


function controlUnicidad (var archEmpleados: archivoEmpleados; num: integer): boolean; // creo que está mal, falta el reset
var
    emp: empleado;
    repetido: boolean;
begin
    repetido := false;
    while (not EOF (archEmpleados)) and (not repetido) do begin
        read (archEmpleados, emp);
        if (emp.numero = num) then
            repetido := true;
    end;
    controlUnicidad := repetido;
end;


procedure agregarEmpleados (var archEmpleados: archivoEmpleados);
var
    emp: empleado;
begin
    reset (archEmpleados);
    leerEmpleado (emp);
    while (emp.apellido <> 'fin') do begin
        if (not (controlUnicidad(archEmpleados, emp.numero))) then begin
            seek (archEmpleados, filesize (archEmpleados));
            write (archEmpleados, emp);
        end;
        leerEmpleado (emp);
    end;
    close (archEmpleados);
end;


procedure modificarEdadEmpleado (var archEmpleados: archivoEmpleados);
var
    emp: empleado;
    num: integer;
    edadNueva: integer;
begin
    reset (archEmpleados);
    writeln ('Ingrese el numero del empleado a modificar');
    readln (num);
    while (not EOF (archEmpleados)) do begin
        read (archEmpleados, emp);
        if (emp.numero = num) then begin
            writeln ('Ingrese la nueva edad del empleado');
            readln (edadNueva);
            emp.edad := edadNueva;
            seek (archEmpleados, filepos (archEmpleados) - 1);
            write (archEmpleados, emp);
        end;
    end;
    close (archEmpleados);
end;


procedure exportarEmpleadosATexto (var archEmpleados: archivoEmpleados);
var
    emp: empleado;
    archTexto: text;
begin
    reset (archEmpleados);
    assign (archTexto, 'todos_empleados.txt');
    rewrite (archTexto);
    while (not EOF (archEmpleados)) do begin
        read (archEmpleados, emp);
        with emp do begin
            writeln (archTexto, ' ', numero, ' ', apellido, ' ', nombre, ' ', edad, ' ', dni);
        end;
    end;
    writeln('Contenido del archivo binario exportado correctamente a archivo de texto');
    close (archTexto);
    close (archEmpleados);
end;


procedure exportarEmpleadosSinDNI (var archEmpleados: archivoEmpleados);
var
    emp: empleado;
    archTexto: text;
begin
    reset (archEmpleados);
    assign (archTexto, 'faltaDNIEmpleado.txt');
    rewrite (archTexto);
    while (not EOF (archEmpleados)) do begin
        read (archEmpleados, emp);
        if (emp.dni = '00') then
            with emp do begin
                writeln (archTexto, ' ', numero, ' ', apellido, ' ', nombre, ' ', edad, ' ', dni);
            end;
    end;
    writeln('Empleados sin DNI exportados correctamente a archivo de texto');
    close (archTexto);
    close (archEmpleados);
end;


procedure eliminarEmpleado (var archEmpleados: archivoEmpleados); // Método útil cuando el archivo no posee orden
var
    codigoEliminar: integer;
    emp, ultEmp: empleado;
begin
    reset (archEmpleados);
    writeln ('Ingrese el codigo del empleado a eliminar');
    readln (codigoEliminar);
    seek (archEmpleados, fileSize(archEmpleados)-1);
    read (archEmpleados, ultEmp);
    seek (archEmpleados, 0);
    read (archEmpleados, emp);
    while (not EOF (archEmpleados)) and (emp.numero <> codigoEliminar) do begin
        read (archEmpleados, emp);
    end;
    if (emp.numero = codigoEliminar) then begin
        seek (archEmpleados, filePos(archEmpleados)-1);
        write (archEmpleados, ultEmp);
        seek (archEmpleados, fileSize(archEmpleados)-1);
        truncate (archEmpleados);
        writeln ('Se encontro el empleado con codigo ', codigoEliminar, ' y se realizo la baja de forma correcta');
    end
    else
        writeln ('No se encontro el empleado con codigo ', codigoEliminar);
    close (archEmpleados);
end;


procedure abrirMenuPrincipal (var archEmpleados: archivoEmpleados);
var
    opcion: integer;
begin
    repeat
        writeln ('Menu principal de opciones');
        writeln('Opcion 0: Salir del menu y terminar la ejecucion del programa');
        writeln('Opcion 1: Listar en pantalla los datos de empleados que tengan un nombre o apellido determinado');
        writeln('Opcion 2: Listar en pantalla los empleados de a uno por linea');
        writeln('Opcion 3: Listar en pantalla los empleados mayores a 70 anios, proximos a jubilarse');
        writeln('Opcion 4: Agregar uno o mas empleados al final del archivo');
        writeln('Opcion 5: Modificar la edad de un empleado');
        writeln('Opcion 6: Exportar el contenido del archivo a un archivo de texto llamado todos_empleados.txt');
        writeln('Opcion 7: Exportar a un archivo de texto llamado faltaDNIEmpleado.txt, los empleados que no tengan cargado el DNI');
        writeln('Opcion 8: Eliminar un empleado');
        readln (opcion);

        case opcion of
            1: listarEmpleadosPorNombreOApellido (archEmpleados);
            2: listarEmpleados (archEmpleados);
            3: listarEmpleadosMayoresA70 (archEmpleados);
            4: agregarEmpleados (archEmpleados);
            5: modificarEdadEmpleado (archEmpleados);
            6: exportarEmpleadosATexto (archEmpleados);
            7: exportarEmpleadosSinDNI (archEmpleados);
            8: eliminarEmpleado (archEmpleados);
        else if (opcion <> 0) then
            writeln ('Opcion inexistente');
        end; // coresponde al case of

    until (opcion = 0);
end;


var
    nombreArchivo: string;
    archEmpleados: archivoEmpleados;
begin
    crearArchivo (archEmpleados);
    abrirMenuPrincipal (archEmpleados);
end.