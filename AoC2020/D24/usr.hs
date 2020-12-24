import qualified Data.Map as Map

type Coord = (Int,Int)

toLs :: String -> [String]
toLs ('e':xs) = "e" : toLs xs
toLs ('w':xs) = "w" : toLs xs
toLs ('s':'e':xs) = "se" : toLs xs
toLs ('s':'w':xs) = "sw" : toLs xs
toLs ('n':'w':xs) = "nw" : toLs xs
toLs ('n':'e':xs) = "ne" : toLs xs
toLs [] = []

adyacent = [(2,0),(-2,0),(1,1),(1,-1),(-1,1),(-1,-1)]
directions = Map.fromList $ zip ["e","w","ne","se","nw","sw"] adyacent

nextTile :: String -> Coord -> Coord
nextTile dir (x,y) = (x+x',y+y') 
    where (x',y') = (directions Map.! dir)

neighbours :: Coord -> [Coord]
neighbours (x,y) = map (\(x',y') -> (x+x',y+y')) adyacent

genInitialState :: [[String]] -> Map.Map Coord Int
genInitialState = foldr aux Map.empty
    where
        aux path m = Map.insert tileVal (prevVal+1) m
            where
                prevVal = getCellState tileVal m
                tileVal = foldr nextTile (0,0) path

getCellState k = Map.findWithDefault 0 k

updateCell :: Int -> Int -> Int
updateCell 0 2 = 1
updateCell 1 1 = 1
updateCell 1 2 = 1
updateCell _ _ = 0

next :: Map.Map Coord Int -> Map.Map Coord Int
next m = Map.filter (==1) $ Map.mapWithKey update tileToActiveNeighbours
    where
        update coord cellState = updateCell (getCellState coord m) cellState
        listOfNeighbours = map neighbours $ Map.keys m
        tileToActiveNeighbours = foldr1 (Map.unionWith (+)) $ map (Map.fromList . map (\x -> (x,1))) $ listOfNeighbours

star1 = Map.size . Map.filter odd . genInitialState

star2 ls = Map.size $ iter 100 initialState
    where
        initialState = Map.map (\_->1) $ Map.filter odd $ genInitialState ls
        iter 0 x = x
        iter i x = iter (i-1) (next x)

main :: IO ()
main = do
  contents <- getContents
  let ls = map toLs $ lines contents

  putStrLn $ "Star 1: " ++ (show $ star1 ls)
  putStrLn $ "Star 1: " ++ (show $ star2 ls)
