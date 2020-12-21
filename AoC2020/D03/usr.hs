
star1 :: [[Int]] -> (Int,Int) -> Int
star1 ls (x,y) = helper ls 1 0
    where
        len = (length . head) ls
        helper :: [[Int]] -> Int -> Int -> Int
        helper ls' t acc 
            | length ls' <= y = acc
            | otherwise = helper (k:ks) (t+1) acc'
            where
                (k:ks) = drop y ls'
                acc' = acc + (k !! ((x*t) `mod` len))

directions = [
    (1,1),
    (3,1),
    (5,1),
    (7,1),
    (1,2)
    ]

star2 :: [[Int]] -> Int
star2 ls = (product . map (star1 ls)) directions

main :: IO ()
main = do
  contents <- getContents
  let ls = map (map (\x -> if x=='#' then 1 else 0)) $ lines contents
  putStrLn $ "Star 1: " ++ (show $ star1 ls (3,1))
  putStrLn $ "Star 2: " ++ (show $ star2 ls)
