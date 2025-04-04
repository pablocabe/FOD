program P2Ej9;

type

    registroCliente = record
        codigo: integer;
        nombre: string;
        apellido: string;
    end;


    registroMaestro = record
        cliente: registroCliente;
        anio: integer;
        mes: integer;
        dia: integer;
        monto: real;
    end;

    archivoMaestro = file of registroMaestro;

procedure informarArchivoMaestro (var archM: archivoMaestro);
var
    regM: registroMaestro;
    totalMensual, totalAnual, totalEmpresa: real;
    codigoActual, anioActual, mesActual, cantVentas: integer;
begin
    reset (archM);
    totalEmpresa := 0;
    
    while (not EOF (archM)) do begin
        read (archM, regM);
        codigoActual := regM.cliente.codigo;
        writeln ('El cliente es ', regM.cliente.nombre , ' ', regM.cliente.apellido, '. Su codigo es: ', regM.cliente.codigo);
        while (regM.cliente.codigo = codigoActual) do begin
            anioActual := regM.cliente.anio;
            totalAnual := 0;
            while (regM.cliente.codigo = codigoActual) and (regM.cliente.anio = anioActual) do begin
                mesActual := regM.cliente.mes;
                totalMensual := 0;
                cantVentas := 0;
                while (regM.cliente.codigo = codigoActual) and (regM.cliente.anio = regM.cliente.anio)
                and (mregM.cliente.mes = mesActual) do begin
                    totalEmpresa := totalEmpresa + regM.monto;
                    totalMensual := totalMensual + regM.monto;
                    cantVentas := cantVentas + 1;
                    read (archM, regM);
                end;
                totalAnual := totalAnual + totalMensual;
                writeln ('En el mes ', mesActual, ' compro un total de : ', cantVentas);
            end;
            writeln ('En el anio ', anioActual, ' se gasto ', totalAnual);
        end;
    end;
    writeln ('El monto total de ventas obtenido por la empresa es: ', totalEmpresa);
    close (archM);
end;


var
    archM: archivoMaestro;
begin
    crearArchivoMaestro (archM); // se dispone
    informarArchivoMaestro (archM);
end.

{
Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente.

Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente. Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido
por la empresa.

El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta. El orden del archivo está dado por: cod cliente, año y mes.

Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras. No es necesario que informe tales meses en el reporte
}