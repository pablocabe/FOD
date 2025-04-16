program P2Ej13ii; // inciso ii)

const
    valorAlto = 9999;

type

    registroMaestro = record
        numeroUsuario: integer;
        nombreUsuario: string;
        nombre: string;
        apellido: string;
        cantidadMailsEnviados: integer;
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


procedure leerMaestro (var archM: archivoMaestro; var regM: registroMaestro);
begin
    if (not EOF(archM)) then
        read (archM, regM)
    else
        regM.numeroUsuario := valorAlto; // Asigno un valor de corte
end;


procedure leerDetalle (var archD: archivoDetalle; var regD: registroDetalle);
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
    archivoText: Text;
    usuarioActual, cantAuxiliar: integer;
    actualizado: boolean;
begin
    reset (archM);
    reset (archD);
    assign (archivoText, 'mails.txt'); // Nombre del archivo de texto
    rewrite (archivoText);
    leerMaestro (archM, regM);
    leerDetalle (archD, regD);

    while (regM.numeroUsuario <> valorAlto) do begin // Mi condición de corte principal es el final del archivo maestro
        usuarioActual := regM.numeroUsuario;
        cantAuxiliar := 0;
        actualizado := false;
        while (regD.numeroUsuario = usuarioActual) do begin // Cuando llegue al valor de corte no entra más en este while
            cantAuxiliar := cantAuxiliar + 1;
            regM.cantidadMailsEnviados := regM.cantidadMailsEnviados + 1;
            actualizado := true;
            leerDetalle (archD, regD);
        end;

        writeln (archivoText, usuarioActual, ' ', cantAuxiliar);
        if (actualizado) then begin
            seek (archM, filePos(archM)-1);
            write (archM, regM);
        end;
        leerMaestro (archM, regM);
    end;

    close (archM);
    close (archD);
    close (archivoText);
end;


var
    archM: archivoMaestro;
    archD: archivoDetalle;
begin
    crearArchivoMaestro (archM); // Se dispone
    crearArchivoDetalle (archD); // Se dispone y representa un día
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