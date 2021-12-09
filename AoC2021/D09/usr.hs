import Data.List (sort)
import Data.Char (digitToInt)
import Data.Maybe (fromJust)
import qualified Data.Map as M
import qualified Data.Set as S

genCave i (x:xs) = (zip (zip (repeat i) [0..]) (map digitToInt x)) ++ genCave (i+1) xs
genCave _ [] = []

neighbourDir = [(1,0),(0,1),(-1,0),(0,-1)]
neighbours (x,y) = map (\(dx,dy) ->(x+dx,y+dy)) neighbourDir

lowPoints f m = filter isLow (M.keys m)
  where
    isLow p = all (bigger f m v) (neighbours p)
      where v = fromJust $ p `M.lookup` m

bigger f m val np = case np `M.lookup` m of
    Nothing -> True
    Just w -> val `f` w

basin m p = p `S.insert` (S.unions (map (basin m) larger))
  where
    val = fromJust $ p `M.lookup` m
    larger = filter isInBasin (neighbours p)
      where
        isInBasin n = case n `M.lookup` m of
            Just v -> v /= 9 && v > val
            Nothing -> False

star1 cave = sum $ map (\k -> 1 + (fromJust $ k `M.lookup` cave)) $ lowPoints (<) cave
star2 cave = product $ take 3 $ reverse $ sort $ map (S.size . basin cave) (lowPoints (<=) cave)

main :: IO ()
main = do
  contents <- getContents
  let cave = M.fromList $ genCave 0 $ lines contents
  putStrLn $ "Star 1: " ++ (show $ star1 cave)
  putStrLn $ "Star 2: " ++ (show $ star2 cave)
