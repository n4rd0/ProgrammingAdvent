import qualified Data.Set as Set

type Point = (Int, Int)

--PARSING
split :: Char -> String -> String -> [String]
split c acc (x:xs) = if x == c then acc : split c [] xs else split c (acc++[x]) xs
split _ acc [] = [acc]

directions :: [String] -> String
directions ((x:_):xs) = x : directions xs
directions [] = []

nums :: [String] -> [Int]
nums ((_:n):ns) = (read n :: Int) : nums ns
nums [] = []

getPoints :: String -> [Int] -> Point -> [Point]
getPoints (s:ss) (n:ns) p = res ++ getPoints ss ns (last res)
  where
    res = allPoints (func s) n p

    func 'U' (x,y) = (x,y+1)
    func 'D' (x,y) = (x,y-1)
    func 'R' (x,y) = (x+1,y)
    func  _  (x,y) = (x-1,y)

    allPoints _ 0 _ = []
    allPoints f n' p' = nextp : allPoints f (n'-1) nextp
      where nextp = f p'

getPoints [] [] _ = []
-- /PARSING

manhDist :: Point -> Int
manhDist (x,y) = (abs x) + (abs y)

star1 :: [Point] -> Int
star1 = minimum . map manhDist

star2 :: [Point] -> [Point] -> [Point] -> Int
star2 p1 p2 inter = minimum $ zipWith (+) (map (getD p1') inter) (map (getD p2') inter)
  where 
    p1' = addDistance p1 1 --Since the fst point is 1 unit off the centre
    p2' = addDistance p2 1
    set = Set.fromList p1

    getD ((x,y,d):ls) pt@(x',y')
      | x == x' && y == y' = d
      | otherwise = getD ls pt

    addDistance ((x,y):ps) n = (x,y,n) : addDistance ps (n+1)
    addDistance [] _ = []


main :: IO ()
main = do
  contents <- getContents
  let ls = map (split ',' []) $ lines contents
  let sone = head ls
  let stwo = last ls

  let p1 = getPoints (directions sone) (nums sone) (0,0)
  let p2 = getPoints (directions stwo) (nums stwo) (0,0)

  let set = Set.fromList p1
  let inter = filter (flip Set.member $ set) p2

  putStrLn $ "Star 1: " ++ (show $ star1 inter)
  putStrLn $ "Star 2: " ++ (show $ star2 p1 p2 inter)