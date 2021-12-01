countIncreasing :: [Int] -> Int
countIncreasing l1@(_:l2) = length $ filter (uncurry (<)) (zip l1 l2)

star1 :: [Int] -> Int
star1 = countIncreasing

star2 :: [Int] -> Int
star2 l1@(_:l2@(_:l3)) = countIncreasing $ zipWith3 (\a b c -> a + b + c) l1 l2 l3

main = do
    f <- readFile "input.txt"
    let inp = map read (lines f) :: [Int]
    putStrLn $ "Star 1: " ++ (show . star1 $ inp)
    putStrLn $ "Star 2: " ++ (show . star2 $ inp)
