data Value = Symbol Char | Val Int deriving (Eq,Show)

toVal c = if c `elem` ['0'..'9'] then Val $ read [c] else Symbol c

toNum (Val v) = v
toNum _ = undefined

op (Symbol '+') (Val a) (Val b) = Val $ a + b
op (Symbol '*') (Val a) (Val b) = Val $ a * b
op s _ _ = error $ "Unknown symbol " ++ show s

evalSymbol :: (Value -> Bool) -> [Value] -> [Value]
evalSymbol isSymbol (v_:vals) = evalSymbol' [v_] vals
    where
        evalSymbol' (a:acc) (v:v2:vs) = if isSymbol v
            then evalSymbol' ((op v a v2):acc) vs
            else evalSymbol' (v:a:acc) (v2:vs)
        evalSymbol' acc [x] = x:acc
        evalSymbol' acc _ = acc

-- Evaluation when there are no parenthesis
evalFlat1 = evalSymbol (\x -> x==(Symbol '*') || x==(Symbol '+'))
evalFlat2 = evalSymbol (==(Symbol '*')) . evalSymbol (==(Symbol '+'))

evalParenthesis :: ([Value] -> [Value]) -> [Value] -> [Value] -> ([Value], [Value])
evalParenthesis evalFlat (v:vs) acc 
    | v == Symbol '(' = evalParenthesis evalFlat rest (expr ++ acc)
    | v == Symbol ')' = (vs, evalFlat $ reverse acc)
    | otherwise = evalParenthesis evalFlat vs (v:acc)
    where (rest, expr) = evalParenthesis evalFlat vs []
evalParenthesis evalFlat [] acc = ([], evalFlat $ reverse acc)

eval :: ([Value] -> [Value]) -> [Value] -> Value
eval evalFlat ss = head $ snd $ evalParenthesis evalFlat ss []

star f = sum . map (toNum . eval f)

main :: IO ()
main = do
  contents <- getContents
  let ls = map (map toVal . filter (/=' ')) $ lines contents

  putStrLn $ "Star 1: " ++ (show $ star evalFlat1 ls)
  putStrLn $ "Star 2: " ++ (show $ star evalFlat2 ls)
