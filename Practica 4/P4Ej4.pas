{ Dado el siguiente algoritmo de búsqueda en un árbol B.}

procedure buscar(NRR, clave, NRR_encontrado, pos_encontrada, resultado)
var
    clave_encontrada: boolean;
begin
    if (nodo = null)
        resultado := false {clave no encontrada}
    else
        posicionarYLeerNodo(A, nodo, NRR);
    claveEncontrada(A, nodo, clave, pos, clave_encontrada);
    if (clave_encontrada) then begin
        NRR_encontrado := NRR; { NRR actual }
        pos_encontrada := pos; { posicion dentro del array }
        resultado := true;
    end
    else
        buscar(nodo.hijos[pos], clave, NRR_encontrado, pos_encontrada, resultado)
end;

{
Asuma que el archivo se encuentra abierto y que, para la primera llamada,
el parámetro NRR contiene la posición de la raíz del árbol. Responda detalladamente.

a. PosicionarYLeerNodo(): Indique qué hace y la forma en que deben ser enviados los parámetros (valor o referencia).
Implemente este módulo en Pascal.

Es un procedimiento que se posiciona en un nodo hijo de la raíz para poder seguir buscando la clave buscada.
La variable nodo corresponde al array de claves correspondiente al nodo hijo, A es el árbol y NRR el índice.
NRR debe ser pasado por valor, mientras que nodo y A por referencia.
}

procedure posicionarYLeerNodo (var A: arbol; var nodo: registroNodo; NRR: integer);
begin
    seek (A, NRR); // Se posiciona en el NRR (Número de Registro Relativo) indicado dentro del archivo A.
    read (A, nodo); // Lee el registro (el nodo completo) desde la posición actual del archivo A y lo almacena en la variable nodo.
end;

{
b. claveEncontrada(): Indique qué hace y la forma en que deben ser enviados los parámetros
(valor o referencia). ¿Cómo lo implementaría?

El procedimiento claveEncontrada tiene la tarea de buscar una clave específica
dentro de un nodo particular del árbol B (que ya se supone cargado en memoria).
var A: arbol; nodo: registroNodo; clave: longint; var pos: integer; var clave_encontrada: boolean
}

procedure claveEncontrada(var A: arbol; nodoActual: registroNodo; claveBuscada: longint; var posSalida: integer; var encontrada: boolean)
    i: integer; // Índice para iterar sobre las claves del nodoActual
begin
    i := 1;

    // Se busca la posición de la claveBuscada o la posición del hijo a seguir.
    // Mientras 'i' no exceda la cantidad de claves en el nodo Y
    // la clave en la posición 'i' del nodo sea menor que la 'claveBuscada',
    // se incrementa 'i'.
    while (i <= nodoActual.cantClaves) and (nodoActual.claves[i] < claveBuscada) do
    begin
        i := i + 1;
    end;

    // Al salir del bucle, 'i' tiene un valor significativo:
    // 1. Si claveBuscada está en nodoActual.claves, 'i' es su posición.
    // 2. Si claveBuscada no está, 'i' es la posición del hijo por el que se debe descender
    //    (es decir, nodoActual.hijos[i]).
    // 3. O 'i' es la posición donde se insertaría claveBuscada si no está.

    // Verificar si la clave fue encontrada
    // Para que se haya encontrado, 'i' debe estar dentro del rango de claves válidas Y
    // la clave en nodoActual.claves[i] debe ser igual a claveBuscada.
    if (i <= nodoActual.cantClaves) and (nodoActual.claves[i] = claveBuscada) then
        encontrada := true // Se encontró la clave en la posición 'i' del array de claves.
                           // En el 'buscar' original, esto sería 'pos_encontrada'.
    else
        encontrada := false;
        // No se encontró la clave. 'i' es el índice para nodoActual.hijos[i].
        // En el 'buscar' original, esto es 'pos' para 'nodo.hijos[pos]'.
    posSalida := i;
end;

{
Esta implementación realiza una búsqueda lineal dentro del nodo. Para árboles B con un orden M grande,
a veces se usa una búsqueda binaria dentro del nodo si cantClaves es suficientemente grande,
pero una búsqueda lineal suele ser adecuada para valores moderados de M debido
a la sobrecarga de la búsqueda binaria y al hecho de que los nodos suelen estar en caché.
}

{Respuesta de Matías Gauymas, no guarda siempre posSalida:
El método claveEncontrada() es un procedimiento que almacena en la variable clave_encontrada true o false, 
dependiendo si la variable clave se encontró en el árbol, y si se encontró almacena la posición en la variable pos.
La variable clave_encontrada debe ser pasada por referencia ya que se debe cambiar su valor, al igual que pos, 
clave por valor porque sólo se necesita su valor y no modificarlo, y nodo y A se deben pasar por referencia.}
