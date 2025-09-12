-- Programación Funcional en Haskell - Demostraciones

{-
===== probar: curry . uncurry = id ===== 

curry :: ((a, b) -> c) -> (a -> b -> c)
{C} curry f = (\x y -> f (x, y))

uncurry :: (a -> b -> c) -> ((a, b) -> c)
{U} uncurry f = (\(x, y) -> f x y)

(.) :: (b -> c) -> (a -> b) -> (a -> c)

{COMP} (f . g) x = f (g x)

id :: a -> a
{I} id x = x

forAll x :: a -> b -> c

curry uncurry x = {Comp}
curry (uncurry x) = {U}
curry (\(x', y') -> x x' y') = {C}
(\x" y" -> (\(x', y') -> x x' y') (x", y")) =(Beta)
= (\x" y" -> x x" y") (\y" -> A y") =(n) A
= (\x" -> \y" -> (x x") y")
=(n) (\x" -> x x")
=(n) x =(I) id x
-}


{-
data Either a b = Left a | Right b

si c es un conjunto y e un elemento, la expresion c e devuelve True si e pertenece a c y False en caso contrario

prod :: Either Int (Int, Int) -> Either Int (Int, Int) -> Either Int (Int, Int)
{P0} prod (Left x) (Left y) = Left (x * y)
{P1} prod (Left x) (Right (y, z)) = Right (x * y, x * z)
{P2} prod (Right (y, z)) (Left x) = Right (y * x, z * x)
{P3} prod (Right (w, x)) (Right (y, z)) = Left (w * y + x * z)

Por Lema de generacion:

- Caso p Left -
    p :: Either Int (Int, Int)
        o bien p = Left x1 con x1 :: Int
        o bien p = Right p1 con p1 :: (Int, Int)

- Caso p Right -
    Como p1 :: (Int, Int) , para algun y1, z1 :: Int tal que p1 = (y1, z1)

- Caso q Left -
    q = Left x2 con x2 :: Int

- Caso q Right -
    q = Right (y2, z2) para algun y2, z2 :: Int 


- Caso p Left, q Left - Caso 1 - prod p q = prod q p
    p = Left x1
    q = Left x2

    prod (Left x1) (Left x2) = prod (Left x2) (Left x1)
        
        (partiendo del lado izquierdo)
        =(P_0) Left (x1 * x2) =(Prop Int) Left (x2 * x1)

        (partiendo del lado derecho)
        =(P_0) prod (Left x2) (Left x1)

- Caso p Left, q Right
    p = Left x1
    q = Right (y2, z2)

    prod (Left x1) (Right (y2, z2)) = prod (Right (y2, z2)) (Left x1) 
        =({P1}) Right (x1 * y2, x1 * z2)
        =(Prop Int) Right (y2 * x1, z2 * x1)
        =({P2}) prod (Right (y2, z2)) (Left x1)

- Caso p Right, q Right
    p = (Right(y1, z1))
    q = (Right(y2, z2))

    prod (Right(y1, z1)) (Right(y2, z2))
    =({P3}) Left (y1 * y2 + z1 * z2)
    =(Prop Int) Left (y2 * y1 + z2 * z1)
    = 


==== Demo Funciones como estructuras de datos ====
    interseccion d (dif c d) = vacio
    b V q por extencionalidad funcional
    forAll x :: a = int d (dif c d) x = vacio x
    (partiendo del lado derecho) 
    vacio x =({V}) (\z -> False) x
            =(Beta) False

    interseccion d (dif c d) x =({I})
        (\e -> d e && (dif c d) e) x =(Beta)
        dx && (dif c d) x = ({D})
        dx && ((\e -> ce && (nat(de)) x) =(Beta)
        dx && (cd && not(dx)) =(Prop. Bool)
        False


==== Induccion Estructural ====

-- Demo de igualdad de lengths:

Veamos que estas dos definiciones de length son equivalentes:
    length1 :: [a] -> Int
    {L10} length1 [] = 0
    {L11} length1 ( :xs) = 1 + length1 xs
    length2 :: [a] -> Int
    {L2} length2 = foldr (\ res -> 1 + res) 0
    Recordemos:
    foldr :: (a -> b -> b) -> b -> [a] -> b
    {F0} foldr f z [] = z
    {F1} foldr f z (x:xs) = f x (foldr f z xs)


    length1 = length2
    por extensionalidad bvq:
    forAll ys :: [a]. length1 ys = lengh2 ys
    P(ys) = length1 ys = length2 ys

    Caso base: ys = []
        Lado izq: length1 [] =({L10}) 0
        Lado der: length2 [] =({L2}) foldr (\_ res -> 1+res) 0 [] =({F0}) 0


    ** Caso inductivo: ys = x:xs
        HI : length1 xs = length2 xs = P(xs)
        TI : P(x:xs)

        Lado izq: length1 (x:xs) =({L11}) 1 + length1 xs =(HI) 1 + length2 xs
        Lado der:   length2 (x:xs) =({L2}) foldr (\_ res -> 1 + res) 0 (x:xs) 
                    =({F1}) (\_ res -> 1 + res) x (foldr (\_ res -> 1 + res) 0 xs) 
                    =({L2}) (\_ res -> 1 + res) x (length2 xs) 
                    =(Beta) (\_ res -> 1 + res) (length2 xs)
                    =(Beta) 1 + length2 xs


-- Demo Eq a y Eq b: --
    ** Caso base: ys = []
        qvq elem e [] => elem (f e) (map f []) =({E0}) False => Vale por logica
    
    ** Caso inductivo: ys = x:xs
        HI = forAll f :: a -> b. forAll e :: a. elem e xs => elem (f e) (map f xs)
        TI (Tesis inductiva) = P (x:xs)

        (partiendo del lado izquierdo)
            elem e (x:xs) =({E1}) || elem e xs
        
        (partiendo del lado derecho)
            (f e) (map f (x:xs)) =({M1}) elem (f e) (f x : map f xs) 
            =({E1}) f e == f x || elem (f e) (map f xs)

        ** Por Lema de Generacion de Bool: e == x es True o False
            * Caso True: 
                por Congruencia, f e == f x = True
                True || ... => True || ... => True, vale por logica
            
            * Caso False: 
                Partiendo por izquierda: False || elem e xs =(Bool) elem e xs
                Por HI: elem e xs => elem (f e) (map f xs)

                Por Bool:
                    forAll x, y, z:: Bool. (x => y) => x => z V y  
                    Entonces elem e xs => f e == f x || elem(f e) (map f xs)


-- Demo "Otra vuelta de tuerca": --
    Caso inductivo: ys = x:xs
        HI: P(xs)
        izq: length (x:xs) =({L1}) 1 + length xs 
            =(HI) 1 + length (foldl (flip(:)) [] xs)

        der: length (foldl (flip(:)) [] (x:xs)) 
            =({F1}) lenth foldl (flip(:)) (flip(:) [] x) xs
            =({FL}) length (foldl (flip(:) (x:[]) xs)
-}

 