import Data.Either (lefts, rights)
import Data.List (sort)
import qualified Data.Map as M

opens = "([{<"
closes = ")]}>"
points1 = zip closes [3,57,1197,25137]
points2 = zip closes [1,2,3,4]
pairs = zip opens closes
forcedLookup k d = (\(Just x) -> x) $ k `lookup` d

process (o:os) (x:xs)
  | x `elem` closes = if ((o,x) `elem` pairs) then process os xs else Left x
  | otherwise = process (x:o:os) xs
process [] (x:xs) = process [x] xs
process open _ = Right open

genMap = foldr (\k -> M.insertWith (+) k 1) M.empty

calculateScore1 = foldl (\acc (k,v) -> acc + v * (k `forcedLookup` points1)) 0 . M.assocs . genMap
calculateScore2 = foldl (\acc k -> 5*acc + (k `forcedLookup` points2)) 0

star1 = calculateScore1 . lefts . map (process [])
star2 = median . map (calculateScore2 . map ((flip forcedLookup) pairs)) . rights . map (process [])
  where median ls = (sort ls) !! (length ls `div` 2)

main :: IO ()
main = do
  contents <- getContents
  let navigation = lines contents
  putStrLn $ "Star 1: " ++ (show $ star1 navigation)
  putStrLn $ "Star 2: " ++ (show $ star2 navigation)
