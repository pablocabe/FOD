{
Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:
{Abre el archivo y elimina la flor recibida como parámetro manteniendo
la política descripta anteriormente
procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);
}

program P3Ej5;

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


procedure eliminarFlor (var a: tArchFlores; flor: reg_flor);
var
    cabecera, auxiliar: flor;
    existe: boolean;
begin
    reset (a);
    existe := false;
    read (a, cabecera) // Cabecera toma el registro cabecera
    while (not EOF (a) and (not existe)) do begin
        read (a, auxiliar); // Auxiliar se utiliza para recorrer
        if (auxiliar.codigo = flor.codigo) then begin
            existe := true;
            seek (a, filePos(a)-1);
            write (a, cabecera);
            cabecera.codigo := (filePos(a)-1) * -1;
            seek (a, 0);
            write (a, cabecera);
        end;
    end;
    if (existe) then
        writeln ('Se realizo la baja de la flor con codigo ', flor.codigo)
    else
        writeln ('No se encontro la flor con codigo ', flor.codigo);
    close (a);
end;


var
    a: tArchFlores;
    nombre: string;
    codigo: integer;
    flor: reg_flor;
begin
    crearArchivo (a); // Se dispone
    writeln ('Ingrese el nombre de la flor a agregar');
    readln (nombre);
    writeln ('Ingrese el codigo de la flor a agregar');
    readln (codigo);
    agregarFlor (a, nombre, codigo);
    imprimirArchivo (a);
    writeln ('Ingrese el nombre de la flor a eliminar');
    readln (flor.nombre);
    writeln ('Ingrese el codigo de la flor a eliminar');
    readln (flor.codigo);
    eliminarFlor (a, flor);
end.