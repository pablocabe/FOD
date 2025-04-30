{
Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.

El programa debe presentar un menú con las siguientes opciones:

a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.

b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a), se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de “enlace” de la lista (utilice el código de
novela como enlace), se debe especificar los números de registro
referenciados con signo negativo, . Una vez abierto el archivo, brindar
operaciones para:

i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.

ii. Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.

iii. Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.

c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.

NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario.
}

program P3Ej3;

type
    str20 = string[20];

    registroNovela = record
        codigo: integer;
        genero: str20;
        nombre: str20;
        duración: integer;
        director: str20;
        precio: real;
    end;

    archivoNovelas = file of registroNovela;


procedure asignarRegistroCabecera (var novela: registroNovela);
begin
    with novela do begin
        codigo := 0;
        genero := '0';
        nombre := 'Lista invertida';
        duración := 0;
        director := '0';
        precio := 0;
    end;
end;


procedure leerNovela (var novela: registroNovela);
begin
    with novela do begin
        writeln ('Ingrese el nombre');
        readln (nombre);
        if (nombre <> 'zzz') then begin
            writeln ('Ingrese un codigo mayor a 0');
            readln (codigo);
            writeln ('Ingrese el genero');
            readln (genero);
            writeln ('Ingrese la duracion');
            readln (duracion);
            writeln ('Ingrese el director');
            readln (director);
            writeln ('Ingrese el precio');
            readln (precio);
        end;
    end;
end;


procedure crearArchivo (var archN: archivoNovelas);
var
    nombreArchivo: string;
    novela: registroNovela;
begin
    writeln ('Ingrese el nombre del archivo');
    readln (nombreArchivo);
    assingn (archN, nombreArchivo);
    rewrite (archN);
    asignarRegistroCabecera (novela);
    write (archN, novela);
    leerNovela (novela);
    while (novela.nombre <> 'zzz') do begin
        write (archN, novela);
        leerNovela (novela);
    end;
    close (archN);
end;


procedure darAltaNovela (var archN: archivoNovelas);
var
    novela, aux: registroNovela;
begin
    writeln ('Ingrese el nombre del archivo');
    readln (nombreArchivo);
    assingn (archN, nombreArchivo);
    reset (archN);
    leerNovela (novela);
    read (archN, aux);
    // Estoy parado en el registro cabcera
    if (aux.codigo = 0) and (aux.nombre <> 'zzz') then begin
        seek (archN, fileSize(archN));
        write (archN, novela);
    end
    else begin
        seek (archN, aux.codigo * -1);
        read (archN, aux);
        seek (archN, filePos(archN)-1);
        write (archN, novela);
        seek (archN, 0)
        write (archN, aux);
    end;

    close (archN);
end;


procedure modificarNovela (var archN: archivoNovelas);
var
    novela, aux: registroNovela;
    existe: boolean;
begin
    writeln ('Ingrese el nombre del archivo');
    readln (nombreArchivo);
    assingn (archN, nombreArchivo);
    reset (archN);
    writeln ('Ingrese los datos de la novela a modificar');
    leerNovela (novela);
    existe := false;
    
    while (not EOF (archN) and (not existe)) do begin
        read (archN, aux);
        if (aux.codigo = novela.codigo) then begin
            existe := true;
            seek (archN, filePos(archN)-1);
            write (archN, novela); // Se está sobrescribiendo el codigo pero es el mismo, es valido?
        end; 
    end;

    if (existe) then
        writeln ('Se modifico la novela con codigo ', novela.codigo)
    else
        writeln ('No se encontro la novela con codigo ', novela.codigo);
    close (archN);
end;


procedure eliminarNovela (var archN: archivoNovelas);
var
    novela, aux: registroNovela;
    codigoTeclado: integer;
    existe: boolean;
begin
    writeln ('Ingrese el nombre del archivo');
    readln (nombreArchivo);
    assingn (archN, nombreArchivo);
    reset (archN);
    writeln ('Ingrese el codigo de la novela a eliminar');
    readln (codigoTeclado);
    existe := false;
    read (archN, aux);
    // El registro aux toma el registro cabecera
    while (not EOF (archN) and (not existe)) do begin
        read (archN, novela);
        // El registro novela se utiliza para recorrer el archivo
        if (novela.codigo = codigoTeclado) then begin
            existe := true;
            seek (archN, filePos(archN)-1);
            write (archN, aux);
            aux.codigo := (filePos(archN)-1) * -1;
            seek (archN, 0);
            write (archN, aux);
        end;
    end;
    if (existe) then
        writeln ('Eliminada la novela con codigo ', codigoTeclado)
    else
        writeln ('No se encontro la novela con codigo ', codigoTeclado);
    close (archN);
end;


procedure crearArchivoTexto (var archN: archivoNovelas);
var
    archivoText: Text;
    novela: registroNovela;
begin
    writeln ('Ingrese el nombre del archivo binario');
    readln (nombreArchivo);
    assingn (archN, nombreArchivo);
    reset (archN);
    assign (archivoText, 'novelas.txt');
    rewrite(archivoText);

    while (not EOF (archN)) do begin
        read (archN, novela);
        if (novela.codigo < 1) then
            write (archivoText, 'Novela eliminada: ');
        write (archivoText, ' Codigo=', novela.codigo, ' Genero=', novela.genero, ' Nombre=', novela.nombre, 
              ' Duracion=', novela.duracion, ' Director=', novela.director, ' Precio=', novela.precio:0:2);
    end;

    writeln ('Archivo de texto creado');
    close (archN);
    close (archivoText);
end;

{
c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
}

procedure abrirMenuPrincipal (var archN: archivoNovelas);
var
    opcion: integer;
begin
    repeat
        writeln ('Menu principal de opciones');
        writeln('Opcion 0: Salir del menu y terminar la ejecucion del programa');
        writeln('Opcion 1: Crear archivo');
        writeln ('Opcion 2: Dar de alta una novela');
        writeln ('Opcion 3: Modificar los datos de una novela');
        writeln ('Opcion 4: Eliminar novela');
        writeln ('Opcion 5: Listar en un archivo de texto todas las novelas');
        readln (opcion);

        case opcion of
            1: crearArchivo (archN);
            2: darAltaNovela (archN);
            3: modificarNovela (archN);
            4: eliminarNovela (archN);
            5: crearArchivoTexto (archN);
        else if (opcion <> 0) then
            writeln ('Opcion inexistente');
        end; // Coresponde al case of
    until (opcion = 0);
end;

var
    archN: archivoNovelas;
begin
    abrirMenuPrincipal (archN);
end.