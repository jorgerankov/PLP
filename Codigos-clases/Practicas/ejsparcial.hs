type Tono       = Integer
data Melodia    =  Silencio
                | Nota Tono
                | Secuencia Melodia Melodia
                | Paralelo [Melodia]

foldMelodia :: b -> (Tono -> b) -> (b -> b -> b) -> ([b] -> b) -> Melodia -> b
foldMelodia cSilencio cNota cSecuencia cParalelo m =
    case m of 
        Silencio            -> cSilencio
        Nota t              -> cNota t
        Secuencia m1 m2     -> cSecuencia (rec m1) (rec m2)
        Paralelo ms         -> cParalelo (map rec ms) 
    
    where rec = foldMelodia cSilencio cNota cSecuencia cParalelo


duracionTotal :: Melodia -> Integer
duracionTotal = foldMelodia 
                1 
                (const 1)
                (+) ~= (\rec1 rec2 -> rec1 + rec2)
                maximum

{-
Ejemplos de truncar:
    truncar Silencio 1 -> Silencio
    truncar Silencio 3 -> Silencio
    truncar (Secuencia (Nota 1) Silencio) 1 -> Nota 1
    truncar (Secuencia (Secuencia Silencio Silencio) (Secuencia Silencio Silencio)) 3
    -> Secuencia (Secuencia Silencio Silencio) Silencio
-}

truncar :: Melodia -> Integer -> Melodia
truncar m n =    foldMelodia
                    (const Silencio) {- \i -> Silencio -}
                    (\t _ -> Nota t)
                    (\f1 f2 n -> 
                        let m1 = f1 n 
                                duracionRestante = n - duracionTotal m1
                        in if duracionRestante > 0 then Secuencia m1 (f2 duracionRestante) else m1)
                    (\fs n -> map ($n) fs)


recMelodia :: b -> (Tono -> b) -> (Melodia -> Melodia -> b -> b -> b) -> ([Melodia] -> [b] -> b) -> Melodia -> b
recMelodia cSilencio cNota cSecuencia cParalelo m =
    case m of
        Silencio        -> cSilencio
        Nota t          -> cNota t
        Secuencia m1 m2 -> cSecuencia m1 m2 (rec m1) (rec m2)
        Paralelo ms     -> cParalelo ms (map rec ms)
    
    where rec = recMelodia cSilencio cNota cSecuencia cParalelo


{- 
Deduccion natural
Demostrar el siguiente teorema usando Deduccion Natural, sin utilizar principios clasicos: 
ρ => (σ V (ρ => τ )) => (σ V τ)

                                                                        ---------------------------ax   ----------------------ax
                                                                        ρ, σ V (ρ => τ), ρ ⊢ ρ => τ     ρ, σ V (ρ => τ), ρ ⊢ ρ
                                    -----------------------ax           ------------------------------------------------------=>e
                                    ρ, σ V (ρ => τ), σ ⊢ σ              ρ, σ V (ρ => τ), ρ ⊢ τ
------------------------------ax    ---------------------------Vi1      --------------------------Vi2  
ρ, σ V (ρ => τ) ⊢ σ V (ρ => τ)      ρ, σ V (ρ => τ), σ ⊢ σ V τ          ρ, σ V (ρ => τ), ρ ⊢ σ V τ
---------------------------------------------------------------------------------------------------Ve
ρ, σ V (ρ => τ) ⊢ (σ V τ)
---------------------------=>i
ρ ⊢ σ V (ρ => τ) => (σ V τ)
--------------------------------=>i
⊢ ρ => (σ V (ρ => τ)) => (σ V τ)



===================== Razonamiento Ecuacional e Induccion Estructural ===================== 

Primer paso: predicado unario => Lo q quiero probar lo tengo q poder reescribir tal que: ∀t :: AB a . P(t)

P(t) := ∀u :: AB a . altura t >= altura (zipAB t u)

Caso base: P(Nil)
    ∀u :: AB a . altura Nil >= altura (zipAB Nil u)
        altura Nil >= altura (zipAB Nil u)  
        0 >= altura (zipAB Nil u)                   {A0}
        0 >= altura (const Nil u)                   {Z0}
        0 >= altura ((\x -> \y -> x) Nil u)          {C}
        0 >= altura (Nil)                           {Beta x2}
        0 >= 0                                      {A0}
        True
    Se cumple el caso base


Caso inductivo: ∀i,d :: AB a, ∀r :: a
    (P(i) ∧ P(d) => P(Bin i r d))
    -------------
          HI

    HI1 : P(i) = ∀u :: AB a . altura i ≥ altura (zipAB i u)
    HI2 : P(d) = ∀u :: AB a . altura d ≥ altura (zipAB d u)


Tesis Inductiva: 
    \t  == zipAB (Bin i r d)
    B   ==  Bin (zipAB i i’) (r,r’) (zipAB d d’)

    altura (Bin i r d)             >= altura (zipAB (Bin i r d) u)
    1 + max (altura i) (altura d)  >= altura (zipAB (Bin i r d) u)                  {A1}
    1 + max (altura i) (altura d)  >= altura (\t -> case t of                
                                                    Nil             -> Nil
                                                    Bin i' r' d'    -> B (macro)
                                            u)                                  {Z1}
    1 + max (altura i) (altura d)  >= altura (case u of 
                                                Nil -> Nil
                                                Bin i' r' d' -> B)                  {Beta}
    Por lema de generacion, tenemos:
        u = Nil
        u = Bin (i' r' d')

        Caso u = nil:
            1 + max (altura i) (altura d) >= altura (case Nil of
                                                        Nil -> Nil                          
                                                        Bin i' r' d' -> B)
            
            1 + max (altura i) (altura d) >= altura Nil                                             {Case}
            1 + max (altura i) (altura d) >= 0                                                      {A0}
            (altura i) >= 0                                                                         {LEMA}
            (altura d) >= 0                                                                         {LEMA}
        
            Por Int, max (altura i) (altura d) >= 0
            Por Int, 1 + max (altura i) (altura d) >= 0

        
        Caso u = Bin (i' r' d')
            1 + max (altura i) (altura d) >= altura (case Bin (i' r' d') of
                                                        Nil -> Nil
                                                        Bin i' r' d' -> B)

            1 + max (altura i) (altura d) >= altura (Bin (zipAB i i') (r r') (zipAB d d'))          {Case}
            1 + max (altura i) (altura d) >= 1 + max (altura (zipAB i i')) (altura (zipAB d d'))    {A1}

            Por HI: altura i >= altura (zipAB i i') ∧ 
                    altura d >= altura (zipAB d d')

            Por Int, x >= y ∧ z >= w, para todo x, y, z, w :: Int
                    => max x z >= max y w
            Entonces,
                max (altura i) (altura d) >= max (altura (zipAB i i')) (altura (zipAB d d'))


-}