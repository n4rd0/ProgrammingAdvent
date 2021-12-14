import qualified Data.Map as M
import Data.Text (splitOn, pack, unpack)

fj (Just a) = a

parse ls = (unpack coords,insertions')
  where
    [coords,insertions] = splitOn (pack "\n\n") (pack ls)
    insertions' = map  ((\[x,[y]] -> (x,y)).(\s -> map unpack $ splitOn (pack " -> ") s)) $ map pack $ lines $ unpack insertions

apply i f x = foldr (\_ -> f) x [1..i]
count' s = foldr (\k -> M.insertWith (+) k 1) M.empty s

toRules m = foldr aux M.empty (M.keys m)
  where
    aux [x,y] = M.insert [x,y] [[x,a],[a,y]]
      where a = (fj $ [x,y] `M.lookup` m)

pairs (x:y:xs) = [x,y]:pairs (y:xs)
pairs _ = []

insertLs ls m = foldr (\(key,val) -> M.insertWith (+) key val) m ls

s rules m = foldr aux M.empty (M.assocs m)
  where
    aux (k,t) acc = insertLs (zip (newPairs k) (repeat t)) acc
      where
        newPairs pair = fj $ pair `M.lookup` rules


toM reacts m = M.map halveAndRound $ insertLs (concat $ map (\([x,y],v) -> [(x,v),(y,v)]) pairs) M.empty
  where
    halveAndRound s = uncurry (+) $ divMod s 2
    pairs = M.assocs m

star n insertions chain = result $ M.elems $ toM insertions' $ apply n (s insertionToRules) $ (count' $ pairs chain)
  where
    result ls = maximum ls - minimum ls
    insertions' = M.fromList insertions
    insertionToRules = toRules insertions'

main :: IO ()
main = do
  contents <- getContents
  let (chain,insertions) = parse contents
  putStrLn $ "Star 1: " ++ (show $ star 10 insertions chain)
  putStrLn $ "Star 2: " ++ (show $ star 40 insertions chain)
