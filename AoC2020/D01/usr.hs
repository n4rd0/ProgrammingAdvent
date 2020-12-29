import qualified Data.Set as Set
import Data.Maybe (fromJust)

head' :: [a] -> Maybe a
head' (x:_) = Just x
head' _ = Nothing

-- Simplest approach
star1 :: [Int] -> Int -> Maybe Int
star1 (l:ls) target = if (target-l) `elem` ls then Just $ l*(target-l) else star1 ls target
star1 [] _ = Nothing

-- Best complexity, using sets O(nlogn)
star1' :: [Int] -> Int -> Maybe Int
star1' ls target = head' $ map (\x -> x * (target-x)) $ filter (\e -> (target - e) `Set.member` set) ls
    where set = Set.fromList ls

-- (NOT mine) list comprehensions
star1'' :: [Int] -> Int -> Maybe Int
star1'' ls target = head' $ [a*b | a <- ls, b <- ls, a + b == target]

-- Uses the same approach as star1
star2 :: [Int] -> Int -> Int
star2 (l:ls) target = case star1 ls (target-l) of
        Just a -> a*l
        Nothing -> star2 ls target
star2 [] _ = 0

-- (NOT mine) list comprehensions
star2' :: [Int] -> Int -> Int
star2' ls target = head $ [a*b*c | a <- ls, b <- ls, c <- ls, a + b + c == target]

main :: IO ()
main = do
  contents <- getContents
  let numbers = (map read $ lines contents) :: [Int]
  putStrLn $ "Star 1: " ++ (show $ fromJust $ star1 numbers 2020)
  putStrLn $ "Star 2: " ++ (show $ star2 numbers 2020)

  print $ (star1 numbers 2020) == (star1' numbers 2020) && (star1 numbers 2020) == (star1'' numbers 2020)
  print $ (star2 numbers 2020) == (star2' numbers 2020)
