import Data.List

parse :: String -> [String] -> [String]
parse del = foldr (\w l@(x:xs) -> if null w then del:l else ((del++w)++x):xs) [del]

star1 :: [String] -> Int
star1 xs = sum . map (length . nub) $ parse "" xs

star2 :: [String] -> Int
star2 xs = sum . map (length . nub . foldl1 intersect) $ map words $ parse " " xs

main = do
  inp <- getContents
  let ls = lines inp
  putStrLn $ "Star 1: " ++ (show $ star1 ls)
  putStrLn $ "Star 2: " ++ (show $ star2 ls)
