{- 
                            ========================== Ejercicio 1 ==========================

=> Expresiones de Terminos
a) x                                    
b) x x          -> Es la aplicación de dos términos (ambos pueden ser variables), por lo tanto cumple con la regla M ::= M M
c) M            -> Se refiere a un término arbitrario, por lo tanto es un término válido 
d) M M
g) λx.isZero(x)
h) λx: σ. succ(x)
i) λx: Bool. succ(x)
j) λx: if true then Bool else Nat. x

=> Expresiones de Tipos
k) σ                    
l) Bool
m) Bool → Bool
n) Bool → Bool → Nat
ñ) (Bool → Bool) → Nat



                            ========================== Ejercicio 2 ==========================

Mostrar un término que utilice al menos una vez todas las reglas de generación de la gramática de los términos
y exhibir su árbol sintáctico

    Un termino es:
        M ::= x 
        | λx: τ. M 
        | M M 
        | true 
        | false 
        | if M then M else M 
        | zero 
        | succ(M) 
        | pred(M) 
        | isZero(M)

    λx:Nat. if isZero(pred(succ(x))) then (if false then zero else true) else (λy:Bool. y) false

    Abstraccion x:Nat
    |
    If
    ├── isZero
    │   └── pred
    │       └── succ
    │           └── x
    ├── If
    │   ├── false
    │   ├── zero
    │   └── true
    │
    └── Aplicacion
        ├── Abstraccion y:Bool
        │   └── y
        └── false


                            ========================== Ejercicio 3 ==========================

a) Marcar las ocurrencias del término x como subtérmino en λx: Nat. succ((λx: Nat. x) x)
b) Ocurre x1 como subtérmino en λx1 : Nat. succ(x2)?
c) Ocurre x (y z) como subtérmino en u x (y z)?

a)
    λx: Nat.        => Abstraccion          => declaracion 
    λx: Nat. x      => 1er x: Abstraccion   => declaracion, 
                    => 2do x: Uso           => variable ligada por el λx 
    x               => Uso                  => variable libre
 
b)
    Parámetro ligado: x1 (es la variable ligada por el λ)
    Cuerpo: succ(x2)

    Subtérmino == Cualquier aparición de la variable x1 dentro del cuerpo de la expresión (a derecha del punto)
    
    x1 no ocurre como subtérmino en λx1 : Nat. succ(x2), ya que no aparece en el cuerpo de la función

c)
    u x (y z) = ((u x) (y z))

    x (y z) es un subtérmino de u x (y z), porque está presente como parte de la aplicación



                            ========================== Ejercicio 4 ==========================

i) Insertar todos los paréntesis de acuerdo a la convención usual
ii) Dibujar el árbol sintáctico de cada una de las expresiones
iii) Indicar en el árbol cuáles ocurrencias de variables aparecen ligadas y cuáles libres
iv) En cuál o cuáles de los términos anteriores ocurre la siguiente expresión como subtérmino?
    (λx: Bool → Nat → Bool. λy : Bool → Nat. λz : Bool. x z (y z)) u

a) u x (y z) (λv : Bool. v y)
i) (((u x) (y z)) (λv : Bool. v y))

ii)
                  Aplicacion
                /           \
        Aplicacion          Abstraccion (v:Bool)
        /        \                    |
    Aplicacion    Aplicacion       Aplicacion
    /       \     /       \        /       \
    u       x    y         z      v         y
    

iii)    ligadas => v
        libres  => u, x, y, z


b) (λx: Bool → Nat → Bool. λy : Bool → Nat. λz : Bool. x z (y z)) u v w
    i) (((λx: Bool → Nat → Bool. λy : Bool → Nat. λz : Bool. x z (y z)) u) v) w

    ii)
        Aplicación
        ├── Aplicación
        │   ├── Aplicación
        │   │   ├── Abstracción x: Bool → Nat → Bool
        │   │   │   └── Abstracción y: Bool → Nat
        │   │   │       └── Abstracción z: Bool
        │   │   │           └── Aplicación
        │   │   │               ├── Aplicación
        │   │   │               │   ├── x
        │   │   │               │   └── z
        │   │   │               └── Aplicación
        │   │   │                   ├── y
        │   │   │                   └── z
        │   │   └── u
        │   └── v
        └── w

iii)    Libres  => u, v, w (No son variables, son argumentos == x, y, z?)
        Ligadas => x, y, z


c) w (λx: Bool → Nat → Bool. λy : Bool → Nat. λz : Bool. x z (y z)) u v
    i) (((w (λx: Bool → Nat → Bool. λy : Bool → Nat. λz : Bool. x z (y z))) u) v)

    ii)
        Aplicacion
        ├── Aplicacion
        │   ├── Aplicacion
        │   │   ├── w
        │   │   └── Abstraccion x: Bool → Nat → Bool
        │   │       └── Abstraccion y : Bool → Nat
        │   └── u          └── Abstraccion z : Bool
        └── v                   ├── Aplicacion 
                                │   ├── x
                                │   └── z
                                └── Aplicacion
                                    ├── y
                                    └── z

    iii)    Libres  =>  w
            Ligadas =>  x, y, z
                        u, v son argumentos aplicados a la función 


iv) Sucede en b) y en c) 



                            ========================== Ejercicio 6 ==========================

Dar una derivación - o explicar por qué no es posible dar una derivación - para cada uno de los siguientes juicios de tipado:

a)                                          
                                                 ------------T-Zero
                                                 ⊢ zero : nat
-------------T-True      ------------T-Zero      ------------------T-Succ
⊢ true : bool            ⊢ zero : nat            ⊢ succ(zero) : nat
--------------------------------------------------------------------T-if
⊢ if true then zero else succ(zero) : Nat


b) Llamo Γ a 'x : Nat, y : Bool'

                                                    ----------------------T-var
                                                    Γ, z : Bool ⊢ z : Bool
                                                    ---------------------------------T-Abs      ---------------T-True
                                                    Γ ⊢ (λz : Bool. z) : Bool -> Bool           Γ ⊢ true : Bool    
---------------T-Bool   ----------------T-Bool      -------------------------------------------------------T-app
Γ ⊢ true : Bool         Γ ⊢ false : Bool            Γ ⊢ (λz : Bool. z) true : Bool
----------------------------------------------------------------------------------T-if
Γ ⊢ if true then false else (λz : Bool. z) true : Bool


c) 
                                                    ------------T-zero
                                                    ⊢ zero : nat
--------------------        -------------T-zero     -------------------T-succ
⊢ λx: Bool. x : bool        ⊢ zero : nat            ⊢ succ(zero) : nat
-----------------------------------------------------------------------T-if
⊢ if λx: Bool. x then zero else succ(zero) : nat

La derivación no es válida porque la condición del if no tiene tipo Bool (tiene tipo Bool -> Bool) => No es derivable


d) Llamo Γ a 'x : Bool → Nat, y : Bool'

Γ ⊢ x: bool → nat -> nat       Γ ⊢ y : bool
-------------------------------------------T-app
Γ ⊢ x y : nat

No es posible derivar Γ ⊢ x y : Nat ya que necesito un sistema de la forma Γ ⊢ x y : Nat -> Nat 



                            ========================== Ejercicio 7 ==========================

Se modifica la regla de tipado de la abstracción y se la cambia por la siguiente regla:

Γ ⊢ M : τ                           Γ, x : τ ⊢ M : σ
---------------------→i2            ----------------------T-abs
Γ ⊢ λx: σ. M : σ → τ                Γ ⊢ λx : τ . M : τ → σ

Exhibir un juicio de tipado que sea derivable en el sistema original pero que no lo sea en el sistema actual



                            ========================== Ejercicio 8 ==========================

Determinar qué tipo representa σ en cada uno de los siguientes juicios de tipado.
a) ⊢ succ(zero) : σ                                                         => Nat
b) ⊢ isZero(succ(zero)) : σ                                                 => Bool
c) ⊢ if (if true then false else false) then zero else succ(zero) : σ       => Nat



                            ========================== Ejercicio 9 ==========================

Decimos que un tipo τ está habitado si existe un término M tal que el juicio ⊢ M : τ es derivable. En ese caso, decimos que 
M es un habitante de τ. Por ejemplo, dado un tipo σ, la identidad λx : σ. x es un habitante del tipo σ → σ.
Demostrar que los siguientes tipos están habitados (para cualquier σ, τ y ρ):

a)  σ → τ → σ
    λx:σ. λy:τ. x

b)  (σ → τ → ρ) → (σ → τ) → σ → ρ
    λf:(σ → τ → ρ). λg:(σ → τ). λx:σ. f, x, (g,x)

c)  (σ → τ → ρ) → τ → σ → ρ
    λf:(σ → τ → ρ). λx:τ. λy:σ. f y x 

d)  (τ → ρ) → (σ → τ) → σ → ρ
    λf:(τ → ρ). λg:(σ → τ). λx: σ. f (g x)



                            ========================== Ejercicio 10 ==========================

Determinar qué tipos representan σ y τ en cada uno de los siguientes juicios de tipado. Si hay +1 solución, o ninguna, indicarlo.

a) x: σ ⊢ isZero(succ(x)) : τ                           => σ: Nat, τ: Bool  
b) ⊢ (λx: σ. x)(λy : Bool. zero) : σ                    => σ: Bool → Nat 
c) y : τ ⊢ if (λx: σ. x) then y else succ(zero) : σ     => Ninguna solución (la condición no puede ser de tipo Bool)  
d) x: σ ⊢ x y : τ                                       => Ninguna solución (porque y no está en el contexto)
e) x: σ, y : τ ⊢ x y : τ                                => σ: , τ: 
f) x: σ ⊢ x true : τ                                    => σ: , τ: 
g) x: σ ⊢ x true : σ                                    => Ninguna solución (ecuación imposible: σ = Bool → σ)
h) x: σ ⊢ x x : τ                                       => Ninguna solución (ecuación imposible: σ = σ → τ) 



                            ========================== Ejercicio 13 ==========================

Sean σ, τ, ρ tipos. Según la definición de sustitución, calcular
Renombrar variables en ambos términos para que las sustituciones no cambien su significado.

La α-conversión debe hacerse ANTES de la sustitución, no después

a)  (λy : σ. x (λx: τ. x)) {x := (λy : ρ. x y)}
    (λy : σ. (λy : ρ. x y) (λx: τ. x)) => aplico conversion-α, cambio la y exterior por z
    (λz : σ. (λy : ρ. x y) (λx: τ. x))

b)  (y (λv : σ. x v)){x := (λy : τ. v y)} => aplico conversion-α, cambio la v por w para evitar captura de variables
    (y (λw : σ. x w)){x := (λy : τ. v y)}
    (y (λw : σ. (λy : τ. v y) w))         => aplico conversion-α, cambio la y exterior por z
    (z (λw : σ. (λy : τ. v y) w))



                            ========================== Ejercicio 15 ==========================

Dado el conjunto de valores visto en clase V := λx: τ. M | true | false | zero | succ(V)
Determinar si cada una de las siguientes expresiones es o no un valor:

a)  (λx: Bool. x) true
    Entiendo que    V := λx: Bool. x == λx: τ. M
                    V := true
    (λx: Bool. x) true es una aplicación de una función a un argumento
    => No es un valor

El 2 subrayado indica que es una constante primitiva o un símbolo no definido en el sistema de tipos que estás usando
2 subrayado == succ(succ(zero))

b)  λx: Bool. 2
    λx: Bool. succ(succ(zero)) == λx: τ. M 
    => Es un valor

c)  λx: Bool. pred(2)
    λx: Bool. pred(succ(succ(zero))) => pred no esta definido en V
    => No es un valor

d)  λy : Nat. (λx: Bool. pred(2)) true
    λx: Bool. pred(succ(succ(zero))) => pred no esta definido en V
    => No es un valor

e)  x => No esta definido como un valor 
    => No es un valor

f)  succ(succ(zero))
    succ(V) esta definido en V => por ende, succ(succ(V)) tambien
    => Es un valor



                            ========================== Ejercicio 16 ==========================

Para el siguiente ejercicio, considerar el cálculo sin la regla pred(zero) → zero
Un programa es un término que tipa en el contexto vacío (es decir, no puede contener variables libres). Para cada una de las sig. expresiones,

a) Determinar si puede ser considerada un programa.
b) Si es un programa, cuál es el resultado de su evaluación?
Determinar si se trata de una forma normal, y en caso de serlo, si es un valor o un error.

Una forma normal es una expresión que no se puede reducir más mediante las reglas de evaluación.
    Valor: Forma normal que es un resultado válido (según la definición V)
    Error: Forma normal que representa un estado de error (como pred(zero) sin la regla especial)



1)  (λx: Bool. x) true
    a) puede ser considerado un programa, true es una constante, no es una variable libre        
    b)  Aplicar β-reducción => x[x := true] 
        Es forma normal, no se puede reducir mas
        Es un Valor

2)  λx: Nat. pred(succ(x))
    a) puede ser considerado un programa, x esta ligado a λx y no hay variables libres
    b)  Es forma normal, es una abstracción lambda, no puede reducirse mas
        Es un Valor => Tiene la forma λx: τ. M

3)  λx: Nat. pred(succ(y))
    a) No puede ser considerado un programa, ya que 'y' es una variable libre

4)  (λx: Bool. pred(isZero(x))) true
    a)  Entiendo que no es un programa, ya que en pred(isZero(x)) se esta pidiendo en anterior de un bool (isZero(x)), 
        tal que reemplazando en x quedaria pred(isZero(true))) => No tipa correctamente

5)  (λf : Nat → Bool. f zero) (λx: Nat. isZero(x))
    a) Es un programa, no hay variables libres y tipa correctamente
    b)  β-reducción => (f zero) [f := λx: Nat. isZero(x)]   ==> (λx: Nat. isZero(x) zero) 
        β-reducción => isZero(x) [x := zero]                ==> isZero(zero) ==> True
    Es forma normal, es un Valor 

6)  (λf : Nat → Bool. x) (λx: Nat. isZero(x))
    No es un programa, ya que en (λf : Nat → Bool. x), x es una variable libre


7)  (λf : Nat→Bool.f pred(zero)) (λx: Nat. isZero(x))
    a) Es un programa, pred(zero) es una constante, no hay variables libres
    b)  β-reducción => (f pred(zero)) [f := λx: Nat. isZero(x)] ==> (λx: Nat. isZero(x) pred(zero))
        β-reducción => isZero(x) [x := pred(zero)]              ==> isZero(pred(zero))
        Considerar el cálculo sin la regla pred(zero) → zero    ==> pred(zero) no esta definido
    Es forma normal, es un Error


8)  fix λy : Nat. succ(y)
    β-reducción => succ(y) [y := fix λy : Nat. succ(y)]

-}


