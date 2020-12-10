import qualified Data.Map as Map
import Data.List (sort)
import Data.Maybe (fromJust)

continuations :: [Int] -> [[Int]]
continuations (x:xs) = (takeWhile ((<=3) . (+(-x))) xs) : continuations xs
continuations _ = []

paths :: Map.Map Int [Int] -> [Int] -> Map.Map Int Int -> Map.Map Int Int
paths m (n:ns) acc = paths m ns (Map.insert n tot acc)
    where
        tot = if lookup == 0 then 1 else lookup --The if is for the last num
        lookup = sum $ map (fromJust . (flip Map.lookup) acc) possibilites
        possibilites = fromJust $ n `Map.lookup` m
paths _ [] acc = acc

star1 = (\(_,one,three) -> one*three) . foldl aux (0,0,1) . sort
  where aux (prev,one,three) x = if x-prev == 1
        then (x,one+1,three)
        else if x-prev == 3
            then (x,one,three+1)
            else (x,one,three)

star2 ls' = foldr retrieve 0 [1,2,3]
    where
        ls = sort ls'
        conts = Map.fromList $ zip ls (continuations ls)
        m = paths conts (reverse ls) Map.empty
        retrieve n acc = case n `Map.lookup` m of 
            Just res -> acc + res
            Nothing -> 0

main :: IO ()
main = do
  contents <- getContents
  let ls = (map read $ lines contents) :: [Int]
  putStrLn $ "Star 1: " ++ (show $ star1 ls)
  putStrLn $ "Star 2: " ++ (show $ star2 ls)
