{-
                            ========================== Ejercicio 1 ==========================

 

i. ∀ p::(a,b) . intercambiar (intercambiar p) = p

    Por {intercambiar} -> dado p :: (a,b) -> p = (x,y) 
    => intercambiar p => intercambiar (x,y) => p = (y,x)
    Luego, por {intercambiar} -> intercambiar (intercambiar p) 
    => intercambiar p (modificada) => intercambiar (y,x) => p = (x,y) = p
    
    Como queriamos probar



ii. ∀ p::(a,(b,c)) . asociarD (asociarI p) = p 
    
    Por {asociarI} -> dado p::(a,(b,c)) -> p = (x,(y,z))
    => asociarI p => asociarI(x,(y,z)) => p = ((x,y),z)
    Por {asociarD} -> asociarD (asociarI p) = asociarD p
    => asociarD ((x,y),z) => p = (x,(y,z)) = p

    Como queriamos probar



iii. ∀ p::Either a b . espejar (espejar p) = p

    Dado p :: Either a b
    
    Caso Left:
        Por {espejar} => espejar p => espejar (Left p) => espejar a = Right p = b
        Luego, por {espejar} => espejar (espejar p) => espejar (Right p) => Left p = a = p
    
    Caso Right:
        Por {espejar} => espejar p => espejar (Right p) => espejar b = Left p = a
        Luego, por {espejar} => espejar (espejar p) => espejar (Left p) => Right p = b = p

    Luego, por ambos casos, queda demostrado: espejar (espejar p) = p



iv. ∀ f::a->b->c . ∀ x::a . ∀ y::b . flip (flip f) x y = f x y
    
    Por {flip} => flip f = flip a->b->c = b->a->c = f y x
    Por {flip} => flip (flip f) x y => flip f y x = f x y
    
    Como queriamos demostrar



v. ∀ f::a->b->c . ∀ x::a . ∀ y::b . curry (uncurry f) x y = f x y
    ={curry}, (uncurry f) (x,y) ={uncurry}
    f x y, como queriamos probar



                            ========================== Ejercicio 2 ==========================

i. flip . flip = id



ii. ∀ f::(a,b)->c . uncurry (curry f) = f
    Tomo un p :: (a, b), tal que uncurry (curry f) p = f p
    Por {uncurry}, (curry f) (fst p) (snd p) = (curry f) a b
    Por {curry}, f (a, b) => f :: (a,b) -> c, como queriamos demostrar



                            ========================== Ejercicio 3 ==========================


i. ∀ xs::[a] . length (duplicar xs) = 2 * length xs

    Caso base: xs = []
        length (duplicar []) = 2 * length [] ={D0}
        length [] = 2 * length [] ={L0}
        0 = 2 * 0 = 0
    Se cumple el Caso base

    Paso inductivo: xs = y:ys
        HI: Suponemos que length (duplicar ys) = 2 * length ys
        qvq: length (duplicar y:ys)         = 2 * length (y:ys)     ={D1} 
        length (y : y : duplicar ys)    = 2 * length (y:ys)     ={L1}
        1 + length (y : duplicar ys)    = 2 * (1 + length (ys))   ={L1}
        1 + 1 + length (duplicar ys)    = 2 * (1 + length (ys))   =
        2 + length (duplicar ys)        = 2 * (1 + length (ys))   ={HI en lado izq, distributiva en lado der}
        2 + 2 * length ys               = 2 + 2 * length ys       
    Como queriamos demostrar



ii. ∀ xs::[a] . ∀ ys::[a] . length (xs ++ ys) = length xs + length ys

    Caso base: xs = []
        length ([] ++ ys) = length [] + length ys   ={++0}
        length (ys) = length [] + length ys         ={L0}
        length ys = 0 + length ys                   =
        length ys = length ys
    Se cumple el Caso base
    
    Paso inductivo: xs = w:ws
        HI: Supongo que length (w:ws ++ ys) = length w:ws + length ys
        qvq: 
            length (w:ws ++ ys)         ={++1}
            length(w : (ws ++ ys))      ={L1}
            1 + length (ws ++ ys)       ={HI}
            1 + length ws + length ys   ={L1} 
            length w:ws + length ys
    Como queria probar



iii. ∀ xs::[a] . ∀ x::a . [x] ++ xs = x:xs
    Caso base: xs = [], x => [x] ++ [] = x:[]:[] = x:[]
    Se cumple el Caso base

    Paso inductivo: xs = y:ys
        HI: Supongo que ∀ xs::[a] . ∀ x::a . [x] ++ xs = x:xs
        qvq: [x] ++ (y:ys)  = x:(y:ys)
            [x] ++ y:ys     ={++1}
            x:([] ++ y:ys)  ={++0}
            x:(y:ys)
    Como queria probar



iv. ∀ xs::[a] . xs ++ [] = xs
    Caso base: xs = [], [] ++ [] = [] = xs
    Se cumple el Caso base

    Paso inductivo: xs = y:ys
        HI: Supongo ∀ xs::[a] . ys ++ [] = ys
        qvq:    (y:ys) ++ [] = y:ys
                y : (ys ++ []) ={++0}
                y:ys
    Como queria probar



v. ∀ xs::[a] . ∀ ys::[a] . ∀ zs::[a] . (xs ++ ys) ++ zs = xs ++ (ys ++ zs)
    Caso base: xs = []
        ([] ++ ys) ++ zs = [] ++ (ys ++ zs) ={++0}
        ys ++ zs = ys ++ zs
    Se cumple el Caso base

    Paso inductivo: xs = x:xs'
        HI: Asumo que ∀ xs'::[a] . ∀ ys::[a] . ∀ zs::[a] . (xs' ++ ys) ++ zs = xs' ++ (ys ++ zs)
        qvq:    
            (x:xs' ++ ys) ++ zs     ={++1}
            (x : (xs' ++ ys)) ++ zs ={++1}
            x : ((xs' ++ ys) ++ zs) ={HI}
            x : (xs' ++ (ys ++ zs)) =
            x:xs' ++ (ys ++ zs)
    Como queria probar



vi. ∀ xs::[a] . ∀ f::(a->b) . length (map f xs) = length xs
    Caso base: xs = []
        length (map f []) = length [] ={M0}
        length ([]) = length [] ={L0}
        0 = 0
    Se cumple el Caso base

    Paso inductivo: xs = y:ys
        HI: Asumo que ∀ ys::[a] . ∀ f::(a->b) . length (map f ys) = length ys
        qvq:    
            length (map f y:ys)             = length y:ys ={M1}
            length(f y : map f ys)          = length y:ys ={L1}
            1 + length(map f ys)            = length y:ys ={HI}
            1 + length ys                   = length y:ys ={L1}
            length (y:ys)                   = length y:ys
    Como queria probar



vii. ∀ xs::[a] . ∀ p::a->Bool . ∀ e::a . (elem e (filter p xs) => elem e xs) (si vale Eq a)
    
    Caso base: xs = []
        elem e (filter p [])    => elem e [])   = {F0}
        elem e []               => elem e []    ={Bool}
        False                   => False        = True
    Se cumple el Caso base

    Paso inductivo: xs = y:ys
        HI: Asumo que ∀ ys::[a] . ∀ p::a->Bool . ∀ e::a . (elem e (filter p ys) => elem e ys) (si vale Eq a)
        qvq:    elem e (filter p y:ys) ={F1}
                elem e (if p y then y : filter p ys else filter p ys)
                    
                Caso p y = True:
                    elem e (y : filter p ys) ={E1}
                    (e == y) || elem e (filter p ys) ={HI}
                    (e == y) || elem e ys
                        
                        Si (e == y) es True:
                            True || elem e ys = True
                        Si (e == y) es False:
                            False || elem e ys = elem e ys ???


                Caso p y = False:
                    elem e (filter p ys) ={HI}
                    elem e ys ???


                            ========================== Ejercicio 4 ==========================


i. reverse = foldr (\x rec -> rec ++ (x:[])) []



ii. ∀ xs::[a] . ∀ ys::[a] . reverse (xs ++ ys) = reverse ys ++ reverse xs

    Caso base: xs = []
        reverse ([] ++ ys) = reverse ys ++ reverse []   ={++0}
        reverse ys  = reverse ys ++ reverse []          ={R0}
        reverse ys = reverse ys ++ []                   ={++0}
        reverse ys = reverse ys
    Se cumple el Caso base

    Paso inductivo: xs = x:xs'
        HI: Asumo que ∀ xs'::[a] . ∀ ys::[a] . reverse (xs' ++ ys) = reverse ys ++ reverse xs'
        qvq: ∀ xs'::[a] . ∀ ys::[a] . reverse (x:xs' ++ ys) = reverse ys ++ reverse x:xs'
            reverse (x:xs' ++ ys) ={++1}
            reverse (x : (xs' ++ ys)) ={R1}
            reverse (xs' ++ ys) ++ [x] ={Distributiva}
            reverse xs' ++ reverse ys ++ [x] = {++1}
            reverse x:xs' ++ reverse ys
        Como queria probar ???



iii. ∀ xs::[a] . ∀ x::a . reverse (xs ++ [x]) = x:reverse xs
    Caso base: xs = []
        reverse ([] ++ [x]) ={++0}(tomando [x] como ys)
        reverse [x] = reverse (x:[]) ={R1}
        reverse [] ++ [x] ={R0}
        [] ++ [x] = [x] = x : reverse []
    Se cumple el caso base

    Paso inductivo: xs = y:ys
        HI: Asumo que ∀ ys::[a] . ∀ x::a . reverse (ys ++ [x]) = x : reverse ys
        qvq:    reverse (y: (ys ++ [x]))        = x : reverse y:ys
                reverse ((y:ys) ++ [x]))        ={++1}
                reverse (y : (ys ++ [x]))       ={R1}
                reverse (ys ++ [x]) ++ [y]      ={HI}
                (x : reverse ys) ++ [y]         ={++1}
                x : (reverse ys ++ [y])         ={R1}
                x : reverse (y:ys)
        Como queria probar



                            ========================== Ejercicio 5 ==========================


Lema generador para reverse:
    ∀ ys zs, reverse (ys ++ zs) = reverse zs ++ reverse ys

Principio de extensionalidad funcional:
    Cuando comparo dos listas, son iguales si tienen los mismos elementos en el mismo orden, 
    o dos funciones son iguales si devuelven siempre el mismo resultado.


i. reverse . reverse = id => Es decir, ∀xs::[a]. reverse (reverse xs) = xs
    Por inducción sobre xs:
    
    Caso base: xs = []
        reverse (reverse [])    ={R0}
        reverse []              ={R0}
        []                      = xs
    Se cumple el Caso Base

    Paso inductivo: xs = y:ys
        HI:     Asumo como Verdadero que ∀ys::[a]. reverse (reverse ys) = id = ys
        qvq:    reverse (reverse (y:ys)) = id               = y:ys
                reverse (reverse (y:ys))                    ={R1}
                reverse (reverse ys ++ [y])                 ={Lema generador de reverse}
                reverse [y] ++ reverse (reverse ys)         ={R1}
                reverse [] ++ [y] ++ reverse (reverse ys)   ={R0}           
                [] ++ [y] ++ reverse (reverse ys)           =
                [y] ++ reverse (reverse ys)                 ={HI}
                [y] ++ ys                                   = y:ys
        Como queria probar

ii. append = (++) => Es decir, ∀ xs::[a] ys::[a]. append xs ys = xs ++ ys
    Por inducción sobre xs:
    Caso base: xs = []
        append [] ys        ={A0}
        foldr (:) ys []     ={FR0}
        ys                  = [] ++ ys = xs ++ ys
    Se cumple el caso base

    Paso inductivo: xs = x:xs'
        HI: Asumo como Verdadero que ∀ xs::[a] ys::[a]. append xs' ys = xs' ++ ys
        qvq:    append x:xs' ys             = (x:xs') ++ ys
                append x:xs' ys             ={A0}
                foldr ys (x:xs')            ={FR1}
                (:) x (foldr (:) ys xs')    =
                x : foldr (:) ys xs'        ={A0}
                x : append xs' ys           ={HI}
                (x : xs') ++ ys
        Como queria probar



iii. map id = id => Es decir ∀ xs::[a], f::(a -> b). map id xs = xs
    Por inducción sobre xs:
    Caso base: xs = []
        map id [] = [] = xs = id
    Se cumple el caso base
    
    Paso inductivo: xs = x:xs'
        HI: Asumo como Verdadero que map id xs' = xs'
        qvq:    map id (x:xs') = (x:xs') = id
                map id (x:xs')           ={M1}
                id x : map id xs'        ={HI}
                id x : xs'               ={id}
                x : xs'
        Como queria probar



                            ========================== Ejercicio 6 ==========================
Demostrar que zip = zip' utilizando inducción estructural y el principio de extensionalidad.



                            ========================== Ejercicio 7 ==========================




i. Eq a => ∀ xs::[a] . ∀ e::a . ∀ p::a -> Bool . elem e xs && p e = elem e (filter p xs)
    Si elem e xs = True y p e = True implica que, al aplicar filter p en xs, 
    e va a aparecer dentro de xs luego de aplicar el filtro, tal que elem e xs
    seguira siendo True. Luego, sucede lo mismo para el caso p e = False y 
    para elem e = False 

    Caso base: xs = []
        elem e xs && p e    = elem e (filter p xs)
        elem e [] && p e    = elem e (filter p [])  ={E0, F0}
        False && p e        = elem e ([])           ={F0}
        False               = False                 
    Se cumple el caso base

    Paso inductivo: xs = x:xs'
        HI: Asumo como Verdadero que elem e xs' && p e = elem e (filter p xs')
        qvq: elem e (x:xs') && p e = elem e (filter p (x:xs'))
                elem e (x:xs') && p e            ={E1}
                (e == x) || elem e xs' && p e    ={HI}
                (e == x) || elem e (filter p xs) 



ii. Eq a => ∀ xs::[a] . ∀ e::a . elem e xs = elem e (nub xs)
    
    Verdadero, nub elimina las apariciones repetidas del elem e en xs, tal que siempre va a haber 
    al menos un e en xs

    Caso base: xs = []
        elem e [] = elem e (nub []) ={N0}
        elem e [] = elem e []       ={E0}
        False = False
    Se cumple el caso base

    Paso inductivo: xs = x:xs'
        HI: Asumo como Verdadero que elem e xs' = elem e (nub xs')
        qvq: elem e x:xs' = elem e (nub x:xs')

        elem e x:xs'             ={E1}
        (e == x) || elem e xs'   ={HI}
        (e == x) || elem e (nub xs')

        Si (e == x) = True,
        True || elem e (nub xs') = True por {OR} = elem e (nub x:xs')

        Si (e == x) = False,
        False || elem e (nub xs') = elem e (nub xs') por {OR}
                                    

    Luego, se cumple la igualdad en ambos casos



iii. Eq a => ∀ xs::[a] . ∀ ys::[a] . ∀ e::a . elem e (union xs ys) = (elem e xs) || (elem e ys)

    Verdadero, elem e (union xs ys) == elem e (xs ++ ys), tal que e puede estar en xs y/o en ys, o en ninguna
    de las 2, dando los 4 casos posibles: T T, T F, F T y F F

    Caso base: xs = []
        elem e (union [] ys) = (elem e []) || (elem e ys) ={U0}
        elem e ys = False || (elem e ys) ={OR}
        elem e ys = elem e ys








-} 