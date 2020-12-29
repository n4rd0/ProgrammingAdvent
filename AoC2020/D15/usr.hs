import qualified Data.IntMap as IntMap
import qualified Data.Vector.Unboxed.Mutable as MV
import Data.List.Split (splitOn)
import Control.Monad.ST (runST)
import Control.Monad (zipWithM_)

next :: Int -> IntMap.IntMap Int -> Int -> Int
next turn m num = turn - lastTime
    where lastTime = IntMap.findWithDefault turn num m

findVal :: Int -> IntMap.IntMap Int -> Int -> Int
findVal target m lastNum = aux m (IntMap.size m + 1) lastNum
    where
        aux m turn lastN = if turn == target then lastN else aux m' (succ turn) lastN'
            where
              m' = IntMap.insert lastN turn m
              lastN' = next turn m lastN

star num ls = findVal num (IntMap.fromList $ zip ls [1..]) 0

findValM 0 y _ _ = return y
findValM target' y i v = do
    n <- MV.read v y
    let y' = if n == 0 then 0 else i - n
    MV.write v y i
    findValM (target' - 1) y' (succ i) v

--Using the state monad, so that we can use mutable data structures
star' num ls = get num 
    where
      l = length ls
      get i = if i < l then ls !! (i-1) else get' i
      get' target = runST $ do
        let i = length ls + 1
        v <- MV.new num
        zipWithM_ (MV.write v) (init ls) [1..]
        findValM (target - l) (last ls) l v

main :: IO ()
main = do
  contents <- getContents
  let ls = (map read . splitOn ",") contents :: [Int]

  putStrLn $ "Star 1: " ++ (show $ star 2020 ls)
  --putStrLn $ "Star 2: " ++ (show $ star (3*10^6) ls)
  putStrLn $ "Star 2: " ++ (show $ star' (3*10^7) ls)
