split :: Char -> String -> String -> [String]
split c acc (x:xs) = if x == c then acc : split c [] xs else split c (acc++[x]) xs
split _ acc [] = [acc]

--The list is generated backwards 1230 -> [0, 3, 2, 1]
toLs :: Int -> [Int]
toLs 0 = []
toLs x = mod x 10 : toLs (div x 10)

accepted :: [Int] -> Bool
accepted (x:y:xs) = x >= y && accepted (y:xs)
accepted _ = True

acceptedDoub :: [Int] -> Bool
acceptedDoub (x:y:xs) = x == y || acceptedDoub (y:xs)
acceptedDoub _ = False

acceptedDoubOnce :: [Int] -> Bool
acceptedDoubOnce ls@(x:y:z:_) = (x == y && y /= z) || aux ls
    where
        aux (x:y:z:t:rs) = if y == z && z /= t && x /= y then True else aux (y:z:t:rs)
        aux (x:y:z:[]) = y == z && x /= y --This is equiv to [x,y,z]

star1 :: [Int] -> Int
star1 = length . filter accepted . filter acceptedDoub . map toLs

star2 :: [Int] -> Int
star2 = length . filter acceptedDoubOnce . filter accepted . map toLs

main :: IO ()
main = do
  contents <- getContents
  let [lb,ub] = (map read $ split '-' [] contents) :: [Int]

  let t = 10^5
  let v = [x | x <- [lb..ub], mod x 10 >= div x t]

  putStrLn $ "Star 1: " ++ (show $ star1 v)
  putStrLn $ "Star 2: " ++ (show $ star2 v)