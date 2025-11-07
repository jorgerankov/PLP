/* 	Usando el ejemplo del enunciado del TP, 
	el predicado aplicado paso a paso queda:
	
	length(M, 2) -> M = [_, _]
	maplist(asignar_lista(3), [_, _])
		* Aplicamos asignar_lista(3) al primer elemento: len_lista(3, _) -> _ = [_, _, _]
		* Misma aplicación para el segundo elemento: len_lista(3, _) -> _ = [_, _, _]

	Finalmente, nos queda una matriz M de la forma: [[_, _, _], [_, _, _]]

	Por otro lado, la aplicación de nth1 funciona de la sig. manera:
		matriz(2, 3, M), --> Crea la matriz de 2x3 
		nth1(1, M, F1),	 --> Accede a la primer fila de la matriz M, y la denomina F1
		nth1(2, F1, x).	 --> Accede al segundo elemento de F1 y lo "pinta" con una x
	
	Luego, el resultado queda de la sig. forma:
		M = [[_A, x, _B], [_, _, _]],
		F1 = [_A, x, _B].
*/

% Ejercicio 1
matriz(F, C, M) :-
    length(M, F),					% Crea una lista M de longitud F (con variables sin asignar)
    maplist(asignar_lista(C), M).	% Asigna los C valores a cada elemento de M
									% Equivalente a llenar con C elementos del tipo "_" cada fila de M

% Ejercicio 2
replicar(X, N, L) :- length(L, N), maplist(=(X), L).				
% Crea lista L de N variables
% =(X) unifica cada elemento de L con X
% Es un predicado built-in que funciona: =(X, A) → A = X

% Ejercicio 3
%! transponer(+M, -MT)
transponer([], []).
transponer([[]|_], []).
transponer(M, [Columna|RestoColumnas]) :-
	maplist(primera_columna, M, Columna, Resto),
	transponer(Resto, RestoColumnas).

primera_columna([X|Xs], X, Xs).		% Extrae el primer elemento de cada fila

% Predicado dado armarNono/3
armarNono(RF, RC, nono(M, RS)) :-
	length(RF, F),
	length(RC, C),
	matriz(F, C, M),
	transponer(M, Mt),
	zipR(RF, M, RSFilas),
	zipR(RC, Mt, RSColumnas),
	append(RSFilas, RSColumnas, RS).

zipR([], [], []).
zipR([R|RT], [L|LT], [r(R,L)|T]) :- zipR(RT, LT, T).

% Ejercicio 4
% R es de la forma r(Restricciones, Celdas)
% Busca unificar Celdas con todas las posibles soluciones
pintadasValidas(r(Restricciones, Celdas)) :- 
	maplist(llenar_celda, Celdas),					% Llena (pinta) cada celda
	extraerBloques(Celdas, Bloques),
	Bloques = Restricciones.

% Ejercicio 5
% El nonograma (NN) tiene la estructura:
% 	M = matriz de celdas
% 	RS = lista de restricciones (filas + columnas)
resolverNaive(nono(M, RS)) :-
    maplist(maplist(llenar_celda), M),		% Llena todas las celdas de la matriz
    maplist(validar_restriccion_r, RS).		% Verifica que todas las restricciones se cumplan

% Convierte r(Restricciones, Celdas) a validar_restriccion/2
validar_restriccion_r(r(Restricciones, Celdas)) :- validar_restriccion(Restricciones, Celdas).

% Ejercicio 6
% El operador -> es un condicional if-then-else
% Es la forma que Prolog tiene de hacer decisiones
% Sintaxis: (Condición -> AccionIfTrue ; AccionIfFalse)
pintarObligatorias(r(Restricciones, Celdas)) :- 
	length(Celdas, N),
	findall(Combinacion,
		(length(Combinacion, N),
		 maplist(llenar_celda, Combinacion),
		 validar_restriccion(Restricciones, Combinacion)),
		Soluciones),
	Soluciones \= [],  % Debe haber al menos una solución
	transponer(Soluciones, Columnas),
	maplist(pintar_celda_obligatoria, Celdas, Columnas).

% Predicado dado combinarCelda/3
combinarCelda(A, B, _) :- var(A), var(B).
combinarCelda(A, B, _) :- nonvar(A), var(B).
combinarCelda(A, B, _) :- var(A), nonvar(B).
combinarCelda(A, B, A) :- nonvar(A), nonvar(B), A = B.
combinarCelda(A, B, _) :- nonvar(A), nonvar(B), A \== B.

% Ejercicio 7
deducir1Pasada(nono(_, RS)) :- maplist(pintarObligatorias, RS).

% Predicado dado
cantidadVariablesLibres(T, N) :- term_variables(T, LV), length(LV, N).

% Predicado dado
deducirVariasPasadas(NN) :-
	NN = nono(M,_),
	cantidadVariablesLibres(M, VI), % VI = cantidad de celdas sin instanciar en M en este punto
	deducir1Pasada(NN),
	cantidadVariablesLibres(M, VF), % VF = cantidad de celdas sin instanciar en M en este punto
	deducirVariasPasadasCont(NN, VI, VF).

% Predicado dado
deducirVariasPasadasCont(_, A, A). % Si VI = VF entonces no hubo más cambios y frenamos.
deducirVariasPasadasCont(NN, A, B) :- A =\= B, deducirVariasPasadas(NN).

% Ejercicio 8
restriccionConMenosLibres(nono(_, RS), R) :- completar("Ejercicio 8").

% Ejercicio 9
resolverDeduciendo(NN) :- completar("Ejercicio 9").

% Ejercicio 10
solucionUnica(NN) :- findall(_, resolverNaive(NN), [_]).

% =====================================================
% =============== Funciones Auxiliares ================
% =====================================================

asignar_lista(C, Fila) :- length(Fila, C).

llenar_celda(X) :- member(X, [x, o]). 		% Asigna a X el valor x (pintada) u o (sin pintar) para una celda

extraerBloques([], []).						% Caso Base: Sin celdas = Sin bloques
extraerBloques([o|T], Bloques) :-			% Si encontramos 'o':
	extraerBloques(T, Bloques).				% Sino, ignora 'o' y sigue
extraerBloques([x|T], [Largo | Bloques]) :-	% Si encuentra 'x'
	buscarRachasDeX(T, 1, Largo, Resto),	% Cuenta cuantas 'x' hay
	extraerBloques(Resto, Bloques).			% Continua con el resto

% Cuenta x consecutivas
buscarRachasDeX([x|T], Contador, N, Resto) :-			% Si hay 'x'
	C1 is Contador + 1,									% Cuenta el resto recursivamente
	buscarRachasDeX(T, C1, N, Resto).
buscarRachasDeX(Resto, Contador, Contador, Resto) :-	% Corta en 'o' -> Largo = 0
	(Resto = []; Resto = [o|_]).						% Corta al final -> Largo = 0

% Valida que se cumpla la restriccion dada en cada bloque obtenido
validar_restriccion(Restricciones, Celdas) :-
	extraerBloques(Celdas, Bloques),		% Extrae bloques de Celdas
	Bloques = Restricciones.				% Los bloques deben ser iguales a Restricciones

% Pinta una celda solo si todos los valores en la columna son iguales
pintar_celda_obligatoria(Celda, Valores) :-
	msort(Valores, [Valor]), !,
	Celda = Valor.
pintar_celda_obligatoria(_, _).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              %
%    Ejemplos de nonogramas    %
%        NO MODIFICAR          %
%    pero se pueden agregar    %
%                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fáciles
nn(0, NN) :- armarNono([[1],[2]],[[],[2],[1]], NN).
nn(1, NN) :- armarNono([[4],[2,1],[2,1],[1,1],[1]],[[4],[3],[1],[2],[3]], NN).
nn(2, NN) :- armarNono([[4],[3,1],[1,1],[1],[1,1]],[[4],[2],[2],[1],[3,1]], NN).
nn(3, NN) :- armarNono([[2,1],[4],[3,1],[3],[3,3],[2,1],[2,1],[4],[4,4],[4,2]], [[1,2,1],[1,1,2,2],[2,3],[1,3,3],[1,1,1,1],[2,1,1],[1,1,2],[2,1,1,2],[1,1,1],[1]], NN).
nn(4, NN) :- armarNono([[1, 1], [5], [5], [3], [1]], [[2], [4], [4], [4], [2]], NN).
nn(5, NN) :- armarNono([[], [1, 1], [], [1, 1], [3]], [[1], [1, 1], [1], [1, 1], [1]], NN).
nn(6, NN) :- armarNono([[5], [1], [1], [1], [5]], [[1, 1], [2, 2], [1, 1, 1], [1, 1], [1, 1]], NN).
nn(7, NN) :- armarNono([[1, 1], [4], [1, 3, 1], [5, 1], [3, 2], [4, 2], [5, 1], [6, 1], [2, 3, 2], [2, 6]], [[2, 1], [1, 2, 3], [9], [7, 1], [4, 5], [5], [4], [2, 1], [1, 2, 2], [4]], NN).
nn(8, NN) :- armarNono([[5], [1, 1], [1, 1, 1], [5], [7], [8, 1], [1, 8], [1, 7], [2, 5], [7]], [[4], [2, 2, 2], [1, 4, 1], [1, 5, 1], [1, 8], [1, 7], [1, 7], [2, 6], [3], [3]], NN).
nn(9, NN) :- armarNono([[4], [1, 3], [2, 2], [1, 1, 1], [3]], [[3], [1, 1, 1], [2, 2], [3, 1], [4]], NN).
nn(10, NN) :- armarNono([[1], [1], [1], [1, 1], [1, 1]], [[1, 1], [1, 1], [1], [1], [ 1]], NN).
nn(11, NN) :- armarNono([[1, 1, 1, 1], [3, 3], [1, 1], [1, 1, 1, 1], [8], [6], [10], [6], [2, 4, 2], [1, 1]], [[2, 1, 2], [4, 1, 1], [2, 4], [6], [5], [5], [6], [2, 4], [4, 1, 1], [2, 1, 2]], NN).
nn(12, NN) :- armarNono([[9], [1, 1, 1, 1], [10], [2, 1, 1], [1, 1, 1, 1], [1, 10], [1, 1, 1], [1, 1, 1], [1, 1, 1, 1, 1], [1, 9], [1, 2, 1, 1, 2], [2, 1, 1, 1, 1], [2, 1, 3, 1], [3, 1], [10]], [[], [9], [2, 2], [3, 1, 2], [1, 2, 1, 2], [3, 11], [1, 1, 1, 2, 1], [1, 1, 1, 1, 1, 1], [3, 1, 3, 1, 1], [1, 1, 1, 1, 1, 1], [1, 1, 1, 3, 1, 1], [3, 1, 1, 1, 1], [1, 1, 2, 1], [11], []], NN).
nn(13, NN) :- armarNono([[2], [1,1], [1,1], [1,1], [1], [], [2], [1,1], [1,1], [1,1], [1]], [[1], [1,3], [3,1,1], [1,1,3], [3]], NN).
nn(14, NN) :- armarNono([[1,1], [1,1], [1,1], [2]], [[2], [1,1], [1,1], [1,1]], NN).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              %
%    Predicados auxiliares     %
%        NO MODIFICAR          %
%                              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%! completar(+S)
%
% Indica que se debe completar el predicado. Siempre falla.
completar(S) :- write("COMPLETAR: "), write(S), nl, fail.

%! mostrarNono(+NN)
%
% Muestra una estructura nono(...) en pantalla
% Las celdas x (pintadas) se muestran como ██.
% Las o (no pintasdas) se muestran como ░░.
% Las no instanciadas se muestran como ¿?.
mostrarNono(nono(M,_)) :- mostrarMatriz(M).

%! mostrarMatriz(+M)
%
% Muestra una matriz. Solo funciona si las celdas
% son valores x, o, o no instanciados.
mostrarMatriz(M) :-
	M = [F|_], length(F, Cols),
	mostrarBorde('╔',Cols,'╗'),
	maplist(mostrarFila, M),
	mostrarBorde('╚',Cols,'╝').

mostrarBorde(I,N,F) :-
	write(I),
	stringRepeat('══', N, S),
	write(S),
	write(F),
	nl.

stringRepeat(_, 0, '').
stringRepeat(Str, N, R) :- N > 0, Nm1 is N - 1, stringRepeat(Str, Nm1, Rm1), string_concat(Str, Rm1, R).

%! mostrarFila(+M)
%
% Muestra una lista (fila o columna). Solo funciona si las celdas
% son valores x, o, o no instanciados.
mostrarFila(Fila) :-
	write('║'),
	maplist(mostrarCelda, Fila),
	write('║'),
	nl.

mostrarCelda(C) :- nonvar(C), C = x, write('██').
mostrarCelda(C) :- nonvar(C), C = o, write('░░').
mostrarCelda(C) :- var(C), write('¿?').