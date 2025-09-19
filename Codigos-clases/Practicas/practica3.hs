{- 

Introducción de <=>
    A => B    B => A
   ------------------<=>i
        A <=> B

Eliminación de ⟺
    A <=> B    A            A <=> B    B
   --------------<=>e1     --------------<=>e2  
          B                       A


                            ========================== Ejercicio 1 ==========================

Cuando el valor de verdad de P y Q es V, mientras que el de S y T es F:

i.   (¬P ∨ Q)                                        === (V v F)                                                    === V
ii.  (P ∨ (S ∧ T) ∨ Q)                               === (V v (F ∧ F) v V)                                          === V
iii. ¬(Q ∨ S)                                        === ¬(V v F)                                                   === F
iv.  (¬P ∨ S) ⇔ (¬P ∧ ¬S)                            === (F ∨ F) <-> (F ∧ V) === F <-> F                            === V
v.   ((P ∨ S) ∧ (T ∨ Q))                             === (V v F) ∧ (F v V)   === V ∧ V                              === V
vi.  (((P ∨ S) ∧ (T ∨ Q)) ⇔ (P ∨ (S ∧ T) ∨ Q))       === (((V ∨ F) ∧ (F ∨ V)) <-> (V ∨ (F ∧ F) ∨ V))    === V <-> V === V
vii. (¬Q ∧ ¬S)                                       === F ∧ V                                                      === F



                            ========================== Ejercicio 3 ==========================

τ, σ, ρ, ζ tal que τ => σ es tautología y ρ => ζ es contradicción
Ver si son tautologías, contradicciones o contingencias y demostrarlo:

τ => σ es tautología significa que sus valores de verdad siempre se veran de la forma:
    V => V
    F => V
    F => F
    Nunca se da el caso donde τ es V y σ es F, tal que V => F === F 

ρ => ζ es contradicción significa que sus valores de verdad siempre se veran de la forma:
    V => F
    Nunca se da los casos donde:
        τ es V y σ es V, tal que V => V === V
        τ es F y σ es V, tal que F => V === V
        τ es F y σ es F, tal que F => F === V


i. (τ => σ) ∨ (ρ => ζ)
    Por enunciado, sabemos que τ => σ es tautología y ρ => ζ es contradicción:
    (τ => σ) es siempre verdadero y (ρ => ζ) es siempre falso, tal que
    (τ => σ) ∨ (ρ => ζ) sera siempre V v F === V

    Mas en profundidad, probamos los 3 casos posibles:
        (V => V) v (V => F) === V v F === V
        (F => V) v (V => F) === V v F === V
        (F => F) v (V => F) === V v F === V

    Luego, los 3 casos dan V, tal que (τ => σ) ∨ (ρ => ζ) es una tautologia


ii. (τ => ρ) ∨ (σ => ζ)
    τ y σ pueden tomar los valores tanto V como F, 
    ρ solo puede tomar V y ζ solo puede tomar F 
    (por lo visto en la demostacion de tautologia y contradiccion)

    (τ => V) ∨ (σ => F)
    (τ => V) ∨ (σ => F)

    Si τ toma V o F, el => sigue siendo V por el valor de ρ. Veamos el caso de σ entonces:
        V v (V => F) === V v F === V
        V v (F => F) === V v V === V

    Luego, los 2 casos dan V, tal que (τ => ρ) ∨ (σ => ζ) es una tautologia


iii. (ρ => σ) ∨ (ζ => σ)
    Mismos valores posibles que en ii, veamos el caso de σ:
        σ = V -> (V => V) v (F => V) === V v V === V
        σ = F -> (V => F) v (F => F) === F v V === V
    Luego, los 2 casos dan V, tal que (ρ => σ) ∨ (ζ => σ) es una tautologia
    


                            ========================== Ejercicio 5 ==========================

i. Modus ponens relativizado: 

-------------------------------------ax              -------------------ax
A, (ρ => σ), ρ ⊢ A => (ρ => σ) => τ                 A, (ρ => σ), ρ ⊢ A
-------------------------------------------------------------------------=>e        ---------------------------------------ax
(ρ => σ => τ ), (ρ => σ), ρ ⊢ (ρ => σ) => τ (llamo 'A' a (ρ => σ => τ ))            (ρ => σ => τ ), (ρ => σ), ρ ⊢ (ρ => σ)
---------------------------------------------------------------------------------------------------------------------------=>e
(ρ => σ => τ ), (ρ => σ), ρ ⊢ τ
----------------------------------=>i
(ρ => σ => τ ), (ρ => σ) ⊢ ρ => τ
------------------------------------=>i
(ρ => σ => τ ) ⊢ (ρ => σ) => ρ => τ
----------------------------------------=>i
⊢ (ρ => σ => τ ) => (ρ => σ) => ρ => τ



ii. Introducción de la doble negación:

-----------ax     ----------ax
 ρ,¬ρ ⊢ ¬ρ         ρ,¬ρ ⊢ ρ 
---------------------------¬e
         ρ,¬ρ ⊢ ⊥
        -----------¬i
         ρ ⊢ ¬¬ρ
        ------------=>i
         ⊢ ρ => ¬¬ρ


iii. Eliminación de la triple negación: 

--------------ax  -------------ax
 ¬¬¬ρ, ρ ⊢ ¬ρ      ¬¬¬ρ, ρ ⊢ ρ
-------------------------------¬e
 ¬¬¬ρ, ρ ⊢ ⊥
--------------¬i
 ¬¬¬ρ ⊢ ¬ρ
--------------=>i
 ⊢ ¬¬¬ρ => ¬ρ


iv. Contraposición:
                                               -------------------ax   ------------------------ax
                                                ρ => σ, ¬σ, ρ ⊢ ρ       ρ => σ, ¬σ, ρ ⊢ ρ => σ
-------------------ax                          -----------------------------------------------=>e
ρ => σ, ¬σ, ρ ⊢ ¬σ                              ρ => σ, ¬σ, ρ ⊢ σ      
------------------------------------------------------------------¬e
ρ => σ, ¬σ, ρ ⊢ ⊥ 
------------------¬i
ρ => σ, ¬σ ⊢ ¬ρ
------------------=>i
ρ => σ ⊢ ¬σ => ¬ρ
-------------------------=>i
⊢ (ρ => σ) => (¬σ => ¬ρ)


v. Adjunción: ((ρ ∧ σ) => τ ) <=> (ρ => σ => τ )

Para demostrar el <=>, debo demostrar 2 subproblemas:
    1) ⊢ ((ρ ∧ σ) => τ ) => (ρ => σ => τ )
    2) ⊢ (ρ => σ => τ ) => ((ρ ∧ σ) => τ ) 
Veamos:

1)







----------------------------------=>i
⊢ ((ρ ∧ σ) => τ ) => (ρ => σ => τ )





vi. de Morgan (I):

¬(ρ ∨ σ) <=> (¬ρ ∧ ¬σ)


vii. de Morgan (II): ¬(ρ ∧ σ) <=> (¬ρ ∨ ¬σ).
Para la dirección => es necesario usar principios de razonamiento clásicos.


viii. Conmutatividad (∧): 

------------------ax        ------------------ax
(ρ ∧ σ) ⊢ (ρ ∧ σ)           (ρ ∧ σ) ⊢ (ρ ∧ σ)
------------------∧e2      ------------------∧e1
(ρ ∧ σ) ⊢ σ                (ρ ∧ σ) ⊢ ρ
----------------------------------------∧i
(ρ ∧ σ) ⊢ σ ∧ ρ
------------------=>i
⊢ (ρ ∧ σ) => (σ ∧ ρ)


ix. Asociatividad (∧): ((ρ ∧ σ) ∧ τ ) <=> (ρ ∧ (σ ∧ τ ))


x. Conmutatividad (∨):

                        ---------------ax           ---------------ax    
                        (ρ ∨ σ), ρ ⊢ ρ              (ρ ∨ σ), σ ⊢ σ
------------------ax    --------------------Vi2     ---------------------Vi1
(ρ ∨ σ) ⊢ (ρ ∨ σ)       (ρ ∨ σ), ρ ⊢ (σ ∨ ρ)        (ρ ∨ σ), σ ⊢ (σ ∨ ρ)                                                      
-------------------------------------------------------------------------Ve
(ρ ∨ σ) ⊢ σ ∨ ρ                                                         
------------------=>i
⊢ (ρ ∨ σ) (σ ∨ ρ)


xi. Asociatividad (∨): ((ρ ∨ σ) ∨ τ ) <=> (ρ ∨ (σ ∨ τ ))

















 -}