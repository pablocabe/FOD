{
Considere que se tiene un archivo que contiene información de los préstamos otorgados por una
empresa financiera que cuenta con varias sucursales. Por cada préstamo se tiene la siguiente
información: número de sucursal donde se otorgó, DNI del empleado que lo otorgó, número de
préstamo, fecha de otorgación y monto otorgado. Cada préstamo otorgado por la empresa se
considera como una venta. Además, se sabe que el archivo está ordenado por los siguientes
criterios: código de sucursal, DNI del empleado y fecha de otorgación (en ese orden).

Se le solicita definir las estructuras de datos necesarias y escribir el módulo que reciba el archivo de
datos y genere un informe en un archivo de texto con el siguiente formato.

Informe de ventas de la empresa
Sucursal <número sucursal>
Empleado: DNI <DNI empleado>
Año Cantidad de ventas Monto de ventas
............... ...................... .......................
Totales <Total ventas empleado> <Monto total empleado>
Empleado: DNI <DNI empleado>
……………..
Cantidad total de ventas sucursal: ……………..
Monto total vendido por sucursal: ……………..
Sucursal <número sucursal>
...……..
Cantidad de ventas de la empresa: ................
Monto total vendido por la empresa: ................

Notas:
* El archivo de datos se debe recorrer solo una vez.
* Para determinar el año de otorgación de un préstamo, puede asumir que existe una función
extraerAño(fecha) que, a partir de una fecha dada, devuelve el año de la misma.
* En la generación del archivo de texto solo interesa que aparezca la información requerida,
NO es necesario que se incluyan los espacios en blanco o tabulaciones que se incluyen en el
informe de modo como ejemplo.
}

program parcial4;

const
    valorAlto = 9999;

type
    // Cada préstamo otorgado por la empresa se considera como una venta
    registroMaestro = record
        codigoSucursal: integer;
        DNI: integer;
        numPrestamo: integer;
        fecha: integer;
        monto: real;
    end;

    archivoMaestro = file of registroMaestro; // Ordenado por código de sucursal, DNI del empleado y fecha de otorgación (en ese orden)


procedure leerMaestro (var archM: archivoMaestro; var regM: registroMaestro);
begin
    if (not EOF (archM)) then
        read (archM, regM)
    else
        regM.codigoSucursal := valorAlto;
    end;
        
end;


function extraerAnio (fecha: integer): integer; // Se dispone


procedure procesarInforme (var archM: archivoMaestro; var informeTXT: text);
var
    regM: registroMaestro;
    anioActual, sucursalActual, DNIActual: integer;
    totalVentasAnio, totalVentasEmpleado, totalVentasSucursal, totalVentasEmpresa: integer;
    montoTotalAnio, montoTotalEmpleado, montoTotalSucursal, montoTotalEmpresa: real;
begin
    reset (archM);
    rewrite (informeTXT);

    totalVentasEmpresa := 0;
    montoTotalEmpresa := 0;
    leerMaestro (archM, regM);
    writeln (informeTXT, 'Informe de ventas de la empresa');

    while (regM.codigoSucursal <> valorAlto) do begin // Mientras queden registros por recorrer
        sucursalActual := regM.codigoSucursal;
        writeln (informeTXT, 'Sucursal ', sucursalActual);
        totalVentasSucursal := 0;
        montoTotalSucursal := 0;
        while (regM.codigoSucursal = sucursalActual) do begin
            DNIActual := regM.DNI;
            writeln (informeTXT, 'Empleado: DNI ', DNIActual);
            totalVentasEmpleado := 0;
            montoTotalEmpleado := 0;
            while (regM.codigoSucursal = sucursalActual) and (regM.DNI = DNIActual) do begin
                anioActual := extraerAnio (regM.fecha);
                totalVentasAnio := 0;
                montoTotalAnio := 0;
                while (regM.codigoSucursal = sucursalActual) and (regM.DNI = DNIActual) and (regM.anioActual = extraerAnio (regM.fecha)) do begin
                    totalVentasAnio := totalVentasAnio + 1;
                    montoTotalAnio := montoTotalAnio + regM.monto;
                    leerMaestro (archM, regM);
                end;
                writeln (informeTXT, 'Año | Cantidad de ventas | Monto de ventas');
                writeln (informeTXT, anioActual, totalVentasAnio, montoTotalAnio);
                totalVentasEmpleado := totalVentasEmpleado + totalVentasAnio;
                montoTotalEmpleado := montoTotalEmpleado + montoTotalAnio;
            end;
            writeln (informeTXT, 'Totales: ', totalVentasEmpleado, montoTotalEmpleado);
            totalVentasSucursal := totalVentasSucursal + totalVentasEmpleado;
            montoTotalSucursal := montoTotalSucursal + montoTotalEmpleado;
        end;
        writeln (informeTXT, 'Cantidad total de ventas sucursal: ', totalVentasSucursal);
        writeln (informeTXT, 'Monto total vendido por sucursal: ', montoTotalSucursal);
        totalVentasEmpresa := totalVentasEmpresa + totalVentasSucursal;
        montoTotalEmpresa := montoTotalEmpresa + montoTotalSucursal;
    end;
    writeln (informeTXT, 'Cantidad de ventas por la empresa: ', totalVentasEmpresa);
    writeln (informeTXT, 'Monto total vendido por la empresa: ', montoTotalEmpresa);

    close (archM);
    close (informeTXT);
end;


var
    archM: archivoMaestro;
    informeTXT: text;
begin
    assign (archM, 'archivoMaestro');
    assign (informeTXT, 'informe.txt');
    procesarInforme (archM, informeTXT);
end.