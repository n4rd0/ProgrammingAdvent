star1 (x:xs) = sum $ map fromEnum $ zipWith (>) xs (x:xs)
star2 (x:y:xs) = star1 $ map (\(a,b,c) -> a+b+c) $ zip3 xs (y:xs) (x:y:xs)

main :: IO ()
main = do
  contents <- getContents
  let numbers = (map read $ lines contents) :: [Int]
  putStrLn $ "Star 1: " ++ (show $ star1 numbers)
  putStrLn $ "Star 2: " ++ (show $ star2 numbers)
