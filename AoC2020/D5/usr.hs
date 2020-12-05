import qualified Data.List as L

type Seat = (Int, Int)

sId :: Seat -> Int
sId (row,col) = row*8+col

toBin :: [Int] -> Int
toBin x = foldl1 (\acc d -> acc*2 + d) x

seat :: String -> Seat
seat ss = (row', col')
  where
    (row,col) = splitAt 7 ss
    row' = toBin $ map (\x-> if x == 'B' then 1 else 0) row
    col' = toBin $ map (\x-> if x == 'R' then 1 else 0) col

star1 = maximum . map (sId . seat)
star2 ls = head availableSeats
  where
    seats = map (sId . seat) ls
    availableSeats = [(minimum seats)..(maximum seats)] L.\\ seats

main :: IO ()
main = do
  contents <- getContents
  let ls = lines contents
  putStrLn $ "Star 1: " ++ (show $ star1 ls)
  putStrLn $ "Star 2: " ++ (show $ star2 ls)