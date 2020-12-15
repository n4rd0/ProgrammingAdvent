import qualified Data.Map as Map
import qualified Data.HashTable.IO as H
import Data.List.Split (splitOn)
import Data.Maybe (fromMaybe)

next :: Int -> Map.Map Int Int -> Int -> (Int, Map.Map Int Int)
next turn m num = (numberSpoken, Map.insert num turn m)
    where
        lastTime = Map.findWithDefault turn num m
        numberSpoken = turn - lastTime

findVal :: Int -> Map.Map Int Int -> Int -> Int
findVal target m lastNum = aux nextTurn m lastNum
    where
        nextTurn = map next [Map.size m + 1..target - 1]
        aux (f:fs) m lastN = aux fs m' lastN'
            where (lastN',m') = f m lastN
        aux [] _ lastN = lastN

--The previous approach runs out of memory very fast,
-- I guess that it keeps old Maps in memory

--Here I use the IO monad to have fast inserts,
-- and there is no need to copy anything
-- somehow the complexity isn't linear,
-- I guess it is haskell's lazyness
type HashTable k v = H.BasicHashTable k v

insertLs :: HashTable Int Int -> [(Int,Int)] -> IO ()
insertLs m ((k,v):rs) = do
    H.insert m k v
    insertLs m rs
insertLs m _ = return ()

genHT :: Int -> [Int] -> IO (HashTable Int Int)
genHT num ls = do
    m <- H.newSized num
    insertLs m (zip ls [1..])
    return m

findVal' :: (Int,Int) -> HashTable Int Int -> Int -> IO (Int)
findVal' (from,to) m lastNum = aux (from+1) m lastNum
    where
        aux :: Int -> HashTable Int Int -> Int -> IO (Int)
        aux turn m lastN = if turn == to
            then return lastN 
            else do
                let f = next' turn
                (lastN',m') <- f m lastN
                aux (turn+1) m' lastN'

next' :: Int -> HashTable Int Int -> Int -> IO (Int, HashTable Int Int)
next' turn m num = do
    maybeLastTime <- H.lookup m num
    let lastTime = fromMaybe turn maybeLastTime
    let numberSpoken = turn - lastTime
    H.insert m num turn
    return (numberSpoken, m)

star' num ls = do
    m <- genHT num ls
    findVal' (length ls, num) m 0

star num ls = findVal num (Map.fromList $ zip ls [1..]) 0

main :: IO ()
main = do
  contents <- getContents
  let ls = (map read . splitOn ",") contents :: [Int]

  --putStrLn $ "Star 1: " ++ (show $ star 2020 ls)
  --putStrLn $ "Star 2: " ++ (show $ star (3*10^7) ls)

  s1 <- star' 2020 ls
  putStrLn $ "Star 1: " ++ (show s1)
  s2 <- star' (3*10^7) ls
  putStrLn $ "Star 2: " ++ (show s2)
