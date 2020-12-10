import Data.List

tribo :: [Integer]
tribo = 0:0:1:zipWith (+) (zipWith (+) tribo $ tail tribo) (tail $ tail tribo)

diffs :: [Integer] -> [Integer]
diffs [x] = [3]
diffs (x:y:xs) = (y-x):diffs (y:xs)

star1 :: [Integer] -> Integer
star1 = product . foldl (\[ones, threes] x -> if x == 1 then [ones+1, threes] else [ones, threes+1]) [0,0]

star2 :: [Integer] -> [Integer]
star2 = foldl (\[prod, ones] x -> if x == 1 then [prod, ones+1] else [prod*(ways ones), 0]) [1, 0]
  where ways n = tribo !! (fromIntegral $ n+2)

main = do
  inp <- getContents
  let l@(x:ls) = sort $ map (read::String->Integer) (lines inp)
  let allDiffs = x:(diffs l)
  putStrLn $ "Star 1: " ++ (show $ star1 allDiffs)
  putStrLn $ "Star 2: " ++ (show $ (star2 allDiffs)!!0)