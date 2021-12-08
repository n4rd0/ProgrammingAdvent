import qualified Data.Set as S

splitOn ch = foldr (\c acc@(y:ys) -> if c == ch then []:acc else (c:y):ys) [[]]

knownSegments = [(1,2),(7,3),(4,4),(8,7)]

rules = [
  ((5,2, 4),2),
  ((5,2, 1),3),
  ((6,1, 1),6),
  ((6,4, 4),9)
  ]

parse ls = map (map S.fromList . words) $ splitOn '|' ls

deduct [x,y] m
  | S.size x == 5 = (5,x):(0,y):m
  | otherwise = (5,y):(0,x):m
deduct (x:xs) m = deduct xs' m'
  where
    (xs',m') = if option == [] then (xs++[x],m) else (xs,(snd $ head option,x):m)
    option = filter (flip elem eachInCommon.fst) rules
    inCommon (n,repr) = (S.size x, S.size $ x `S.intersection` repr, n)
    eachInCommon = map inCommon m

s2 ls = foldl (\acc x -> acc*10+x) 0 nums
  where
    nums = map (\x -> fst $ head $ filter ((==x).snd) deductedValues) output
    deductedValues = deduct (filter (flip elem [5,6]. S.size) input) knownMapping
    knownMapping = map (\(n,size) -> (n,head $ filter ((==size). S.size) input)) knownSegments
    [input,output] = ls

star2 = sum . map s2
star1 = length . filter (not.flip elem [5,6]. S.size) . concat . map (head.tail)

main :: IO ()
main = do
  contents <- getContents
  let signals = map parse $ lines contents
  putStrLn $ "Star 1: " ++ (show $ star1 signals)
  putStrLn $ "Star 2: " ++ (show $ star2 signals)