program P1Ej2;

type
    archivoNumeros = file of integer;


procedure crearArchivo (var archNumeros: archivoNumeros);
var
    num: integer;
    nombreArchivo: string;
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
end;


procedure informarArchivo (var archNumeros: archivoNumeros);
var
    num: integer;
    cantMenores1500: integer;
    suma: integer;
    promedio: real;
begin
    reset (archNumeros);
    cantMenores1500 := 0;
    suma := 0;
    while (not eof (archNumeros)) do begin
        read (archNumeros, num);
        if (num < 1500) then
            cantMenores1500 := cantMenores1500 + 1;
        suma := suma + num;
        writeln (num);
    end;
    promedio := suma / filesize (archNumeros);
    writeln ('Cantidad de numeros menores a 1500: ', cantMenores1500);
    writeln ('Promedio de los numeros ingresados: ', promedio:0:2);
    close (archNumeros);
end;


var
    archNumeros: archivoNumeros;
begin
    crearArchivo (archNumeros);
    informarArchivo (archNumeros);
end.


{
Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creado en el ejercicio 1, informe por pantalla la cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.
}