import qualified Data.Map as Map
import qualified Data.Set as Set
import Data.List.Split (splitOn)
import Data.List (intercalate, intersect)

type Food = ([String],[String])

swap (a,b) = (b,a)

invert m = Map.fromListWith (++) pairs
    where pairs = [(head vs,k) | (k,vs) <- Map.toList m]

parse :: String -> Food
parse ss = (words foods, words $ init $ filter (/=',') contains)
    where [foods,contains] = splitOn "(contains" ss

toMap :: Food -> Map.Map String [String]
toMap (foods, allergens) = Map.fromList $ zip foods $ repeat allergens

simplify :: Map.Map String [String] -> Map.Map String [String]
simplify m = if Set.size onlyOnce == Map.size m then m else simplify m'
    where
        m' = Map.map aux m
        aux ls = if length ls <= 1 then ls else filter (not . (flip Set.member) onlyOnce) ls
        onlyOnce = foldr1 Set.union $ map Set.fromList $ Map.elems $ Map.filter ((==1).length) m

genMaps :: [Food] -> (Map.Map String [String], Map.Map String String)
genMaps ls = (allergenToFood, foodToAllergen)
    where
        foodToAllergen = invert allergenToFood
        allergenToFood = simplify jointMap
        jointMap = foldr1 (Map.unionWith intersect) inverseMap
        inverseMap = map (toMap . swap) ls

star1 ls = length $ filter ((flip Set.member) cleanFoods) listOfIngredients
    where
        cleanFoods = Set.fromList $ Map.keys $ Map.filter null $ foldr1 Map.union $ map (Map.mapWithKey aux) possible
        aux k vs = if k `Map.member` foodToAllergen
            then [foodToAllergen Map.! k]
            else filter (not . (flip Map.member) allergenToFood) vs
        (allergenToFood,foodToAllergen) = genMaps ls
        listOfIngredients = foldr1 (++) $ map fst ls
        possible = map toMap ls

star2 ls = intercalate "," $ map (head . snd) $ Map.toAscList $ fst $ genMaps ls

main :: IO ()
main = do
  contents <- getContents
  let ls = map parse $ lines contents

  putStrLn $ "Star 1: " ++ (show $ star1 ls)
  putStrLn $ "Star 2: " ++ (star2 ls)
