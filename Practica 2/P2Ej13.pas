program P2Ej13i; // inciso i)

const
    valorAlto = 9999;

type

    registroMaestro = record
        numeroUsuario: integer;
        nombreUsuario: string;
        nombre: string;
        apellido: string;
        cantMailsEnviados: integer;
    end;

    registroDetalle = record
        numeroUsuario: integer;
        cuentaDestino: string;
        cuerpoMensaje: string;
    end;

    archivoMaestro = file of registroMaestro;

    archivoDetalle = file of registroDetalle;


procedure crearArchivoMaestro (var archM: archivoMaestro) // Se dispone


procedure crearArchivoDetalle (var archD: archivoDetalle) // Se dispone


procedure leer (var archD: archivoDetalle; var regD: registroDetalle);
begin
    if (not EOF(archD)) then
        read (archD, regD)
    else
        regD.numeroUsuario := valorAlto; // Asigno un valor de corte
end;


procedure actualizarArchivoMaestro (var archM: archivoMaestro; var archD: archivoDetalle);
var
    regM: registroMaestro;
    regD: registroDetalle;
begin
    reset (archM);
    reset (archD);
    leer (archD, regD);

    while (regD.numeroUsuario <> valorAlto) do begin
        read (archM, regM);

        while (regD.numeroUsuario <> regM.numeroUsuario) do begin
            read (archM, regM);
        end;

        while (regD.numeroUsuario = regM.numeroUsuario) do begin
            regM.cantidadMailEnviados := regM.cantidadMailEnviados + 1;
            leer (archD, regD);
        end;

        seek (archM, filePos(archM)-1);
        write (archM, regM);
    end;

    close (archM);
    close (archD);
end;


procedure generarArchivoText (var archM: archivoMaestro; var archD: archivoDetalle);
var
    archivoText: Text;
    usuarioActual, cantAuxiliar: integer;
    regD: registroDetalle;
begin
    reset (archD);
    assign (arch, 'mails.txt'); // Nombre del archivo de texto
    rewrite (archivoText);
    leer (archM, regM);

    while (regM.numeroUsuario <> valorAlto) do begin
        cantAuxiliar := 0;
        while (regD.numeroUsuario = usuarioActual) do begin
            cantAuxiliar := cantAuxiliar + 1;
            leer (archD, regD);
        end;
        write (archivoText, usuarioActual, cantAuxiliar);
    end;

    close (archD);
    close (archivoText);
end;


var
    archM: archivoMaestro;
begin
    crearArchivoMaestro (archM); // Se dispone
    crearArchivoMaestro (archD); // Se dispone y representa un día
    actualizarArchivoMaestro (archM, archD);
    generarArchivoText (archM, archD);
end.

{
Suponga que usted es administrador de un servidor de correo electrónico. En los logs del
mismo (información guardada acerca de los movimientos que ocurren en el server) que se
encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados.

Diariamente el servidor de correo genera un archivo con la siguiente información: nro_usuario,
cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
sabe que un usuario puede enviar cero, uno o más mails por día.

a. Realice el procedimiento necesario para actualizar la información del log en un
día particular. Defina las estructuras de datos que utilice su procedimiento.

b. Genere un archivo de texto que contenga el siguiente informe dado un archivo
detalle de un día determinado:
nro_usuarioX…………..cantidadMensajesEnviados
………….
nro_usuarioX+n………..cantidadMensajesEnviados

Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
existen en el sistema. Considere la implementación de esta opción de las
siguientes maneras:

i- Como un procedimiento separado del punto a).

ii- En el mismo procedimiento de actualización del punto a). Qué cambios
se requieren en el procedimiento del punto a) para realizar el informe en
el mismo recorrido?
}