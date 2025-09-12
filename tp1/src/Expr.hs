module Expr
  ( Expr (..),
    recrExpr,
    foldExpr,
    eval,
    armarHistograma,
    evalHistograma,
    mostrar,
  )
where

import Generador
import Histograma

-- | Expresiones aritméticas con rangos
data Expr
  = Const Float
  | Rango Float Float
  | Suma Expr Expr
  | Resta Expr Expr
  | Mult Expr Expr
  | Div Expr Expr
  deriving (Show, Eq)

-- recrExpr :: Const -> Rango -> Suma -> Resta -> Mult -> Div -> Expr -> a
recrExpr :: (Float -> a) -> (Float -> Float -> a) -> (a -> a -> a) -> (a -> a -> a) -> (a -> a -> a)
            -> (a -> a -> a) -> Expr -> a
recrExpr const rango suma resta multi divi expr =
  case expr of
    Const n -> const n
    Rango x y -> rango x y
    Suma e1 e2 -> suma (recrExprAux e1) (recrExprAux e2)
    Resta e1 e2 -> resta (recrExprAux e1) (recrExprAux e2)
    Mult e1 e2 -> multi (recrExprAux e1) (recrExprAux e2)
    Div e1 e2 -> divi (recrExprAux e1) (recrExprAux e2)
  where
    recrExprAux = recrExpr const rango suma resta multi divi

-- Observacion: Usamos "case expr of" para poder evitar usar ifThenElse y guardas ("|", "otherwise")
-- debido a que eso nos iba a llevar a tener que realizar muchas funciones auxiliares (una para evaluar cada tipo de data)

-- Ejemplos de uso de recrExpr:


-- foldExpr :: Const -> Rango -> Suma -> Resta -> Mult -> Div -> Expr -> a
foldExpr :: (Float -> a) -> (Float -> Float -> a) -> (a -> a -> a) -> (a -> a -> a) -> (a -> a -> a)
            -> (a -> a -> a) -> Expr -> a
foldExpr const rango suma resta multi divi expr =
  case expr of
    Const n -> const n
    Rango x y -> rango x y
    Suma e1 e2 -> suma (foldExprAux e1) (foldExprAux e2)
    Resta e1 e2 -> resta (foldExprAux e1) (foldExprAux e2)
    Mult e1 e2 -> multi (foldExprAux e1) (foldExprAux e2)
    Div e1 e2 -> divi (foldExprAux e1) (foldExprAux e2)
  where
    foldExprAux = foldExpr const rango suma resta multi divi

-- | Evaluar expresiones dado un generador de números aleatorios
eval :: Expr -> G Float
eval expr = recrExpr const rango suma resta multi divi expr
  where
    const x = valorConGen x             -- const :: Float -> G Float
    rango x y = dameUno (x, y)          -- rango :: Float -> Float -> G Float  
    suma = operacionesAleatorios (+)    -- suma :: G Float -> G Float -> G Float
    resta = operacionesAleatorios (-)   -- resta :: G Float -> G Float -> G Float
    multi = operacionesAleatorios (*)   -- multi :: G Float -> G Float -> G Float
    divi = operacionesAleatorios (/)    -- divi :: G Float -> G Float -> G Float


    valorConGen x gen = (x, gen)        -- Devuelve el par (elem, Gen) sin modificaciones (ya que es un unico elemento)

    operacionesAleatorios :: (Float -> Float -> Float) -> G Float -> G Float -> G Float
    operacionesAleatorios op x y gen = (op res1 res2, gen2) -- Tomo operacion a realizar, dameUno(a,b), dameUno(c,d) 
                                                            -- y el Gen que quiera usar
      where                                                     
        (res1, gen1) = x gen    -- Obtengo res1 y un nuevo Gen a partir de dameUno(a,b) y el Gen original
        (res2, gen2) = y gen1   -- Obtengo res2 y un nuevo Gen a partir de dameUno(c,d) y el Gen1

                                -- Tanto Gen1 como Gen2 como Gen van a tener un "estado" diferente
                                -- Es por eso que hacemos la diferenciacion entre los 3 en la funcion
                                -- Si usaramos el mismo generador para ambas operaciones, 
                                -- ambas obtendrían el mismo valor y generarían valores similares.


-- | @armarHistograma m n f g@ arma un histograma con @m@ casilleros
-- a partir del resultado de tomar @n@ muestras de @f@ usando el generador @g@.
armarHistograma :: Int -> Int -> G Float -> G Histograma
armarHistograma m n f g = (histograma m (lowerRange, upperRange) sampleValues, updatedF)
    where
        (sampleValues, updatedF) = muestra f n g
        (lowerRange, upperRange) = rango95 sampleValues

-- | @evalHistograma m n e g@ evalúa la expresión @e@ usando el generador @g@ @n@ veces
-- devuelve un histograma con @m@ casilleros y rango calculado con @rango95@ para abarcar el 95% de confianza de los valores.
-- @n@ debe ser mayor que 0.
evalHistograma :: Int -> Int -> Expr -> G Histograma
evalHistograma m n expr = armarHistograma m n (eval expr)

-- Podemos armar histogramas que muestren las n evaluaciones en m casilleros.
-- >>> evalHistograma 11 10 (Suma (Rango 1 5) (Rango 100 105)) (genNormalConSemilla 0)
-- (Histograma 102.005486 0.6733038 [1,0,0,0,1,3,1,2,0,0,1,1,0],<Gen>)

-- >>> evalHistograma 11 10000 (Suma (Rango 1 5) (Rango 100 105)) (genNormalConSemilla 0)
-- (Histograma 102.273895 0.5878462 [239,288,522,810,1110,1389,1394,1295,1076,793,520,310,254],<Gen>)

-- | Mostrar las expresiones, pero evitando algunos paréntesis innecesarios.
-- En particular queremos evitar paréntesis en sumas y productos anidados.
mostrar :: Expr -> String
mostrar = foldExpr 
 show                                -- funcion Const
 (\x y -> show x ++ "~" ++ show y)   -- funcion Rango
 (\s1 s2 -> s1 ++ " + " ++ s2)       -- funcion Suma
 (\s1 s2 -> s1 ++ " - " ++ s2)       -- funcion Resta
 (\s1 s2 -> s1 ++ " * " ++ s2)       -- funcion Mult
 (\s1 s2 -> s1 ++ " / " ++ s2)       -- funcion Div


-- Funcion auxiliar para chequear cuando necesitamos usar los parentesis del lado izquierdo de una cuenta:
checkParentesisIzq :: ConstructorExpr -> ConstructorExpr -> Bool
checkParentesisIzq ce1 ce2 = case (ce1, ce2) of
  -- Caso de constantes/rangos -> No necesitan ()
  (_, CEConst) -> False
  (_, CERango) -> False
  -- Casos mul/div con suma/resta
  (CEMult, CESuma) -> True
  (CEMult, CEResta) -> True
  (CEDiv, CESuma) -> True
  (CEDiv, CEResta) -> True
  -- Caso default (solo) -> No necesita ()
  _ -> False

-- Funcion auxiliar para chequear cuando necesitamos usar los parentesis del lado derecho de una cuenta:
checkParentesisDer :: ConstructorExpr -> ConstructorExpr -> Bool
checkParentesisDer ce1 ce2 = checkParentesisIzq ce1 ce2 || case (ce1, ce2) of
  (CEResta, CESuma) -> True
  (CEDiv, CEMult) -> True
  (CEDiv, CEDiv) -> True
  _ -> False

data ConstructorExpr = CEConst | CERango | CESuma | CEResta | CEMult | CEDiv
  deriving (Show, Eq)

-- | Indica qué constructor fue usado para crear la expresión.
constructor :: Expr -> ConstructorExpr
constructor (Const _) = CEConst
constructor (Rango _ _) = CERango
constructor (Suma _ _) = CESuma
constructor (Resta _ _) = CEResta
constructor (Mult _ _) = CEMult
constructor (Div _ _) = CEDiv

-- | Agrega paréntesis antes y después del string si el Bool es True.
maybeParen :: Bool -> String -> String
maybeParen True s = "(" ++ s ++ ")"
maybeParen False s = s
