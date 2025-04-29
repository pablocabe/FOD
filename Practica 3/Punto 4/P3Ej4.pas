{
Dada la siguiente estructura:

type

    reg_flor = record
        nombre: String[45];
        codigo: integer;
    end;

    tArchFlores = file of reg_flor;

Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como auxCabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.

a. Implemente el siguiente módulo:
Abre el archivo y agrega una flor, recibida como parámetro
manteniendo la política descrita anteriormente

procedure agregarFlor (var a: tArchFlores; nombre: string; codigo: integer);

b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.
}

program P3Ej4;

type

    reg_flor = record
        nombre: String[45];
        codigo: integer;
    end;

    tArchFlores = file of reg_flor;


procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);
var
    flor, auxCabecera: reg_flor;
begin
    reset (a);
    read (a, auxCabecera);
    flor.nombre := nombre;
    flor.codigo := codigo;
    if (auxCabecera.codigo = 0) then begin
        seek (a, fileSize(a));
        write (a, flor);
    end
    else begin
        seek (a, auxCabecera.codigo * -1);
        read (a, auxCabecera);
        seek (a, filePos(a)-1);
        write (a, flor);
        seek (a, 0);
        write (a, auxCabecera);
    end;
    writeln('Se realizo un alta de la flor con codigo ', flor.codigo);
    close (a);
end;


procedure imprimirArchivo (var a: tArchFlores);
var
    flor: reg_flor;
begin
    reset (a);
    while (not EOF (a)) do begin
        read (a, flor);
        if (flor.codigo > 0) then
            writeln ('Codigo = ', flor.codigo, ' Nombre = ', flor.nombre);
    end;
    close (a);
end;


var
    a: tArchFlores;
    nombre: string;
    codigo: integer;
begin
    crearArchivo (a); // Se dispone
    writeln ('Ingrese el nombre de la flor');
    readln (nombre);
    writeln ('Ingrese el codigo de la flor');
    readln (codigo);
    agregarFlor (a, nombre, codigo);
    imprimirArchivo (a);
end.