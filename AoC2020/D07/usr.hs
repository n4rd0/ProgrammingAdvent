import qualified Data.Map as Map
import qualified Data.Set as Set
import Data.List.Split (splitOn)
import Data.List (isPrefixOf)
import Data.Hashable (hash)

type Bag = Int

removeEnding :: ([a] -> Bool) -> [a] -> [a]
removeEnding f (x:xs) = if f xs then [x] else x: (removeEnding f xs)
removeEnding _ [] = []

parse :: String -> (Bag, [(Int, Bag)])
parse ss = (hash container, content)
    where
        [container,rest] = splitOn " bags contain " ss
        content = map (aux . dropWhile (==' ')) $ filter ((/='n') . head) $ splitOn "," rest
        aux s = (read i, hash $ (removeEnding (isPrefixOf " bag") . dropWhile (==' ')) rest)
            where (i, rest) = break (==' ') s

toAscendMap :: (Bag, [(Int, Bag)]) -> Map.Map Bag [(Int, Bag)]
toAscendMap (container, content) = if null content then Map.empty else Map.fromList $ map (\(i,color) -> (color, [(i, container)])) content

toDescendMap :: (Bag, [(Int, Bag)]) -> Map.Map Bag [(Int, Bag)]
toDescendMap (container, content) = if null content then Map.empty else Map.singleton container content

genSet :: Map.Map Bag [(Int, Bag)] -> Bag -> Set.Set Bag -> Set.Set Bag
genSet m key acc = case key `Map.lookup` m of
        Just val -> foldr aux nacc val
        Nothing -> nacc
        where
            nacc = (key `Set.insert` acc)
            aux (_,s) set = genSet m s set

countBags :: Map.Map Bag [(Int, Bag)] -> Bag -> Int
countBags m key = case key `Map.lookup` m of
        Just val -> foldr aux 0 val
        Nothing -> 0
        where aux (i,s) acc = acc + i + (i * countBags m s)

star1 ls = (+(-1)) $ length $ genSet m (hash "shiny gold") Set.empty
    where m = (foldr1 (Map.unionWith (++)) . map toAscendMap) ls

star2 ls = countBags m (hash "shiny gold")
    where m = (foldr1 Map.union . map toDescendMap) ls

main :: IO ()
main = do
  contents <- getContents
  let ls = map parse $ lines contents
  putStrLn $ "Star 1: " ++ (show $ star1 ls)
  putStrLn $ "Star 2: " ++ (show $ star2 ls)
