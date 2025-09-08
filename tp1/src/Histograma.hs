-- | Un `Histograma` es una estructura de datos que permite contar cuántos valores hay en cada rango.
-- @vacio n (a, b)@ devuelve un histograma vacío con n+2 casilleros:
--
-- * @(-inf, a)@
-- * @[a, a + tamIntervalo)@
-- * @[a + tamIntervalo, a + 2*tamIntervalo)@
-- * ...
-- * @[b - tamIntervalo, b)@
-- * @[b, +inf)@
--
-- `vacio`, `agregar` e `histograma` se usan para construir un histograma.
module Histograma
  ( Histograma, -- No se exportan los constructores
    vacio,
    agregar,
    histograma,
    Casillero (..),
    casMinimo,
    casMaximo,
    casCantidad,
    casPorcentaje,
    casilleros,
  )
where

import Util
import Data.List (zipWith4)

data Histograma = Histograma Float Float [Int]
  deriving (Show, Eq)

-- | Inicializa un histograma vacío con @n@ casilleros para representar
-- valores en el rango y 2 casilleros adicionales para los valores fuera del rango.
-- Require que @l < u@ y @n >= 1@.
vacio :: Int -> (Float, Float) -> Histograma
vacio n (l, u) = Histograma l u ([0] ++ replicate n 0 ++ [0])

-- replicate toma un elemento y un multiplicador n -> devuelve una lista que contiene ese elemento n veces
-- Generamos una lista que toma Inf- ++ cantidad total de rangos que queremos ++ Inf+ -> Todos inicializados en 0

{- =========== Ejemplos de uso de vacio ===========
  ghci> vacio 3 (3.0,5.0)
    Histograma 3.0 5.0 [0,0,0,0,0]

  ghci> vacio 8 (1.0, 7.0)
    Histograma 1.0 7.0 [0,0,0,0,0,0,0,0,0,0]

  ghci> vacio 0 (3.0, 5.0)
    Histograma 3.0 5.0 [0,0]

-}

-- | Agrega un valor al histograma.
agregar :: Float -> Histograma -> Histograma
agregar x (Histograma l u ls)
  | x < l = Histograma l u (actualizarElem 0 (+1) ls)
  | x >= (l + u * fromIntegral (length ls - 2)) = Histograma l u (actualizarElem (length ls -1) (+1) ls)
  | otherwise = Histograma l u (actualizarElem  (floor ((x - l) / u) + 1) (+1) ls)

  -- Caso elem entre (-inf, l)                    -> +1 a la primer posicion
  -- Caso elem entre (ultima pos finita, +inf))   -> +1 a la ultima posicion
  -- Caso elem > l y < ultima pos finita          -> +1 a las posiciones del medio

{- =========== Ejemplos de uso de agregar ===========
  ghci> agregar 6.0 (Histograma 3.0 5.0 [0,0,0,0])
    Histograma 3.0 5.0 [0,1,0,0]

  ghci> agregar 2.0 (Histograma 3.0 5.0 [0,0,0,0])
    Histograma 3.0 5.0 [1,0,0,0]

  ghci> agregar 7.0 (Histograma 3.0 5.0 [0,0,0,0])
    Histograma 3.0 5.0 [0,1,0,0]

  ghci> agregar 1800.0 (Histograma 3.0 5.0 [0,0,0,0])
    Histograma 3.0 5.0 [0,0,0,1]
-}

-- | Arma un histograma a partir de una lista de números reales con la cantidad de casilleros y rango indicados.
histograma :: Int -> (Float, Float) -> [Float] -> Histograma
histograma n r = foldl (\acc x -> agregar x acc) (vacio n r)

{-
  acc = Histograma -> al inicio comienza vacio -> (vacio n (fst r, snd r))
  x = cada elemento de xs
    - Vamos modificando acc con agregar x acc -> +1 a cada posicion a medida que recorremos xs
    - Devolvemos un nuevo acc (nuevo Histograma) modificado por el agregar x acc

=========== Ejemplos de uso de histograma ===========
  ghci> histograma 5 (3.0,5.0) [-5, 2, 7, 20, 60000]
    Histograma 3.0 5.0 [2,1,0,0,1,0,1]

  ghci> histograma 5 (3.0,5.0) [-5, 2, 1, 0, 600000, 7000000, 200000, 50000]
    Histograma 3.0 5.0 [4,0,0,0,0,0,4]

  ghci> histograma 5 (0.0, 5.0) [0,5,10,15,20]
    Histograma 0.0 5.0 [0,1,1,1,1,1,0]
-}

-- | Un `Casillero` representa un casillero del histograma con sus límites, cantidad y porcentaje.
-- Invariante: Sea @Casillero m1 m2 c p@ entonces @m1 < m2@, @c >= 0@, @0 <= p <= 100@
data Casillero = Casillero Float Float Int Float
  deriving (Show, Eq)

-- | Mínimo valor del casillero (el límite inferior puede ser @-inf@)
casMinimo :: Casillero -> Float
casMinimo (Casillero m _ _ _) = m

-- | Máximo valor del casillero (el límite superior puede ser @+inf@)
casMaximo :: Casillero -> Float
casMaximo (Casillero _ m _ _) = m

-- | Cantidad de valores en el casillero. Es un entero @>= 0@.
casCantidad :: Casillero -> Int
casCantidad (Casillero _ _ c _) = c

-- | Porcentaje de valores en el casillero respecto al total de valores en el histograma. Va de 0 a 100.
casPorcentaje :: Casillero -> Float
casPorcentaje (Casillero _ _ _ p) = p

-- | Dado un histograma, devuelve la lista de casilleros con sus límites, cantidad y porcentaje.
casilleros :: Histograma -> [Casillero]
casilleros (Histograma inicio tamaño cantidades) = 
  zipWith4 Casillero limInf limSup cantidades porcentajes

  where
    nCasilleros = length cantidades - 2                   -- Total de casilleros sin -inf y +inf
    tamIntervalo = tamaño / fromIntegral nCasilleros      -- Tamano de cada intervalo sin infinitos
    
    limInf = (-1/0) : límitesNormales                                                     -- Lista de límites inferiores
    limSup = tail límitesNormales ++ [1/0]                                                -- Lista de límites superiores
    límitesNormales = map (\i -> inicio + fromIntegral i * tamIntervalo) [0..nCasilleros] -- Puntos de corte
               
    total = fromIntegral (sum cantidades)                                         -- Total de valores en el Histograma
    calcularPorcentaje c = if total == 0 then 0 else fromIntegral c / total * 100 -- Convierto cantidad a porcentaje
    porcentajes = map calcularPorcentaje cantidades                               -- Calculo de porcentaje a cada cantidad