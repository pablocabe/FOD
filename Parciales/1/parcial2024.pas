program parcial;
const 
    valorAlto = 999;
    cantArch = 30;
type
    str = String[30];
    maestro = record
        codMuni: Integer; // ordenado por este
        cantCasoPos: Integer;
        nombre: str;
    end;
    detalle = record
       codMuni: Integer; // ordenado por este
       cantCasoPos: Integer;
    end;
    archMaestro = file of maestro;
    archDetalle= file of detalle; 
    // en cada archivo puede venir info de cualquier municipio, un municipio puede aparecer cero, una o mas de una vez en cada archivo
    archivosDetalles= array [1..cantArch] of archDetalle; 
    vecRegDet = array[1..cantArch] of archDetalle; //registros detalless

var
    mae: archMaestro;
    detalles: archivosDetalles;

procedure Leer(var det: archDetalle; var d: detalle);
begin
  if (not Eof(det)) then
    Read(det, d)
  else
    d.codMuni:= valorAlto;
end;
 procedure LeerRegistrosDetalles(var detalles:archivosDetalles ;var regdet:vecRegDet);
 var
  i:Integer;
 begin
    for i:=1 to cantArch do
    begin
      Leer(detalles[i], regdet[i]);
    end;
 end;
procedure  InicializarArchivos(var mae: archMaestro; var detalles: archivosDetalles);
var
    nombre: str;
    i:Integer;
begin
    WriteLn('ingrese el nombre del archivo maestro');
    Readln(nombre);
    Assign(mae, nombre);
    for i := 1 to cantArch do 
    begin
      WriteLn('ingrese el nombre del archivo detalles');
      Readln(nombre);
      Assign(detalles[i], nombre);
    end;
end;
procedure CalcularMinimo(var regdet:vecRegDet; var minimo:detalle);
var
  i,pos:Integer;
begin
  minimo.codMuni:= 999;
  for i:=1 to cantArch do
  begin
    if(vecRegDet[i].codMuni < minimo.codMuni) then
    begin
        minimo.codMuni:= vecRegDet[i].codMuni;
        pos:= i;
    end;
  end;
  if(minimo.codMuni <> valorAlto)then
    Leer(detalles[pos], regdet[i]);
 
end;

procedure  ProcesarDatos();
var
  i:Integer;
  regM: maestro;
  regDetmin: detalle;
  regdet: vecRegDet;
begin
  Reset(mae);
  for i:=1 to cantArch do
  begin
    Reset(detalle[i]);
  end;
  LeerRegistrosDetalles(detalles,regdet);
  CalcularMinimo(regdet, regDetmin);
  while (not eof(mae)) do
  begin
    Read(mae, regM);
    while (regM.codMuni = regDetmin.codMuni) do
    begin
        regM.cantCasoPos:=regM.cantCasoPos + regDetmin.cantCasoPos;
        CalcularMinimo(regdet,regDetmin);
    end;
    if(regM.cantCasoPos >15) then
    begin
      WriteLn('codigo', regM.codMuni,'nombre', regM.nombre);
    end;
    Seek(mae, FilePos(mae)-1);
    Write(mae, regM);
  end;
  Close(mae);
  for i:=1 to cantArch do
  begin
    Close(detalle[i]);
  end;
end;
   
begin
  InicializarArchivos(mae, detalles);
  ProcesarDatos(mae, detalle);
end.