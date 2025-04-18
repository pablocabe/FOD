{
La editorial X, autora de diversos semanarios, posee un archivo maestro con la información
correspondiente a las diferentes emisiones de los mismos. De cada emisión se registra:
fecha, código de semanario, nombre del semanario, descripción, precio, total de ejemplares
y total de ejemplares vendidos.

Mensualmente se reciben 100 archivos detalles con las ventas de los semanarios en todo el
país. La información que poseen los detalles es la siguiente: fecha, código de semanario y
cantidad de ejemplares vendidos. Realice las declaraciones necesarias, la llamada al
procedimiento y el procedimiento que recibe el archivo maestro y los 100 detalles y realice la
actualización del archivo maestro en función de las ventas registradas. Además deberá
informar fecha y semanario que tuvo más ventas y la misma información del semanario con
menos ventas.

Nota: Todos los archivos están ordenados por fecha y código de semanario. No se realizan
ventas de semanarios si no hay ejemplares para hacerlo.
}

program P2Ej16;

const
    dF = 100;
    valorAlto = 9999;

type
    subrango = 1 .. dF;

    registroMaestro = record
        fecha: integer;
        codigoSemanario: integer;
        nombreSemanario: string;
        descripcion: string;
        precio: real;
        totalEjemplares: integer;
        totalEjemplaresVendidos: integer;
    end;

    registroDetalle = record
        fecha: integer;
        codigoSemanario: integer;
        cantEjemplaresVendidos: integer;
    end;

    archivoMaestro = file of registroMaestro;

    archivoDetalle = file of registroDetalle;

    vectorDetalles = array [subrango] of archivoDetalle;

    vectorRegistros = array [subrango] of registroDetalle;


procedure crearArchivoMaestro (var archM: archivoMaestro) // Se dispone


procedure crearArchivoDetalle (var archD: archivoDetalle) // Se dispone


procedure crearArchivosDetalles (var vectorD: vectorDetalles);
var
    i: subrango;
begin
    for i := 1 to dF do begin
        crearArchivoDetalle(vectorD[i]); // se dispone
    end;
end;


var
    archM: archivoMaestro;
    vectorD: vectorDetalles;
begin
    crearArchivoMaestro (archM); // Se dispone
    crearArchivosDetalles (vectorD);
    actualizarArchivoMaestro (archM, vectorD);
end.