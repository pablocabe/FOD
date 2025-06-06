program P1Ej7;

type

    novela = record
        codigo: integer;
        nombre: string;
        genero: string;
        precio: real;
    end;

    archivoNovelas = file of novela;


procedure crearArchivo (var archNovelas: archivoNovelas);
var
    archTexto: text;
    n: novela;
    nombreArchivo: string;
begin
    writeln ('Ingrese el nombre del archivo binario');
    readln (nombreArchivo);
    assign (archNovelas, nombreArchivo);
    rewrite (archNovelas);
    assign (archTexto, 'novelas.txt');
    rewrite (archTexto);
    while (not EOF(archTexto)) do begin
        readln (archTexto, n.codigo, n.precio, n.genero);
        readln (archTexto, n.nombre);
        write (archNovelas, n);
    end;
    close (archTexto);
    close (archNovelas);
end;


procedure leerNovela (var n: novela);
begin
    with n do begin
        writeln ('Ingrese el codigo de la novela');
        readln (codigo);
        if (codigo <> 0) then begin
            writeln ('Ingrese el nombre de la novela');
            readln (nombre);
            writeln ('Ingrese el genero de la novela');
            readln (genero);
            writeln ('Ingrese el precio de la novela');
            readln (precio);
        end;
    end;
end;


procedure agregarNovela (var archNovelas: archivoNovelas);
var
    n: novela;
begin
    reset (archNovelas);
    seek (archNovelas, filesize(archNovelas));
    leerNovela (n);
    while (n.codigo <> 0) do begin
        write (archNovelas, n);
        leerNovela (n);
    end;
    close (archNovelas);
end;


procedure modificarNovela (var archNovelas: archivoNovelas);
var
    n: novela;
    codigoTeclado: integer;
begin
    reset (archNovelas);
    writeln ('Ingrese el codigo de la novela a modificar');
    readln (codigoTeclado);
    while (not EOF(archNovelas)) do begin
        read (archNovelas, n);
        if (n.codigo = codigoTeclado) then begin
            leerNovela (n); // no esta mal volver a leer el codigo porque puedo querer modificarlo
            seek (archNovelas, filepos(archNovelas) - 1);
            write (archNovelas, n);
        end;
    end;
    close (archNovelas);
end;


procedure abrirMenuPrincipal (var archNovelas: archivoNovelas);
var
    opcion: integer;
begin
    repeat
        writeln ('1. Crear archivo binario');
        writeln ('2. Agregar novela');
        writeln ('3. Modificar novela');
        writeln ('4. Salir');
        readln (opcion);
        case opcion of
            1: crearArchivo (archNovelas);
            2: agregarNovela (archNovelas);
            3: modificarNovela (archNovelas);
        end;
    until (opcion = 4);
end;


var
    archNovelas: archivoNovelas;
begin
    crearArchivo (archNovelas);
    abrirMenuPrincipal (archNovelas);
end.

{
Realizar un programa que permita:

a) Crear un archivo binario a partir de la información almacenada en un archivo de
texto. El nombre del archivo de texto es: “novelas.txt”. La información en el
archivo de texto consiste en: código de novela, nombre, género y precio de
diferentes novelas argentinas. Los datos de cada novela se almacenan en dos
líneas en el archivo de texto. La primera línea contendrá la siguiente información:
código novela, precio y género, y la segunda línea almacenará el nombre de la
novela.

b) Abrir el archivo binario y permitir la actualización del mismo. Se debe poder
agregar una novela y modificar una existente. Las búsquedas se realizan por
código de novela.

NOTA: El nombre del archivo binario es proporcionado por el usuario desde el teclado.
}