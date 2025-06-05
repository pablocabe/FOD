{
Una mejora respecto a la solución propuesta en el ejercicio 1 sería mantener por un
lado el archivo que contiene la información de los alumnos de la Facultad de
Informática (archivo de datos no ordenado) y por otro lado mantener un índice al
archivo de datos que se estructura como un árbol B que ofrece acceso indizado por
DNI de los alumnos.

a. Defina en Pascal las estructuras de datos correspondientes para el archivo de
alumnos y su índice.
}

const
	M = {orden del arbol}
	
type
    alumno = record
        nombre: string;
        apellido: string;
        DNI: integer;
        legajo: integer;
        anioIngreso: integer;
    end;

	nodo = record
		cantClaves: integer;
		claves: array [1..M-1] of longint; // DNIs
        enlaces: array [1..M-1] of integer; // Número de Registro Relativo (NRR)
        // Apunta al número de registro (la posición) del alumno con ese DNI dentro del archivo archivoDatos (TArchivoDatos). 
		hijos: array [1..M] of integer; // Índices de nodos en el archivo
	end;
	
    TArchivoDatos = file of alumno // Desordenado
	arbolB = file of nodo; // Ordenado por DNIs

var
    archivoDatos: TArchivoDatos;
    archivoIndice: arbolB;

{
b. Suponga que cada nodo del árbol B cuenta con un tamaño de 512 bytes. ¿Cuál
sería el orden del árbol B (valor de M) que se emplea como índice? Asuma que
los números enteros ocupan 4 bytes. Para este inciso puede emplear una fórmula
similar al punto 1b, pero considere además que en cada nodo se deben
almacenar los M-1 enlaces a los registros correspondientes en el archivo de
datos.

N = (M-1) * A + (M-1) * A + M * B + C
512 = (M-1) * 4 + (M-1) * 4 + M * 4 + 4
512 = 4M - 4 + 4M - 4 + 4M + 4
512 = 12M - 4
512 + 4 = 12M
516 = 12M
M = 516 / 12
M = 43
El orden del árbol B es 43.

c. ¿Qué implica que el orden del árbol B sea mayor que en el caso del ejercicio 1?

Un orden mayor del árbol B significa:

Menor altura del árbol: Cada nodo puede contener más claves (índices a registros), reduciendo la profundidad.

Menos accesos a disco: Se necesitan menos operaciones I/O para encontrar un registro.

Mayor uso de memoria: Cada nodo ocupa más espacio cuando se carga en memoria.

Búsquedas más eficientes: Aunque cada nodo es más grande, se requieren menos comparaciones en promedio.

d. Describa con sus palabras el proceso para buscar el alumno con el DNI 12345678
usando el índice definido en este punto.

Se busca en el árbol la clave con DNI 12345678, aprovechando el criterio de orden,
moviéndonos a la izquierda si es menor o igual, y en caso contrario, a la derecha.
Una vez hallada la clave, uso el NRR guardado en el enlace para buscar el registro en el archivo de datos.

NRR: Número de Registro Relativo.
Es un valor que indica la posición relativa de un registro dentro de un archivo.

Mejor explicado:
Para encontrar un alumno por DNI usando el índice:
Buscas el DNI en el archivoIndice (el árbol B) navegando a través de los nodos usando las claves y los hijos.
Cuando encuentras el DNI en el array claves de un nodo, obtienes el valor correspondiente del array enlaces.
Ese valor de enlaces es el número de registro que te dice exactamente en qué posición del archivoDatos se encuentra el registro alumno completo con ese DNI.
Con ese número de registro, puedes acceder directamente al registro completo del alumno en archivoDatos.

e. ¿Qué ocurre si desea buscar un alumno por su número de legajo? ¿Tiene sentido
usar el índice que organiza el acceso al archivo de alumnos por DNI? ¿Cómo
haría para brindar acceso indizado al archivo de alumnos por número de legajo?

Si se deseara buscar un alumno por su numero de legajo se deberia realizar una búsqueda secuencial hasta encontrar el alumno con el legajo
solicitado. No tendría sentido, en este caso, usar el índice que organiza el acceso al archivo de alumnos por DNI. Para brindar acceso indizado
al archivo de alumnos por número de legajos, lo más conveniente sería armar un nuevo árbol B pero con criterio de orden en base al legajo.

f. Suponga que desea buscar los alumnos que tienen DNI en el rango entre
40000000 y 45000000. ¿Qué problemas tiene este tipo de búsquedas con apoyo
de un árbol B que solo provee acceso indizado por DNI al archivo de alumnos?

El problema son los múltiples accesos aleatorios al archivo de datos (archivoDatos):
- El árbol B (archivoIndice) permite localizar eficientemente los DNIs
(o más bien, los punteros o Números de Registro Relativo - NRR - a ellos) que caen dentro del rango especificado (40000000 - 45000000).
- Sin embargo, por cada DNI que se identifica en el índice como parte del rango,
se debe realizar un acceso al archivo archivoDatos utilizando el NRR
(almacenado en el campo enlaces del nodo del árbol) para recuperar el registro completo del alumno.
- El enunciado original indica que archivoDatos es un "archivo de datos no ordenado". 
Esto implica que los registros de alumnos cuyos DNIs están secuencialmente en el rango (por ejemplo, 40000001, 40000002, etc.)
no estarán necesariamente almacenados de forma contigua en archivoDatos.
- Como resultado, recuperar cada alumno del rango probablemente implicará un acceso a disco separado
y **aleatorio** (no secuencial) en archivoDatos. Los accesos aleatorios a disco son considerablemente más lentos que los accesos secuenciales.
Si hay una gran cantidad de alumnos dentro del rango de DNIs, esto se traduce en una multitud de operaciones de E/S lentas
y dispersas en archivoDatos,lo cual degrada significativamente el rendimiento de la búsqueda por rango.
}