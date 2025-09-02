{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Eta reduce" #-}
{-# HLINT ignore "Use map" #-}

infUno :: [Integer]
infUno = 1 : infUno

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

-- ==== Maximo con MejorSegun ====
maximoSegun :: [Int] -> Int
maximoSegun xs = mejorSegunPractica (>) xs

-- ==== Minimo con MejorSegun ====
minimoSegun :: [Int] -> Int
minimoSegun xs = mejorSegunPractica (<) xs

-- ==== listaMasCorta con MejorSegun ====
listaMasCortaSegun :: [[Int]] -> [Int]
listaMasCortaSegun xs = mejorSegunPractica (<) xs

-- ======== Funciones con filter ========
-- ==== deLongitudN ====
deLongitudN :: Int -> [[a]] -> [[a]]
deLongitudN n =
  Prelude.filter (\xs -> length xs == n)

-- === filter((==n).filter)

-- ===== soloPuntosFijosEnN =====
soloPuntosFijosEnN :: Int -> [Int -> Int] -> [Int -> Int]
soloPuntosFijosEnN n =
  Prelude.filter (\f -> n == f n)

-- ========= Funciones con Map =========
-- ===== reverseAnidado =====
reverseAnidado :: [[Char]] -> [[Char]]
reverseAnidado xs = reverse (Prelude.map reverse xs)

-- === reverse.(map reverse)

-- ===== paresCuadrados =====
paresCuadrados :: [Int] -> [Int]
paresCuadrados =
  Prelude.map
    ( \n ->
        if even n
          then n ^ 2
          else n
    )



-- =========== Funcion fold ===========
{-
Un fold reduce una lista a un solo valor combinando elementos con una función y un valor inicial


Tipos:

foldr  :: (a -> b -> b) -> b -> [a] -> b
foldl  :: (b -> a -> b) -> b -> [a] -> b


foldr f z [x1,x2,x3] ≡ x1 f (x2 f (x3 f z)) (asocia a la derecha)
foldl f z [x1,x2,x3] ≡ ((z f x1) f x2) f x3 (asocia a la izquierda)
foldl' :: (b -> a -> b) -> b -> [a] -> b  -- Igual a foldl pero evalúa el acumulador en cada paso

Con operaciones no conmutativas (p. ej. resta) dan resultados distintos



==== map con foldr: ====

map f xs = foldr (\x acc -> f x : acc) [] xs

-- Paso a paso para f = (*2), xs = [1,2,3]
foldr (\x acc -> (x*2):acc) [] [1,2,3]
= (\1 acc -> 2:acc) (foldr ... [2,3])
= 2 : (foldr (\x acc -> (x*2):acc) [] [2,3])
= 2 : (4 : (foldr ... [3]))
= 2 : 4 : (6 : [])
= [2,4,6]


-}

-- ====== filter y map con foldr ======
filter :: (a -> Bool) -> [a] -> [a]
filter p xs = foldr (\x r -> if p x then x : r else r) [] xs

map :: (a -> b) -> [a] -> [b]
map f xs = foldr (\x r -> f x : r) [] xs

--- ====== listaComp con map y filter ======
listaComp :: (a -> Bool) -> (a -> b) -> [a] -> [b]
listaComp p f xs = Prelude.map f (Prelude.filter p xs)

-- === map f . filter p
