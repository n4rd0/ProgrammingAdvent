import Data.List.Split (splitOn)
import qualified Data.Set as Set

score :: [Int] -> Int
score ls = sum $ zipWith (*) ls [l,l-1..]
    where l = length ls

modifyDeck :: Bool -> [Int] -> [Int] -> ([Int],[Int])
modifyDeck True (a:as) (b:bs) = (as++[a,b],bs)
modifyDeck False (a:as) (b:bs) = (as,bs++[b,a])

playSubGame :: [Int] -> [Int] -> Set.Set ([Int],[Int]) -> Bool
playSubGame pa@(a:as) pb@(b:bs) set = (pa,pb) `Set.member` set || playSubGame pa' pb' (Set.insert (pa,pb) set)
    where (pa',pb') = modifyDeck (a>b) pa pb
playSubGame a [] _ = True
playSubGame [] b _ = False

playOneMove :: ([Int] -> [Int] -> Bool) -> [Int] -> [Int] -> ([Int],[Int])
playOneMove determineWinner pa pb = modifyDeck (determineWinner pa pb) pa pb

play :: ([Int] -> [Int] -> ([Int],[Int])) -> [Int] -> [Int] -> Set.Set ([Int],[Int]) -> Int
play _ a [] _ = score a
play _ [] b _ = score b
play playMove a b set = if (a,b) `Set.member` set
    then play undefined a [] undefined
    else play playMove a' b' ((a,b) `Set.insert` set)
    where (a',b') = playMove a b

winnerStar2 (a:as) (b:bs) = if length as >= a && length bs >= b
    then playSubGame (take a as) (take b bs) Set.empty
    else a > b

winnerStar1 (a:_) (b:_) = a > b

main :: IO ()
main = do
  contents <- getContents
  let [a,b] = map (map read . tail . lines) $ splitOn "\n\n" contents :: [[Int]]

  putStrLn $ "Star 1: " ++ (show $ play (playOneMove winnerStar1) a b Set.empty)
  putStrLn $ "Star 2: " ++ (show $ play (playOneMove winnerStar2) a b Set.empty)
