import qualified Data.Map.Strict as M

split = foldr (\c acc@(y:ys) -> if c == ',' then []:acc else (c:y):ys) [[]]

parse line = ((ax,ay),(bx,by))
  where
    [a,_,b] = words line
    [ax,ay] = map read (split a) :: [Int]
    [bx,by] = map read (split b) :: [Int]

diff ((ax,ay),(bx,by)) = (bx-ax,by-ay)

toDir (0,0) = (0,0)
toDir (0,y) = if y > 0 then (0,1) else (0,-1)
toDir (x,0) = if x > 0 then (1,0) else (-1,0)
toDir (x,y) = (x `div` ratio,y `div` ratio)
  where ratio = gcd (abs x) (abs y)

arrPoints pair@((x,y),to) = to : takeWhile (/=to) (map newPoint [0..])
  where
    (dx,dy) = toDir $ diff pair
    newPoint mult = (x+mult*dx,y+mult*dy)

addToMap m point = M.insertWith (+) point 1 m

star1 = star2 . filter ((==0) . uncurry (*) . diff)

star2 = M.size . M.filter (>1) . foldl addToMap M.empty . foldr1 (++) . map arrPoints

main :: IO ()
main = do
  contents <- getContents
  let points = map parse $ lines contents
  putStrLn $ "Star 1: " ++ (show $ star1 points)
  putStrLn $ "Star 2: " ++ (show $ star2 points)
