import qualified Data.Vector as V

directions = [
    (1,1),
    (3,1),
    (5,1),
    (7,1),
    (1,2)
    ]

star1 :: V.Vector (V.Vector Int) -> (Int,Int) -> Int
star1 ls (x,y) = foldr helper 0 [1..rows]
    where
        rows = V.length ls
        cols = V.length $ ls V.! 0
        helper :: Int -> Int -> Int
        helper t acc 
            | y*t >= rows = acc
            | otherwise = acc+thisVal
            where thisVal = (ls V.! (y*t)) V.! (x*t `rem` cols)

star2 :: V.Vector (V.Vector Int) -> Int
star2 ls = (product . map (star1 ls)) directions

main :: IO ()
main = do
  contents <- getContents
  let ls = map (map (fromEnum . (=='#'))) $ lines contents
  let v = V.fromList $ map V.fromList ls
  putStrLn $ "Star 1: " ++ (show $ star1 v (3,1))
  putStrLn $ "Star 2: " ++ (show $ star2 v)
