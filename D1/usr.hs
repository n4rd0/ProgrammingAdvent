
--Notice that in 1 and 1' there are no arguments (in 1'' there are), this is because
--they are a composition of funtions, so the compiler always knows what to do

--Not the best but it is one line
s1 :: [Int] -> Int --This is the function declaration, it isn't necessary
s1=sum.map((+(-2)).(flip div$3))

--More intuitive and tail recursive version
star1' :: [Int] -> Int
star1' = foldl toFuelAndAcc 0
    where
        toFuelAndAcc :: Int -> Int -> Int
        toFuelAndAcc acc i = acc + (i `div` 3) - 2

--Simplest to understand
star1'' :: [Int] -> Int
star1'' (x:xs) = fuel + star1'' xs
    where
        fuel = (x `div` 3) - 2
star1'' [] = 0

--Simpler than having another function to calculate the total fuel
--in stead of sum [3, 4] == 3 + sum [4] we do sum [3, 4] == 1 + sum [2, 4]
star2 :: [Int] -> Int
star2 (x:xs) = if x < 6 then star2 xs else fuel + star2 (fuel:xs) -- (fuel:xs) generates a new list with fuel as the head and xs as the tail
    where fuel = (x `div` 3) - 2
star2 [] = 0

main :: IO ()
main = do
  contents <- getContents
  let numbers = (map read $ lines contents) :: [Int]
  putStrLn $ "Star 1: " ++ (show $ star1' numbers)
  putStrLn $ "Star 2: " ++ (show $ star2 numbers)
  putStrLn $ "3 are Eq: " ++ (show $ (s1 numbers) == (star1' numbers) && (star1' numbers) == (star1'' numbers))