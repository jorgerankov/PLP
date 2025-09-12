{-

\x = Funcion anonima = Funcion lambda

Ejemplos:

x -> x + 1
Significa “La función que recibe un parámetro x y devuelve x + 1”.

\x y -> x + y
Significa "La función que toma dos parámetros x e y y devuelve x + y.

-}
-- =========== Ejercicio 1 ===========
-- I)
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Eta reduce" #-}
{-# HLINT ignore "Use sum" #-}
{-# HLINT ignore "Redundant lambda" #-}
{-# HLINT ignore "Evaluate" #-}
{-# HLINT ignore "Avoid lambda using `infix`" #-}
max2 (x, y)
  | x >= y = x
  | otherwise = y

-- max2 :: Ord a => (a, a) -> a

normaVectorial (x, y) = sqrt (x ^ 2 + y ^ 2)

-- normaVectorial :: Floating a => (a, a) -> a

sustraer = flip (-)

-- sustraer :: Integer -> Integer -> Integer

predecesor = sustraer 1

-- predecesor :: Integer -> Integer

evaluarEnCero = \f -> f 0

-- evaluarEnCero :: (Integer -> t) -> t

dosVeces = \f -> f . f

-- dosVeces :: (a -> a) -> a -> a

flipAll = map flip

-- flipAll :: [a -> b -> c] -> [b -> a -> c]

flipRaro = flip flip

-- flipRaro :: b -> (a -> b -> c) -> a -> c

{-
La currificación es una técnica de transformación de funciones
que convierte una función que acepta múltiples argumentos
en una serie de funciones que aceptan un solo argumento cada una,
devolviendo la siguiente función en la cadena
hasta que todos los argumentos hayan sido procesados
-}
-- II)
-- sustraer = flip (-)
-- predecesor = sustraer 1
-- evaluarEnCero = \f -> f 0
-- dosVeces = \f -> f . f
-- flipAll = map flip
-- flipRaro = flip flip

-- =========== Ejercicio 2 ===========
-- curry :: (a, b) -> a -> b
curryficar :: ((a, b) -> c) -> a -> b -> c
curryficar f x y = f (x, y)

-- uncurry :: a -> b -> (a,b)
uncurry :: (a -> b -> c) -> (a, b) -> c
uncurry f (x, y) = f x y

-- =========== Ejercicio 3 ===========
-- I)
sumFoldr :: (Num a) => [a] -> a
sumFoldr xs = foldr (+) 0 xs

elemFoldr e xs = foldr (\x acc -> e == x || acc) False xs

concatFoldr xs ys = foldr (:) xs ys

filterFoldr c = foldr (\x xs -> if c x then x : xs else xs) []

mapFoldr f = foldr ((:) . f) []

-- II)
mejorSegun :: (a -> a -> Bool) -> [a] -> a
mejorSegun cmp = foldr1 (\x y -> if cmp x y then x else y)

mejorSegunPractica :: (a -> a -> Bool) -> [a] -> a
mejorSegunPractica comp (x : xs) =
  case xs of
    [] -> x
    y : ys ->
      if comp x m
        then x
        else m
  where
    m = mejorSegunPractica comp xs


-- III)
sumasParciales :: (Num a) => [a] -> [a]
sumasParciales [] = []
sumasParciales (x : xs) = x : map (+ x) (sumasParciales xs)

-- IV)
sumaAlt :: (Num a) => [a] -> a
sumaAlt = \xs -> foldr (\x g s -> x - g s) id xs 0

-- =========== Ejercicio 4 ===========
-- I)
-- Funcion aux: obtener elemento en posicion i
obtenerEnPos :: Int -> [a] -> a
obtenerEnPos 0 (x:xs) = x
obtenerEnPos i (x:xs) = obtenerEnPos (i-1) xs

-- Funcion aux: obtener lista sin elemento en posicion i
listaSinPosicion :: Int -> [a] -> [a]
listaSinPosicion i xs = take i xs ++ drop (i+1) xs

permutaciones :: [a] -> [[a]]
permutaciones [] = [[]]
permutaciones xs = concatMap procesarIndice [0..length xs - 1]
  where
    procesarIndice i = map (obtenerEnPos i xs :) (permutaciones (listaSinPosicion i xs))

-- II)
partes :: [a] -> [[a]]
partes [] = [[]]
partes (x:xs) = sinX ++ conX
  where
    sinX = partes xs              -- Todas las partes sin x
    conX = map (x :) (partes xs)  -- Todas las partes con x

-- III) REVISAR
prefijos :: [a] -> [[a]]
prefijos [] = [[]]
prefijos xs = tail xs : prefijos (tail xs)


-- ============ Ejercicio 5 ============
-- elementosEnPosicionesPares no es estructural. Con foldr:
elementosEnPosicionesPares :: [a] -> [a]
elementosEnPosicionesPares xs = 
  foldr (\(elem, i) xs -> if even i then elem : xs else xs) [] (zip xs [0..])

-- entrelazar no es estructural. Con foldr:
entrelazar :: [a] -> [a] -> [a]
entrelazar xs ys = 
  foldr (\(x,y) acc -> x : y : acc) (drop (length xs) ys) (zip xs ys)

-- ============ Ejercicio 7 ============
armarPares :: [a] -> [a] -> [(a,a)]
armarPares xs ys = zip xs ys

mapDoble :: (a -> b -> c) -> [a] -> [b] -> [c]
mapDoble f xs ys = zipWith f xs ys


-- ============ Ejercicio 8 ============
sumaMat :: [[Int]] -> [[Int]] -> [[Int]]
sumaMat xs ys = zipWith (zipWith (+)) xs ys
-- zipWith (zipWith (+)) :: [[Int]] -> [[Int]] -> [[Int]]  (aplica la suma de listas a cada par de filas)

--trasponer :: [[Int]] -> [[Int]]
--trasponer xs ys = zipWith (zipWith reverse) xs ys

-- ============ Ejercicio 9 ============
foldNat :: a -> (a -> a) -> Integer -> a
foldNat zero f n
  | n <= 0    = zero
  | otherwise = f (foldNat zero f (n - 1))


{-
Ejemplo con foldNat 1 (*2) 5:

= (*2) (foldNat 1 (*2) 4)      -- Como 5 > 0, aplicamos f a foldNat(..., 4)
= (*2) ((*2) (foldNat 1 (*2) 3))   -- Como 4 > 0, aplicamos f a foldNat(..., 3)
= (*2) ((*2) ((*2) (foldNat 1 (*2) 2)))   -- Como 3 > 0, aplicamos f a foldNat(..., 2)
= (*2) ((*2) ((*2) ((*2) (foldNat 1 (*2) 1))))   -- Como 2 > 0, aplicamos f a foldNat(..., 1)
= (*2) ((*2) ((*2) ((*2) ((*2) (foldNat 1 (*2) 0)))))   -- Como 1 > 0, aplicamos f a foldNat(..., 0)
= (*2) ((*2) ((*2) ((*2) ((*2) 1)))) 
-}

potencia :: Integer -> Integer  
potencia n = foldNat n (^2) 1

-- ============ Ejercicio 10 ============
genLista :: a -> (a -> a) -> Integer -> [a]
genLista inicial f n 
  | n <= 0    = []
  | otherwise = inicial : genLista (f inicial) f (n - 1)


-- ============ Ejercicio 12 ============
data AB a = Nil | Bin (AB a) a (AB a)

-- II)
esNil :: AB a -> Bool
esNil Nil = True
esNil (Bin i a d) = False

altura :: AB a -> Int
altura Nil = 0
altura (Bin i a d) = 1 + max (altura i) (altura d)

cantNodos :: AB a -> Int
cantNodos Nil = 0
cantNodos (Bin i a d) = 1 + cantNodos i + cantNodos d

-- IV)
esABB :: Ord a => AB a -> Bool
esABB Nil = True
esABB (Bin i a d) = todosmenores a i && todosMayores a d && esABB i && esABB d

-- Todos los elems del arbol <= x
todosmenores :: Ord a => a -> AB a -> Bool
todosmenores _ Nil = True
todosmenores x (Bin i a d) = a < x && todosmenores x i && todosmenores x d

-- Todos los elems del arbol > x
todosMayores :: Ord a => a -> AB a -> Bool
todosMayores _ Nil = True
todosMayores x (Bin i a d) = a > x && todosMayores x i && todosMayores x d