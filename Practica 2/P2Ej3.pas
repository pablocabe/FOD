program P2Ej3;

const
    valorInvalido = 'ZZZ';

type
    registroMaestro = record
        provincia: string;
        cantAlfabetizados: integer;
        cantEncuestados: integer;
    end;

    registroDetalle = record
        provincia: string;
        codigo: integer;
        cantAlfabetizados: integer;
        cantEncuestados: integer;
    end;

    archivoMaestro = file of registroMaestro;

    archivoDetalle = file of registroDetalle;


procedure crearArchivoMaestro(var archM: archivoMaestro); // se dispone


procedure crearArchivoDetalle(var archD: archivoDetalle); // se dispone


procedure leer(var archD: archivoDetalle; var regD: registroDetalle);
begin
    if (not EOF(archD)) then
        read (archD, regD)
    else
        regD.provincia := valorInvalido; // asigno un valor de corte
end;


procedure buscarMinimo (var archD1, archD2: archivoDetalle; var regD1, regD2, minimo: registroDetalle);
begin
    if (regD1.provincia <= regD2.provincia) then begin
        minimo := regD1;
        leer (archD1, regD1);
    end
    else begin
        minimo := regD2;
        leer (archD2, regD2);
    end;
end;


procedure actualizarArchivoMaestro (var archM: archivoMaestro; var archD1, archD2: archivoDetalle);
var
    regM: registroMaestro;
    regD1, regD2, minimo: registroDetalle;
begin
    reset (archM);
    reset (archD1);
    reset (archD2);

    leer (archD1, regD1);
    leer (archD2, regD2);
    buscarMinimo (archD1, archD2, regD1, regD2, minimo);

    while (minimo.provincia <> valorInvalido) do begin
        read (archM, regM);
        while (regM.provincia <> minimo.provincia) do
            read (regM, archM);
        while (regM.provincia = minimo.provincia) do begin
            regM.cantAlfabetizados := regM.cantAlfabetizados + minimo.cantAlfabetizados;
            regM.cantEncuestados := regM.cantEncuestados + minimo.cantEncuestados;
            buscarMinimo (archD1, archD2, regD1, regD2, minimo); 
        end;
        seek (archM, filePos (archM)-1);
        write (archM, regM);
    end;

    close (archM);
    close (archD1);
    close (archD2);
end;


var
    archM: archivoMaestro;
    archD1, archD2: archivoDetalle;
begin
    assign (archM, 'maestro');
    assign (archD1, 'detalle1');
    assign (archD2, 'detalle2');
    crearArchivoMaestro(archM); // se dispone
    crearArchivoDetalle(archD1); // se dispone
    crearArchivoDetalle(archD2); // se dispone
    actualizarArchivoMaestro (archM, archD1, archD2);
end.


{
A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados.

Se reciben dos archivos detalle provenientes de dos agencias de censo diferentes,
dichos archivos contienen: nombre de la provincia, código de localidad,
cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.

NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.
}