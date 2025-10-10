{- 
Recursion estructural
    1.  El caso base devuelve un valor z “fijo” (no depende de g)
    2.  El caso recursivo no puede usar las variables g ni xs,
        salvo en la expresion (g xs):
            g [] = z
            g (x : xs) = ... x ... (g xs) ...

    Ejemplo:
        suma :: [Int] -> Int
        suma [] = 0
        suma (x : xs) = x + suma xs


Plegado de listas a derecha (foldr)
    Abstrae el esquema de recursion estructural
        foldr f z [] = z
        foldr f z (x : xs) = f x (foldr f z xs)

    Ejemplos:
        foldr (+) 0 [1, 2, 3, 4, 5]                 ==> 15

        foldr (*) 1 [1, 2, 3, 4]                    ==> 24

        foldr (++) [] [[1,2], [3,4], [5,6]]         ==> [1,2,3,4,5,6]

        foldr (&&) True [True, True, False, True]   ==> False

        contarPares :: [Int] -> Int
        contarPares = foldr (\x acc -> if even x then acc + 1 else acc) 0


Recursion primitiva
    1.  El caso base devuelve un valor z “fijo” (no depende de g)
    2.  El caso recursivo no puede usar la variable g,
        salvo en la expresion (g xs) (S´ı puede usar la variable xs)
            g [] = z
            g (x : xs) = ... x ... xs ... (g xs) ...


Recursion iterativa
    1.  El caso base devuelve el acumulador ac.
    2.  El caso recursivo invoca inmediatamente a (g ac’ xs),
        donde ac’ es el acumulador actualizado en funcion de su
        valor anterior y el valor de x

    g :: b -> [a] -> b
    g ac [] = ⟨caso base⟩
    g ac (x : xs) = ⟨caso recursivo⟩


Tipos de datos algebraicos
    data Tipo = ⟨declaracion de los constructores⟩

    Ejemplo:    data Dia = Dom | Lun | Mar | Mie | Jue | Vie | Sab
            
                Declara que existen constructores: Dom :: Dia, Lun :: Dia,..., Sab :: Dia
                Declara que esos son los unicos constructores del tipo Dia

-}

                            -- ======================= Ejercicios de Guia 1 =======================
mejorSegun :: (a -> a -> Bool) -> [a] -> a
mejorSegun comp = foldr1 (\x y -> if comp x y then x else y)


{- 
5)
Considerar las siguientes funciones:
    elementosEnPosicionesPares :: [a] -> [a]
    elementosEnPosicionesPares [] = []
    elementosEnPosicionesPares (x:xs) = if null xs
                                        then [x]
                                        else x : elementosEnPosicionesPares (tail xs)

    entrelazar :: [a] -> [a] -> [a]
    entrelazar [] = id
    entrelazar (x:xs) = \ys ->  if null ys
                                then x : entrelazar xs []
                                else x : head ys : entrelazar xs (tail ys)
 
Indicar si la recursión utilizada en cada una de ellas es o no estructural. Si lo es, reescribirla utilizando foldr.
En caso contrario, explicar el motivo.


elementosEnPosicionesPares no usa recursion estructural, ya que llama a xs fuera la expresion (g xs), en el condicional if null xs;
entrelazar  no usa recursion estructural, ya que Manipula dos listas simultáneamente de forma no estructural, 
            usando head y tail en ys mientras recurre sobre xs
-}


-- Ejercicio 6 ⋆
-- El siguiente esquema captura la recursión primitiva sobre listas.

recr :: (a -> [a] -> b -> b) -> b -> [a] -> b
recr _ z [] = z
recr f z (x : xs) = f x xs (recr f z xs)


{- 
b. Explicar por qué el esquema de recursión estructural (foldr) no es adecuado para implementar la función
sacarUna del punto anterior.

    Porque foldr comienza desde el fin de la lista, dando a saber que probablemente tardaria mas en encontrar la PRIMER aparicion de
    un elemento en la lista, ya que tendria que recorrer la lista desde la ultima aparicion del elemento.
    Otro planteo seria que foldr, al comenzar a recorrer desde el ultimo elemento de la lista, tome la ultima aparicion del elemento a buscar
    como la primer aparicion, ya que con este metodo recorre la lista al reves, haciendo que la ultima aparicion del elemento sea la primera
    a retornar

    ¿Por qué esto es problemático para sacarUna?

    * No puedes detener el procesamiento: foldr siempre procesa toda la lista
    * No puedes "cortocircuitar": Una vez que encuentras el elemento, 
      quieres devolver el resto sin modificar, pero foldr ya habrá procesado todo

 -}



--                                 ============================== Practica 2 =============================== 
{- 
Ejercicio 1 ⋆
Sean las siguientes definiciones de funciones:
- intercambiar (x,y) = (y,x)            {I}
- espejar (Left x) = Right x            {EspejarL}
- espejar (Right x) = Left x            {EspejarR}
- asociarI (x,(y,z)) = ((x,y),z)        {AsociarI}
- asociarD ((x,y),z)) = (x,(y,z))       {AsociarD}
- flip f x y = f y x                    {Flip}
- curry f x y = f (x,y)                 {Curry}
- uncurry f (x,y) = f x y               {Uncurry}

Demostrar las siguientes igualdades usando los lemas de generación cuando sea necesario:
    i. ∀ p::(a,b) . intercambiar (intercambiar p) = p
    ii. ∀ p::(a,(b,c)) . asociarD (asociarI p) = p
    iii. ∀ p::Either a b . espejar (espejar p) = p
    iv. ∀ f::a->b->c . ∀ x::a . ∀ y::b . flip (flip f) x y = f x y
    v. ∀ f::a->b->c . ∀ x::a . ∀ y::b . curry (uncurry f) x y = f x y
 
i. ∀ p::(a,b) . intercambiar (intercambiar p) = p
    ∀x :: a. ∀y :: b. intercambiar (intercambiar (x,y)) = (x,y)
    intercambiar (intercambiar (x,y))
    intercambiar ((y,x))                    {I}
    (x,y) = (x,y)                           {I}

ii. ∀ p::(a,(b,c)) . asociarD (asociarI p) = p
    ∀x :: a. ∀y :: b. ∀z :: c. asociarD (asociarI (x,(y,z))) = (x,(y,z))
    asociarD (asociarI (x,(y,z)))
    asociarD ((x,y),z)                          {AsociarI}
    (x,(y,z)) = (x,(y,z))                       {AsociarD}

iii. ∀ p::Either a b . espejar (espejar p) = p
    ∀x :: a. ∀y :: b. espejar (espejar Either x y) = Either x y
    espejar (espejar Either x y)
    
    Caso Left x:
        espejar (espejar Left x)
        espejar Right x                 {EspejarL}
        Left x                          {EspejarR}
                                                                    ======> Left x por un lado, Right y por el otro == Either x y
    Caso Right y:
        espejar (espejar Right y)
        espejar Left y                  {EspejarR}
        Right y                         {EspejarI}

iv. ∀ f::a->b->c . ∀ x::a . ∀ y::b . flip (flip f) x y = f x y
    flip (flip f) x y
    (flip f) y x            {Flip} (primero aplico el que esta fuera de los parentesis)
    f x y                   {Flip} == f x y

v. ∀ f::a->b->c . ∀ x::a . ∀ y::b . curry (uncurry f) x y = f x y
    curry (uncurry f) x y
    (uncurry f) (x,y)       {Curry}
    f x y                   {Uncurry} == f x y


Ejercicio 2
Demostrar las siguientes igualdades utilizando el principio de extensionalidad funcional:

i. flip . flip = id
ii. ∀ f::(a,b)->c . uncurry (curry f) = f
iii. flip const = const id
iv. ∀ f::a->b . ∀ g::b->c . ∀ h::c->d . ((h . g) . f) = (h . (g . f))
    con la definición usual de la composición: (.) f g x = f (g x).


i. flip . flip = id
    ∀f. (flip . flip) f = id f === ∀f. flip (flip f) = f === flip (flip f) x y = f x y

        flip (flip f) x y   {(.)}
        flip f y x          {Flip}
        f x y               {Flip}
        id f x y            {Id}

ii. ∀ f::(a,b)->c . uncurry (curry f) = f
    ∀ f::(a,b)->c, ∀x :: a. ∀y:: b. uncurry (curry f) (x,y) = f (x,y) = id

        uncurry (curry f) (x, y)
        (curry f) x y           {Uncurry}
        f (x, y)                {Curry}

iii. flip const = const id
    ∀ f::(a,b)->c, ∀x :: a. ∀y:: b. flip const x y = const id x y
    flip const x y
=   const y x       {Flip}
=   y               {Const}
=   id y            {Id}
=   const id y x    {Const} ===> Las igualdades no son ciertas de ambos lados
 
iv. ∀ f::a->b . ∀ g::b->c . ∀ h::c->d . ((h . g) . f) = (h . (g . f))
    con la definición usual de la composición: (.) f g x = f (g x).
    ∀x:: a. ∀y :: b. ((h . g) . f x y) = (h . (g . f x y))
    ((h . g) . f x)
=   h . g (f x)       {(.)}
=   h (g (f x))       {(.)} 
=   h (g . f x))      {(.)}
=   h . (g . f x))    {(.)}


Inducción sobre listas
length :: [a] -> Int
    {L0} length [] = 0
    {L1} length (x:xs) = 1 + length xs

duplicar :: [a] -> [a]
    {D0} duplicar [] = []   
    {D1} duplicar (x:xs) = x : x : duplicar xs  

(++) :: [a] -> [a] -> [a]
    {++0} [] ++ ys = ys
    {++1} (x:xs) ++ ys = x : (xs ++ ys)

append :: [a] -> [a] -> [a]
    {A0} append xs ys = foldr (:) ys xs

reverse :: [a] -> [a]
    {R0} reverse = foldl (flip (:)) []

Ejercicio 3
Demostrar las siguientes propiedades:
i. ∀ xs::[a] . length (duplicar xs) = 2 * length xs
ii. ∀ xs::[a] . ∀ ys::[a] . length (xs ++ ys) = length xs + length ys
iii. ∀ xs::[a] . ∀ x::a . [x] ++ xs = x:xs
iv. ∀ xs::[a] . xs ++ [] = xs
v. ∀ xs::[a] . ∀ ys::[a] . ∀ zs::[a] . (xs ++ ys) ++ zs = xs ++ (ys ++ zs)
vi. ∀ xs::[a] . ∀ f::(a->b) . length (map f xs) = length xs
vii. ∀ xs::[a] . ∀ p::a->Bool . ∀ e::a . (elem e (filter p xs) ⇒ elem e xs) (si vale Eq a)

i. ∀ xs::[a] . length (duplicar xs) = 2 * length xs
    Caso base: xs = []
        length (duplicar [])
    =   length []               {D0}
    =   0                       {L0}
    =   2 * 0
    =   2 * length []           {L0} ==> Se cumple el caso base

    Paso inductivo: 
    HI: Asumo como V que length (duplicar xs') = 2 * length xs'
    CI: length (duplicar x:xs') = 2 * length x:xs'

    Tesis Inductiva:
        length (duplicar x:xs)
    =   length (x : x : duplicar xs')   {D1}
    =   1 + length (x : duplicar xs')   {L1}
    =   1 + 1 + length (duplicar xs')   {L1}
    =   2 + 2 * length xs'              {HI}
    =   2 * (1 + length xs')            {Distributiva}
    =   2 * length (x:xs')              {L1}


ii. ∀ xs::[a] . ∀ ys::[a] . length (xs ++ ys) = length xs + length ys
    Por induccion sobre listas en xs => Caso base: xs = [] 
    length ([] ++ ys) = length [] + length ys
    length ([] ++ ys)
    =   length ys           {++0}
    =   0 + length ys
    =   length [] + length ys   {L0} ==> Se cumple el caso base

    Paso inductivo sobre xs:
    HI: Asumo como V que length (xs' ++ ys) = length xs' + length ys
    CI: length (x:xs' ++ ys) = length x:xs' + length ys

    Tesis Inductiva:
        length (x:xs' ++ ys)
    =   length (x : (xs' ++ ys))    {++1}
    =   1 + length (xs' ++ ys)      {L1}
    =   1 + length xs' + length ys  {HI}
    =   length (x:xs') + length ys  {L1}


iii. ∀ xs::[a] . ∀ x::a . [x] ++ xs = x:xs
    Por induccion sobre listas en xs => Caso base: xs = []
        [x] ++ []
    =   [] ++ [x]
    =   [x]             {++0}
    =   x : []  => Se cumple el caso base

    Paso inductivo sobre xs:
    HI: Asumo como V que [x] ++ xs' = x:xs'
    CI: [x] ++ (x:xs') = (x:x:xs')

    Tesis inductiva:
        [x] ++ (x:xs')
    =   (x:xs') ++ [x]      {Conmut}
    =   x : (xs' ++ [x])    {++1}
    =   x : ([x] ++ xs')    {Conmut}
    =   x : (x:xs')         {HI}
    =   (x:x:xs')           => Como queriamos probar

iv. ∀ xs::[a] . xs ++ [] = xs
    Caso base: xs = []
        [] ++ []
    =   []          {++0}
    =   xs          => Se cumple el caso base

    Paso inductivo:
    HI: Asumo como V que xs' ++ [] = xs'
    CI: x:xs' ++ [] = x:xs'

    Tesis inductiva:
        x:xs' ++ []
    =   x : (xs' ++ []) {++1}
    =   x : xs'         {HI}
    => Como queriamos probar

v. ∀ xs::[a] . ∀ ys::[a] . ∀ zs::[a] . (xs ++ ys) ++ zs = xs ++ (ys ++ zs)
    Por induccion sobre listas en xs: Caso base: xs = []
        ([] ++ ys) ++ zs = [] ++ (ys ++ zs)
        ([] ++ ys) ++ zs
    =   ys ++ zs            {++0}
    =   [] ++ (ys ++ zs)    {++0} => Se cumple el caso base
    
    Paso inductivo:
    HI: Asumo como V que (xs' ++ ys) ++ zs = xs' ++ (ys ++ zs)
    CI: (x:xs' ++ ys) ++ zs = x:xs' ++ (ys ++ zs)

    Tesis Inductiva:
        (x:xs' ++ ys) ++ zs
    =   x : (xs' ++ ys) ++ zs   {++1}
    =   x : xs' ++ (ys ++ zs)   {HI} => Como queria probar
    

map f [] = []                                      -- {M0}
map f (x:xs) = f x : map f xs                      -- {M1}

vi. ∀ xs::[a] . ∀ f::(a->b) . length (map f xs) = length xs
    Caso base: xs = []
        length (map f [])
    =   length []           {M0}
    =   0                   {L0}
    =   length xs           {L0} => Se cumple el caso base

    Paso inductivo: 
    HI: Asumo como V que length (map f xs') = length xs'
    CI: length (map f x:xs') = length x:xs'

    Tesis inductiva:
        length (map f x:xs')
    =   length (f x : map f xs')    {M1}
    =   1 + length (map f xs')      {L1}
    =   1 + length xs'              {HI}
    =   length (x:xs')              {L1} => como queriamos probar
       

Ejercicio 4 
Demostrar las siguientes propiedades:
i. reverse = foldr (\x rec -> rec ++ (x:[])) []
ii. ∀ xs::[a] . ∀ ys::[a] . reverse (xs ++ ys) = reverse ys ++ reverse xs
iii. ∀ xs::[a] . ∀ x::a . reverse (xs ++ [x]) = x:reverse xs
Nota: en adelante, siempre que se necesite usar reverse, se podrá utilizar cualquiera de las dos definiciones,
según se considere conveniente.

i.  reverse = foldr (\x rec -> rec ++ (x:[])) []
    reverse xs = foldr (\x rec -> rec ++ (x:[])) [] xs
    Caso base: xs = []
        foldr (\x rec -> rec ++ (x:[])) [] []
        []              {definicion de foldr}

    Paso inductivo: 
    HI: Asumo como V que reverse xs' = foldr (\x rec -> rec ++ (x:[])) [] xs'
    CI: reverse x:xs' = foldr (\x rec -> rec ++ (x:[])) [] x:xs'
     

ii. ∀ xs::[a] . ∀ ys::[a] . reverse (xs ++ ys) = reverse ys ++ reverse xs
    Por induccion estructural sobre listas aplicada a xs: Caso base: xs = [] 
        reverse ([] ++ ys)
    =   reverse ys                  {++0}
    =   reverse ys ++ reverse []    {++0} => Se cumple el caso base

    Paso inductivo:
    HI: Asumo como V que reverse (xs' ++ ys) = reverse ys ++ reverse xs'
    CI: reverse (x:xs' ++ ys) = reverse ys ++ reverse x:xs'

    Tesis inductiva:
        reverse (x:xs' ++ ys)
    =   reverse (xs' ++ ys) ++ [x]          {R1}
    =   reverse ys ++ reverse xs' ++ [x]    {HI}
    =   reverse ys ++ reverse x:xs'         {R1}

iii. ∀ xs::[a] . ∀ x::a . reverse (xs ++ [x]) = x:reverse xs
    Caso base: xs = []
        reverse ([] ++ [x])
    =   reverse [x]             {++0}
    =   reverse x:[]
    =   reverse [] ++ [x]
    =   x : reverse []            

    Paso inductivo:
    HI: Asumo como V que reverse (ys ++ [x]) = x:reverse ys
    CI: (y:ys ++ [x]) = x:reverse y:ys

    Tesis inductiva:
        reverse (y:ys ++ [x])
    =   reverse (y : (ys ++ [x]))   {++1}
    =   reverse (ys ++ [x]) ++ [y]  {R1}
    =   x : reverse ys ++ [y]       {HI}
    =   x : (reverse ys ++ [y])     {Asociatividad de ++}
    =   x : (reverse y:ys)          => Como queria probar


Ejercicio 6
Dadas las siguientes funciones:
zip :: [a] -> [b] -> [(a,b)]
    {Z0} zip = foldr (\x rec ys ->
                            if null ys
                            then []
                            else (x, head ys) : rec (tail ys))
                        (const [])

zip' :: [a] -> [b] -> [(a,b)]
    {Z'0} zip' [] ys = []
    {Z'1} zip' (x:xs) ys = if null ys then [] else (x, head ys):zip' xs (tail ys)

Demostrar que zip = zip' utilizando inducción estructural y el principio de extensionalidad.



Ejercicio 7 ⋆

Elem:
    {E0}: elem e [] = False
    {E1}: elem e (x:xs) = (e == x) || elem e xs

Filter:
    {F0}: filter p [] = []
    {F1-True}: filter p (x:xs) = x : filter p xs (si p x == True)
    {F1-False}: filter p (x:xs) = filter p xs (si p x == False)

Dadas las siguientes funciones:
nub :: Eq a => [a] -> [a]
    {N0} nub [] = []
    {N1} nub (x:xs) = x : filter (\y -> x /= y) (nub xs)

union :: Eq a => [a] -> [a] -> [a]
    {U0} union xs ys = nub (xs++ys)

intersect :: Eq a => [a] -> [a] -> [a]
    {I0} intersect xs ys = filter (\e -> elem e ys) xs

Y la siguiente propiedad que vale para todos los tipos a y b pertenecientes a la clase Eq:
    {CONGRUENCIA ==} ∀ x::a . ∀ y::a . ∀ f::a->b . (a == b ⇒ f a == f b)


Indicar si las siguientes propiedades son verdaderas o falsas. Si son verdaderas, realizar una demostración.
Si son falsas, presentar un contraejemplo.

i. Eq a => ∀ xs::[a] . ∀ e::a . ∀ p::a -> Bool . elem e xs && p e = elem e (filter p xs)
ii. Eq a => ∀ xs::[a] . ∀ e::a . elem e  xs = elem e (nub xs)
iii. Eq a => ∀ xs::[a] . ∀ ys::[a] . ∀ e::a . elem e (union xs ys) = (elem e xs) || (elem e ys)
iv. Eq a => ∀ xs::[a].∀ ys::[a].∀ e::a . elem e (intersect xs ys) = (elem e xs) && (elem e ys)
v. Eq a => ∀ xs::[a] . ∀ ys::[a] . length (union xs ys) = length xs + length ys
vi. Eq a => ∀ xs::[a] . ∀ ys::[a] . lengt(elem e ys) (union xs ys) ≤ length xs + length ys

i. Eq a => ∀ xs::[a] . ∀ e::a . ∀ p::a -> Bool . elem e xs && p e = elem e (filter p xs) => Verdadero
    Caso base: xs = []
        elem e [] && p e = elem e (filter p [])
        elem e [] && p e
        false && p e            {E0}
        false
        elem e []               {E0}
        elem e (filter p [])    {F0}

    Caso inductivo:
        HI: Asumo como V que elem e xs' && p e = elem e (filter p xs')
        qv: elem e x:xs' && p e = elem e (filter p x:xs')
            elem e x:xs' && p e
            e == x || elem e xs && p e  {E1}

            Si e == x:
                True || elem e xs' && p e
                True || elem e (filter p xs')   {HI}
                Como por HI asumimos que 'p e' tambien se cumple, filter p xs' tambien tendra a x dentro (por e == x = True)
                e == x || elem e (filter p xs')
                elem e (filter p x:xs')         {e == x = True}

            Si e /= x:
                False || elem e xs' && p e
                False || elem e (filter p xs')  {HI}
                elem e (filter p xs')           {e == x = False}

            Luego, se cumple lo pedido solo cuando e == x

ii. Eq a => ∀ xs::[a] . ∀ e::a . elem e xs = elem e (nub xs) ==> Verdadero
    Caso base: xs = []
        elem e [] = elem e (nub [])
        elem e []
        False           {E0}
        elem e []       {E0}
        elem e (nub []) {N0} => Se cumple el caso base

    Caso inductivo:
    HI: Asumo como V que elem e xs' = elem e (nub xs')
    qv: elem e x:xs' = elem e (nub x:xs')
        elem e x:xs'
        (e == x) || elem e xs'          {E1}
        (e == x) || elem e (nub xs')    {HI}
        
        Si e == x:
            True || elem e (nub xs')
            elem e (nub x:xs')
        Si e != x:
            False || elem e (nub xs')
            elem e (nub xs')        
        Se cumple el caso pedido si y solo si e == x

iii. Eq a => ∀ xs::[a] . ∀ ys::[a] . ∀ e::a . elem e (union xs ys) = (elem e xs) || (elem e ys)
    elem e (union xs ys) = (elem e xs) || (elem e ys) => Verdadero
    Induccion estructural sobre xs: Caso base: xs = []
        elem e (union [] ys) = (elem e []) || (elem e ys)
        elem e (union [] ys)
        elem e (nub ([]++ys))               {U0}
        elem e (nub ys)                     {++0}
        elem e (y : filter (\z -> y /= z))  {N1}
        elem e ys => True o False
        (elem e []) || (elem e ys)          => Se cumple el caso base

    Caso inductivo:
    HI: Asumo como V que elem e (union xs' ys) = (elem e xs') || (elem e ys)
    qv: elem e (union x:xs' ys) = (elem e x:xs') || (elem e ys)
        elem e (union x:xs' ys)
        elem e (nub (x:xs'++ys))        {U0}
        elem e (nub (x : (xs' ++ ys)))
        elem e (x : (xs' ++ ys))
        (e == x) || elem e (xs' ++ ys)  {E1}
        (e == x) || (elem e xs') || (elem e ys)
        ((e == x) || (elem e xs')) || (elem e ys)
        (elem e x:xs') || (elem e ys)       {E1} => Como queria probarlo


Ejercicio 10 ⋆
altura :: AB a -> Int
    altura Nil = 0
    altura (Bin i r d) = 1 + max (altura izq) (altura der)

cantNodos :: AB a -> Int
    cantNodos Nil = 0
    cantNodos (Bin i r d) = 1 + cantNodos izq + cantNodos der

Dadas las funciones altura y cantNodos definidas en la práctica 1 para árboles binarios, demostrar la siguiente
propiedad:
∀ x::AB a . altura x ≤ cantNodos x
    Caso base: x = Nil
        altura Nil ≤ cantNodos Nil
        altura Nil
        0           {N0}
        La minima cantidad de altura que podemos tener es 0 => 0 <=cantNodos x siempre => Se cumple el caso base

    Paso inductivo: x = Bin izq r der
    HI: Asumo que   altura izq ≤ cantNodos izq
                    altura der ≤ cantNodos der
    qv: altura Bin (i r d) ≤ cantNodos Bin(i r d)
        altura Bin (i r d)
        1 + max (altura izq) (altura der)           {A1}
        
        Si altura izq > altura der:
            1 + altura izq                          {>}
            1 + altura izq <=1 + cantNodos izq      {HI}
        
        Si altura der > altura izq:
            1 + altura der                          {>}
            1 + altura der <= 1 + cantNodos der     {HI}

        Luego, 1 + altura izq + altura der <= 1 + cantNodos izq + cantNodos izq
        1 + altura izq + altura der <= cantNodos (Bin i r d)                        {CN1}
        1 + max (altura izq + altura der) <= cantNodos (Bin i r d)                  {regla de max}
        altura (Bin i r d) <= cantNodos (Bin i r d)                                 {A1}




Ejercicios parcial:

type Tono = Integer
data Melodia = Silencio | Nota Tono | Secuencia Melodia Melodia | Paralelo [Melodia] deriving Show

foldMelodia :: b -> (Tono -> b) -> (b -> b -> b) -> ([b] -> b) -> Melodia -> b
foldMelodia cSilencio cNota cSecuencia cParalelo melo = case melo of
    Silencio -> cSilencio 
    Nota tono -> cNota tono
    Secuencia melo1 melo2 -> cSecuencia (rec melo1) (rec melo2)
    Paralelo l -> cParalelo (map rec l)

where rec = foldMelodia cSilencio cNota cSecuencia cParalelo

duracionTotal :: Melodia -> Integer





Dadas las siguientes definiciones:
data AB a = Nil | Bin (AB a) a (AB a)
const :: a -> b -> a
    {C} const = (\x -> \y -> x)

altura :: AB a -> Int
    {A0} altura Nil = 0
    {A1} altura (Bin i r d) = 1 + max (altura i) (altura d)

zipAB :: AB a -> AB b -> AB (a,b)
    {Z0} zipAB Nil = const Nil
    {Z1} zipAB (Bin i r d) = \t -> case t of
                                    Nil -> Nil
                                    Bin i’ r’ d’ -> Bin (zipAB i i’) (r,r’) (zipAB d d’)


Demostrar la siguiente propiedad: ∀ t::AB a.∀ u::AB a. altura t ≥ altura (zipAB t u)
Por induccion estructural en AB t:
Caso base: t = Nil
    altura Nil >= altura (zipAB Nil u)
    0 >= altura (zipAB Nil u)           {A0}
    0 >= altura (const Nil u)           {Z0}
    0 >= altura ((\x -> \y -> x) Nil u) {C}
    0 >= altura ((\y -> Nil) u)         {Beta: x := Nil}
    0 >= altura Nil                     {Beta: y := u}
    0 >= 0                              {A0} => Se cumple el caso base

Paso inductivo: t = Bin i r d
HI:     altura i ≥ altura (zipAB i u)
        altura d ≥ altura (zipAB d u)

qvq:    altura Bin i r d                >= altura (zipAB (Bin i r d) u)
        1 + max (altura i) (altura d)   >= altura (zipAB (Bin i r d) u)     {A1}
        1 + max (altura i) (altura d)   >= altura (\t -> case t of
                                                        Nil -> Nil
                                                        Bin i’ r’ d’ -> Bin (zipAB i i’) (r,r’) (zipAB d d’))
                                                    u)

por lema de generacion, u = Nil o u = Bin ui ur ud:

Caso u = Nil:

Caso u = Bin ui ur ud, 1 + max (altura i) (altura d) = E:

E >= altura (\t -> case t of
                    Nil -> Nil
                    Bin i’ r’ d’ -> Bin (zipAB i i’) (r,r’) (zipAB d d’))
                Bin ui ur ud)
E >= altura (Bin (zipAb i ui) (r, ur) (zipAB d, ud))
E >= 1 + max (altura (zipAb i ui)) (altura (zipAB d, ud))   {A1}
max (altura i) (altura d) >= max (altura (zipAb i ui)) (altura (zipAB d, ud))





Demostrar el siguiente teorema usando Deducci´on Natural, sin utilizar
principios cl´asicos: 
                                                                    ----------------------------------ax    -----------------------------ax
                                                                    ρ, σ V (ρ -> τ), (ρ -> τ) ⊢ ρ -> τ      ρ, σ V (ρ -> τ), (ρ -> τ) ⊢ ρ
                                    ----------------------ax        ---------------------------------------------------------------------- ->e
                                    ρ, σ V (ρ -> τ), σ ⊢ σ          ρ, σ V (ρ -> τ), (ρ -> τ) ⊢ τ
------------------------------ax    ---------------------------Vi1  ---------------------------------Vi2
ρ, σ V (ρ -> τ) ⊢ σ V (ρ -> τ)      ρ, σ V (ρ -> τ), σ ⊢ σ V τ      ρ, σ V (ρ -> τ), (ρ -> τ) ⊢ σ V τ      
------------------------------------------------------------------------------------------------------ Ve
ρ, σ V (ρ -> τ) ⊢ σ V τ
--------------------------- ->i
ρ ⊢ σ V (ρ -> τ) -> (σ V τ)
---------------------------------- ->i
⊢ ρ -> (σ V (ρ -> τ )) -> (σ V τ)



Este ejercicio extiende el cálculo-λ tipado con pares. Las gramáticas de los tipos y los términos se extienden de
la siguiente manera:
τ ::= . . . | τ × τ
M ::= . . . | ⟨M, M⟩ | π1(M) | π2(M)

donde σ × τ es el tipo de los pares cuya primera componente es de tipo σ y cuya segunda componente es de
tipo τ , ⟨M, N⟩ construye un par y π1(M) y π2(M) proyectan la primera y la segunda componente de un par,
respectivamente.

a) Definir reglas de tipado para los nuevos constructores de términos.

Γ ⊢ M :: σ    Γ ⊢ N :: τ
-------------------------- T-Par
Γ ⊢ ⟨M, N⟩ :: σ × τ


Γ ⊢ M :: σ x τ                  Γ ⊢ M :: σ x τ                      
--------------- T-Pi1           --------------- T-Pi2                   
Γ ⊢ π1(M) :: σ                  Γ ⊢ π2(M) :: τ                      


b) Usando las reglas de tipado anteriores, y dados los tipos σ, τ y ρ, exhibir habitantes de los siguientes tipos:
    i) Constructor de pares: σ → τ → (σ × τ)
    ii) Proyecciones: (σ × τ ) → σ y (σ × τ) → τ
    iii) Conmutatividad: (σ × τ ) → (τ × σ),
    iv) Asociatividad: ((σ × τ ) × ρ) → (σ × (τ × ρ)) y (σ × (τ × ρ)) → ((σ × τ ) × ρ).
    v) Currificación: ((σ × τ ) → ρ) → (σ → τ → ρ) y (σ → τ → ρ) → ((σ × τ ) → ρ).

i) Constructor de pares: σ → τ → (σ × τ)
    M = λx:σ. λy:τ. ⟨x, y⟩
    Γ ⊢ λx:σ. λy:τ. ⟨x, y⟩: σ → τ → (σ × τ)

-----------------ax     -----------------ax
x:σ, y:τ ⊢ x : σ       x:σ, y:τ ⊢ y : τ       
------------------------------------------T-Par
x:σ, y:τ ⊢ ⟨x, y⟩: (σ × τ)
-------------------------------T-Abs
x:σ ⊢ λy:τ. ⟨x, y⟩: τ → (σ × τ)
-------------------------------------T-Abs
⊢ λx:σ. λy:τ. ⟨x, y⟩: σ → τ → (σ × τ)


ii) Proyecciones: (σ × τ) → σ y (σ × τ) → τ
    M1 = λp:(σ × τ). π1(p)
    M2 = λp:(σ × τ). π2(p)
    

    Γ1 ⊢ λp:(σ × τ). π1(p): (σ × τ) → σ
    Γ2 ⊢ λp:(σ × τ). π2(p): (σ × τ) → τ


----------------------ax
p:(σ × τ) ⊢ p:(σ × τ)
---------------------T-Pi1
p:(σ × τ) ⊢ π1(p): σ
---------------------------------T-Abs
⊢ λp:(σ × τ). π1(p): (σ × τ) → σ



---------------------ax
p:(σ × τ) ⊢ p:(σ × τ)
----------------------T-Pi2
p:(σ × τ) ⊢ π2(p): τ
------------------------------T-Abs
⊢ λp:(σ × τ). π2(p): (σ × τ) → τ



iii) Conmutatividad: (σ × τ) → (τ × σ),
    λp: (σ × τ). ⟨π2(p), π1(p)⟩
    Γ ⊢ λp: (σ × τ). ⟨π2(p), π1(p)⟩ : (σ × τ) → (τ × σ)


p: (σ × τ) ⊢ p : (σ × τ)        p: (σ × τ) ⊢ p : (σ × τ)
-----------------------T-Pi2    -----------------------T-Pi1
p: (σ × τ) ⊢ π2(p) : τ          p: (σ × τ) ⊢ π1(p) : σ
-------------------------------------------------------T-Par
p: (σ × τ) ⊢ ⟨π2(p), π1(p)⟩ : (τ × σ)
---------------------------------------------------T-Abs
⊢ λp:(σ × τ). ⟨π2(p), π1(p)⟩ : (σ × τ) → (τ × σ)


























































































































































































































































































































































































































































-}   