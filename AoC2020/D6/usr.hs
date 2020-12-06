import qualified Data.Set as Set

parse :: [String] -> String -> [String]
parse (x:xs) acc
  | x == "" = acc : parse xs ""
  | otherwise = parse xs (acc ++ ' ':x)
parse _ acc = [acc]

foldSet :: Ord a => (Set.Set a -> Set.Set a -> Set.Set a) -> [[a]] -> Int
foldSet f = Set.size . foldl1 f . map Set.fromList

star1 = sum . map (foldSet Set.union)
star2 = sum . map (foldSet Set.intersection)

main :: IO ()
main = do
  contents <- getContents
  let ls' = lines contents
  let ls = map words $ parse ls' ""
  putStrLn $ "Star 1: " ++ (show $ star1 ls)
  putStrLn $ "Star 2: " ++ (show $ star2 ls)
