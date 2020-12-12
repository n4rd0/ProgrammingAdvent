import qualified Data.Map as Map

data Rotation = L | R deriving (Eq,Show)
type Vec = (Int,Int)
data Move = Move Vec Int | Turn Rotation Int | Forward Int deriving (Eq,Show)
type Ship = (Vec, Vec)

charToDir :: Map.Map Char Vec
charToDir = Map.fromList [('N', (1,0)), ('E', (0,1)), ('S', (-1,0)), ('W', (0,-1))]

charToRot = Map.fromList [('R', R), ('L', L)]

manhattanDist (x,y) = abs x + abs y

turnVec :: Rotation -> Vec -> Int -> Vec
turnVec _ dir 0 = dir
turnVec L (x,y) deg = turnVec L (y,-x) (deg-1)
turnVec R (x,y) deg = turnVec R (-y,x) (deg-1)

parse :: String -> Move
parse (s:ss) = case s `Map.lookup` charToDir of
    Just d -> Move d (read ss)
    Nothing -> case s `Map.lookup` charToRot of
        Just d -> Turn d ((read ss) `div` 90)
        Nothing -> Forward (read ss)

moveInDir :: Vec -> Move -> Vec
moveInDir (x,y) (Move (dx,dy) steps) = (x+steps*dx,y+steps*dy)

applyMove :: Bool -> Ship -> Move -> Ship
applyMove False (pos, dir) mv@(Move _ _) = (moveInDir pos mv, dir) 
applyMove _ (pos, dir) (Forward steps) = (moveInDir pos (Move dir steps), dir)
applyMove _ (pos, dir) (Turn rot degrees) = (pos, turnVec rot dir degrees)
applyMove _ (pos, dir) mv = (pos, moveInDir dir mv) 

star1 = manhattanDist . fst . foldl (applyMove False) ((0,0),(0,1))
star2 = manhattanDist . fst . foldl (applyMove True) ((0,0),(1,10))

main :: IO ()
main = do
  contents <- getContents
  let ls = map parse $ lines contents
  putStrLn $ "Star 1: " ++ (show $ star1 ls)
  putStrLn $ "Star 2: " ++ (show $ star2 ls)
