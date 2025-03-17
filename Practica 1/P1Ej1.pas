program P1Ej1;

type
    archivoNumeros = file of integer;

var
    archNumeros: archivoNumeros;
    nombreArchivo = string;
    num: integer;
begin
    writeln ('Ingrese el nombre del archivo');
    readln (nombreArchivo);
    assign (archNumeros, nombreArchivo);
    rewrite (archNumeros);
    writeln ('Ingrese un numero');
    readln (num);
    while (num <> 30000) do begin
        write (archNumeros, num);
        writeln ('Ingrese un numero');
        readln (num);
    end;
    close (archNumeros);
end.


{
Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. La carga finaliza
cuando se ingresa el número 30000, que no debe incorporarse al archivo. El nombre del
archivo debe ser proporcionado por el usuario desde teclado.
}