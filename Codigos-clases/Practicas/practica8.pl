natural(cero).
natural(_).
natural(suc(X)) :- natural(X).

% pred mayorA2(X): V cuando X es mayor que 2
% Va a ser Nat y de minima va a valer 3
mayorA2(suc(suc(suc(_)))).
mayorA2(suc(X)) :- mayorA2(X).

% pred esPar(X): V cuando X es par
esPar(cero).
esPar(suc(suc(X))) :- esPar(X).

% pred menor(X,Y): V cuando X < Y
menor(cero, suc(X)) :- natural(X).
menor(suc(X), suc(Y)) :- menor(X,Y). 

%! entre(+X, +Y, -Z)
entre(X,Y,X) :- X =< Y.
entre(X,Y,Z) :-
    X < Y, N is X + 1, entre(N, Y, Z).

% Ejemplo: amaALosGatos
gato(garfield).
tieneMascota(john,odie).
tieneMascota(john,garfield).
amaALosGatos(X) :- tieneMascota(X,Y) , gato(Y).

%! long(+L, -N)
long([], 0).
long([_ | T], N) :- long(T,M), N is M+1.

%! sacar(+X, +XS, -YS)
sacar(_, [], []).
sacar(X, [X | T], L) :- sacar(X, T, L).
sacar(X, [H | T], [H | L]) :-
    X \= H, sacar(X, T, L).

%! sinConsecRep(+XS,-YS)
sinConsecRep([], _).
sinConsecRep(X, L) :- 
    sinConsecRep(X, L).

% Utilizando el siguiente predicado:
append([],L,L).
append([X|L1],L2,[X|L3]) :- append(L1,L2,L3).
% Implementar los siguientes:
                                % Juntos: SL aparece consecutivamente dentro de L
%! insertar(?X,+L,?LX)
insertar(X, L, LX) :-
    append(Antes, Despues, L),          % divide L en dos partes
    append(Antes, [X | Despues], LX).   % inserta X entre esas dos partes
                                        % Prolog prueba todas las posiciones posibles

%! permutacion(+L,?P)


% pred member
member(X,[X|_]).
member(X,[_|L]) :- member(X,L).
% member(2,[1,2]).      --> true; false.
% member(X,[1,2]).      --> X = 1; X = 2; false.
% member(5,[X,3,X]).    --> X = 5; X = 5; false.
% member(2,[1,2,2]).    --> true; true; false.
%  length(L,2), member(5,L), member(2,L). --> L = [5,2]; L = [2,5]; false.

% ==== 1 ====
padre(juan, carlos).
padre(juan, luis).
padre(carlos, daniel).
padre(carlos, diego).
padre(luis, pablo).
padre(luis, manuel).
padre(luis, ramiro).
abuelo(X,Y) :- padre(X,Z), padre(Z,Y).

% i) abuelo(X, manuel) => X = juan; false.
% ii)
hijo(X,Y) :- padre(Y,X).
hermano(X,Y) :- padre(Z,X), padre(Z, Y).
descendiente(X,Y) :- padre(Y,X).
descendiente(X,Y) :- padre(Y,Z), descendiente(X,Z).
% iii)
% descendiente(Alguien, juan).:
    % Alguien = carlos ;
    % Alguien = luis ;
    % Alguien = daniel ;
    % Alguien = diego ;
    % Alguien = pablo ;
    % Alguien = manuel ;
    % Alguien = ramiro ;
    % false.

% iv) abuelo(juan, Nieto). -> daniel; diego; ...; ramiro.
% v) hermano(pablo, Hermano). -> pablo; manuel; ramiro.

% vi)
ancestro(X, X).
ancestro(X, Y) :- ancestro(Z, Y), padre(X, Z).

% Si se pide mas de un resultado, ancestro va bajando por el arbol
% hasta quedar sin mas elementos (ultimo elem: ramiro).
% Luego, no puede continuar, tal que ancestro queda trabado y crashea

% viii) Invirtiendo los valores, tal que quede: 
% ancestro(X, X).
% ancestro(X, Y) :- padre(X, Z), ancestro(Z, Y).
/* 
El programa analiza primero si el elemento es padre y luego si 
tiene algun ancestro mas, tal que cuando se queda sin elementos
por recorrer, devuelve false.
 */

% ==== 2 ====
vecino(X, Y, [W|LS]) :- vecino(X, Y, LS).
vecino(X, Y, [X|[Y|LS]]).
/* 
i. Y = 6; Y = 3; false;

ii. No, devuelve Y = 3; Y = 6, pero no devuelve false,
    El orden es el mismo
*/

% ==== 3 ====
menorOIgual(X, suc(Y)) :- menorOIgual(X, Y).
menorOIgual(X,X) :- natural(X).

/*
i.  Al hacer menorOIgual(0,X). el programa crashea, ya que 
    el programa busca primero resolver una recursividad en la
    que no fue definida su caso base. 

ii. Cuando se define un caso recursivo antes que el caso base
    Cuando se recorre una lista/arbol y no se coloca una guarda
        para finalizar el recorrido

iii.    menorOIgual(X,X) :- natural(X).
        menorOIgual(X, suc(Y)) :- menorOIgual(X, Y).
*/    

% ==== 4 ====
%! juntar(?Lista1,?Lista2,?Lista3)
juntar([],L2,L2).                                       % Si L1 es vacia, L2 == L2
juntar([H | T1], L2, [H | T3]) :- append(T1, L2, T3).   % Si L1 tiene head H y tail L1
                                                        % Agrego H al inicio de res (L3)
                                                        % Recursivamente junto T1 con T2
% ==== 5 ====
%! i. last(?L, ?U)                                        
last(L, U) :- append(_, [U], L).

%! iii. prefijo(+L,?P):
prefijo(L, P) :-
    append(P, _, L).    % "P concatenado con algo (_) da L"

%! iv. sufijo(+L,?S):
sufijo(L, S) :-
    append(_, S, L).    % Mismo analisis que prefijo pero invertido

%! v. sublista(+L,?SL)
sublista(L, SL) :-
    append(_, Resto, L),        % divide L en dos partes: algo + Resto
    append(SL, _, Resto).       % SL es un prefijo de Resto

%! vi. pertenece(?X, +L)
pertenece(X, L) :-
    append(_, [X], L).

% ==== 6 ====
aplanar([],[]).
aplanar(H|_, YS) :- 
    aplanar(H, AplanaH),
    aplanar(H, AplanaT),
    append(AplanaH, AplanaT, YS).

% ==== 7 =====
%! i. intersección(+L1, +L2, -L3)
interseccion([],_, []).
interseccion([X|L1],L2,[X|L3]) :-
    member(X, L2),
    interseccion(L1,L2,L3).
interseccion([X|L1],L2,L3) :-
    \+ member(X, L2),
    interseccion(L1,L2,L3).

%! ii. borrar(+ListaOriginal, +X, -ListaSinXs)
borrar(_, [], []).
borrar(X, [X | T], L) :- borrar(X, T, L).
borrar(X, [H | T], [H | L]) :-
    X \= H, borrar(X, T, L).

%! iii. sacarDuplicados(+L1, -L2)
sacarDuplicados([],[]).
sacarDuplicados([H | T], [H | L2]) :- 
    \+ member(H,T),                     % X no aparece mas adelante en L1
    sacarDuplicados(T, L2).
sacarDuplicados([H | T], L2) :-
    member(H, T),                       % X aparece mas adelante en L1
    sacarDuplicados(T, L2).             % Lo salteo
% \+ := Negacion como fallo, si H no aparece en T, entonces devuelve true

%! iv. permutación(+L1, ?L2)
permutacion([], []).
permutacion(L1, [H|T]) :-
    member(H, L1),                      % H es miembro de L1
    append(Antes, [H|Despues], L1),     % Saco H de L1
    append(Antes, Despues, Resto),      % Resto == L1 sin H
    permutacion(Resto, T).              % Busco permutacion en el resto
% Antes = Primeros N elementos de L
% Despues = Ultimos N elementos de L
% N + M = length(L)

%! v. reparto(+L, +N, -LListas)
reparto(L,1,[L]).               % Caso base: 1 lista es L
reparto(L, N, [H|T]) :-
    N > 1,
    append(H, Resto_L, L),      % Divido L en lo que busco y su resto
    N1 is N -1,
    reparto(Resto_L, N1 , T).   % Reparto el resto en N-1 partes

% ==== 8 ====
parteQueSuma(L, S, P) :-
    parteAux(L,S,0,P).

parteAux([], S, S, []).                     % Caso base: suma acumulada = S objetivo
parteAux([H | T], S, Acum, [H | L2]) :-
    NuevoAcum is Acum + H,                  % Incluyo H en la solucion
    parteAux(T, S, NuevoAcum, L2).
parteAux([_|T], S, Acum, L2) :-
    parteAux(T, S, Acum, L2).               % Excluyo el elemento

% ==== 9 ====
% i. Debo verificar que X sea natural y que X <= Y
% ii.
desde(X,X).
desde(X,Y) :- 
    desde(X, N),
    Y is N+1.

% ==== 11 ====
abb(nil).
abb(bin(Izq, _, Der)) :- abb(Izq), abb(Der).

vacio(nil).
raiz(bin(_, R, _), R).

altura(nil,0).
altura(bin(I, _, D), A) :-
    altura(I, AI),
    altura(D, AD),
    A is max(AI, AD) + 1.

cantidadNodos(nil, 1).
cantidadNodos(bin(I, _, D), N) :-
    cantidadNodos(I, NI),
    cantidadNodos(D, ND),
    N is NI + ND + 1.