import qualified Data.Map as Map
import Data.List.Split (splitOn)
import Data.List (isPrefixOf)

data Rule = Sequence [[Int]] | Str [String] deriving (Show, Eq)

cartesianProduct :: ([a] -> [a] -> Bool) -> [[a]] -> [[a]] -> [[a]]
cartesianProduct f xx yy = [x++y | x <- xx, y <- yy, f x y]

parseRules :: [String] -> Map.Map Int Rule
parseRules ls = Map.fromList $ map toR ls
    where 
        toR s = (read num, rule)
            where
                [num,rest] = splitOn ": " s
                rule = if head rest == '\"'
                    then Str [tail $ init rest]
                    else Sequence $ map (map read . words) $ splitOn "|" rest

fromStr (Str s) = s
fromSequence (Sequence s) = s
isStr (Str _) = True
isStr _ = False

collapseToString :: Int -> Map.Map Int [String] -> Rule -> [String]
collapseToString maxL m (Sequence ls) = foldr1 (++) $ map (aux [""]) ls
    where
        aux :: [String] -> [Int] -> [String]
        aux acc (l:ls) = aux acc' ls
            where 
                possible = m Map.! l
                acc' = cartesianProduct (\x y -> length x + length y <= maxL) acc possible
        aux acc [] = acc

collapseRules :: Map.Map Int Rule -> Int -> Map.Map Int [String]
collapseRules m maxL = collapseRules' (Map.filterWithKey (aux initial) m) initial
    where
        aux mp k _ = not $ k `Map.member` mp
        initial = Map.map fromStr $ Map.filter isStr m
        collapseRules' :: Map.Map Int Rule -> Map.Map Int [String] -> Map.Map Int [String]
        collapseRules' m acc = if null m then acc else collapseRules' m' acc'
            where
                m' = Map.filterWithKey (aux conversion) m
                acc' = Map.union acc (Map.map (collapseToString maxL acc) conversion)
                conversion = Map.filter hasAllValues m
                hasAllValues (Sequence ls) = all (all ((flip Map.member) acc)) ls

wordFollowsRule :: String -> [[String]] -> Bool
wordFollowsRule [] [] = True
wordFollowsRule word (s:ss) = if null pre
    then False
    else wordFollowsRule (drop lenhp word) ss
    where
        pre = filter (\x -> isPrefixOf x word) s
        lenhp = length $ head pre
wordFollowsRule _ _ = False

-- Takes advantage of the fact that 0: 8 11 and no other rules derive 8,11
--construct the possible values for the subrules of 8 and 11 by concatenating
--then check them against the possible words
-- We can't keep on concatenating since there are too many possible combinations
star lenTake rules strings = length $ filter (\x -> any (wordFollowsRule x) rules0) strings
    where
        rules' = foldr (Map.delete) rules [0,8,11]
        maxL = maximum $ map length strings
        resMap = collapseRules rules' maxL
        lenTake' = if lenTake == 0 then maxL `div` 2 else lenTake

        --0: 8 11
        rules0 = map (map (resMap Map.!)) $ cartesianProduct (\x y -> length x + length y <= maxL) rules8 rules11
        --8: a | aa | aaa ...
        rules8 = take lenTake' $ iterate (\x -> v:x) [v]
            where [v] = head $ fromSequence $ rules Map.! 8
        --11: ab | aabb | aaabbb ...
        rules11 = map (\x -> replicate x v1 ++ replicate x v2)$ take lenTake' $ iterate (+1) 1  
            where [v1,v2] = head $ fromSequence $ rules Map.! 11

main :: IO ()
main = do
  contents <- getContents
  let ls = map lines $ splitOn "\n\n" contents
  let rules = parseRules (ls !! 0)
  let strings = ls !! 1

  putStrLn $ "Star 1: " ++ (show $ star 1 rules strings)
  putStrLn $ "Star 2: " ++ (show $ star 0 rules strings)
