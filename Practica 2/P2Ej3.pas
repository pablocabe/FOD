program P2Ej3;

const
    valorInvalido = -1;

type

    producto = record
        codigo: integer;
        nombre: string;
        precio: real;
        stockActual: integer;
        stockMinimo: integer;
    end;

    venta = record
        codigo: integer;
        cantVentas: integer;
    end;

    archivoMaestro = file of producto; // es el archivo donde figuran todos los productos comercializados

    archivoDetalle = file of venta; // es el archivo donde figuran las ventas diarias

{
El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende.

Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo.

Diariamente se genera un archivo detalle donde se registran todas las ventas de productos realizadas.
De cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:

a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:

● Ambos archivos están ordenados por código de producto.

● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.

● El archivo detalle sólo contiene registros que están en el archivo maestro.

b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.
}