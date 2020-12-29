import qualified Data.Map as Map
import qualified Data.Vector as V
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

getCoord (x,y) v = do
  row <- v V.!? x
  row V.!? y

neighbourBesidesOccupied :: V.Vector (V.Vector Cell) -> (Int,Int) -> (Int,Int) -> Int
neighbourBesidesOccupied v (r,c) (dr,dc) = fromEnum $ (getCoord coord v) == Just Occupied
    where coord = (r+dr,c+dc)

neighbourLineOccupied :: V.Vector (V.Vector Cell) -> (Int,Int) -> (Int,Int) -> Int
neighbourLineOccupied v (r,c) d@(dr,dc) = case getCoord coord v of
        Just Occupied -> 1
        Just Floor -> neighbourLineOccupied v coord d
        _ -> 0
    where coord = (r+dr,c+dc)

occupiedNeighbours :: ((Int,Int) -> (Int,Int) -> Int) -> (Int,Int) -> Int
occupiedNeighbours countOneDirection (r,c) = sum $ map (countOneDirection (r,c)) [(-1,0),(1,0),(0,-1),(0,1),(1,1),(1,-1),(-1,1),(-1,-1)]

update :: V.Vector (V.Vector Cell) -> (Cell -> Int -> Cell) -> ((Int,Int) -> (Int,Int) -> Int) -> V.Vector (V.Vector Cell)
update v changeCriteria countOneDirection = V.imap (\x v' -> V.imap (\y cell -> newCell (x,y) cell) v') v
    where
      newCell co oldCell = changeCriteria oldCell (neighOccupied co)
      neighOccupied co = occupiedNeighbours countOneDirection co

findStableConfig :: V.Vector (V.Vector Cell) -> (Cell -> Int -> Cell) -> (V.Vector (V.Vector Cell) -> (Int,Int) -> (Int,Int) -> Int) -> (Int,Int) -> V.Vector (V.Vector Cell)
findStableConfig v changeCriteria countOneDirection d@(rows,cols) = if nxtV == v then nxtV else findStableConfig nxtV changeCriteria countOneDirection d
    where nxtV = update v changeCriteria (countOneDirection v)

star v changeCriteria countOneDirection dimentions = V.foldr1 (+) $ V.map (V.length . V.filter (==Occupied)) $ findStableConfig v changeCriteria countOneDirection dimentions

main :: IO ()
main = do
  contents <- getContents
  let ls = lines contents
  let v = V.fromList $ map (V.fromList . map charToCell) ls
  let rows = V.length v
  let cols = V.length $ v V.! 0

  putStrLn $ "Star 1: " ++ (show $ star v (updateSingle 4) neighbourBesidesOccupied (rows,cols))
  putStrLn $ "Star 2: " ++ (show $ star v (updateSingle 5) neighbourLineOccupied (rows,cols))
