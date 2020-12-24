import Data.Char (digitToInt,intToDigit)
import Data.List (delete)
import qualified Data.IntMap.Strict as IntMap

getDestination max i xs 
    | i == 0 = getDestination max max xs
    | otherwise = if i `elem` xs then getDestination max (i-1) xs else i

move :: Int -> IntMap.IntMap Int -> IntMap.IntMap Int
move current im = nim
    where
        destination = getDestination (IntMap.size im) (current-1) [next,temp,ending]
        next = im IntMap.! current
        temp = im IntMap.! next
        ending = im IntMap.! temp
        nim = IntMap.insert destination next $ IntMap.insert ending (im IntMap.! destination) $ IntMap.insert current (im IntMap.! ending) im

game :: Int -> Int -> IntMap.IntMap Int -> IntMap.IntMap Int
game 0 _ im = im
game t current im = game (t-1) (nim IntMap.! current) nim
    where nim = move current im

parseRes :: Int -> IntMap.IntMap Int -> String
parseRes i im = aux $ im IntMap.! i
    where
        aux 1 = []
        aux i' = intToDigit i' : aux nxt
            where nxt = im IntMap.! i'

star1 ls = parseRes 1 resIm
    where
        im = IntMap.fromList $ zip ls (drop 1 $ cycle ls)
        resIm = game 100 (head ls) im

star2 ls = next*(resIm IntMap.! next)
    where
        next = resIm IntMap.! 1
        ls' = ls ++ [10..10^6]
        im = IntMap.fromList $ zip ls' (drop 1 $ cycle ls')
        resIm = game (10^7) (head ls) im

main :: IO ()
main = do
  contents <- getContents
  let val = map digitToInt contents

  putStrLn $ "Star 1: " ++ (star1 val)
  putStrLn $ "Star 2: " ++ (show $ star2 val)
