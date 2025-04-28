{
Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.
}

program P3Ej2;

type
    str20 = string[20];

    registroAsistente = record
        numero: integer;
        apellido: str20;
        nombre: str20;
        email: str20;
        telefono: integer;
        DNI: integer;
    end;

    archivoAsistentes = file of registroAsistente;


procedure leerAsistente (var asistente: registroAsistente);
begin
    with asistente do begin
        writeln ('Ingrese el numero');
        readln (numero);
        if (numero <> -1) then begin
            writeln ('Ingrese el apellido');
            readln (apellido);
            writeln ('Ingrese el nombre');
            readln (nombre);
            writeln ('Ingrese el email');
            readln (email);
            writeln ('Ingrese el telefono');
            readln (telefono);
            writeln ('Ingrese el DNI');
            readln (DNI);
        end;
    end;
end;


procedure crearArchivo (var archivo: archivoAsistentes);
var
    nombreArchivo: string;
    asistente: registroAsistente;
begin
    writeln ('Ingrese el nombre del archivo');
    readln (nombreArchivo);
    assign (archivo, nombreArchivo);
    rewrite (archivo);
    leerAsistente (asistente);
    while (asistente.numero <> -1) do begin
        write (archivo, asistente);
        leerAsistente (asistente);
    end;
    close (archivo);
end;


procedure imprimirAsistente (asistente: registroAsistente);
begin
    with asistente do begin
        writeln('Numero = ', numero, ' | Apellido = ', apellido, ' | Nombre = ', nombre, ' | DNI = ', DNI);
    end;
end;


procedure imprimirArchivo (var archivo: archivoAsistentes);
var
    asistente: registroAsistente;
begin
    reset (archivo);
    while (not EOF (archivo)) do begin
        read (archivo, asistente);
        if (asistente.apellido[1] <> '@') then
            imprimirAsistente (asistente);
    end;
    close (archivo);
end;


procedure bajaLogica (var archivo: archivoAsistentes);
var
    asistente: registroAsistente;
begin
    reset (archivo);
    while (not EOF (archivo)) do begin
        read (archivo, asistente);
        if (asistente.numero < 1000) then begin
            asistente.apellido := '@' + asistente.apellido;
            seek (archivo, filePos(archivo)-1);
            write (archivo, asistente);
        end;
    end;
    close (archivo);
end;


var
    archivo: archivoAsistentes;
begin
    writeln ('Se creara el archivo');
    crearArchivo (archivo);
    writeln ('Se imprimira el archivo original');
    imprimirArchivo (archivo);
    writeln ('Se realizara la baja logica');
    bajaLogica (archivo);
    writeln ('Se imprimira el archivo modificado');
    imprimirArchivo (archivo);
end.