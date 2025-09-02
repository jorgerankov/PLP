-- pasaje de binario a decimal
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use foldl" #-}


bin2dec :: [Int] -> Int
bin2dec = foldl (\ac b -> b + 2 * ac) 0

--Reverse con acumulador.
reverseC :: [a] -> [a] -> [a]
reverseC ac [] = ac
reverseC ac (x : xs) = reverseC (x : ac) xs
