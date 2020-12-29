import qualified Data.Set as Set
import Data.Maybe (fromJust)

type Seat = (Int, Int)

sId :: Seat -> Int
sId (row,col) = row*8+col

toBin :: [Int] -> Int
toBin x = foldl1 (\acc d -> acc*2 + d) x

seat :: String -> Seat
seat ss = (row', col')
  where
    (row,col) = splitAt 7 ss
    row' = toBin $ map (fromEnum . (=='B')) row
    col' = toBin $ map (fromEnum . (=='R')) col

star1 = maximum . map (sId . seat)

star2 ls = head $ filter aux [mn..mx]
  where
    mn = fromJust $ Set.lookupGT 0 seats
    mx = fromJust $ Set.lookupLT (2^31) seats
    seats = Set.fromList $ map (sId . seat) ls
    aux x = not $ x `Set.member` seats

main :: IO ()
main = do
  contents <- getContents
  let ls = lines contents
  putStrLn $ "Star 1: " ++ (show $ star1 ls)
  putStrLn $ "Star 2: " ++ (show $ star2 ls)
