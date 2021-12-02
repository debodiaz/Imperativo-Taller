{1. En un colegio secundario, cada alumno participa de un proyecto de ciencias. El proyecto de
un alumno pertenece a un tópico (volcanes, vida marina, migración de las aves, etc.). Un
mismo alumno pudo haber presentado más de un proyecto (en distintos tópicos). En la
última hora del evento las personas visitantes pueden votar el proyecto del alumno que más
le gustó.
a. Realice un programa para el sistema de votación. Un voto consiste en el nombre del
alumno y el tópico en el cual pertenece el proyecto.
b. Almacene esta información en una estructura óptima para la búsqueda, ordenada
por nombre de alumno. Para cada alumno almacene todos sus proyectos ordenado
por tópico.
c. Al finalizar la carga (se lee el alumno ‘zzz’) se debe informar:
i. Cual fue el proyecto ganador: nombre del alumno, tópico y cantidad de
votos.
ii. Número de votos totales, es decir la suma de los votos de todos los
proyectos en los que participa un alumno, ordenados alfabéticamente por
nombre de alumno.}

program colegio;



type

voto=record
  nombre:string;
  topic:string;
  end;
  
  
 lista= ^nodo;//ordenada por topico
 nodo=record
   dato:string;
   sig:lista;
   end;
   
 alumno=record
   nombre:string;
   proyectos:lista;
   end;
    
arbol=^nodoA;
nodoA=record
  dato: alumno;
  HI:arbol;
  HD:arbol;
  end;

procedure leerVoto(var v:voto);

begin
with v do begin
writeln('ingrese nombre alumno');
readln(nombre);
if (nombre <> 'ZZZ') then begin
  writeln('ingrese topico que mas le gusto');
  readln(topic);
end;
end;
end;
procedure insertarOrdenado(var l:lista; t:string);

var
     ant, nue, act: lista;
begin
     new (nue);
     nue^.dato := t;
     act := l;
     ant:=l;
     while (act<>NIL) and (act^.dato < t) do begin
           ant := act;
           act := act^.sig ;
           end;
     if (act = ant) then
            l:= nue
     else
            ant^.sig := nue;
     nue^.sig := act ;
end;

procedure buscarAlumno(a:arbol;var encontre:boolean; nom:string;t:string);
begin
 if(a=nil) then
   encontre:=false
  else 
    begin
      if (a^.dato.nombre=nom) then begin
        encontre:=true;
        insertarOrdenado(a^.dato.proyectos,t);
       end
      else
        begin
          if (nom<a^.dato.nombre) then
            buscarAlumno(a^.HI,encontre,nom,t)
           else
             buscarAlumno(a^.HD,encontre,nom,t);
        end;
    end; 
end;



procedure insertarArbol(var a:arbol; alum:alumno );
begin
  if (a=nil) then begin
              new(a);
              a^.dato:=alum;
              a^.HI:=nil;
              a^.HD:=nil;
       end
       else 
            if (a^.dato.nombre > alum.nombre) then
            insertarArbol (a^.HI, alum)
            else
            insertarArbol (a^.HD, alum);
end;

procedure cargarArbol(var a:arbol);
var
v:voto;
t:string;//lo q va dentro de la lista
encontre:boolean;
alum:alumno;
begin
  a:=nil;
  leerVoto(v);
  while(v.nombre<>'ZZZ') do begin
    encontre:=false;
    alum.nombre:= v.nombre;
    t:=v.topic;
    buscarAlumno(a,encontre,alum.nombre,t);
    if (encontre =false) then begin
        alum.proyectos:=nil;
        insertarOrdenado(alum.proyectos,t);
        insertarArbol(a,alum);
       end;
     leerVoto(v);
    end;
end;
//Cual fue el proyecto ganador: nombre del alumno, tópico y cantidad de votos.
procedure cuentoTopicos(l:lista; var votos:integer; var topicoMax:string);
var
actual:string;
suma:integer;
begin
  suma:=0;
  while(l <>nil) do begin
    actual:=l^.dato;
    while((l <>nil) and (l^.dato = actual)) do begin 
      suma:=suma+1;
      l:=l^.sig;
      end;
     if( suma > votos) then begin
       votos:=suma;
       topicoMax:=actual;
     end;
     
  end;
end;

procedure cuentoVotos(a:arbol;var votoMax:integer; var topicoMax,alumnoMax:string);

begin
  if (a= nil) then begin
    topicoMax:= 'no hay topico';
    alumnoMax:='no hay alumno';
  end
  else
    begin
      alumnoMax:=a^.dato.nombre;
      cuentoTopicos(a^.dato.proyectos,votoMax,topicoMax);
      cuentoVotos(a^.HI,votoMax,topicoMax,alumnoMax);
      cuentoVotos(a^.HD,votoMax,topicoMax,alumnoMax);
    end;
end;

{Número de votos totales, es decir la suma de los votos de todos los
proyectos en los que participa un alumno, ordenados alfabéticamente por
nombre de alumno.}

procedure recuentoTotal(a:arbol);
var
votos:integer;
begin

      if (a <> nil) then begin
            recuentoTotal(a^.HI);
            votos:=0;
             while(a^.dato.proyectos<>nil) do begin
                 votos:=votos +1;
                 a^.dato.proyectos:=a^.dato.proyectos^.sig;
             end;
             writeln(a^.dato.nombre,' ',votos);
             recuentoTotal(a^.HD);
            end;

end;
//ppal

var
a:arbol;
votoMax:integer;
topicoMax:string;
alumnoMax:string;
begin
  
  votoMax:=-1;
  cargarArbol(a);
  cuentoVotos(a,votoMax,topicoMax,alumnoMax);
  writeln('el alumno que mas votos obtuvo es ',alumnoMax,' cuyo topico ',topicoMax,' obtuvo ',votoMax,' votos');
  recuentoTotal(a);
end.
