import qualified Data.Map.Strict as Map
import Data.List (delete)

type Coord = (Int,Int,Int,Int)

toDirection :: Int -> Coord
toDirection x = ((d . d . d) x `mod` 3 - 1, (d . d) x `mod` 3 - 1, d x `mod` 3 - 1, x `mod` 3 - 1)
    where d = (flip div) 3

possibleDirections1 = delete (0,0,0,0) $ map toDirection [1,4..80]
possibleDirections2 = delete (0,0,0,0) $ map toDirection [0..80]

addDir :: Coord -> Coord -> Coord
addDir (x,y,z,w) (x',y',z',w') = (x+x',y+y',z+z',w+w')

--Bri ish spelling
getNeighbours :: [Coord] -> Coord -> [Coord]
getNeighbours ls c = map (addDir c) ls

updateCell :: Int -> Int -> Int
updateCell 1 2 = 1
updateCell _ 3 = 1
updateCell _ _ = 0

newCellVal :: [Coord] -> Map.Map Coord Int -> Coord -> Int
newCellVal dirs m coord = updateCell (aux coord) (sum $ map aux $ getNeighbours dirs coord)
    where aux k = Map.findWithDefault 0 k m

next :: [Coord] -> Map.Map Coord Int -> Map.Map Coord Int
next dirs m = onlyActiveCells $ Map.mapWithKey (\coord val -> newCellVal dirs m coord) nmap
    where nmap = Map.fromList $ map (\x -> (x,0)) $ foldr1 (++) $ map (getNeighbours dirs) $ Map.keys m

onlyActiveCells = Map.filter (==1)
applyNTimes n f a = foldr (\_ acc -> f acc) a [1..n]

star dirs = Map.size . applyNTimes 6 (next dirs)

main :: IO ()
main = do
  contents <- getContents
  let ls = map (map (fromEnum . (=='#'))) $ lines contents
  let rows = length ls
  let cols = length $ head ls
  let coords = map (\(x,y)->(y,x,0,0)) $ (foldr1 (++) . map (zip [0..cols-1] . repeat)) [0..rows-1]
  let m = onlyActiveCells $ Map.fromList $ zip coords (foldr1 (++) ls)

  putStrLn $ "Star 1: " ++ (show $ star possibleDirections1 m)
  putStrLn $ "Star 2: " ++ (show $ star possibleDirections2 m)
