sol1 :: [Int] -> Int
sol1 ls@(_:ls') = foldr (\(a,b) s -> if a<b then s+1 else s) 0 (zip ls ls')

sol2 :: [Int] -> Int
sol2 ls@(_:(_:(_:ls'))) = foldr (\(a,b) s -> if a<b then s+1 else s) 0 (zip ls ls')

main = do
    file <- readFile "input.txt"
    let xs = map read (lines file) :: [Int]
    putStrLn $ "Star 1: " ++ (show $ sol1 xs)
    putStrLn $ "Star 2: " ++ (show $ sol2 xs)