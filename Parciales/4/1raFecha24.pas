program examen24;
const
	valorAlto = '999';
type
	rFecha = record;
		dia: integer;
		mes: integer;
		anio: integer;
	end;

	prestamo = record
		nroSucursal : integer;
		dniEmpleado: integer;
		nroPrestamo: integer;
		fechaOtorfacion: rFecha;
		monto: real;
	end;

	maestro : file of prestamo;
procedure leerMaestro (var m: maestro; var rm: prestamo);
begin
	if (not eof (m)) then
		read (m, rm)
	else
		rm.nroPresta := valorAlto; // A los 3 campos se les pone valorAlto
end;

procedure procesar (var m: maestro; var txt:text);
var
	rm : prestamo;
	sucActual : string;
	cantSuc, cantEmpresa, anioActual, anio, cantEmpleado, empleadoActual: integer
	totalEmpleado, totalSuc , totalEmpresa, totalAnio : real;
begin
	reset (m);
	rewrite (txt);
	leerMaestro (m, rm);
	totalEmpresa := 0;
	CantEmpesa := 0;
	while (rm.nroPrestamo <> valorAlto;) do
		begin
			sucActual := rm.nroSucursal;
			writeln (txt, 'Sucursal ', sucActual);
			totEmpleado := 0;
			while ( sucActual = rm.nroSucursal) do
				begin
					empleadoActual := rm.dniEmpleado;
					writeln (txt, 'Empleado DNI: ', empleadoActual);
					cantEmpleado := 0;
					while (sucActual = rm.nroSucursal) and (empleadoActual = rm.dniEmpleado) do
						begin
							anioActual := extraerAnio (rm.fechaOtorgacion);
							cantVentas := 0;
							totalAnio:= 0;
							while (sucActual = rm.nroSucursal) and (empleadoActual = rm.dniEmpleado)  and (anioActual = extraeranio (rm.fechaOtorgacion) do
								begin
									cantVentas := cantVentas +1;
									totalAnio := totalAnio + rm.monto;
									leerMaestro (m , rm);
								end
							writeln (txt, 'anio | Cantidad de ventas | Monto de ventas');
							writeln (txt, anioActual, cantVentas, totalAnio);
							totalEmpleado := totalEmpleado + totalAnio;
							cantEmpleado := cantEmpleado + cantVentas;
						end;
					writeln (txt, 'Totales', cantEmpleado, totalEmpleado);
					totalSucursal := totalSucursal + totalEmpleado;
					cantSucursal := cantSucursal + cantEmpleado;
				end;
			writeln (txt, 'Cantidad total sucursal: ', cantSucursal);
			writeln (txt, 'Monto total vendido por sucursal' , totalSucursal)
			cantEmpresa := cantEmpresa + cantSucursal;
			totalEmpresa := totalEmpresa + totalSucursal;
		end;
	writeln (txt, 'Cantidad de ventas de la empresa ' , cantEmpresa);
	writeln (txt, 'Monto total vendido por la empresa', totalEmpresa);
	close (mae);
	close (txt);
end;

var
	mae : maestro;
	txt: text;
begin
	assign (mae, 'maestro');
	assign (txt, 'informe'); // es informe.txt
	procesar (mae, text);
end;
