import Data.Char (digitToInt,intToDigit)
import Data.List (delete)
import qualified Data.Sequence as Seq
import Data.Sequence ((<|),(><),(|>))
import Data.Foldable (toList)
import qualified Data.IntMap.Strict as IntMap

getDestination max i xs 
    | i == 0 = getDestination max max xs
    | otherwise = if i `elem` xs then getDestination max (i - 1) xs else i

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

initMap ls = IntMap.fromList $ Prelude.zip ls (tail $ cycle ls)

-- :<| should be used for pattern matching
parseRes' :: Seq.Seq Int -> String
parseRes' s = aux $ toList s
    where
        aux (1:xs) = map intToDigit xs
        aux (x:xs) = aux $ xs ++ [x]

move' :: Int -> Seq.Seq Int -> Seq.Seq Int
move' mx xss = bef >< (destination <| three >< (after |> x)) 
    where
        ls@[x,x1,x2,x3] = toList $ Seq.take 4 xss
        xs = Seq.drop 4 xss
        three = x1 <| x2 <| x3 <| Seq.empty
        after = Seq.drop 1 after'
        (bef, after') = Seq.spanl (/=destination) xs
        destination = getDestination mx (x - 1) ls

star1' ls = parseRes' $ iter !! 100
    where
        iter = iterate (move' (length ls)) seq
        seq = Seq.fromList ls

star1 ls = parseRes 1 resIm
    where
        im = initMap ls
        resIm = game 100 (head ls) im

star2 ls = next*(resIm IntMap.! next)
    where
        next = resIm IntMap.! 1
        ls' = ls ++ [10..10^6]
        im = initMap ls'
        resIm = game (10^7) (head ls) im

main :: IO ()
main = do
  contents <- getContents
  let val = map digitToInt contents

  putStrLn $ "Star 1: " ++ (star1' val)
  --putStrLn $ "Star 1: " ++ (star1 val)
  putStrLn $ "Star 2: " ++ (show $ star2 val)
