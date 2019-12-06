import qualified Data.Map as Map
import qualified Data.Maybe as Maybe
import qualified Data.List as List

split :: Char -> String -> String -> [String]
split c acc (x:xs) = if x == c then acc : split c [] xs else split c (acc++[x]) xs
split _ acc [] = [acc]

divide :: (a -> Bool) -> [a] -> ([a], [a])
divide f (x:xs) = if f x then (x:yes, no) else (yes, x:no)
    where
        (yes, no) = divide f xs
divide _ [] = ([], [])


buildSortedLs :: String -> [[String]] -> [[String]]
buildSortedLs _ [] = []
buildSortedLs match xs = nodesMatching' ++ (foldl (++) [] (children $ map buildSortedLs newStrs))
    where 
        (nodesMatching, rest) = divide (\[a,b] -> a == match || b == match) xs
        nodesMatching' = map (\[a,b] -> if a == match then [a,b] else [b,a]) nodesMatching
        newStrs = map (\[a,b] -> if a == match then b else a) nodesMatching

        children = List.foldl' (\acc f -> f rest : acc) []

dist :: String -> Map.Map String String -> String -> Int
dist s m t
    | val == t = 1
    | otherwise = 1 + dist val m t
    where
        val = Maybe.fromJust $ Map.lookup s m

buildMap :: [[String]] -> Map.Map String String
buildMap ls = Map.fromList $ List.foldl' (\acc [a,b] -> (b,a) : acc) [] ls

star1 :: [[String]] -> Int
star1 ls = List.foldl' (\acc a -> acc + dist a m "COM") 0 to
    where
        to = map last ls
        m = buildMap ls

star2 :: String -> String -> [[String]] -> Int
star2 from to ls = dist from m to - 2
    where
        newls = buildSortedLs to ls
        m = buildMap newls

main :: IO ()
main = do
  contents <- getContents
  let ls = map (split ')' []) $ lines contents

  print $ star1 ls
  print $ star2 "YOU" "SAN" ls
  