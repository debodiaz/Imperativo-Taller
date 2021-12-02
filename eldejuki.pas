{Un supermercado dispone de una lista de los pedidos realizados. De cada pedido se tiene 
código del pedido, DNI del cliente y la lista de los productos pedidos (código de producto
 y cantidad).
Además se dispone de un árbol de productos. De cada producto se tiene su código y stock. 
El árbol está ordenado por código de producto.
Implemente un programa con:
A).Un módulo recursivo que recorra la lista de pedidos actualizando el stock de los productos. 
En el caso que el código de producto no exista, debe incorporarse al árbol con stock en cero.
B)Un módulo que reciba el árbol de productos y dos códigos de producto y retorne una lista con 
los códigos de los productos con stock 0 entre los dos códigos recibidos.}

program juki;



type

producto=record
  cod:integer;
  cant:integer;
  end;
  
pedido=record
  codPedido:integer;
  dni:integer;
  listaProd: listaProductos;
  end;
  
 productoArbol=record 
   cod:integer;
   stock:integer;
   end;
   
listaPedidos=^nodo;
 nodo=record
	dato:pedido;
	sig:listaPedidos;
	end;
  
 listaProductos=^nodo2;//se dispone
  nodo2=record
	dato:producto;
	sig:listaProductos;
	end; 
	
arbol= ^nodoA;//ordenado por cod
     nodoA = Record
         dato: productoArbol;
         HI: arbol;
         HD: arbol;
         end;	
         
  listaNueva=^nodoNuevo;
   nodoNuevo=record
     dato:integer;
     sig:listaNueva;
   end;
     
{A).Un módulo recursivo que recorra la lista de pedidos actualizando el stock de los productos. 
En el caso que el código de producto no exista, debe incorporarse al árbol con stock en cero.}
Procedure insertarArbol (VAR  A:arbol; p:producto);
begin
      if (a=nil) then begin
              new(a);
              a^.dato.cod:=p.cod;
              a^.dato.stock:=0;
              a^.HI:=nil;
              a^.HD:=nil;
       end
       else 
            if (a^.dato.cod > p.cod) then
            insertarArbol (A^.HI, p)
            else
            insertarArbol (A^.HD, p);
end;

procedure buscoCodArbol(var a:arbol; prod:producto);
begin
if (a=nil) then
   insertarArbol(a,prod)
else begin
 
   if (prod.cod = a^.dato.cod) then
     a^.dato.stock:= a^.dato.stock+prod.cant
    else
    begin
      if (prod.cod<a^.dato.cod) then
          buscoCodArbol(a^.HI,prod)
       else
          buscoCodArbol(a^.HD,prod);
     end;
end;
end;

procedure recorroProductos(l2:listaProductos;var a:arbol);
begin
  if (l2<>nil) then begin
    buscoCodArbol(a,l2^.dato);
    recorroProductos(l2^.sig, a);
    end;
end;

procedure recorroListaP(l:listaPedidos; var a:arbol);


begin
  if (l<>nil) then begin
    if(l^.dato.listaProd <>nil) then
       recorroProductos(l^.dato.listaProd,a);
    recorroListaP(l^.sig,a);
  end;
end;

procedure agregarAdelante(var l:listanueva; cod:integer);
var 
  nue:listaNueva;
begin
  new(nue);
  nue^.dato:=cod;
  nue^.sig:=l;
  l:=nue;
end;

{B)Un módulo que reciba el árbol de productos y dos códigos de producto y retorne una lista con 
los códigos de los productos con stock 0 entre los dos códigos recibidos.}   
procedure retornoLista(a:arbol; var l:listaNueva; cod1,cod2:integer);
begin
  if (a<>nil) then begin
 
          if ( a^.dato.cod >= cod1 ) then begin
                    if( a^.dato.cod <= cod2 ) then begin
                        if(a^.dato.stock=0)then
                         agregarAdelante(l,a^.dato.cod);
            
                         end
                     else
                         retornoLista(a^.HI, l,cod1, cod2);
                         end
              else
                  retornoLista( a^.HD,l, cod1, cod2);
   end;
   end;



var
l:listaPedidos;
a:arbol;
ln:listaNueva;
begin
l:=nil;
ln:=nil;
 recorroListaP(l,a);
 retornoLista(a,ln,2,56);
end.
