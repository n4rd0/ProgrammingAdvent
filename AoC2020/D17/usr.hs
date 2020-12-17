import qualified Data.Map.Strict as Map
import Data.List (delete)

type Coord = [Int]
type Cell = Int

dimension = 4

-- 16 in 4d = 1+2*3+9+0*27 = [0,1,0,-1]
toDirection :: Int -> Coord
toDirection = reverse . take dimension . map (\x -> x `mod` 3 - 1) . iterate d
    where d = (flip div) 3

possibleDirections1 = delete (replicate dimension 0) $ map toDirection [1,4..3^4-1]
possibleDirections2 = delete (replicate dimension 0) $ map toDirection [0..3^4-1]

--Bri ish spelling
getNeighbours :: [Coord] -> Coord -> [Coord]
getNeighbours ls c = map (zipWith (+) c) ls

updateCell :: Cell -> Int -> Cell
updateCell 1 2 = 1
updateCell _ 3 = 1
updateCell _ _ = 0

next :: [Coord] -> Map.Map Coord Cell -> Map.Map Coord Cell
next dirs m = onlyActiveCells $ Map.mapWithKey update tileToActiveNeighbours
    where
        update coord cellState = updateCell (getCellState coord m) cellState
        listOfNeighbours = map (getNeighbours dirs) $ Map.keys m
        tileToActiveNeighbours = foldr1 (Map.unionWith (+)) $ map (Map.fromList . map (\x -> (x,1))) $ listOfNeighbours

getCellState k = Map.findWithDefault 0 k
onlyActiveCells = Map.filter (==1)

star dirs = Map.size . (!! 6) . iterate (next dirs)

main :: IO ()
main = do
  contents <- getContents
  let ls = map (map (fromEnum . (=='#'))) $ lines contents
  let rows = length ls
  let cols = length $ head ls
  let coords = map (\(x,y)->[y,x] ++ replicate (dimension - 2) 0) $ (foldr1 (++) . map (zip [0..cols-1] . repeat)) [0..rows-1]
  let m = onlyActiveCells $ Map.fromList $ zip coords (foldr1 (++) ls)

  putStrLn $ "Star 1: " ++ (show $ star possibleDirections1 m)
  putStrLn $ "Star 2: " ++ (show $ star possibleDirections2 m)
