import Data.Char (digitToInt)
import qualified Data.Map as M

neighCoord = [(x,y) | x <- [-1..1], y <- [-1..1]]
neighbours (x,y) = map (\(dx,dy) -> (x+dx,y+dy)) neighCoord

genCave i (x:xs) = (zip (zip (repeat i) [0..]) (map digitToInt x)) ++ genCave (i+1) xs
genCave _ [] = []

oneTick banged m = if null bangs then (banged,m) else oneTick (bangs++banged) m''
  where
    bangs = map fst $ filter ((>=10).snd) (M.assocs m)
    m' = M.filter (<10) m
    morePlus = concat $ map neighbours bangs
    occurences = foldr (\k -> M.insertWith (+) k 1) M.empty morePlus
    m'' = M.mapWithKey (plustJust . flip M.lookup occurences) m'
    plustJust (Just x) = (+x)
    plustJust (Nothing) = (+0)

update m = (length bangs, foldr (\k acc-> M.insert k 0 acc) nm bangs)
  where
    (bangs,nm) = oneTick [] (M.map (+1) m)

star1 cave = fst $ foldl aux (0,cave) [1..100]
  where 
    aux (accn,accm) _ = (accn+nn,nm)
      where (nn,nm) = update accm

star2 i m = if nn >= M.size m then i else star2 (i+1) nm
  where (nn,nm) = update m

main :: IO ()
main = do
  contents <- getContents
  let cave = M.fromList $ genCave 0 $ lines contents
  putStrLn $ "Star 1: " ++ (show $ star1 cave)
  putStrLn $ "Star 2: " ++ (show $ star2 1 cave)
