import Data.List (sort)

split = foldr (\c acc@(y:ys) -> if c == ',' then []:acc else (c:y):ys) [[]]

triangNum n = n*(n+1) `div` 2

totalFuelCost f ls pos = sum $ map (f.abs.(pos-)) ls

--More efficient ways of computing the first star
--First, the optimal element has to be within the list
star1 ls = minimum $ map (totalFuelCost id ls) ls
--Second, the optimal element is the median
star1' ls = (totalFuelCost id ls) $ (!! (length ls `div` 2)) $ sort ls

star f ls = minimum $ map (totalFuelCost f ls) [minimum ls..maximum ls]

main :: IO ()
main = do
  contents <- getContents
  let crabs = map read $ split contents :: [Int]
  putStrLn $ "Star 1: " ++ (show $ star1' crabs)
  putStrLn $ "Star 2: " ++ (show $ star triangNum crabs)
