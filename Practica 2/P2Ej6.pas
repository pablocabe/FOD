program P2Ej6;

const
    valorAlto = 9999;
    dF = 5;

type
    subrango = 1..dF;
    
    registroMaestro = record
        cod_usuario: integer;
        fecha: integer;
        tiempo_total_de_sesiones_abiertas: integer;
    end;

    registroDetalle = record
        cod_usuario: integer;
        fecha: integer;
        tiempo_sesion: integer;
    end;

    archivoMaestro = file of registroMaestro;

    archivoDetalle = file of registroDetalle;

    vectorDetalles = array [subrango] of archivoDetalle;

    vectorRegistros = array [subrango] of registroDetalle;


procedure crearArchivoDetalle (var archD: archivoDetalle) // se dispone


procedure crearArchivosDetalles (var vectorD: vectorDetalles);
var
    i: subrango;
begin
    for i := 1 to dF do begin
        crearArchivoDetalle(vectorD[i]);
    end;
end;


procedure leer (var archD: archivoDetalle; var regD: registroDetalle);
begin
    if (not EOF (archD)) then
        read (archD, regD)
    else
        regD.cod_usuario := valorAlto;
end;


procedure crearArchivoMaestro (var archM: archivoMaestro; var vectorD: vectorDetalles);
var
    i: subrango;
    vectorR: vectorRegistros;
begin
    rewrite (archM);
    for i := 1 to dF do begin
        reset (vectorD[i]);
        leer (vectorD[i], vectorR[i]);
    end;



    close (archM);
    for i := 1 to dF do begin
        close (vectorD[i]);
    end;
end;


var
    archM: archivoMaestro;
    vectorD: vectorDetalles;
begin
    crearArchivosDetalles (vectorD);
    assign (archM, 'maestro');
    crearArchivoMaestro (archM, vectorD);
end.
    
{
Suponga que trabaja en una oficina donde está montada una LAN (red local).

La misma fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta.

Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.

Notas:

● Cada archivo detalle está ordenado por cod_usuario y fecha.

● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
inclusive, en diferentes máquinas.

● El archivo maestro debe crearse en la siguiente ubicación física: /var/log.

}