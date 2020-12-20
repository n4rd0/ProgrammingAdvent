import qualified Data.Map as Map
import qualified Data.Set as Set
import Data.List.Split (splitOn)
import Data.List (transpose)

type Tile = (Int,[[Char]])

parse :: [String] -> Tile
parse (s:ss) = (read num, ss)
    where num = take 4 $ drop 5 s

--The 8 possible symmetries
symmetries :: [[[Char]] -> [[Char]]]
symmetries = f ++ map ((map reverse).) f
    where f = [id, reverse, transpose, reverse . transpose]

--Get the 4*2 different edges a tile has
edges :: Tile -> [[Char]]
edges (_,ls) = zipWith (\f x -> head $ f x) symmetries (repeat ls)

--Determines which tiles can be adyacent to iD
findMatches :: Int -> [[Char]] -> [Int] -> [Tile] -> [Int]
findMatches iD h matches (t@(iD',_):ts) = if iD == iD'
    then findMatches iD h matches ts
    else findMatches iD h matches' ts
    where
        e = take 4 $ edges t --We only need to get the different sides
        matches' = if any ((flip elem) h) e then iD':matches else matches
findMatches _ _ matches [] = matches

--Generates the map id->[possible adyacent ids]
genCombinations :: [Tile] -> [Tile] -> Map.Map Int [Int] -> Map.Map Int [Int]
genCombinations (l@(iD,_):ls) allTiles m = genCombinations ls allTiles m'
        where
            m' = Map.insert iD matches m
            matches = findMatches iD tcs [] allTiles
            tcs = edges l
genCombinations [] _ m = m

firstRow (x:xs) = head x : firstRow xs
firstRow [] = []

lastRow (x:xs) = last x : lastRow xs
lastRow [] = []

--If it is adyacent to the right or below
areAdyacentNext :: [[Char]] -> [[Char]] -> Bool
areAdyacentNext x y = last x == head y || lastRow x == firstRow y

--If it is adyacent upwards or to the left
areAdyacentBef = flip areAdyacentNext

--Determines which rotations are valid given a tile's neighbour
validRotations :: Maybe Int -> [[Char]] -> [[Char]] -> [Int]
validRotations rot a b = case rot of
    Just rot -> [x | x <- [0..7], aux areAdyacentBef x rot]
    Nothing -> [x | x <- [0..7], y <- [0..7], aux areAdyacentNext x y]
    where
        aux f x y = f ((symmetries !! x) a) ((symmetries !! y) b)

--Tile b can fit at the right of a
isToTheRight :: [[Char]] -> [[Char]] -> Bool
isToTheRight a b = any (\x -> lastRow a == firstRow x) combinations
    where combinations = map (\f -> f b) symmetries

--Tile b can fit below a
isBelow :: [[Char]] -> [[Char]] -> Bool
isBelow a b = any (\x -> last a == head x) combinations
    where combinations = map (\f -> f b) symmetries

--Fins one valid rotation based on which rotations are allowed by it's neighbours
findOneValidRotation :: [[Char]] -> [(Maybe Int,Tile)] -> Int
findOneValidRotation tile ls = head $ Set.toList set
    where
        set = foldr1 Set.intersection $ map Set.fromList $ map snd tileRotPairs
        tileRotPairs = map (\(rot,(x,y)) -> (x, validRotations rot tile y)) ls

--Determine which ID comes next in the same row (x,y)->(x,y+1)
getNextID :: Int -> [[Char]] -> Map.Map Int [[Char]] -> Map.Map Int [Int] -> Int
getNextID iD tileRotated idToTile combinations = if null ls then (-1) else fst $ head ls
    where
        ls = filter (isToTheRight tileRotated . snd) prep
        prep = map (\x -> (x, idToTile Map.! x)) $ combinations Map.! iD

--Determine which ID comes next in the bottom row (x,dim)->(x+1,0)
getIDNextLine :: Int -> [[Char]] -> Map.Map Int [[Char]] -> Map.Map Int [Int] -> Int
getIDNextLine iD tileRotated idToTile combinations = if null ls then (-1) else fst $ head ls
    where
        ls = filter (isBelow tileRotated . snd) prep
        prep = map (\x -> (x, idToTile Map.! x)) $ combinations Map.! iD

--Helper function for genPicture, separated since initialization isn't trivial
genPicture' :: Map.Map Int [[Char]] -> Int -> Map.Map Int [Int] -> (Int,Int) -> Map.Map Int Int -> Map.Map (Int,Int) (Int,Int) -> Int -> Map.Map (Int,Int) (Int,Int)
genPicture' idToTile dim combinations coord@(x,y) idToRotation acc iD
    | y >= dim = genPicture' idToTile dim combinations (x+1,0) idToRotation acc continuationNextLine
    | x >= dim || iD == (-1) = acc
    | otherwise = genPicture' idToTile dim combinations (x,y+1) idToRotation' acc' nextID
        where
            continuationNextLine = getIDNextLine continuationID ((symmetries !! continuationRot) (idToTile Map.! continuationID)) idToTile combinations
            continuationRot = idToRotation Map.! continuationID
            continuationID = fst $ acc Map.! (x,0)
            tile = idToTile Map.! iD
            idToRotation' = Map.insert iD rotation idToRotation
            acc' = Map.insert coord (iD,rotation) acc
            neighbours = map (\x -> (x `Map.lookup` idToRotation, x)) $ filter (`Map.member` idToRotation) $ combinations Map.! iD
            rotation = findOneValidRotation tile (map (\(x,y) -> (x, (y,idToTile Map.! y))) neighbours)
            nextID = getNextID iD tileRotated idToTile combinations
            tileRotated = (symmetries !! rotation) tile

--Determines where and in what orientation the tiles should be placed
genPicture :: [Tile] -> Int -> Map.Map Int [Int] -> Map.Map (Int,Int) (Int,Int)
genPicture ls dim m = genPicture' idToTile dim m (0,1) idToRotation acc nextID
    where
        idToTile = Map.fromList ls
        rotation = findOneValidRotation (idToTile Map.! corner0) $ map (\(x,y) -> (x, (y,idToTile Map.! y))) $ map (\x -> (x `Map.lookup` idToRotation, x)) $ m Map.! corner0
        idToRotation = Map.singleton corner0 rotation
        acc = Map.singleton (0,0) (corner0,rotation)
        nextID = getNextID corner0 tileRotated idToTile m
        tileRotated = (symmetries !! rotation) (idToTile Map.! corner0)
        corner0 = head $ Map.keys $ Map.filter ((==2).length) m

joinLine :: [[[Char]]] -> [[Char]]
joinLine [] = []
joinLine xs = if null $ head xs then [] else (foldr1 (++) $ map head xs) : (joinLine $ map tail xs)

flatten :: Int -> [[[Char]]] -> [[Char]]
flatten _ [] = []
flatten dim ls = joinLine line ++ flatten dim rest
    where (line,rest) = splitAt dim ls

--Orders the tiles based on coordToIdRot, and prunes the edges
assemble :: Int -> Map.Map (Int,Int) (Int,Int) -> Map.Map Int [[Char]] -> (Int,Int) -> [[[Char]]] -> [[[Char]]]
assemble dim coordToIdRot idToTile coord@(x,y) acc
    | y >= dim = assemble dim coordToIdRot idToTile (x+1,0) acc
    | x >= dim = acc
    | otherwise = assemble dim coordToIdRot idToTile (x,y+1) acc'
    where
        acc' = prunedTile:acc
        prunedTile = init $ tail $ map init $ map tail tile
        tile = (symmetries !! rot) (idToTile Map.! id)
        (id,rot) = coordToIdRot Map.! coord

lineMatches :: String -> String -> Bool
lineMatches mons l = and $ zipWith (\m x -> (m == '#' && x == '#') || m == ' ') mons l

countInstances :: [String] -> Int
countInstances xs
    | (length $ head xs) < (length $ head monster) = 0
    | otherwise = if monsterFound then 1 + next else next
    where
        monsterFound = and $ zipWith lineMatches monster xs
        howManyDrop = if monsterFound then length $ head monster else 1
        next = countInstances $ map (drop howManyDrop) xs

countMonsters :: [[Char]] -> Int
countMonsters xs 
    | length xs < length monster = 0
    | otherwise = (countInstances $ take 3 xs) + countMonsters (drop 1 xs)

totalWaves image = if numMonsters == 0 then (-1) else count image - (numMonsters * (count monster))
    where
        count = length . filter (=='#') . foldr1 (++)
        numMonsters = countMonsters image

monster = ["                  # ","#    ##    ##    ###"," #  #  #  #  #  #   "]

star1 ls = product $ Map.keys $ Map.filter ((==2).length) $ genCombinations ls ls Map.empty

star2 ls = head $ filter (/=(-1)) $ map totalWaves configurations
    where
        configurations = map (\f -> f image) symmetries
        image = flatten dim assm
        assm = reverse $ assemble dim pic idToTile (0,0) []
        idToTile = Map.fromList ls
        pic = genPicture ls dim $ genCombinations ls ls Map.empty
        dim = (round . sqrt . fromIntegral . length) ls

main :: IO ()
main = do
  contents <- getContents
  let ls = map parse $ map lines $ splitOn "\n\n" contents

  putStrLn $ "Star 1: " ++ (show $ star1 ls)
  putStrLn $ "Star 2: " ++ (show $ star2 ls)
