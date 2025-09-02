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
