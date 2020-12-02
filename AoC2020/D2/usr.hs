
xor a b = (a || b) && (not (a && b))

--String split, based on words
split :: (Char -> Bool) -> String -> [String]
split p s =  case dropWhile p s of
                      "" -> []
                      s' -> w : split p s''
                            where (w, s'') = break p s'

--Parse each line
parse :: [String] -> (Int, Int, Char, String)
parse (is:cs:s:[]) = (a, b, c, s)
  where
    ints = (map read $ split (=='-') is) :: [Int]
    a = head ints
    b = head $ tail ints
    c = head cs
parse _ = error "Parse error"


star1 :: (Int, Int, Char, String) -> Bool
star1 (lo, hi, c, s) = lo <= occurences && occurences <= hi
      where
        occurences = length $ filter (==c) s

star2 :: (Int, Int, Char, String) -> Bool
star2 (lo, hi, c, s) = (indexEq lo) `xor` (indexEq hi)
      where
        indexEq idx = (s !! (idx-1)) == c

main :: IO ()
main = do
  contents <- getContents
  let ls = map (parse . words) $ lines contents
  putStrLn $ "Star 1: " ++ (show $ length $ filter star1 ls)
  putStrLn $ "Star 2: " ++ (show $ length $ filter star2 ls)
