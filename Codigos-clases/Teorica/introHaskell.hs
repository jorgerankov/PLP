{-
======== Creación y escritura de funciones ========

En Haskell, una función se define usando el siguiente formato:

nombreFuncion :: TipoDeEntrada -> TipoDeSalida
nombreFuncion parametros = expresión

Por ejemplo, una función que suma dos números:

sumar :: Int -> Int -> Int
sumar x y = x + y

sumar es el nombre de la función.
Int -> Int -> Int indica que toma dos enteros y devuelve un entero.
sumar x y = x + y es la implementación.

======== Uso de funciones en consola ========
Para probar funciones en Haskell, usar el intérprete GHCi. Para abrirlo, ejecutar en la terminal: ghci

Luego, cargar el archivo y probar funciones:
:l factorial.hs   # Carga el archivo
sumar 3 5         # Llama a la función sumar con 3 y 5

======== Manejo de Listas ========

    Recorrer una lista:

    sumListRec :: [Int] -> Int
    sumListRec []     = 0
    sumListRec (x:xs) = x + sumListRec xs

    con foldl:

    sumListFold :: [Int] -> Int
    sumListFold = foldl (+) 0

====== Otras Observaciones ======

    *   3+4 is the same as (+) 3 4
        div 3 4 is the same as 3 `div` 4

    *   The symbol % is used to separate the numerator and denominator of a rational number.

    * Use x for things, xs for lists of things, and xss for lists of lists of things

    *   If we need a function that adds 1 to a number, or doubles a number,
        then we might choose to name such functions explicitly:
            succ, double :: Integer -> Integer
            succ n = n+1
            double n = 2*n

    *   Type classes:
            (+) :: Num a => a -> a -> a
        This declaration asserts that (+) is of type a -> a -> a for any number type a

    *   ghci> "Hello ++"\n"++ "young" ++"\n"++ "lovers"
            "Hello\nyoung\nlovers"

        ghci> putStrLn ("Hello ++"\n"++ "young" ++"\n"++ "lovers")
            Hello
            young
            lovers

    *   The standard prelude functions fst and snd return the first and second components of a pair:
            fst :: (a,b) -> a
            fst (x,y) = x

            snd :: (a,b) -> b
            snd (x,y) = y
-}

-- ======= Ejercicios de las diapositivas =======
-- Funcion sumar int a todos los elems de una Lista
sumaN :: Int -> [Int] -> [Int]
sumaN n [] = []
sumaN n (x : xs) = (x + n) : sumaN n xs

-- Funcion aparece T en lista de Ts
apareceElem :: (Eq a) => a -> [a] -> Bool
apareceElem c [] = False
apareceElem c (cs : s) = c == cs || apareceElem c s

-- Funcion ordenar una lista de Floats
ordenar :: [Float] -> [Float]
ordenar [] = []
ordenar [x] = [x]
ordenar (x : y : xs) = encontrarMenor (x : y : xs) : ordenar (eliminarElemDeLista (x : y : xs) (encontrarMenor (x : y : xs)))

encontrarMenor :: [Float] -> Float
encontrarMenor [] = 0.0
encontrarMenor [m] = m
encontrarMenor (m : n : ms) = if m > n then encontrarMenor (n : ms) else encontrarMenor (m : ms)

eliminarElemDeLista :: [Float] -> Float -> [Float]
eliminarElemDeLista [] m = []
eliminarElemDeLista [n] m = if n == m then [] else [n]
eliminarElemDeLista (n : ns) m
  | n /= m = n : eliminarElemDeLista ns m
  | otherwise = eliminarElemDeLista ns m

-- ====== Ejercicio: desplazar coordenadas ======
type Coordenada = (Int, Int)

data Direccion
  = Norte
  | Este
  | Sur
  | Oeste
  deriving (Show)

{-
Coordenadas se representan como (latitud, longitud):
Norte -> (1,0)
Este -> (0,1)
Sur -> (-1,0)
Oeste -> (0, -1)
-}

desplazar :: Coordenada -> Direccion -> Coordenada
desplazar c Norte = (fst c + 1, snd c)
desplazar c Este = (fst c, snd c + 1)
desplazar c Sur = (fst c - 1, snd c)
desplazar c Oeste = (fst c, snd c - 1)

opuesta :: Direccion -> Direccion
opuesta Norte = Sur
opuesta Sur = Norte
opuesta Este = Oeste
opuesta Oeste = Este

-- Ejercicio 1
{-
null:
    Tipo: [a] -> Bool
    Comportamiento: Returns True if a list is empty, otherwise False

head:
    Tipo: [a] -> a
    Comportamiento: returns the first item of a list

tail:
    Tipo: [a] -> [a]
    Comportamiento: it accepts a list and returns the list without its first item

init
    Tipo: [a] -> [a]
    Comportamiento: it accepts a list and returns the list without its last item

last
    T: [a] -> a
    C: returns the last item of a list

take
    T: Int -> [a] -> [a]
    C: creates a list, the first argument determines, how many items should be taken from the list passed as the second argument

drop
    T: Int -> [a] -> [a]
    C: elimina los primeros n elementos de una lista y devuelve el resto. Si n > Lista -> []

(++)
    T: [a] -> [a] -> [a]
    C: Concatena dos listas pasadas como parametro

concat
    T: [[a]] -> [a]
    C: Toma una lista de listas y las une en una sola lista

reverse
    T: [a] -> [a]
    C: Devuelve una lista con sus elementos en orden invertido

elem
    T: a -> [a] -> Bool
    C: Verifica que un elemento pertenece a una lista
-}

-- Ejercicio 2
-- a)
valorAbsoluto :: Float -> Float
valorAbsoluto = abs

-- b)
bisiesto :: Int -> Bool
bisiesto n
  | n `mod` 4 == 0 && n `mod` 100 == 0 && (n `mod` 400 /= 0) = False
  | n `mod` 4 == 0 || (n `mod` 4 == 0 && n `mod` 100 == 0 && n `mod` 400 == 0) = True
  | otherwise = False

-- c)
factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)

-- d)
cantDivisoresPrimos :: Int -> Int
cantDivisoresPrimos n
  | n <= 1 = 0
  | esPrimo n = 0
  | otherwise = 0

esPrimo :: Int -> Bool
esPrimo n
  | n <= 1 = False
  | otherwise = not (esDivisible n 2)

esDivisible :: Int -> Int -> Bool
esDivisible n m
  | m >= n = False
  | n `mod` m == 0 = True
  | otherwise = esDivisible n (m + 1)

-- Ejercicio 3
-- a)
inverso :: Float -> Maybe Float
inverso 0 = Nothing
inverso n = Just (1 / n)

-- b)
aEntero :: Either Int Bool -> Int
aEntero (Left n) = n
aEntero (Right True) = 1
aEntero (Right False) = 0

-- Ejemplos de uso:
-- aEntero (Right True)   -- 1
-- aEntero (Right False)  -- 0
-- aEntero (Left 42)      -- 42

-- Ejercicio 4
-- a)
limpiar :: String -> String -> String
limpiar "" n = n
limpiar n "" = ""
limpiar (n : ns) (m : ms)
  | elem m (n : ns) = limpiar (n : ns) ms
  | otherwise = m : limpiar (n : ns) ms

-- b)
difPromedio :: [Float] -> [Float]
difPromedio xs = difPromedioAux xs (promedio xs)

difPromedioAux :: [Float] -> Float -> [Float]
difPromedioAux [] x = []
difPromedioAux (x : xs) promedio = (x - promedio) : difPromedioAux xs promedio

promedio :: [Float] -> Float
promedio [] = 0
promedio [n] = n
promedio xs = sumarLista xs / totalEnLista xs

sumarLista :: [Float] -> Float
sumarLista [] = 0
sumarLista (n : ns) = n + sumarLista ns

totalEnLista :: [Float] -> Float
totalEnLista [] = 0
totalEnLista (n : ns) = 1 + totalEnLista ns

-- c)
todosIguales :: [Int] -> Bool
todosIguales xs = todosIgualesAux xs (primerElemLista xs)

todosIgualesAux :: [Int] -> Int -> Bool
todosIgualesAux [] _ = True
todosIgualesAux (x : xs) y
  | x == y = todosIgualesAux xs y
  | otherwise = False

primerElemLista :: [Int] -> Int
primerElemLista = head

eliminarPrimeroYAgregarFinal :: [Int] -> Int -> [Int]
eliminarPrimeroYAgregarFinal [] _ = []
eliminarPrimeroYAgregarFinal [m] n = [n]
eliminarPrimeroYAgregarFinal xs n = n : tail xs

ultimoIndiceDe :: (Eq a) => a -> [a] -> Int
ultimoIndiceDe a xs = buscarUltimo xs 0 (-1)
  where
    {-
        La función auxiliar buscarUltimo recorre la lista con un índice acumulador i.
        Si encuentra el elemento (y == a), actualiza el valor de ultimo con el índice actual i.
        Si no lo encuentra, continúa buscando en el resto de la lista.
        Devuelve el último índice encontrado o -1 si no se encuentra
    -}
    buscarUltimo [] _ ultimo = ultimo
    buscarUltimo (y : ys) i ultimo
      | y == a = buscarUltimo ys (i + 1) i
      | otherwise = buscarUltimo ys (i + 1) ultimo

-- ======= Ejercicio operatoria =======
operatoria :: (a -> a -> a) -> [a] -> a
operatoria op [x] = x
operatoria op (x : xs) = op x (operatoria op xs)

sumatoria :: (Num x) => [x] -> x
sumatoria [x] = x
sumatoria (x : xs)
  | null xs = x
  | otherwise = x + sumatoria xs

productoria :: (Num x) => [x] -> x
productoria [x] = x
productoria (x : xs)
  | null xs = x
  | otherwise = x * productoria xs

--- ===== Buscar maximo en Lista =====
maximo :: [Int] -> Int
maximo [x] = x
maximo (x : xs)
  | x > maximo xs = x
  | otherwise = maximo xs

-- === V2 ===
maximo2 :: [Int] -> Int
maximo2 [x] = x
maximo2 (x : xs) = case xs of
  (y : ys) -> if x > maximo (y : ys) then x else maximo (y : ys)

-- === v3 ===
maximo3 :: [Int] -> Int
maximo3 (x : xs) =
  case xs of
    [] -> x
    (y : ys) -> if x > m then x else m
  where
    m = maximo3 xs

--- ===== Buscar maximo aunque haya una Lista vacia =====
maximoConListaVacia :: [Int] -> Int
maximoConListaVacia [] = 0
maximoConListaVacia (x : xs) = max x (maximo xs)

-- ====== Ejercicio minimo ======
minimo :: [Int] -> Int
minimo (x : xs) =
  case xs of
    [] -> x
    (y : ys) -> if x < m then x else m
  where
    m = minimo xs

-- ===== Ejercicio Lista mas corta =====
listaMasCorta :: [[a]] -> [a]
listaMasCorta (x : xs) =
  case xs of
    [] -> []
    y : ys ->
      if length xs < length l
        then x
        else l
  where
    l = listaMasCorta xs

-- ====== Ejercicio mientras ======

resultado = 2 * 10

-- ====== Unir 2 listas (append)======
append :: [a] -> [a] -> [a]
append [] lista2 = lista2
append (x : xs) lista2 = x : (append xs lista2)

-- ====== Sin repetidos ======
-- Eq a ===== Define a los Tipos que pueden ser comparado entre si (Int, Char, etc)

sinRepetidos :: (Eq a) => [a] -> [a]
sinRepetidos [] = []
sinRepetidos (x : xs) = if pertenece x xs then sinRepetidos xs else x : sinRepetidos xs

pertenece :: (Eq a) => a -> [a] -> Bool
pertenece x [] = False
pertenece x (y : ys) = x == y || pertenece x ys

-- ===== Incluida -> True si todo elem de la primer lista aparecen en la segunda =====
incluida :: (Eq a) => [a] -> [a] -> Bool
incluida xs [] = False
incluida [] xs = True
incluida (x : xs) ys = pertenece x ys && incluida xs ys

-- ===== Diferencia = Toma 2 Listas -> Devuelve una Lista que tenga los elementos de la primera
--       que no aparecen en la segunda =====
diferencia :: (Eq a) => [a] -> [a] -> [a]
diferencia [] xs = []
diferencia (x : xs) ys
  | pertenece x ys = diferencia xs ys
  | otherwise = x : diferencia xs ys

-- ===== Sufijos => Toma una Lista y devuelve una lista de listas de sus sufijos=====
sufijos :: [a] -> [[a]]
sufijos [] = [[]]
sufijos xs = xs : sufijos (tail xs)

-- Otra version de sufijos
sufijosV2 :: [a] -> [[a]]
sufijosV2 [] = [[]]
sufijosV2 (x : xs) = (x : xs) : sufijosV2 xs

prefijos :: [a] -> [[a]]
prefijos [] = [[]]
prefijos xs = tail xs : prefijos (tail xs)

-- =============================== Tipos Algebraicos ===============================

-- nroAnimales => Dada una lista de Origen devuelve cuantas veces aparece Animal
data Origen = Animal | Vegetal | Mineral
  deriving (Show)

nroAnimales :: [Origen] -> Int
nroAnimales [] = 0
nroAnimales (x : xs)
  | esAnimal x = 1 + nroAnimales xs
  | otherwise = nroAnimales xs

esAnimal :: Origen -> Bool
esAnimal Animal = True
esAnimal Vegetal = False
esAnimal Mineral = False

-- ===== Tipos Producto (Registros) =====

type Nombre = String

data Ingrediente = MkI Nombre Origen Int
  deriving (Show)

bollo :: Ingrediente
bollo = MkI "Masa de pizza" Vegetal 228

tomate :: Ingrediente
tomate = MkI "Tomate" Vegetal 22

queso :: Ingrediente
queso = MkI "Queso" Animal 245

descripcionI :: Ingrediente -> Nombre
descripcionI (MkI x y z) = x

origenI :: Ingrediente -> Origen
origenI (MkI x y z) = y

caloriasI :: Ingrediente -> Int
caloriasI (MkI x y z) = z

-- ===== Tipos Suma =====
data Fuego = Suave | Moderado | Fuerte
  deriving (Show)

data MetodoCoccion
  = Horno Fuego Int
  | Hervido
  | Frito
  deriving (Show)

demoraMc :: MetodoCoccion -> Int
demoraMc (Horno fuego minutos) = minutos
demoraMc Hervido = 30
demoraMc Frito = 15

-- ======================= Arboles Binarios =======================
data AB a = Nil | Bin (AB a) a (AB a)
  deriving (Show)

-- Esquema de recursion estructural para tipo de datos Arbol
-- f :: Arbol -> ...
-- f Nil   =
-- f (Bin i d) = ... f i ... f d

vacioAB :: AB a -> Bool
vacioAB Nil = True
vacioAB (Bin i a d) = False

-- Precondicion: El arbol no debe ser Nil
hijoIzq :: AB a -> AB a
hijoIzq (Bin i a d) = i

-- Precondicion: El arbol no debe ser Nil
hijoDer :: AB a -> AB a
hijoDer (Bin i a d) = d

cantNodos :: AB a -> Int
cantNodos Nil = 0
cantNodos (Bin i a d) = 1 + cantNodos i + cantNodos d

cantHojas :: AB a -> Int
cantHojas Nil = 0
cantHojas (Bin i a d)
  | vacioAB i && vacioAB d = 1
  | otherwise = cantHojas i + cantHojas d

altura :: AB a -> Int
altura Nil = 0
altura (Bin i a d) = 1 + max (altura i) (altura d)

-- Dado un árbol de booleanos construye otro
-- formado por la negación de cada uno de los nodos
negacionAB :: AB Bool -> AB Bool
negacionAB Nil = Nil
negacionAB (Bin i v d) = Bin (negacionAB i) (not v) (negacionAB d)

-- Calcula el producto de todos los nodos del árbol
productoAB :: AB Int -> Int
productoAB Nil = 1
productoAB (Bin i valor d) = valor * productoAB i * productoAB d


