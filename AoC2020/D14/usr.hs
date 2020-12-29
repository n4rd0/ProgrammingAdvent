import qualified Data.Map as Map
import Data.List.Split (splitOn)

type Bin = [Int]
data Program = Mask [Int] | Mem Int Bin deriving (Show)

pad :: Int -> a -> [a] -> [a]
pad upTo filler ls = replicate (upTo - length ls) filler ++ ls

padding = pad 36 0

parse :: [String] -> Program
parse [lft, rght] = if lft == "mask"
    then Mask $ map aux rght
    else Mem dir val
        where
            aux '0' = 0
            aux '1' = 1
            aux 'X' = -1
            dir = read $ tail $ dropWhile (/='[') (takeWhile (/=']') lft)
            val = reverse $ toBin $ read rght

bitwise :: Int -> Int -> Int
bitwise 0 _ = 0
bitwise 1 _ = 1
bitwise _ b = b

floating :: Int -> Int -> Int
floating 1 _ = 1
floating (-1) _ = -1
floating _ b = b

applyMask :: Program -> Bin -> Bin
applyMask (Mask arr) val = zipWith bitwise arr (padding val)
applyMask _ _ = error "Cant apply mask"

toLs :: [Program] -> [[Program]]
toLs ps = map reverse $ tail $ toLs' ps []
    where
        toLs' (m@(Mask _):rs) acc = acc : toLs' rs [m]
        toLs' (r:rs) acc = toLs' rs (r:acc)
        toLs' [] acc = [acc]

toBin :: Int -> Bin
toBin 0 = []
toBin n = (fromEnum $ n `rem` 2 == 1) : toBin (n `div` 2)

toDecimal :: Bin -> Int
toDecimal = foldl (\acc x -> 2*acc + fromEnum x) 0

genMemory :: [Program] -> Map.Map Int Bin
genMemory p = Map.fromList $ zip ls (repeat [0])
    where
        ls = foldr extractMems [] p
        extractMems (Mem dir _) acc = dir:acc
        extractMems _ acc = acc

--Reversing the input is much cheaper than reversing each of the possible outputs or
--doing acc ++ [x] (most expensive)
allCombinations :: [Int] -> [Bin]
allCombinations ls = diverge (reverse ls) []
    where
        diverge (x:xs) acc = if x == -1
            then diverge xs (0:acc) ++ diverge xs (1:acc)
            else diverge xs (x:acc)
        diverge _ acc = [acc]

applyFloatingMask :: Program -> Bin -> [Bin]
applyFloatingMask (Mask arr) val = allCombinations nval
    where nval = zipWith floating arr (padding val)
applyFloatingMask _ _ = error "Cant apply floating mask"

updateMemory :: ([Program] -> [(Int,Bin)]) -> Map.Map Int Bin -> [Program] -> Map.Map Int Bin
updateMemory f mem ps = Map.unionWith (\_ new -> new) mem (Map.fromList $ f ps)

program1 (mask:rs) = map (\(Mem dir val) -> (dir, applyMask mask val)) rs
program2 (mask:rs) = foldr (++) [] (map getDirectionValPairs rs)
    where
        getDirectionValPairs (Mem dir val) = zip (map toDecimal $ applyFloatingMask mask $ dirBin dir) (repeat val)
        dirBin = reverse . toBin

star program l = sum $ map toDecimal $ Map.elems newMem
    where
        ls = toLs l
        mem = genMemory l
        newMem = foldl program mem ls

star1 = star (updateMemory program1)
star2 = star (updateMemory program2)

main :: IO ()
main = do
  contents <- getContents
  let ls = lines contents
  let l = map (parse . splitOn " = ") ls

  putStrLn $ "Star 1: " ++ (show $ star1 l)
  putStrLn $ "Star 2: " ++ (show $ star2 l)
