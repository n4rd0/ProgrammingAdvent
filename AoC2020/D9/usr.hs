import Data.Maybe (fromJust)

sums :: [Int] -> [Int]
sums (l:ls) = map (+l) ls ++ sums ls
sums _ = []

findRange :: Int -> [Int] -> Int -> [Int]
findRange target nss@(n:ns) i = if s == target
    then range
    else if s < target
        then findRange target nss (i+1)
        else findRange target ns 2
        where
            range = take i nss
            s = sum range
findRange _ [] _ = error "Can't find range"

--Lists are better than sets due to the sizes used here

star1 nums
    | length nums <= preamble = error "Conditions for star 1 aren't met"
    | otherwise = if not (a `elem` sums (b:bef)) then a else star1 (bef++a:after)
    where
        (b:bef,a:after) = splitAt preamble nums

star2 nums = minimum range + maximum range
    where
        range = findRange (star1 nums) nums 2

preamble = 25

main :: IO ()
main = do
  contents <- getContents
  let ls = (map read $ lines contents) :: [Int]
  putStrLn $ "Star 1: " ++ (show $ star1 ls)
  putStrLn $ "Star 2: " ++ (show $ star2 ls)
