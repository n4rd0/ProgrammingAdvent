import Data.Maybe (fromJust)

sums :: [Int] -> [Int]
sums (l:ls) = map (+l) ls ++ sums ls
sums _ = []

findRange :: Int -> [Int] -> [Int] -> Int -> [Int] -> [Int]
findRange target nss@(n:ns) (r:rest) s range = if s' == target
    then r:range
    else if s' < target
        then findRange target nss rest s' (r:range)
        else findRange target ns ns 0 []
        where
            s' = s + r
findRange _ [] _ _ _ = error "Can't find range"

--Lists are better than sets due to the sizes used here

star1 nums
    | length nums <= preamble = error "Conditions for star 1 aren't met"
    | otherwise = if not (a `elem` sums (b:bef)) then a else star1 (bef++a:after)
    where
        (b:bef,a:after) = splitAt preamble nums

star2 nums = minimum range + maximum range
    where range = findRange (star1 nums) nums nums 0 []

preamble = 25

main :: IO ()
main = do
  contents <- getContents
  let ls = (map read $ lines contents) :: [Int]
  putStrLn $ "Star 1: " ++ (show $ star1 ls)
  putStrLn $ "Star 2: " ++ (show $ star2 ls)
