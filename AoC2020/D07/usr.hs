import qualified Data.Map as Map
import qualified Data.Set as Set
import Data.List.Split (splitOn)
import Data.List (isPrefixOf)

removeEnding :: ([a] -> Bool) -> [a] -> [a]
removeEnding f (x:xs) = if f xs then [x] else x: (removeEnding f xs)
removeEnding _ [] = []

parse :: String -> (String, [(Int, String)])
parse ss = (container, content)
    where
        [container,rest] = splitOn " bags contain " ss
        content = map (aux . dropWhile (==' ')) $ filter ((/='n') . head) $ splitOn "," rest
        aux s = (read i, (removeEnding (isPrefixOf " bag") . dropWhile (==' ')) rest)
            where (i, rest) = break (==' ') s

toAscendMap :: (String, [(Int, String)]) -> Map.Map String [(Int, String)]
toAscendMap (container, content) = if null content then Map.empty else Map.fromList $ map (\(i,color) -> (color, [(i, container)])) content

toDescendMap :: (String, [(Int, String)]) -> Map.Map String [(Int, String)]
toDescendMap (container, content) = if null content then Map.empty else Map.singleton container content

genSet :: Map.Map String [(Int, String)] -> String -> Set.Set String -> Set.Set String
genSet m key acc = case key `Map.lookup` m of
        Just val -> foldr aux nacc val
        otherwise -> nacc
        where
            nacc = (key `Set.insert` acc)
            aux (_,s) set = genSet m s set

countBags :: Map.Map String [(Int, String)] -> String -> Int
countBags m key = case key `Map.lookup` m of
        Just val -> foldr aux 0 val
        otherwise -> 0
        where aux (i,s) acc = acc + i + (i * countBags m s)

star1 ls = (+(-1)) $ length $ genSet m "shiny gold" Set.empty
    where m = (foldr1 (Map.unionWith (++)) . map toAscendMap) ls

star2 ls = countBags m "shiny gold"
    where m = (foldr1 Map.union . map toDescendMap) ls

main :: IO ()
main = do
  contents <- getContents
  let ls = map parse $ lines contents
  putStrLn $ "Star 1: " ++ (show $ star1 ls)
  putStrLn $ "Star 2: " ++ (show $ star2 ls)
