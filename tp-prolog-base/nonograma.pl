% Ejercicio 1

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

% Ejercicio 2
replicar(X, N, L) :-
	length(L, N),					% Crea lista L de N variables
	maplist(asignar_valor(X), L).	% Relaciona cada elemento de L con X
									% Lo que unifica cada valor con X en cada posicion de L

% Ejercicio 3
transponer(_, _) :- 
	M = [_ | _],					% Valida que M no sea vacío
	M = [FilaActual | _],			% Extrae la primer fila a analizar de la matriz
	length(FilaActual, CantCols),	% Cuenta la #columnas que tiene la fila
	findall(						% Toma todas las columnas
		Col,						% Y las define como Col
		(between(1, CantCols, C),	% Itera sobre todas las columnas C
		maplist(nth1(C), M, Col)),	% Obtiene la columna C-ésima de M 
		MT							% Retorna MT = lista de columnas = transpuesta
	).

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
	length(Celdas, N),							% N = número de celdas
	findall(CeldasPintadas,						% Busca todas las posibles combinaciones
		(	
			llenar_n_celdas(N, CeldasPintadas),					% Genera combinación con x/o
			validar_restriccion(Restricciones, CeldasPintadas)	% Verifica que cumpla la restricción
		),
		SolucionesRestringidas		% Guarda todas las soluciones encontradas (Las que cumplan las restricciones)
	),
	sort(SolucionesRestringidas, Soluciones),	% Elimina duplicados
	member(Celdas, Soluciones).					% Unifica Celdas con c/ solución 

% Ejercicio 5
resolverNaive(_) :-  completar("Ejercicio 5").

% Ejercicio 6
pintarObligatorias(_) :- completar("Ejercicio 6").

% Predicado dado combinarCelda/3
combinarCelda(A, B, _) :- var(A), var(B).
combinarCelda(A, B, _) :- nonvar(A), var(B).
combinarCelda(A, B, _) :- var(A), nonvar(B).
combinarCelda(A, B, A) :- nonvar(A), nonvar(B), A = B.
combinarCelda(A, B, _) :- nonvar(A), nonvar(B), A \== B.

% Ejercicio 7
deducir1Pasada(_) :- completar("Ejercicio 7").

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
restriccionConMenosLibres(_, _) :- completar("Ejercicio 8").

% Ejercicio 9
resolverDeduciendo(NN) :- completar("Ejercicio 9").

% Ejercicio 10
solucionUnica(NN) :- completar("Ejercicio 10").



% ====== Funciones Auxiliares ======
asignar_valor(X, X).						% Asigna un valor X en el lugar de otro ya existente

asignar_lista(C, Fila) :- length(Fila, C).	% Asigna los valores de C a una lista

matriz(F, C, M) :-
    length(M, F),							% Crea una lista M de longitud F (con variables sin asignar)
    maplist(asignar_lista(C), M).			% Asigna los C valores a cada elemento de M

llenar_celda(X) :- member(X, [x, o]). 		% Asigna a X el valor x (pintada) u o (sin pintar) para una celda

% Llenar N celdas con x/o recursivamente
llenar_n_celdas(0, []) :- !.				% CB, 0 celdas = lista vacía
llenar_n_celdas(N, [Celda | Resto]) :-
	N > 0,									% N debe ser positivo
	N1 is N - 1,							% Decrementa N en 1
	llenar_celda(Celda),					% Asigna x u o a Celda
	llenar_n_celdas(N1, Resto).				% Recursión con N-1

% Se extraen bloques de forma recursiva
extraer_bloques([], []) :- !.				% CB: Sin celdas = Sin bloques
extraer_bloques([o | Resto], Bloques) :-	% Si encontramos 'o':
	!,										% Corta el predicado
	extraer_bloques(Resto, Bloques).		% Sino, ignora 'o' y sigue
extraer_bloques([x | Resto], [Largo | BloquesResto]) :-	% Si encuentra 'x'
	contar_xs([x | Resto], Largo, RestoSinBloque),		% Cuenta cuantas 'x' hay
	extraer_bloques(RestoSinBloque, BloquesResto).		% Continua con el resto

% Cuenta x consecutivas
contar_xs([x | Resto], Largo, RestoFinal) :-	% Si hay 'x'
	contar_xs(Resto, LargoResto, RestoFinal),	% Cuenta el resto recursivamente
	Largo is LargoResto + 1.					% +1 al total de elems encontrados
contar_xs([o | Resto], 0, [o | Resto]) :- !.	% Corta en 'o' -> Largo = 0
contar_xs([], 0, []) :- !.						% Corta al final -> Largo = 0

% Valida que se cumpla la restriccion dada en cada bloque obtenido
validar_restriccion(Restricciones, Celdas) :-
	extraer_bloques(Celdas, Bloques),		% Extrae bloques de Celdas
	Bloques = Restricciones.				% Los bloques deben ser iguales a Restricciones

% Para eliminar duplicados, usamos el predicado de Prolog "sort".

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
