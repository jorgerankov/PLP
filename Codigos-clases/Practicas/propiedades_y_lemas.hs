{- 
- intercambiar (x,y) = (y,x)                    - asociarD ((x,y),z)) = (x,(y,z)) 

- espejar (Left x) = Right x                    - flip f x y = f y x
  espejar (Right x) = Left x                    - curry f x y = f (x,y)

- asociarI (x,(y,z)) = ((x,y),z)                - uncurry f (x,y) = f x y                 


length :: [a] -> Int                                    (++) :: [a] -> [a] -> [a]
    {L0} length [] = 0                                      {++0} [] ++ ys = ys
    {L1} length (x:xs) = 1 + length xs                      {++1} (x:xs) ++ ys = x : (xs ++ ys)


duplicar :: [a] -> [a]                                  append :: [a] -> [a] -> [a]
    {D0} duplicar [] = []                                   {A0} append xs ys = foldr (:) ys xs
    {D1} duplicar (x:xs) = x : x : duplicar xs          


reverse :: [a] -> [a]                                   map :: (a -> b) -> [a] -> [b]
    {R0} reverse = foldl (flip (:)) []                      {M0} map f [] = []
                                                            {M1} map f (x:xs) = f x : map f xs


filter :: (a -> Bool) -> [a] -> [a]
    {F0} filter p [] = []
    {F1} filter p (x:xs) = if p x then x : filter p xs else filter p xs


elem :: Eq a => a -> [a] -> Bool                        foldr :: (a -> b -> b) -> b -> [a] -> b
    {E0} elem e [] = False                                  {FR0} foldr f z [] = z
    {E1} elem e (x:xs) = (e == x) || elem e xs              {FR1} foldr f z (x:xs) = f x (foldr f z xs)


reverse :: [a] -> [a]
    {R0} reverse [] = []
    {R1} reverse (x:xs) = reverse xs ++ [x]



                            ================== Ejercicio 6 ==================

    zip :: [a] -> [b] -> [(a,b)]
{Z0} zip = foldr (\x rec ys ->
                    if null ys
                        then []
                        else (x, head ys) : rec (tail ys))
                (const [])


    zip' :: [a] -> [b] -> [(a,b)]
{Z'0} zip' [] ys = []
{Z'1} zip' (x:xs) ys = if null ys then [] else (x, head ys):zip' xs (tail ys)



                            ================== Ejercicio 7 ==================

nub :: Eq a => [a] -> [a]
    {N0} nub [] = []
    {N1} nub (x:xs) = x : filter (\y -> x /= y) (nub xs)

union :: Eq a => [a] -> [a] -> [a]
    {U0} union xs ys = nub (xs++ys)

intersect :: Eq a => [a] -> [a] -> [a]
    {I0} intersect xs ys = filter (\e -> elem e ys) xs

{CONGRUENCIA ==} ∀ x::a . ∀ y::a . ∀ f::a->b . (a == b ⇒ f a == f b)

 -}

intersect :: Eq a => [a] -> [a] -> [a]
intersect xs ys = filter (\e -> elem e ys) xs