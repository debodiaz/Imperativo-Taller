{Una cadena de entrega de Comidas Rápidas necesita procesar su facturación para enviar un regalo de fin de año a sus mejores clientes. 
* Entregará para el mes de Octubre un premio diario al cliente que hizo el pedido de mayor monto.

Se dispone de una estructura que almacena los pedidos de Octubre agrupados por número de punto de envío (de 1 a 10). Para cada punto de envío, 
* los pedidos se encuentran ordenados por día del mes. Por cada pedido se conoce el día, número de pedido, dni del cliente y monto.

Además se dispone de un vector desordenado con información personal de 3500 clientes. De cada cliente se conoce el dni, dirección y teléfono.

Implemente un programa que: 

Ordene, por dni, los elementos del vector de clientes que se dispone. Es necesario este ordenamiento para obtener información del cliente
*  en el siguiente inciso con mayor eficiencia.
Reciba la estructura con los pedidos y, usando la técnica de merge, imprima en pantalla para cada día del mes, el número de pedido ganador,
*  el dni y teléfono del cliente correspondiente. Por cada día, el pedido ganador es aquel con mayor monto. 
La búsqueda del cliente en el vector de información personal debe implementarse de forma recursiva. Si el cliente no está en el vector, 
* se deberá informar el día y “Premio vacante”.

NOTA: En cada punto de envío se pueden haber realizado más de un pedido en el mismo día. }

program parcialComidasRapidas;

const
cantClientes=3500;
dimF=10;

type
clientes=1..cantClientes;
rango=1..10;


cliente=record
	dni:integer;
	direccion:string;
	telefono:integer;
	end;
	
pedidosOctubre=record
	puntoE:rango;
	dia: integer;
	nroP:integer;
	dni:integer;
	monto:real;
	end;
	
 lista=^nodo;
 nodo=record
	dato:pedidosOctubre;
	sig:lista;
	end;
	
vectorPunto=array [rango] of lista;//se dispone
vector=array[clientes] of cliente;//se dispone desordenado

{Ordene, por dni, los elementos del vector de clientes que se dispone. Es necesario este ordenamiento para obtener información del cliente
*  en el siguiente inciso con mayor eficiencia.}
procedure ordenarVector(var v:vector);//por dni
var
i,j,num: integer;
begin
for i := 2 to cantClientes do
begin
  num:=v[i].dni;
  j:=i-1;
  while (j>0) and (v[j].dni>num) do begin
    v[j+1]:=v[j];
    j:=j-1;
  end;
  v[j+1].dni:= num;
end;
end;

procedure minimo(var vP:vectorPunto; var min:pedidosOctubre);
var
i,pos:integer;
begin
  min.dia:=9999;
  min.monto:=-1;//busco el monto max
  pos:=-1;
  for i:=1 to dimF do begin
    if (vP[i]<>nil) then begin
      if (min.dia> vP[i]^.dato.dia) and (min.monto < vP[i]^.dato.monto) then begin
        min.monto:=vP[i]^.dato.monto;
        min.dia:=vP[i]^.dato.dia;
        pos:= i;
     end;
    end;
  end;
  if(pos<>-1) then begin
    min.dni:=vP[i]^.dato.dni;
    min.nroP:=vP[i]^.dato.nroP;
    vP[pos]:=vP[pos]^.sig;
  end;
  end;
  
  procedure buscarDni(v:vector;dni:integer;var ini,fin,pos:integer);
var

    medio:integer;
begin
   if (ini>fin) then
      pos:=0
   else 
     begin
      medio:=(ini+fin)div 2;
      if(v[medio].dni = dni)then
          pos:= medio
      else
      begin
         if (dni < v[medio].dni)then
            buscarDni(v,dni,ini,medio-1,pos)
         else
            buscarDni(v,dni,medio+1,fin,pos);
      end;
end;

end;
procedure buscarCliente(v:vector;c:cliente;pos:integer);//busco la info del cliente
begin
c.dni:=v[pos].dni;
c.telefono:=v[pos].telefono;
end;
  
 {Reciba la estructura con los pedidos y, usando la técnica de merge, imprima en pantalla para cada día del mes, el número de pedido ganador,
*  el dni y teléfono del cliente correspondiente. Por cada día, el pedido ganador es aquel con mayor monto. 
* La búsqueda del cliente en el vector de información personal debe implementarse de forma recursiva.
*  Si el cliente no está en el vector,se deberá informar el día y “Premio vacante”.}       

procedure merge(vP:vectorPunto; v:vector);
var
min:pedidosOctubre;
actual,ini,fin,pos: integer;
ganador:pedidosOctubre;
cli:cliente;


begin
  ini:=1;
  fin:=cantClientes;
  pos:=-1;
  min.dia:=9999;
  minimo(vP,min);
  while(min.dia<>9999) do begin
    actual:=min.dia;
    ganador.monto :=min.monto;
    while ((min.dia<>9999) and (actual=min.dia))do begin
      if(ganador.monto <min.monto) then begin
      ganador.monto:=min.monto;
      ganador.dni:=min.dni;
      ganador.nroP:=min.nroP;
      end;
      minimo(vP,min);
    end;
    buscarDni(v,ganador.dni,ini,fin,pos);
    if (pos<>0) then begin
      cli.dni:=ganador.dni;
      buscarCliente(v,cli,pos);
      writeln('para el dia ',actual,' numero de pedido ganador es ',ganador.nroP,' el dni del cliente ganador es',cli.dni,' y su telefono es ',cli.telefono);
    end
    else
      writeln('para el dia ',actual,'Premio vacante');
end;
end;

//programa principal
var
v:vector;
vP:vectorPunto;
begin
 ordenarVector(v);
 merge(vP,v);
end.
