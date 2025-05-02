{
Se cuenta con un archivo que almacena información sobre especies de aves en vía
de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que permita borrar especies de aves extintas. Este programa debe
disponer de dos procedimientos:

a. Un procedimiento que dada una especie de ave (su código) marque la misma
como borrada (en caso de querer borrar múltiples especies de aves, se podría
invocar este procedimiento repetidamente).

b. Un procedimiento que compacte el archivo, quitando definitivamente las
especies de aves marcadas como borradas. Para quitar los registros se deberá
copiar el último registro del archivo en la posición del registro a borrar y luego
eliminar del archivo el último registro de forma tal de evitar registros duplicados.

i. Implemente una variante de este procedimiento de compactación del
archivo (baja física) donde el archivo se trunque una sola vez.
}

program P3Ej7; // Me falta revisar el b y hacer el i

const

    valorCorte = 9999;

type

    registroAve = record
        codigo: integer;
        nombre: string;
        familia: string;
        descripcion: string;
        zona: string;
    end;

    archivoMaestro = file of registroAve; // No esta ordenado


procedure crearArchivoMaestro (var archM: archivoMaestro); // Se dispone


procedure leer (var archM: archivoMaestro; var regM: registroAve);
begin
    if (not EOF(a)) then
        read(archM, regM)
    else
        regM.codigo := valorCorte;
end;


procedure bajaLogica (var archM: archivoMaestro; codigoTeclado: integer);
var
    regM: registroAve;
    existe: boolean;
begin
    reset (archM);
    existe := false;
    while (not EOF (archM)) and (not existe) do begin
        read (archM, regM);
        if (regM.codigo = codigoTeclado) then begin
            existe := true;
            seek (archM, filePos(archM)-1);
            regM.codigo := regM.codigo * -1;
            write (archM, regM);
        end;
    end;
    if (existe) then
        writeln ('Se realizo la baja logica del ave con codigo ', codigoTeclado)
    else
        writeln ('No se encontro el ave con el codigo ', codigoTeclado);
    close (archM);
end;

{
b. Un procedimiento que compacte el archivo, quitando definitivamente las
especies de aves marcadas como borradas. Para quitar los registros se deberá
copiar el último registro del archivo en la posición del registro a borrar y luego
eliminar del archivo el último registro de forma tal de evitar registros duplicados.
}

procedure compactarArchivo (var archM: archivoMaestro);
var
    regM, regUltimo: registroAve;
    posActual, posUltimo: integer;
begin
    reset (archM);
    leer (archM, regM);
    while (regM.codigo <> valorCorte) do begin
        if (regM.codigo < 0) then begin // Si se cumple, se debe borrar este registro
            posActual := filePos(archM) - 1;
            seek (archM, fileSize(archM) - 1);
            read (archM, regUltimo);
            // Evita copiar el último registro sobre sí mismo o hacer una operación innecesaria si sólo queda un registro en el archivo
            if (posActual <> fileSize(archM) - 1) then begin
                while (regM.codigo < 0) do begin
                    seek (archM, fileSize(archM) - 1);
                    truncate (archM);
                    seek (archM, fileSize(archM) - 1);
                    read (archM, regM);
                end;
            end;
            seek (archM, posActual);
            write (archM, regM);
            seek (archM, fileSize(archM) - 1);
            truncate (archM);
            seek (archM, posActual);
        end;
        leer (archM, regM);
    end;
    close (archM);
end;


var
    archM: archivoMaestro;
    codigoTeclado: integer;
begin
    crearArchivoMaestro (archM) // Se dispone
    writeln ('Ingrese el codigo de la ave a borrar');
    readln (codigoTeclado);
    bajaLogica (archM, codigoTeclado);
    compactarArchivo (archM);
end.