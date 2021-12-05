import Data.Text (splitOn, pack, unpack)
import qualified Data.Map as M

type Bingo = (M.Map Int (Int,Int), M.Map Int Int, M.Map Int Int)

bingoSz = 5

parse :: String -> ([Int],[Bingo])
parse ls = (map (read . unpack) (splitOn (pack ",") nums), map toMap blocksCoords')
  where
    (nums:blocks) = splitOn (pack "\n\n") (pack ls)
    blocks' = map (map (map read . words . unpack) . splitOn (pack "\n")) blocks
    blocksCoords = map (map (\(x,y) -> zip3 (repeat x) [0..] y) . zip [0..]) blocks'
    blocksCoords' = map (foldr1 (++)) blocksCoords
    toMap m = (foldr (\(x,y,z) acc -> M.insert z (x,y) acc) M.empty m, colrowMap, colrowMap)
    colrowMap = M.fromList $ zip [0..bingoSz-1] (repeat bingoSz)

processNum :: Int -> Bingo -> (Bingo,Bool)
processNum num bingo@(board,row,col) = case M.lookup num board of
                    Just (x,y) -> ((M.delete num board, nrow, ncol), wrow || wcol)
                      where
                        (nrow,wrow) = update x row
                        (ncol,wcol) = update y col
                    Nothing -> (bingo,False)
  where
    update v m = case M.lookup v m of
      Just n -> if n == 1 then (m,True) else (M.adjust (+(-1)) v m,False)
      Nothing -> error "a"

finalScore (board,_,_) num = num * (sum $ M.keys board)

findFinishedBoard ((board,x):xs) = if x then Just board else findFinishedBoard xs
findFinishedBoard [] = Nothing

star1 (n:ns) bingos = case findFinishedBoard nxt of
        Just finishedBoard -> finalScore finishedBoard n
        Nothing -> star1 ns (fst $ unzip nxt)
  where
    nxt = map (processNum n) bingos

star2 ns [x] = star1 ns [x]
star2 (n:ns) bingos = star2 ns nbingos
  where
    (nbingos,_) = unzip $ filter (not.snd) $ map (processNum n) bingos

main :: IO ()
main = do
  contents <- getContents
  let (nums,bingos) = parse contents
  putStrLn $ "Star 1: " ++ (show $ star1 nums bingos)
  putStrLn $ "Star 2: " ++ (show $ star2 nums bingos)
