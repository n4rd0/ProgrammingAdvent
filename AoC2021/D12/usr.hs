import qualified Data.Map as M
import qualified Data.Set as S
import Data.Char (isLower)

split = foldr (\c acc@(y:ys) -> if c == '-' then []:acc else (c:y):ys) [[]]
fj (Just x) = x

parse ls = foldr1 (M.unionWith (++)) $ map (uncurry M.singleton) splitted'
  where
    splitted = map split ls
    splitted' = map (\[x,y]->(x,[y])) $ splitted ++ (map reverse splitted)

paths _ _ _ "start" = 1
paths twice@(curr,use) visited m x = sum $ map aux neigh
  where
    neigh = fj $ x `M.lookup` m
    aux "end" = 0
    aux n = if isLower $ head n then
      if n `S.member` visited then if curr || use then 0 else paths (True,use) (n `S.insert` visited) m n
       else paths twice (n `S.insert` visited) m n
      else paths twice visited m n

star b m = paths (False, b) (S.empty) m "end"

main :: IO ()
main = do
  contents <- getContents
  let graph = parse $ lines contents
  putStrLn $ "Star 1: " ++ (show $ star True graph)
  putStrLn $ "Star 2: " ++ (show $ star False graph)
