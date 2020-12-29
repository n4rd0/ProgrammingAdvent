import qualified Data.Map as Map
import Data.List (sort)
import Data.Maybe (fromJust)

continuations :: [Int] -> [[Int]]
continuations (x:xs) = takeWhile ((<=3) . (+(-x))) xs : continuations xs
continuations _ = []

paths :: Map.Map Int [Int] -> [Int] -> Map.Map Int Integer -> Map.Map Int Integer
paths m (n:ns) acc = paths m ns (Map.insert n tot acc)
    where
        tot = if lookup == 0 then 1 else lookup --The if is for the last num
        lookup = sum $ map (acc Map.!) possibilites
        possibilites = m Map.! n
paths _ [] acc = acc

star1 ls = product $ (map count [1,3]) <*> [zipped]
  where
    count n = length . filter (==n)
    zipped = zipWith (-) (tail ls') ls'
    ls' = 0:(sort ls) ++ [(maximum ls) + 3]

star2 ls = foldr retrieve 0 [1,2,3]
    where
        ls' = sort ls
        conts = Map.fromList $ zip ls' (continuations ls')
        m = paths conts (reverse ls') Map.empty
        retrieve n = (+) (Map.findWithDefault 0 n m)

main :: IO ()
main = do
  contents <- getContents
  let ls = (map read $ lines contents) :: [Int]
  putStrLn $ "Star 1: " ++ (show $ star1 ls)
  putStrLn $ "Star 2: " ++ (show $ star2 ls)
