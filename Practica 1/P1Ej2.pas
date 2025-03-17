program P1Ej2;

type
    archivoNumeros = file of integer;

var
    archNumeros: archivoNumeros;
    nombreArchivo: string;
    num: integer;
begin
    writeln ('Ingrese el nombre del archivo');
    readln (nombreArchivo);
    assign (archNumeros, nombreArchivo);
    reset (archNumeros);

end.



{
Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creado en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.
}