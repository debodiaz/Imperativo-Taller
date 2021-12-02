
{Una pizzeria recibe pedidos telefonicos de sus clientes.De cada pedido interesa conocer:
* DNI del cliente,nombre,fecha y monto a abonar por el pedido
* 1)Lea la informacion de los pedidos telefonicos hasta ingresar uno con monto 0.
* A partir de esto, genere una estructura que almacene para cada DNI de cliente,
* su nombre y una lista con informacion de la fecha y monto de los pedidos realizados.
* La estructura debe ordenado por DNI  y ser eficiente para la busqueda por dicho criterio.
* A partir d ela estructura generada en 1) realice modulos independientes para:
* a)A partir del arbol informar la cant de clientes que realizaron 
* pedidos en una fecha leida por teclado
* b)informar total abonado y total d epedidos realizados por el cliente
* cuyo dni coincide con uno ingresado
* Nota: la informacion en 1) se lee sin orden alguno
* }
program imperativo;


type
pedido=record
  dni:integer;
  nombre:string;
  fecha:string;
  monto:real;
  end;
  
 dataLista=record
   fecha:string;
   monto:real;
   end;
   
   lista =^nodo;
 nodo=record
   dato:dataLista;
   sig:lista;
   end;
   
 cliente=record
   dni:integer;
   nombre:string;
   listaPedidos:lista;
   end;
  
arbol=^nodoA;
nodoA=record
  dato: cliente;
  HI:arbol;
  HD:arbol;
  end;
  
procedure leerPedido(var p:pedido);
begin
  with p do begin
    writeln('Ingrese monto');
    readln(monto);
    if(monto<>0) then begin
      writeln('ingrese dni');
      readln(dni);
      writeln('ingrese nombre');
      readln(nombre);
      writeln('ingrese fecha');
      readln(fecha);
    end;
  end;
end;

procedure agregarAdelante(var l:lista; d:dataLista);
var
nue:lista;
begin
  new(nue);
  nue^.dato:=d;
  nue^.sig:=l;
  l:=nue;
end;
procedure buscarCliente(a:arbol;var encontre:boolean; dni:integer;d:dataLista);
begin
 if(a=nil) then
   encontre:=false
  else 
    begin
      if (a^.dato.dni=dni) then begin
        encontre:=true;
        agregarAdelante(a^.dato.listaPedidos,d);
       end
      else
        begin
          if (dni<a^.dato.dni) then
            buscarCliente(a^.HI,encontre,dni,d)
           else
             buscarCliente(a^.HD,encontre,dni,d);
        end;
    end; 
end;

procedure insertarArbol(var a:arbol; c:cliente);
begin
  if (a=nil) then begin
              new(a);
              a^.dato:=c;
              a^.HI:=nil;
              a^.HD:=nil;
       end
       else 
            if (a^.dato.dni > c.dni) then
            insertarArbol (a^.HI, c)
            else
            insertarArbol (a^.HD, c);

end;

procedure cargarArbol(var a:arbol);//a partir de un pedido cargo el arbol, 
//si el cliente ya esta en el arbol, solo actualizo la lista
var
p:pedido;
c:cliente;
d:dataLista;
encontre:boolean;
begin
  a:=nil;
  leerPedido(p);
  while(p.monto<>0) do begin
    encontre:=false;
    c.dni:=p.dni;
    d.fecha:=p.fecha;
    d.monto:=p.monto;
    buscarCliente(a,encontre,c.dni,d);
    if (encontre =false) then begin
        c.nombre:=p.nombre;
        c.listaPedidos:=nil;
        agregarAdelante(c.listaPedidos,d);
        insertarArbol(a,c);
       end;
     leerPedido(p);
    end;
end;
{A partir del arbol informar la cant de clientes que realizaron 
* pedidos en una fecha leida por teclado}
function fechaCliente(l:lista;unafecha:string):integer;
begin
  if (l=nil) then
    fechaCliente:=0
   else
   begin
     if (l^.dato.fecha = unaFecha) then
     fechaCliente:= 1
     else
       fechaCliente(l^.sig,unafecha);
   end;
end;

function pedidosxFecha(a:arbol; unaFecha:string):integer;

begin
 if (a=nil) then
   pedidosxFecha:=0
  else
  begin
    if (a^.dato.listaPedidos^.dato.fecha = unaFecha) then
       pedidosxFecha:= 1 + pedidosxFecha(a^.HI, unaFecha)+ pedidosxFecha(a^.HD, unaFecha)
       else
         pedidosxFecha:=fechaCliente(a^.dato.listaPedidos^.sig,unafecha);
         
  end;
end;


{informar total abonado y total d epedidos realizados por el cliente
* cuyo dni coincide con uno ingresado}
procedure totalxCliente(l:lista; var tA:real; var tP:integer);
begin
       while(l<>nil) do begin
       tA:=l^.dato.monto + tA;
       tP:=1+tP;
       l:=l^.sig;
     end;
   
end;

procedure clienteTotal(a:arbol;unDNI:integer;var tA:real; var tP:integer);

begin
  if(a=nil) then begin
   tA:=0;
   tP:=0;
   end
  else 
    begin
      if (a^.dato.dni= unDNI) then begin
          totalxCliente(a^.dato.listaPedidos,tA,tP);
        
       end
      else
        begin
          if (unDNI <a^.dato.dni) then
            clienteTotal(a^.HI,unDNI,tA,tP)
           else
              clienteTotal(a^.HD,unDNI,tA,tP);
        end;
    end; 

end;

//ppal
var
a:arbol;
unaFecha:string;
unDNI:integer;
totalAbonado:real;
totalPedidos:integer;
begin
  totalAbonado:=0;
  totalPedidos:=0;
  cargarArbol(a);
  writeln('ingrese fecha para saber cuantos clientes realizaron pedidos ese dia');
  readln(unaFecha);
  writeln( pedidosxFecha(a,unaFecha));
  writeln('ingrese dni de cliente para saber su total abonado y su total de pedidos ');
  readln(unDNI);
  clienteTotal(a,unDNI,totalAbonado,totalPedidos);
  writeln('el total abonado por el cliente',unDNI,' es ',totalAbonado,' y el total de pedidos que realizo es ',totalPedidos);
  
end.
