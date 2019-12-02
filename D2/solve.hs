target = 19690720

split :: Char -> String -> String -> [String]
split c acc (x:xs) = if x == c then acc : split c [] xs else split c (acc++[x]) xs
split _ acc [] = [acc]

obtainNew :: Int -> Int -> [Int] -> [Int]
obtainNew nf ns (z:_:_:rs) = (z:nf:ns:rs)

func :: Int -> Int -> Int -> Int
func x a b 
  | x == 1 = a + b
  | x == 2 = a * b
  | otherwise = error $ "Shouldn't be here " ++ (show x)

replace :: [Int] -> Int -> Int -> [Int]
replace (x:xs) c val 
  | c == 0 = val : xs
  | otherwise = x : replace xs (c-1) val

compute :: [Int] -> Int
compute xs = head $ solve xs xs 0
  where
    solve ls (99:_) _ = ls
    solve ls (x:y:z:t:rs) c = solve newLs cont (c+4)
      where
        newVal = func x (ls !! y) (ls !! z)
        newLs = replace ls t newVal
        cont = if t < c then rs else drop (c+4) newLs

    solve ls [] _ = ls

star1 :: [Int] -> Int
star1 = (compute . obtainNew 12 2)

star2 :: [Int] -> Int
star2 xs = loop ln 0 0
  where
    ln = length xs
    loop ln i j 
      | j == ln = loop ln (i+1) (i+1)
      | otherwise = if (compute . obtainNew i j) xs == target then 100*i+j else loop ln i (j+1)

main :: IO ()
main = do
  contents <- getContents
  let ns = split ',' [] contents --TODO: init is needed to remove \n
  let numbers = (map read ns) :: [Int]

  putStrLn $ "Star 1: " ++ (show $ star1 numbers)
  putStrLn $ "Star 2: " ++ (show $ star2 numbers)