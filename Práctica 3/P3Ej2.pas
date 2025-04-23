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

    registroAsistente = record
        numero: integer;
        apellido: string;
        nombre: string;
        email: string;
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
    assign (archivoAsistentes, nombreArchivo);
    rewrite (archivoAsistentes);
    leerAsistente (asistente);
    while (asistente.numero <> -1) do begin
        write (archivoAsistentes, asistente);
        leerAsistente (asistente);
    end;
    close (archivoAsistentes);
end;

var
    archivo: archivoAsistentes;
begin
    crearArchivo (archivo);
end.