width = 25
height = 6

--TODO: Use a foldl here
count :: (Eq a) => [a] -> a -> Int
count ls c = foldl (\acc c' -> if c' == c then acc + 1 else acc) 0 ls

replace :: (Eq a) => a -> a -> [a] -> [a]
replace from to = foldr (\c acc -> if c == from then to : acc else c : acc) []

toLayers :: Int -> String -> [String]
toLayers _ [] = []
toLayers len xs = beg : toLayers len end
    where
        (beg, end) = splitAt len xs

--Generates tuples (count 0s in str, str) and finds the best in lexicographic order
minLayer :: [String] -> String
minLayer = snd . minimum . map (\s -> (count s '0', s))

res :: String -> Int
res xs = (count xs '1') * (count xs '2')

order :: [String] -> [String]
order ([]:_) = []
order xs = region : order rest
    where
        region = map head xs
        rest = map tail xs

pixelVal :: String -> Char
pixelVal ('2':xs) = pixelVal xs
pixelVal (x:_) = x
pixelVal [] = '2'

join :: Char -> [String] -> String
join c (s:ss) = (s ++ [c]) ++ (join c ss)
join _ _ = []

star1 :: String -> Int
star1 = res . minLayer . toLayers (width * height)

star2 :: String -> String
star2 = beautify . calc
    where
        calc = map pixelVal . order . toLayers (width * height)
        beautify = replace '0' ' ' . join '\n' . toLayers width

main :: IO ()
main = do
  contents <- getContents
  let ls = head $ lines contents

  putStrLn $ "Star 1: " ++ (show $ star1 ls)
  putStrLn $ "Star 2: \n" ++ (star2 ls)
