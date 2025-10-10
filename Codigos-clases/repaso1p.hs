type Tono = Integer
data Melodia = Silencio | Nota Tono | Secuencia Melodia Melodia | Paralelo [Melodia] deriving Show

foldMelodia :: c -> (Tono -> c) -> (c -> c -> c) -> ([c] -> c) -> Melodia -> c
foldMelodia cSilencio cNota cSecuencia cParalelo melo = case melo of
 Silencio -> cSilencio
 Nota tono -> cNota tono
 Secuencia melo1 melo2 -> cSecuencia (rec melo1) (rec melo2)
 Paralelo l -> cParalelo (map rec l)
 where rec = foldMelodia cSilencio cNota cSecuencia cParalelo
 
duracionTotal :: Melodia -> Integer
duracionTotal = foldMelodia 1 (const 1) (+) maximum


-- IDEA: Por cómo funciona Secuencia, en cada llamado recursivo necesito poder decidir por cuánto quiero truncar. Para lograrlo, mi resultado recursivo va a ser una función que tome un número (por cuánto truncar) y actúe en consecuencia. Quizás ayuda recordar que toda función toma 1 parámetro solamente (y devuelve otra función si corresponde)
-- En truncar, el c de foldMelodia va a ser (Integer -> Melodia)

truncar :: Melodia -> Integer -> Melodia
truncar = foldMelodia 
 (const Silencio)
 (\tono _ -> Nota tono)
 (\truncarMelo1 truncarMelo2 i -> let duracionMelo1Truncada = (duracionTotal (truncarMelo1 i)) in
  if i <= duracionMelo1Truncada
   then truncarMelo1 i
   else Secuencia (truncarMelo1 i) (truncarMelo2 (i - duracionMelo1Truncada)))
 (\listaDeFunciones i -> Paralelo (map (\cadaFuncion -> cadaFuncion i) listaDeFunciones))



-- BONUS
-- En vez de: 
--  (map (\cadaFuncion -> cadaFuncion i) listaDeFunciones)
-- también era válido:
--  [cadaFuncion i | cadaFuncion <- listadeFunciones]
