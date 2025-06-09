program parcial2;

type
    profesional = record
        DNI: integer;
        nombre: string;
        apellido: string;
        sueldo: real;
    end;

    tArchivo = file of profesional;


procedure crear (var arch: tArchivo; var info: text);
var
    p: profesional;
begin
    reset (info);
    rewrite (arch);
    
    with p do begin
        DNI := 0;
        nombre := 'cabecera';
        apellido := 'cabecera';
        sueldo := 0;
    end;
    write (arch, p);

    while (not EOF (info)) do begin
        with p do begin
            read (info, DNI, sueldo, nombre);
            read (info, apellido);
        end;
        write (arch, p);
    end;

    close (info);
    close (arch);
end;


procedure agregar (var arch: tArchivo; p: profesional);
var
    rCabecera: profesional;
begin
    reset (arch);
    read (arch, rCabecera);
    if (rCabecera.DNI = 0) then begin // Si es 0 significa que no tengo espacio
        seek (arch, fileSize(arch)-1);
        write (arch, rCabecera);
    end
    else begin // Si no es 0 voy a la posición libre
        seek (arch, rCabecera.DNI * -1);
        read (arch, rCabecera);
        seek (arch, filePos(arch)-1);
        write (arch, p);
        seek (arch, 0);
        write (arch, rCabecera);
    end;
    close (arch);
end;


procedure eliminar (var arch: tArchivo; DNI: integer; var bajas: text);
var
    rCabecera, p: profesional;
begin
    reset (arch);
    reset (bajas);
    
    close (arch;)
end;


var
    arch: tArchivo;
    info, bajas: text;
begin
    Assign(arch, 'maestro.dat');
    Assign(info, 'info.txt');
    Assign(bajas, 'bajas.txt');
end.