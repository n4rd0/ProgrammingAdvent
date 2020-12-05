import qualified Data.Set as Set

type Seat = (Int, Int)

sId :: Seat -> Int
sId (row,col) = row*8+col

toBin :: [Int] -> Int
toBin x = foldl1 (\acc d -> acc*2 + d) x

seat :: String -> Seat
seat ss = (row', col')
  where
    (row,col) = splitAt 7 ss
    aux f = (\x -> if f x then 1 else 0)
    row' = toBin $ map (aux (=='B')) row
    col' = toBin $ map (aux (=='R')) col

star1 = maximum . map (sId . seat)
star2 ls = Set.elemAt 0 availableSeats
  where
    seats = map (sId . seat) ls
    availableSeats = (Set.fromList [(minimum seats)..(maximum seats)]) Set.\\ (Set.fromList seats)

main :: IO ()
main = do
  contents <- getContents
  let ls = lines contents
  putStrLn $ "Star 1: " ++ (show $ star1 ls)
  putStrLn $ "Star 2: " ++ (show $ star2 ls)