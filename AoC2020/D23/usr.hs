import Data.Char (digitToInt,intToDigit)
import Data.List (delete)

determineLabel max i xs 
    | i == 0 = determineLabel max max xs
    | otherwise = if i `elem` xs then determineLabel max (i-1) xs else i

move :: [Int] -> [Int]
move (x:xs) = bef ++ (destination:pickedUp) ++ after ++ [x]
    where
        (pickedUp,rest) = splitAt 3 xs
        destination = determineLabel 9 (x-1) (x:pickedUp)
        (bef,_:after) = break (==destination) rest

toResult :: [Int] -> String
toResult (1:xs) = foldr ((:).intToDigit) [] xs
toResult (x:xs) = toResult $ xs ++ [x]


game :: Int -> [Int] -> [Int]
game 0 xs = xs
game i xs = game (i-1) (move xs)

million = 10^6

star1 ls = toResult $ game 100 ls

star2 :: [Int] -> Integer
star2 ls = aux $ game (10*million) ls
    where
        aux (1:a:b:_) = (fromIntegral a)*(fromIntegral b)
        aux (x:xs) = aux $ xs ++ [x]

main :: IO ()
main = do
  contents <- getContents
  let val = map digitToInt contents
  let ls = val ++ [10..million]

  putStrLn $ "Star 1: " ++ (star1 val)
  putStrLn $ "Star 2: " ++ "Sorry, haskell implementation is too slow"
  --putStrLn $ "Star 2: " ++ (show $ star2 ls)
