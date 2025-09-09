module Util where

-- | @alinearDerecha n s@ agrega espacios a la izquierda de @s@ hasta que su longitud sea @n@.
-- Si @s@ ya tiene longitud @>= n@, devuelve @s@.
alinearDerecha :: Int -> String -> String
alinearDerecha 0 s = s
alinearDerecha n s = if length s >= n then s else replicate (n - length s) ' ' ++ s


-- | Dado un índice y una función, actualiza el elemento en la posición del índice
-- aplicando la función al valor actual. Si el índice está fuera de los límites
-- de la lista, devuelve la lista sin cambios.
-- El primer elemento de la lista es el índice 0.
actualizarElem :: Int -> (a -> a) -> [a] -> [a]
actualizarElem n f xs = zipWith (\x i -> if i == n then f x else x) xs [0..]

{-
Es total por construcción:
    - Para cualquier valor de n, f y xs, la función devuelve una lista
    - Si n está fuera del rango de índices de xs no se modifica nada, pero la función sigue devolviendo una lista

No usa recursion explicita:
    - usa zipWith -> función de orden superior que aplica una función a dos listas en paralelo
-}

-- | infinito positivo (Haskell no tiene literal para +infinito)
infinitoPositivo :: Float
infinitoPositivo = 1 / 0

-- | infinito negativo (Haskell no tiene literal para -infinito)
infinitoNegativo :: Float
infinitoNegativo = -(1 / 0)
