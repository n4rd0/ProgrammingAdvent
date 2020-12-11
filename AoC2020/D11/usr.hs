import qualified Data.Map as Map
import Data.Maybe (fromJust)

data Cell = Floor | Occupied | Empty deriving (Show, Eq)

charToCell '.' = Floor
charToCell '#' = Occupied
charToCell 'L' = Empty
charToCell c = error $ "Invalid char " ++ [c]

updateSingle :: Int -> Cell -> Int -> Cell
updateSingle _ Empty occupied = if occupied == 0 then Occupied else Empty
updateSingle bound Occupied occupied = if occupied >= bound then Empty else Occupied
updateSingle _ Floor _ = Floor

neighbourBesidesOccupied :: Map.Map (Int,Int) Cell -> (Int,Int) -> (Int,Int) -> Int
neighbourBesidesOccupied m (r,c) (dr,dc) = if (coord `Map.lookup` m) == Just Occupied then 1 else 0
    where coord = (r+dr,c+dc)

neighbourLineOccupied :: Map.Map (Int,Int) Cell -> (Int,Int) -> (Int,Int) -> Int
neighbourLineOccupied m (r,c) d@(dr,dc) = case coord `Map.lookup` m of
        Just Occupied -> 1
        Just Empty -> 0
        Just Floor -> neighbourLineOccupied m coord d
        Nothing -> 0
    where coord = (r+dr,c+dc)

occupiedNeighbours :: ((Int,Int) -> (Int,Int) -> Int) -> (Int,Int) -> Int
occupiedNeighbours countOneDirection (r,c) = sum $ map (countOneDirection (r,c)) [(-1,0),(1,0),(0,-1), (0,1),(1,1),(1,-1),(-1,1),(-1,-1)]

update :: Map.Map (Int,Int) Cell -> (Cell -> Int -> Cell) -> ((Int,Int) -> (Int,Int) -> Int) -> (Int,Int) -> (Int,Int) -> [((Int,Int), Cell)] -> Bool -> ([((Int,Int), Cell)], Bool)
update m changeCriteria countOneDirection d@(rows,cols) coord@(r,c) acc same
    | c >= cols = update m changeCriteria countOneDirection d (r+1,0) acc same
    | r >= rows = (acc,same)
    | otherwise = update m changeCriteria countOneDirection d (r,c+1) ((coord, newCell):acc) (same && newCell == oldCell)
    where
        oldCell = case coord `Map.lookup` m of
            Just a -> a
            Nothing -> error $ show coord
        newCell = if oldCell == Floor then Floor else changeCriteria oldCell neighOccupied
        neighOccupied = occupiedNeighbours countOneDirection coord

findStableConfig :: Map.Map (Int,Int) Cell -> (Cell -> Int -> Cell) -> (Map.Map (Int,Int) Cell -> (Int,Int) -> (Int,Int) -> Int) -> (Int,Int) -> Map.Map (Int,Int) Cell
findStableConfig m changeCriteria countOneDirection d = if same then nxtM else findStableConfig nxtM changeCriteria countOneDirection d
    where
        nxtM = Map.fromList nxtLs
        (nxtLs,same) = update m changeCriteria (countOneDirection m) d (0,0) [] True

star a b c d = length $ filter (==Occupied) $ (Map.elems) $ findStableConfig a b c d

main :: IO ()
main = do
  contents <- getContents
  let ls' = lines contents
  let rows = length ls'
  let cols = length $ head ls'
  let ls = map charToCell $ foldl1 (++) ls'
  let coords = map (\(x,y)->(y,x)) $ (foldr1 (++) . map (zip [0..cols-1] . repeat)) [0..rows-1]
  let m = Map.fromList $ zip coords ls

  putStrLn $ "Star 1: " ++ (show $ star m (updateSingle 4) neighbourBesidesOccupied (rows,cols))
  putStrLn $ "Star 2: " ++ (show $ star m (updateSingle 5) neighbourLineOccupied (rows,cols))
