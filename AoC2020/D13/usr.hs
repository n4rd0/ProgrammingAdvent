import Data.List.Split (splitOn)
import Data.Maybe (fromJust)

--gist.github.com/lovasoa/0e52bcbc937f3d26224f303669ca2b0f
inverse b a =
  let
    next a b = zipWith (-) a $ map (*(head $ zipWith div a b)) b
    l = [a,0] : [b,1] : zipWith next l (tail l)
  in
    head $ tail $ head $ filter ((==1).head) l

--Chinese Remainder Theorem algorithm
crt :: ([Integer], [Integer]) -> Integer
crt (remainders, mods) = sumation `mod` modProd
    where
        sumation = sum $ zipWith3 (\x y z -> x*y*z) remainders inverses ts
        modProd = product mods
        ts = map (\x -> modProd `div` x) mods
        inverses = zipWith inverse ts mods

star1 depart ls = wait * busID
    where
        (wait,busID) = (minimum . toWaitIDPair) ls'
        ls' = foldr remNothing [] ls
        remNothing Nothing acc = acc
        remNothing (Just a) acc = a:acc
        toWaitIDPair = map (\x -> (x - (depart `mod` x),x))

star2 ls = (crt . unzip . convert . zip [0,(-1)..]) ls
    where
        justs = filter (\(_,y) -> y /= Nothing)
        toRemModuloPair = (\(x,y) -> ((y+x) `mod` y, y)).(\(x,y)->(x,fromJust y))
        convert = map toRemModuloPair . justs

main :: IO ()
main = do
  contents <- getContents
  let ls = lines contents
  let depart = read (head ls) :: Integer
  let rs = map (\x -> if x == "x" then Nothing else Just (read x :: Integer)) (splitOn  "," ((head . tail) ls))

  putStrLn $ "Star 1: " ++ (show $ star1 depart rs)
  putStrLn $ "Star 2: " ++ (show $ star2 rs)
