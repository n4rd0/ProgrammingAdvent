type Command = (String, Int)

parse :: String -> [Command]
parse s = map (parse' . words) (lines s)
  where
      parse' [d, val] = (d, read val :: Int)

star1 :: [Command] -> Int
star1 = product . foldr f [0, 0]
  where
      f (d, val) [x, y]
        | d == "up"   = [x, y - val]
        | d == "down" = [x, y + val]
        | otherwise   = [x + val, y]

star2 :: [Command] -> Int
star2 = product . tail . foldl f [0, 0, 0]
  where
      f [aim, x, y] (d, val)
        | d == "up"   = [aim - val, x, y]
        | d == "down" = [aim + val, x, y]
        | otherwise   = [aim, x + val, y + aim * val]

main = do
    inp <- readFile "input.txt"
    let l = parse inp
    putStrLn $ "Star 1: " ++ (show . star1 $ l)
    putStrLn $ "Star 2: " ++ (show . star2 $ l)
